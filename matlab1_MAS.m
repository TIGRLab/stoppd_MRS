% /scratch/rutwik/MAS/dataset_sim
% /archive/data-2.0/STOPPD/data/nii
%% Getting path to subjects directory
prompt = 'Enter the path of folder where all subjects are located: ';
N = 100;
for t=1:N
    str = input(prompt,'s');
    if ~isempty(str)
        %change directories into the parent folder
        cd(str);
        break;
    end
end
%% Get the path to the nifti folder
prompt2 = 'Enter the path of the folder containing nifti files: ';
M = 100;
for u=1:M
    str2 = input(prompt2,'s');
    if ~isempty(str2)
        %the folder of nifti files is now stored in str2
        break;
    end
end

%% The other stuff
D = dir;
p=1;
%outer loop that goes over all subject folders
for i = 3:length(D)
    %% Adjusting the naming convention
    
    % %     %change directories into each subject's folder
    % %     current = fullfile(pwd,D(i).name);
    
    %get the subject id
    name_split = strsplit(D(i).name,'_');
    
    
   % truncated = [name_split(1), name_split(2), name_split(3),name_split(4)];
    %adjusted_name = strjoin(truncated,{'_','_','_'});
   truncated = [name_split(2),name_split(3)];
   adjusted_name = strjoin(truncated,{'_'});
   
    
    %newdir = sprintf('%s_%s','MRS',adjusted_name);
     newdir = sprintf('%s_%s','MRS_STOPPD_MAS',adjusted_name);
     newname = sprintf('%s_%s','STOPPD_MAS',adjusted_name);

    mkdir(newdir);
    movefile(D(i).name,newdir);
    
    
    %drop the last part of the file name
    %% Importing the nifti file
    %identify subject's nifti folder
    
    half_path = fullfile(str2,newname);
    final = fullfile(half_path,'/**T1**nii*');
    new_struct= rdir(final);
    
    try
    nifti = new_struct(1).name;
    
    %unzip the nifti file
    gunzip(nifti,newdir);
    cd(newdir);
    local_dir = dir('*.nii');
    local_nifti = local_dir.name;
    %% Processing the spar files
    %get the spar file for each ROI
   
    try
        
        dlpfc_spar = fullfile(str,newdir,'/**LTDIPFC**act.SPAR');
        d_struct   = rdir(dlpfc_spar);
        d_name     = d_struct(1).name
        
        sacc_spar  = fullfile(str,newdir,'/**SACC**act.SPAR');
        s_struct   = rdir(sacc_spar);
        s_name     = s_struct(1).name;
%         splitname = strsplit(current_spar,'_');
%         ROI_name = splitname(7);
%         %don't know why there are 2 spar files for each ROI but the ones that have are labelled ref do not produce a good MRS result and the
%         %ones that have 'act' in the label do.
%         act = splitname(11) ;
%         is_act = strcmp (act,'act.SPAR');
%         is_SACC = strcmp(ROI_name,'SACC');
%         is_DLPFC = strcmp(ROI_name,'LTDIPFC');
%         ROI_char = splitname{7};
        
           %gannetmask here
            GannetMask_Philips(d_name,local_nifti);
            
            %save the output image for QC purposes. This figure extraction
            %tool uses a third party function called export_fig, which can
            %be found in a separate folder. Refer to the readme doc for
            %more information
            export_fig( gcf, ...      % figure handle
                'DLPFC',... % name of output file without extension
                '-painters', ...      % renderer
                '-jpg', ...           % file format
                '-r72' );             % resolution in dpi
            %--------------------------------------------------------------
             
       
            %gannetmask here
            GannetMask_Philips(s_name,local_nifti);
            
            export_fig( gcf, ...      % figure handle
                'SACC',... % name of output file without extension
                '-painters', ...      % renderer
                '-jpg', ...           % file format
                '-r72' );             % resolution in dpi
        
       
        
     end

    catch
        warning('nifti not available for subject %s\n',adjusted_name);
    end
    
    
    % End of the loop
    cd(str);
end


% % % % GannetMask_Philips('data.SPAR','input.nii');
% % %
% % % for subject_directories in main_directory
% % %   change directories to each subject
% % %
% % %   for files in directory
% % %
% % %       -namesplit by delimiter _ -> grab subject id
% % %       -copy the nifti file from the nii folder
% % %       -if 8th field is LTDIPFC & extension is spar
% % %           run gannetmask_Philips
% % %
% % %           *---->>>need to save the images as jpg
% % %
% % %       -run same procedure for 8th field being SACC
% % %         gannetmask_philips
% % %
% % %
% % %         %this will generate the roi placement images for QC
% % %
% % %      for each spar file, on the first iteration run gannet for sacc
% and the second run for the dlpfc
% % %