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

% --- Properly enables and disables objects depending on whether row or
% column is selected

function rowcolumn(hObject, eventdata, handles)

% Clear data analysis pane
clearGUI(hObject, eventdata, handles, 3);

% Get selected button
sel = get(handles.radColumn, 'Value');

% Enable corresponding menus and text for selected button
if sel == 1
    set(handles.menuColumn, 'Enable', 'on');
    set(handles.menuColumnStart, 'Enable', 'on');
    set(handles.menuColumnEnd, 'Enable', 'on');
    set(handles.txtColumnStart, 'Enable', 'on');
    set(handles.txtColumnEnd, 'Enable', 'on');
    set(handles.menuRow, 'Enable', 'off');
    set(handles.menuRowStart, 'Enable', 'off');
    set(handles.menuRowEnd, 'Enable', 'off');
    set(handles.txtRowStart, 'Enable', 'off');
    set(handles.txtRowEnd, 'Enable', 'off');
else
    set(handles.menuRow, 'Enable', 'on');
    set(handles.menuRowStart, 'Enable', 'on');
    set(handles.menuRowEnd, 'Enable', 'on');
    set(handles.txtRowStart, 'Enable', 'on');
    set(handles.txtRowEnd, 'Enable', 'on');
    set(handles.menuColumn, 'Enable', 'off');
    set(handles.menuColumnStart, 'Enable', 'off');
    set(handles.menuColumnEnd, 'Enable', 'off');
    set(handles.txtColumnStart, 'Enable', 'off');
    set(handles.txtColumnEnd, 'Enable', 'off');
end