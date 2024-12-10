# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 21:40:32 2024

@author: 20202
"""

#将Scheafer annot文件转为txt
locals().clear()
import nibabel as nib
import os
import numpy as np

input_dir = '/v16data/user_data/lym/Adapt_Result/fmriprep/sourcedata/label'
output_dir = '/v16data/user_data/lym//empirical/parcellations'

num_sub = 240;

for i in range(101, num_sub+1):
    sub_id = f'CA{str(i).zfill(4)}'
    for hemi in ['lh', 'rh']:       
        filename = f'sub-{sub_id}_{hemi}.Schaefer400.annot'
        annot_file = os.path.join(input_dir, filename)
        img = nib.freesurfer.read_annot(annot_file)
        # 保存标签到txt文件
        labels = img[0]
        output_filename = os.path.join(output_dir, f'sub-{sub_id}_Schaefer400-{hemi}.txt')
        np.savetxt(output_filename, labels, fmt='%d')


import nibabel as nib
import numpy as np

input_dir = '/v16data/user_data/lym/Adapt_Result/fmriprep/sourcedata/mask'
output_dir = '/v16data/user_data/lym/empirical/mask'


for i in range(101, num_sub+1):
    sub_id = f'CA{str(i).zfill(4)}'
    for hemi in ['lh', 'rh']:       
        filename = f'sub-{sub_id}_{hemi}_cortex_mask.gii'
        gii_file = os.path.join(input_dir, filename)
        gii_data = nib.load(gii_file)
        # 保存标签到txt文件
        data_array = gii_data.darrays[0].data
        output_filename = os.path.join(output_dir, f'sub-{sub_id}_cortex-{hemi}_mask.txt')
        np.savetxt(output_filename, data_array, fmt='%d')








