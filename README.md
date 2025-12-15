<h1>🔬 ExpressionLevelsCalculation Macro</h1>
An automated workflow for quantifying gene expression and co-expression levels in multi-channel (4-channel) fluorescence maximum intensity projection (MIP) images.

<h2>Table of Contents</h2>









<h2>Overview</h2>
This macro provides a robust, batch-processable solution for analyzing 4-channel maximum intensity projection (MIP) images typically derived from fluorescence microscopy acquisitions.

The primary function of the macro is to:

Identify Regions of Interest (ROIs): Use the Nuclear Marker (Channel 1) to automatically segment and delineate individual cell nuclei, which serve as the primary ROIs.

Quantify Expression: Measure the mean intensity of Marker 1 (Channel 2), Marker 2 (Channel 3), and Marker 3 (Channel 4) within each defined nuclear ROI.

Calculate Co-expression: Allow for subsequent calculation of co-expression ratios or percentages based on the quantified intensity values.

This tool ensures highly reproducible quantification across large datasets, making it ideal for high-throughput gene expression studies.

<h2>Features</h2>
The macro offers the following key capabilities for image analysis:

✅ 4-Channel Support: Specifically designed to handle 4-channel stack images (Channel 1: Nucleus; Channels 2-4: Targets).

✅ Automated Nuclear Segmentation: Uses thresholding and watershed techniques on the nuclear channel to accurately identify individual cells.

✅ Intensity Quantification: Measures key parameters (e.g., Mean Intensity, Integrated Density) for all three target markers (Ch 2, Ch 3, Ch 4) within the nuclear boundary.

✅ Batch Processing: Processes an entire folder of images automatically, saving significant time.

✅ Result Export: Exports all measured values (per-cell data) into a single, comprehensive CSV file for external analysis.

✅ Quality Control (Optional): Saves a final composite image with segmented ROIs overlaid for visual inspection of the segmentation quality.

<h2>Installation</h2>
This section explains how a user can get the macro running in their ImageJ/Fiji environment.

<h3>Prerequisites</h3>
ImageJ/Fiji: Ensure you have the latest stable version of installed.

Required Plugins: This macro relies only on core Fiji functionality and should not require additional plugin installation.

<h3>Steps</h3>
Download: Download the macro file, ExpressionLevelsCalculation.ijm, directly from this repository.

Locate the Macros Folder: Place the macro file in the Fiji.app/macros directory of your Fiji installation.

Alternative: You can simply drag and drop the .ijm file onto the main ImageJ window to load it temporarily.

Restart ImageJ/Fiji: Close and reopen ImageJ/Fiji for the macro to appear in the Plugins > Macros menu.

<h2>Usage</h2>
Step-by-step instructions on how to execute the macro.

Preparation: Ensure all your input 4-channel MIP images (e.g., .tif, .oif, .czi converted to a TIFF stack) are placed into a single designated Input Folder.

Run the Macro:

Go to Plugins > Macros > Run... and select ExpressionLevelsCalculation.ijm.

If installed: You may find it directly under Plugins > Macros > ExpressionLevelsCalculation.

Configure Parameters: A dialog box will appear. You will need to specify:

Input Directory: The folder containing your raw 4-channel MIP images.

Output Directory: A separate, empty folder where the processed results and QC images will be saved.

Channel Order: Confirm the order of your channels (e.g., C1=DAPI, C2=Marker1, etc.).

Segmentation Parameters: Adjust the thresholding method (e.g., Otsu, Default) and required particle size limits (e.g., 50-Infinity pixels$^2$).

Execute: Click OK to start the batch process.

Input and Output
Clearly define what the macro expects and what it produces.

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
