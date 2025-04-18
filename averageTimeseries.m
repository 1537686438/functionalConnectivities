clear all; clc; 

func_name = '%s_ses-01_task-restxinscapes_acq-mepi_run-01_space-T1w_desc-preproc_bold.nii.gz';
anat_name = '%s_ses-01_task-restxinscapes_acq-mepi_run-01_space-T1w_desc-aparcaseg_dseg.nii.gz';

subjectDir = 'E:\CHN-STF_BIDS\derivatives\fmriprep';
funcPath = '\ses-01\func';


workingDir = 'E:\CHN-STF_BIDS\derivatives\data_manage';
addpath(workingDir)
outputDir =  'E:\CHN-STF_BIDS\derivatives\average_fmri';
outputName = '%s.mat';

seg = readtable(fullfile(subjectDir, 'desc-aseg_dseg.tsv'), "FileType","delimitedtext", "Delimiter", "	");

%% Create a list of subject that has not been processed
fileList = dir(subjectDir);
subList = struct2table(fileList).name;
subList = subList(find(startsWith(subList, "sub") & struct2table(fileList).isdir));

toSkip = struct2table(dir(outputDir)).name;
toSkip = toSkip(find(startsWith(toSkip, "sub")));
toSkip = cellfun(@(x) x(1:end-4), toSkip, 'UniformOutput',false);

subList = setdiff(subList, toSkip);
%% Go through each subjects and save the sturct object
for i = 1:length(subList)
    curSub = subList{i};
    fprintf('Working on %s\n', curSub);
    
    subFolder = fullfile(subjectDir, curSub, funcPath);

    anat_file = load_nii(fullfile(subFolder, sprintf(anat_name, curSub)));
    func_file = load_nii(fullfile(subFolder, sprintf(func_name, curSub)));

    anat_img = anat_file.img;
    func_img = func_file.img;

    timeseries = getTimeSeries(anat_img, func_img, size(func_img,4));
    result = makeStruct(seg, timeseries);

    save(fullfile(outputDir, sprintf(outputName, curSub)), "result");

end















