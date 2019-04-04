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

% --- Reads data from HDF5 file and populates data pane objects

function handles = read_hdf5(hObject, eventdata, handles)

% Get filename
file = handles.file;
finalInd = handles.finalInd;
rate = handles.rate*1e3;

% Get index of selected dataset
dataInd = get(handles.listDatasets, 'Value');
% Path to selected dataset
h5path = handles.fileInfo.Groups.Groups.Groups.Groups(dataInd).Name;
infopath = [h5path, '/InfoChannel'];
h5path = [h5path, '/ChannelData'];

% Get selected electrodes
row_col = get(handles.radColumn, 'Value');
if row_col == 1
    contents = cellstr(get(handles.menuColumnStart,'String'));
    eStart = get(handles.menuColumnStart,'Value');
    eEnd = get(handles.menuColumnEnd,'Value');
    if eStart <= eEnd
        selElectrodes = contents(eStart:eEnd);
        handles.rev = 0;
    else
        selElectrodes = flip(contents(eEnd:eStart));
        handles.rev = 1;
    end
else
    contents = cellstr(get(handles.menuRowStart,'String'));
    eStart = get(handles.menuRowStart,'Value');
    eEnd = get(handles.menuRowEnd,'Value');
    if eStart <= eEnd
        selElectrodes = contents(eStart:eEnd);
        handles.rev = 0;
    else
        selElectrodes = flip(contents(eEnd:eStart));
        handles.rev = 1;
    end
end

% Define menu string array for trace highlight options
highlights = [selElectrodes; {'None'}];
% Define menu string array for cross-correlation highlight options
xCorrStringInit = {};
numElectrodes = length(selElectrodes);
for n = 1:numElectrodes-1
    for m = n+1:numElectrodes
        xCorrStringInit = [xCorrStringInit; ...
            {[char(selElectrodes{n}),', ',char(selElectrodes{m})]}];
    end
end
xCorrString = [xCorrStringInit; {'None'}];
xCorrPVString = [{'All'}; xCorrStringInit];

% Populate drop-down menus with selected electrodes
set(handles.menuEventElectrode, 'String', selElectrodes);
set(handles.menuHighlight, 'String', highlights);
set(handles.menuXCorr, 'String', xCorrString);
set(handles.menuXCorrPV, 'String', xCorrPVString);

% Get array giving electrode labels and indices corresponding to selected
% electrodes
infoChannel = h5read(file, infopath);
labels = infoChannel.Label;
index = zeros(numElectrodes,1);
for n = 1:numElectrodes
    compare = strcmp(selElectrodes(n), labels);
    index(n) = find(compare == 1);
end

% Define reading parameters and time array
% Start time
contents = cellstr(get(handles.menuStartTime,'String'));
tStart = str2double(contents{get(handles.menuStartTime, 'Value')});
deltaT = 1/rate;
iStart = tStart/deltaT + 1;
% Duration
contents = cellstr(get(handles.menuDur, 'String'));
durMenuLength = length(contents);
durMenuSel = get(handles.menuDur, 'Value');
% Ensure end time does not exceed dataset size due to rounding errors
readDur = str2double(contents{get(handles.menuDur, 'Value')});
if durMenuSel == durMenuLength && handles.endIsEnd == 1
    readDur = (double(finalInd) - 1)/rate - tStart;
end
readSamples = round(readDur/deltaT) + 1;
tEnd = tStart + (readSamples-1)*deltaT;
if tEnd*rate > finalInd
    tEnd = double(finalInd/rate);
    readSamples = (tEnd - tStart)*rate;
end
% Time array
time = tStart:deltaT:tEnd;
time = time.';

% Set sound start time
set(handles.edtSoundStart, 'String', tStart);

% Initialize voltage matrix
volt = zeros(readSamples, numElectrodes);
% Get conversion factor from InfoChannel
factor = double(infoChannel.ConversionFactor(1));
% Read data for selected electrodes to voltage matrix
for n = 1:numElectrodes
    ind = index(n);
    data = h5read(file, h5path, [iStart ind], [readSamples 1]);
    volt(:,n) = double(data)*factor*1e-6;
end

% Put variables in handles
handles.volt = volt;
handles.time = time;
handles.tStart = tStart;
handles.readDur = readDur;
handles.numElectrodes = numElectrodes;
handles.electrodes = selElectrodes;