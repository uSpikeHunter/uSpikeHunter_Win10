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

% Defines appropriate plotting window and plots voltage traces

function handles = voltTrace(hObject, eventdata, handles)
% Get variables from handles
eventTime = handles.eventTime;
selElectrode = handles.selElectrode;
selEvent = handles.selEvent;
tReadStart = handles.tReadStart;
highlight = handles.highlight;
rate = handles.rate*1e3;
eSpacing = handles.eSpacing;
numElectrodes = handles.numElectrodes;
readDur = handles.readDur;
volt = handles.volt;
time = handles.time;
SPV = handles.SPV{selElectrode}(selEvent, numElectrodes-1);

% Get font size
fontsize = get(handles.axesTraces, 'FontSize');

% Plotting window: Under the assumption that a spike propagates at a
% minimum speed of approximately 0.2 m/s, the time to travel from the first
% electrode to the last electrode in a time equal to (n-1)d(0.2 m/s), where
% n is the number of electrodes and d is the interelectrode distance. The
% plotting window then was defined to span from t1 - 2.5 ms to tf + 2.5 ms,
% where t1 and tf are the times at which the spike arrives at the first and
% last electrodes, respectively.
minPV = 0.2;                % m/s
eTime = eSpacing/minPV;     % s
tBefore = 2.5e-3;           % s
tAfter = 2.5e-3;            % s
deltaT = 1/rate;            % s

% Anterograde or retrograde propagation
if SPV < 100 && SPV > 0
    antero = 1;
elseif SPV < 100 && SPV < 0
    antero = -1;
else
    antero = 0;
end

% Plotting start and end times
if antero == 1
    tPlotStart = eventTime - eTime*(selElectrode - 1) - tBefore;
    tPlotEnd = eventTime + eTime*(numElectrodes - selElectrode) + tAfter;
elseif antero == -1
    tPlotStart = eventTime - eTime*(numElectrodes - selElectrode) - tBefore;
    tPlotEnd = eventTime + eTime*(selElectrode - 1) + tAfter;
else
    tPlotStart = eventTime - tBefore - numElectrodes*eTime/2;
    tPlotEnd = eventTime + tBefore + numElectrodes*eTime/2;
end

% Check if out of bounds
if tPlotStart < tReadStart
    tPlotStart = tReadStart;
end
if tPlotEnd > tReadStart + readDur
    tPlotEnd = tReadStart + readDur;
end

% Plotting start and end indices
iStart = floor((tPlotStart - tReadStart)/deltaT) + 1;
iEnd = floor((tPlotEnd - tReadStart)/deltaT) + 1;

% Plot data for each electrode in given window
axes(handles.axesTraces);
for n = 1:numElectrodes
    if n ~= highlight
        plot(time(iStart:iEnd), volt(iStart:iEnd, n),...
            'Color', [0.7, 0.7, 0.7]);
        axis tight
        hold on
    end
end
if highlight <= numElectrodes
    plot(time(iStart:iEnd), volt(iStart:iEnd, highlight),...
        'Color', [0.8, 0.2, 0.2]);
end
axis tight
xlabel('Time [s]');
ylabel('Voltage [µV]');
hold off

% Set font size
set(handles.axesTraces, 'FontSize', fontsize);

% Put variables in handles
handles.tPlotStart = tPlotStart;
handles.tPlotEnd = tPlotEnd;
handles.iStart = iStart;
handles.iEnd = iEnd;