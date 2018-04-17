//TryOutCohesinDetection 1. determine optimal autolocalthreshold and use that to select all cohesin localizations
// KJ Feb6-10 2018

saveSettings();
var minSize=0.0005;
var maxSize = "infinity";
var method="Bernsen";

run("Close All");
path=File.openDialog("Select file...");
open(path);
run("8-bit");
rename("Test.tif");
run("In [+]"); run("In [+]"); run("In [+]"); run("In [+]");
run("Duplicate...", "title=RGBDup");
run("RGB Color");
run("Concatenate...", "  title=ThreshStack image1=RGBDup image2=RGBDup image3=[-- None --]");
IJ.deleteRows(0, 20000);

for (i=2; i<20; i++){ //this loop cycles to various settings of autoLocalThreshold to let the user choose
	selectWindow("Test.tif");	
	run("Duplicate...", "title=Thresh");
	run("Auto Local Threshold", "method="+method+" radius="+i+" parameter_1=0 parameter_2=0 white");
	setOption("BlackBackground", false);
	run("Make Binary");
	run("Watershed");
	run("Analyze Particles...", "size="+minSize + "-"+ maxSize +" circularity=0.40-1.00 display exclude add");
	print("Bernsen "+i+"  Detected particles = "+ roiManager("count"));
	selectWindow("Thresh");
	close();
	selectWindow("Test.tif");	
	run("Duplicate...", "title=Dup");
	run("From ROI Manager");
	roiManager("Show All without labels");
	drawString(i, 5,20);
	run("Flatten");
	rename("Flattened");
	run("RGB Color");
	run("Concatenate...", "  title=[Concatenated Stacks] image1=ThreshStack image2=Flattened image3=[-- None --]");
	run("In [+]"); 	run("In [+]"); 	run("In [+]"); 	run("In [+]");
	rename("ThreshStack");
	selectWindow("Dup");
	close();
	roiManager("Delete");
}
print("done cycling");
waitForUser("determine which Bernsen radius detects events best");
i=getNumber("Input which radius detects events best (number) ", 8);

//i=8;
print("Selected "+method+" radius = "+i);

selectWindow("Test.tif");	
//run("Auto Local Threshold", "method="+method+" radius="+i+" parameter_1=0 parameter_2=0 white");
IJ.deleteRows(0, 100000);
	run("Auto Local Threshold", "method="+method+" radius="+i+" parameter_1=0 parameter_2=0 white");
	setOption("BlackBackground", false);
	run("Make Binary");
	run("Watershed");
	run("Analyze Particles...", "size="+minSize + "-"+ maxSize +" circularity=0.40-1.00 display exclude add");
saveAs("Results", path+"Results.txt");
	
restoreSettings();