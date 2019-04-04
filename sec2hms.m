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

% --- Converts value in seconds to string of hours, minutes, and seconds

function hms = sec2hms(t)

% Calculate hours, minutes, seconds
hrs = floor(t/3600);
t = t - hrs*3600;
mins = floor(t/60);
t = t - mins*60;
secs = t;

% Hours
if hrs > 0
    hstr = sprintf('%d h ', hrs);
else
    hstr = '';
end
% Minutes
if mins > 0
    mstr = sprintf('%d m ', mins);
else
    mstr = '';
end
% Seconds
if secs > 0
    sstr = sprintf('%.3g s ', secs);
else
    sstr = '';
end

% Combine hms strings
hms = [hstr mstr sstr];