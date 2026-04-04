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
    *)
        echo "Usage: $0 {start|stop|status}"
        exit 1
        ;;
esac