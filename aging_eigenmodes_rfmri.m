%% Load surface files for visualization
num_sub = 960;
maindir = '/brain/zhang_group/Desktop/LiYuMeng/Geometric_brain/Temperature'
cd (maindir)
load('subset.mat');
for i =814:num_sub
    surface_interest = fileID{i};
     for hemis = {'lh', 'rh'}
        hemisphere = hemis{1}

        mesh_interest = 'midthickness';
        
        [vertices, faces] = read_vtk(sprintf('brainprint/%s_%s_%s.vtk', surface_interest, hemisphere, mesh_interest));
        surface_midthickness.vertices = vertices';
        surface_midthickness.faces = faces';
        
        % Load cortex mask
        cortex = dlmread(sprintf('mask_txt/%s_cortex-%s_mask.txt', surface_interest, hemisphere));
        cortex_ind = find(cortex);
        
        %% Reconstruct a single-subject resting-state fMRI spatiotemporal map and FC matrix
        
        %hemisphere = 'rh';
        num_modes = 200;
        
        % =========================================================================
        %                    Load eigenmodes and empirical data                    
        % =========================================================================
        
        % Load 200 fsLR_32k template midthickness surface eigenmodes
        eigenmodes = dlmread(sprintf('eigenmodes/%s_midthickness-%s_emode_%i.txt', surface_interest, hemisphere, num_modes));
        
        % Replace above line with the one below and make num_modes = 200 if using the 200 modes provided at data/template_eigenmodes
        % eigenmodes = dlmread(sprintf('data/template_eigenmodes/fsLR_32k_midthickness-%s_emode_%i.txt', hemisphere, num_modes));
        
        % Load example single-subject rfMRI time series data
        data = load(sprintf('rfmri_emode/%s_rfMRI_timeseries-%s.mat', surface_interest, hemisphere));
        data_to_reconstruct = data.timeseries;
        T = size(data_to_reconstruct, 2);
        
        % =========================================================================
        % Calculate reconstruction beta coefficients using 1 to num_modes eigenmodes
        % =========================================================================
        
        recon_beta = zeros(num_modes, T, num_modes);
        for mode = 1:num_modes
            basis = eigenmodes(cortex_ind, 1:mode);
            
            recon_beta(1:mode,:,mode) = calc_eigendecomposition(data_to_reconstruct(cortex_ind,:), basis, 'matrix');
        end
        
        % =========================================================================
        %     Calculate reconstruction accuracy using 1 to num_modes eigenmodes    
        % =========================================================================
        
        % reconstruction accuracy = correlation of empirical and reconstructed data
        
        % At parcellated level
        parc_name = 'Schaefer400';
        parc = dlmread(sprintf('parcellations/%s_%s-%s.txt', surface_interest, parc_name, hemisphere));
        num_parcels = length(unique(parc(parc>0)));
        
        % Extract upper triangle indices
        triu_ind = calc_triu_ind(zeros(num_parcels, num_parcels));
        
        % Calculate empirical FC
        data_parc_emp = calc_parcellate(parc, data_to_reconstruct);
        data_parc_emp = calc_normalize_timeseries(data_parc_emp');
        data_parc_emp(isnan(data_parc_emp)) = 0;
        
        FC_emp = data_parc_emp'*data_parc_emp;
        FC_emp = FC_emp/T;
        FCvec_emp = FC_emp(triu_ind);
        
        % Calculate reconstructed FC and accuracy (slow to run with more modes)
        FCvec_recon = zeros(length(triu_ind), num_modes);
        recon_corr_parc = zeros(1, num_modes);               
        for mode = 1:num_modes
            recon_temp = eigenmodes(:, 1:mode)*squeeze(recon_beta(1:mode,:,mode));
         
            data_parc_recon = calc_parcellate(parc, recon_temp);
            data_parc_recon = calc_normalize_timeseries(data_parc_recon');
            data_parc_recon(isnan(data_parc_recon)) = 0;
        
            FC_recon_temp = data_parc_recon'*data_parc_recon;
            FC_recon_temp = FC_recon_temp/T;
        
            FCvec_recon(:,mode) = FC_recon_temp(triu_ind);
                            
            recon_corr_parc(mode) = corr(FCvec_emp, FCvec_recon(:,mode));
        end
        
        % =========================================================================
        %                      Some visualizations of results                      
        % =========================================================================
        
        % Reconstruction accuracy vs number of modes at parcellated level
%         figure('Name', 'rfMRI reconstruction - accuracy');
%         hold on;
%         plot(1:num_modes, recon_corr_parc, 'b-', 'linewidth', 2)
%         hold off;
%         set(gca, 'fontsize', 10, 'ticklength', [0.02 0.02], 'xlim', [1 num_modes], 'ylim', [0 1])
%         xlabel('number of modes', 'fontsize', 12)
%         ylabel('reconstruction accuracy', 'fontsize', 12)
%         
%         % Reconstructed FC using N = num_modes modes
        N = num_modes;
        FC_recon = zeros(num_parcels, num_parcels);
        FC_recon(triu_ind) = FCvec_recon(:,N);
        FC_recon = FC_recon + FC_recon';
        FC_recon(1:(num_parcels+1):num_parcels^2) = 1;
%         
%         fig1 = sprintf('%s-%s-rfMRI-acc.png',surface_interest,hemisphere)
%         saveas(gca, fig1)
%         
%         figure('Name', sprintf('rfMRI reconstruction - FC matrix using %i modes', N));
%         imagesc(FC_recon)
%         caxis([-1 1])
%         colormap(bluewhitered)
%         cbar = colorbar;
%         set(gca, 'fontsize', 10, 'ticklength', [0.02 0.02])
%         xlabel('region', 'fontsize', 12)
%         ylabel('region', 'fontsize', 12)
%         ylabel(cbar, 'FC', 'fontsize', 12)
%         axis image
%         fig2 = sprintf('%s-%s-rfMRI-FC.png',surface_interest,hemisphere)
%         saveas(gca, fig2)
%         % Calculate modal power spectral content of spatial maps
%         N = length(recon_corr_parc)-1
%         acc_increase=[];
%         for i=1:N
%             j=i+1
%             acc=recon_corr_parc(j)-recon_corr_parc(i)
%             acc_increase = cat(1,acc_increase,acc)
%         end
%         h = bar(acc_increase);
%         fig3 = sprintf('%s-%s-acc-increase.png',surface_interest,hemisphere)
%         saveas(h, fig3)
        
        all_var = sprintf('result/%s-%s.mat',surface_interest,hemisphere)
        save(all_var,'recon_corr_parc','FC_recon','recon_beta');
     end
end
        

