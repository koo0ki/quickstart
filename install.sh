#!/bin/bash

# Функция для красивого вывода
print_message() {
    echo "----------------------------------------"
    echo "$1"
    echo "----------------------------------------"
}

print_message "Обновление системы..."
sudo apt update
sudo apt upgrade -y

print_message "Установка MongoDB..."
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] http://repo.mongodb.org/apt/debian $(lsb_release -cs)/mongodb-org/7.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod

print_message "Установка NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

print_message "Установка Node.js 20.x..."
nvm install 20
nvm use 20

print_message "Установка TypeScript..."
npm install -g typescript

print_message "Установка PM2..."
npm install -g pm2

print_message "Проверка установленных компонентов:"
echo "MongoDB: $(mongod --version | grep 'db version' | cut -d ' ' -f 3)"
echo "Node.js: $(node -v)"
echo "NPM: $(npm -v)"
echo "TypeScript: $(tsc -v)"
echo "PM2: $(pm2 -v)"

echo "
    _              ___   _    _ 
   | |             / _ \ | |  (_)
   | | ___   ___  | | | || | _ 
   | |/ / _ \/ _ \| | | || |/ /
   |   < (_) | (_) \ \_/ /|   < 
   |_|\_\___/ \___/ \___/ |_|\_\\
                                                           
         Установка завершена успешно!
"