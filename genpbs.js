#!/bin/env node
'use strict';

const fs = require('fs');
const config = JSON.parse(fs.readFileSync('config.json', "utf8"));
const path = require('path');

//setup environment specific pbs parameters
var pbs = "";
if(process.env.HPC == "KARST") {
    pbs += "#PBS -l nodes=1:ppn=16,walltime=12:00:00\n";
} else if(process.env.HPC == "CARBONATE") {
    pbs += "#PBS -l nodes=1:ppn=24,walltime=12:00:00\n";
} else if(process.env.HPC == "BIGRED2") {
    pbs += "#PBS -l nodes=1:ppn=32\n#PBS -q cpu\n#PBS -l walltime=20:00:00\n";//16 hours not enough
}

function genrecon(filename, subject) {
    var line = "";

    //recon-all fails if there is previous output dir (according to Jonn?)
    line += "rm -rf "+subject+"\n";

    if(process.env.HPC == "BIGRED2") line += "export OMP_NUM_THREADS=32\naprun -n 1 -d 32 ";

    line += "recon-all -i \""+filename+"\" -subject \""+subject+"\" -all"; //all is needed to generate all labels
    if(process.env.HPC == "BIGRED2") line += " -openmp 32";
    if(process.env.HPC == "KARST") line += " -openmp 16"; //not sure if this really does anything on karst
    if(process.env.HPC == "CARBONATE") line += " -openmp 24"; 
    if(config.hipposubfields) line+=" -hippo-subfields";
    return line;
}

var reconall = genrecon(config.t1, "output");

//do substitutions
var template = fs.readFileSync(__dirname+"/template.pbs", "utf8");
template = template.replace("__pbs__", pbs);
template = template.replace("__reconall__", reconall);

console.log(template);

