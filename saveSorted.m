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

% --- Saves txt files with the first column giving the index of the event,
% the second column giving the spike arrival time (ms) on the reference 
% electrode for each event detected on that electrode, columns 3 to 
% numElectrodes+2 giving the corresponding arrival times (ms) on each
% electrode, column numElectrodes+3 giving the  cluster propagation
% velocity of the spike (m/s), column numElectrodes+4 giving cluster
% confidence interval, column numElectrodes+5 giving the single-sequence
% propagation velocity of the spike (m/s), and column numElectrodes+6
% giving the single-sequence confidence interval. A separate csv file is
% saved for each sorted cluster of spikes.

function saveSorted(handles)

% Get variables from handles
baseFilename = handles.baseFilename;
headerText = handles.headerText;
clusterID = handles.clusterID;
eventCount = handles.eventCount;
eventTimes = (handles.eventTimes + handles.tReadStart)*1e3;     % ms
CPV = handles.CPV;
CPVconf = handles.CPVconf;
SPV = handles.SPV;
SPVconf = handles.SPVconf;
SPVstr = handles.SPVstr;
SPVheader = handles.SPVheader;
selElectrode = handles.sel;
numEvents = handles.numEvents;
numElectrodes = handles.numElectrodes;
electrodes = handles.electrodes;
pairNums = handles.pairNums;

% File headers
subheaderText = ['Spike sorting and propagation velocity results.\n', ...
    'Event electrode: ', electrodes{selElectrode}, '\n'];
colHeaders = cell(numElectrodes+6, 1);
colHeaders{1} = 'Event index';
colHeaders{2} = ['Time (ms): ', electrodes{selElectrode}];
for i = 1:numElectrodes
    colHeaders{i+2} = electrodes{i};
end
colHeaders{numElectrodes+3} = 'CPV (m/s)';
colHeaders{numElectrodes+4} = 'CPV conf.';
colHeaders{numElectrodes+5} = 'SPV (m/s)';
colHeaders{numElectrodes+6} = 'SPV conf.';

% Concatenate event time for selected electrode with all event times and
% propagation velocity
eventInds = 1:numEvents;
eventInds = eventInds.';
timePVarray = [eventInds, eventTimes(:, selElectrode), eventTimes, CPV, ...
    CPVconf, SPV, SPVconf];

n = 0;
% Get events in each cluster
for g = 0:4
    if eventCount(g+1) ~= 0
        n = n + 1;
        grps(n) = g;
        timePV_grouped{n} = timePVarray(clusterID == g, :);
    end
end
numClusters = n;

% Create string for CPV electrodes for filename and header text
pairInd = get(handles.menuPair, 'Value');
CPVstr = ['_CPV', electrodes{pairNums(pairInd,1)}, ...
    '-', electrodes{pairNums(pairInd,2)}];
subheaderText = [subheaderText, SPVheader, 'CPV: electrodes ', ...
    electrodes{pairNums(pairInd,1)}, ' and ', ...
    electrodes{pairNums(pairInd,2)}, '\n\n'];

% Create filenames for saving and save to file with header
for n = 1:numClusters
    suffix = ['_sel', electrodes{selElectrode}, CPVstr, SPVstr, '_clst', ...
        char(string(grps(n))), '.csv'];
    fileSave = [baseFilename, suffix];
    data = timePV_grouped{n};
    fileID = fopen(fileSave, 'w');
    fprintf(fileID, headerText);
    fclose(fileID);
    fileID = fopen(fileSave, 'a');
    fprintf(fileID, subheaderText);
    for i = 1:numElectrodes+5
        fprintf(fileID, '%s,', colHeaders{i});
    end
    fprintf(fileID, '%s\n', colHeaders{numElectrodes+6});
    dlmwrite(fileSave, data, 'precision', '%0.4f', '-append');
end