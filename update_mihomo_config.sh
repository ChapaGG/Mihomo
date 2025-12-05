#!/bin/sh

# Скрипт для обновления конфигурации xkeen
# Сохраните как /opt/etc/update_mihomo_config.sh и сделайте исполняемым:
# chmod +x /opt/etc/update_mihomo_config.sh

# Пути к файлам
GITHUB_URL="https://raw.githubusercontent.com/ваш_username/ваш_репозиторий/main/config.yaml"
TEMP_CONFIG="/opt/tmp/config.yaml"
PROXIES_FILE="/opt/etc/xkeen/proxies.yaml"
CONFIG_FILE="/opt/etc/xkeen/config.yaml"
BACKUP_DIR="/opt/backup/xkeen"
LOG_FILE="/opt/var/log/xkeen_update.log"

# Создаем директории если их нет
mkdir -p /opt/tmp
mkdir -p "$(dirname "$PROXIES_FILE")"
mkdir -p "$BACKUP_DIR"

# Функция для логирования
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
    echo "$1"
}

# Функция для создания бэкапа
create_backup() {
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    cp "$CONFIG_FILE" "$BACKUP_DIR/config_${timestamp}.yaml" 2>/dev/null
    cp "$PROXIES_FILE" "$BACKUP_DIR/proxies_${timestamp}.yaml" 2>/dev/null
    log_message "Бэкапы созданы в $BACKUP_DIR"
}

# Функция для проверки наличия команд
check_commands() {
    local missing_commands=""
    
    for cmd in wget curl; do
        if command -v $cmd >/dev/null 2>&1; then
            DOWNLOADER=$cmd
            log_message "Используется $cmd для загрузки"
            return 0
        fi
    done
    
    log_message "Ошибка: Не найден ни wget, ни curl"
    exit 1
}

# Функция для загрузки файла
download_file() {
    log_message "Загрузка config.yaml с GitHub..."
    
    if [ "$DOWNLOADER" = "wget" ]; then
        wget -q "$GITHUB_URL" -O "$TEMP_CONFIG"
    elif [ "$DOWNLOADER" = "curl" ]; then
        curl -s -o "$TEMP_CONFIG" "$GITHUB_URL"
    fi
    
    if [ $? -ne 0 ] || [ ! -f "$TEMP_CONFIG" ]; then
        log_message "Ошибка: Не удалось загрузить файл с GitHub"
        exit 1
    fi
    
    log_message "Файл успешно загружен"
}

# Функция для объединения файлов
merge_files() {
    log_message "Объединение proxies.yaml и config.yaml..."
    
    # Проверяем существование файлов
    if [ ! -f "$PROXIES_FILE" ]; then
        log_message "Внимание: $PROXIES_FILE не существует, создаем пустой файл"
        touch "$PROXIES_FILE"
    fi
    
    if [ ! -f "$TEMP_CONFIG" ]; then
        log_message "Ошибка: $TEMP_CONFIG не существует"
        exit 1
    fi
    
    # Создаем бэкап текущих файлов
    create_backup
    
    # Объединяем файлы
    # Вариант 1: Простое объединение (прокси сверху, конфиг снизу)
    {
        echo "# === PROXIES SECTION ==="
        cat "$PROXIES_FILE"
        echo ""
        echo "# === MAIN CONFIG SECTION ==="
        cat "$TEMP_CONFIG"
    } > "$CONFIG_FILE"
    
    # Вариант 2: Если нужен YAML-валидный файл (раскомментировать если нужно)
    # {
    #     cat "$PROXIES_FILE"
    #     echo "---"
    #     cat "$TEMP_CONFIG"
    # } > "$CONFIG_FILE"
    
    log_message "Файлы успешно объединены в $CONFIG_FILE"
}

# Функция для перезапуска xkeen
restart_xkeen() {
    log_message "Перезапуск xkeen..."
    
    # Проверяем, как установлен xkeen и как его перезапускать
    if [ -f /opt/etc/init.d/Sxxkeen ]; then
        /opt/etc/init.d/Sxxkeen restart
    elif [ -f /opt/etc/init.d/xkeen ]; then
        /opt/etc/init.d/xkeen restart
    elif pgrep xkeen >/dev/null; then
        pkill xkeen
        sleep 2
        # Запуск xkeen (уточните путь к вашему исполняемому файлу)
        /opt/usr/bin/xkeen -c "$CONFIG_FILE" &
    else
        log_message "xkeen не запущен, попытка запуска..."
        /opt/usr/bin/xkeen -c "$CONFIG_FILE" &
    fi
    
    sleep 3
    
    # Проверяем, запустился ли xkeen
    if pgrep xkeen >/dev/null; then
        log_message "xkeen успешно перезапущен"
    else
        log_message "Внимание: xkeen возможно не запустился"
    fi
}

# Функция для очистки временных файлов
cleanup() {
    rm -f "$TEMP_CONFIG"
    log_message "Временные файлы очищены"
}

# Основной скрипт
main() {
    log_message "=== Начало обновления xkeen ==="
    
    # Проверяем доступные команды
    check_commands
    
    # Загружаем файл
    download_file
    
    # Объединяем файлы
    merge_files
    
    # Перезапускаем xkeen
    restart_xkeen
    
    # Очищаем временные файлы
    cleanup
    
    log_message "=== Обновление завершено успешно ==="
}

# Запуск скрипта
main
