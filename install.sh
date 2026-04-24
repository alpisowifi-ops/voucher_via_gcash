#!/data/data/com.termux/files/usr/bin/bash

clear
echo "🔥 INSTALLING PISO WIFI SYSTEM (FULL AUTO)..."

# UPDATE SYSTEM
pkg update -y && pkg upgrade -y

# INSTALL DEPENDENCIES
pkg install php git tmux termux-api termux-services -y

# STORAGE PERMISSION
echo "📂 Setting storage permission..."
termux-setup-storage
sleep 5

# CLEAN OLD INSTALL
rm -rf ~/htdocs

# CLONE PROJECT
echo "📥 Downloading project..."
git clone https://github.com/alpisowifi-ops/voucher_via_gcash.git ~/htdocs

cd ~/htdocs

# FIX PERMISSIONS
chmod -R 777 .

# AUTO START ON BOOT
echo "⚙️ Setting auto-start..."
mkdir -p ~/.termux/boot

cat > ~/.termux/boot/start.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/sh

termux-wake-lock
cd ~/htdocs

# run inside tmux (background)
tmux new-session -d -s wifi "php -S 0.0.0.0:8080"
EOF

chmod +x ~/.termux/boot/start.sh

# START SERVER NOW (BACKGROUND)
echo "🚀 Starting server..."
tmux new-session -d -s wifi "php -S 0.0.0.0:8080"

# DONE
IP=$(ip route get 1 | awk '{print $7;exit}')

echo ""
echo "✅ INSTALL COMPLETE!"
echo "🌐 Open this in browser:"
echo "👉 http://$IP:8080"
echo ""
echo "🔐 Admin:"
echo "👉 http://$IP:8080/admin.php"
echo "👉 Password: admin123"
echo ""
echo "⚡ Server runs in background (tmux)"
echo "⚡ Auto start on reboot enabled"
echo ""
