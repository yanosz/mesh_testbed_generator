#!/bin/sh

commit_interval=600 # Commit every 600 seconds aka 10 mins
mkdir -p /usr/dumps
mkdir -p /tmp/old_dumps
hostname=$(uci get system.@system[0].hostname)
while (true) do
  date=$(date +%s)
  #Create Archive
  mv /tmp/dumps/* /tmp/old_dumps
  tar czf /tmp/dumps.tar.gz /tmp/old_dumps
  cp /tmp/dumps.tar.gz /usr/dumps/$hostname.$date.tar.gz
  rm -rf /tmp/old_dumps/*
  sleep $commit_interval

done
