#!/bin/env node
'use strict';

var fs = require('fs');
var config = JSON.parse(fs.readFileSync('config.json', "utf8"));

function genrecon(file) {
    var subject = file.filename.substring(0, file.filename.length-4);
    var workdir = process.env.SCA_WORKFLOW_DIR;
    var line = "recon-all -i \""+workdir+"/"+config.input_task_id+"/"+file.filename+"\" -subject \""+subject+"\"";
    if(config.all) line+=" -all";
    if(config.hipposubfields) line+=" -hippo-subfields";
    line += " &\n";
    return line;
}

var template = fs.readFileSync(__dirname+"/template.pbs", "utf8");

var reconall = "";
config.files.forEach(function(file) {
    reconall += genrecon(file);
});

//do substitutions
template = template.replace("__taskdir__", process.env.SCA_TASK_DIR);
template = template.replace("__reconall__", reconall);

console.log(template);
