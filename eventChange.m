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

% --- Main function for change of selected event

function handles = eventChange(hObject, eventdata, handles)

% If there is an old line on the kymograph, delete it
if handles.isLine == 1
    delete(handles.PVline);
    handles.isLine = 0;
    set(handles.txtPVlinestatic, 'Enable', 'off');
    set(handles.txtPVline, 'Enable', 'off');
    set(handles.txtPVline, 'String', '');
end

% Get indices of selected electrode, event, and highlighted plots
selEvent = get(handles.listEvents, 'Value');
handles.selEvent = selEvent;
selElectrode = get(handles.menuEventElectrode, 'Value');
handles.selElectrode = selElectrode;
handles.highlight = get(handles.menuHighlight, 'Value');
handles.xCorrhigh = get(handles.menuXCorr, 'Value');
% Time of selected event
handles.eventTime = handles.events{selElectrode}(selEvent, 2);

% ----------- CROSS-CORRELATION
handles = spikeXCorrPlot(hObject, eventdata, handles);
handles = SPVcalculation(hObject, eventdata, handles);

% ----------- VOLTAGE TRACES
handles = voltTrace(hObject, eventdata, handles);

% ----------- KYMOGRAPH
handles = kymograph(hObject, eventdata, handles);