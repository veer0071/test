#!/bin/bash
printf "==> START SERVICE \n"
# Start the first process
python app.py run &

wait -n

# Exit with status of process that exited first
exit $?