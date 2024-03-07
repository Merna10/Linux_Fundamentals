#!/usr/bin/bash -i

list_process(){
    ps aux
}
process_information(){
    read -p "Enter process ID: " pid
    echo "the information of $pid process is "
    ps -p "$pid" -o pid,ppid,user,%cpu,%mem,cmd

}
kill_process(){
    read -p "Enter process ID: " pid
    kill $pid
    echo "the $pid process is killed"

}
process_statistics(){
    top -n 1
}
real-time_monitoring(){
    clear
    echo "Press Ctrl+C to exit real-time monitoring."
    top
}
search_processes() {
    read -p "Enter search term: " term
    ps aux | grep "$term"
}
interactive_mode(){
    echo "Menu"
    echo "1. List processes"
    echo "2. Process information"
    echo "3. Kill a process"
    echo "4. System statistics"
    echo "5. Real-time monitoring"
    echo "6. Search and filter processes"
    read -p "Choose Operation: " operation
    case "${operation}" in
        1)
            list_process
        ;;
        2)
            process_information
        ;;
        3)
            kill_process
        ;;
        4)
            process_statistics
        ;;
        5)
            real-time_monitoring
        ;;
        6)
            search_processes
        ;;
    esac
    
}
resource_alerts() {
    
    source process_monitor.conf 
    
    while true; do
        # Get CPU and memory usage
        cpu_usage=$(top -bn1 | awk '/^%Cpu/ {print $2}' | cut -d. -f1)
        mem_usage=$(free | awk '/Mem/ {print $3/$2 * 100.0}' | cut -d. -f1)

        if [ $cpu_usage -gt $CPU_ALERT_THRESHOLD ]; then
            echo "Alert: CPU '$cpu_usage%' usage exceeded threshold'$CPU_ALERT_THRESHOLD%'!"

        fi

        if [ $mem_usage -gt $MEMORY_ALERT_THRESHOLD ]; then
            echo "Alert: Memory '$mem_usage%' usage exceeded threshold'$MEMORY_ALERT_THRESHOLD%'!"
        fi

    done
}
log_activity() {
    LOG_FILE="process_monitor.log"
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $message" >> "$LOG_FILE"
}
main(){
    resource_alerts &
    log_activity "Process Monitor script started."
    interactive_mode
    log_activity "Process Monitor script ended."
}
main