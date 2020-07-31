#!/bin/bash

echo "Starting Hydra offline test"
rm ../tmp/gate_control_fifo
mkfifo ../tmp/gate_control_fifo

rm ../tmp/sync_control_fifo
mkfifo ../tmp/sync_control_fifo

# ../bin/sim | ../bin/sync | ../bin/gate | python3 ../gui/main.py 512

../bin/sim | python3 ../gui/main.py 512
