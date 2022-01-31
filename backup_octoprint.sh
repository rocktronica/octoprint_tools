#!/bin/bash

{

user="pi"
host="octopi.local"
remote_backup_folder="/home/pi/.octoprint/data/backup/"
local_backup_folder="./backups/"

mkdir -p "$local_backup_folder"

function warn_if_ssh_requires_password() {
    ssh -o BatchMode=yes "$user@$host" "exit" &> /dev/null

    if [ ! $? -eq 0 ]; then
        echo "WARNING: ssh password required. Script cannot run unsupervised."
        echo
    fi
}

function make_new_backup() {
    echo "CREATING NEW BACKUP..."
    ssh "$user@$host" "
        source ~/oprint/bin/activate
        octoprint plugins backup:backup --exclude timelapses
    "
    echo
}

function download() {
    echo "DOWNLOADING..."
    path=$(ssh "$user@$host" "ls -dt $remote_backup_folder/* | head -n1")
    scp -C "$user@$host:$path" "$local_backup_folder"
    echo
}

warn_if_ssh_requires_password
make_new_backup
download

}
