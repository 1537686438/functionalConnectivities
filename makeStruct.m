%Make a sturct object containing indices, region name and activity
%timeseries
%   seg - segmentation file with the indices and name of each region
%   timeSeries - a table with the timeseries of each regions
%   return a sturct
function output = makeStruct(seg, timeSeries)

Index = {};ROI_name = {};Timecourse = {};

for i = 1:size(timeSeries, 2)
    cur_idx = str2num(timeSeries.Properties.VariableNames{i});
    cur_activity = table2array(timeSeries(:,i));
    cur_ROI = table2array(seg(find(table2array(seg(:,["index"])) == cur_idx), ["name"]));
    
    Index{end + 1} = cur_idx;
    ROI_name{end+1} = cur_ROI;
    Timecourse{end + 1} = cur_activity;
end

output = struct("Index", Index, "ROI_name", ROI_name, "Timecourse", Timecourse)


end