IDLE_TIME=5
gamerun=""
notif_run=""

smartSystemRun() {
  echo
  echo "[start system-running]"
  if [[ "$menu1" == "true" ]]; then
    echo " [$time] Fitur 1 is actived smart system"
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
        echo "  • masuk ke bypash mode"
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
    auto_sf_dyn $run_sf 1
    other false 1 0
  else
    echo " [$time] Fitur 1 is not-actived"
  fi
  if [[ "$menu2" == "true" ]]; then
    echo " [$time] Fitur 2 is actived smart system"
    settings delete global updatable_driver_production_opt_in  >/dev/null 2>&1;
    settings put global updatable_driver_production_opt_in_apps $detected_apps;
  else
    echo " [$time] Fitur 2 is not-actived"
  fi
  if [[ "$menu3" == "true" ]]; then
    echo " [$time] Fitur 3 is actived smart system"
    # source Code By kazuyo
    setprop debug.composition.type mdp
    setprop debug.hwc.dynThreshold 4.5
    setprop debug.enable.sglscale 1
    setprop debug.hwui.disable_vsync true
    setprop debug.hwui.target_gpu_time_percent 100
    setprop debug.gpuprio 7
    setprop debug.sf.gpu_freq_index 7
    setprop debug.sf.cpu_freq_index 7
    setprop debug.ioprio 7
    setprop debug.sf.mem_freq_index 7
    if [[ "$soc" == "Mediatek" ]]; then
     setprop debug.mediatek.appgamepq_compress 1
     setprop debug.mediatek.disp_decompress 1
     setprop debug.mediatek.appgamepq 2
     setprop debug.mediatek.game_pq_enable 1
     setprop debug.mediatek.high_frame_rate_sf_set_big_core_fps_threshold 119
     setprop debug.mtklog.netlog.enable 0
     setprop debug.mtklog.aee.Running 0
     setprop debug.mtklog.aee.enable 0
     setprop debug.mtklog.log2sd.path ""
     setprop debug.mtk.aee.db 0
     setprop debug.MB.running 0
   elif [[ "$soc" == "Qualcom" ]]; then
     setprop debug.qti.am.resource.type super-large
     setprop debug.qc.hardware true
     setprop debug.qctwa.preservebuf 1
     setprop debug.qualcomm.sns.libsensor1 0
     setprop debug.qualcomm.sns.daemon 0
     setprop debug.qualcomm.sns.hal 0
     setprop debug.qctwa.statusbar 1
   fi
  else
    echo " [$time] Fitur 3 is not-actived"
  fi
  if [[ "$menu4" == "true" ]]; then
    echo " [$time] Fitur 4 is actived smart system"
  else
    echo " [$time] Fitur 4 is not-actived"
  fi
  echo "[end system-running]"
  echo
}

smartSystemRmv() {
  echo
  echo "[start system-remove]"
  if [[ "$menu1" == "true" ]]; then
    echo " [$time] Fitur 1 is actived smart system"
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
        echo "  • masuk ke bypash mode"
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
    auto_sf_dyn $remove_sf 0
    other true 0 1
  else
    echo " [$time] Fitur 1 is not-actived"
  fi
  if [[ "$menu2" == "true" ]]; then
    echo " [$time] Fitur 2 is actived smart system"
    settings delete global updatable_driver_production_opt_in  >/dev/null 2>&1;
  else
    echo " [$time] Fitur 2 is not-actived"
  fi
  if [[ "$menu3" == "true" ]]; then
    echo " [$time] Fitur 3 is actived smart system"
    # source Code By kazuyo
    setprop debug.composition.type mdp
    setprop debug.hwc.dynThreshold 3.5
    setprop debug.enable.sglscale 0
    setprop debug.hwui.disable_vsync false
    setprop debug.hwui.target_gpu_time_percent 50
    setprop debug.gpuprio 5
    setprop debug.sf.gpu_freq_index 5
    setprop debug.sf.cpu_freq_index 5
    setprop debug.ioprio 5
    setprop debug.sf.mem_freq_index 5
    if [[ "$soc" == "Mediatek" ]]; then
     setprop debug.mediatek.appgamepq_compress 0
     setprop debug.mediatek.disp_decompress 0
     setprop debug.mediatek.appgamepq 1
     setprop debug.mediatek.game_pq_enable 0
     setprop debug.mediatek.high_frame_rate_sf_set_big_core_fps_threshold 90
     setprop debug.mtklog.netlog.enable 1
     setprop debug.mtklog.aee.Running 1
     setprop debug.mtklog.aee.enable 1
     setprop debug.mtklog.log2sd.path ""
     setprop debug.mtk.aee.db 1
     setprop debug.MB.running 1
   elif [[ "$soc" == "Qualcom" ]]; then
     setprop debug.qti.am.resource.type large
     setprop debug.qc.hardware false
     setprop debug.qctwa.preservebuf 0
     setprop debug.qualcomm.sns.libsensor1 1
     setprop debug.qualcomm.sns.daemon 1
     setprop debug.qualcomm.sns.hal 1
     setprop debug.qctwa.statusbar 0
   fi
  else
    echo " [$time] Fitur 3 is not-actived"
  fi
  if [[ "$menu4" == "true" ]]; then
    echo " [$time] Fitur 4 is actived smart system"
  else
    echo " [$time] Fitur 4 is not-actived"
  fi
  echo "[end system-remove]"
  echo
}

test_logic() {
  time=$(date "+%d-%m-%Y %H:%M")
  menu1=$(settings get global menu_gvr_smart_noxg1)
  menu2=$(settings get global menu_gvr_smart_noxg2)
  menu3=$(settings get global menu_gvr_smart_noxg3)
  menu4=$(settings get global menu_gvr_smart_noxg4)
   game=$(settings get global package_gvr_noxg)
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