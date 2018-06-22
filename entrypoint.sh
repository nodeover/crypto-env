#!/bin/bash

sudo /usr/sbin/service ssh start

tail -f /dev/null

echo "[$APP_NAME Server Started]"