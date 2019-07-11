# aem-runner-bash
Bash Script to startup development environment for AEM on a mac, when running it:
* Runs AEM from the command line in debug mode.
* Kills all .jar processes (IntelliJ, other AEM instances).
* Opens IntelliJ for the current project.
* Runs a maven clean install from the project repo directory.
* Tails the designated log file.
* Runs aemsync (for immediate front end updates)
* opens a spare terminal for git and mvn clean install.

## Installation
* Pull this repo.
* Reference it in your ./.bash_profile file:
```
declare load_files=(~/personal/aem-runner-bash/aem-project-loader.bash)
```
* Configure AEM/repo variables in aem-project-loader.bash
* Restart terminal.
* In the terminal, type the name of the functions you make in aem-project-loader.bash ie
```setup-adobe```
* Grab a coffee, 3 minutes later it'll be running and ready for work!

## TODO
* generate project config files, so this can be shared.
* make repo public.
* Improve 'kill all jars' function.
* create new project functionality.
* enable config for terminal to front aggressively.