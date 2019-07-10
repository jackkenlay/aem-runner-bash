#!/bin/bash

kill-jars() {
  echo "Killing all Java Processes"
  killall -9 java
}

open-normal-apps(){
  echo "Opening Rocket Chat"
  open -g -a /Applications/Rocket.Chat+.app/
  echo "Opening Notes"
  open -g -a /Applications/Notes.app/
  echo "Opening Mail"
  open -g -a /Applications/Mail.app/
  echo "Opening Chrome"
  open -g -a /Applications/Google\ Chrome.app/
}

bring-terminal-to-front(){
  osascript -e 'tell application "Terminal" to activate'
  organise-terminal-windows
}

organise-terminal-windows() {
  # TODO
  # Make this work dynamically
  # https://mac.appstorm.net/general/build-a-window-management-app-with-apptivate-and-applescript/
  osascript -e 'tell application "System Events" to tell process "Terminal"
    tell window 1
        set size to {700, 440}
        set position to {0, 0}
    end tell
    tell window 2
        set size to {700, 440}
        set position to {700, 0}
    end tell
    tell window 3
        set size to {700, 440}
        set position to {0, 460}
    end tell
    tell window 4
        set size to {700, 440}
        set position to {700, 460}
    end tell
end tell'  
}

countdown()
(
  IFS=:
  set -- $*
  secs=$(( ${1#0} * 3600 + ${2#0} * 60 + ${3#0} ))
  while [ $secs -gt 0 ]
  do
    sleep 1 &
    printf "\r%02d:%02d:%02d" $((secs/3600)) $(( (secs/60)%60)) $((secs%60))
    secs=$(( $secs - 1 ))
    wait
  done
  echo
)

wait-and-bring-terminals-to-front(){
  bring-terminal-to-front
  echo "Waiting 120 seconds before mvn clean install"
  countdown "00:00:10"
  bring-terminal-to-front
  countdown "00:00:10"
  bring-terminal-to-front
  countdown "00:00:10"
  bring-terminal-to-front
  countdown "00:00:10"
  bring-terminal-to-front
  countdown "00:00:10"
  bring-terminal-to-front
  countdown "00:00:10"
  bring-terminal-to-front
  countdown "00:01:00"
  bring-terminal-to-front
}

setup-aem-project(){
  aemdirectory=$1
  repodirectory=$2
  aemfilename=$3
  mvncleaninstalldirectory=$4
  logfile=$5
  projectName=$6
  
  echo "Setting up $6"
  echo "Killing IntelliJ"
  pkill -f "IntelliJ"

  kill-jars
  killall node

  echo "killing all chromes"
  pkill chrome

  countdown "00:00:10"

  echo "Opening Logs"
  osascript -e 'tell application "Terminal" to do script "tail -f '"$aemdirectory"'/'"$logfile"'"'

  echo "Opening JAR"
  osascript -e 'tell application "Terminal" to do script "cd '"$aemdirectory"'; java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=30303 -jar '$aemfilename'" '

  echo "Opening normal apps"
  open-normal-apps
  bring-terminal-to-front
  organise-terminal-windows

  echo "Opening IJ"
  cd ''"$repodirectory"''
  open -g -a /Applications/IntelliJ\ IDEA.app .

  wait-and-bring-terminals-to-front  

  cd ''"$mvncleaninstalldirectory"''
  echo "maven install"
  mvn clean install -PautoInstallPackage ||  mvn clean install -PautoInstallPackage

  echo "Starting AEM Sync"
  osascript -e 'tell application "Terminal" to do script "cd '"$mvncleaninstalldirectory"'; aemsync"'
  
  bring-terminal-to-front
  echo "Setup $6 finished"
}


create-new-project(){
  node ~/personal/setup/nodejs-scripts/create-aem-project.js
# TODO
# Change to node
# Selection input
# Packages
# Starting with Admin admin (probably easier with NodeJS)
# Change to Rsync
# Call from Bash, make a nodeJS file in my setup
# Ask for prompts for repo and stuff
# After starting AEM, then it asks for logfile, incase it's created after project creation?
# a JSON file with all of the set up so you can alter it later on
# Makes a setup-projectName function
# Advanced
  # add option to add in package-share url, and it can sign in and download it and install it upon completion. - probably better than having all of the packages.

  # AEMNASdir="/Volumes/Users/jackk/AEM/";
  # # input:
  #   # AEM version
  #   # Packages
  #   # Repo url
  #   # MVN clean install dir.
  #   # Logfile dir
  #   # AEM filename
  #   # repo folder name (gets after cloning)
  
  # # Steps
  #   # get a project name
  #     projectName="creditsafe-aem"
  #   # Ensure LondonNAS is connected
  #     # If not then mount it
  #     mount-london-nas
  #   # Asks which AEM you want
  #     # TODO have manual input here, from list or just read it

  #   # Asks which packages you want
  #   # Asks for Repo URL
  #     repoUrl="https://stash.ensemble.com/scm/cs/aem.git"
  #     echo "Repo URL: $repoUrl"
  #   # goes to work folder & clones repo
  #     cd ~/work
  #     git clone "$repoUrl" "$projectName"
  #     echo "Repo Cloned"
  #   # goes to AEM folder & clones correct AEM version from NAS
  #     echo "Copying AEM from NAS, please wait (normally takes 1 minutes on the 5ghz wifi)"
  #     cd ~/AEM/
  #     SRC_DIR="$AEMNASdir$aemVersion/";
  #     mkdir ~/AEM/$projectName-$aemVersion && cp -r $SRC_DIR ~/AEM/$projectName-$aemVersion
  #     echo "Copied AEM"

            # TODO USE RSYNC w/progress bar BUT THE PIECE OF SHIT DOESNT WORK
            # SRC_DIR="$AEMNASdir$aemVersion/";
            # OPTIONS="-avz";
            # DST_DIR="~/AEM/";
            # echo "$SRC_DIR";
            # echo "$DST_DIR";
            # /usr/bin/rsync $OPTIONS "$SRC_DIR" "$DST_DIR";
    
    # Gets available packages from directory in NAS and asks user which ones they want.
    # Starts AEM with admin admin
    
    
    # Installs packages
      # runs an install on all packages the total amount of packages there are, to ensure all of them have been installed? 
    # creates a bash function for my thing.
}