IDLE_TIME=5
gamerun=""
notif_run=""

test_logic() {
  time=$(date "+%d-%m-%Y %H:%M")
   game=$(settings get global package_osiris)
   detected_apps=$(dumpsys window | grep "Window #" | grep WindowStateAnimator | grep -v "Window #0" | grep -Eo "$game")
    render_detected=$(getprop debug.hwui.renderer)
   if [[  -n "$detected_apps" ]]; then
        if [[ "$gamerun" != "running" ]] && [[ "$render_detected" != "skiavk" ]]; then
           if [[ "$notif_run" != "run" ]]; then
              cmd notification post -S bigtext -t '️Smart System🔄' -i file:///sdcard/VortexModules/NOXG/vmods.png -I file:///sdcard/VortexModules/NOXG/vmods.png "noxg_engine_mode" "Game Mode : ON
              Game Mode On In Time : $time" >/dev/null 2>&1
              smartSystemRun
              notif_run="run"
           fi
          gamerun="running"
        fi
    else
        if [[ "$gamerun" != "stopped" ]]; then
           if [[ "$notif_run" != "stop" ]]; then
              cmd notification post -S bigtext -t '️Smart System🔄' -i file:///sdcard/VortexModules/NOXG/vmods.png -I file:///sdcard/VortexModules/NOXG/vmods.png "noxg_engine_mode" "Game Mode : OFF
              Game Mode Off In Time : $time" >/dev/null 2>&1
              smartSystemRmv
              notif_run="stop"
           fi
          gamerun="stopped"
        fi
   fi
}

while true; do
    test_logic
    sleep "$IDLE_TIME"
done