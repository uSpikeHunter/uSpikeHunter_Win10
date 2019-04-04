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

% --- Creates first plot of spikes in a single color aligned by their
% minima/maxima

function handles = plotSpikes(hObject, eventdata, handles)

% Get variables from handles
volt = handles.volt;                % µV
events = handles.events;
rate = handles.rate*1e3;            % Hz
electrodes = handles.electrodes;
intEDist = handles.intEDist;        % µm
selElectrode = handles.sel;
numElectrodes = handles.numElectrodes;
numEvents = handles.numEvents;
ax = handles.ax;
axPos = handles.axPos;
R = handles.R;
axY = handles.axY;

% Get font size
fontsize = get(handles.axesSel, 'FontSize');

% Define plotting color array for different source clusters
handles.colors = 1/255*[64 64 102 25.5;      % blue-gray
    37 129 0 45.9;       % green
    160 34 15 45.9;      % red
    250 158 5 45.9;      % orange
    0 107 141 45.9];     % blue

% Time array (s)
deltaT = 1/rate;
tEnd = deltaT*(length(volt(:, 1))-1);
time = 0:deltaT:tEnd;
time = time.';

% Plotting window
tBefore = 1.5e-3;           % s
tAfter = 1.5e-3;            % s
iBefore = tBefore*rate;
iAfter = tAfter*rate;
timePlot = 1e3*time(1:iAfter+iBefore+1);    % ms

% Initialize indices of events on each electrode, new event array
eventsOverlay = cell(1, numElectrodes);

% Define array of indices for each set of events
indsInit = zeros(numEvents, numElectrodes);
for n = 1:numElectrodes
    indsInit(:, n) = events{n}(:, 3);
end
indsAlign = indsInit;

% Create spike overlay vectors for each electrode
for n = 1:numElectrodes
    for e = 1:numEvents
        iStart = round(indsAlign(e,n) - iBefore);
        iEnd = round(indsAlign(e,n) + iAfter);
        if iStart < 1
            prePad = zeros(1 - iStart,1);
            iStart = 1;
        else
            prePad = [];
        end
        if iEnd > length(volt(:,1))
            postPad = zeros(iEnd - length(volt(:,1)),1);
            iEnd = length(volt(:,1));
        else
            postPad = [];
        end
        eventsOverlay{n}(:,e) = [prePad; volt(iStart:iEnd,n); postPad];
    end
    if n == selElectrode
        xlabel('Time [ms]');
        ylabel('Voltage [µV]');
    end
    hold off
end

% Plot spikes
for n = 1:numElectrodes
    if n == selElectrode
        axes(handles.axesSel);
    elseif n < selElectrode
        axes(ax(n));
    else
        axes(ax(n-1));
    end
    plot(timePlot, eventsOverlay{n}, 'Color', handles.colors(1,:));
    axis tight
    title(electrodes{n});
    set(gca, 'FontSize', fontsize);
    if n == selElectrode
        xlabel('Time [ms]');
        ylabel('Voltage [µV]');
    end
end

% Set font size
set(handles.axesSel, 'FontSize', fontsize);

% Axis labels
labelSize = get(handles.txtTimeLabel, 'FontSize');
set(handles.txtTimeLabel, 'Visible', 'on');
Hax = axPos(1, 4);
Htot = R + (R-1)*axY(2)/Hax + (axY(1) + axY(3))/Hax;
postnY = 1 + axY(1)/Hax - Htot/2;
axes(ax(1));
vertlabel = ylabel('Voltage [µV]');
set(vertlabel, 'Units', 'normalized');
postn = get(vertlabel, 'Position');
set(vertlabel, 'Position', [postn(1) postnY]);
set(vertlabel, 'FontSize', labelSize);
set(vertlabel, 'FontWeight', 'bold');

% Number of events
set(handles.txtNumEvents, 'String', [char(string(numEvents)), ' events']);


% Initial realignment
% Do cross-correlation with z events before and z events after each
% event to achieve better alignment
% Each time, if the number of events is too close to the start or end of
% the list of events to do z events before and after, auto-correlation is
% done, adding a lag of zero to the total lag. The number of
% auto-correlations is taken into consideration when averaging the lag.
corrWindow = 0.5e-3;        % s
corrInd = round(corrWindow*rate)*intEDist/100;
z = 10;
for n = 1:numElectrodes
    for e = 1:numEvents
        eventInd = indsInit(e, n);
        corrStart = eventInd - corrInd;
        corrEnd = eventInd + corrInd;
        lagTot = 0;
        numReps = 0;
        for cc = 0-z:z
            eRef = e + cc;
            if eRef < 1
                eRef = e;
                numReps = numReps + 1;
            elseif eRef > numEvents
                eRef = e;
                numReps = numReps + 1;
            elseif eRef == e
                numReps = numReps + 1;
            end
            corrStartRef = indsInit(eRef, n) - corrInd;
            corrEndRef = indsInit(eRef, n) + corrInd;
            [xCorrel, lag] = xcorr(volt(corrStartRef:corrEndRef, n), ...
                volt(corrStart:corrEnd, n));
            [~, maxInd] = max(xCorrel);
            lagTot = lagTot + lag(maxInd);
        end
        lagIndMean = lagTot/(2*z+1 - numReps);
        lagInd = corrStart + (corrEnd - corrStart)/2 - lagIndMean;
        indsInit(e, n) = round(lagInd);
    end
end

% Initialize ROI object array and array of positions of ROIs
handles.ROI = cell(4,2);
handles.ROIpos = cell(4,2);

% Put variables in handles
handles.time = time;
handles.indsInit = indsInit;
handles.indsAlign = indsAlign;
handles.timePlot = timePlot;
handles.iBefore = iBefore;
handles.iAfter = iAfter;
handles.eventsOverlay = eventsOverlay;