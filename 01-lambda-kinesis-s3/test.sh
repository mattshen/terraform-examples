#!/usr/bin/env sh

aws kinesis put-record --stream-name mzfc-stream-1 --data 'test,12' --partition-key `uuidgen`