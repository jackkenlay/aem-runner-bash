# aem-runner-bash
Bash Script to startup development environment for AEM on a mac, when running it:
* Runs AEM from the command line in debug mode.
* Kills all .jar processes (IntelliJ, other AEM instances).
* Opens IntelliJ for the current project.
* Runs a maven clean install from the project repo directory.
* Tails the designated log file.
* Runs aemsync (for immediate front end updates).
* opens a spare terminal for git and mvn clean install.

This can be useful if you dislike manually opening AEM each morning, opening up log files etc..

It's very useful if you're working on multiple AEM projects at the same time, since you can easily close everything down and reopen the other project with a fresh environment.

## Installation
* Pull this repo.
* Reference it in ./.bash_profile by appending the following line to it:
```
declare load_files=(~/personal/aem-runner-bash/aem-project-loader.bash)
```
* Configure AEM/repo variables in aem-project-loader.bash
* Restart terminal.
* In the terminal, type the name of the functions you make in aem-project-loader.bash ie:

```setup-adobe```
* Grab a coffee, 3 minutes later it'll be running and ready for work!

## TODO
* generate project config files.
* Improve 'kill all jars' function.
* Other TODOS in the code.
* Create new project functionality.
* Enable config for terminal to front aggressively.