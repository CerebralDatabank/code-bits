#!/bin/bash

function checkerr() {
    if [[ "$?" -eq "0" ]]; then
        printf "\x1B[92m[ OK ]\x1B[m $1\n"
    else
        printf "\x1B[91m[FAIL]\x1B[m $2\n"
        exit
    fi
}

function okprint() {
    printf "\x1B[92m[ OK ]\x1B[m $1\n"
}

function failprint() {
    printf "\x1B[91m[FAIL]\x1B[m $1\n"
}

function infoprint() {
    printf "\x1B[94m[INFO]\x1B[m $1\n"
}

printf '\n\x1B[96;1;4mCSCE 410 VM Auto-Shutdown Service\x1B[m\n'
printf '\x1B[3mAdds a systemd timer to shutdown the system if no users are logged in via SSH\x1B[m\n'
printf '\x1B[3m(option to automatically remove the service coming soon)\x1B[m\n\n'
if [[ "$(whoami)" != "root" ]]; then
    failprint 'Must be run as root (use sudo)'
    exit
fi

read -p $'\x1B[mEnter your Linux username (shown in CLI prompt): \x1B[96m' username < /dev/tty
printf '\x1B[m'

if ! type gcloud &> /dev/null; then
    infoprint 'gcloud not found; installing (snap)...'
    snap install google-cloud-cli --classic
    checkerr 'gcloud (snap: google-cloud-cli) installed' 'Failed to install snap gcloud-google-cli'
    infoprint 'You must now authenticate the gcloud CLI - follow the instructions given.'
    infoprint 'If it asks, using the personal account is fine unless you want to use a service account.'
    read -p 'Press Enter to continue...' < /dev/tty
    su -c 'gcloud auth login' "$username" < /dev/tty
    checkerr 'gcloud login completed' 'gcloud login failed'
else
    okprint 'gcloud already installed'
    infoprint 'Check the below output to ensure you are logged into gcloud CLI:'
    printf '\u2501\u2501\u2501\u252B $ gcloud auth list \u2523\u2501\u2501\u2501\n'
    su -c 'gcloud auth list' "$username"
    printf '\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\u2501\n'
    infoprint 'If you don't see your account there, quit this script with Ctrl-C and run: \x1B[93mgcloud auth login\x1B[m'
    read -p 'Press Enter to continue...' < /dev/tty
fi
printf '\n'

infoprint 'Go to https://console.cloud.google.com/ in a browser'
infoprint 'Take note of the \x1B[93mName\x1B[m and \x1B[93mZone\x1B[m columns of the VM'
read -p $'Enter the \x1B[93mName\x1B[m: \x1B[96m' vm_name < /dev/tty
read -p $'\x1B[mEnter the \x1B[93mZone\x1B[m: \x1B[96m' vm_zone < /dev/tty
printf '\x1B[m'

mkdir /home/$username/auto-off/

cat <<EOF > /home/$username/auto-off/auto-off.sh
#!/bin/bash
if ! ps aux | grep "[0-9] sshd: [^ ]*@" &> /dev/null; then
    /snap/bin/gcloud compute instances stop $vm_name --zone=$vm_zone
fi
EOF
checkerr 'Added auto-off script' 'Failed to add auto-off.sh script'

cat <<EOF > /home/$username/auto-off/off.sh
read -p $'\e[91mShutdown VM? [Y/n]\e[m ' resp
if [[ "\$resp" =~ ^[Nn]\$ ]]; then
    printf 'Shutdown canceled.\n'
else
    printf 'Shutting down...\n'
    nohup gcloud compute instances stop $vm_name --zone=$vm_zone &> /dev/null &
    disown
    printf 'Terminating SSH session...\n'
    ps aux | grep "[0-9] sshd: \$(whoami)@" | awk '{print \$2}' | xargs kill
fi
EOF
checkerr 'Added script for manual off command' 'Failed to add off.sh script for manual off command'

chmod +x /home/$username/auto-off/*
checkerr 'Made scripts executable' 'Failed to set script permissions'
chown -R $username:$username /home/$username/auto-off/
checkerr 'Made user own scripts' 'Failed to set script owner'

printf "\nalias off='~/auto-off/off.sh'\n" >> /home/$username/.bashrc
checkerr 'Added off command alias in ~/.bashrc' 'Failed to add off command alias in ~/.bashrc'

cat <<EOF > /etc/systemd/system/auto-off.service
[Unit]
Description=Automatically shut down VM if user is not logged in

[Service]
Type=oneshot
User=$username
ExecStart=/home/$username/auto-off/auto-off.sh
EOF
checkerr 'Created systemd service file' 'Failed to create systemd service file'

read -p $'Enter the time interval for the auto-shutdown check\n(30min recommended, DO NOT make it too low)\nEnter time interval: \x1B[96m' chk_itvl < /dev/tty
printf '\x1B[m'

cat <<EOF > /etc/systemd/system/auto-off.timer
[Unit]
Description=Automatically shut down VM if user is not logged in

[Timer]
OnBootSec=$chk_itvl
OnUnitActiveSec=$chk_itvl

[Install]
WantedBy=timers.target
EOF
checkerr 'Created systemd timer file' 'Failed to create systemd timer file'
systemctl daemon-reload
checkerr 'systemd daemon configuration reloaded' 'Failed to reload systemd daemon configuration'
systemctl enable auto-off.service > /dev/null
checkerr 'Enabled systemd service' 'Failed to enable systemd service'
systemctl enable auto-off.timer > /dev/null
checkerr 'Enabled systemd timer' 'Failed to enable systemd timer'
systemctl start auto-off.timer > /dev/null
checkerr 'Started systemd timer' 'Failed to start systemd timer'
okprint 'All done!'
infoprint "Every \x1B[93m$chk_itvl\x1B[m from boot, the VM will automatically shut down if there are no active SSH sessions."
infoprint 'Use the \x1B[93moff\x1B[m command to manually shut down (works after re-login or running \x1B[93msource ~/.bashrc\x1B[m)'
printf '\n'
