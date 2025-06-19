$AXFUN

if [[ "$1" = "true" ]]; then
  am force-stop com.google.android.gms >/dev/null 2>&1
  cmd activity force-stop com.xiaomi.joyose >/dev/null 2>&1
  dumpsys deviceidle whitelist -com.google.android.gms >/dev/null 2>&1
  settings put global device_idle_constants "light_after_inactive_to=0,light_pre_idle_to=5000,light_idle_to=3600000,light_max_idle_to=43200000,locating_to=5000,location_accuracy=1000,inactive_to=0,sensing_to=0,motion_inactive_to=0,idle_after_inactive_to=0,idle_to=21600000,max_idle_to=172800000,quick_doze_delay_to=5000,min_time_to_alarm=300000,deep_idle_to=7200000,deep_max_idle_to=86400000,deep_idle_maintenance_max_interval=86400000,deep_idle_maintenance_min_interval=43200000,deep_still_threshold=0,deep_idle_prefetch=1,deep_idle_prefetch_delay=300000,deep_idle_delay_factor=2,deep_idle_factor=3" >/dev/null 2>&1
  settings put global app_restriction_enabled true >/dev/null 2>&1
  dumpsys deviceidle force-idle >/dev/null 2>&1
  dumpsys deviceidle step deep >/dev/null 2>&1
  echo "Disable GMS succesfuly"
else
  dumpsys deviceidle whitelist +com.google.android.gms >/dev/null 2>&1
  dumpsys deviceidle unforce >/dev/null 2>&1
  dumpsys deviceidle step active >/dev/null 2>&1
  settings delete global device_idle_constants >/dev/null 2>&1
  settings delete global app_restriction_enabled >/dev/null 2>&1
  dumpsys deviceidle disable >/dev/null 2>&1
  echo "Enable GMS succesfuly"
fi
