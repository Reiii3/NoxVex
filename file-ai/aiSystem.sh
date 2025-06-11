IDLE_TIME=5
gamerun=""
notif_run=""
test_logic() {
   game=$(settings get global package_gvr_noxg)
   detected_apps=$(dumpsys window | grep "Window #" | grep WindowStateAnimator | grep -v "Window #0" | grep -Eo "$game")
    render_detected=$(getprop debug.hwui.renderer)
   if [[  -n "$detected_apps" ]]; then
        if [[ "$gamerun" != "running" ]] && [[ "$render_detected" != "skiavk" ]]; then
           if [[ "$notif_run" != "run" ]]; then
              cmd notification post -S bigtext -t "Smart Syatem" "nox_ai_status" "Smart Sytem mode Game : ON"
              echo "[DEBUG] : running notif"
              notif_run="run"
           fi
          gamerun="running"
        fi
    else
        if [[ "$gamerun" != "stopped" ]]; then
           if [[ "$notif_run" != "stop" ]]; then
              cmd notification post -S bigtext -t "Smart Syatem" "nox_ai_status" "Smart Sytem mode Game : OFF"
              notif_run="stop"
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