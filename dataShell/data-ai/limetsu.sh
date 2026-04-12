#!/bin/bash

service_server() {
    LOG_FILE="/data/local/tmp/cosmic.log"
    IDLE_TIME=1.7
    running_mode_detection=""
    profile_detection=""
    profile_state="run"
    
    settings put global cosmic_engine_version 1.6.6_GEN
    settings put global cosmic_engine_enable limet_server.pid
    
    echo "[Service] cosmic Started at $(date)" >> "$LOG_FILE"
    game_mode() {
        [ -n "$detected_apps" ] && \
        settings put global updatable_driver_production_opt_in_apps "$detected_apps"
    
        # Source By CmdTweak @HoyoSlave
        cmd power set-adaptive-power-saver-enabled false
        cmd power set-fixed-performance-mode-enabled true
        cmd power set-mode 0
    
        # From lykafka module
        setprop debug.hwui.renderer skiavkthreaded
        setprop debug.renderengine.backend skiavkthreaded
        am force-stop com.google.android.gms
        cmd activity force-stop com.xiaomi.joyose
        dumpsys deviceidle whitelist -com.google.android.gms
        cmd thermalservice override-status 0
        setprop debug.composition.type mdp
        cmd activity memory-factor set 0
        setprop debug.egl.hw 1
        setprop debug.sf.set_idle_timer_ms 0
        
        cmd power set-fixed-performance-mode-enabled true
        cmd power set-adaptive-power-saver-enabled false
        cmd power set-mode 0
        cmd thermalservice override-status 0
        setprop debug.egl.hw 1
        setprop debug.sf.hw 1
        setprop debug.hwui.trace_gpu_resources false
        setprop debug.egl.force_msaa false
        setprop debug.performance.tuning 1
        md settings put system air_motion_engine 0
        cmd settings put system master_motion 0
        cmd settings put system motion_engine 0
        cmd shortcut reset-all-throttling
        cmd settings put global updatable_driver_all_apps 1
        cmd settings put global security_center_pc_save_mode_data '{"a":0,"b":-1,"c":-1,"d":-1}'
        cmd settings put system POWER_BALANCED_MODE_OPEN 0
        cmd settings put system POWER_PERFORMANCE_MODE_OPEN 1
        cmd settings put system POWER_SAVE_MODE_OPEN 0
        cmd settings put system POWER_SAVE_PRE_HIDE_MODE performance
        cmd settings put system speed_mode 1
        
        # CPU Reducer
        settings put global battery_saver_adaptive_constants advertise_is_enabled=false,enable_datasaver=true,disable_launch_boost=false,disable_vibration=true,disable_animation=true,disable_soundtrigger=true,location_mode=2,gps_mode=2,enable_brightness_adjustment=false,force_all_apps_standby=false,force_background_check=true,disable_optional_sensors=true,enable_quick_doze=true
        settings put global battery_saver_constants advertise_is_enabled=false,enable_datasaver=true,disable_launch_boost=false,disable_vibration=true,disable_animation=true,disable_soundtrigger=true,location_mode=2,gps_mode=2,enable_brightness_adjustment=false,force_all_apps_standby=false,force_background_check=true,disable_optional_sensors=true,enable_quick_doze=true
        settings put global battery_saver_device_specific_constants advertise_is_enabled=false,enable_datasaver=true,disable_launch_boost=false,disable_vibration=true,disable_animation=true,disable_soundtrigger=true,location_mode=2,gps_mode=2,enable_brightness_adjustment=false,force_all_apps_standby=false,force_background_check=true,disable_optional_sensors=true,enable_quick_doze=true
    }

    balance_mode() {
        # PROFILE STATUS
        settings put global cosmic_profile_enable Balance-Mode

        # SETPROP (lebih ringan)
        setprop debug.hwui.renderer skiagl
        setprop debug.renderengine.backend skiagl
        setprop debug.sf.hw 1
        setprop debug.egl.hw 1
        setprop debug.hwui.trace_gpu_resources false
        setprop debug.performance.tuning 1

        # CMD (aman & stabil)
        cmd power set-fixed-performance-mode-enabled false
        cmd settings put system air_motion_engine 0
        cmd settings put system master_motion 0
        cmd power set-mode 0

        # GPU Driver (aman)
        cmd settings put global angle_gl_driver_all_angle 1
        cmd settings put global game_driver_all_apps 1
        cmd settings put global updatable_driver_all_apps 1

        # THERMAL (tidak penuh bypass, hanya stabil)
        cmd thermalservice override-status 1

        # MEMORY FACTOR (medium)
        cmd activity memory-factor set 1

        # BALANCE DEVICE CONFIG
        cmd device_config put activity_manager max_cached_processes 4096
        cmd device_config put activity_manager max_phantom_processes 4096
        cmd device_config put activity_manager max_empty_time_millis 120000
        cmd device_config put activity_manager bg_fgs_monitor_enabled true
        cmd device_config put activity_manager bg_broadcast_monitor_enabled true
        cmd device_config put activity_manager_native_boot modern_queue_enabled true
    }
    
    saver_mode() {
        settings delete global updatable_driver_production_opt_in >/dev/null 2>&1
    
        cmd power set-adaptive-power-saver-enabled true
        cmd power set-fixed-performance-mode-enabled false
        cmd powrr set-mode 1
        dumpsys deviceidle whitelist +com.google.android.gms
        setprop debug.composition.type c2d
        
        cmd power set-fixed-performance-mode-enabled true
        cmd power set-adaptive-power-saver-enabled false
        cmd power set-mode 0
        cmd thermalservice override-status 0
        setprop debug.egl.hw 1
        setprop debug.sf.hw 1
        setprop debug.hwui.trace_gpu_resources false
        setprop debug.egl.force_msaa false
        setprop debug.performance.tuning 1
        md settings put system air_motion_engine 0
        cmd settings put system master_motion 0
        cmd settings put system motion_engine 0
        cmd shortcut reset-all-throttling
        
        settings put global battery_saver_adaptive_constants ""
        settings put global battery_saver_constants ""
        settings put global battery_saver_device_specific_constants ""
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

        installed=$(pm list packages)

        for a in $apps; do
            echo "$installed" | grep -q "$a" || continue
            am force-stop "$a" >/dev/null 2>&1
            am kill "$a" >/dev/null 2>&1
            cmd dropbox add-low-priority "$a"
        done
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
        
        installed=$(pm list packages)

        for a in $apps; do
            echo "$installed" | grep -q "$a" || continue

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
        
        installed=$(pm list packages)

        for pkg in $apps; do
            echo "$installed" | grep -q "$a" || continue
            # Reset semua app ops ke default
            appops reset $pkg
        done
        
        ###############################################
        # UNDO — DROPBOX + LOGGING
        ###############################################
        
        for pkg in $apps; do
            echo "$installed" | grep -q "$a" || continue
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
        cmd=$(echo "Mode Status : [ Game Mode ]\nLimetsU AI Engine | [Enjoy Your Game]\n\nCosmic Injection Engine\nRunning Service : $timer")
        cmd notification post -S bigtext -t 'LimetsU AI Engine' \
        "noxg_engine_mode" \
        "$cmd" \
        >/dev/null 2>&1
    }
    
    
    notif_force() {
        cmd=$(echo "Mode Status : [ Game Force Mode ]\nLimetsU AI Engine | [Enjoy Your Game And Battery Is Low]\n\nCosmic Injection Engine\nRunning Service : $timer")
        cmd notification post -S bigtext -t 'LimetsU AI Engine' \
        "noxg_engine_mode" \
        "$cmd" \
        >/dev/null 2>&1
    }
    
    
    notif_stop() {
        cmd=$(echo "Mode Status : [ Saver Mode ]\nLimetsU AI Engine | [Enjoy Efficiency Battery]\n\nCosmic Injection Engine\nRunning Service : $timer")
        cmd notification post -S bigtext -t 'LimetsU AI Engine' \
        "noxg_engine_mode" \
        "$cmd" \
        >/dev/null 2>&1
    }

    toast() {
        text=$1
        am start -a AxManager.TOAST -e text "$text" >/dev/null 2>&1
    }
    
    while true; do
        GAME_LIST=$(cat /data/local/tmp/game.txt)
        timer=$(TZ="Asia/Jakarta" date +"%H:%M")
        persentase_battrey=$(dumpsys battery | grep level | cut -f2 -d:)
        # detected_apps=$(dumpsys activity processes | grep top-activity | cut -d ':' -f4 | cut -d '/' -f1 | head -n 1)
        detected_apps=$(dumpsys window | grep "Window #" | grep WindowStateAnimator | grep -v "Window #0" | grep -Eo "$GAME_LIST" | head -n 1) # Beta New Generation
        render_detected=$(getprop debug.hwui.renderer)
        list_game=$(echo "$GAME_LIST" | tr ',' '\n')
        notif_state="run"

        # --- Midnight Action ---
        if [[ "$timer" == "00:00" ]]; then
            cosmic --cache_cleaner
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
                if [[ $(settings get global cosmic_game_mode) != "$profile_detection" ]]; then
                    profile_state="run"
                fi
            elif [[ $persentase_battrey -ge 20 ]]; then
                mode_now="force-mode"
                if [[ $(settings get global cosmic_game_mode) != "$profile_detection" ]]; then
                    profile_state="run"
                fi
            else
                mode_now="force-saver-mode"
                if [[ $(settings get global cosmic_game_mode) != "$profile_detection" ]]; then
                    profile_state="run"
                fi
            fi
        else
            gameDetected="false"
            mode_now="saver-mode"
            if [[ $(settings get global cosmic_daily_mode) != "$profile_detection" ]]; then
                profile_state="run"
            fi
        fi


        # -------- MODE SWITCH ----------
        if [[ "$mode_now" != "$running_mode_detection" ]]; then
            notif_state="run"
            profile_state="run"
        else
            notif_state="skip"
        fi

        if [[ "$gameDetected" == "true" ]]; then
            # GAME MODE
            if [[ $persentase_battrey -ge 30 ]]; then
                # Profile mode
                if [[ $profile_state == "run" ]]; then
                    if [[ $(settings get global cosmic_game_mode) == "1" ]]; then
                        toast "Game Mode | Cosmic Pro | Saver Profile" >/dev/null 2>&1
                        saver_mode
                        echo "[DEBUG][PROFILE] Saver Mode Activated"
                        profile_detection="1"
                    elif [[ $(settings get global cosmic_game_mode) == "2" ]]; then
                        toast "Game Mode | Cosmic Pro | Balance Profile" >/dev/null 2>&1
                        echo "[DEBUG][PROFILE] Balance Mode Activated"
                        balance_mode
                        profile_detection="2"
                    elif [[ $(settings get global cosmic_game_mode) == "3" ]]; then
                        toast "Game Mode | Cosmic Pro | High Profile" >/dev/null 2>&1
                        echo "[DEBUG][PROFILE] High Mode Activated"
                        game_mode
                        profile_detection="3"
                    fi
                    profile_state="stop"
                fi

                if [[ "$notif_state" == "run" ]]; then
                    notif_run
                    cosmic --driver $detected_apps >/dev/null 2>&1
                    cosmic --game_compiler $detected_apps >/dev/null 2>&1
                    install_background >/dev/null 2>&1

                    # GMS
                    if [[ $(settings get global cosmic_gms_doze_enable) == "true" ]]; then
                        dumpsys deviceidle whitelist -com.google.android.gms
                        appops set com.google.android.gms WAKE_LOCK ignore >/dev/null 2>&1
                        appops set com.google.android.gms RUN_IN_BACKGROUND ignore >/dev/null 2>&1
                        appops set com.google.android.gms WAKEUP_ALARM ignore >/dev/null 2>&1
                        settings put global enable_google_services 0 >/dev/null 2>&1
                        settings put global gs_location_enabled 0 >/dev/null 2>&1
                        settings put global backup_enabled 0 >/dev/null 2>&1
                        pm disable-user --user 0 com.google.android.gms/com.google.android.gms.chimera.GmsIntentOperationService >/dev/null 2>&1
                        pm disable-user --user 0 com.google.android.gms/com.google.android.gms.stats.service.DropBoxEntryAddedService >/dev/null 2>&1
                        pm disable-user --user 0 com.google.android.gms/com.google.android.gms.checkin.CheckinService >/dev/null 2>&1
                        echo "[DEBUG] Disable GMS succesfuly"
                    fi
                    
                    # OTHER OPTIMIZER FEATURE ON WEBUI  
                    if [[ $(settings get system high_performance_mode_on 2>/dev/null) ]]; then
                        cmd settings put system high_performance_mode_on 1
                        cmd settings put system high_performance_mode_on_when_shutdown 1
                        echo "[DEBUG] ColorOS High Performance Mode Activated"
                    fi
                    
                    if [ $(settings get global cosmic_perf_opt_enable) = "true" ]; then
                        settings put --user 0 system performance_mode_enable 1
                        settings put system power_save_type_performance 0
                        settings put system power_mode high
                        cmd settings put global security_center_pc_save_mode_data '{"a":0,"b":-1,"c":-1,"d":-1}'
                        cmd settings put system POWER_BALANCED_MODE_OPEN 0
                        cmd settings put system POWER_PERFORMANCE_MODE_OPEN 1
                        cmd settings put system POWER_SAVE_MODE_OPEN 0
                        cmd settings put system POWER_SAVE_PRE_HIDE_MODE performance
                        cmd settings put system speed_mode 1
                        echo "[DEBUG] Performance Mode Activated"
                    fi
                    
                    if [ $(settings get global cosmic_adaptive_power_enable) == "true" ]; then
                        settings put global adaptive_battery_management_enabled 0 >/dev/null 2>&1
                        settings put global reduce_motion 1
                        cmd power set-adaptive-power-saver-enabled false
                        cmd power set-mode 0
                        cmd deviceidle pre-idle-factor 0
                        echo "[DEBUG] Adaptive Power Mode Activated"
                    fi
                    
                    if [ $(settings get global cosmic_dnd_enable) == "true" ]; then
                        settings put global zen_mode 1
                        echo "[DEBUG] Do Not Disturb Activated"
                    fi

                    # Additional Tweaks
                    [ "$temp_limit" = "true" ] && settings put --user 0 system rt_enable_templimit false; echo "[DEBUG] Temperature Limit Activated"
                    [ "$bypass_high_temp" = "true" ] && settings put --user 0 system tran_temp_battery_warning 0 && settings put --user 0 system tran_default_temperature_index 0; echo "[DEBUG] Bypass High Temperature Activated"
                    [ "$fos_hdr_disabler" = "true" ] && settings put global user_disable_hdr_formats 1; echo "[DEBUG] HDR Disabler Activated"
                    [ "$cos_temp_protect" = "true" ] && settings put secure oppo_high_temperature_protection_status 0 && settings put system oplus_settings_hightemp_protect 0; echo "[DEBUG] Temperature Protection Activated"
                    [ $getHavyEnable == "true" ] && havy_force_stopped >/dev/null 2>&1; echo "[DEBUG] Havy Force Stopped Activated"

                    running_mode_detection="game-mode"
                    notif_state="skip"
                fi
            # FORCE MODE
            elif [[ $persentase_battrey -ge 20 ]]; then
                # Profile mode
                if [[ $profile_state == "run" ]]; then
                    if [[ $(settings get global cosmic_game_mode) == "1" ]]; then
                        toast "Game Mode | Cosmic Pro | Saver Profile" >/dev/null 2>&1
                        saver_mode
                        echo "[DEBUG][PROFILE] Saver Mode Activated"
                        profile_detection="1"
                    elif [[ $(settings get global cosmic_game_mode) == "2" ]]; then
                        toast "Game Mode | Cosmic Pro | Balance Profile" >/dev/null 2>&1
                        echo "[DEBUG][PROFILE] Balance Mode Activated"
                        balance_mode
                        profile_detection="2"
                    elif [[ $(settings get global cosmic_game_mode) == "3" ]]; then
                        toast "Game Mode | Cosmic Pro | High Profile" >/dev/null 2>&1
                        echo "[DEBUG][PROFILE] High Mode Activated"
                        game_mode
                        profile_detection="3"
                    fi
                    profile_state="stop"
                fi

                if [[ "$notif_state" == "run" ]]; then
                    notif_force
                    cosmic --driver $detected_apps >/dev/null 2>&1
                    cosmic --game_compiler $detected_apps >/dev/null 2>&1
                    install_background >/dev/null 2>&1

                    # GMS
                    if [[ $(settings get global cosmic_gms_doze_enable) == "true" ]]; then
                        dumpsys deviceidle whitelist -com.google.android.gms
                        appops set com.google.android.gms WAKE_LOCK ignore >/dev/null 2>&1
                        appops set com.google.android.gms RUN_IN_BACKGROUND ignore >/dev/null 2>&1
                        appops set com.google.android.gms WAKEUP_ALARM ignore >/dev/null 2>&1
                        settings put global enable_google_services 0 >/dev/null 2>&1
                        settings put global gs_location_enabled 0 >/dev/null 2>&1
                        settings put global backup_enabled 0 >/dev/null 2>&1
                        pm disable-user --user 0 com.google.android.gms/com.google.android.gms.chimera.GmsIntentOperationService >/dev/null 2>&1
                        pm disable-user --user 0 com.google.android.gms/com.google.android.gms.stats.service.DropBoxEntryAddedService >/dev/null 2>&1
                        pm disable-user --user 0 com.google.android.gms/com.google.android.gms.checkin.CheckinService >/dev/null 2>&1
                        echo "[DEBUG] Disable GMS succesfuly"
                    fi
                    
                    # OTHER OPTIMIZER FEATURE ON WEBUI  
                    if [[ $(settings get system high_performance_mode_on 2>/dev/null) ]]; then
                        cmd settings put system high_performance_mode_on 1
                        cmd settings put system high_performance_mode_on_when_shutdown 1
                        echo "[DEBUG] ColorOS High Performance Mode Activated"
                    fi
                    
                    if [ $(settings get global cosmic_perf_opt_enable) = "true" ]; then
                        settings put --user 0 system performance_mode_enable 1
                        settings put system power_save_type_performance 0
                        settings put system power_mode high
                        cmd settings put global security_center_pc_save_mode_data '{"a":0,"b":-1,"c":-1,"d":-1}'
                        cmd settings put system POWER_BALANCED_MODE_OPEN 0
                        cmd settings put system POWER_PERFORMANCE_MODE_OPEN 1
                        cmd settings put system POWER_SAVE_MODE_OPEN 0
                        cmd settings put system POWER_SAVE_PRE_HIDE_MODE performance
                        cmd settings put system speed_mode 1
                        echo "[DEBUG] Performance Mode Activated"
                    fi
                    
                    if [ $(settings get global cosmic_adaptive_power_enable) == "true" ]; then
                        settings put global adaptive_battery_management_enabled 0 >/dev/null 2>&1
                        settings put global reduce_motion 1
                        cmd power set-adaptive-power-saver-enabled false
                        cmd power set-mode 0
                        cmd deviceidle pre-idle-factor 0
                        echo "[DEBUG] Adaptive Power Mode Activated"
                    fi
                    
                    if [ $(settings get global cosmic_dnd_enable) == "true" ]; then
                        settings put global zen_mode 1
                        echo "[DEBUG] Do Not Disturb Activated"
                    fi

                    # Additional Tweaks
                    [ "$temp_limit" = "true" ] && settings put --user 0 system rt_enable_templimit false; echo "[DEBUG] Temperature Limit Activated"
                    [ "$bypass_high_temp" = "true" ] && settings put --user 0 system tran_temp_battery_warning 0 && settings put --user 0 system tran_default_temperature_index 0; echo "[DEBUG] Bypass High Temperature Activated"
                    [ "$fos_hdr_disabler" = "true" ] && settings put global user_disable_hdr_formats 1; echo "[DEBUG] HDR Disabler Activated"
                    [ "$cos_temp_protect" = "true" ] && settings put secure oppo_high_temperature_protection_status 0 && settings put system oplus_settings_hightemp_protect 0; echo "[DEBUG] Temperature Protection Activated"
                    [ $getHavyEnable == "true" ] && havy_force_stopped >/dev/null 2>&1; echo "[DEBUG] Havy Force Stopped Activated"

                    running_mode_detection="force-mode"
                    notif_state="skip"
                fi
            # FORCE-SAVER MODE
            else
                # Profile mode
                if [[ $profile_state == "run" ]]; then
                    if [[ $(settings get global cosmic_game_mode) == "1" ]]; then
                        toast "Game Mode | Cosmic Pro | Saver Profile" >/dev/null 2>&1
                        saver_mode
                        echo "[DEBUG][PROFILE] Saver Mode Activated"
                        profile_detection="1"
                    elif [[ $(settings get global cosmic_game_mode) == "2" ]]; then
                        toast "Game Mode | Cosmic Pro | Balance Profile" >/dev/null 2>&1
                        echo "[DEBUG][PROFILE] Balance Mode Activated"
                        balance_mode
                        profile_detection="2"
                    elif [[ $(settings get global cosmic_game_mode) == "3" ]]; then
                        toast "Game Mode | Cosmic Pro | High Profile" >/dev/null 2>&1
                        echo "[DEBUG][PROFILE] High Mode Activated"
                        game_mode
                        profile_detection="3"
                    fi
                    profile_state="stop"
                fi

                if [[ "$notif_state" == "run" ]]; then
                    notif_stop

                    uninstall_bg >/dev/null 2>&1

                    if [[ $(settings get global cosmic_gms_doze_enable) == "true" ]]; then
                        dumpsys deviceidle whitelist -com.google.android.gms
                        appops set com.google.android.gms WAKE_LOCK ignore >/dev/null 2>&1
                        appops set com.google.android.gms RUN_IN_BACKGROUND ignore >/dev/null 2>&1
                        appops set com.google.android.gms WAKEUP_ALARM ignore >/dev/null 2>&1
                        settings put global enable_google_services 0 >/dev/null 2>&1
                        settings put global gs_location_enabled 0 >/dev/null 2>&1
                        settings put global backup_enabled 0 >/dev/null 2>&1
                        pm enable-user --user 0 com.google.android.gms/com.google.android.gms.chimera.GmsIntentOperationService >/dev/null 2>&1
                        pm enable-user --user 0 com.google.android.gms/com.google.android.gms.stats.service.DropBoxEntryAddedService >/dev/null 2>&1
                        pm enable-user --user 0 com.google.android.gms/com.google.android.gms.checkin.CheckinService >/dev/null 2>&1
                        echo "[DEBUG] GMS Doze Activated"
                    fi
                    
                    # OPTIMIZER (MATCHING WEBUI)
                    if [[ $(settings get system high_performance_mode_on 2>/dev/null) ]]; then
                        cmd settings put system high_performance_mode_on 0
                        cmd settings put system high_performance_mode_on_when_shutdown 0
                        echo "[DEBUG] High Performance Mode Non-Activated"
                    fi
                
                    if [ "$(settings get global cosmic_perf_opt_enable)" = "true" ]; then
                        settings put --user 0 system performance_mode_enable 0
                        settings put system power_save_type_performance 1
                        settings put system power_mode low
                        cmd settings put global security_center_pc_save_mode_data '{"a":1,"b":1,"c":0,"d":0}'
                        cmd settings put system POWER_BALANCED_MODE_OPEN 1
                        cmd settings put system POWER_PERFORMANCE_MODE_OPEN 0
                        cmd settings put system POWER_SAVE_MODE_OPEN 1
                        cmd settings put system POWER_SAVE_PRE_HIDE_MODE save
                        cmd settings put system speed_mode 0
                        echo "[DEBUG] Performance Optimizer Non-Activated"
                    fi
                
                    if [ "$(settings get global cosmic_adaptive_power_enable)" = "true" ]; then
                        settings put global adaptive_battery_management_enabled 1 >/dev/null 2>&1
                        settings put global reduce_motion 1
                        cmd deviceidle pre-idle-factor 6
                        echo "[DEBUG] Adaptive Power Non-Activated"
                    fi
                
                    if [ "$(settings get global cosmic_dnd_enable)" = "true" ]; then
                        settings put global zen_mode 0
                        echo "[DEBUG] Do Not Disturb Non-Activated"
                    fi
                    
                    # Restore Settings
                    [ "$temp_limit" = "true" ] && settings put --user 0 system rt_enable_templimit true; echo "[DEBUG] Temperature Limit Non-Activated"
                    [ "$bypass_high_temp" = "true" ] && settings put --user 0 system tran_temp_battery_warning 1 && settings put --user 0 system tran_default_temperature_index 1; echo "[DEBUG] Temperature Bypass Non-Activated"
                    [ "$fos_hdr_disabler" = "true" ] && settings put global user_disable_hdr_formats 0; echo "[DEBUG] HDR Disabler Non-Activated"
                    [ "$cos_temp_protect" = "true" ] && settings put secure oppo_high_temperature_protection_status 1 && settings put system oplus_settings_hightemp_protect 1; echo "[DEBUG] Temperature Protect Non-Activated"

                    running_mode_detection="force-saver-mode"
                    notif_state="skip"
                fi
            fi
        else
            # SAVER MODE
            # Profile mode
            if [[ $profile_state == "run" ]]; then
                if [[ $(settings get global cosmic_daily_mode) == "1" ]]; then
                    toast "Saver Mode | Cosmic Pro | Saver Profile" >/dev/null 2>&1
                    echo "[DEBUG][PROFILE] Saver Mode Activated"
                    saver_mode
                    profile_detection="1"
                elif [[ $(settings get global cosmic_daily_mode) == "2" ]]; then
                    toast "Saver Mode | Cosmic Pro | Balance Profile" >/dev/null 2>&1
                    echo "[DEBUG][PROFILE] Balance Mode Activated"
                    balance_mode
                    profile_detection="2"
                elif [[ $(settings get global cosmic_daily_mode) == "3" ]]; then
                    toast "Saver Mode | Cosmic Pro | High Profile" >/dev/null 2>&1
                    echo "[DEBUG][PROFILE] Game Mode Activated"
                    game_mode
                    profile_detection="3"
                fi
                profile_state="stop"
            fi

            if [[ "$notif_state" == "run" ]]; then
                notif_stop

                uninstall_bg >/dev/null 2>&1
                cosmic --cache_cleaner >/dev/null 2>&1

                if [[ $(settings get global cosmic_gms_doze_enable) == "true" ]]; then
                    dumpsys deviceidle whitelist -com.google.android.gms
                    appops set com.google.android.gms WAKE_LOCK ignore >/dev/null 2>&1
                    appops set com.google.android.gms RUN_IN_BACKGROUND ignore >/dev/null 2>&1
                    appops set com.google.android.gms WAKEUP_ALARM ignore >/dev/null 2>&1
                    settings put global enable_google_services 0 >/dev/null 2>&1
                    settings put global gs_location_enabled 0 >/dev/null 2>&1
                    settings put global backup_enabled 0 >/dev/null 2>&1
                    pm enable-user --user 0 com.google.android.gms/com.google.android.gms.chimera.GmsIntentOperationService >/dev/null 2>&1
                    pm enable-user --user 0 com.google.android.gms/com.google.android.gms.stats.service.DropBoxEntryAddedService >/dev/null 2>&1
                    pm enable-user --user 0 com.google.android.gms/com.google.android.gms.checkin.CheckinService >/dev/null 2>&1
                    echo "[DEBUG] GMS Doze Activated"
                fi
                
                # OPTIMIZER (MATCHING WEBUI)
                if [[ $(settings get system high_performance_mode_on 2>/dev/null) ]]; then
                    cmd settings put system high_performance_mode_on 0
                    cmd settings put system high_performance_mode_on_when_shutdown 0
                    echo "[DEBUG] High Performance Mode Non-Activated"
                fi
            
                if [ "$(settings get global cosmic_perf_opt_enable)" = "true" ]; then
                    settings put --user 0 system performance_mode_enable 0
                    settings put system power_save_type_performance 1
                    settings put system power_mode low
                    cmd settings put global security_center_pc_save_mode_data '{"a":1,"b":1,"c":0,"d":0}'
                    cmd settings put system POWER_BALANCED_MODE_OPEN 1
                    cmd settings put system POWER_PERFORMANCE_MODE_OPEN 0
                    cmd settings put system POWER_SAVE_MODE_OPEN 1
                    cmd settings put system POWER_SAVE_PRE_HIDE_MODE save
                    cmd settings put system speed_mode 0
                    echo "[DEBUG] Performance Optimizer Non-Activated"
                fi
            
                if [ "$(settings get global cosmic_adaptive_power_enable)" = "true" ]; then
                    settings put global adaptive_battery_management_enabled 1 >/dev/null 2>&1
                    settings put global reduce_motion 1
                    cmd deviceidle pre-idle-factor 6
                    echo "[DEBUG] Adaptive Power Non-Activated"
                fi
            
                if [ "$(settings get global cosmic_dnd_enable)" = "true" ]; then
                    settings put global zen_mode 0
                    echo "[DEBUG] Do Not Disturb Non-Activated"
                fi
                
                # Restore Settings
                [ "$temp_limit" = "true" ] && settings put --user 0 system rt_enable_templimit true; echo "[DEBUG] Temperature Limit Non-Activated"
                [ "$bypass_high_temp" = "true" ] && settings put --user 0 system tran_temp_battery_warning 1 && settings put --user 0 system tran_default_temperature_index 1; echo "[DEBUG] Temperature Bypass Non-Activated"
                [ "$fos_hdr_disabler" = "true" ] && settings put global user_disable_hdr_formats 0; echo "[DEBUG] HDR Disabler Non-Activated"
                [ "$cos_temp_protect" = "true" ] && settings put secure oppo_high_temperature_protection_status 1 && settings put system oplus_settings_hightemp_protect 1; echo "[DEBUG] Temperature Protect Non-Activated"

                running_mode_detection="saver-mode"
                notif_state="skip"
            fi
        fi
        
        cosmic --dex2ot >/dev/null 2>&1

        sleep "$IDLE_TIME"
    done
}

service_server
