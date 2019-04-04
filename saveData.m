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

% --- Saves time array (ms) and voltage traces (µV) for selected electrodes
% over selected time window

function saveData(handles)

% Base filename and header text
baseFilename = handles.baseFilename;
headerText = handles.headerText;
electrodes = handles.electrodes;
numElectrodes = handles.numElectrodes;

% Create filename for saving
fileSave = [baseFilename, '_data.csv'];

% Create headers for file
subheaderText = 'Voltage traces (µV) for all electrodes over the entire analysis duration.\n\n';
fileID = fopen(fileSave, 'w');
fprintf(fileID, headerText);
fclose(fileID);
fileID = fopen(fileSave, 'a');
fprintf(fileID, subheaderText);
str1 = ['Time (ms),', electrodes{1} ','];
fprintf(fileID, str1);
for n = 2:numElectrodes-1
    colHeader = electrodes{n};
    fprintf(fileID, '%s,', colHeader);
end
fprintf(fileID, '%s\n', electrodes{numElectrodes});
fclose(fileID);

% Concatenate time array and voltage matrix and write to file
time = handles.time*1e3;        % convert to ms
data = [time, handles.volt];
dlmwrite(fileSave, data, 'precision', '%0.4f', '-append');