#!/bin/sh

INTERVAL=5 # Dummp every 5 seconds
HOST=$(uci get system.@system[0].hostname)

mkdir -p /tmp/dumps/
while (true) do
  date=$(date +%s)
  mkdir /tmp/dumps/$date
  iw dev wlan0 station dump > /tmp/dumps/$date/$HOST.stations.dump
  echo "/all" | nc 127.0.0.1 9090 > /tmp/dumps/$date/$HOST.olsr.json
  sleep $INTERVAL

done
