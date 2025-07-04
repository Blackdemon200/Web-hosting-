#!/bin/bash

echo "🟢 تم بدء تنفيذ سكربت التثبيت الخاص بـ PRO HOSTING بنجاح!"
sleep 2

# تحديث النظام
apt update && apt upgrade -y

# تثبيت الحزم الأساسية
apt install -y apache2 php php-mysql mariadb-server unzip curl python3 python3-pip nodejs npm zip ufw htop

# تفعيل الخدمات
systemctl enable apache2 mariadb
systemctl start apache2 mariadb

# إعداد MySQL وتأمينه
echo "⚙️ إعداد قاعدة البيانات..."
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'prohosting123'; FLUSH PRIVILEGES;"
mysql -uroot -pprohosting123 -e "CREATE DATABASE mysite_db;"

# تثبيت Composer
curl -sSL https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# تثبيت أدوات node / python
npm install -g pm2
pip3 install flask gunicorn

# اكتشاف نوع المشروع (بدائي)
if ls /var/www/html | grep -qi "wp-config.php"; then
  project_type="WordPress"
elif ls /var/www/html | grep -qi "index.php"; then
  project_type="PHP"
elif ls /var/www/html | grep -qi "index.html"; then
  project_type="HTML"
else
  project_type="غير محدد (ارفع ملفاتك)"
fi

# إنشاء صفحة index تلقائية
if [ ! -f /var/www/html/index.html ]; then
echo '<!DOCTYPE html>
<html lang="ar" dir="rtl"><head><meta charset="UTF-8"><title>🌀 موقعك قيد الإنشاء</title></head>
<body style="background-color:#111;color:#f1c40f;font-family:sans-serif;text-align:center;padding:100px;">
<h1>🚀 أهلاً بك في استضافة PRO HOSTING</h1>
<p>تم تثبيت البيئة بنجاح ✔️</p>
<p>نوع المشروع المتوقع: <b>'"$project_type"'</b></p>
<p>ضع ملفاتك داخل <code>/var/www/html/</code></p>
</body></html>' > /var/www/html/index.html
fi

# حماية أساسية عبر UFW
ufw allow OpenSSH
ufw allow 'Apache Full'
ufw --force enable

echo "✅ تم التثبيت الكامل بنجاح!"
echo "🧠 قاعدة البيانات: mysite_db"
echo "👤 المستخدم: root | كلمة المرور: prohosting123"
echo "📁 المسار: /var/www/html/"
echo "🔗 مثال: http://your-ip/wp-admin"
