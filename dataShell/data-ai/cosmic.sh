# PRO LICENSE
# BUILD IN 12/3/2026

service_server() {
    LOG_FILE="/data/local/tmp/cosmic.log"
    IDLE_TIME=5
    running_mode_detection=""
    
    settings put global cosmic_engine_version 1.1.5_BETA
    settings put global cosmic_engine_enable cosmic_server.pid
    
    echo "[Service] COSMIC Started at $(date)" >> "$LOG_FILE"
    
    game_mode() {
        settings put global updatable_driver_production_opt_in_apps "$detected_apps"
        settings put global cosmic_profile_enable Game-Mode
        
        # Source By CmdTweak @HoyoSlave
        cmd power set-adaptive-power-saver-enabled false
        cmd power set-fixed-performance-mode-enabled true
        cmd power set-mode 0
    
        # From lykafka module
        setprop debug.renderengine.backend skiavkthreaded
        am force-stop com.google.android.gms
        cmd activity force-stop com.xiaomi.joyose
        dumpsys deviceidle whitelist -com.google.android.gms
        cmd thermalservice override-status 0
        setprop debug.composition.type mdp
        cmd activity memory-factor set 0
        
        settings put global power_check_max_cpu_1 310
        settings put global power_check_max_cpu_2 370
        settings put global power_check_max_cpu_3 140
        settings put global power_check_max_cpu_4 170
        setprop debug.hwui.target_power_time_percent 210
        setprop debug.hwui.target_cpu_time_percent 210
        setprop debug.hwui.target_gpu_time_percent 210
        cmd power set-mode 0
        cmd thermalservice override-status 0
        setprop debug.egl.hw 1
        setprop debug.sf.hw 1
        setprop debug.hwui.trace_gpu_resources false
        setprop debug.egl.force_msaa false
        setprop debug.performance.tuning 1
        cmd settings put system air_motion_engine 0
        cmd settings put system master_motion 0
        cmd settings put system motion_engine 0
        cmd shortcut reset-all-throttling
        
        settings put global battery_saver_adaptive_constants advertise_is_enabled=false,enable_datasaver=true,disable_launch_boost=false,disable_vibration=true,disable_animation=true,disable_soundtrigger=true,location_mode=2,gps_mode=2,enable_brightness_adjustment=false,force_all_apps_standby=false,force_background_check=true,disable_optional_sensors=true,enable_quick_doze=true

        settings put global battery_saver_constants advertise_is_enabled=false,enable_datasaver=true,disable_launch_boost=false,disable_vibration=true,disable_animation=true,disable_soundtrigger=true,location_mode=2,gps_mode=2,enable_brightness_adjustment=false,force_all_apps_standby=false,force_background_check=true,disable_optional_sensors=true,enable_quick_doze=true
        
        settings put global battery_saver_device_specific_constants advertise_is_enabled=false,enable_datasaver=true,disable_launch_boost=false,disable_vibration=true,disable_animation=true,disable_soundtrigger=true,location_mode=2,gps_mode=2,enable_brightness_adjustment=false,force_all_apps_standby=false,force_background_check=true,disable_optional_sensors=true,enable_quick_doze=true
    
        # Oppo Battery High Performance
        if [[ $(settings get system high_performance_mode_on 2>/dev/null) ]]; then
            cmd settings put system high_performance_mode_on 1
            cmd settings put system high_performance_mode_on_when_shutdown 1
        fi
        
        if [ $(settings get global cosmic_perf_opt_enable) = "true" ]; then
            settings put --user 0 system high_performance_mode_on 1
            settings put --user 0 system performance_mode_enable 1
            settings put system power_save_type_performance 0
            settings put system power_mode high
            cmd settings put global security_center_pc_save_mode_data '{"a":0,"b":-1,"c":-1,"d":-1}'
            cmd settings put system POWER_BALANCED_MODE_OPEN 0
            cmd settings put system POWER_PERFORMANCE_MODE_OPEN 1
            cmd settings put system POWER_SAVE_MODE_OPEN 0
            cmd settings put system POWER_SAVE_PRE_HIDE_MODE performance
            cmd settings put system speed_mode 1
        fi
        
        if [ $(settings get global cosmic_adaptive_power_enable) == "true" ]; then
            settings put global adaptive_battery_management_enabled 0 >/dev/null 2>&1
            cmd power set-mode 0
            cmd power set-adaptive-power-saver-enabled false
            cmd deviceidle pre-idle-factor 0
            settings put global reduce_motion 1
        fi
        
        if [ $(settings get global cosmic_dnd_enable) == "true" ]; then
            settings put global zen_mode 1
        fi
    }
    
    saver_mode() {
        settings delete global updatable_driver_production_opt_in >/dev/null 2>&1
        settings put global cosmic_profile_enable Power-Saver
    
        cmd power set-adaptive-power-saver-enabled true
        cmd power set-fixed-performance-mode-enabled false
        dumpsys deviceidle whitelist +com.google.android.gms
        setprop debug.composition.type c2d
        
        settings put global power_check_max_cpu_1 110
        settings put global power_check_max_cpu_2 170
        settings put global power_check_max_cpu_3 110
        settings put global power_check_max_cpu_4 120
        setprop debug.hwui.target_power_time_percent 110
        setprop debug.hwui.target_cpu_time_percent 90
        setprop debug.hwui.target_gpu_time_percent 80
        cmd power set-mode 1
        cmd thermalservice override-status 1
        setprop debug.egl.hw 0
        setprop debug.sf.hw 0
        setprop debug.hwui.trace_gpu_resources true
        setprop debug.egl.force_msaa true
        setprop debug.performance.tuning 0
        cmd settings put system air_motion_engine 1
        cmd settings put system master_motion 1
        cmd settings put system motion_engine 01
        cmd shortcut reset-all-throttling
    
        if [[ $(settings get system high_performance_mode_on 2>/dev/null) ]]; then
            cmd settings put system high_performance_mode_on 0
            cmd settings put system high_performance_mode_on_when_shutdown 0
        fi
        
        if [ $(settings get global cosmic_perf_opt_enable) = "true" ]; then
            settings put --user 0 system high_performance_mode_on 0
            settings put --user 0 system performance_mode_enable 0
            settings put system POWER_PERFORMANCE_MODE_OPEN 0
            settings put system power_save_type_performance 1
            settings put system power_mode high
        fi
        
        if [ $(settings get global cosmic_adaptive_power_enable) == "true" ]; then
            settings put global adaptive_battery_management_enabled 0 >/dev/null 2>&1
            cmd power set-mode 0
            cmd power set-adaptive-power-saver-enabled false
            cmd deviceidle pre-idle-factor 0
            settings put global reduce_motion 1
        fi
        
        if [ $(settings get global cosmic_dnd_enable) == "true" ]; then
            settings put global zen_mode 0
        fi
    }
    
    install_background() {
        apps="
            com.facebook.katana
            com.zhiliaoapp.musically
            com.ss.android.ugc.trill
            com.instagram.android
            com.facebook.orca
            com.snapchat.android
            com.twitter.android
            org.telegram.messenger
            org.telegram.plus
            org.thunderdog.challegram
            com.whatsapp.w4b
            com.ss.android.ugc.trill
            com.openai.chatgpt
            com.coloros.movetosdcard
            com.google.android.apps.photos
            com.google.android.youtube
            com.google.android.apps.youtube.music
            com.google.android.apps.docs
            com.google.android.apps.maps
            com.facebook.katana
            com.facebook.orca
            com.instagram.android
            com.snapchat.android
            com.whatsapp
            com.zhiliaoapp.musically
            com.ss.android.article.news
            com.netflix.mediaclient
            com.spotify.music
            com.touchtype.swiftkey
            com.google.android.as
            com.google.android.ext.services
            com.google.android.providers.media.module
            com.coloros.movetosdcard
            com.oplus.statistics.rom
            com.coloros.smartsidebar:ui
            com.coloros.smartsidebar:edgepanel
            com.coloros.alarmclock:clockWidget
            com.coloros.weather.service
            com.oplus.romupdate
            com.oplus.deepthinker
            com.oplus.gesture
            com.heytap.accessory
            com.oplus.nas
        "
        
        ###############################################
        # PART 1 — NON-SYSTEM PACKAGES
        ###############################################
        
        for a in $apps; do
            # Background Restriction
            am set-inactive --user 0 $a true
            am set-bg-restriction-level --user 0 $a hibernation
            am set-standby-bucket $a rare
            am service-restart-backoff disable $a
            am set-foreground-service-delegate --user 0 $a stop
        
            # APP OPS LIMIT
            appops set $a RUN_IN_BACKGROUND ignore
            appops set $a RUN_ANY_IN_BACKGROUND ignore
            appops set $a WAKE_LOCK deny
            appops set $a START_IN_BACKGROUND ignore
            appops set $a START_FOREGROUND ignore
            appops set $a INSTANT_APP_START_FOREGROUND ignore
            appops set $a GET_USAGE_STATS ignore
            appops set $a RUN_USER_INITIATED_JOBS ignore
            appops set $a MONITOR_LOCATION ignore
            appops set $a MONITOR_HIGH_POWER_LOCATION ignore
            appops set $a SCHEDULE_EXACT_ALARM ignore
            appops set $a FINE_LOCATION ignore
        
            # Dropbox / Logging
            cmd dropbox add-low-priority $a
            pm log-visibility $a --disable
        done
        
        ###############################################
        # PART 4 — ADDITIONAL DEVICE_CONFIG OPTIMIZER
        ###############################################
        
        # Matikan wakeup heavy apps
        device_config set activity_manager max_cached_processes 8
        device_config set activity_manager max_phantom_processes 16
        device_config set activity_manager bg_start_timeout 5000
        
    }
    
    uninstall_bg() {
        apps="
            com.facebook.katana
            com.zhiliaoapp.musically
            com.ss.android.ugc.trill
            com.instagram.android
            com.facebook.orca
            com.snapchat.android
            com.twitter.android
            org.telegram.messenger
            org.telegram.plus
            org.thunderdog.challegram
            com.whatsapp.w4b
            com.ss.android.ugc.trill
            com.openai.chatgpt
            com.coloros.movetosdcard
            com.google.android.apps.photos
            com.google.android.youtube
            com.google.android.apps.youtube.music
            com.google.android.apps.docs
            com.google.android.apps.maps
            com.facebook.katana
            com.facebook.orca
            com.instagram.android
            com.snapchat.android
            com.whatsapp
            com.zhiliaoapp.musically
            com.ss.android.article.news
            com.netflix.mediaclient
            com.spotify.music
            com.touchtype.swiftkey
            com.google.android.as
            com.google.android.ext.services
            com.google.android.providers.media.module
            com.coloros.movetosdcard
            com.oplus.statistics.rom
            com.coloros.smartsidebar:ui
            com.coloros.smartsidebar:edgepanel
            com.coloros.alarmclock:clockWidget
            com.coloros.weather.service
            com.oplus.romupdate
            com.oplus.deepthinker
            com.oplus.gesture
            com.heytap.accessory
            com.oplus.nas
        "
        
        ###############################################
        # UNDO — APP OPS
        ###############################################
        
        for pkg in $apps; do
            # Reset semua app ops ke default
            appops reset $pkg
        done
        
        ###############################################
        # UNDO — DROPBOX + LOGGING
        ###############################################
        
        for pkg in $apps; do
            pm log-visibility $pkg --enable
        done
        
        ###############################################
        # UNDO — DEVICE_CONFIG
        ###############################################
        
        device_config delete activity_manager max_cached_processes
        device_config delete activity_manager max_phantom_processes
        device_config delete activity_manager bg_start_timeout
        
    }
    
    notif_run() {
        cmd=$(echo "Profile Status : [ Game Mode ]\n───────────────────────\nCosmic AI Engine | Enjoy Your Game\nRunning Service : $timer")
        cmd notification post -S bigtext -t 'Cosmic AI Engine' -i "file:///storage/emulated/0/Android/media/.cosmic/notif.png" -I "file:///storage/emulated/0/Android/media/.cosmic/baner.png" \
        "noxg_engine_mode" \
        "$cmd" \
        >/dev/null 2>&1
    }
    
    
    notif_force() {
        cmd=$(echo "Profile Status : [ Game Force Mode ]\n───────────────────────\nCosmic AI Engine | Enjoy Your Game And Battery Is Low\nRunning Service : $timer")
        cmd notification post -S bigtext -t 'Cosmic AI Engine' -i "file:///storage/emulated/0/Android/media/.cosmic/notif.png" -I "file:///storage/emulated/0/Android/media/.cosmic/baner.png" \
        "noxg_engine_mode" \
        "$cmd" \
        >/dev/null 2>&1
    }
    
    
    notif_stop() {
        cmd=$(echo "Profile Status : [ Saver Mode ]\n───────────────────────\nCosmic AI Engine | Enjoy Efficiency Battery\nRunning Service : $timer")
        cmd notification post -S bigtext -t 'Cosmic AI Engine' -i "file:///storage/emulated/0/Android/media/.cosmic/notif.png" -I "file:///storage/emulated/0/Android/media/.cosmic/baner.png" \
        "noxg_engine_mode" \
        "$cmd" \
        >/dev/null 2>&1
    }
    
    boost_pkg() {
    pkg=$1
    PID=$(pidof $pkg)

    if [ -z "$PID" ]; then
        PID=$(ps -A | grep -w $pkg | head -n1 | awk '{print $2}')
    fi

    if [ -n "$PID" ]; then
        echo "[+] Boosting $pkg (PID: $PID)"
        taskset -p ff $PID >/dev/null 2>&1
        renice -n -20 -p $PID >/dev/null 2>&1
        echo "[+] Done"
    else
        echo "[!] PID not found → App tidak berjalan"
    fi
    }
    
    
    havy_force_stopped() {
        apps="
            com.facebook.katana
            com.zhiliaoapp.musically
            com.ss.android.ugc.trill
            com.instagram.android
            com.facebook.orca
            com.snapchat.android
            com.twitter.android
            org.telegram.messenger
            org.telegram.plus
            org.thunderdog.challegram
            com.whatsapp
            com.whatsapp.w4b
            com.openai.chatgpt
        "
    
        for a in $apps; do
            am force-stop $a >/dev/null 2>&1
            am kill $a
        done
    
    }

    cache_cleaner() {
        cmd notification post -S bigtext -t 'Cosmic AI Engine' \
        "noxg_engine_mode" \
        "Cosmic AI Engine Cache Cleaner - Midnight Optimization" \
        >/dev/null 2>&1
    
        find /data/data/*/cache/* -delete 2>/dev/null
        find /data/data/*/code_cache/* -delete 2>/dev/null
        find /data/user_de/*/*/cache/* -delete 2>/dev/null
        find /data/user_de/*/*/code_cache/* -delete 2>/dev/null
        find /sdcard/Android/data/*/cache/* -delete 2>/dev/null
    
        pm trim-caches 1024G >/dev/null 2>&1
    }
    
    while true; do
        GAME_LIST=$(cat /data/local/tmp/game.txt)
        timer=$(TZ="Asia/Jakarta" date +"%H:%M")
        persentase_battrey=$(dumpsys battery | grep level | cut -f2 -d:)
        detected_apps=$(dumpsys activity processes | grep top-activity | cut -d ':' -f4 | cut -d '/' -f1 | head -n 1)
        render_detected=$(getprop debug.hwui.renderer)
        getHavyEnable=$(settings get global cosmic_havy_apps_enable)
        temp_limit=$(settings get global cosmic_temp_limit_enable)
        fos_hdr_disabler=$(settings get global cosmic_hdr_enable)
        bypass_high_temp=$(settings get global cosmic_bypas_high_enable)
        fos_hdr_disabler=$(settings get global cosmic_hdr_disabler_enable)
        cos_temp_protect=$(settings get global cosmic_temp_protect_enable)
        
        list_game=$(echo "$GAME_LIST" | tr ',' '\n')

        notif_state="run"

        # --- Midnight Action ---
        if [[ "$timer" == "00:00" ]]; then
            cache_cleaner >/dev/null 2>&1
            gms_tweak

            sorted=$(echo "$GAME_LIST" | tr ',' '\n' | sort)
            for package in $sorted; do
                cmd package compile -m speed -f "$package" 2>/dev/null
            done
        fi

        # -------- GAME DETECT ----------
        if echo "$list_game" | grep -qw "$detected_apps"; then
            gameDetected="true"

            if [[ $persentase_battrey -ge 30 ]]; then
                mode_now="game-mode"
            elif [[ $persentase_battrey -ge 20 ]]; then
                mode_now="force-mode"
            else
                mode_now="force-saver-mode"
            fi

        else
            gameDetected="false"
            mode_now="saver-mode"
        fi

        # -------- MODE SWITCH ----------
        if [[ "$mode_now" != "$running_mode_detection" ]]; then
            notif_state="run"
        fi

        if [[ "$gameDetected" == "true" ]]; then
            # GAME MODE
            if [[ $persentase_battrey -ge 30 ]]; then
                if [[ "$render_detected" != "skiavk" && "$notif_state" == "run" ]]; then
                    notif_run
                    setprop debug.hwui.renderer skiavk
                    game_mode
                    cosmic --driver $detected_apps
                    cosmic --game_compiler
                    boost_pkg $detected_apps
                    running_mode_detection="game-mode"
                    notif_state="stop"
                    if [ "$temp_limit" = "true" ]; then
                        settings put --user 0 system rt_enable_templimit false
                    fi
                    if [ "$bypass_high_temp" = "true" ]; then
                        settings put --user 0 system tran_temp_battery_warning 0
                        settings put --user 0 system tran_default_temperature_index 0
                    fi
                    if [ "$fos_hdr_disabler" = "true" ]; then
                        settings put global user_disable_hdr_formats 1
                    fi
                    if [ "$cos_temp_protect" = "true" ]; then
                        settings put secure oppo_high_temperature_protection_status 0
                        settings put system oplus_settings_hightemp_protect 0
                    fi
                    if [ $getHavyEnable == "true" ]; then
                        havy_force_stopped
                        install_background
                    fi
                fi
            # FORCE MODE
            elif [[ $persentase_battrey -ge 20 ]]; then
                if [[ "$notif_state" == "run" ]]; then
                    notif_force
                    setprop debug.hwui.renderer skiavk
                    game_mode
                    cosmic --driver $detected_apps
                    cosmic --game_compiler
                    boost_pkg $detected_apps
                    running_mode_detection="force-mode"
                    notif_state="stop"
                    if [ "$temp_limit" = "true" ]; then
                        settings put --user 0 system rt_enable_templimit false
                    fi
                    if [ "$bypass_high_temp" = "true" ]; then
                        settings put --user 0 system tran_temp_battery_warning 0
                        settings put --user 0 system tran_default_temperature_index 0
                    fi
                    if [ "$fos_hdr_disabler" = "true" ]; then
                        settings put global user_disable_hdr_formats 1
                    fi
                    if [ "$cos_temp_protect" = "true" ]; then
                        settings put secure oppo_high_temperature_protection_status 0
                        settings put system oplus_settings_hightemp_protect 0
                    fi
                    if [ $getHavyEnable == "true" ]; then
                        install_background
                        havy_force_stopped
                    fi
                fi
            # FORCE-SAVER MODE
            else
                if [[ "$notif_state" == "run" ]]; then
                    notif_stop
                    saver_mode
                    running_mode_detection="force-saver-mode"
                    notif_state="stop"
                    if [ $getHavyEnable == "true" ]; then
                        havy_force_stopped
                        uninstall_bg
                    fi
                fi
            fi
        else
            # SAVER MODE
            if [[ "$render_detected" != "opengl" ]]; then
                setprop debug.hwui.renderer opengl
                setprop debug.renderengine.backend vulkan
                notif_stop
                saver_mode
                uninstall_bg
                running_mode_detection="saver-mode"
                notif_state="stop"
            fi
            cosmic --cache_cleaner >/dev/null 2>&1
        fi
        
        cosmic --dex2ot

        sleep "$IDLE_TIME"
    done
}

service_server
