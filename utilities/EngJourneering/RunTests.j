#!/usr/bin/env objj

print("Running 'ojtest Tests/*/*Test*.j'...");

var pathToTestFolder = "Tests";

var lsOptions = {output: ""};
runCommand("ls", pathToTestFolder, lsOptions);

var folders = lsOptions.output.split("\n");

var testFiles = [];
var re = new RegExp(".*Test.*.j", "i");

var path = [pathToTestFolder];

for (var i = 0; i < folders.length; i++)
{
    var folder = folders[i];
    path.push(folder);
    
    var lsOptions = {output: ""};
    runCommand("ls", path.join("/"), lsOptions);
    
    var files = lsOptions.output.split("\n");
    for (var i = 0; i < files.length; i++)
    {
        var file = files[i];
        path.push(file);
        
        if (re.test(file))
        {
            testFiles.push(path.join("/"));
        }
        
        path.pop();
    }
    
    path.pop();
}

print("");

var ojtestOptions = {args:testFiles};
var result = runCommand("ojtest", ojtestOptions);

print("");