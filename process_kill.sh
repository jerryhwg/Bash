#!/bin/bash

ps -ef | grep "sleep 600" | grep -v grep | awk '{print $2}' | xargs -I{} kill {}

echo All sleeping processes are killed

# pkill ssh
# ps -ef |grep "ssh" |grep -v grep | awk '{print $2}' | xargs kill -9
