#!/bin/bash

echo `drill +short myip.opendns.com @resolver1.opendns.com | grep myip.opendns.com.` | sed -r 's/.*\ ([0-9+|\.]{4})/\1/'
