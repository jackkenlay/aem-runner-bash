#!/bin/bash

# Import the util file
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/aem-project-loader-util.bash"


# Loading Project Functions

setup-adobe(){
  projectName="Adobe"

  # AEM
  aemDir="AEM/adobe-6.4"
  aemJarName="cq-quickstart-6.4.0.jar"
  # (relative to AEM dir)
  logFileName="crx-quickstart/logs/error.log"

  # Repo/Mvn
  repoDir="work/adobe"
  mvnCleanInstallDir="work/adobe"

  setup-aem-project $aemDir $repoDir $aemJarName $mvnCleanInstallDir $logFileName $projectName
}