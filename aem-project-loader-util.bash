#!/bin/bash

kill-jars() {
  # TODO
  # Make more friendlier...
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