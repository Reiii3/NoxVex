engineStart() {
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
    android=$1
    pkg=$2
    value_downscale=$3
    value_angle=$4
    value_frame=$5

    if [[ "$android" -gt 30 ]]; then
        device_config put game_overlay $pkg mode=2,downscaleFactor=$value_downscale,useAngle=$value_angle,fps=$value_frame,loadingBoost=999999999
        cmd game set --mode 2 --downscale $value_downscale --angle $value_angle --fps $value_frame $pkg
    else
        device_config put game_overlay $pkg mode=2,downscaleFactor=$value_downscale,useAngle=$value_angle,fps=$value_frame,loadingBoost=999999999
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