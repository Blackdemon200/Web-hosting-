#!/bin/bash

echo "🔧 جاري تثبيت بيئة استضافة المواقع..."
sleep 1

# تحديث النظام
apt update && apt upgrade -y

# تثبيت الحزم الأساسية
apt install -y apache2 php php-mysql mariadb-server unzip curl python3 python3-pip nodejs npm

# تفعيل الخدمات
systemctl enable apache2 mariadb
systemctl start apache2 mariadb

# تثبيت Composer
curl -sSL https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# تثبيت أدوات node / python
npm install -g pm2
pip3 install flask gunicorn

echo "✅ تم التثبيت بنجاح!"
echo "📁 ضع ملفات موقعك في: /var/www/html/"
echo "🌐 إذا كنت تستخدم WordPress، فقط ادخل: http://your-ip/wp-admin"
