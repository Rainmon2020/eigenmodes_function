for i in {175..240}; do
    sid=$(printf "sub-CA%04d" $i)
    echo "Processing ${sid}"

    for hemisphere in 'lh' 'rh'; do
        echo "Processing ${hemisphere}"

        for t in {0..179}; do
            t=$(printf $t)
            echo "Processing ${t}"
            mri_vol2surf --src "/v16data/user_data/lym/Adapt_Result/fmriprep/sourcedata/3D_NII/${sid}_task-rest_T1W_bold_3d_${t}.nii" \
                         --out "/v16data/user_data/lym/Adapt_Result/fmriprep/sourcedata/3D_GII/${sid}_${hemisphere}_func_midthickness_${t}.gii" \
                         --regheader "${sid}" \
                         --hemi "${hemisphere}" \
                         --surf midthickness
        done
    done
done
