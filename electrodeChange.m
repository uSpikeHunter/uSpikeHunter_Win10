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

% --- Presents information based on selected electrode (event electrode)

function handles = electrodeChange(hObject, eventdata, handles)

% Get variables from handles
numEvents = handles.numEvents;
names = handles.names;
thresh = handles.thresh;

% Set number of propagation sequences, highlight event electrode trace,
% clear event list
selElectrode = get(handles.menuEventElectrode, 'Value');
set(handles.listEvents, 'Value', 1);
set(handles.listEvents, 'String', {' '});
set(handles.menuHighlight, 'Value', selElectrode);
numEventsStr = [num2str(numEvents), ' events'];
set(handles.txtNumEvents, 'String', numEventsStr);

% If event count not zero, run events list selection change callback to
% plot data, enable/disable objects, set list of events to events for
% selected electrode
if numEvents ~= 0
    % Enable plotting objects
    set(handles.menuHighlight, 'Enable', 'on');
    set(handles.menuXCorr, 'Enable', 'on');
    set(handles.menuXCorrPV, 'Enable', 'on');
    set(handles.txtSelectTrace, 'Enable', 'on');
    set(handles.txtSelectXCorr, 'Enable', 'on');
    set(handles.txtSelectXCorrPV, 'Enable', 'on');
    % Enable PV estimation objects
    set(handles.txtPV, 'Enable', 'on');
    set(handles.txtPVstatic, 'Enable', 'on');
    set(handles.txtConfidence, 'Enable', 'on');
    set(handles.txtConfidenceStatic, 'Enable', 'on');
    % Populate event list
    set(handles.listEvents, 'Enable', 'on');
    set(handles.listEvents, 'String', names{selElectrode});
    % Enable/disable/reset kymograph PV objects as needed
    set(handles.btnLine, 'Enable', 'on');
    set(handles.btnSpikeOverlay, 'Enable', 'on');
    set(handles.btnLine, 'Enable', 'on');
    set(handles.txtPVlinestatic, 'Enable', 'off');
    set(handles.txtPVline, 'String', '');
    % Set threshold text
    threshStr = ['Vt = ', sprintf('%0.2f', round(thresh(selElectrode), 2)), ' µV'];
    set(handles.txtThresh, 'String', threshStr);
    % Run event change function
    handles = eventChange(hObject, eventdata, handles);
else
    % Disable plotting and data analysis objects
    set(handles.menuHighlight, 'Enable', 'off');
    set(handles.menuXCorr, 'Enable', 'off');
    set(handles.menuXCorrPV, 'Enable', 'off');
    set(handles.txtSelectTrace, 'Enable', 'off');
    set(handles.txtSelectXCorr, 'Enable', 'off');
    set(handles.txtSelectXCorrPV, 'Enable', 'off');
    set(handles.btnSpikeOverlay, 'Enable', 'off');
    set(handles.listEvents, 'Enable', 'off');
    set(handles.btnLine, 'Enable', 'off');
    % Disable PV estimation objects
    set(handles.txtPV, 'Enable', 'off');
    set(handles.txtPVstatic, 'Enable', 'off');
    set(handles.txtConfidence, 'Enable', 'off');
    set(handles.txtConfidenceStatic, 'Enable', 'off');
    set(handles.txtConfidence, 'String', '');
    set(handles.txtPV, 'String', '');
    % Set threshold text
    set(handles.txtThresh, 'String', '');
    % Clear axes
    fontsize = get(handles.axesTraces, 'FontSize');
    axes(handles.axesTraces);
    cla reset;
    set(handles.axesTraces, 'FontSize', fontsize);
    axes(handles.axesXCorr);
    cla reset;
    set(handles.axesXCorr, 'FontSize', fontsize);
    axes(handles.axesKymo);
    cla reset;
    set(handles.axesKymo, 'FontSize', fontsize);
end

% Update handles structure
handles.names = names;
fig1 = gcf();
guidata(fig1, handles);