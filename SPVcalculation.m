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

% --- Calculates single-unit propagation velocity estimate based on
% selected pair of electrodes

function handles = SPVcalculation(hObject, eventdata, handles)

% Get variables from handles
selElectrode = handles.selElectrode;
selEvent = handles.selEvent;
SPV = handles.SPV;
SPVstr = handles.SPVstr;
SPVconf = handles.SPVconf;
xCorrPeak = handles.xCorrPeak;

% Get selected electrode pair for PV calculation
pairInd = get(handles.menuXCorrPV, 'Value') - 1;

% Define strings to set PV and confidence
if pairInd > 0
    % If single electrode pair is selected
    SPVev = SPV{selElectrode}(selEvent, pairInd);
    if SPVev > 100
        setSPVstr = 'Undefined';
    else
        setSPVstr = sprintf('%0.3f', round(SPVev, 3));
        setSPVstr = [setSPVstr, ' m/s'];
    end
    conf = round(xCorrPeak{selElectrode}(selEvent, pairInd), 3);
    confStr = sprintf('%0.3f', conf);
else
    % If all electrodes to be averaged
    setSPVstr = SPVstr{selElectrode}{selEvent};
    conf = round(SPVconf{selElectrode}(selEvent), 3);
    confStr = sprintf('%0.3f', conf);
end

% Set text to average and standard deviation of PV, confidence interval
% text to confidence level
set(handles.txtPV, 'String', setSPVstr);
set(handles.txtConfidence, 'String', confStr);