#!/bin/bash
# This script sends a command to kodi to start cleaning the Video Library through Kodi's Web Api

curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Clean", "id": "mybash"}' -H 'content-type: application/json;' http://kodi@localhost:8080/jsonrpc