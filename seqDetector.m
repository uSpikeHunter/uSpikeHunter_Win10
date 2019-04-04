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

% --- Uses Event Detector function to generate names for events list and
% populate events list

function handles = seqDetector(hObject, eventdata, handles)

% Get variables from handles
numElectrodes = handles.numElectrodes;
volt = handles.volt;
rate = handles.rate*1e3;
tStart = handles.tStart;
intEDist = handles.intEDist;

% Generate event names for event list using event detector
Nsig = str2double(get(handles.edtNsig, 'String'));
isNeg = get(handles.radNegPhase, 'Value');

% Initialize count vector, events cell array, and threshold vector
events = cell(1, numElectrodes);
thresh = zeros(numElectrodes, 1);

% Calculate thresholds using same method as in event detector
c = -1/(sqrt(2)*erfcinv(3/2));
for n = 1:numElectrodes
    MAD = c*median(abs(volt(:,n) - median(volt(:,n))));
    noisePlus = median(volt) + 3*MAD;
    noiseMinus = median(volt) - 3*MAD;
    noiseInds = volt < noisePlus & volt > noiseMinus;
    noise = volt(noiseInds);
    sig = std(noise);
    if isNeg == 1
        thresh(n) = median(noise) - Nsig*sig;
    else
        thresh(n) = median(noise) + Nsig*sig;
    end
end

% Run event detector on electrode closest to center
ch = round(numElectrodes/2);
[ev, ~, thresh(ch), ~] = EventDetector(rate, Nsig, volt, ch, isNeg);
% Only include events that can be analyzed, i.e., where the time before
% and the time after is within the defined tolerance of the read time
tol = 1.5e-3*ceil(numElectrodes/2);
tEnd = length(volt(:, 1))/rate;
ev = ev(ev(:,2) > tol & ev(:,2) < tEnd - tol, :);
numEvents = size(ev, 1);

% Check around each event for events on other electrodes
evSearch = 1e-3;           % Search window for each 100 µm (s)
searchInd = round(evSearch*rate)*intEDist/100;
k = 0;
for e = 1:numEvents
    % Index for detected event
    eventInd = ev(e, 3);
    % Initialize min/max amplitude, index vectors, and start and end search
    % window arrays
    Mamp = zeros(numElectrodes, 1);
    Mind = zeros(numElectrodes, 1);
    iStart = zeros(numElectrodes, 1);
    Mtime = zeros(numElectrodes, 1);
    for n = 1:numElectrodes
        % Find max/min in search window for each electrode and check if
        % behond threshold
        iStart(n) = eventInd - searchInd*abs(ch-n);
        iEnd = eventInd + searchInd*abs(ch-n);
        if isNeg == 1
            [Mamp(n), Mind(n)] = min(volt(iStart(n):iEnd, n));
            Mtime(n) = (Mind(n) + iStart(n) - 2)/rate + tStart;
            if Mamp(n) > thresh(n)
                Mind(n) = -1;
            end
        else
            [Mamp(n), Mind(n)] = max(volt(iStart(n):iEnd, n));
            Mtime(n) = (Mind(n) + iStart(n) - 2)/rate + tStart;
            if Mamp(n) < thresh(n)
                Mind(n) = -1;
            end
        end
    end
    % If unit meets following conditions, add to event array:
    % 1.  No electrodes fail threshold test
    % 2.  Event times on first and last electrodes are not too close (max
    %     allowable PV of 100 m/s)
    % 3.  Kendall rank coefficient between time and electrode number is
    %     greater than 0.8
    % 1
    failThresh = find(Mind == -1, 1);
    % 2
    indInit = Mind(1) + iStart(1) - 1;
    indFin = Mind(numElectrodes) + iStart(numElectrodes) - 1;
    indTol = floor((numElectrodes - 1)*intEDist*1e-6*rate/100);
    % 3
    elInd = (1:numElectrodes)';
    Kcorr = abs(corr(Mtime, elInd, 'Type', 'Kendall'));
    if isempty(failThresh) && abs(indFin-indInit) > indTol && Kcorr >= 0.8
        k = k + 1;
        for n = 1:numElectrodes
            events{n}(k, 1) = Mamp(n);
            events{n}(k, 2) = Mtime(n);
            events{n}(k, 3) = Mind(n) + iStart(n) - 1;
        end
    end
end
numEvents = k;

% Create event names
names = cell(numElectrodes, 1);
for n = 1:numElectrodes
    namesInit = {''};
    for e = 1:numEvents
        ampEvent = round(events{n}(e,1),1);
        ampEvent = sprintf('%.1f', ampEvent);
        timeEvent = round(events{n}(e,2),4);
        timeEvent = sprintf('%.4f', timeEvent);
        namesInit{e} = ['          Event ', sprintf('%d', e), ':     t = ', ...
            timeEvent, ' s,     ', 'V = ', ampEvent, ' µV'];
    end
    names{n} = namesInit;
end

% Put start time and duration of read data (s) into handles
if contains(handles.file, '.h5')
    contents = cellstr(get(handles.menuStartTime,'String'));
    handles.tReadStart = str2double(contents{get(handles.menuStartTime, 'Value')});
    contents = cellstr(get(handles.menuDur,'String'));
    handles.readDur = str2double(contents{get(handles.menuDur, 'Value')});
else
    handles.tReadStart = 0;
    handles.readDur = handles.durSec;
end

% Put variables into handles
handles.events = events;
handles.numEvents = numEvents;
handles.names = names;
handles.isNeg = isNeg;
handles.thresh = thresh;

% Perform cross-correlation to calculate PV
handles = spikeXCorr(hObject, eventdata, handles);

% Run EventElectrode menu callback to populate list of events for selected
% electrode, display the number of events, and plot data
handles = electrodeChange(hObject, eventdata, handles);