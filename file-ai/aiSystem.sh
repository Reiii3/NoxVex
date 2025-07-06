IDLE_TIME=5
gamerun=""
notif_run=""
time=$(date "+%d-%m-%Y %H:%M")
menu1=$(settings get global menu_gvr_smart_noxg1)
menu2=$(settings get global menu_gvr_smart_noxg2)
menu3=$(settings get global menu_gvr_smart_noxg3)
menu4=$(settings get global menu_gvr_smart_noxg4)

smartSystemRun() {
  echo
  echo "[start system-running]"
  if [[ "$menu1" == "true" ]]; then
    echo " [$time] Fitur 1 is actived smart system"
  else
    echo " [$time] Fitur 1 is not-actived"
  fi
  if [[ "$menu2" == "true" ]]; then
    echo " [$time] Fitur 2 is actived smart system"
  else
    echo " [$time] Fitur 2 is not-actived"
  fi
  if [[ "$menu3" == "true" ]]; then
    echo " [$time] Fitur 3 is actived smart system"
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
  else
    echo " [$time] Fitur 1 is not-actived"
  fi
  if [[ "$menu2" == "true" ]]; then
    echo " [$time] Fitur 2 is actived smart system"
  else
    echo " [$time] Fitur 2 is not-actived"
  fi
  if [[ "$menu3" == "true" ]]; then
    echo " [$time] Fitur 3 is actived smart system"
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
   game=$(settings get global package_gvr_noxg)
   detected_apps=$(dumpsys window | grep "Window #" | grep WindowStateAnimator | grep -v "Window #0" | grep -Eo "$game")
    render_detected=$(getprop debug.hwui.renderer)
   if [[  -n "$detected_apps" ]]; then
        if [[ "$gamerun" != "running" ]] && [[ "$render_detected" != "skiavk" ]]; then
           if [[ "$notif_run" != "run" ]]; then
              cmd notification post -S bigtext -t "Smart Syatem" "nox_ai_status" "Mode Game : ON"
              smartSystemRun
              notif_run="run"
           fi
          gamerun="running"
        fi
    else
        if [[ "$gamerun" != "stopped" ]]; then
           if [[ "$notif_run" != "stop" ]]; then
              cmd notification post -S bigtext -t "Smart Syatem" "nox_ai_status" "Mode Game : OFF"
              notif_run="stop"
              smartSystemRmv
           fi
          gamerun="stopped"
        fi
   fi
}

while true; do
    test_logic
    echo
    echo "DEBUG by looping : loop berhasil dijalankan"
    echo "DEBUG by looping : loop akan berulang setiap ${IDLE_TIME} detik"
    echo "DEBUG by looping : status noti : $notif_run"
    echo "DEBUG by looping : status game : $gamerun"
    echo "DEBUG by looping : apk $detected_apps run"
    echo
    sleep "$IDLE_TIME"
done