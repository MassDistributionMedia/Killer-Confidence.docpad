#!/bin/bash
 
# ----------------------
# KUDU Deployment Script
# ----------------------
 
# Helpers
# -------
 
exitWithMessageOnError () {
  if [ ! $? -eq 0 ]; then
    echo "An error has occured during web site deployment."
    echo $1
    exit 1
  fi
}
 
# Prerequisites
# -------------
 
# Verify node.js installed
hash node 2>/dev/null
exitWithMessageOnError "Missing node.js executable, please install node.js, if already installed make sure it can be reached from current environment."
 
# Setup
# -----
 
SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ARTIFACTS=$SCRIPT_DIR/artifacts
 
if [[ ! -n "$DEPLOYMENT_SOURCE" ]]; then
  DEPLOYMENT_SOURCE=$SCRIPT_DIR
fi
 
if [[ ! -n "$NEXT_MANIFEST_PATH" ]]; then
  NEXT_MANIFEST_PATH=$ARTIFACTS/manifest
 
  if [[ ! -n "$PREVIOUS_MANIFEST_PATH" ]]; then
    PREVIOUS_MANIFEST_PATH=$NEXT_MANIFEST_PATH
  fi
fi
 
if [[ ! -n "$KUDU_SYNC_COMMAND" ]]; then
  # Install kudu sync
  echo Installing Kudu Sync
  npm install kudusync -g --silent
  exitWithMessageOnError "npm failed"
 
  KUDU_SYNC_COMMAND="kuduSync"
fi
 
if [[ ! -n "$DEPLOYMENT_TARGET" ]]; then
  DEPLOYMENT_TARGET=$ARTIFACTS/wwwroot
else
  # In case we are running on kudu service this is the correct location of kuduSync
  KUDU_SYNC_COMMAND="$APPDATA\\npm\\node_modules\\kuduSync\\bin\\kuduSync"
fi
 
##################################################################################################################################
# Deployment
# ----------
 
echo Handling deployment.
 
# 1. Install npm packages
if [ -e "$DEPLOYMENT_SOURCE/package.json" ]; then
  cd "$DEPLOYMENT_SOURCE"
  npm install --production --silent
  exitWithMessageOnError "npm failed"
  cd - > /dev/null
fi
 
# 2. Build DocPad Site
echo Building the DocPad site
cd "$DEPLOYMENT_SOURCE"
node ./node_modules/docpad/bin/docpad generate
exitWithMessageOnError "Docpad generation failed"
 
# 3. KuduSync
echo Kudu Sync from "$DEPLOYMENT_SOURCE/out" to "$DEPLOYMENT_TARGET"
$KUDU_SYNC_COMMAND -q -f "$DEPLOYMENT_SOURCE/out" -t "$DEPLOYMENT_TARGET" -n "$NEXT_MANIFEST_PATH" -p "$PREVIOUS_MANIFEST_PATH" -i ".git;.deployment;deploy.sh" 2> /dev/null
exitWithMessageOnError "Kudu Sync failed"
 
 
##################################################################################################################################
 
echo "Finished successfully."