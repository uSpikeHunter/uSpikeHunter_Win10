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

% --- Creates baseline filename structure for saving files

function [baseFilename, headerText] = saveFilename(handles)

% Get variables from handles
filename = handles.filename;
isNeg = handles.isNeg;

% Header text
headerText = ['# File created with uSpikeHunter 1.0\n' ...
'# Kristine Heiney, Paulo Aguiar*\n'...
'# NCN - Neuroengineering and Computational Neuroscience group\n'...
'# https://www.i3s.up.pt/neuroengineering-and-computational-neuroscience\n'...
'# INEB/i3S, Porto, Portugal - May 2018\n'...
'# (*) pauloaguiar@ineb.up.pt\n'...
'#\n'...
'# A publication on uSpikeHunter is currently under review\n'...
'# If you use uSpikeHunter in your research, please acknowledge our work\n\n'];

% Get read start time, duration, selected electrodes, and event detection
% parameters from figure objects
headerText = [headerText, 'Analysis file: ', filename, '\n'];
if contains(filename, '.h5')
    readStart = char(string(handles.tStart));
    readDur = char(string(handles.readDur));
    electrodes = handles.electrodes;
    electrodes = [electrodes{1}, '-', electrodes{length(electrodes)}];
    electrodes_time = [electrodes, '_', readStart, 's_', readDur, 's_'];
    filename = filename(1:(length(filename)-3));
    headerText = [headerText, 'Start time: ', readStart, ' s,Duration: ',...
        readDur, ' s,Electrodes: ', electrodes, '\n'];
else
    electrodes_time = '';
    filename = filename(1:(length(filename)-4));
end
Nsig = [get(handles.edtNsig, 'String'), 'sig'];
if isNeg == 1
    isNegStr = '-';
else
    isNegStr = '+';
end

% Create filename and full header text
baseFilename = [filename, '_', electrodes_time, isNegStr, Nsig];
headerText = [headerText, 'Event detection threshold: ', isNegStr, Nsig, '\n\n'];