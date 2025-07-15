$AXFUN

soc=$(getprop ro.soc.manufacturer)

if [[ "$1" = "true" ]]; then
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
  setprop debug.cpu_core_ctl_active 1
  setprop debug.cpu_core_ctl_busy_down_thres 35
  setprop debug.cpu_core_ctl_busy_up_thres 70
  setprop debug.cpu_core_ctl_max_cores 8
  if [[ "$soc" == "Mediatek" ]]; then
   setprop debug.mediatek.appgamepq_compress 1
   setprop debug.mediatek.disp_decompress 1
   setprop debug.mediatek.appgamepq 2
   setprop debug.mediatek.game_pq_enable 1
   setprop debug.mediatek.high_frame_rate_sf_set_big_core_fps_threshold 119
   setprop debug.mtklog.netlog.enable "0"
   setprop debug.mtklog.aee.Running "0"
   setprop debug.mtklog.aee.enable "0"
   setprop debug.mtklog.log2sd.path ""
 elif [[ "$soc" == "Qualcom" ]]; then
   setprop debug.qti.am.resource.type "super-large"
   setprop debug.qc.hardware "true"
   setprop debug.qctwa.statusbar "1"
   setprop debug.qctwa.preservebuf "1"
 fi
  echo "Chipset Optimizer Actived"
else
  setprop debug.composition.type gpu
  setprop debug.hwc.dynThreshold 2.5
  setprop debug.enable.sglscale 0
  setprop debug.hwui.disable_vsync false
  setprop debug.hwui.target_gpu_time_percent 70
  setprop debug.gpuprio 5
  setprop debug.sf.gpu_freq_index 5
  setprop debug.ioprio 5
  setprop debug.sf.cpu_freq_index 5
  setprop debug.sf.mem_freq_index 5
  setprop debug.cpu_core_ctl_active 0
  setprop debug.cpu_core_ctl_busy_down_thres 35
  setprop debug.cpu_core_ctl_busy_up_thres 50
  setprop debug.cpu_core_ctl_max_cores 4
  if [[ "$soc" == "Mediatek" ]]; then
   setprop debug.mediatek.appgamepq_compress 0
   setprop debug.mediatek.disp_decompress 0
   setprop debug.mediatek.appgamepq 0
   setprop debug.mediatek.game_pq_enable p
   setprop debug.mediatek.high_frame_rate_sf_set_big_core_fps_threshold 80
 elif [[ "$soc" == "Qualcom" ]]; then
   setprop debug.qti.am.resource.type ""
   setprop debug.qc.hardware "false"
   setprop debug.qctwa.statusbar "0"
   setprop debug.qctwa.preservebuf "0"
 fi
  echo "Chipset Optimizer Non-Active"
fi
