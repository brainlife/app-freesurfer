#!/bin/env node
'use strict';

const fs = require('fs');
const config = JSON.parse(fs.readFileSync('config.json', "utf8"));
const path = require('path');

var template = fs.readFileSync(__dirname+"/template.pbs", "utf8");

function genrecon(filename, subject) {
    var line = "";

    //recon-all fails if there is previous output dir (according to Jonn?)
    line += "rm -rf "+subject+"\n";

    if(process.env.PBS_ENV == "bigred2") line += "module load ccm\nccmrun ";
    //line += "recon-all -i \""+filename+"\" -subject \""+subject+"\" -autorecon1 -autorecon2 -openmp 16";
    line += "recon-all -i \""+filename+"\" -subject \""+subject+"\" -all -openmp 16\n"; //all is needed to generate all labels
    if(config.hipposubfields) line+=" -hippo-subfields";
    return line;
}

var reconall = "";

//setup environment specific pbs parameters
var pbs = "";
if(process.env.PBS_ENV == "karst") {
    pbs += "#PBS -l nodes=1:ppn=16:dc2,walltime=12:00:00\n";
} else if(process.env.PBS_ENV == "bigred2") {
    pbs += "#PBS -l gres=ccm:nodes=1:ppn=32,walltime=10:00:00\n";
}

reconall += genrecon(config.t1, "output");
//products.push({type: "freesurfer", dir: "output"});

//do substitutions
template = template.replace(/__taskdir__/g, process.env.SCA_TASK_DIR);
template = template.replace("__pbs__", pbs);
template = template.replace("__reconall__", reconall);

console.log(template);

