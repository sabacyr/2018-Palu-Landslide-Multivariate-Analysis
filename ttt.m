data = readtable('Swath8_Disp.txt');
filename = 'Swath8_Disp.xlsx';
writetable(data, filename);

generate_swath_figure('Swath1_Disp.xlsx', 'Swath1_Elv.xlsx')