# 如何连接remote ssh且不用输入密码

To connect to a remote SSH server without a password using Visual Studio Code (VS Code), you'll need to use SSH keys for authentication. Here are the general steps to achieve this:

1. **Generate an SSH Key Pair**:
   You can generate an SSH key pair on your local machine using the `ssh-keygen` tool. Open a terminal (on Linux or Mac) or PowerShell (on Windows), and enter the following command:

   ```bash
   ssh-keygen
   ```
   This will generate a pair of keys: a public key and a private key. By default, these keys will be stored in the `~/.ssh` directory (in your home directory) and named `id_rsa` (private key) and `id_rsa.pub` (public key).

2. **Copy the Public Key to the Server**:
   Next, you need to add your public key to the `~/.ssh/authorized_keys` file on the remote server. You can do this manually by copying and pasting the contents of your public key file, or you can use the `ssh-copy-id` command:

   ```bash
   ssh-copy-id username@your_server_ip
   ```
   Replace `username` and `your_server_ip` with your actual username and the IP address of your server.

   This command will ask for your password, but this should be the last time you need to enter it.

3. **Connect to the Server with VS Code**:
   First, you'll need to install the "Remote - SSH" extension in VS Code. This can be found in the extensions marketplace.

   Once you've installed the extension, you can press `F1` to open the command palette, type "Remote-SSH: Connect to Host..." and press Enter. Then, you should be able to select or enter the username and IP address of your server (e.g., `username@your_server_ip`). VS Code will use your SSH key for authentication and connect to the server without asking for a password.

Please note that the process can be a bit different depending on the operating systems of your local machine and the server. Also, some servers may require additional steps to enable SSH key authentication. If you encounter any problems, check the SSH server configuration (`/etc/ssh/sshd_config` on most Linux servers) or consult your server's documentation or support resources.
