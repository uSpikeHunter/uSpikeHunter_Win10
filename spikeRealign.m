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

% --- Spike realignment after sorting

function handles = spikeRealign(hObject, eventdata, handles)

% Get variables from handles
volt = handles.volt;
indsInit = handles.indsInit;
rate = handles.rate*1e3;            % Hz
intEDist = handles.intEDist*1e-6;   % m
isNeg = handles.isNeg;
numElectrodes = handles.numElectrodes;
numEvents = handles.numEvents;
clusterID = handles.clusterID;

% Count number of events in each cluster
eventCount = zeros(4,1);
for g = 0:5
    eventCount(g+1) = length(find(clusterID == g));
end

% Define new event indices through new alignment based on intra-cluster 
% cross-correlation
searchTime = 1e-3;         % Search window (s)
searchInd = round(searchTime*rate*intEDist*1e4);
maxXCorr = zeros(numEvents, numElectrodes);
inds = indsInit;
for n = 1:numElectrodes
    for e = 1:numEvents
        g = clusterID(e);
        eventInd = indsInit(e, n);
        corrStart = eventInd - searchInd;
        corrEnd = eventInd + searchInd;
        lagTot = 0;
        % Cross-correlation with all other events in the same cluster
        if eventCount(g+1) > 1
            for cc = 1:eventCount(g+1)
                eventsInCluster = find(clusterID == g);
                eRef = eventsInCluster(cc);
                corrStartRef = indsInit(eRef, n) - searchInd;
                corrEndRef = indsInit(eRef, n) + searchInd;
                [xCorrel, lag] = xcorr(volt(corrStartRef:corrEndRef, n), ...
                    volt(corrStart:corrEnd, n), 'coeff');
                [maxVal, maxInd] = max(xCorrel);
                % Sum all maximum values of xcorr for averaging
                maxXCorr(e,n) = maxXCorr(e,n) + maxVal;
                % Sum all lags
                lagTot = lagTot + lag(maxInd);
            end
            % Mean lag (excluding auto-correlation) to get new index
            lagMean = round(lagTot/(eventCount(g+1) - 1));
            lagInd = eventInd - lagMean;
            inds(e, n) = round(lagInd);
            % Mean maximum cross-correlation value
            maxXCorr(e,n) = (maxXCorr(e,n) - 1)/(eventCount(g+1) - 1);
        elseif eventCount(g+1) == 1
            maxXCorr(e,n) = 1;
        end
    end
end

% Update index to correspond to time when sum of spike amplitudes in each
% cluster is at the peak magnitude
ampSum = zeros(2*searchInd+1, 6);
for n = 1:numElectrodes
    for e = 1:numEvents
        g = clusterID(e);
        eventInd = inds(e, n);
        iStart = eventInd - searchInd;
        iEnd = eventInd + searchInd;
        ampSum(:, g+1) = ampSum(:, g+1) + volt(iStart:iEnd, n);
    end
    % Find largest peak in amplitude summation for each cluster
    for g = 0:4
        if isNeg == 1
            lagPeak = find(ampSum(:,g+1) == min(ampSum(:,g+1)), 1) - searchInd - 1;
        else
            lagPeak = find(ampSum(:,g+1) == max(ampSum(:,g+1)), 1) - searchInd - 1;
        end
        % Adjust indices based on largest peak
        eventsInCluster = find(clusterID == g);
        inds(eventsInCluster, n) = inds(eventsInCluster, n) + lagPeak;
    end
end

% Put variables in handles
handles.inds = inds;
handles.eventCount = eventCount;
handles.maxXCorr = maxXCorr;