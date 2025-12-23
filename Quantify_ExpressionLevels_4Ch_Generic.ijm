/*****************************************************************************
 *  Author Dr. Ioannis Alexopoulos
 * The author of the macro reserve the copyrights of the original macro.
 * However, you are welcome to distribute, modify and use the program under 
 * the terms of the GNU General Public License as stated here: 
 * (http://www.gnu.org/licenses/gpl.txt) as long as you attribute proper 
 * acknowledgement to the author as mentioned above.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *****************************************************************************
 * Description of macro
 * --------------------
 * See the following README file:
 * https://github.com/jalexop/ExpressionLevelsCalculation/blob/main/README.md
 */
requires("1.53f");
Dialog.create("Expression Levels Calculation");
Dialog.addMessage("Specify the name of the markers");
Dialog.addString("\"Nuclear Marker\" name: ", "DAPI");
Dialog.addString("\"Marker 1\" name: ", "f-Actin");
Dialog.addString("\"Marker 2\" name: ", "Ki67");
Dialog.addString("\"Marker 3\" name: ", "CD31");
Dialog.show();
BlueChannel=Dialog.getString();
GreenChannel=Dialog.getString();
YellowChannel=Dialog.getString();
RedChannel=Dialog.getString();

// Create dialog, create save folders, and select file(s) to process
ThresholdMethods=getList("threshold.methods");
SelectionApproach=newArray("Load Selection", "Select All FoV", "Manually Select");
Dialog.create("Expression Levels Calculation: Parameters");
//Dialog.addMessage("Quantify AECI and AECII in alveolospheres");
Dialog.addMessage("General Parameters", 14, "#023E8A");
Dialog.addCheckbox("Analyse single image container file", true);
Dialog.addString("Name of saving folder: ", "");
Dialog.addString("Condition of Experiment (label): ", "");
Dialog.addMessage("Channel order (IMPORTANT)", 14, "#023E8A");
Dialog.addNumber(""+BlueChannel+" Channel", 1);
Dialog.addNumber(""+GreenChannel+" Channel", 2);
Dialog.addNumber(""+YellowChannel+" Channel", 3);
Dialog.addNumber(""+RedChannel+" Channel", 4);
Dialog.addMessage("Analysis Parameters", 14, "#023E8A");
Dialog.addChoice("Area to Analyse", SelectionApproach, "Manually Select");
Dialog.addCheckbox("Quantify Double Positive Areas", false);
Dialog.setInsets(0, 40, 0);
Dialog.addCheckbox(""+RedChannel+" within "+GreenChannel+"", false);
Dialog.setInsets(0, 40, 0);
Dialog.addCheckbox(""+GreenChannel+" within "+RedChannel+"", false);
Dialog.setInsets(0, 40, 0);
Dialog.addCheckbox(""+GreenChannel+" within "+YellowChannel+"", false);
Dialog.setInsets(0, 40, 0);
Dialog.addCheckbox(""+YellowChannel+" within "+GreenChannel+"", false);
Dialog.setInsets(0, 40, 0);
Dialog.addCheckbox(""+RedChannel+" within "+YellowChannel+"", false);
Dialog.setInsets(0, 40, 0);
Dialog.addCheckbox(""+YellowChannel+" within "+RedChannel+"", false);
Dialog.addMessage("Thresholding Parameters", 14, "#023E8A");
Dialog.addCheckbox("Automatic Threshold", true);
Dialog.addChoice("Threshold Algorithm for "+RedChannel+" signal", ThresholdMethods, "Default");
Dialog.addChoice("Threshold Algorithm for "+GreenChannel+" signal", ThresholdMethods, "Default");
Dialog.addChoice("Threshold Algorithm for "+YellowChannel+" signal", ThresholdMethods, "Li");
Dialog.addCheckbox("Save Thresholded Projections", true);
Dialog.show();

// Variables of Dialog
single_file=Dialog.getCheckbox();
save_folder=Dialog.getString();
condition=Dialog.getString();
BLUE_Ch=Dialog.getNumber();
GREEN_Ch=Dialog.getNumber();
YELLOW_Ch=Dialog.getNumber();
RED_Ch=Dialog.getNumber();
LOAD_ROI=Dialog.getChoice();

double_positive=Dialog.getCheckbox();
R_G=Dialog.getCheckbox();
G_R=Dialog.getCheckbox();
G_Y=Dialog.getCheckbox();
Y_G=Dialog.getCheckbox();
R_Y=Dialog.getCheckbox();
Y_R=Dialog.getCheckbox();
auto_thr=Dialog.getCheckbox();
Thres_Method_RED=Dialog.getChoice();
Thres_Method_GREEN=Dialog.getChoice();
Thres_Method_YELLOW=Dialog.getChoice();
save_tif=Dialog.getCheckbox();
sep = File.separator;
if (save_folder==""||save_folder==" "){
	save_folder="Results";
}
if (condition==""||condition==" "){
	condition="Condition";
}
if (single_file)
{
	Filelist=newArray(1);
	Filelist[0] = File.openDialog("Select a file to proccess...");
	SourceDir=File.getParent(Filelist[0]);
	Filelist[0]=File.getName(Filelist[0]);
	save_folder_name_add=Filelist[0];
	SAVE_DIR=SourceDir;
	run("Bio-Formats Macro Extensions");
	Ext.setId(SourceDir+sep+Filelist[0]);
	Ext.getSeriesCount(SERIES_COUNT);
	// Create arrays...
	SERIES_NAMES=newArray(SERIES_COUNT);
	default_check_box_values=newArray(SERIES_COUNT);
	SERIES_2_OPEN=newArray(SERIES_COUNT);
	
	// Create the dialog
	rows=10;
	columns=(SERIES_COUNT/10)+1;
	Dialog.create("Select Series to Analyze");
	if(SERIES_COUNT == 1){default_check_box=true;}else{default_check_box=false;}
	for (i=0; i<SERIES_COUNT; i++) {
		// Get series names and channels count
		Ext.setSeries(i);
		SERIES_NAMES[i]="";
		Ext.getSeriesName(SERIES_NAMES[i]);
		default_check_box_values[i]=default_check_box;
	}
	Dialog.addCheckboxGroup(rows,columns,SERIES_NAMES,default_check_box_values);
	Dialog.addCheckbox("Select All", false);
	Dialog.show();
	for (i=0; i<SERIES_COUNT; i++)
	{
		SERIES_2_OPEN[i]=Dialog.getCheckbox();
	}
	select_all=Dialog.getCheckbox();
	if (select_all)
	{
		for (i=0; i<SERIES_COUNT; i++)
		{
			SERIES_2_OPEN[i]=select_all;
		}
	}
	// Check if user selected image
	ok_to_proc=0;
	for(i=0; i<SERIES_COUNT; i++){
		if(SERIES_2_OPEN[i]==1){
			ok_to_proc=1;
		}
	}
	if(ok_to_proc<1){
		exit("Please Select an image to open")
	}
}else
{
	SourceDir = getDirectory("Choose source directory");
	Filelist=getFileList(SourceDir);
	SAVE_DIR=SourceDir;
	save_folder_name_add=File.getName(SourceDir);
	SERIES_2_OPEN=newArray(1);
	SERIES_2_OPEN[0]=1;
}

//save_folder=save_folder+"_"+save_folder_name_add;
// Remove Folders from Filelist array
tmp=newArray();
for(k=0;k<Filelist.length;k++)
{
	if (!File.isDirectory(SourceDir+"/"+Filelist[k]))
	{
		tmp = Array.concat(tmp,Filelist[k]); 
	}
}
Filelist=tmp;
if (!single_file){
	SERIES_COUNT=Filelist.length;
}

if(LOAD_ROI=="Load Selection")
{
	TISSUE_ROI_PATH = getDirectory("Select the folder containing the ROIs");
}

getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
month=month+1;
save_folder=save_folder+"_"+condition+"_Ch"+RED_Ch+"-"+Thres_Method_RED+"_Ch"+GREEN_Ch+"-"+Thres_Method_GREEN+"_Ch"+YELLOW_Ch+"-"+Thres_Method_YELLOW+"_"+year+""+month+""+dayOfMonth+"_"+hour+""+minute+""+second;
new_folder=SAVE_DIR + sep + save_folder;
File.makeDirectory(new_folder);
run("Input/Output...", "jpeg=85 gif=-1 file=.xls copy_row save_column save_row");

if (LOAD_ROI!="Manually Select" && auto_thr){
setBatchMode(true);
}

for (k=0;k<Filelist.length;k++)
{
	if(!endsWith(Filelist[k], sep))
	{
		SeriesNames=newArray(SERIES_COUNT);
		OrganoidArea=newArray(SERIES_COUNT);
		GREENTotalArea=newArray(SERIES_COUNT);
		YELLOWArea=newArray(SERIES_COUNT);
		REDArea=newArray(SERIES_COUNT);
		GREEN_MeanInt=newArray(SERIES_COUNT);
		YELLOW_MeanInt=newArray(SERIES_COUNT);
		RED_MeanInt=newArray(SERIES_COUNT);
		if(double_positive){
			RED_GREENArea=newArray(SERIES_COUNT);
			RED_GREEN_MeanInt=newArray(SERIES_COUNT);
			GREEN_REDArea=newArray(SERIES_COUNT);
			GREEN_RED_MeanInt=newArray(SERIES_COUNT);
			GREEN_YELLOWArea=newArray(SERIES_COUNT);
			GREEN_YELLOW_MeanInt=newArray(SERIES_COUNT);
			YELLOW_GREENArea=newArray(SERIES_COUNT);
			YELLOW_GREEN_MeanInt=newArray(SERIES_COUNT);
			RED_YELLOWArea=newArray(SERIES_COUNT);
			RED_YELLOW_MeanInt=newArray(SERIES_COUNT);
			YELLOW_REDArea=newArray(SERIES_COUNT);
			YELLOW_RED_MeanInt=newArray(SERIES_COUNT);
		}
		
		run("Bio-Formats Macro Extensions");
		Ext.setId(SourceDir+sep+Filelist[k]);
		Ext.getSeriesCount(SERIES_COUNT);
		FILE_PATH=SourceDir + sep + Filelist[k];
		for (i=0;i<SERIES_COUNT; i++) 
		{
			showProgress(i, SERIES_COUNT);
		 if(SERIES_2_OPEN[i]==1){
			options="open=["+ FILE_PATH + "] " + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT " + "series_"+d2s(i+1,0) + "";
			run("Bio-Formats Importer", options);
	//		FILE_NAME=File.getName(FILE_PATH);
			FILE_NAME=File.nameWithoutExtension;
			Ext.setSeries(i);
			Ext.getSeriesName(SERIES_NAMES2);
			SERIES_NAMES2=replace(SERIES_NAMES2, " ", "_");
			SERIES_NAMES2=replace(SERIES_NAMES2, "/", "_");
			SERIES_NAMES2=replace(SERIES_NAMES2, "\\(", "");
			SERIES_NAMES2=replace(SERIES_NAMES2, "\\)", "_");
			SeriesNames[i]=SERIES_NAMES2;
			SAVE_NAME=FILE_NAME+"_"+SERIES_NAMES2;
			rename(SAVE_NAME);
			initialImage=getTitle();
			getDimensions(width, height, channels, slices, frames);
			run("Set Measurements...", "area mean min display redirect=None decimal=3");
			if(slices>1){
				run("Z Project...", "projection=[Max Intensity]");
			}else{
				rename("MAX_"+SAVE_NAME);
			}
			MAX_ProjectionID=getImageID();
			MAX_ProjectionName=getTitle();
			run("Make Composite", "display=Composite");
			run("Enhance Contrast", "saturated=0.35");
			run("Median...", "radius=1.5");
			selectWindow(MAX_ProjectionName);
			if(LOAD_ROI=="Load Selection")
			{
//				LARGE_ROI_PATH = File.openDialog("Select the .zip file with the LARGE ROI");
				roiManager("Open", TISSUE_ROI_PATH + sep + SAVE_NAME+"_ROI"+".zip" );
			}else if (LOAD_ROI=="Manually Select")
			{
				setBatchMode("show");
				setTool("freehand");
				waitForUser("Select the tissue region");
				roiManager("Add");
				setBatchMode("hide");
			}else if (LOAD_ROI=="Select All FoV")
			{
				run("Select All");
				roiManager("Add");
			}
			roiManager("Select", 0);
			roiManager("Measure");
			OrganoidArea[i]=getResult("Area", 0);
			run("Clear Results");
			//selectImage(MAX_ProjectionID);
			selectWindow(MAX_ProjectionName);
			run("32-bit");
			run("Make Composite", "display=Composite");
			run("Split Channels");
			
			
		//Threshold and quantify GREEN Channel	
			selectWindow("C"+GREEN_Ch+"-"+MAX_ProjectionName);
			if(auto_thr)
			{
				setAutoThreshold(Thres_Method_GREEN+" dark stack");
				run("NaN Background", "stack");
			}else
			{
				//setBatchMode("show");
				waitForUser("Please select the threshold limits,press Apply and convert background to NaN\nThen click OK for this message");
				//setBatchMode("hide");
			}
			roiManager("Select", 0);
			roiManager("Measure");
			
			GREENTotalArea[i]=getResult("Area", 0);
			GREEN_MeanInt[i]=getResult("Mean", 0);
			run("Clear Results");
			run("Select None");
			//Make Binary Version
			run("Duplicate...", "title=C"+GREEN_Ch+"-Binary");
			setOption("BlackBackground", true);
			setThreshold(0.0001, 1000000000000000000000000000000.0000);
			run("Convert to Mask");
			run("32-bit");
			run("Divide...", "value=255");
			setAutoThreshold("Default dark no-reset");
			run("NaN Background");
			
		//Threshold and quantify YELLOW Channel		
			selectWindow("C"+YELLOW_Ch+"-"+MAX_ProjectionName);
			if(auto_thr)
			{
				setAutoThreshold(Thres_Method_YELLOW+" dark stack");
				run("NaN Background", "stack");
			}else
			{
				//setBatchMode("show");
				waitForUser("Please select the threshold limits,press Apply and convert background to NaN\nThen click OK for this message");
				//setBatchMode("hide");
			}
			roiManager("Select", 0);
			roiManager("Measure");
			
			YELLOWArea[i]=getResult("Area", 0);
			YELLOW_MeanInt[i]=getResult("Mean", 0);
			run("Clear Results");
			run("Select None");
			//Make Binary Version
			run("Duplicate...", "title=C"+YELLOW_Ch+"-Binary");
			setOption("BlackBackground", true);
			setThreshold(0.0001, 1000000000000000000000000000000.0000);
			run("Convert to Mask");
			run("32-bit");
			run("Divide...", "value=255");
			setAutoThreshold("Default dark no-reset");
			run("NaN Background");
		
		//Threshold and quantify RED Channel		
			selectWindow("C"+RED_Ch+"-"+MAX_ProjectionName);
			if(auto_thr)
			{
				setAutoThreshold(Thres_Method_RED+" dark stack");
				run("NaN Background", "stack");
			}else
			{
				//setBatchMode("show");
				waitForUser("Please select the threshold limits,press Apply and convert background to NaN\nThen click OK for this message");
				//setBatchMode("hide");
			}
			roiManager("Select", 0);
			roiManager("Measure");
			
			REDArea[i]=getResult("Area", 0);
			RED_MeanInt[i]=getResult("Mean", 0);
			run("Clear Results");
			run("Select None");
			//Make Binary Version
			run("Duplicate...", "title=C"+RED_Ch+"-Binary");
			setOption("BlackBackground", true);
			setThreshold(0.0001, 1000000000000000000000000000000.0000);
			run("Convert to Mask");
			run("32-bit");
			run("Divide...", "value=255");
			setAutoThreshold("Default dark no-reset");
			run("NaN Background");
			
			
			
//////// Double Positive Quantifications
			if(double_positive){
				if(R_G){
					imageCalculator("Multiply create 32-bit", "C"+RED_Ch+"-"+MAX_ProjectionName, "C"+GREEN_Ch+"-Binary");
					roiManager("Select", 0);
					roiManager("Measure");
					RED_GREENArea[i]=getResult("Area", 0);
					RED_GREEN_MeanInt[i]=getResult("Mean", 0);
					run("Clear Results");
					run("Select None");
					close();
				}
				if(G_R){
					imageCalculator("Multiply create 32-bit", "C"+GREEN_Ch+"-"+MAX_ProjectionName, "C"+RED_Ch+"-Binary");
					roiManager("Select", 0);
					roiManager("Measure");
					GREEN_REDArea[i]=getResult("Area", 0);
					GREEN_RED_MeanInt[i]=getResult("Mean", 0);
					run("Clear Results");
					run("Select None");
					close();
				}
				if(G_Y){
					imageCalculator("Multiply create 32-bit", "C"+GREEN_Ch+"-"+MAX_ProjectionName, "C"+YELLOW_Ch+"-Binary");
					roiManager("Select", 0);
					roiManager("Measure");
					GREEN_YELLOWArea[i]=getResult("Area", 0);
					GREEN_YELLOW_MeanInt[i]=getResult("Mean", 0);
					run("Clear Results");
					run("Select None");
					close();
				}
				if(Y_G){
					imageCalculator("Multiply create 32-bit", "C"+YELLOW_Ch+"-"+MAX_ProjectionName, "C"+GREEN_Ch+"-Binary");
					roiManager("Select", 0);
					roiManager("Measure");
					YELLOW_GREENArea[i]=getResult("Area", 0);
					YELLOW_GREEN_MeanInt[i]=getResult("Mean", 0);
					run("Clear Results");
					run("Select None");
					close();
				}
				if(R_Y){
					imageCalculator("Multiply create 32-bit", "C"+RED_Ch+"-"+MAX_ProjectionName, "C"+YELLOW_Ch+"-Binary");
					roiManager("Select", 0);
					roiManager("Measure");
					RED_YELLOWArea[i]=getResult("Area", 0);
					RED_YELLOW_MeanInt[i]=getResult("Mean", 0);
					run("Clear Results");
					run("Select None");
					close();
				}
				if(Y_R){
					imageCalculator("Multiply create 32-bit", "C"+YELLOW_Ch+"-"+MAX_ProjectionName, "C"+RED_Ch+"-Binary");
					roiManager("Select", 0);
					roiManager("Measure");
					YELLOW_REDArea[i]=getResult("Area", 0);
					YELLOW_RED_MeanInt[i]=getResult("Mean", 0);
					run("Clear Results");
					run("Select None");
					close();
				}
			}
			
			close(initialImage);
			// Available Options from run menu: ("RED", "YELLOW", "RED and YELLOW");
			run("Merge Channels...", "c1=[C"+RED_Ch+"-"+MAX_ProjectionName+"] c2=[C"+GREEN_Ch+"-"+MAX_ProjectionName+"] c3=[C"+YELLOW_Ch+"-"+MAX_ProjectionName+"] create");
	
			rename(MAX_ProjectionName);
			if(save_tif)
			{
				saveAs("tif", new_folder+ sep +SAVE_NAME+"_32bit_thresholded_MAX");
			}
			run("Close All");
			roiManager("save", new_folder+ sep + SAVE_NAME+"_ROI.zip");
			roiManager("reset");
		 }
		}
		row=0;
		for (i=0;i<SERIES_COUNT; i++) 
		{
			if(SERIES_2_OPEN[i]==1){
			setResult("Label", row, SeriesNames[i]);
			setResult("Condition", row, condition);
			setResult("Selected Total Area [um^2]", row, OrganoidArea[i]);
			
			setResult(""+GreenChannel+" Total Area [um^2]", row, GREENTotalArea[i]);
			setResult(""+RedChannel+" Total Area [um^2]", row, REDArea[i]);
			setResult(""+YellowChannel+" Total Area [um^2]", row, YELLOWArea[i]);
			
			setResult(""+GreenChannel+" Area Ratio ("+GreenChannel+"/Total Organoid Area)[0-1]", row, GREENTotalArea[i]/OrganoidArea[i]);
			setResult(""+RedChannel+" Area Ratio ("+RedChannel+"/Total Organoid Area)[0-1]", row, REDArea[i]/OrganoidArea[i]);
			setResult(""+YellowChannel+" Area Ratio  ("+YellowChannel+"/Total Organoid Area)[0-1]", row, YELLOWArea[i]/OrganoidArea[i]);
			
			setResult("Mean Intensity of "+GreenChannel+"", row, GREEN_MeanInt[i]);
			setResult("Mean Intensity "+RedChannel+"", row, RED_MeanInt[i]);
			setResult("Mean Intensity "+YellowChannel+"", row, YELLOW_MeanInt[i]);
			
			if(double_positive){
				if(R_G){
					setResult(""+RedChannel+" within "+GreenChannel+" Area Ratio ("+RedChannel+" in "+GreenChannel+" Area/Total Organoid Area)[0-1]", row, RED_GREENArea[i]/OrganoidArea[i]);
					setResult(""+RedChannel+" within "+GreenChannel+" Mean Intensity", row, RED_GREEN_MeanInt[i]);
				}
				if(G_R){
					setResult(""+GreenChannel+" within "+RedChannel+" Area Ratio ("+GreenChannel+" in "+RedChannel+" Area/Total Organoid Area)[0-1]", row, GREEN_REDArea[i]/OrganoidArea[i]);
					setResult(""+GreenChannel+" within "+RedChannel+" Mean Intensity", row, GREEN_RED_MeanInt[i]);
				}
				if(G_Y){
					setResult(""+GreenChannel+" within "+YellowChannel+" Area Ratio ("+GreenChannel+" in "+YellowChannel+" Area/Total Organoid Area)[0-1]", row, GREEN_YELLOWArea[i]/OrganoidArea[i]);
					setResult(""+GreenChannel+" within "+YellowChannel+" Mean Intensity", row, GREEN_YELLOW_MeanInt[i]);
				}
				if(Y_G){
					setResult(""+YellowChannel+" within "+GreenChannel+" Area Ratio ("+YellowChannel+" in "+GreenChannel+" Area/Total Organoid Area)[0-1]", row, YELLOW_GREENArea[i]/OrganoidArea[i]);
					setResult(""+YellowChannel+" within "+GreenChannel+" Mean Intensity", row, YELLOW_GREEN_MeanInt[i]);
				}
				if(R_Y){
					setResult(""+RedChannel+" within "+YellowChannel+" Area Ratio ("+RedChannel+" in "+YellowChannel+" Area/Total Organoid Area)[0-1]", row, RED_YELLOWArea[i]/OrganoidArea[i]);
					setResult(""+RedChannel+" within "+YellowChannel+" Mean Intensity", row, RED_YELLOW_MeanInt[i]);
				}
				if(Y_R){
					setResult(""+YellowChannel+" within "+RedChannel+" Area Ratio ("+YellowChannel+" in "+RedChannel+" Area/Total Organoid Area)[0-1]", row, YELLOW_REDArea[i]/OrganoidArea[i]);
					setResult(""+YellowChannel+" within "+RedChannel+" Mean Intensity", row, YELLOW_RED_MeanInt[i]);
				}
			}

			row++;
			updateResults();
			}
		}
		
		selectWindow("Results");
		saveAs("Results", new_folder+ sep +"Results_ALL-"+condition+".txt");
		run("Clear Results");
		run("Close All");
		roiManager("reset");
	}
}
setBatchMode(false);