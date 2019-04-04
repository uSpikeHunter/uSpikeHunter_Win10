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

% --- Enables and disables appropriate objects for btnRead

function readEnDis(hObject, eventdata, handles)

% Data analysis objects
set(handles.btnClearData, 'Enable', 'on');
set(handles.txtSelectElectrode, 'Enable', 'on');
set(handles.menuEventElectrode, 'Enable', 'on');
set(handles.btnSaveAll, 'Enable', 'on');
set(handles.btnSaveEvent, 'Enable', 'on');
set(handles.btnSaveData, 'Enable', 'on');
set(handles.listEvents, 'Enable', 'on');
set(handles.btnRead, 'Enable', 'on');

% Sound objects
set(handles.edtSoundStart, 'Enable', 'on');
set(handles.menuChord, 'Enable', 'on');
set(handles.txtTimer, 'Enable', 'on');
set(handles.btnStartSound, 'Enable', 'on');