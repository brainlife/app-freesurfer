#!/bin/env node
'use strict';

const fs = require('fs');
const config = JSON.parse(fs.readFileSync('config.json', "utf8"));
const path = require('path');

//setup environment specific pbs parameters
var pbs = "";
if(process.env.PBS_ENV == "karst") {
    pbs += "#PBS -l nodes=1:ppn=16,walltime=12:00:00\n";
} else if(process.env.PBS_ENV == "bigred2") {
    pbs += "#PBS -l nodes=1:ppn=32\n#PBS -q cpu\n#PBS -l walltime=10:00:00\n";
}

function genrecon(filename, subject) {
    var line = "";

    //recon-all fails if there is previous output dir (according to Jonn?)
    line += "rm -rf "+subject+"\n";

    //if(process.env.PBS_ENV == "bigred2") line += "module load ccm\nccmrun ";
    if(process.env.PBS_ENV == "bigred2") line += "export OMP_NUM_THREADS=32\naprun -n 1 -d 32 ";
    //line += "recon-all -i \""+filename+"\" -subject \""+subject+"\" -autorecon1 -autorecon2 -openmp 16";
    line += "recon-all -i \""+filename+"\" -subject \""+subject+"\" -all"; //all is needed to generate all labels
    if(process.env.PBS_ENV == "bigred2") line += " -openmp 32";
    if(process.env.PBS_ENV == "karst") line += " -openmp 16"; //not sure if this really does anything on karst
    if(config.hipposubfields) line+=" -hippo-subfields";
    return line;
}

var reconall = genrecon(config.t1, "output");
//products.push({type: "freesurfer", dir: "output"});

//do substitutions
var template = fs.readFileSync(__dirname+"/template.pbs", "utf8");
template = template.replace(/__taskdir__/g, process.env.SCA_TASK_DIR);
template = template.replace("__pbs__", pbs);
template = template.replace("__reconall__", reconall);

console.log(template);

