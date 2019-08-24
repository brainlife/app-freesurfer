const fs = require('fs');

let lut = fs.readFileSync("/N/soft/rhel7/freesurfer/6.0.0/freesurfer/FreeSurferColorLUT.txt", "ascii");

lut.split("\n").forEach(line=>{
	line = line.trim();
	if(line[0] == "#") return;
	if(line == "") return;
	let tokens = line.split(/[ ]+/);
	console.log(tokens[0]+" -> "+tokens[0] + " == "+tokens[1]);
});

