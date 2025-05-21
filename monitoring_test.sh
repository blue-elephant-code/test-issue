#!/bin/bash

# Проверка наличия процесса test
CURRENT_PID=$(pgrep -x test)

# Пути к файлам
PID_FILE="/var/run/monitoring_test.pid"
LOG_FILE="/var/log/monitoring.log"

# Если процесс запущен
if [ -n "$CURRENT_PID" ]; then
    # Отправка HTTP-запроса
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://test.com/monitoring/test/api" 2>/dev/null)
    CURL_EXIT=$?

    # Логирование ошибок сервера
    if [ $CURL_EXIT -ne 0 ] || [ "$HTTP_STATUS" != "200" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Monitoring server error (Curl: $CURL_EXIT, HTTP: $HTTP_STATUS)" >> "$LOG_FILE"
    fi

    # Проверка перезапуска процесса
    if [ -f "$PID_FILE" ]; then
        PREVIOUS_PID=$(cat "$PID_FILE")
        if [ "$PREVIOUS_PID" != "$CURRENT_PID" ]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Process test restarted. New PID: $CURRENT_PID" >> "$LOG_FILE"
        fi
    fi

    # Обновление PID
    echo "$CURRENT_PID" > "$PID_FILE"
else
    # Очистка PID-файла, если процесс не запущен
    [ -f "$PID_FILE" ] && rm "$PID_FILE"
fi