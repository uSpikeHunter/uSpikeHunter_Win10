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

% --- Plot cross-correlation for each possible pair of electrodes for
% selected event

function handles = spikeXCorrPlot(hObject, eventdata, handles)

% Get variables from handles
lagNorm = handles.lagNorm;
xCorrel = handles.xCorrel;
selElectrode = handles.selElectrode;
selEvent = handles.selEvent;
xCorrhigh = handles.xCorrhigh;
numElectrodes = handles.numElectrodes;

% Get font size
fontsize = get(handles.axesXCorr, 'FontSize');

% Colors for plotting
map = colormap(copper(numElectrodes-1));
map = flip(map);
axes(handles.axesXCorr);

% Number of electrode pairs and pairs matrix
numPairs = numElectrodes*(numElectrodes - 1)/2;
pairs = flip(combnk(1:numElectrodes, 2), 1);

% Perform cross-correlation and plot
for j = 1:numPairs
    n = pairs(j, 1);
    m = pairs(j, 2);
    % Plot with parula colormap indicating distance
    par = map(m-n,:);
    par = flip(par);
    p = plot(lagNorm{selElectrode}{selEvent,j}, ...
        xCorrel{selElectrode}{selEvent,j},...
        'Color', par);
    axis tight
    hold on
    if j ~= xCorrhigh
        p.Color(4) = 0.35;
    end
    if j == xCorrhigh
        highColor = par;
    end
end

if xCorrhigh <= numPairs
    plot(lagNorm{selElectrode}{selEvent, xCorrhigh}, ...
        xCorrel{selElectrode}{selEvent, xCorrhigh}, ...
        'Color', highColor);
end
xlabel('Time to travel 1 m [s]');
ylabel('Cross-correlation');
hold off

% Set font size
set(handles.axesXCorr, 'FontSize', fontsize);