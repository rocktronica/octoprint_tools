#!/bin/bash

{

filename="$1"

user="pi"
host="octopi.local"
destination="~/.octoprint/uploads"
bandwidth_limit="1000" # prevents stalling on large files; kbit/s

function upload() {
    echo "Uploading $filename"
    scp -C -l "$bandwidth_limit" "$filename"  "$user@$host:$destination"
    echo
}

function stop_octoprint() {
    echo 'Stopping OctoPrint'
    ssh "$user@$host" 'sudo service octoprint stop'
    echo
}

function start_octoprint() {
    echo 'Starting OctoPrint'
    ssh "$user@$host" 'sudo service octoprint start'
}

if [[ -z "$filename" ]]; then
    echo 'No filename found'
    exit 1
fi

function clean_junk_folders() {
    ssh "$user@$host" "
        sudo rm -rf $destination/Temporary_Items*
        sudo rm -rf $destination/Network_Trash*
    "
}

# stop_octoprint
upload "$filename"
# start_octoprint

# clean_junk_folders

}
