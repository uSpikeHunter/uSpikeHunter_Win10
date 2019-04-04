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

% --- Populates drop-down menu for PV electrode selection

function handles = PVelectrodes(hObject, eventdata, handles)

numElectrodes = handles.numElectrodes;
electrodes = handles.electrodes;

% Populate drop-down menu
pairString = {};
for n = 1:numElectrodes-1
    for m = n+1:numElectrodes
        pairString = [pairString; ...
            {[char(electrodes{n}),', ',char(electrodes{m})]}];
    end
end
handles.pairNums = flip(combnk(1:numElectrodes, 2));
set(handles.menuPair, 'String', pairString);
set(handles.menuPair, 'Value', numElectrodes - 1);