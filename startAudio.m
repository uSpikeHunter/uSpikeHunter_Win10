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

% --- Start audio playback

function handles = startAudio(hObject, eventdata, handles)

% Get variables from handles
volt = handles.volt;
rate = handles.rate*1e3;    % Hz

% Enable playback buttons, disable initializing objects
set(handles.btnPause, 'Enable', 'on');
set(handles.btnStop, 'Enable', 'on');
set(handles.btnStartSound, 'Enable', 'off');
set(handles.edtSoundStart, 'Enable', 'off');
set(handles.edtSoundStart, 'FontWeight', 'bold');
set(handles.menuChord, 'Enable', 'off');

% Parameters
audioDur = 1;       % s
periodRec = 1e-3;   % s
% Audio sampling frequency and sampling interval
Fs = 2000;              % Hz
handles.Fs = Fs;
Ts = 1/Fs;              % s
numElectrodes = handles.numElectrodes;
% Resampling rate coefficient
cResamp = 500;

% Playback start time
audioStartTime = str2double(get(handles.edtSoundStart, 'String'));
audioStartTime = round(audioStartTime, 3);
file = get(handles.edtFile, 'String');
if contains(file, '.h5')
    contents = cellstr(get(handles.menuStartTime,'String'));
    readStart = str2double(contents{get(handles.menuStartTime, 'Value')});
    contents = cellstr(get(handles.menuDur,'String'));
    readEnd = readStart + str2double(contents{get(handles.menuDur, 'Value')});
else
    readStart = handles.time(1);
    readEnd = handles.time(length(handles.time));
end
if audioStartTime < readStart || audioStartTime >= readEnd
    audioStartTime = readStart;
    set(handles.edtSoundStart, 'String', audioStartTime);
end
if audioStartTime + audioDur > readEnd
    audioDur = readEnd - audioStartTime;
end
audioStart = floor((audioStartTime - readStart)*rate) + 1;
handles.audioStartTime = audioStartTime;

% Resampling rate
p = double(floor(cResamp*Fs/rate));
handles.p = p;
% Period for time display, number of samples to convert to audio, number
% of timer tasks
period = periodRec*rate*p/Fs;
numSamples = round(audioDur*rate);
audioEnd = audioStart + numSamples - 1;
numTasks = audioDur/periodRec + 1;
% Initialize playVolt array
sizePlayVolt = round(numSamples*p);
playVolt = zeros(1,sizePlayVolt);
% Time array for playback
endTime = double(numSamples*p - 1)*Ts;
T = 0:Ts:endTime;

% Frequencies of individual notes
C2 = 65.4064;   D2 = 73.4162;   Eb2 = 77.7817;  E2 = 82.4069;
F2 = 87.3071;   G2 = 97.9989;   Bb2 = 116.541;

C3 = 130.813;   Db3 = 138.591;  D3 = 146.832;   Eb3 = 155.563;
E3 = 164.814;   F3 = 174.614;   Fsh3 = 184.997; G3 = 195.998;
Bb3 = 233.082;  B3 = 246.942;

C4 = 261.626;   Db4 = 277.183;  D4 = 293.665;   Eb4 = 311.127;
E4 = 329.628;   F4 = 349.228;   Fsh4 = 369.994; G4 = 391.995;
Bb4 = 466.164;  B4 = 493.883;

C5 = 523.251;   Db5 = 554.365;  D5 = 587.330;   Eb5 = 622.254;
E5 = 659.255;   F5 = 698.456;   Fsh5 = 739.989; G5 = 783.991;
Bb5 = 932.328;  B5 = 987.767;

C6 = 1046.50;   D6 = 1174.66;   Eb6 = 1244.51;  E6 = 1318.51;
F6 = 1396.91;   G6 = 1567.98;   C7 = 2093.00;

% Get selected chord and define frequencies
contents = cellstr(get(handles.menuChord,'String'));
chord = string(contents{get(handles.menuChord, 'Value')});
% C
if strcmp(chord, 'C') == 1
    if numElectrodes <= 2
        freqs = [C4, G4];
    elseif numElectrodes <= 4
        freqs = [C4, E4, G4, C5];
    elseif numElectrodes <= 13
        freqs = [C3, E3, G3, C4, E4, G4, C5, E5, G5, C6, E6, G6, C7];
    else
        freqs = [C2, E2, G2, C3, E3, G3, C4, E4, G4, C5, E5, G5, ...
            C6, E6, G6, C7];
    end
% Cm
elseif strcmp(chord, 'Cm') == 1
    if numElectrodes <= 2
        freqs = [C4, G4];
    elseif numElectrodes <= 4
        freqs = [C4, Eb4, G4, C5];
    elseif numElectrodes <= 13
        freqs = [C3, Eb3, G3, C4, Eb4, G4, C5, Eb5, G5, C6, Eb6, G6, C7];
    else
        freqs = [C2, Eb2, G2, C3, Eb3, G3, C4, Eb4, G4, ...
            C5, Eb5, G5, C6, Eb6, G6, C7];
    end
% C2
elseif strcmp(chord, 'C2') == 1
    if numElectrodes <= 2
        freqs = [C4, G4];
    elseif numElectrodes <= 4
        freqs = [C4, D4, G4, C5];
    elseif numElectrodes <= 13
        freqs = [C3, D3, G3, C4, D4, G4, C5, D5, G5, C6, D6, G6, C7];
    else
        freqs = [C2, D2, G2, C3, D3, G3, C4, D4, G4, C5, D5, G5, ...
            C6, D6, G6, C7];
    end
% C4
elseif strcmp(chord, 'C4') == 1
    if numElectrodes <= 2
        freqs = [C4, G4];
    elseif numElectrodes <= 4
        freqs = [C4, F4, G4, C5];
    elseif numElectrodes <= 13
        freqs = [C3, F3, G3, C4, F4, G4, C5, F5, G5, C6, F6, G6, C7];
    else
        freqs = [C2, F2, G2, C3, F3, G3, C4, F4, G4, C5, F5, G5, ...
            C6, F6, G6, C7];
    end
% C7
elseif strcmp(chord, 'C7') == 1
    if numElectrodes <= 2
        freqs = [C4, G4];
    elseif numElectrodes <= 5
        freqs = [C4, E4, G4, Bb4, C5];
    elseif numElectrodes <= 13
        freqs = [C3, E3, G3, Bb3, C4, E4, G4, Bb4, C5, E5, G5, Bb5, C6];
    else
        freqs = [C2, E2, G2, Bb2, C3, E3, G3, Bb3, C4, E4, G4, Bb4, ...
            C5, E5, G5, Bb5, C6];
    end
% Cm7
elseif strcmp(chord, 'Cm7') == 1
    if numElectrodes <= 2
        freqs = [C4, G4];
    elseif numElectrodes <= 5
        freqs = [C4, Eb4, G4, Bb4, C5];
    elseif numElectrodes <= 13
        freqs = [C3, Eb3, G3, Bb3, C4, Eb4, G4, Bb4, C5, Eb5, G5, Bb5, C6];
    else
        freqs = [C2, Eb2, G2, Bb2, C3, Eb3, G3, Bb3, C4, Eb4, G4, Bb4, ...
            C5, Eb5, G5, Bb5, C6];
    end
% Cmaj7
elseif strcmp(chord, 'Cmaj7') == 1
    if numElectrodes <= 2
        freqs = [C4, G4];
    elseif numElectrodes <= 5
        freqs = [C4, E4, G4, B4, C5];
    elseif numElectrodes <= 13
        freqs = [C3, E3, G3, B3, C4, E4, G4, B4, C5, E5, G5, B5, C6];
    else
        freqs = [C2, E2, G2, B2, C3, E3, G3, B3, C4, E4, G4, B4, ...
            C5, E5, G5, B5, C6];
    end
% Nightmare
else
    if numElectrodes <= 5
        freqs = [C4, Db4, Fsh4, G4, C5];
    elseif numElectrodes <= 13
        freqs = [C3, Db3, Fsh3, G3, C4, Db4, Fsh4, G4, C5, Db5, Fsh5, G5, C6];
    else
        freqs = [C2, Db2, Fsh2, G2, C3, Db3, Fsh3, G3, C4, Db4, Fsh4, G4, ...
            C5, Db5, Fsh5, G5, C6];
    end
end

for n = 1:numElectrodes
    % Transpose of data for electrode n
    nPlayVolt = volt(audioStart:audioEnd,n).';
    % Expand array by resampling
    nPlayVolt = resample(nPlayVolt, p, 1);
    % Take square of signal
    nPlayVolt = abs(nPlayVolt).^(2.4);
    % Normalize signal
    nPlayVolt = (nPlayVolt - min(nPlayVolt))/(max(nPlayVolt) - min(nPlayVolt));
    % Convert signal to tone with frequency from above freqs array
    nPlayVolt = nPlayVolt.*sin(2*pi*freqs(n)*T);
    playVolt = playVolt + nPlayVolt;
end

% Add reverb
playVolt = playVolt.';
reverb = reverberator('DecayFactor', 1, 'WetDryMix', 0, 'HighFrequencyDamping', 1);
playVolt = reverb(playVolt);

% Create audio signal
handles.player = audioplayer(playVolt,Fs);
% Play signal
set(handles.txtTimer, 'String', 'Audio time (s)');
play(handles.player);
handles.isPlayer = 1;

% Display elapsed recording time
handles.timedisp = timer;
handles.timedisp.Period = period;
handles.timedisp.TasksToExecute = numTasks;
handles.timedisp.ExecutionMode = 'fixedRate';
handles.timedisp.TimerFcn = {@TimeDisplay, hObject, handles};
handles.timedisp.StopFcn = {@TimeEnd, hObject, eventdata, handles};
start(handles.timedisp);