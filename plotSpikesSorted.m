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

% --- Creates plot of sorted spikes

function handles = plotSpikesSorted(hObject, eventdata, handles)

% Get variables from handles
volt = handles.volt;
rate = handles.rate;            % kHz
electrodes = handles.electrodes;
selElectrode = handles.sel;
numElectrodes = handles.numElectrodes;
numEvents = handles.numEvents;
indsAlign = handles.indsAlign;
iBefore = handles.iBefore;
timePlot = handles.timePlot;
colors = handles.colors;
ROI = handles.ROI;
ROIpos = handles.ROIpos;
eventsOverlay = handles.eventsOverlay;
ax = handles.ax;
axPos = handles.axPos;
R = handles.R;
axY = handles.axY;

% Set has sorted to 1
handles.hasSorted = 1;

% Get font size
fontsize = get(handles.axesSel, 'FontSize');

% Re-initialize cluster ID vector
clusterID = zeros(numEvents, 1);

% Get positions of ROIs and see if spikes inside bounds
for g = 1:4
    for r = 1:2
        if ~isempty(ROI{g,r})
            if isvalid(ROI{g,r})
                ROIpos{g,r} = getPosition(ROI{g,r});
                setConstrainedPosition(ROI{g,r},ROIpos{g,r})
            else
                ROIpos{g,r} = [];
            end
        end
    end
end

% See if spikes inside bounds of ROIs
inRange = cell(2,1);
for e = 1:numEvents
    for g = 1:4
        for r = 1:2
            inRange{r} = [];
            if ~isempty(ROIpos{g,r})
                % Time bounds
                Tmin = ROIpos{g,r}(1);
                Tmax = ROIpos{g,r}(1) + ROIpos{g,r}(3);
                % Translate to index bounds in original voltage array
                imin = round(Tmin*rate) + indsAlign(e,selElectrode) - iBefore;
                imax = round(Tmax*rate) + indsAlign(e,selElectrode) - iBefore;
                % Voltage bounds
                Vmin = ROIpos{g,r}(2);
                Vmax = ROIpos{g,r}(2) + ROIpos{g,r}(4);
                % Check if in range for each ROI in the cluster
                inRange{r} = find(volt(imin:imax, selElectrode) <= Vmax...
                    & volt(imin:imax, selElectrode) >= Vmin, 1);
            else
                inRange{r} = 0;
            end
        end
        if ~isempty(inRange{1}) && ~isempty(inRange{2}) && ...
                (inRange{1} ~= 0 || inRange{2} ~= 0) && clusterID(e) == 0
            clusterID(e) = g;
        end
    end
end

% Plot with color based on cluster
for n = 1:numElectrodes
    if n == selElectrode
        axes(handles.axesSel);
    elseif n < selElectrode
        axes(ax(n));
    else
        axes(ax(n-1));
    end
    for g = 4:-1:0
        plotColor = colors(g + 1,:);
        clusterEvents = eventsOverlay{n}(:, clusterID == g);
        if ~isempty(clusterEvents)
            plot(timePlot, clusterEvents, 'Color', plotColor);
            axis tight
            hold on
        end
    end
    title(electrodes{n});
    if n == selElectrode
        xlabel('Time [ms]');
        ylabel('Voltage [µV]');
    end
    % Keep ROIs in selected electrode plot
    if n == selElectrode
        for g = 1:4
            for r = 1:2
                if ~isempty(ROIpos{g,r})
                    ROI{g,r} = imrect(handles.axesSel, ROIpos{g,r});
                    setPosition(ROI{g,r}, ROIpos{g,r});
                    setColor(ROI{g,r}, colors(g+1,:));
                    hold on
                end
            end
        end
    end
    hold off
    set(gca, 'FontSize', fontsize);
end

% Vertical axis label in subplots
labelSize = get(handles.txtTimeLabel, 'FontSize');
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

% Put variables in handles
handles.clusterID = clusterID;
handles.ROIpos = ROIpos;
handles.ROI = ROI;