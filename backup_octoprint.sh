#!/bin/bash

{

user="pi"
host="octopi.local"
remote_backup_folder="/home/pi/.octoprint/data/backup/"
local_backup_folder="./backups/"

mkdir -p "$local_backup_folder"

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

make_new_backup
download

}
