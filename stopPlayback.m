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

% --- Stops playback if audio is playing

function handles = stopPlayback(hObject, eventdata, handles)

if handles.isPlayer == 1
    stop(handles.player);
    clear handles.player;
    stop(handles.timedisp);
    set(handles.txtTimer, 'String', 'Audio start (s)');
    set(handles.edtSoundStart, 'String', handles.audioStartTime);
    handles.isPlayer = 0;
end
set(handles.btnPause, 'Enable', 'off');
set(handles.btnResume, 'Enable', 'off');
set(handles.btnStop, 'Enable', 'off');
set(handles.edtSoundStart, 'Enable', 'on');
set(handles.edtSoundStart, 'FontWeight', 'normal');
set(handles.menuChord, 'Enable', 'on');
set(handles.btnStartSound, 'Enable', 'on');