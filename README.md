
---

# Create_user_linux

A Bash script for automated user creation and SSH key setup on a remote Linux server.

## Overview

`createUser.sh` simplifies the process of adding a new user to a remote Linux server, configuring their SSH access, and granting sudo privileges. It also ensures that password login is disabled for the new user, enforcing key-based authentication for added security.

## Features

- Prompts for essential information (username, server IP, public key path)
- Uploads the specified SSH public key to the remote server
- Creates a new user account (if it doesn’t already exist)
- Grants sudo access to the new user
- Sets up SSH-only access for the new user (disables password login)
- Reloads the SSH service to apply changes
- Cleans up temporary files

## Prerequisites

- Bash shell
- `ssh` and `scp` installed locally
- Root access to the remote server
- The remote server should be running a Linux distribution (Debian/Ubuntu with adduser, usermod, sudo, etc.)
- Your public key file available on your local system

## Usage

1. Clone this repository or download `createUser.sh`.
2. Make the script executable:

   ```bash
   chmod +x createUser.sh
   ```

3. Run the script:

   ```bash
   ./createUser.sh
   ```

4. When prompted, enter:
   - The username to create
   - The remote server’s IP address
   - The full path to your public key file (e.g., `~/.ssh/id_rsa.pub`)

## Example

```bash
./createUser.sh
```

Sample prompts and responses:

```
Enter the new username to create: alice
Enter the remote server IP (e.g., 192.168.1.10): 192.168.1.10
Enter the full path to the public key file (e.g., ~/.ssh/id_rsa.pub): ~/.ssh/id_rsa.pub
```

## What the Script Does

- Validates the provided public key file path
- Securely copies the public key to the remote server
- Connects to the server as root via SSH
- Checks if the user already exists (aborts if true)
- Creates the user, adds them to the sudo group
- Sets up SSH access and disables password login for the user
- Reloads the SSH service to apply changes

## Security Notes

- The script requires root access to the remote server.
- Password login is disabled for the new user; SSH key authentication is enforced.
- Make sure you trust the public key you’re uploading.

## Troubleshooting

- Ensure you can SSH into the remote server as root.
- If you see “Public key file not found,” verify the path you entered.
- If you see “User already exists,” pick a different username or manually review the existing user.

## License

MIT License. See [LICENSE](LICENSE) for details.

---
