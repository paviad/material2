#!/bin/bash

TUNNEL_LOG="$LOGS_DIR/browserstack-tunnel.log"

# Method that prints the logfile output of the browserstack tunnel.
printLog() {
  echo "Logfile output of Browserstack tunnel (${TUNNEL_LOG}):"
  echo ""
  cat ${TUNNEL_LOG}
}

# Wait for Connect to be ready before exiting
# Time out if we wait for more than 2 minutes, so the process won't run forever.
let "counter=0"

# Exit the process if there are errors reported. Print the tunnel log to the console.
if [ -f $BROWSER_PROVIDER_ERROR_FILE ]; then
  echo
  echo "An error occurred while starting the tunnel. See error:"
  printLog
  exit 5
fi

while [ ! -f $BROWSER_PROVIDER_READY_FILE ]; do
  let "counter++"

  if [ $counter -gt 240 ]; then
    echo
    echo "Timed out after 2 minutes waiting for tunnel ready file"
    printLog
    exit 5
  fi

  printf "."
  sleep .5
done

echo ""
echo "Connected to Browserstack"
