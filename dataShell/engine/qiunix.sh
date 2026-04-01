engineStart() {
    chmod 777 /data/user_de/0/com.android.shell/axeron/xbin/qiunixAI
    if [[ -f /data/local/tmp/qiunixai.pid ]]; then
        PID=$(cat /data/local/tmp/qiunixai.pid)
        if kill -0 $PID > /dev/null 2>&1; then
            echo "QiunixAI sedang berjalan"
            return
        else 
            rm -f /data/local/tmp/qiunixai.pid
            rm -f /data/local/tmp/qiunixai.log
        fi
    fi

    nohup /data/user_de/0/com.android.shell/axeron/xbin/qiunixAI > /data/local/tmp/qiunixai.log 2>&1 &
    # Menyimpan PID ke file
    echo $! > /data/local/tmp/qiunixai.pid

    if [[ -f /data/local/tmp/qiunixai.pid ]]; then
        echo "QiunixAI berhasil diaktifkan"
    else
        echo "QiunixAI gagal diaktifkan"
    fi
}

engineStop() {
    if [[ ! -f /data/local/tmp/qiunixai.pid ]]; then
        echo "QiunixAI sedang tidak aktif"
        exit 0
    fi

    PID=$(cat /data/local/tmp/qiunixai.pid)
    if ! kill -0 $PID > /dev/null 2>&1; then
        rm -f /data/local/tmp/qiunixai.pid
        rm -f /data/local/tmp/qiunixai.log
        echo "QiunixAI sedang tidak aktif"
        exit 0
    fi

    kill $PID
    rm -f /data/local/tmp/qiunixai.pid
    rm -f /data/local/tmp/qiunixai.log
    echo "QiunixAI berhasil dinonaktifkan"
}

engineStatus() {
    if [[ -f /data/local/tmp/qiunixai.pid ]]; then
        PID=$(cat /data/local/tmp/qiunixai.pid)
        if kill -0 $PID > /dev/null 2>&1; then
            echo "RUNNING PID: $PID"
        else
            rm -f /data/local/tmp/qiunixai.pid
            rm -f /data/local/tmp/qiunixai.log
            echo "STOPPED"
        fi
    else
        echo "STOPPED"
    fi
}

downscale() {
    android=$2
    pkg=$3
    downscale=$4
    angle=$5
    frame=$6
    if [[ "$android" -gt "34" ]]; then
        device_config put game_overlay $pkg mode=2,downscaleFaktor=$downscale,useAngle=$angle,fps=$frame,loadingBoost=999999999
        cmd game set --mode 2 --downscale $downscale --angle $angle --fps $frame $pkg
    elif [[ "$android" -le "30" ]]; then
        device_config put game_overlay $pkg mode=2,downscaleFaktor=$downscale,useAngle=$angle,fps=$frame,loadingBoost=999999999
        cmd game mode 2 $pkg
    fi
}

case "$1" in
    "--start" )
        engineStart
        ;;
    "--stop" )
        engineStop
        ;;
    "--status" )
        engineStatus
        ;;
    "--downscale" )
        downscale "$2" "$3" "$4" "$5" "$6"
        ;;
    *)
        echo "Usage: $0 {start|stop|status}"
        exit 1
        ;;
esac