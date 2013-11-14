p = xlsread('InputFile', 1, 'B4');
w = xlsread('InputFile', 1, 'B6');
thicknessStart = xlsread('InputFile', 1, 'C2');
thicknessEnd = xlsread('InputFile', 1, 'D2');

elementVec = zeros(length(xfinal));

