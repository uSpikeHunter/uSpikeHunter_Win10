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

% --- Populates  row start and end menus

function menuRow(hObject, eventdata, handles)

% Get variables from handles
MEAnum = handles.MEAnum;

% Clear data analysis pane
clearGUI(hObject, eventdata, handles, 3);

% Set selected start and end electrode menus to top of list
set(handles.menuRowStart, 'Value', 1);
set(handles.menuRowEnd, 'Value', 1);

% Get selected row
contents = cellstr(get(handles.menuRow, 'String'));
row = contents{get(handles.menuRow, 'Value')};
row = str2double(row);

% Electrodes in selected row

% --- 60 electrodes
elec60 = [11:18; 21:28; 31:38; 41:48; 51:58; 61:68; 71:78; 81:88];

% --- 120 electrodes
% Rows 4-9
cols120 = char([uint8(65:72),uint8(74:77)]).';    % A to M excl. I
% Concatenate numbers with letters
nums120 = row*ones(1,12);
nums120 = nums120.';
nums120 = char(string(nums120));
elec120 = [cols120, nums120];
% Rows 1 and 12
cols120_112 = char([uint8(68:72),uint8(74)]).';
nums120_112 = row*ones(1,6);
nums120_112 = nums120_112.';
nums120_112 = char(string(nums120_112));
elec120_112 = [cols120_112, nums120_112];
% Rows 2 and 11
cols120_211 = char([uint8(67:72),uint8(74:75)]).';
nums120_211 = row*ones(1,8);
nums120_211 = nums120_211.';
nums120_211 = char(string(nums120_211));
elec120_211 = [cols120_211, nums120_211];
% Rows 3 and 10
cols120_310 = char([uint8(66:72),uint8(74:76)]).';
nums120_310 = row*ones(1,10);
nums120_310 = nums120_310.';
nums120_310 = char(string(nums120_310));
elec120_310 = [cols120_310, nums120_310];

% --- 256 electrodes
% Rows 2-15
cols256 = char([uint8(65:72),uint8(74:80),uint8(82)]).';    % A to R excl. I,Q
% Concatenate numbers with letters
nums256 = row*ones(1,16);
nums256 = nums256.';
nums256 = char(string(nums256));
elec256 = [cols256, nums256];
% Rows 1 and 16
cols256_row116 = char([uint8(66:72),uint8(74:80)]).'; % cols for rows 1 and 16
nums256_116 = row*ones(1,14);
nums256_116 = nums256_116.';
nums256_116 = char(string(nums256_116));
elec256_row116 = [cols256_row116, nums256_116];

% Update row start and end list depending on selected row
if MEAnum == 60
    if row == 1 || row == 8
        set(handles.menuRowStart, 'String', elec60(2:7,row));
        set(handles.menuRowEnd, 'String', elec60(2:7,row));
    elseif row == 5
        set(handles.menuRowStart, 'String', elec60(2:8,5));
        set(handles.menuRowEnd, 'String', elec60(2:8,5));
    else
        set(handles.menuRowStart, 'String', elec60(:,row));
        set(handles.menuRowEnd, 'String', elec60(:,row));
    end
elseif MEAnum == 120
    if row == 1 || row == 12
        set(handles.menuRowStart, 'String', elec120_112);
        set(handles.menuRowEnd, 'String', elec120_112);
    elseif row == 2 || row == 11
        set(handles.menuRowStart, 'String', elec120_211);
        set(handles.menuRowEnd, 'String', elec120_211);
    elseif row == 3 || row == 10
        set(handles.menuRowStart, 'String', elec120_310);
        set(handles.menuRowEnd, 'String', elec120_310);
    else
        set(handles.menuRowStart, 'String', elec120);
        set(handles.menuRowEnd, 'String', elec120);
    end
elseif MEAnum == 252
    if row == 1 || row == 16
        set(handles.menuRowStart, 'String', elec256_row116);
        set(handles.menuRowEnd, 'String', elec256_row116);
    else
        set(handles.menuRowStart, 'String', elec256);
        set(handles.menuRowEnd, 'String', elec256);
    end
end