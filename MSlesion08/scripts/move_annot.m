%% A script for moving annotations to the directory of the skull stripped data
% Directory to keep the processed images
base_dir = '/usr/data/medical_images/MSlesion08/';
ss_base_dir = [base_dir, 'skull_stripped_'];
dUNC = dir([base_dir,'UNC_train*']); % For the UNC data
dCHB = dir([base_dir,'CHB_train*']); % For the CHB data
d=[dUNC; dCHB];
list_dir = {d.name}; % a list of the directories

%%
tic
for dir_index=1:length(list_dir)
    dir_name = [list_dir{dir_index}, '/'];
    source_dir=[base_dir, dir_name];
    target_dir = [ss_base_dir, dir_name];
    inputf = dir([source_dir '*lesion*']); % get the names of all the input files
    list_inputf = {inputf.name};
    % loop through all annotations in this directory;
    for f_ind=1:length(list_inputf)
        src_file = [source_dir, list_inputf{f_ind}]; % get the filename with full path
        [~,name,ext] = fileparts(src_file); % get the filename w/o extention
        target_file = [target_dir, name, ext]; % get the name of the target file
        movefile(src_file,target_file);
    end
end
toc