#!/usr/bin/env objj

print("Running 'ojtest tests/*Test*.j'...");

var pathToTestFolder = "tests/";

var lsOptions = {output: ""};
runCommand("ls", pathToTestFolder, lsOptions);

var files = lsOptions.output.split("\n");

var testFiles = [];
var re = new RegExp(".*Test.*.j", "i");

for (var i = 0; i < files.length; i++)
{
    var file = files[i];
    
    if (re.test(file))
    {
        testFiles.push(pathToTestFolder+file);
    }
}

print("");

var ojtestOptions = {args:testFiles};
var result = runCommand("ojtest", ojtestOptions);

print("");