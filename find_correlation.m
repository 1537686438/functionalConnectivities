workingDir = 'C:\Users\STF-Collective\Documents\CHN-STF_BIDS\derivatives\correlation';
averageDir = 'C:\Users\STF-Collective\Documents\CHN-STF_BIDS\derivatives\average_fmri';

ROI_1 = 'Left-Caudate';
ROI_2 = '3rd-Ventricle';
surveyField = 'ee_8';

survey = readtable("C:\Users\STF-Collective\Documents\CHN-STF\data\surveys\STFStudentSurveyProj_DATA_2025-01-27_1149.csv");

% find the names of all .mat file
temp_list = dir(averageDir);
temp_index = find([temp_list.isdir] ~= 1);
fileNames = {temp_list(temp_index).name};
%%
survey_results = [];
activity_results = [];

for i = 1:length(fileNames)
    sub = fileNames{i};
    sub_path = fullfile(averageDir, sub);
    sub_ID = sub(5:end-4);

    load(sub_path)
    
    if(isempty(find(strcmp({result.ROI_name}, ROI_1),1)))
        fprintf('No ROI_1 in %s\n', sub_ID);
        continue
    elseif (isempty(find(strcmp({result.ROI_name}, ROI_2),1)))
        fprintf('No ROI_2 in %s\n', sub_ID);
        continue
    end

    survey_rowIdx = find(strcmp([survey.subject_id], sub_ID));
    survey_colIdx = find(strcmp(survey.Properties.VariableNames, surveyField));
    survey_result = survey(survey_rowIdx, survey_colIdx);
    survey_result = table2array(survey_result);
    if(isnan(survey_result))
        fprintf('No survey result in %s\n', sub_ID);
        continue
    end
    survey_results(end + 1) = survey_result;

    cor = get_correlation(result, ROI_1, ROI_2);
    activity_results(end+1) = cor;
    
end
survey_results = survey_results(:);
activity_results = activity_results(:);
combined = cat(2,survey_results, activity_results);
%%
plot(combined(:,1), combined(:,2))
correlation = corrcoef(combined(:,1), combined(:,2));
fprintf("The correlation between functional connectivity and the survey result is %s\n", correlation(1,2))