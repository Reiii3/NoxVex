LOG_FILE="/data/local/tmp/lsvc_server.log"
GAMELIST_FILE="/data/local/tmp/game.txt"
GAME_LIST=$(cat "$GAMELIST_FILE")

# ----------------- LOG -----------------
log() {
    echo "[ $(date '+%H:%M:%S') ] $1"
}

taskset -p ff $$ >/dev/null 2>&1
renice -n 19 -p $$ >/dev/null 2>&1
ionice -c 3 -p $$ >/dev/null 2>&1
iorenice $$ 7 idle >/dev/null 2>&1

# ------------------------------------------------
# ----------------- CORE SERVICE -----------------
# ------------------------------------------------
game_profiles_server() {
  settings put global limetsu_engine_version 2.6
  settings put global limetsu_engine_enable lsvc_server.pid
  
  last_pkg="init"
  last_status="off"
  current_target=""
  CPU_INFO=$(cat /proc/cpuinfo)

  if echo "$CPU_INFO" | grep -q "MT"; then SOC="MTK"; fi
  if echo "$CPU_INFO" | grep -q "Qualcomm"; then SOC="QCOM"; fi
  if [ "$(getprop ro.soc.manufacturer)" = "Spreadtrum" ]; then SOC="UNISOC"; fi

  echo "[SERVICE] Celestial Game Optimizer Started" >> "$LOG_FILE"

  while true; do

    screen_prop=$(getprop debug.tracing.screen_state)
    if { [ -n "$screen_prop" ] && [ "$screen_prop" != "2" ]; } || \
       ! dumpsys display | grep -q "mScreenState=ON"; then
        sleep 10 && continue
    fi

    pkg=$(cmd activity stack list | grep "topActivity" | grep -m1 "visible=true" | awk -F'[: ]+' '{print $3}' | cut -d'/' -f1)
    [ -z "$pkg" ] && pkg=$(cmd activity stack list | grep "topActivity" | head -n1 | awk -F'[: ]+' '{print $3}' | cut -d'/' -f1)

    is_in_gamelist=$(echo "$GAME_LIST" | grep -qw "$pkg" && echo "yes" || echo "no")

    if [ "$pkg" = "$last_pkg" ] && [ "$is_in_gamelist" = "no" ] && [ "$last_status" = "off" ]; then
        sleep 5 && continue
    fi

    last_pkg="$pkg"
    pkg_full="$pkg"
    target="$pkg_full"
    [ "$pkg_full" = "com.mobile.legends" ] && target="com.mobile.legends:UnityKillsMe"

    # -------- GAME DETECTED ----------
    if echo "$GAME_LIST" | grep -qw "$pkg_full"; then
        if [ "$last_status" != "game" ]; then
            current_game_pkg="$pkg_full"
            
            # PERFORMANCE MODE
            for path in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
                echo "performance" > "$path" 2>/dev/null
            done
            cmd power set-adaptive-power-saver-enabled false
            cmd power set-mode 0
            cmd thermalservice override-status 0
            cmd activity memory-factor set 0
            setprop debug.egl.hw 1
            setprop debug.sf.set_idle_timer_ms 0

            pid=$(pidof "$pkg_full")
            for t in /proc/$pid/task/*; do
              tid=${t##*/}
              settaskprofile "$tid" "CPUSET_SP_TOP_APP"
              settaskprofile "$tid" "SCHED_SP_TOP_APP"
            done

            cmd game set --mode 2 --fps "$fps" "$pkg_full"
            cmd game mode 2 "$pkg_full"
            cmd ufw settings set-boost-proc "$pkg_full" 1 true
            cmd ufw settings set-io-feature 2 "$pkg_full" true

            get_bg_apps | while read -r app; do
                am force-stop "$app"
            done

            # SOC SPECIFIC SETTINGS
            case "$SOC" in
                "MTK")
                    setprop debug.mediatek.appgamepq_compress 1
                    setprop debug.mediatek.disp_decompress 1
                    setprop debug.mediatek.appgamepq 1
                    setprop debug.mediatek.game_pq_enable 1
                    ;;
                "QCOM")
                    setprop debug.qc.hardware true
                    setprop debug.gralloc.gfx_ubwc_disable 0
                    ;;
                "UNISOC")
                    resetprop -n persist.sys.unisoc_game_boost true
                    ;;
            esac

            # Notification
            if command -v su >/dev/null 2>&1; then
                su -lp 2000 -c "cmd notification post -S bigtext -t 'Celestial-Game-Opt' tag 'Status : $pkg_full | Optimized!'" >/dev/null 2>&1
            else
                am start -a AxManager.TOAST -e text "$pkg_full | Optimized!" >/dev/null 2>&1
            fi

            last_status="game"
            current_target="$target"
        fi

    else
        # -------- GAME CLOSED ----------
        if [ "$last_status" != "off" ]; then
            if [ -n "$current_target" ]; then
                target_to_reset="$current_game_pkg"
                limetsu --cache_cleaner
                for path in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
                    echo "schedutil" > "$path" 2>/dev/null || echo "interactive" > "$path" 2>/dev/null
                done

                pid=$(pidof "$target_to_reset")
                for t in /proc/$pid/task/*; do
                  tid=${t##*/}
                  settaskprofile "$tid" "CPUSET_SP_BACKGROUND"
                  settaskprofile "$tid" "SCHED_SP_BACKGROUND"
                done

                cmd power set-adaptive-power-saver-enabled true
                cmd thermalservice reset
                cmd activity memory-factor set 1
                setprop debug.egl.hw 0
                setprop debug.sf.set_idle_timer_ms 2000

                cmd game reset "$target_to_reset"
                cmd ufw settings set-boost-proc "$target_to_reset" 1 false
                cmd ufw settings set-io-feature 2 "$target_to_reset" false

                case "$SOC" in
                    "MTK")
                        setprop debug.mediatek.appgamepq_compress 0
                        setprop debug.mediatek.disp_decompress 0
                        setprop debug.mediatek.appgamepq 0
                        setprop debug.mediatek.game_pq_enable 0
                        ;;
                    "QCOM")
                        setprop debug.qc.hardware false
                        setprop debug.gralloc.gfx_ubwc_disable 1
                        ;;
                    "UNISOC")
                        resetprop -n persist.sys.unisoc_game_boost false
                        ;;
                esac
            fi

            if command -v su >/dev/null 2>&1; then
                su -lp 2000 -c "cmd notification post -S bigtext -t 'Celestial-Game-Opt' tag 'Status : Game Closed!'" >/dev/null 2>&1
            else
                am start -a AxManager.TOAST -e text "Game Closed" >/dev/null 2>&1
            fi

            last_status="off"
            current_target=""
            [ -f "$GAMELIST_FILE" ] && GAME_LIST=$(cat "$GAMELIST_FILE")
        fi
    fi
    limetsu --dex2ot
    limetsu --downscale
    sleep 5
  done
}

game_profiles_server
