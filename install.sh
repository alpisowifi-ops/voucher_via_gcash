#!/data/data/com.termux/files/usr/bin/bash

clear
echo "🔥 INSTALLING PISO WIFI SYSTEM (FULL AUTO FINAL)..."

# UPDATE SYSTEM
pkg update -y && pkg upgrade -y

# INSTALL DEPENDENCIES
pkg install php git tmux termux-api termux-services iproute2 -y

# STORAGE (OPTIONAL PERMISSION)
echo "📂 Setting storage permission..."
termux-setup-storage 2>/dev/null

# REMOVE OLD INSTALL
rm -rf ~/htdocs

# CLONE PROJECT
echo "📥 Downloading project..."
git clone https://github.com/alpisowifi-ops/voucher_via_gcash.git ~/htdocs

cd ~/htdocs || exit

# FIX PERMISSIONS
chmod -R 777 .

# AUTO START ON BOOT
echo "⚙️ Setting auto-start..."
mkdir -p ~/.termux/boot

cat > ~/.termux/boot/start.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/sh

termux-wake-lock
cd ~/htdocs

# kill old session if exists
tmux kill-session -t wifi 2>/dev/null

# start server in background
tmux new-session -d -s wifi "php -S 0.0.0.0:8080"
EOF

chmod +x ~/.termux/boot/start.sh

# START SERVER NOW
echo "🚀 Starting server..."
tmux kill-session -t wifi 2>/dev/null
tmux new-session -d -s wifi "php -S 0.0.0.0:8080"

# GET IP (SAFE)
IP=$(ip route get 1 2>/dev/null | awk '{print $7;exit}')

if [ -z "$IP" ]; then
IP="localhost"
fi

# DONE
echo ""
echo "✅ INSTALL COMPLETE!"
echo "🌐 Open this in browser:"
echo "👉 http://$IP:8080"
echo ""
echo "🔐 Admin Panel:"
echo "👉 http://$IP:8080/admin.php"
echo "👉 Password: admin123"
echo ""
echo "⚡ Server running in background (tmux)"
echo "⚡ Auto start on reboot enabled"
echo ""
