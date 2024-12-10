for i in {241..483}; do
    sid=$(printf "sub-CA%04d" $i)
    for hemisphere in lh rh; do
        annot_name="/v16data/user_data/lym/CBIG-master/stable_projects/brain_parcellation/Schaefer2018_LocalGlobal/Parcellations/FreeSurfer5.3/fsaverage/label/${hemisphere}.Schaefer2018_400Parcels_7Networks_order.annot"
        output_name="/v16data/user_data/lym/Result/fmriprep/sourcedata/label/${sid}_${hemisphere}.Schaefer400.annot"
        mri_surf2surf --hemi ${hemisphere} \
            --srcsubject fsaverage \
            --trgsubject ${sid} \
            --sval-annot ${annot_name} \
            --tval ${output_name}
    done
done
