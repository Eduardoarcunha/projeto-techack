#!/bin/bash

# update packages
sudo yum update --all -y
# install packages
sudo yum install readline-devel openssl-devel -y
# install postgresql
sudo dnf install postgresql15 -y 

#!/bin/bash
sudo yum install google-authenticator -y

# Configure /etc/pam.d/sshd
sudo bash -c 'cat > /etc/pam.d/sshd' << 'EOF'
#%PAM-1.0
#auth       substack     password-auth
auth       include      postlogin
account    required     pam_sepermit.so
account    required     pam_nologin.so
account    include      password-auth
password   include      password-auth
# pam_selinux.so close should be the first session rule
session    required     pam_selinux.so close
session    required     pam_loginuid.so
# pam_selinux.so open should only be followed by sessions to be executed in the user context
session    required     pam_selinux.so open env_params
session    required     pam_namespace.so
session    optional     pam_keyinit.so force revoke
session    optional     pam_motd.so
session    include      password-auth
session    include      postlogin
auth required pam_google_authenticator.so nullok
auth required pam_permit.so
EOF

# Append the required lines to /etc/ssh/sshd_config
echo 'ChallengeResponseAuthentication yes' | sudo tee -a /etc/ssh/sshd_config
echo 'AuthenticationMethods publickey,keyboard-interactive' | sudo tee -a /etc/ssh/sshd_config

# Replace the contents of /etc/ssh/sshd_config.d/50-redhat.conf
sudo bash -c 'cat > /etc/ssh/sshd_config.d/50-redhat.conf' << 'EOF'
# This system is following system-wide crypto policy. The changes to
# crypto properties (Ciphers, MACs, ...) will not have any effect in
# this or following included files. To override some configuration option,
# write it before this block or include it before this file.
# Please, see manual pages for update-crypto-policies(8) and sshd_config(5).
Include /etc/crypto-policies/back-ends/opensshserver.config

SyslogFacility AUTHPRIV

ChallengeResponseAuthentication yes

GSSAPIAuthentication yes
GSSAPICleanupCredentials no

UsePAM yes

X11Forwarding yes

# It is recommended to use pam_motd in /etc/pam.d/sshd instead of PrintMotd,
# as it is more configurable and versatile than the built-in version.
PrintMotd no
EOF

# Restart SSHD service
sudo service sshd restart

# Create the necessary .ssh directory and authorized_keys file
sudo su -c "mkdir -p -- '/etc/skel/.ssh' && sed -e 's/.*\\(ssh-rsa.*\\) .*/\\1/' ~/.ssh/authorized_keys > '/etc/skel/.ssh/authorized_keys'"

# Configure /etc/profile.d/mfa.sh for MFA
sudo bash -c 'cat > /etc/profile.d/mfa.sh' << 'EOF'
if [ ! -e ~/.google_authenticator ] && [ $USER != "root" ]; then
    google-authenticator --time-based --disallow-reuse --force --rate-limit=3 --rate-time=30 --window-size=3
    echo
    echo "Save the generated emergency scratch codes and use secret key or scan the QR code to
    register your device for multifactor authentication."
    echo
    echo "Login again using your ssh key pair and the generated One-Time Password on your registered
    device."
    echo
    logout
fi
EOF