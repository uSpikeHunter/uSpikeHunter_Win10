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

% --- Populates data pane objects for .csv files

function handles = read_custom(hObject, eventdata, handles)

% Determine number of electrodes and create voltage array
volt = handles.volt;
[~, numElectrodes] = size(volt);
% Array of electrode labels
electrodes = 1:numElectrodes;
electrodes = electrodes.';
electrodes = cellstr(string(electrodes));
% Define menu string array for trace highlight options
highlights = [electrodes; {'None'}];

% Define menu string array for cross-correlation highlight options
xCorrStringInit = {};
for n = 1:numElectrodes-1
    for m = n+1:numElectrodes
        xCorrStringInit = [xCorrStringInit; ...
            {[char(electrodes{n}),', ',char(electrodes{m})]}];
    end
end
xCorrString = [xCorrStringInit; {'None'}];
xCorrPVString = [{'All'}; xCorrStringInit];

% Populate drop-down menus with selected electrodes
set(handles.menuEventElectrode, 'String', electrodes);
set(handles.menuHighlight, 'String', highlights);
set(handles.menuXCorr, 'String', xCorrString);
set(handles.menuXCorrPV, 'String', xCorrPVString);

% Set sound start 
tStart = handles.time(1);
set(handles.edtSoundStart, 'String', tStart);

% Put variables in handles
handles.tStart = tStart;
handles.electrodes = electrodes;