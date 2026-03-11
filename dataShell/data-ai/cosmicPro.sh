# BETA New Generation Engine
# Cosmis AI Engine Pro Version

run_sf=1000000000
remove_sf=1000000

other() {
    # source : https://android.googlesource.com/platform/frameworks/native/+/refs/heads/main/services/surfaceflinger/SurfaceFlinger.cpp
    # Optimize Surface Flinger
    setprop debug.sf.luma_sampling $3
    setprop debug.sf.enable_gl_backpressure $2
    setprop debug.sf.enable_transaction_tracing $3
    setprop debug.sf.disable_client_composition_cache $3
    setprop debug.sf.predict_hwc_composition_strategy $3
    setprop debug.sf.vsync_reactor_ignore_present_fences $3
    setprop debug.sf.use_phase_offsets_as_durations $2
    setprop debug.sf.kernel_idle_timer_update_overlay $2

    # SurfaceFlinger Optimize PrimeShader
    for i in solid_layers shadow_layers image_layers clipped_layers edge_extension_shader hole_punch solid_dimmed_layers image_dimmed_layers pip_image_layers transparent_image_dimmed_layers clipped_dimmed_image_layers;do setprop debug.sf.prime_shader_cache.$i $1; done
}

auto_sf_dyn() {
    # credit : by Kazuyoo
    refresh_rate=$(dumpsys display | grep -oE 'fps=[0-9]+' | awk -F '=' '{print $2 + 2}' | head -n 1)
    # cek apakah variable refresh_rate berisi jika tidak variabel akan otomatis mengambil nilai 62
    if [ -z "$refresh_rate" ]; then
        echo "masuk ke bypash mode"
        refresh_rate=62
    fi

    frame_time=$(awk "BEGIN {printf \"%.0f\", (1 / $refresh_rate) * $1}")

    early_offset=$((frame_time / 5))
    late_offset=$((frame_time * 5 / 6))
    negative_offset=$((early_offset * -1))
    gl_duration=$((late_offset + frame_time / 15))
    idle_timer=$((frame_time / 1000000 + 800))
    sampling_duration=$((frame_time * 4 / 5))
    sampling_period=$((frame_time * 9 / 10))

    setprop debug.sf.hw "$2"
    setprop debug.egl.hw "$2"
    setprop debug.sf.hwc.min.duration "$frame_time"
    setprop debug.sf.early.app.duration "$early_offset"
    setprop debug.sf.late.app.duration "$late_offset"
    setprop debug.sf.early.sf.duration "$early_offset"
    setprop debug.sf.late.sf.duration "$late_offset"
    setprop debug.sf.set_idle_timer_ms "$idle_timer"
    setprop debug.sf.earlyGl.sf.duration "$gl_duration"
    setprop debug.sf.earlyGl.app.duration "$gl_duration"
    setprop debug.sf.early_phase_offset_ns "$early_offset"
    setprop debug.sf.early_gl_phase_offset_ns "$early_offset"
    setprop debug.sf.early_app_phase_offset_ns "$early_offset"
    setprop debug.sf.early_gl_app_phase_offset_ns "$early_offset"
    setprop debug.sf.high_fps_early_app_phase_offset_ns "$negative_offset"
    setprop debug.sf.high_fps_late_app_phase_offset_ns "$late_offset"
    setprop debug.sf.high_fps_early_sf_phase_offset_ns "$negative_offset"
    setprop debug.sf.high_fps_late_sf_phase_offset_ns "$late_offset"
    setprop debug.sf.high_fps_early_gl_phase_offset_ns "$early_offset"
    setprop debug.sf.high_fps_early_gl_app_phase_offset_ns "$early_offset"
}

main_active_sf() {
    auto_sf_dyn $run_sf 1
    other false 1 0
}

main_remove_sf() {
    auto_sf_dyn $remove_sf 0
    other true 0 1
}

game_mode() {
    # SET PROFILE STATUS TO WEBUI STATUS
    settings put global cosmic_profile_enable Game-Mode

    # SETPROP
    setprop debug.hwui.renderer skiavk
    setprop debug.renderengine.backend skiavkthreaded
    settings put global power_check_max_cpu_1 310
    settings put global power_check_max_cpu_2 370
    settings put global power_check_max_cpu_3 140
    settings put global power_check_max_cpu_4 170
    setprop debug.hwui.target_power_time_percent 210
    setprop debug.hwui.target_cpu_time_percent 210
    setprop debug.hwui.target_gpu_time_percent 210
    setprop debug.egl.hw 1
    setprop debug.sf.hw 1
    setprop debug.hwui.trace_gpu_resources false
    setprop debug.egl.force_msaa false
    setprop debug.performance.tuning 1
    setprop debug.composition.type mdp

    # CMD
    cmd power set-fixed-performance-mode-enabled true
    cmd settings put system air_motion_engine 0
    cmd settings put system master_motion 0
    cmd settings put system motion_engine 0
    cmd shortcut reset-all-throttling
    cmd thermalservice override-status 0
    cmd activity memory-factor set 0

    # GMS
    dumpsys deviceidle whitelist -com.google.android.gms
    appops set com.google.android.gms WAKE_LOCK ignore
    appops set com.google.android.gms RUN_IN_BACKGROUND ignore
    appops set com.google.android.gms WAKEUP_ALARM ignore
    settings put global enable_google_services 0
    settings put global gs_location_enabled 0
    settings put global backup_enabled 0
    pm disable-user --user 0 com.google.android.gms/com.google.android.gms.chimera.GmsIntentOperationService
    pm disable-user --user 0 com.google.android.gms/com.google.android.gms.stats.service.DropBoxEntryAddedService
    pm disable-user --user 0 com.google.android.gms/com.google.android.gms.checkin.CheckinService

    # OTHER OPTIMIZER FEATURE ON WEBUI  
    if [[ $(settings get system high_performance_mode_on 2>/dev/null) ]]; then
        cmd settings put system high_performance_mode_on 1
        cmd settings put system high_performance_mode_on_when_shutdown 1
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
    fi
    
    if [ $(settings get global cosmic_adaptive_power_enable) == "true" ]; then
        settings put global adaptive_battery_management_enabled 0 >/dev/null 2>&1
        settings put global reduce_motion 1
        cmd power set-adaptive-power-saver-enabled false
        cmd power set-mode 0
        cmd deviceidle pre-idle-factor 0
    fi
    
    if [ $(settings get global cosmic_dnd_enable) == "true" ]; then
        settings put global zen_mode 1
    fi
}

saver_mode() {
    # SET PROFILE STATUS
    settings put global cosmic_profile_enable Saver-Mode

    # SETPROP (LOW POWER)
    setprop debug.hwui.renderer skiagl
    setprop debug.renderengine.backend skiaglthreaded
    settings put global power_check_max_cpu_1 120
    settings put global power_check_max_cpu_2 150
    settings put global power_check_max_cpu_3 90
    settings put global power_check_max_cpu_4 110
    setprop debug.hwui.target_power_time_percent 120
    setprop debug.hwui.target_cpu_time_percent 120
    setprop debug.hwui.target_gpu_time_percent 120
    setprop debug.egl.hw 0
    setprop debug.sf.hw 0
    setprop debug.hwui.trace_gpu_resources false
    setprop debug.egl.force_msaa false
    setprop debug.performance.tuning 0
    setprop debug.composition.type c2d

    # CMD POWER SAVER
    cmd power set-fixed-performance-mode-enabled false
    cmd deviceidle enable deep
    cmd deviceidle enable light
    cmd power set-adaptive-power-saver-enabled true
    cmd power set-mode 1
    cmd thermalservice override-status 3
    cmd activity memory-factor set 3

    # GMS RESTRICT
    dumpsys deviceidle whitelist -com.google.android.gms
    appops set com.google.android.gms WAKE_LOCK ignore
    appops set com.google.android.gms RUN_IN_BACKGROUND ignore
    appops set com.google.android.gms WAKEUP_ALARM ignore
    settings put global enable_google_services 0
    settings put global gs_location_enabled 0
    settings put global backup_enabled 0
    pm disable-user --user 0 com.google.android.gms/com.google.android.gms.chimera.GmsIntentOperationService
    pm disable-user --user 0 com.google.android.gms/com.google.android.gms.stats.service.DropBoxEntryAddedService
    pm disable-user --user 0 com.google.android.gms/com.google.android.gms.checkin.CheckinService

    # OPTIMIZER (MATCHING WEBUI)
    if [[ $(settings get system high_performance_mode_on 2>/dev/null) ]]; then
        cmd settings put system high_performance_mode_on 0
        cmd settings put system high_performance_mode_on_when_shutdown 0
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
    fi

    if [ "$(settings get global cosmic_adaptive_power_enable)" = "true" ]; then
        settings put global adaptive_battery_management_enabled 1 >/dev/null 2>&1
        settings put global reduce_motion 1
        cmd deviceidle pre-idle-factor 6
    fi

    if [ "$(settings get global cosmic_dnd_enable)" = "true" ]; then
        settings put global zen_mode 1
    fi
}


# ENGINE SERVICE
service_engine() {
    LOG_FILE="/data/local/tmp/cosmic.log"
    IDLE_TIME=2.5
    running_mode_detection=""

    settings put global cosmic_engine_version 1.0.0_BETA
    settings put global cosmic_engine_enable cosmicp_server.pid
    
    echo "[Service] COSMIC Pro Started at $(date)" >> "$LOG_FILE"

    notif_run() {
        cmd=$(echo "Profile Status : [ Game Mode ]\nCosmic Pro AI Engine | Enjoy Your Game\nBeta New Generation Engine\nRunning Service : $timer")
        cmd notification post -S bigtext -t 'Cosmic Pro AI Engine' -i "file:///storage/emulated/0/Android/media/.cosmic/notif.png" -I "file:///storage/emulated/0/Android/media/.cosmic/baner.png" \
        "beta_new_gen" \
        "$cmd" \
        >/dev/null 2>&1
    }

    notif_stop() {
        cmd=$(echo "Profile Status : [ Saver Mode ]\nCosmic Pro AI Engine | Enjoy Efficiency Battery\nBeta New Generation Engine\nRunning Service : $timer")
        cmd notification post -S bigtext -t 'Cosmic Pro AI Engine' -i "file:///storage/emulated/0/Android/media/.cosmic/notif.png" -I "file:///storage/emulated/0/Android/media/.cosmic/baner.png" \
        "beta_new_gen" \
        "$cmd" \
        >/dev/null 2>&1
    }

    toast() {
        text=$1
        am start -a AxManager.TOAST -e text "$text" >/dev/null 2>&1
    }

    # MAIN CORE
    while true; do
        # Basic Resource
        GAME_LIST=$(cat /data/local/tmp/game.txt)
        timer=$(TZ="Asia/Jakarta" date +"%H:%M")
        persentase_battrey=$(dumpsys battery | grep level | cut -f2 -d:)
        detected_apps=$(dumpsys activity processes | grep top-activity | cut -d ':' -f4 | cut -d '/' -f1 | head -n 1)
        notif_state="run"

        # Enable Checking Feature
        getHavyEnable=$(settings get global cosmic_havy_apps_enable)
        temp_limit=$(settings get global cosmic_temp_limit_enable)
        fos_hdr_disabler=$(settings get global cosmic_hdr_enable)
        bypass_high_temp=$(settings get global cosmic_bypas_high_enable)
        fos_hdr_disabler=$(settings get global cosmic_hdr_disabler_enable)
        cos_temp_protect=$(settings get global cosmic_temp_protect_enable)

        if [[ "$timer" == "00:00" ]]; then
            # CLEANER CACHE
            cosmic --cache_cleaner >/dev/null 2>&1

            # GET PAKAGE GAME
            sorted=$(echo "$GAME_LIST" | tr ',' '\n' | sort)

            for package in $sorted; do
                cmd package compile -m speed -f "$package" >/dev/null 2>&1
            done
        fi

        # -------- MODE DETECT ----------
        if echo "$list_game" | grep -qw "$detected_apps"; then
            gameDetected="true"
            now_mode="game-mode"
        else
            gameDetected="false"
            mode_now="saver-mode"
        fi

        # -------- MODE SWITCH ----------
        if [[ "$mode_now" != "$running_mode_detection" ]]; then
            notif_state="run"
        fi

        if [[ $gameDetected == "true"]]; then
            if [[ $notif_state == "run"]]; then
                notif_run
                toast "Game Mode | Initializer" >/dev/null 2>&1
                main_active_sf
                game_mode
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
                notif_state="stop"
            fi
        else
            if [[ $notif_state == "run"]]; then
                notif_stop
                toast "Saver Mode | Initializer" >/dev/null 2>&1
                main_remove_sf
                saver_mode
                # RESTORE TEMP LIMIT
                if [ "$temp_limit" = "true" ]; then
                    settings put --user 0 system rt_enable_templimit true
                fi

                # RESTORE HIGH TEMP WARNING
                if [ "$bypass_high_temp" = "true" ]; then
                    settings put --user 0 system tran_temp_battery_warning 1
                    settings put --user 0 system tran_default_temperature_index 1
                fi

                # RESTORE HDR DISABLER
                if [ "$fos_hdr_disabler" = "true" ]; then
                    settings put global user_disable_hdr_formats 0
                fi

                # RESTORE OPPO/REALME HIGH TEMP PROTECTION
                if [ "$cos_temp_protect" = "true" ]; then
                    settings put secure oppo_high_temperature_protection_status 1
                    settings put system oplus_settings_hightemp_protect 1
                fi
                notif_state="stop"
            fi
        fi

        sleep "$IDLE_TIME"
    done
}

service_engine