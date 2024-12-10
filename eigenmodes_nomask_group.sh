structure='midthickness'
hemispheres='lh rh'
num_modes=200
save_cut=0

for i in {167..240}; do
	sid=$(printf "sub-CA%04d" $i)
	echo Processing ${sid}
	for hemisphere in ${hemispheres}; do
		echo Processing ${hemisphere}

		surface_raw_filename=/v16data/user_data/lym/Adapt_Result/fmriprep/sourcedata/freesurfer/${sid}/surf/${hemisphere}.midthickness

		surface_input_filename=/v16data/user_data/lym/Adapt_Result/fmriprep/sourcedata/brainprint/${sid}_${hemisphere}_${structure}.vtk
		
		eval mris_convert ${surface_raw_filename} ${surface_input_filename} 


    	# without cortex mask
    	is_mask=0
    	output_eval_filename=/v16data/user_data/lym/Adapt_Result/fmriprep/sourcedata/eigenmodes/${sid}_${structure}-${hemisphere}_eval_${num_modes}.txt
    	output_emode_filename=/v16data/user_data/lym/Adapt_Result/fmriprep/sourcedata/eigenmodes/${sid}_${structure}-${hemisphere}_emode_${num_modes}.txt

    	python surface_eigenmodes.py ${surface_input_filename} \
    							 ${output_eval_filename} ${output_emode_filename} \
    							 -save_cut ${save_cut} -N ${num_modes} -is_mask ${is_mask}
	done
done

