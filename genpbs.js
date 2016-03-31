#!/bin/env node
'use strict';

var fs = require('fs');
var config = JSON.parse(fs.readFileSync('config.json', "utf8"));

var template = fs.readFileSync(__dirname+"/template.pbs", "utf8");

function genrecon(file) {
    var subject = file.filename.substring(0, file.filename.length-4);
    var workdir = process.env.SCA_WORKFLOW_DIR;
    var line = "recon-all -i \""+workdir+"/"+config.input_task_id+"/"+file.filename+"\" -subject \""+subject+"\"";
    if(config.all) line+=" -all";
    if(config.hipposubfields) line+=" -hippo-subfields";
    line += " &\n";
    return line;
}
function genzip(file) {
    var subject = file.filename.substring(0, file.filename.length-4);
    var workdir = process.env.SCA_WORKFLOW_DIR;
    var line = "zip -rm \""+subject+".zip\" \""+subject+"\"\n";
    return line;
}


var reconall = "";
var zip = "";
config.files.forEach(function(file) {
    reconall += genrecon(file);
    zip += genzip(file);
});

//do substitutions
template = template.replace(/__taskdir__/g, process.env.SCA_TASK_DIR);
template = template.replace("__reconall__", reconall);
template = template.replace("__zip__", zip);

console.log(template);
