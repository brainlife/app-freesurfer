#!/usr/bin/env node
const fs = require('fs');

let lut = fs.readFileSync("FreeSurferColorLUT.txt", "ascii");

let key = "";
let labels = [];

lut.split("\n").forEach(line=>{
	line = line.trim();
	if(line[0] == "#") return;
	if(line == "") return;
	let tokens = line.split(/[ ]+/);
	key += tokens[0]+" -> "+tokens[0] + " == "+tokens[1]+"\n";
    labels.push({
        "name": tokens[1],
        "label": tokens[0],
        "voxel_value": parseInt(tokens[0]),
        "r": parseInt(tokens[2]),
        "g": parseInt(tokens[3]),
        "b": parseInt(tokens[4]),
    });
});

fs.writeFileSync("label.json", JSON.stringify(labels, null, 4));
fs.writeFileSync("key.txt", key);
