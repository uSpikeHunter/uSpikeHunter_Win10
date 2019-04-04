% ----------------------------------------------------------------------- %
%                              µSpikeHunter                               %
%                                                                         %
% Copyright (C) 2018  Kristine Heiney & Paulo Aguiar*                     %
% NCN - Neuroengineering and Computational Neuroscience group             %
% https://www.i3s.up.pt/neuroengineering-and-computational-neuroscience   %
% INEB/i3S, Porto, Portugal                                               %
% (*) pauloaguiar@ineb.up.pt                                              %
%                                                                         %
%    This program is free software: you can redistribute it and/or        %
%    modify it under the terms of the GNU General Public License as       %
%    published by the Free Software Foundation, either version 3 of the   %
%    License, or (at your option) any later version.                      %
%                                                                         %
%    This program is distributed in the hope that it will be useful,      %
%    but WITHOUT ANY WARRANTY; without even the implied warranty of       %
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        %
%    GNU General Public License for more details.                         %
%                                                                         %
%    You should have received a copy of the GNU General Public License    %
%    along with this program. If not, see <http://www.gnu.org/licenses/>. %
%                                                                         %
% ----------------------------------------------------------------------- %

% --- Makes panel with array of plots

function handles = subplotArray(hObject, eventdata, handles)

% Get variables from handles
numElectrodes = handles.numElectrodes;

% Parameters
xL = 0.04;          % Left margin
xR = 0.02;          % Right margin
xI = 0.03;          % Horizontal space between plots
yT = 0.05;          % Top margin
yB = 0.1;           % Bottom margin
yI = 0.09;          % Vertical space between plots

% Define number of rows and columns for subplots based on number of
% electrodes
if numElectrodes <= 2
    R = 1;
    C = 1;
elseif numElectrodes <= 3
    R = 1;
    C = 2;
elseif numElectrodes <= 5
    R = 2;
    C = 2;
elseif numElectrodes <= 7
    R = 2;
    C = 3;
elseif numElectrodes <= 10
    R = 3;
    C = 3;
elseif numElectrodes <= 13
    R = 3;
    C = 4;
elseif numElectrodes <= 16
    R = 4;
    C = 4;
end
numPlots = R*C;

% Width and height of each plot
W = 1/C*(1 - xR - xL - (C-1)*xI);
H = 1/R*(1 - yT - yB - (R-1)*yI);
% Define position vectors for each subplot
axPos = zeros(numPlots, 4);
subN = 0;
for row = 1:R
    for col = 1:C
        subN = subN + 1;
        X = xL + (col - 1)*W + (col - 1)*xI;
        Y = 1 - yT - row*H - (row - 1)*yI;
        axPos(subN, :) = [X Y W H];
    end
end

% Position vectors for bottom row if bottom row isn't full
lastRow = C - mod(R*C, numElectrodes - 1);
Y = yB;
if lastRow == 1
    X = 0.5 - W/2 + (xL - xR)/2;
    axPos(C*(R-1)+1, :) = [X Y W H];
elseif lastRow == 2
    X = 0.5 - W - xI/2 + (xL - xR)/2;
    axPos(C*(R-1)+1, :) = [X Y W H];
    X = 0.5 + xI/2 + (xL - xR)/2;
    axPos(C*(R-1)+2, :) = [X Y W H];
elseif lastRow == 3
    X = 0.5 - 3*W/2 - xI + (xL - xR)/2;
    axPos(C*(R-1)+1, :) = [X Y W H];
    X = 0.5 - W/2 + (xL - xR)/2;
    axPos(C*(R-1)+2, :) = [X Y W H];
    X = 0.5 + W/2 + xI + (xL - xR)/2;
    axPos(C*(R-1)+3, :) = [X Y W H];
end

% Suplots
for n = 1:numElectrodes - 1
    ax(n) = subplot('Position', axPos(n, :), 'Parent', handles.panSubplots);
end

% Put variables in handles
handles.axPos = axPos;
handles.ax = ax;
handles.R = R;
handles.axY = [yT yI yB];