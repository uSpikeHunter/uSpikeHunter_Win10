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

% --- Enables and disables appropriate objects for btnList

function infoEnDis(hObject, eventdata, handles)

% Enable objects
% Interelectrode spacing
set(handles.txtIntEDist, 'Enable', 'on');
set(handles.edtIntEDist, 'Enable', 'on');
% Event detector items
set(handles.edtNsig, 'Enable', 'on');
set(handles.txtSig, 'Enable', 'on');
set(handles.txtEventPhase, 'Enable', 'on');
set(handles.radNegPhase, 'Enable', 'on');
set(handles.radPosPhase, 'Enable', 'on');

file = get(handles.edtFile, 'String');
if contains(file, '.h5')
    btnReadOnOff(hObject, eventdata, handles);
else
    set(handles.btnRead, 'Enable', 'on');
end

% Disable file info button
set(handles.btnList, 'Enable', 'off');