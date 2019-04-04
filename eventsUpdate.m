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

% --- Updates events list in main GUI with new information from spike
% sorting GUI

function handles = eventsUpdate(hObject, eventdata, handles)

% Get variables from handles
CPV = handles.CPV;
clusterID = handles.clusterID;
inds = handles.inds;
events = handles.events;
numEvents = handles.numEvents;
numElectrodes = handles.numElectrodes;
names = handles.names;

% Create new event names for event list
for n = 1:numElectrodes
    for e = 1:numEvents
        eventTime = round(events{n}(e,2), 4);
        eventTime = sprintf('%.3f', eventTime);
        eventAmp = round(events{n}(e,1), 1);
        eventAmp = sprintf('%.1f', eventAmp);
        eventCluster = sprintf('%d', clusterID(e));
        eventCluster = ['Cluster ', eventCluster];
        eventCPV = round(CPV(e), 3);
        eventCPV = sprintf('%.3f', eventCPV);
        eventCPV = [', PV = ', eventCPV, ' m/s'];
        namesInit{e} = [eventCluster, ':  t = ', eventTime, ...
            ' s, V = ', eventAmp, ' µV', eventCPV];
    end
    names{n} = namesInit;
end

% Get handles structure from root
mainHandles = getappdata(0, 'mainHandles');
% Put variables into main GUI handles
mainHandles.names = names;
mainHandles.PV = CPV;
mainHandles.clusterID = clusterID;
mainHandles.inds = inds;
mainHandles.hasSorted = handles.hasSorted;
% Update main handles structure
setappdata(0, 'mainHandles', mainHandles);

% Run EventElectrode menu callback to populate list of events for selected
% electrode, display the number of events, and plot data
mainHandles = electrodeChange(hObject, eventdata, mainHandles);
% Update main handles structure
setappdata(0, 'mainHandles', mainHandles);