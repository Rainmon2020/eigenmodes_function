# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 17:55:34 2024

@author: 20202
"""

import os
import nibabel as nib

input_dir = '/v16data/user_data/lym/Result/fmriprep'
output_dir = '/v16data/user_data/lym/Result/fmriprep/sourcedata/test'

for i in range(420, 421):
    sub_id = f'CA{str(i).zfill(4)}'
    file_path = os.path.join(input_dir, f'sub-{sub_id}/func/sub-{sub_id}_task-rest_space-T1w_desc-preproc_bold.nii.gz')

    if os.path.exists(file_path):
        img_4d = nib.load(file_path)
        data_4d = img_4d.get_fdata()

        for t in range(data_4d.shape[-1]):
            data_3d = data_4d[..., t]
            img_3d = nib.Nifti1Image(data_3d, img_4d.affine)

            filename = f'sub-{sub_id}_task-rest_T1W_bold_3d_{t}.nii'
            filepath = os.path.join(output_dir, filename)
            nib.save(img_3d, filepath)
