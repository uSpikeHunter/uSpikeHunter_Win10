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

% Put necessary inputs from main GUI handles structure into multi-spike
% analysis GUI handles structure

function handles = main2sorting(hObject, eventdata, handles)

% Get handles structure from root
mainHandles = getappdata(0, 'mainHandles');

% Voltage array (µv)
handles.volt = mainHandles.volt;
% Events cell array
handles.events = mainHandles.events;
% Sampling rate
handles.rate = mainHandles.rate;   % kHz
% Interelectrode distance (µm)
handles.intEDist = mainHandles.intEDist;
% Character array of electrode names
handles.electrodes = mainHandles.electrodes;
% Index of selected electrode for event detection
handles.sel = mainHandles.selElectrode;
% Detecting positive or negative phase on event detection
handles.isNeg = mainHandles.isNeg;
% Number of selected electrodes
handles.numElectrodes = mainHandles.numElectrodes;
% Event names array for event list
handles.names = mainHandles.names;
% Number of events
handles.numEvents = mainHandles.numEvents;
% Read start time
handles.tReadStart = mainHandles.tReadStart;
% Base filename and header text for saving files
handles.baseFilename = mainHandles.baseFilename;
handles.headerText = mainHandles.headerText;
% Single-unit PV, confidence interval, and string for filename
pairInd = get(mainHandles.menuXCorrPV, 'Value') - 1;
pairNums = flip(combnk(1:handles.numElectrodes, 2));
if pairInd > 0
    handles.SPV = mainHandles.SPV{handles.sel}(:, pairInd);
    handles.SPVconf = mainHandles.xCorrPeak{handles.sel}(:, pairInd);
    handles.SPVstr = ['_SPV',mainHandles.electrodes{pairNums(pairInd,1)},...
        '-',mainHandles.electrodes{pairNums(pairInd,2)}];
    handles.SPVheader = ['SPV: electrodes ', ...
        mainHandles.electrodes{pairNums(pairInd,1)}, ' and ', ...
        mainHandles.electrodes{pairNums(pairInd,2)}, ', '];
else
    handles.SPV = mainHandles.avSPV{handles.sel};
    handles.SPVconf = mainHandles.SPVconf{handles.sel};
    handles.SPVstr = '_SPVall';
    handles.SPVheader = 'SPV: all electrodes, ';
end