
opts = detectImportOptions('All data merged ready for training.csv');
preview('All data merged ready for training.csv',opts)

opts.SelectedVariableNames = [1:5]; 
M = readmatrix('All data merged ready for training.csv', opts) 
opts2 = detectImportOptions('All data merged ready for training.csv');

opts2.SelectedVariableNames = [14:15]; 
M2 = readmatrix('All data merged ready for training.csv',opts2)
C = [M M2]
R = corrcoef(C)

h = heatmap(R,'MissingDataColor','w');
labels = ["Re","S","Ri","xc","yc","delp/delpo","delNu/delNuo"];
h.XDisplayLabels = labels;
h.YDisplayLabels = labels;

