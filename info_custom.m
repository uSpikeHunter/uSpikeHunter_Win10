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

% --- Reads .csv files and gives file information

function handles = info_custom(hObject, eventdata, handles)

% Set MEA image
MEAimsize = get(handles.axesMEA60, 'Position');
axes(handles.axesMEA60);
if MEAimsize(3) > 8
    MEAimage = imread('MEAcustom.png');
else
    MEAimage = imread('MEAcustom.png');
end
image(MEAimage);
axis off
axis image

% Get filename and read file
file = handles.file;
data = csvread(file);

% Determine number of electrodes and create voltage array
[~, c] = size(data);
numElectrodes = c - 1;
volt = data(:, 2:c);

% Determine sampling rate and duration of recording
% --> Defining the time array based on the first and last times and the
% length of the time array avoids possible truncation errors.
deltaT = 1e-3*(data(2,1) - data(1,1));
tStart = 1e-3*data(1,1);
tEnd = deltaT*(length(data(:,1)) - 1);
time = tStart:deltaT:tEnd;              % Time array (s)
time = time.';
rate = 1e-3/deltaT;                     % kHz
durSec = tEnd - tStart;
rateStr = [char(string(rate)), ' kHz'];
durStr = sec2hms(durSec);
set(handles.txtRate, 'String', rateStr);
set(handles.txtDur, 'String', durStr);

% MEA layout and date information
set(handles.txtMEA, 'String', 'Custom');
set(handles.txtDate, 'String', 'Undefined');

% Initialize interelectrode distance
intEDist = 100;
set(handles.edtIntEDist, 'String', intEDist);

% Put variables in handles
handles.durSec = durSec;
handles.volt = volt;
handles.rate = rate;
handles.numElectrodes = numElectrodes;
handles.time = time;

% Update handles structure
guidata(hObject, handles);