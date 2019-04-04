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

% --- Gives information for HDF5 files and populates data selection items

function handles = info_hdf5(hObject, eventdata, handles)

% Get variables from handles
file = handles.file;

% Enable objects
% Stream selection
set(handles.txtSelectDataset, 'Enable', 'on');
set(handles.listDatasets, 'Enable', 'on');
% Row and column items
set(handles.radRow, 'Enable', 'on');
set(handles.radColumn, 'Enable', 'on');
set(handles.radRow, 'Value', 0.0);
set(handles.radColumn, 'Value', 1.0);
set(handles.menuColumn, 'Enable', 'on');
set(handles.menuColumnStart, 'Enable', 'on');
set(handles.menuColumnEnd, 'Enable', 'on');
set(handles.txtColumnStart, 'Enable', 'on');
set(handles.txtColumnEnd, 'Enable', 'on');
% Analysis time items
set(handles.menuStartTime, 'Enable', 'on');
set(handles.menuDur, 'Enable', 'on');
set(handles.txtSelectDur, 'Enable', 'on');
set(handles.txtStartTime, 'Enable', 'on');

% Overall file info
fileInfo = h5info(file);

% Extract number of recording streams (e.g., filtered, raw) and list stream
% names in list box
numStreams = size(fileInfo.Groups.Groups.Groups.Groups);
numStreams = numStreams(1);
for n=1:numStreams
    streamNames{n} = fileInfo.Groups.Groups.Groups.Groups(n).Attributes(5).Value;
end
set(handles.listDatasets, 'String', streamNames);

% Get number of electrodes from file and insert picture of MEA layout
MEA = h5readatt(file, '/Data', 'MeaName');
MEAimsize = get(handles.axesMEA60, 'Position');
if contains(MEA, '60')
    MEAnum = 60;
    axes(handles.axesMEA60);
    if MEAimsize(3) > 8
        MEAimage = imread('60MEA.png');
    else
        MEAimage = imread('60MEA-win.png');
    end
    image(MEAimage);
elseif contains(MEA, '120')
    MEAnum = 120;
    axes(handles.axesMEA256);
    if MEAimsize(3) > 8
        MEAimage = imread('120MEA.png');
    else
        MEAimage = imread('120MEA-win.png');
    end
    image(MEAimage);
elseif contains(MEA, '256')
    MEAnum = 252;
    axes(handles.axesMEA256);
    if MEAimsize(3) > 8
        MEAimage = imread('256MEA.png');
    else
        MEAimage = imread('256MEA-win.png');
    end;
    image(MEAimage);
end
axis off
axis image

% Set interelectrode spacing
if MEAnum == 60
    intEDist = MEA(6:8);
elseif MEAnum == 120
    intEDist = MEA(7:9);
elseif MEAnum == 252
    intEDist = 100;
end
set(handles.edtIntEDist, 'String', intEDist);

% List file information in corresponding fields
% MEA layout
MEA = fileInfo.Groups.Attributes(3).Value;
set(handles.txtMEA, 'String', MEA);
% Recording date
date = fileInfo.Groups.Attributes(6).Value;
set(handles.txtDate, 'String', date);
% Duration
dur = h5readatt(file, '/Data/Recording_0', 'Duration');
durSec = double(dur)*1e-6;         % Recording duration in s
durStr = sec2hms(durSec);
set(handles.txtDur, 'String', durStr);
% Sampling rate
h5path = fileInfo.Groups.Groups.Groups.Groups(1).Name;
timestampspath = [h5path, '/ChannelDataTimeStamps'];
timestamps = h5read(file, timestampspath);
finalInd = timestamps(3);
handles.rate = double((finalInd+1)/(dur*1e-3));        % kHz
rateStr = [char(string(handles.rate)), ' kHz'];
set(handles.txtRate, 'String', rateStr);

% Set start time and duration drop-down menus
maxReadDur = 600;
finalStart = 10*floor(durSec/10);
readStarts = 0:10:finalStart;
set(handles.menuStartTime, 'String', readStarts);
if durSec <= maxReadDur
    readDurs = 10:10:finalStart;
    readDurs = [readDurs, durSec];
    handles.endIsEnd = 1;
else
    readDurs = 10:10:maxReadDur;
    handles.endIsEnd = 0;
end
set(handles.menuDur, 'String', readDurs);

% Set column and row drop-down menus to row and columns in 60-, 120-, and
% 256-electrode cases, show pictures of 60-, 120-, or 256-electrode array
if MEAnum == 60
    rows60 = 1:8;
    cols60 = char(uint8(65:72)).';          % A to H
    set(handles.menuRow, 'String', rows60);
    set(handles.menuColumn, 'String', cols60);
elseif MEAnum == 120
    rows120 = 1:12;
    cols120 = char([uint8(65:72),uint8(74:77)]).';    % A to M excl. I
    set(handles.menuRow, 'String', rows120);
    set(handles.menuColumn, 'String', cols120);
elseif MEAnum == 252
    rows256 = 1:16;
    cols256 = char([uint8(65:72),uint8(74:80),uint8(82)]).';    % A to R excl. I, Q
    set(handles.menuRow, 'String', rows256);
    set(handles.menuColumn, 'String', cols256);
end

% Put variables in handles
handles.fileInfo = fileInfo;
handles.MEAnum = MEAnum;
handles.durSec = durSec;
handles.finalInd = finalInd;

% Populate row and column start and end menus
menuRow(hObject, eventdata, handles);
menuColumn(hObject, eventdata, handles);