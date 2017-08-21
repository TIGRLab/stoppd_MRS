# stoppd_MRS

<h2>1. Need to download the following software for scripts to work:</h2>
	- Gannet2.0<br>
	- SPM 8<br>
	- print_raw_headers (for GE scanner only)<br>

<h2>Script 1: Master_1.sh</h2>
	- shell script, run through terminal<br>
	- type which site's data to process<br>
	- enter data input/output paths as directed by script<br>
	- enter matlab dependencies:<br>
		- Save scripts/gannet/spm in one folder and enter in that path when dependencies are required

<h4> Script Description: </h4>
	- reads information from header files <br>
	- data organization: moving files into folders for easy access (cmh data only)<br>
	- links to matlab script: matlab1_xxx, where xxx is the site name<br>

- matlab1 script runs gannet to place voxels on brain using a T1 weighted image
	- It also saves the matlab produced images as jpgs
	- The images are useful for QC analysis to check if the orientation of each voxel is correct
	- The subject specific T1 image (.nii) is located by the script from /archive/data/STOPPD/data/nii
	- The matlab script also requires input to the parent directory which contains all subjects

<h2>Script 2: Master_2</h2>
	- second shell script, run through terminal and enter input/output paths when prompted<br>
	- Before running this script make sure to go through all images produced by the previous
	   script and ensure that the voxel orientations are correct	<br>
	- <strong>Refer to the document 'QC1_instructions' for details if the voxels are incorrectly oriented</strong><br>
	- <b>The 'Protocol' document shows pictures of what the voxels should look like</b>

<h4> Script Description: </h4>
	- uses FSL and BET (Brain extraction tool) to generate csf fraction values and voxel volume for each ROI<br>
	- also creates masks in nifti format<br>
	- <b>If LCModel can be automated it needs to be run within this script. The exact location is shown in the script with comments</b>

- Links to a matlab script 'csv_creation.m'
	- Need to create versions of this script to ensure it runs for other sites, right now only written for cmh data
	- csv_creation.m calls a function navigate_to_MRS.m, these two scripts are responsible for extracting information 
	  from lcmodel text files which contain metabolite concentrations, %standard deviation, and other important info.
	- only slight syntax changes should be necessary to modify these scripts in order to adapt them to data from other sites
	- at the end of this script, there will be an sgacc folder and a dlpfc folder, each containing their respective table file, plot.pdf (both lcmodel outputs) as well as the generated csv file with the extracted metabolite information. The script also takes care of csf correction.

<h2> Scripts that still need to be written: </h2> 
	- matlab1_PMC.m (use matlab1_xxx from any site as a template)<br>
	- csv_creation_MAS.m, csv_creation_NKI.m, csv_creation_PMC.m <br>
		- Before creating these files it is necessary to have the results from LCModel ready

