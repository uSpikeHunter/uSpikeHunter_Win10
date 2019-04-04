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

% --- Enables the read button if different start/end electrodes are
% selected, disables if same

function btnReadOnOff(hObject, eventdata, handles)

% Check if column or row selected
isCol = get(handles.radColumn, 'Value');

% Enable/disable read button as appropriate
if isCol == 1
    selStart = get(handles.menuColumnStart, 'Value');
    selEnd = get(handles.menuColumnEnd, 'Value');
    if selStart == selEnd
        set(handles.btnRead, 'Enable', 'off');
    else
        set(handles.btnRead, 'Enable', 'on');
    end
else
    selStart = get(handles.menuRowStart, 'Value');
    selEnd = get(handles.menuRowEnd, 'Value');
    if selStart == selEnd
        set(handles.btnRead, 'Enable', 'off');
    else
        set(handles.btnRead, 'Enable', 'on');
    end
end