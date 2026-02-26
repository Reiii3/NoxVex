# Perf mode
settings put global power_check_max_cpu_1 210
settings put global power_check_max_cpu_2 310
settings put global power_check_max_cpu_3 120
settings put global power_check_max_cpu_4 120
setprop debug.hwui.target_power_time_percent 200
setprop debug.hwui.target_cpu_time_percent 200
setprop debug.hwui.target_gpu_time_percent 200
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

# dyn
settings put global power_check_max_cpu_1 310
settings put global power_check_max_cpu_2 370
settings put global power_check_max_cpu_3 140
settings put global power_check_max_cpu_4 170
setprop debug.hwui.target_power_time_percent 210
setprop debug.hwui.target_cpu_time_percent 210
setprop debug.hwui.target_gpu_time_percent 210
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

# low
settings put global power_check_max_cpu_1 150
settings put global power_check_max_cpu_2 210
settings put global power_check_max_cpu_3 90
settings put global power_check_max_cpu_4 90
setprop debug.hwui.target_power_time_percent 200
setprop debug.hwui.target_cpu_time_percent 200
setprop debug.hwui.target_gpu_time_percent 200
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
