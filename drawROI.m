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

% --- Allows user to draw ROI

function handles = drawROI(hObject, eventdata, handles)

% Get variables from handles
colors = handles.colors;
grp = handles.grp;
reg = handles.reg;
ROI = handles.ROI;

% Delete old ROI if present
if ~isempty(ROI{grp,reg})
    delete(ROI{grp,reg});
end

% Draw ROI in color associated with group
ROI{grp,reg} = imrect(handles.axesSel);
setColor(ROI{grp,reg}, colors(grp+1,1:3));

% Put variables into handles
handles.ROI = ROI;