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
    settings put global qiunix_profile_enable Game-Mode

    # SETPROP
    setprop debug.hwui.renderer $(settings get global qiunix_render_value)
    setprop debug.renderengine.backend $(settings get global qiunix_render_backend_value)
    setprop debug.composition.type $(settings get global qiunix_composition_value)
    setprop debug.egl.hw 1
    setprop debug.sf.hw 1
    setprop debug.hwui.trace_gpu_resources false
    #setprop debug.cpurend.vsync false
    #setprop debug.gpurend.vsync false
    setprop debug.egl.force_msaa false
    setprop debug.performance.tuning 1

    # CPU Cluster
    setprop debug.cluster_little-set_his_speed $(cat /sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_min_freq)
    setprop debug.cluster_big-set_his_speed $(cat /sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_max_freq)
    setprop debug.powehint.cluster_little-set_his_speed $(cat /sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_min_freq)
    setprop debug.powehint.cluster_big-set_his_speed $(cat /sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_max_freq)

    # CMD
    cmd power set-fixed-performance-mode-enabled true
    cmd settings put system air_motion_engine 0
    cmd settings put system master_motion 0
    cmd settings put system motion_engine 0
    cmd shortcut reset-all-throttling
    cmd thermalservice override-status 0
    cmd activity memory-factor set 0
    cmd power set-mode 0
    cmd settings put global angle_gl_driver_all_angle 1
    cmd settings put global game_driver_all_apps 1
    cmd settings put global updatable_driver_all_apps 1
 
    # PERFORMANCE DEVICE CONFIG
    cmd device_config put activity_manager max_cached_processes 65535
    cmd device_config put activity_manager max_phantom_processes 65535
    cmd device_config put activity_manager max_empty_time_millis 180000
    cmd device_config put activity_manager bg_fgs_monitor_enabled false
    cmd device_config put activity_manager bg_current_drain_auto_restrict_abusive_apps_enabled false
    cmd device_config put activity_manager bg_media_session_monitor_enabled false
    cmd device_config put activity_manager bg_permission_monitor_enabled false
    cmd device_config put activity_manager_native_boot modern_queue_enabled true
}

saver_mode() {
    # SET PROFILE STATUS
    settings put global qiunix_profile_enable Saver-Mode

    # SETPROP (LOW POWER)
    setprop debug.hwui.renderer skiagl
    setprop debug.renderengine.backend skiaglthreaded
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
    cmd settings put global angle_gl_driver_all_angle 0
    cmd settings put global game_driver_all_apps 0
    cmd settings put global updatable_driver_all_apps 0
}

# ENGINE SERVICE
service_engine() {
    LOG_FILE="/data/local/tmp/qiunixai.log"
    IDLE_TIME=2
    running_mode_detection=""
    notif_update_done=""
    notif_state="run"
    notif_update_state="stop"

    settings put global qiunix_engine_version 1.0.6_Alpha
    settings put global qiunix_engine_enable qiunixai.pid
    
    echo "[Service] QiunixAI Started at $(date)" >> "$LOG_FILE"

    notif_run() {
        render=$(getprop debug.hwui.renderer)
        backend=$(getprop debug.renderengine.backend)
        compotion=$(getprop debug.composition.type)
        cmd=$(echo "Profile Status : [ Game Mode ]\nQiunixAI Engine | Enjoy Your Game\n[ $render | $backend | $compotion ]\n\nNew Generation Engine\nRunning Service : $timer")
        cmd notification post -S bigtext -t 'QiunixAI Engine' \
        "beta_new_gen" \
        "$cmd" \
        >/dev/null 2>&1
    }

    notif_stop() {
        render=$(getprop debug.hwui.renderer)
        backend=$(getprop debug.renderengine.backend)
        compotion=$(getprop debug.composition.type)
        cmd=$(echo "Profile Status : [ Saver Mode ]\nQiunixAI Engine | Efficiency Battery\n[ $render | $backend | $compotion ]\n\nNew Generation Engine\nRunning Service : $timer")
        cmd notification post -S bigtext -t 'QiunixAI Engine' \
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
        new_status=$(wget --no-check-certificate -q -O - "https://raw.githubusercontent.com/Reiii3/NoxVex/main/dataShell/cosmic/triger-update/qiunix-triger")
        GAME_LIST=$(cat /data/local/tmp/game.txt)
        timer=$(TZ="Asia/Jakarta" date +"%H:%M")
        persentase_battrey=$(dumpsys battery | grep level | cut -f2 -d:)
        #detected_apps=$(dumpsys activity processes | grep top-activity | cut -d ':' -f4 | cut -d '/' -f1 | head -n 1)
        detected_apps=$(dumpsys window | grep "Window #" | grep WindowStateAnimator | grep -v "Window #0" | grep -Eo "$GAME_LIST" | head -n 1) # Beta New Generation

        # Enable Checking Feature
        getStatusUpdate=$(settings get global qiunix_update_verif)

        # Daily cache cleaner
        if [[ "$timer" == "00:00" ]]; then
            cosmic --cache_cleaner >/dev/null 2>&1

            sorted=$(echo "$GAME_LIST" | tr ',' '\n' | sort)
            for package in $sorted; do
                cmd package compile -m speed -f "$package" >/dev/null 2>&1
            done
        fi

        # -------- MODE DETECT ----------
        if echo "$GAME_LIST" | grep -qw "$detected_apps"; then
            gameDetected="true"
            mode_now="game-mode"
        else
            gameDetected="false"
            mode_now="saver-mode"
        fi

        # -------- MODE SWITCH ----------
        if [[ "$mode_now" != "$running_mode_detection" ]]; then
            notif_state="run"
        fi
        
        if [[ "$new_status" != $(settings get global qiunix_engine_version) && "$new_status" != "" && "$notif_update_done" != "true" && "$getStatusUpdate" != "true" ]]; then
            notif_update_state="run"
            notif_update_done="true"
        fi

        # -------- GAME MODE ----------
        if [[ $gameDetected == "true" ]]; then
            if [[ $notif_state == "run" ]]; then
                notif_update_done="false"

                main_active_sf
                echo "[DEBUG] Dynamic SurfaceFlinger Actived"
                
                game_mode # Mode Game Tweak
                echo "[DEBUG] Game Mode Actived"
                notif_run

                # OTHER OPTIMIZER FEATURE ON WEBUI  
                if [[ $(settings get system high_performance_mode_on 2>/dev/null) ]]; then
                    cmd settings put system high_performance_mode_on 1
                    cmd settings put system high_performance_mode_on_when_shutdown 1
                    echo "[DEBUG] ColorOS High Performance Mode Activated"
                fi

                running_mode_detection="game-mode"
                notif_state="stop"
            fi

            if [[ "$notif_update_state" == "run" ]]; then
                if [[ "$new_status" != $(settings get global qiunix_engine_version) ]]; then
                    cmd=$(echo "Update AI Engine QiunixAI\nUpdate Version $new_status Available\n\nPlease Check Update In Plugin Cosmic")
                    cmd notification post -S bigtext -t 'Engine Update' \
                    "beta_new_gen" \
                    "$cmd" \
                    > /dev/null 2>&1
                fi
                notif_update_state="stop"
                settings put global qiunix_update_verif true
            fi

        # -------- SAVER MODE ----------
        else
            if [[ $notif_state == "run" ]]; then
                notif_update_done="false"

                main_remove_sf
                echo "[DEBUG] Dynamic SufaceFlinger Non-Active"

                saver_mode # Mode Saver Tweak
                echo "[DEBUG] Saver Mode Actived"
                notif_stop
                
                # OPTIMIZER (MATCHING WEBUI)
                if [[ $(settings get system high_performance_mode_on 2>/dev/null) ]]; then
                    cmd settings put system high_performance_mode_on 0
                    cmd settings put system high_performance_mode_on_when_shutdown 0
                    echo "[DEBUG] High Performance Mode Non-Activated"
                fi

                running_mode_detection="saver-mode"
                notif_state="stop"
            fi

            if [[ "$notif_update_state" == "run" ]]; then
                if [[ "$new_status" != $(settings get global qiunix_engine_version) ]]; then
                    cmd=$(echo "Update AI Engine QiunixAI\nUpdate Version $new_status Available\n\nPlease Check Update In Plugin Cosmic")
                    cmd notification post -S bigtext -t 'Engine Update' \
                    "beta_new_gen" \
                    "$cmd" \
                    > /dev/null 2>&1
                fi
                notif_update_state="stop"
                settings put global qiunix_update_verif true
            fi
        fi

        sleep "$IDLE_TIME"
    done
}

service_engine