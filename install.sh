#!/data/data/com.termux/files/usr/bin/bash

clear
echo "🔥 INSTALLING PISO WIFI SYSTEM..."

pkg update -y
pkg upgrade -y

pkg install php git termux-api termux-services -y

echo "📂 Setting up storage..."
termux-setup-storage

sleep 3

mkdir -p /sdcard/htdocs

echo "📥 Cloning project to htdocs..."
git clone https://github.com/alpisowifi-ops/voucher_via_gcash.git /sdcard/htdocs

echo "⚙️ Setting auto-start..."

mkdir -p ~/.termux/boot

cat > ~/.termux/boot/start.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/sh

termux-wake-lock
cd /sdcard/htdocs
php -S 0.0.0.0:8080
EOF

chmod +x ~/.termux/boot/start.sh

echo "🚀 Starting server..."
cd /sdcard/htdocs
php -S 0.0.0.0:8080