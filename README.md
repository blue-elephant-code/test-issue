# test-issue

```markdown
# Шаг 1: Установка прав на скрипт
sudo chmod +x /usr/local/bin/monitoring_test.sh

# Шаг 2: Создание systemd-сервиса (скопировать в /etc/systemd/system/monitoring_test.service)
[Unit]
Description=Monitoring Service for Test Process
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/monitoring_test.sh
User=root

# Шаг 3: Создание таймера (скопировать в /etc/systemd/system/monitoring_test.timer)
[Unit]
Description=Run Monitoring Script Every Minute

[Timer]
OnBootSec=60
OnUnitActiveSec=60
Unit=monitoring_test.service

[Install]
WantedBy=timers.target

# Шаг 4: Активация сервиса
sudo systemctl daemon-reload
sudo systemctl enable monitoring_test.timer
sudo systemctl start monitoring_test.timer

# Шаг 5: Настройка лог-файла
sudo touch /var/log/monitoring.log
sudo chown root:root /var/log/monitoring.log
sudo chmod 644 /var/log/monitoring.log

# Шаг 6: Проверка работы
tail -f /var/log/monitoring.log
systemctl status monitoring_test.timer
```