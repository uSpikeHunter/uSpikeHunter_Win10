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

% --- Perform cross-correlation for each event on each electrode and
% calculate PV based on cross-correlation

function handles = spikeXCorr(hObject, eventdata, handles)

% Get variables from handles
events = handles.events;
tReadStart = handles.tReadStart;
numElectrodes = handles.numElectrodes;
numEvents = handles.numEvents;
rate = handles.rate*1e3;
eSpacing = handles.eSpacing;
readDur = handles.readDur;
volt = handles.volt;
intEDist = handles.intEDist;

% Cross-correlation window (s)
xCorrWindow = 7.5*eSpacing;

% Initialize cross-correlation cell array, lag vectors, PV and average PV,
% distance
numPairs = numElectrodes*(numElectrodes - 1)/2;
xCorrel = cell(numElectrodes, 1);
xCorrPeak = cell(numElectrodes, 1);
lagInd = zeros(numPairs, 1);
lagTime = zeros(numPairs, 1);
lagNorm = cell(numElectrodes, 1);
dist = zeros(numPairs, 1);
SPV = cell(numElectrodes, 1);
avSPV = cell(numElectrodes, 1);
sigmaSPV = cell(numElectrodes, 1);
SPVstr = cell(numElectrodes, 1);
SPVconf = cell(numElectrodes, 1);

% Perform cross-correlation and calculate average PV over all electrode
% pairs for each event
for s = 1:numElectrodes
    if numEvents ~= 0
        xCorrel{s} = cell(numEvents, numPairs);
        xCorrPeak{s} = zeros(numEvents, numPairs);
        lagNorm{s} = cell(numEvents, numPairs);
        SPV{s} = zeros(numEvents, numPairs);
        avSPV{s} = zeros(numEvents, 1);
        sigmaSPV{s} = zeros(numEvents, 1);
        SPVstr{s} = cell(numEvents, numPairs + 1);
        SPVconf{s} = zeros(numEvents, 1);
        for ev = 1:numEvents
            j = 0;
            eventTime = events{s}(ev, 2);
            for n = 1:numElectrodes-1
                for m = n+1:numElectrodes
                    j = j+1;
                    % Indices for cross-correlation window
                    corrStart = floor(rate*(eventTime - tReadStart - (m-n)*xCorrWindow));
                    corrEnd = floor(rate*(eventTime - tReadStart + (m-n)*xCorrWindow));
                    if corrStart < 1
                        corrStart = 1;
                    end
                    readEnd = readDur*rate;
                    if corrEnd > readEnd
                        corrEnd = readEnd;
                    end
                    % Cross-correlation between electrodes m and n
                    [xCorrel{s}{ev,j}, lag] = xcorr(volt(corrStart:corrEnd, m),...
                        volt(corrStart:corrEnd, n), 'coeff');
                    % Propagation velocity
                    [xCorrPeak{s}(ev,j), maxInd] = max(xCorrel{s}{ev,j});
                    lagInd(j) = lag(maxInd);
                    lagTime(j) = lagInd(j)*1e3/handles.rate;        % µs
                    dist(j) = (m-n)*intEDist;
                    SPV{s}(ev,j) = dist(j)/lagTime(j);
                    % Normalized by distance
                    lagNorm{s}{ev,j} = lag.'/(rate*dist(j)*1e-6);         % s
                end
            end
            avSPV{s}(ev) = mean(SPV{s}(ev,:));
            sigmaSPV{s}(ev) = std(SPV{s}(ev,:));
            if avSPV{s}(ev) < 100
                avSPVstr = sprintf('%0.3f', round(avSPV{s}(ev), 3));
                sigmaSPVstr = sprintf('%0.3f', round(sigmaSPV{s}(ev), 3));
                if numElectrodes > 2
                    SPVstr{s}{ev} = [avSPVstr, ' m/s ± ', sigmaSPVstr, ' m/s'];
                else
                    SPVstr{s}{ev} = [avSPVstr, ' m/s'];
                end
            else
                SPVstr{s}{ev} = 'Undefined';
            end
            SPVconf{s}(ev) = min(xCorrPeak{s}(ev,:));
        end
    end
end

% Put variables in handles
handles.SPV = SPV;
handles.avSPV = avSPV;
handles.sigmaSPV = sigmaSPV;
handles.SPVstr = SPVstr;
handles.xCorrel = xCorrel;
handles.lagNorm = lagNorm;
handles.SPVconf = SPVconf;
handles.xCorrPeak = xCorrPeak;