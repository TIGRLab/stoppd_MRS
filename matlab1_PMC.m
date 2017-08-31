%% Subject folder location
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
%%
D = dir;

%use counters to ensure numbers are correct, these are optional
num = 0;
counter =1;

%outer for loop that loops through the output_STOPPD... subject folders
for i = 3:length(D)
    %% Get the nifti file
    
    name_split = strsplit(D(i).name,'_');
    join_these = [name_split(1),name_split(2),name_split(3)];
    adjusted_name = strjoin(join_these,{'_','_'});
    
    newname = sprintf('%s_%s','STOPPD',adjusted_name);
    %name split to get rid of the last delimeter
       
    
    current = fullfile(pwd,D(i).name);
    num = num + 1;
    cd(current);
    %%
    %make 2 different directories for TE = 120 and TE = 30
    mkdir TE_30
    mkdir TE_120
    
    half_path = fullfile(str2,newname);
    final = fullfile(half_path,'/**T1**nii*');
    new_struct= rdir(final);

    %% Try and check statements to ensure nifti file exists
    try
        nifti = new_struct(1).name;
        
        %unzip the nifti file
        gunzip(nifti,current);
        cd(current);
        local_dir = dir('*MPRAGE.nii');
        local_nifti = local_dir.name;
        %getting the list of the .7 files in the current directory
        rda_files = dir('*.rda');
        
        for k=1:length(rda_files)
            
            current_rda = rda_files(k).name;
            splitname = strsplit(current_rda,'_');
            %need to split these files by echo time to make sure data isn't mixed
            TE = splitname(4);
            TE_string = splitname{4};
            
            try % inconsistent naming conventions -_-
            ROI_name = splitname(6);
            %char format
            ROI_char = splitname{6};
            
            catch
                ROI_name = splitname(5);
                ROI_char = splitname{5};
            end
            
            nifti_path = fullfile(current,local_nifti);
            is_30 = strcmp(TE,'30');
            
                            image_label = sprintf('%s_%s',ROI_char,TE_string);

            if is_30 == 1
            %movefile then gannet
                movefile(current_rda,'TE_30');
                cd TE_30
                
                GannetMask_Siemens(current_rda,nifti_path);
                
                %image_label = sprintf('%s_%s',ROI_char,TE_string);

                export_fig( gcf, ...      % figure handle
                    image_label,... % name of output file without extension
                    '-painters', ...      % renderer
                    '-jpg', ...           % file format
                    '-r72' );             % resolution in dpi
                
                
                cd(current)
            else %gannet mask for the TE 120 is handled separately to avoid confusion
                movefile(current_rda,'TE_120');
                cd TE_120
                GannetMask_Siemens(current_rda,nifti_path);
                
                
                export_fig( gcf, ...      % figure handle
                    image_label,... % name of output file without extension
                    '-painters', ...      % renderer
                    '-jpg', ...           % file format
                    '-r72' );             % resolution in dpi
                
                cd(current)
            end
                        
        end
        
    catch
        warning('nifti not available for subject %s\n', adjusted_name);
    end
    
    
    %change directories to the same one that contains all subject folders
    cd(str);
    
end %end of loop that goes through all subjects in a folder



