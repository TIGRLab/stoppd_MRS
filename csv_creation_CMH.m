%% Basic pseudo code for the program
%for all subjects in the results folder
%   truncate the name to remove the 'output' from the title
%   copy the name into column 1 of an excel file
%   change directories into dcmdir2
%   for each csf number (one is for the dlpfc one is for the sacc)
%       copy the csf number into the column of an excel file
%       copy other relevant things such as the name of metabolite        
%   change directories to sample_set/name of folder from above
%       for each subfolder in the MRS data
%           read x,y,z rows of the table and copy to columns 3,4,5 of excel
%           move the folder somewhere else so it doesn't get read again
%           break loop
%
%       end
%   end
%
%end
%% Initialization of variables/paths

%the path to the output results directory, this should be the same as the one at the end of the file
prompt = 'Enter the path of the output results folder from before: ';
N=100;
for t=1:N
   input_data = input(prompt,'s');
    
   if ~isempty(input_data)
      cd(input_data);  
      % previously: cd '/projects/rutwik/2017/STOP-PD/new_tests/input_data';
      break;    
   end
end

%basepath- to the stoppd dataset
Z=100;
prompt2 = 'Enter the path for the STOPPD data set: ';
for t=1:Z
  % previously: base_path = '/projects/rutwik/2017/STOP-PD/new_tests/sample_set_backup/sample_set';
   base_path = input(prompt2,'s');
    
   if ~isempty(base_path);
      break;    
   end
end

D = dir;

%counters / initializing for loop variables
num = 0;
counter =1;
k=1;
%for the while loop in the navigate_to_MRS function
g=1;

%% outer for loop that loops through the output_STOPPD... subject folders
for i = 3:length(D)
    %keep this declaration within the forloop
    f=1;

    %extract the name of the folder
    name= D(i).name;
    
    %create paths to known locations
    current = fullfile(pwd,name);
    cd(current)
    
    dcm2_path = fullfile(pwd,'dcmdir2');
    
 %% dropping the first word 'output' from the title of the file
    name_split= strsplit(name,'_');
    truncated = [name_split(2), name_split(3), name_split(4),name_split(5),name_split(6)];
    joined_name = strjoin(truncated,{'_','_','_','_'});
    
    path = fullfile(base_path,joined_name);

    %have to convert back to cell format & store in matlab cell array
    final_name(i-2,:)=  cellstr(joined_name);
    
    %change directories to dcmdir2
    cd(dcm2_path);
    
 %% open text file to read the extracted csf values & voxel description
    fid = fopen('csf_fraction.txt','rt');
    fid2 = fopen('voxel_description.txt','rt');
    %arbitrary k value since it's an infinite loop anyways, breaks on blank
    while k<100
 %% Perform operations on the text files, append them to a cell array for later use     
        tline = fgetl(fid);
        if ~ischar(tline), break, end
        %display contents of the text file

        %append to a cell array
        final_csf(k,:)=  cellstr(tline);
        
        %same procedure for opening 
        tline2 = fgetl(fid2);
        if ~ischar(tline2), break, end
        %display contents of the text file
        disp(tline2);
        final_description(k,:) = cellstr(tline2);
        
        %increment line number to eventually break the loop
        k=k+1;
%% Call the navigate to mrs function which does most of the data processing work
        navigate_to_MRS(joined_name,base_path,f,g,tline,tline2);
        
        %f is just a counter used when renaming files so they don't get overwritten
        f=f+1;
       
    end %end while loop that reads text files
    %close the open text files
    fclose(fid);
    fclose(fid2);
 %this path should be the same as the one at the beginning of the file    
 cd(input_data);
   
end %end of outermost for loop

%% after all csv files have been created run the following command in terminal
% find . -name '*.csv' -exec cp {} /projects/rutwik/2017/STOP-PD/new_tests/done/all_csv \;
% cd all_csv
%for f in *.csv; do (cat "${f}"; echo'') >> finalfile.csv; done
