#!/bin/bash
source ./personal/setup/aem-runner-bash/aem-project-loader-util.bash

setup-hsbc(){
  projectName="HSBC"

  # AEM
  aemDir="AEM/hsbc-6.4"
  aemJarName="cq-quickstart-6.4.0.jar"
  logFileName="crx-quickstart/logs/project-hsbc-forms.log"

  # Repo/Mvn
  repoDir="work/hsbc-forms"
  mvnCleanInstallDir="work/hsbc-forms"

  setup-aem-project $aemDir $repoDir $aemJarName $mvnCleanInstallDir $logFileName $projectName
}