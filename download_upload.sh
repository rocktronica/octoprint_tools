#!/bin/bash

{

user="pi"
host="octopi.local"
remote_uploads_folder="/home/pi/.octoprint/uploads"
filename="$1"

function download() {
    echo "DOWNLOADING $filename..."
    scp -C "$user@$host:$remote_uploads_folder/$filename" "$filename"
    echo
}

download

}
