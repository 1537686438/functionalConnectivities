function cor = get_correlation(st, ROI_1, ROI_2)
Index_1 = find(strcmp({st.ROI_name}, ROI_1));
Index_2 = find(strcmp({st.ROI_name}, ROI_2));

table_1 = st(Index_1).Timecourse;
table_2 = st(Index_2).Timecourse;
table_1 = table2array(table_1);
table_2 = table2array(table_2);

cor = corrcoef(table_1(:,1),table_2(:,1));
cor = (cor(1,2));

end