data = readtable('R3_Merge.txt');
filename = 'R3.xlsx';
writetable(data, filename, 'Sheet', 1);
