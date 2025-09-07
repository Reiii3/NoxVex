IDLE_TIME=5
gamerun=""
notif_run=""

test_logic() {
   time=$(date "+%d-%m-%Y %H:%M")
   game=$(settings get global package_list_orsai)
   detected_apps=$(dumpsys activity processes | grep top-activity | cut -d ':' -f4 | cut -d '/' -f1 | head -n 1)
   render_detected=$(getprop debug.hwui.renderer)
   if [[  -n "$detected_apps" ]]; then
      if [[ "$detected_apps" = "$game" ]]; then
         if [[ "$gamerun" != "running" ]] && [[ "$render_detected" != "skiavk" ]]; then
            if [[ "$notif_run" != "run" ]]; then
               cmd notification post -S bigtext -t '️Smart System🔄' -i file:///sdcard/VortexModules/NOXG/vmods.png -I file:///sdcard/VortexModules/NOXG/vmods.png "noxg_engine_mode" "Game Mode : ON Game Mode On In Time : $time" >/dev/null 2>&1
                  notif_run="run"
            fi
            gamerun="running"
            echo "Package : $detected_apps"
         fi
      else 
         if [[ "$gamerun" != "stopped" ]]; then
            if [[ "$notif_run" != "stop" ]]; then
               cmd notification post -S bigtext -t '️Smart System🔄' -i file:///sdcard/VortexModules/NOXG/vmods.png -I file:///sdcard/VortexModules/NOXG/vmods.png "noxg_engine_mode" "Game Mode : OFF Game Mode Off In Time : $time" >/dev/null 2>&1
               notif_run="stop"
            fi
            gamerun="stopped"
            echo "Package : $detected_apps"
         fi
      fi
   fi
}

while true; do
   test_logic
   sleep "$IDLE_TIME"
done