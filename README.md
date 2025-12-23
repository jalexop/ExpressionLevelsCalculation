<h1>🔬 ExpressionLevelsCalculation Macro</h1>
An automated workflow for quantifying markers' expression and co-expression levels in multi-channel (4-channel) fluorescence images.
<br>
<h2>Overview</h2>
<p>This macro provides a robust, batch-processable solution for analyzing 4-channel images typically derived from fluorescence microscopy acquisitions. If the acquired images are xy z-stacks, then the macro projects all the channels in a maximum intensity projection (MIP) which is then analysed.</p>

The primary function of the macro is to:

Quantify Expression: Measure the mean intensity of the positive signal of Marker 1, Marker 2, and Marker 3 within the user defined region of analysis. The marker's expression level is also quantified as a ratio of the marker's positive area (upon thresholding) by the size of the total selection area.

Calculate Co-expression: Upon the union of the positive pixels (Marker 1&2, and/or Marker 1&3 and/or Marker 2&3), the macro quantifies the mean fluoresnce instensities as well as the area of the double positive pixels in each case.

This tool ensures highly reproducible quantification across large datasets, making it ideal for high-throughput gene expression studies.

<h2>Features</h2>
The macro offers the following key capabilities for image analysis:

✅ 4-Channel Support: Specifically designed to handle 4-channel stack images (e.g. Channel 1: Nucleus; Channels 2-4: Targets).

✅ Intensity Quantification: Measures key parameters (e.g., Mean Intensity) for all three target markers (Ch 2, Ch 3, Ch 4).

✅ Expression Levels: Measures for each marker the "positive" area, normilizing this by the total selection area.

✅ Batch Processing: Processes all selected images within an image container file ot within an entire folder, saving significant time.

✅ Result Export: Exports all measured values (per-cell data) into a single, comprehensive tab-separated TXT file for external analysis.

✅ Quality Control (Optional): Saves a final composite image with segmented channels overlaid for visual inspection of the segmentation quality.

<h2>Installation</h2>
This section explains how a user can get the macro running in their ImageJ/Fiji environment.

<h3>Prerequisites</h3>
ImageJ/Fiji: Ensure you have the latest stable version of ImageJ / Fiji installed (minimum version 1.53f).
Required Plugins: This macro relies only on core Fiji functionality and should not require additional plugin installation.

<h3>Steps</h3>
Download: Download the macro file, Quantify_ExpressionLevels_4Ch_Generic.ijm, directly from this repository.

Locate the plugins Folder: Place the macro file in the Fiji.app/plugins directory of your Fiji installation.

Alternative: You can simply drag and drop the .ijm file onto the main ImageJ window to load it temporarily.

Restart ImageJ/Fiji: Close and reopen ImageJ/Fiji for the macro to appear in the Plugins menu.

<h2>Usage</h2>
Step-by-step instructions on how to execute the macro.

Preparation: Ensure you have reading and writing permissions on the folder with the acquisition data.

Run the Macro:

Go to Plugins menu and select Quantify_ExpressionLevels_4Ch_Generic.ijm.

If installed: You may find it directly under Plugins > Quantify_ExpressionLevels_4Ch_Generic.ijm.

Configure Parameters: Two dialog boxes will appear. For the first you will need to specify the name of the markers:
<img width="278" height="224" alt="image" src="https://github.com/user-attachments/assets/0893229a-e16a-48fd-a6cf-b45cf0aec719" />

For the second dialogue box the user needs to specify the following:

<img width="395" height="682" alt="image" src="https://github.com/user-attachments/assets/5d2bfc41-fb01-43bb-95f5-af8443a75934" />

<h3>General Parameters</h3>
Analyse single image container file: Deselect this if you have an input folder with all your acquisition data in.

Name of Saving folder: The initial name of the saving folder where the processed results and QC images will be saved. The folder will be created under the same directory where the input file(s) are located.

<h3>Channel Order</h3>
Confirm the order of your channels (e.g., C1=DAPI, C2=Marker1, etc.).

<h3>Analysis Parameters</h3>
Area to Analyse: Either manually selected for each image that will be analysed or the whole field of view, or you will be asked to provide a folder with saved ROIs from a previous analysis. The name of these ROIs needs to correspond to the image name (for example saved from this macro from a previous run.

Quantify Double Positive Areas: If not selected the macro will quantify the expression levels of each individual marker. If this option will be selected, then the user needs to select one or more of the folowing co-expression options (e.g. Marker1 within Marker2)

<h3>Thresholding Parameters</h3>
Automatic Threshold: If selected (recommended), the macro will threshold the marker's channels using the selected built-in algorithms from the following selections.
Save Thresholded Projections: If selected , the macro will save the overlay of the thresholded channels as maximum intensity projections.

<h3>Execution</h3>
By selecting OK, the macro will ask for the specific file to process (or the input folder in case that the image container file option is not selected). One single file container is selected, then the macro will ask for which images will be processed (see figure below)
<img width="281" height="312" alt="image" src="https://github.com/user-attachments/assets/e980768c-bbd3-41e9-ad53-db994cee8983" />


Input Files
Type: Multi-channel images saved as TIFF stacks (e.g., *.tif).

Format: Must be a 4-channel image stack.

Channel 1: Nuclear Marker (for segmentation).

Channel 2: Target Marker 1.

Channel 3: Target Marker 2.

Channel 4: Target Marker 3.

Output Files
Expression_Results.csv: A comprehensive table containing the per-cell measurements.

Columns include: Image Name, ROI ID, Area, Mean Intensity (C2), Mean Intensity (C3), Mean Intensity (C4), Integrated Density, etc.

QC_segmentation_ImageName.tif: (Optional) The original image with the successfully segmented ROIs overlaid for quality control purposes.

<h2>Examples</h2>
Requirements
ImageJ Version: 1.53n or later (Fiji is highly recommended).

Memory: Recommended 8GB of RAM allocated to ImageJ for batch processing high-resolution images (Edit > Options > Memory & Threads...).

<h2>License</h2>
This project is licensed under the MIT License - see the file for details.

<h2>Contact and Support</h2>
Author: Your Name/GitHub Handle

Reporting Issues: Please use the Issues tab on this GitHub repository to report bugs or suggest enhancements.
