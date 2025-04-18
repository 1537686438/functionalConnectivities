%Calculate the time series of each regions of one participant
%   anat_img - the anatomical data with segementation indices
%   func_img - the functional activity data
%   func_time - how many time point are there in the functional data
%   Return a table of the activity of each indices

function output = getTimeSeries(anat_img, func_img, func_time)

%Get a list of the region indices and remove region 0
anat_unrolled = anat_img(:);
regions = unique(anat_unrolled);
regions = regions(2:end);
output = double(reshape(regions, [1, size(regions,1)]));

%Construct a dictionary of the region indices and their corrsponding
%indices in the anat_img matrix
idx_list = {};
for idx = 1:length(regions)
    cur_idx = find(anat_unrolled == regions(idx));
    idx_list{end+1} = cur_idx;
end
idx_dict = dictionary(reshape(regions,[1,length(regions)]), idx_list);

%Find the average percent change of each voxel over time
func_ave = mean(func_img, 4);
func_output = zeros(size(func_img));
for i = 1:size(func_img,4)
    func_output(:,:,:,i) = func_img(:,:,:,i) ./ func_ave .* 100;
end

%Go through each time point and find the average of each regions
for time = 1:func_time
    cur_func = func_output(:,:,:,time);
    mean_list = [];
    for i = 1:length(regions)
        cur_idx = lookup(idx_dict, regions(i));
        cur_idx = cur_idx{1};
        cur_mean = mean(cur_func(cur_idx), 'omitnan');
        mean_list = [mean_list, cur_mean];
    end

    output = cat(1, output, mean_list);
end

output = array2table(output([2:end], :), 'VariableNames',cellstr(int2str(regions)));

end
