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

% --- Populates column start and end menus

function menuColumn(hObject, eventdata, handles)

% Get variables from handles
MEAnum = handles.MEAnum;

% Clear data analysis pane
clearGUI(hObject, eventdata, handles, 3);

% Set selected electrode menus to top of list
set(handles.menuColumnStart, 'Value', 1);
set(handles.menuColumnEnd, 'Value', 1);

% Get selected column
contents = cellstr(get(handles.menuColumn, 'String'));
col = contents{get(handles.menuColumn, 'Value')};
col = uint8(col);

% Electrodes in selected column

% --- 60 electrodes
elec60_colA = [12,13,14,16,17];             % electrodes in col A
elec60 = [11:18; 21:28; 31:38; 41:48; 51:58; 61:68; 71:78; 81:88];

% --- 120 electrodes
% Cols D-J
rows120 = 1:12;
nums120 = rows120.';                        % row numbers
nums120 = char(string(nums120));
cols120 = char(col*uint8(ones(1,12))).';    % col letters
elec120 = [cols120, nums120];
% Cols A and M
rows120_colAM = 4:9;                        % rows for cols A and M
nums120_colAM = rows120_colAM.';
nums120_colAM = char(string(nums120_colAM));
cols120_colAM = char(col*uint8(ones(1,6))).';
elec120_colAM = [cols120_colAM, nums120_colAM];
% Cols B and L
rows120_colBL = 3:10;                       % rows for cols B and L
nums120_colBL = rows120_colBL.';
nums120_colBL = char(string(nums120_colBL));
cols120_colBL = char(col*uint8(ones(1,8))).';
elec120_colBL = [cols120_colBL, nums120_colBL];
% Cols C and K
rows120_colCK = 2:11;                       % rows for cols C and K
nums120_colCK = rows120_colCK.';
nums120_colCK = char(string(nums120_colCK));
cols120_colCK = char(col*uint8(ones(1,10))).';
elec120_colCK = [cols120_colCK, nums120_colCK];

% --- 256 electrodes
% Cols B-P
rows256 = 1:16;
nums256 = rows256.';
nums256 = char(string(nums256));
cols256 = char(col*uint8(ones(1,16))).';    % col letters
elec256 = [cols256, nums256];
% Cols A and R
rows256_colAR = 2:15;                   % rows for cols A and R
cols256_colAR = char(col*uint8(ones(1,14))).'; % cols for rows 1 and 16
nums256_colAR = rows256_colAR.';
nums256_colAR = char(string(nums256_colAR));
elec256_colAR = [cols256_colAR, nums256_colAR];

% Update row start and end list depending on selected column
if MEAnum == 60
    if col == 65
        set(handles.menuColumnStart, 'String', elec60_colA);
        set(handles.menuColumnEnd, 'String', elec60_colA);
    elseif col == 72
        set(handles.menuColumnStart, 'String', elec60(col-64,2:7));
        set(handles.menuColumnEnd, 'String', elec60(col-64,2:7));
    else
        set(handles.menuColumnStart, 'String', elec60(col-64,:));
        set(handles.menuColumnEnd, 'String', elec60(col-64,:));
    end
elseif MEAnum == 120
    if col == 65 || col == 77
        set(handles.menuColumnStart, 'String', elec120_colAM);
        set(handles.menuColumnEnd, 'String', elec120_colAM);
    elseif col == 66 || col == 76
        set(handles.menuColumnStart, 'String', elec120_colBL);
        set(handles.menuColumnEnd, 'String', elec120_colBL);
    elseif col == 67 || col == 75
        set(handles.menuColumnStart, 'String', elec120_colCK);
        set(handles.menuColumnEnd, 'String', elec120_colCK);
    else
        set(handles.menuColumnStart, 'String', elec120);
        set(handles.menuColumnEnd, 'String', elec120);
    end
elseif MEAnum == 252
    if col == 65 || col == 82
        set(handles.menuColumnStart, 'String', elec256_colAR);
        set(handles.menuColumnEnd, 'String', elec256_colAR);
    else
        set(handles.menuColumnStart, 'String', elec256);
        set(handles.menuColumnEnd, 'String', elec256);
    end
end