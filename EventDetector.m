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

% --- Takes sampling rate (Hz), threshold (number of standard deviations),
% voltage data, and channel as inputs.
% Outputs array of event times and amplitudes, event count, voltage
% threshold and spike rate.

function [events, c, thresh, spikeRate] = EventDetector(rate, Nsig, data, channel, neg)

% Parameters
t = 1e-3;     % Approx. duration of a spike (s)
n = rate*t;   % Number of samples spanning a spike

% Data should already have been bandpass-filtered
% Convert data to double and select channel
volt = double(data(:, channel));

% Eliminate outlier voltage samples and calculate median, sigma, threshold,
% and return threshold
c = -1/(sqrt(2)*erfcinv(3/2));
MAD = c*median(abs(volt - median(volt)));
noisePlus = median(volt) + 3*MAD;
noiseMinus = median(volt) - 3*MAD;
noiseInds = volt < noisePlus & volt > noiseMinus;
noise = volt(noiseInds);
sig = std(noise);

if neg == 1
    thresh = median(noise) - Nsig*sig;
    if Nsig > 1.5
        threshOff = median(noise) - (Nsig/3)*sig;
    else
        threshOff = thresh;
    end
else
    thresh = median(noise) + Nsig*sig;
    if Nsig > 1.5
        threshOff = median(noise) + (Nsig/3)*sig;
    else
        threshOff = thresh;
    end
end

% Event detection
c = 0;   % Initialize event count
k = 0;   % Initialize switch index
if neg == 1
    for i=1:length(volt)-n
        % If voltage is below detection threshold, add event to events
        % list, increment event count, and change switch index to 1
        if k == 0 && volt(i) <= thresh
            c = c+1;
            k = 1;
            e = volt(i:i+n);
            [M, index] = min(e);
            events(c, 1) = M;   % Max amplitude of event
            events(c, 2) = (index+i-2)/rate;   % Time of event (s)
            events(c, 3) = index+i-1;    % Index of event
        % If switch index is on and voltage exceeds return threshold,
        % change switch index back to 0
        elseif k == 1 && volt(i) >= threshOff
            k = 0;
        end
    end
else
    for i=1:length(volt)-n
        % If voltage is above detection threshold, add event to events
        % list, increment event count, and change switch index to 1
        if k == 0 && volt(i) >= thresh
            c = c+1;
            k = k+1;
            e = volt(i:i+n);
            [M, index] = max(e);
            events(c, 1) = M;   % Max amplitude of event
            events(c, 2) = (index+i-2)/rate;   % Time of event (s)
            events(c, 3) = index+i-1;    % Index of event
        % If switch index is on and voltage is below return threshold,
        % change switch index back to 0
        elseif k == 1 && volt(i) <= threshOff
            k = 0;
        end
    end
end

if c == 0
    events = zeros(1, 3);
end


% Average spike rate
spikeRate = c/(length(volt)/rate);