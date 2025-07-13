#!/bin/bash

# Prompt for input
read -rp "Enter the new username to create: " NEW_USER
read -rp "Enter the remote server IP (e.g., 192.168.1.10): " SERVER_IP
read -rp "Enter the full path to the public key file (e.g., ~/.ssh/id_rsa.pub): " PUBKEY_PATH

# Expand ~ if used
PUBKEY_PATH="${PUBKEY_PATH/#\~/$HOME}"

# Validate public key
if [[ ! -f "$PUBKEY_PATH" ]]; then
  echo "❌ Error: Public key file not found at $PUBKEY_PATH"
  exit 1
fi

# Upload public key to server
echo "📤 Uploading public key to $SERVER_IP..."
scp "$PUBKEY_PATH" root@"$SERVER_IP":/tmp/${NEW_USER}_pubkey.pub || {
  echo "❌ Failed to upload public key."
  exit 1
}

# SSH and configure remote user
echo "⚙️ Creating user $NEW_USER on $SERVER_IP..."

ssh root@"$SERVER_IP" bash <<EOF
# Exit if user already exists
if id "$NEW_USER" &>/dev/null; then
  echo "⚠️ User $NEW_USER already exists. Aborting."
  exit 1
fi

# Create user without password
adduser --disabled-password --gecos "" "$NEW_USER"

# Give sudo access
usermod -aG sudo "$NEW_USER"

# Setup SSH directory and authorized_keys
mkdir -p /home/$NEW_USER/.ssh
cat /tmp/${NEW_USER}_pubkey.pub > /home/$NEW_USER/.ssh/authorized_keys

# Set correct permissions
chmod 700 /home/$NEW_USER/.ssh
chmod 600 /home/$NEW_USER/.ssh/authorized_keys
chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/.ssh

# Lock password login (SSH only)
passwd -l $NEW_USER

# Remove temporary key file
rm -f /tmp/${NEW_USER}_pubkey.pub

# Reload SSH service
echo "🔁 Reloading SSH service..."
systemctl reload ssh || systemctl restart ssh

echo "✅ User $NEW_USER created with SSH-only access, and sshd reloaded."
EOF
