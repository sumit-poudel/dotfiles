#!/bin/bash

if asusctl profile -p | grep -q "Active profile is Quiet"; then
  echo true
else
  echo false
fi
