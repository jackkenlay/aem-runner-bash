var Rsync = require('rsync');
var List = require('prompt-list');
const fs = require('fs');
var prompt = require('prompt');
var Prompt = require('prompt-checkbox');
var cmd = require('node-cmd');
const homedir = require('os').homedir();
const path = require('path');


/*
//todo
it creates following structure

~/AEM/source - where the root AEM lies
~/AEM/packages - where local packages reside
~/AEM/projects - where the working AEM instances are
~/work - where the repos are
*/

const rootAEMInstancesDir = homedir + '/AEM/source/';
const localAEMPackagesDir = homedir + '/AEM/packages/';
const AEMInstancesDir = homedir + '/AEM/projects/';
const repoDirectories = homedir + '/work/'
const aemToolKitDir = homedir + '/work/aem-toolkit/';


async function start() {
    console.log('Creating New AEM project\n');

    await createProjectDirectories();

    //gets project name
    //gets project Repo URL
    let params = await getProjectParams();
    params.AEMVersion = await getRequiredAEMVersion();

    // TODO for packages
    // should I offer the URLS of the packages to install?
    // should I offer the names?
        // if i could do the names, once AEM has started, would it be possible to use package manager like that?
    // params.packagesToInstall = await getListOfPackagesToCopy(params.AEMVersion);

    console.log('Project Data:');
    console.log(JSON.stringify(params, null, 4));

    // copy from the aem folder, to the new folder.
    //TODO work from here
    let AEMFolderToCopy = AEMNASDir + params.AEMVersion + '/';

    console.log('Aem folder to copy: ' + AEMFolderToCopy);
    // let newAEMDirectory = localAEMDirectory + params.projectName + '-' + params.AEMVersion;
    // // console.log('Destination: ' + distinationDIR);
    // await copyDirectory(AEMFolderToCopy, newAEMDirectory);

    // //clone the repo.
    // let repoDestination = AEMProjectDirectory + params.projectName;
    // await cloneRepo(params.repoUrl, repoDestination);
    // console.log('finished cloning repo');

    // //copy the selected packages accross to the AEM folder
    // let packagesDirectory = newAEMDirectory + '/packages/';
    // await makeDirIfNotExist(packagesDirectory);
    // await copySelectedPackages(params.packagesToInstall, packagesDirectory);







    //test input data
    //credit-safe
    //6.3
    //https://stash.ensemble.com/scm/cs/aem.git
    //todo

    //init AEM
    // printf 'admin\nadmin\n' | java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=30303 -jar cq-quickstart-6.3.0.jar 

    //install the packages

    //later, do they have a content.package that they can select from wherever.
    //later, make a backup after init project, so they always have something to go back to if they fuck up their AEM
    //later, give the option to save this config in a json file.
    //later, if yes, give the option to parse the input from a json.config file
    // make a global settings config, with the consts in
}
start();

async function createProjectDirectories(){
    makeDirIfNotExist(rootAEMInstancesDir);
    makeDirIfNotExist(localAEMPackagesDir);
    makeDirIfNotExist(AEMInstancesDir);
    makeDirIfNotExist(repoDirectories);
}







async function getFilesInDirectory(dir){
    return new Promise((resolve,reject)=>{
        const directoryPath = path.join(dir);
        //passsing directoryPath and callback function
        fs.readdir(directoryPath, function (err, files) {
            //handling error
            if (err) {
                console.log('Unable to scan directory: ' + err);
                reject();
            }
            //listing all files using forEach
            let allFiles = [];
            files.forEach(function (file) {
                // Do whatever you want to do with the file
                allFiles.push(file);
            });
            resolve(allFiles);
        });
    });
}

async function getRequiredAEMVersion() {
    //TODO make this automatic depending on directory
    //get all aem instances from the local aem directory
    let AEMChoices = await getFilesInDirectory(rootAEMInstancesDir);

    //todo add in 6.3, 6.1 etc and say (needs adding)
    // var list = new List({
    //     name: 'AEM Setup',
    //     message: 'Which AEM?',
    //     // choices may be defined as an array or a function that returns an array
    //     choices: [
    //       '6.4',
    //       '6.3',
    //       '6.2',
    //       {name: '6.1', disabled: 'Needs Creating'},
    //       {name: '6.0', disabled: 'Needs Creating'},
    //     ]
    //   });

    var list = new List({
        name: 'AEM Setup',
        message: 'Which AEM?',
        // choices may be defined as an array or a function that returns an array
        choices: AEMChoices
    });
       
    return list.run()
        .then(function(answer) {
          return Promise.resolve(answer);
        });
}


//need to get a list of all zip files in there
function getAvailableAEM(){

}

async function listAllPackagesByAEM(inputAEM) {
    return new Promise((resolve,reject)=>{
        let currentAemPackages = localAEMPackagesDir+ '/*.zip';
        //inputAem needs to be 6.1 or 6.2 etc
        //get array of all the files in the directory
        // console.log('currentAemPackages: ' + currentAemPackages);
        var glob = require("glob");
    
        // options is optional
        glob(currentAemPackages, function (er, files) {
          // files is an array of filenames.
          // If the `nonull` option is set, and nothing
          // was found, then files is ["**/*.js"]
          // er is an error object or null.
          resolve(files);
        });
    })

}

async function getProjectParams(){
    return new Promise((resolve,reject)=>{
        prompt.start();

        prompt.get(['Project Name','Project Repo Clone Url'], function (err, result) {
            let params = {};
          // Log the results.
        //   console.log('Command-line input received:');
        //   console.log(JSON.stringify(result,null,4));
          params.projectName = result['Project Name'];
          params.repoUrl = result['Project Repo Clone Url'];
          resolve(params);
        });
    });
}

async function getListOfPackagesToCopy(aemVersion){
    let availablePackages = await listAllPackagesByAEM(aemVersion);
    var prompt = new Prompt({
    name: 'colors',
    message: 'Which Available Packages do you want to Install? (Use spacebar to select, enter to submit)',
    choices: availablePackages
    });
    
    return prompt.run()
    .then(function(answers) {
        return Promise.resolve(answers);
    })
    .catch(function(err) {
        console.log('Error:');
        console.log(err)
    })
}

//todo change to promise
async function copyDirectory(source,destination){
    console.log('copying ' + source + ' to ' + destination);
    return new Promise((resolve,reject)=>{
        // Build the command
        var rsync = new Rsync();
        rsync.shell('ssh');
        rsync.set('progress');
        rsync.flags('avz');
        rsync.source(source);
        rsync.destination(destination);
        console.log('running the command ' + rsync.command());
        rsync.output(
            function (data) {
                console.log('synching... ' + data);
            }, function (data) {
                console.log('What is this line for? sync: ' + data);
            }
        );
        rsync.execute(function(error, code, cmd) {
            console.log('Finished copying ' + source + ' to ' + destination);
            resolve();
        });
    });
}

async function cloneRepo(repoUrl, targetPath){
    //https://www.npmjs.com/package/node-cmd
    console.log('Cloning repo: ' + repoUrl + ' to ' + targetPath);
    return new Promise((resolve,reject)=>{
        cmd.get(
            `
                git clone ${repoUrl} ${targetPath}
            `,
            function(err, data, stderr){
                if (!err) {
                   console.log('Finished cloning repo: ' + repoUrl + ' to ' + targetPath);
                   resolve();
                } else {
                   console.log('error', err)
                }
     
            }
        );
    });
}

async function copySelectedPackages(packages, destination){
    //packages needs to be an array of filenames of packages to install
    console.log('Copying packages:');
    for (var i = 0; i < packages.length; i++) { 
        await copyDirectory(packages[i], destination);
    }
    console.log('Completed');
}
    



async function makeDirIfNotExist(dir){
    console.log('Creating directory: ' + dir);
    if (!fs.existsSync(dir)){
        fs.mkdirSync(dir);
    }
}



async function initAEMInstance(filepath, username, password) {
    let AEMstartcommand = `printf '${username}\n${password}\n' | java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=30303 -jar ${filepath}`;

    //opens in another window
    let fullcommand = `osascript -e 'tell application "Terminal" to do script "${AEMstartcommand}"'`;
    /*
        this might need to be run async....

        add a 3 minute timer?

        run it in a new window? (see bash setup)
    */
    return new Promise((resolve,reject) => {
        cmd.get(
            `
                ${fullcommand}
            `,
            function(err, data, stderr){
                if (!err) {
                   console.log('Finished cloning repo: ' + repoUrl + ' to ' + targetPath);
                   resolve();
                } else {
                   console.log('error', err)
                }
     
            }
        );
    });
}