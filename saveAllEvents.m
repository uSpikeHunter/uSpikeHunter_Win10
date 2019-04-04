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

% --- Saves times and amplitudes of all detected propagation sequences
% (events on all electrodes)

function saveAllEvents(handles)

% Get variables from handles
events = handles.events;
numElectrodes = handles.numElectrodes;
electrodes = handles.electrodes;
baseFilename = handles.baseFilename;
headerText = handles.headerText;

% Create filename for saving
fileSave = [baseFilename, '_events.csv'];

% Create and write headers
subheaderText = 'Times (ms) and peak voltages (µV) for all propagation sequences.\n\n';
fileID = fopen(fileSave, 'w');
fprintf(fileID, headerText);
fclose(fileID);
fileID = fopen(fileSave, 'a');
fprintf(fileID, subheaderText);
for n = 1:numElectrodes-1
    colHeader1 = ['Time (', electrodes{n}, ')'];
    colHeader2 = ['Voltage (', electrodes{n}, ')'];
    fprintf(fileID, '%s,%s,', colHeader1, colHeader2);
end
colHeader1 = ['Time (', electrodes{numElectrodes}, ')'];
colHeader2 = ['Voltage (', electrodes{numElectrodes}, ')'];
fprintf(fileID, '%s,%s\n', colHeader1, colHeader2);
fclose(fileID);

% Create and save array of times and amplitudes: in each pair of columns,
% the first column is the time (ms), and the second is the peak voltage
% (µV)
for n = 1:numElectrodes
    col1 = 2*n-1;
    col2 = 2*n;
    data(:, col1:col2) = [1e3*events{n}(:, 2), events{n}(:, 1)];
end
dlmwrite(fileSave, data, 'precision', '%0.4f', '-append');