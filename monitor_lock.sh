#!/bin/bash

gdbus monitor -y -d org.freedesktop.login1 | 
while read -r line; do
	[[ $line =~ LockedHint.*true ]] && ~/on_lock.sh
	[[ $line =~ LockedHint.*false ]] && ~/on_unlock.sh
done
