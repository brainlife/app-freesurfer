#!/bin/env node
'use strict';

var fs = require('fs');
var config = JSON.parse(fs.readFileSync('config.json', "utf8"));
var path = require('path');

var template = fs.readFileSync(__dirname+"/template.pbs", "utf8");
var products = [];

function genrecon(filename, subject) {
    var line = "";
    //recon-all fails if there is previous output dir (according to Jonn?)
    line += "rm -rf "+subject+"\n";

    var workdir = process.env.SCA_WORKFLOW_DIR;
    //line += "recon-all -i \""+filename+"\" -subject \""+subject+"\" -all";
    line += "recon-all -i \""+filename+"\" -subject \""+subject+"\" -autorecon1 -autorecon2 -openmp 4";
    if(config.hipposubfields) line+=" -hippo-subfields";
    line += " &\n";
    return line;
}

/*
function genzip(file, subject) {
    var workdir = process.env.SCA_WORKFLOW_DIR;
    var line = "zip -rm \""+subject+".zip\" \""+subject+"\"\n";
    return line;
}
*/

/*
function genstatsex(file, subject) {
    var servicedir = process.env.SCA_SERVICE_DIR;
    var taskdir = process.env.SCA_TASK_DIR;
    //var line = "mkdir \""+taskdir+"/"+subject+"/Results\"\n";
    var line = "(cd "+servicedir+"/statsex && ./run.r \""+taskdir+"/"+subject+"\" \""+servicedir+"/statsex_template\")\n";
    return line;
}
*/

var reconall = "";
//var zip = "";
var statsex = "";

/*
config.files.forEach(function(file) {
    var subject = file.filename.substring(0, file.filename.length-4);
    reconall += genrecon(file, subject);
    zip += genzip(file, subject);
    //statsex += genstatsex(file, subject);
    products.push({type: "freesurfer", dir: subject});
});
*/
var filename = path.basename(config.t1);
var filename_tokens = filename.split(".");
filename_tokens.splice(filename_tokens.length-2, 2);
var subject = filename_tokens.join(".");
reconall += genrecon(config.t1, subject);
products.push({type: "freesurfer", dir: subject});

//do substitutions
template = template.replace(/__taskdir__/g, process.env.SCA_TASK_DIR);
template = template.replace("__reconall__", reconall);
//template = template.replace("__zip__", zip);
//template = template.replace("__statsex__", statsex);
template = template.replace("__products__", JSON.stringify(products));

console.log(template);
