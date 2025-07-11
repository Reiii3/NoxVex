$AXFUN

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

main_active() {
  auto_sf_dyn $run_sf 1
  other false 1 0
}

main_remove() {
  auto_sf_dyn $remove_sf 0
  other true 0 1
}

if [[ "$1" = "true" ]]; then
   main_active
   echo "Dynamic SufaceFlinger Active, Fps Locked $refresh_rate"
else
  main_remove
  echo "Dynamic SufaceFlinger Non-Active"
fi


#------------------CREDIT @Kazuyoo-----------------