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
        echo "[+] QiunixAI berhasil diaktifkan"
    else
        echo "[!] QiunixAI gagal diaktifkan"
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
    echo "[+] QiunixAI berhasil dinonaktifkan"
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

ram_compact_run() {
    if [[ -f /data/local/tmp/qiunixai.pid ]]; then
        PID=$(cat /data/local/tmp/ram_compact.pid)
        if kill -0 $PID > /dev/null 2>&1; then
            echo "QiunixAI sedang berjalan"
            return
        else 
            rm -f /data/local/tmp/ram_compact.pid
            rm -f /data/local/tmp/ram_compact.log
        fi
    fi

    nohup /data/user_de/0/com.android.shell/axeron/xbin/ram_compact > /data/local/tmp/qiunixai.log 2>&1 &
    # Menyimpan PID ke file
    echo $! > /data/local/tmp/ram_compact.pid

    if [[ -f /data/local/tmp/ram_compact.pid ]]; then
        echo "[+] Ram Compact berhasil diaktifkan"
    else
        echo "[!] Ram Compact gagal diaktifkan"
    fi
}

ram_compact_stop() {
    if [[ ! -f /data/local/tmp/ram_compact.pid ]]; then
        echo "QiunixAI sedang tidak aktif"
        exit 0
    fi

    PID=$(cat /data/local/tmp/ram_compact.pid)
    if ! kill -0 $PID > /dev/null 2>&1; then
        rm -f /data/local/tmp/ram_compact.pid
        rm -f /data/local/tmp/ram_compact.log
        echo "QiunixAI sedang tidak aktif"
        exit 0
    fi

    kill $PID
    rm -f /data/local/tmp/ram_compact.pid
    rm -f /data/local/tmp/ram_compact.log
    echo "[+] QiunixAI berhasil dinonaktifkan"
}

ram_compact_status() {
    if [[ -f /data/local/tmp/ram_compact.pid ]]; then
        PID=$(cat /data/local/tmp/ram_compact.pid)
        if kill -0 $PID > /dev/null 2>&1; then
            echo "RUNNING PID: $PID"
        else
            rm -f /data/local/tmp/ram_compact.pid
            rm -f /data/local/tmp/ram_compact.log
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
    "--ram_compact_start" )
        ram_compact_run
        ;;
    "--ram_compact_stop" )
        ram_compact_stop
        ;;
    "--ram_compact_status" )
        ram_compact_status
        ;;
    *)
        echo "Usage: $0 {start|stop|status}"
        exit 1
        ;;
esac