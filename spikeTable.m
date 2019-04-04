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

% --- Populates table with cluster ID and color, number of events in that
% cluster, average CPV ± stdev, and CPV confidence

function handles = spikeTable(hObject, eventdata, handles)

% Get variables from handles
inds = handles.inds;
rate = handles.rate*1e3;            % Hz
intEDist = handles.intEDist*1e-6;   % m
numEvents = handles.numEvents;
clusterID = handles.clusterID;
eventCount = handles.eventCount;
pairNums = handles.pairNums;
maxXCorr = handles.maxXCorr;

% Array of color names and cluster ID names
colorNames = {'Gray', 'Green', 'Red', 'Orange', 'Blue'};
IDnames = 0:4;

% Get electrodes used to calculate PV
selection = get(handles.menuPair, 'Value');
PVelectrodes = pairNums(selection, :);
numDists = abs(PVelectrodes(2) - PVelectrodes(1));

% Calculate confidence index for each CPV estimate and average
% The CPV confidence index is calculated as follows. The average peak
% cross-correlation values are obtained for each cluster on each electrode.
% The confidence index of an event is the minimum of these averages among
% the two electrodes used to calculate the CPV.
CPVconf = zeros(numEvents, 1);
avCPVconf = zeros(5,1);
avCPVconfStr = cell(5,1);
for e = 1:numEvents
    CPVconf(e) = min(maxXCorr(e,PVelectrodes));
end
for g = 0:4
    CPVconfCluster = CPVconf(clusterID == g);
    avCPVconf(g+1) = mean(CPVconfCluster);
    avCPVconfStr{g+1} = sprintf('%0.3f', avCPVconf(g+1));
end

% Calculate PVs from adjusted indices based on cross-correlation for event
% alignment performed in plotSpikes
eventTimes = (inds-1)/rate;         % s
CPV = zeros(numEvents, 1);
for e = 1:numEvents
    % Event times on selected electrodes
    tInit = eventTimes(e, PVelectrodes(1));
    tFin = eventTimes(e, PVelectrodes(2));
    CPV(e) = numDists*intEDist/(tFin - tInit);        % m/s
end

% Calculate average CPV for each sorted cluster of spikes
avCPV = zeros(5,1);
sigCPV = zeros(5,1);
avCPVstr = cell(5,1);
for g = 0:4
    CPVcluster = CPV(clusterID == g);
    avCPV(g+1) = mean(abs(CPVcluster));
    sigCPV(g+1) = std(abs(CPVcluster));
    avCPVstr{g+1} = [sprintf('%0.3f',avCPV(g+1)), ' m/s ± ', ...
        sprintf('%0.3f',sigCPV(g+1)), ' m/s'];
    if avCPV(g+1) > 100 || sigCPV(g+1) > avCPV(g+1)
        avCPVstr{g+1} = 'Undefined';
        avCPVconfStr{g+1} = 'N/A';
    end
end

% Display information in table
b = 0;
for a = 1:5
    if eventCount(a) ~= 0
        b = b+1;
        data{b, 1} = char(string(IDnames(a)));
        data{b, 2} = colorNames{a};
        data{b, 3} = char(string(eventCount(a)));
        data{b, 4} = avCPVstr{a};
        data{b, 5} = avCPVconfStr{a};
    end
end
set(handles.tableSorted, 'Data', data);
set(handles.tableSorted, 'Visible', 'on');
set(handles.tableSorted, 'FontWeight', 'bold');
set(handles.tableSorted, 'Enable', 'inactive');

% Redefine position of table
pos = get(handles.tableSorted, 'Position');
X = pos(1);
W = pos(3);
if X < 170
    H = 1.5 + b*1.15;
else
    H = 1.7 + b*1.4;
end
Y = pos(2) + pos(4) - H;
set(handles.tableSorted, 'Position', [X Y W H]);

% Put variables in handles
handles.CPV = CPV;
handles.avCPV = avCPV;
handles.sigCPV = sigCPV;
handles.CPVconf = CPVconf;
handles.eventCount = eventCount;
handles.eventTimes = eventTimes;