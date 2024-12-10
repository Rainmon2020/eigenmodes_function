# eigenmodes_function
Coupling of Cortical Geometric Features and Function Based on Individual Space
Required data includes:
1. Surface data output by freesurfer (using the midthickness structure), which needs to be converted to vtk format, and processed through LBO operation to obtain eigenmodes.
2. Functional data, resting state extracted from the 4D-nifti file of timeseries, task state extracted from the activated map after modeling.
3. Cortex_mask, output as a mask according to the aparc.aseg.mgz file and registered to the surface file with corresponding vertices.
4. Parcellation: Map functional templates, such as Schaefer2018, to individual cortical space.
Step 1: Convert cortical data to vtk format and calculate eigenmodes.
1. Execute eigenmodes_nomask_group.sh (needs to be placed in the same folder as surface_eigenmodes.py).
Step 2: Output rfMRI data:
1. Execute 4dto3d.py, which aims to convert the rfMRI individual space T1w 4Dnii data to 3Dnii.
2. Execute nii2gii.sh, which aims to register the rfMRI data to individual cortical space - mri_vol2surf.
3. Execute gen_func_mat.py, which aims to extract rfMRI data for each vertex, forming an N x M matrix of vertex number N by TR number M.
Step 3: Output cortex mask.
1. Execute mask2gii.sh, which aims to compute the mask of the cortex in individual space, setting the cortex label to 1 and the rest to 0, then project the cortex mask to individual cortical space.
Step 4: Map functional templates, like Schaefer2018, to individual cortical space.
1. Execute schaefer_annot.sh
Step 3 & 4
2. Execute annot2txt.py, which aims to convert the annot file of the Schaefer template into a readable txt file and convert the cortex mask gii file into a txt file.
