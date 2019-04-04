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

% --- Partially or completely clears the GUI

function handles = clearGUI(hObject, eventdata, handles, degree)
% degree = 1 for complete clearing, 2 for clearing selected electrodes 
% (must be used in conjunction with menuRow, menuColumn, and rowcolumn 
% functions at this level), 3 for clearing data pane, 4 for clearing plots

mainHandles = getappdata(0, 'mainHandles');

% Close spike sorting GUI
if mainHandles.sortingGUIopen == 1
    % Get sorting handles structure from root and close figure
    sortingHandles = getappdata(0, 'sortingHandles');
    close(sortingHandles.figure1);
    % Set sorting GUI open to zero
    handles.sortingGUIopen = 0;
    setappdata(0, 'mainHandles', handles);
end

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

% Disable and clear kymograph PV calculation
set(handles.btnLine, 'Enable', 'off');
set(handles.txtPVlinestatic, 'Enable', 'off');
set(handles.txtPVline, 'String', '');

% Stop sound playback
stopPlayback(hObject, eventdata, handles);
set(handles.btnStartSound, 'Enable', 'off');
set(handles.edtSoundStart, 'Enable', 'off');
set(handles.edtSoundStart, 'String', '');
set(handles.txtTimer, 'Enable', 'off');
set(handles.edtSoundStart, 'Enable', 'off');
set(handles.menuChord, 'Enable', 'off');

% Clear analysis pane
if degree <= 3
    % Clear objects
    % Events and electrode lists
    set(handles.listEvents, 'String', ' ');
    set(handles.listEvents, 'Value', 1);
    set(handles.menuEventElectrode, 'Value', 1);
    set(handles.menuEventElectrode, 'String', ' ');
    set(handles.menuHighlight, 'Value', 1);
    set(handles.menuHighlight, 'String', ' ');
    set(handles.txtNumEvents, 'String', '');
    set(handles.txtThresh, 'String', '');
    set(handles.menuXCorr, 'Value', 1);
    set(handles.menuXCorr, 'String', ' ');
    set(handles.menuXCorrPV, 'Value', 1);
    set(handles.menuXCorrPV, 'String', ' ');
    set(handles.txtPV, 'String', '');
    set(handles.txtPVline, 'String', '');
    set(handles.txtConfidence, 'String', '');
    
    % Disable objects
    set(handles.btnClearData, 'Enable', 'off');
    % Event and trace options
    set(handles.txtSelectElectrode, 'Enable', 'off');
    set(handles.txtSelectTrace, 'Enable', 'off');
    set(handles.menuEventElectrode, 'Enable', 'off');
    set(handles.menuHighlight, 'Enable', 'off');
    set(handles.btnSaveAll, 'Enable', 'off');
    set(handles.btnSaveEvent, 'Enable', 'off');
    set(handles.btnSaveData, 'Enable', 'off');
    set(handles.txtSelectXCorr, 'Enable', 'off');
    set(handles.menuXCorr, 'Enable', 'off');
    set(handles.menuXCorrPV, 'Enable', 'off');
    set(handles.txtSelectXCorrPV, 'Enable', 'off');
    set(handles.txtPV, 'Enable', 'off');
    set(handles.txtPVstatic, 'Enable', 'off');
    set(handles.txtConfidence, 'Enable', 'off');
    set(handles.txtConfidenceStatic, 'Enable', 'off');
    set(handles.txtPVline, 'Enable', 'off');
    set(handles.txtPVlinestatic, 'Enable', 'off');
    set(handles.btnLine, 'Enable', 'off');
    set(handles.btnSpikeOverlay, 'Enable', 'off');
    set(handles.listEvents, 'Enable', 'off');
end

% Clear selected electrodes
if degree <= 2
    % Clear objects
    % Row and column menus
    set(handles.radColumn, 'Value', 1.0);
    set(handles.menuRow, 'Value', 1);
    set(handles.menuColumn, 'Value', 1);
    set(handles.menuRowStart, 'Value', 1);
    set(handles.menuRowEnd, 'Value', 1);
    set(handles.menuColumnStart, 'Value', 1);
    set(handles.menuColumnEnd, 'Value', 1);
    % Sigma and event count
    set(handles.txtNumEvents, 'String', '');
    set(handles.edtNsig, 'String', '5');
    % Analysis time
    set(handles.menuStartTime, 'Value', 1);
    set(handles.menuDur, 'Value', 1);
    
    % Disable objects
    % Event and trace options
    set(handles.btnClearData, 'Enable', 'off');
end

% Clear everything
if degree == 1
    % Close spike sorting GUI
    % If spike sorting GUI is open, close it
    mainHandles = getappdata(0, 'mainHandles');
    sortingHandles = getappdata(0, 'sortingHandles');
    if mainHandles.sortingGUIopen == 1
        close(sortingHandles.figure1);
    end
    % Clear objects
    % Stream list
    set(handles.listDatasets, 'Value', 1);
    set(handles.listDatasets, 'Enable', 'off');
    set(handles.listDatasets, 'String', ' ');
    % Reset image and interelctrode spacing
    axes(handles.axesMEA60);
    cla reset;
    MEAimsize = get(handles.axesMEA60, 'Position');
    if MEAimsize(3) > 8
        MEAimage = imread('MEAselect.png');
    else
        MEAimage = imread('MEAselect-win.png');
    end
    image(MEAimage);
    axis off
    axis image
    axes(handles.axesMEA256);
    cla reset;
    set(handles.axesMEA256, 'Visible', 'off');
    set(handles.edtIntEDist, 'String', '');
    % Row and column menus
    set(handles.menuRow, 'String', ' ');
    set(handles.menuColumn, 'String', ' ');
    set(handles.menuRowStart, 'String', ' ');
    set(handles.menuRowEnd, 'String', ' ');
    set(handles.menuColumnStart, 'String', ' ');
    set(handles.menuColumnEnd, 'String', ' ');
    % File info
    set(handles.txtMEA, 'String', '');
    set(handles.txtDate, 'String', '');
    set(handles.txtRate, 'String', '');
    set(handles.txtDur, 'String', '');
    % Analysis time
    set(handles.menuStartTime, 'Value', 1);
    set(handles.menuStartTime, 'String', ' ');
    set(handles.menuDur, 'Value', 1);
    set(handles.menuDur, 'String', ' ');
    % Event detector
    set(handles.edtNsig, 'String', '5');
    set(handles.radNegPhase, 'Value', 1.0);
    
    % Disable objects
    % Stream select
    set(handles.txtSelectDataset, 'Enable', 'off');
    % Row and column options
    set(handles.radColumn, 'Enable', 'off');
    set(handles.radRow, 'Enable', 'off');
    set(handles.menuRow, 'Enable', 'off');
    set(handles.menuColumn, 'Enable', 'off');
    set(handles.menuRowStart, 'Enable', 'off');
    set(handles.menuRowEnd, 'Enable', 'off');
    set(handles.menuColumnStart, 'Enable', 'off');
    set(handles.menuColumnEnd, 'Enable', 'off');
    set(handles.txtRowStart, 'Enable', 'off');
    set(handles.txtRowEnd, 'Enable', 'off');
    set(handles.txtColumnStart, 'Enable', 'off');
    set(handles.txtColumnEnd, 'Enable', 'off');
    % Interelectrode spacing
    set(handles.txtIntEDist, 'Enable', 'off');
    set(handles.edtIntEDist, 'Enable', 'off');
    % Analysis time
    set(handles.menuStartTime, 'Enable', 'off');
    set(handles.menuDur, 'Enable', 'off');
    set(handles.txtSelectDur, 'Enable', 'off');
    set(handles.txtStartTime, 'Enable', 'off');
    % Event and trace options
    set(handles.edtNsig, 'Enable', 'off');
    set(handles.txtSig, 'Enable', 'off');
    set(handles.txtEventPhase, 'Enable', 'off');
    set(handles.radNegPhase, 'Enable', 'off');
    set(handles.radPosPhase, 'Enable', 'off');
    set(handles.btnClearData, 'Enable', 'off');
    set(handles.txtSelectElectrode, 'Enable', 'off');
    set(handles.txtSelectTrace, 'Enable', 'off');
    set(handles.menuEventElectrode, 'Enable', 'off');
    set(handles.menuHighlight, 'Enable', 'off');
end