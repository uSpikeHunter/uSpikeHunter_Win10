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

% --- Saves voltage traces (µV) on all electrodes for the currently
% selected event in the events list

function saveEvent(handles)

% Get variables from handles
iStart = handles.iStart;
iEnd = handles.iEnd;
baseFilename = handles.baseFilename;
headerText = handles.headerText;
numElectrodes = handles.numElectrodes;
electrodes = handles.electrodes;
time = handles.time*1e3;                % ms
volt = handles.volt;
rate = handles.rate*1e3;                % Hz

% Create filename suffix
eventNum = char(string(get(handles.listEvents, 'Value')));
fileSave = [baseFilename, '_seq', eventNum, '.csv'];

% Create and write headers
subheaderText = ['Voltage traces (µV) for a single propagation sequence.\n', ...
    'Event number: ' eventNum, '\n\n'];
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

% Concatenate time array and voltage matrix and select trace data
data = [time volt];
saveData = data(iStart:iEnd, :);

% Write data to file
dlmwrite(fileSave, saveData, 'precision', '%0.4f', '-append');