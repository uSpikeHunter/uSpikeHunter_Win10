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

% --- Allows user to draw line on kymograph to manually calculate PV

function handles = kymoPV(hObject, eventdata, handles)

% Clear old text from PV display
set(handles.txtPVline, 'String', '');

% If there is an old line, delete it
if handles.isLine == 1
    delete(handles.PVline);
end

% Allow user to draw line to calculate PV manually
handles.PVline = imline(handles.axesKymo);
setColor(handles.PVline, [1,1,1]);
PVpos = wait(handles.PVline);
handles.isLine = 1;

% Calculate PV from line
eSpacing = handles.eSpacing;
D = eSpacing*(PVpos(2,2) - PVpos(1,2));
kymoInterval = handles.kymoInterval;
T = kymoInterval*(PVpos(2,1) - PVpos(1,1));
PVmanual = D/T;
PVstr = num2str(PVmanual, 3);
PVstring = [PVstr, ' m/s'];

% Enable manual PV calculation objects
set(handles.txtPVline, 'Enable', 'on');
set(handles.txtPVlinestatic, 'Enable', 'on');
set(handles.txtPVline, 'String', PVstring);