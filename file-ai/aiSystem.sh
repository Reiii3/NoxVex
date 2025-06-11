
test_logic() {
   source $file_update
   detected_apps=$(dumpsys window | grep "Window #" | grep WindowStateAnimator | grep -v "Window #0" | grep -Eo "$packageRun")
    render_detected=$(getprop debug.hwui.renderer)

   if [[  -n "$detected_apps" ]]; then
        if [[ "$gamerun" != "running" ]] && [[ "$render_detected" != "skiavk" ]]; then
           if [[ "$notif_run" != "run" ]]; then
              cmd notification post -S bigtext -t "NOXVER.AI RESPONSE" "nox_ai_status" "Game Mode : OFF  Engine : v1.1.XIO │ Status : Connected │ "
              echo "[DEBUG] : running notif"
              notif_run="run"
           fi
          gamerun="running"
        fi
    else
        if [[ "$gamerun" != "stopped" ]]; then
           if [[ "$notif_run" != "stop" ]]; then
              cmd notification post -S bigtext -t "NOXVER.AI RESPONSE" "nox_ai_status" "Game Mode : OFF  Engine : v1.1.XIO │ Status : Connected │ Developer : ReiiEja"
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