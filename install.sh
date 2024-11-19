#!/bin/bash

# Функция для красивого вывода
print_message() {
    echo "----------------------------------------"
    echo "$1"
    echo "----------------------------------------"
}

check_status() {
    if [ $? -ne 0 ]; then
        echo "Ошибка: $1"
        exit 1
    fi
}

print_message "Обновление системы..."
apt update
apt install sudo gpg
check_status "Не удалось обновить систему"

print_message "Установка MongoDB..."

curl -fsSL https://pgp.mongodb.com/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
check_status "Не удалось импортировать GPG ключ"

echo "deb [signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg] http://repo.mongodb.org/apt/debian $(lsb_release -cs)/mongodb-org/7.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
check_status "Не удалось добавить репозиторий MongoDB"

sudo apt update
check_status "Не удалось обновить пакеты после добавления репозитория"
sudo apt install -y mongodb-org
check_status "Не удалось установить MongoDB"

sudo systemctl start mongod
sudo systemctl enable mongod
check_status "Не удалось запустить MongoDB"

print_message "Установка NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
check_status "Не удалось установить NVM"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

print_message "Установка Node.js 20.x..."
nvm install 20
check_status "Не удалось установить Node.js"

nvm use 20

print_message "Установка TypeScript..."
npm install -g typescript
check_status "Не удалось установить TypeScript"

print_message "Установка PM2..."
npm install -g pm2
check_status "Не удалось установить PM2"

print_message "Проверка установленных компонентов:"
echo "MongoDB: $(mongod --version | grep 'db version' | cut -d ' ' -f 3)"
echo "Node.js: $(node -v)"
echo "NPM: $(npm -v)"
echo "TypeScript: $(tsc -v)"
echo "PM2: $(pm2 -v)"

echo "
    _              ___   _    _ 
   | |             / _ \ | |  (_)
   | | ___   ___  | | |  | _ 
   | |/ / _ \/ _ \| | |  |/ /
   |   < (_) | (_) \ \_/ /|   < 
   |_|\_\___/ \___/ \___/ |_|\_\\
                                                           
         Установка завершена успешно!
"
