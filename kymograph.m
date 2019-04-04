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

% --- The kymograph is an n by p matrix, where n is the number of
% electrodes and p is a number of time bins selected such that spikes are
% visible. The kymograph is plotted over a time interval roughly 1 ms less
% than the trace plot.

function handles = kymograph(hObject, eventdata, handles)

% Get variables from handles
rate = handles.rate*1e3;
tPlotStart = handles.tPlotStart;
tPlotEnd = handles.tPlotEnd;
iStart = handles.iStart;
numElectrodes = handles.numElectrodes;
volt = handles.volt;

% Get font size
fontsize = get(handles.axesKymo, 'FontSize');

% Define timespan and binning interval. The binning interval is a multiple
% of deltaT (measurement time interval), and the timespan is a multiple of 
% the binning interval.
deltaT = 1/rate;   % s
kymoTime = tPlotEnd - tPlotStart - 1e-3;
kymoInterval = deltaT;
handles.kymoInterval = kymoInterval;
kymoTime = kymoInterval*floor(kymoTime/kymoInterval);
% Samples per bin and number of kymograph bins
sPerBin = kymoInterval/deltaT;
numBins = floor(kymoTime/kymoInterval);
% Indices in the original dataset used for kymograph
kStart = iStart + ceil(0.5e-3*rate);
kEnd = kStart + kymoTime*rate;

% Time array to include along horizontal axis
file = get(handles.edtFile, 'String');
if contains(file, '.h5')
    contents = cellstr(get(handles.menuStartTime,'String'));
    readStart = str2double(contents{get(handles.menuStartTime, 'Value')});
else
    readStart = 0;
end
ktStart = kStart*deltaT;
ktEnd = kEnd*deltaT;
kTimeAll = ktStart:kymoInterval:ktEnd;
z = 1;
if numElectrodes <= 8
    for b = 1:numBins
        if mod(kTimeAll(b),0.0005) == 0
            kTimeTicks(z) = b;
            kTime(z) = kTimeAll(b);
            z = z+1;
        end
    end
else
    for b = 1:numBins
        if mod(kTimeAll(b),0.001) == 0
            kTimeTicks(z) = b;
            kTime(z) = kTimeAll(b);
            z = z+1;
        end
    end
end
kTime = kTime + readStart;

% Array containing names of first and last electrodes to include along
% vertical axis
allElectrodes = cellstr(get(handles.menuEventElectrode, 'String'));
firstElectrode = allElectrodes{1};
lastElectrode = allElectrodes{numElectrodes};
yLabels = {firstElectrode};
for l = 1:numElectrodes-2
    yLabels = [yLabels; {''}];
end
yLabels = [yLabels; lastElectrode];

% Make kymograph matrix
preKymo = volt(kStart:kEnd, :);
kymo = zeros(numBins, numElectrodes);
for e = 1:numElectrodes
    k = 1;
    for b = 1:numBins
        vals = preKymo(k:k+sPerBin-1, e);
        kymo(b, e) = mean(vals);
        k = k+sPerBin;
    end
end
kymo = kymo.';

% Set plot to image
axes(handles.axesKymo);
kymo = mat2gray(kymo);
colormap default;
imagesc(kymo, [0 1]);
colormap(copper);
axis on;
yticks(1:numElectrodes+1);
xticks(kTimeTicks);
set(handles.axesKymo, 'YTickLabel', yLabels);
set(handles.axesKymo, 'XTickLabel', string(kTime));
set(handles.axesKymo, 'TickLength', [0 0]);
xlabel('Time [s]');

% Set font size
set(handles.axesKymo, 'FontSize', fontsize);