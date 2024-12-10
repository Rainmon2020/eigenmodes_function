for i in {241..483}; do
	sid=$(printf "sub-CA%04d" $i)
	mri_binarize --i /v16data/user_data/lym/Result/fmriprep/sourcedata/freesurfer/${sid}/mri/aparc.a2009s+aseg.mgz --min 1000 --o /v16data/user_data/lym/Result/fmriprep/sourcedata/mask/${sid}_cortex_mask.mgz
	for hemisphere in lh rh; do
		mri_vol2surf --src /v16data/user_data/lym/Result/fmriprep/sourcedata/mask/${sid}_cortex_mask.mgz --out /v16data/user_data/lym/Result/fmriprep/sourcedata/mask/${sid}_${hemisphere}_cortex_mask.gii \
		--regheader ${sid} \
		--hemi ${hemisphere} --surf midthickness
	done
done
