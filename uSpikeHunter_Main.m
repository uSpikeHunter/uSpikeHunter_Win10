% ----------------------------------------------------------------------- %
%                              µSpikeHunter                               %
%                                                                         %
% Copyright (C) 2018  Kristine Heiney & Paulo Aguiar*                     %
% NCN - Neuroengineering and Computational Neuroscience Lab               %
% https://www.i3s.up.pt/content/research-group-detail?x=125               %
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

function varargout = uSpikeHunter_Main(varargin)
% USPIKEHUNTER_MAIN MATLAB code for uSpikeHunter_Main.fig
%      USPIKEHUNTER_MAIN, by itself, creates a new USPIKEHUNTER_MAIN or raises the existing
%      singleton*.
%
%      H = USPIKEHUNTER_MAIN returns the handle to a new USPIKEHUNTER_MAIN or the handle to
%      the existing singleton*.
%
%      USPIKEHUNTER_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in USPIKEHUNTER_MAIN.M with the given input arguments.
%
%      USPIKEHUNTER_MAIN('Property','Value',...) creates a new USPIKEHUNTER_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before uSpikeHunter_Main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to uSpikeHunter_Main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help uSpikeHunter_Main

% Last Modified by GUIDE v2.5 30-Apr-2018 13:39:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uSpikeHunter_Main_OpeningFcn, ...
                   'gui_OutputFcn',  @uSpikeHunter_Main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before uSpikeHunter_Main is made visible.
function uSpikeHunter_Main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to uSpikeHunter_Main (see VARARGIN)

% Choose default command line output for uSpikeHunter_Main
handles.output = hObject;

% Initialize
handles.isPlayer = 0;
handles.isLine = 0;
handles.sortingGUIopen = 0;
setappdata(0, 'mainHandles', handles);
set(handles.btnBrowse, 'Enable', 'off');
set(handles.edtFile, 'String', '');
handles = clearGUI(hObject, eventdata, handles, 1);

% Message box
uiwait(msgbox({'Thank you for your interest in uSpikeHunter.';'';'If uSpikeHunter is important for your research please cite our work:';'';'https://www.nature.com/articles/s41598-019-42148-3';'';'uSpikeHunter was developed by Kristine Heiney and Paulo Aguiar, Neuroengineering and Computational Neuroscience Lab @ INEB/i3S Apr 2019.';'For questions, comments, or bug reports, please send an email to: pauloaguiar@ineb.up.pt'}));

% Enable browse button
set(handles.btnBrowse, 'Enable', 'on');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes uSpikeHunter_Main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = uSpikeHunter_Main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function edtFile_Callback(hObject, eventdata, handles)
% hObject    handle to edtFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtFile as text
%        str2double(get(hObject,'String')) returns contents of edtFile as a double


% --- Executes during object creation, after setting all properties.
function edtFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnBrowse.
function btnBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Clear everything
handles = clearGUI(hObject, eventdata, handles, 1);
set(handles.edtFile, 'String', '');
set(handles.btnRead, 'Enable', 'off');

% Select data file
[handles.filename,handles.pathname] = uigetfile({'*.h5';'*.csv';'*.txt';'*.dat'});
handles.file = fullfile(handles.pathname, handles.filename);
set(handles.edtFile, 'String', handles.filename);

% Enable file info button
if isequal(handles.filename, 0)
    set(handles.btnList, 'Enable', 'off');
else
    set(handles.btnList, 'Enable', 'on');
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnRead.
function btnRead_Callback(hObject, eventdata, handles)
% hObject    handle to btnRead (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Clear analysis pane
clearGUI(hObject, eventdata, handles, 3);

% Disable read button
set(handles.btnRead, 'Enable', 'off');
guidata(hObject, handles);

% Message box
waitbox = msgbox('Reading data. This may take a minute.', 'Please wait');

% See if custom or MCS: Get filename from text box and see if .h5
filename = get(handles.edtFile, 'String');
if contains(filename, '.h5')
    handles = read_hdf5(hObject, eventdata, handles);
else
    handles = read_custom(hObject, eventdata, handles);
end

% Put parameters into handles
% Interelectrode distance (µm)
handles.intEDist = str2double(get(handles.edtIntEDist, 'String'));
% Interelectrode spacing (m)
handles.eSpacing = handles.intEDist*1e-6;
% Number of electrodes
handles.numElectrodes = length(get(handles.menuEventElectrode, 'String'));

% Run event detector, create event names, and populate events list with
% event names
handles = seqDetector(hObject, eventdata, handles);

% Create base filename and basic header text for files to save
[handles.baseFilename, handles.headerText] = saveFilename(handles);

% Close box if user hasn't
if exist('waitbox', 'var')
	delete(waitbox);
	clear('waitbox');
end

% Enable and disable objects
readEnDis(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in listEvents.
function listEvents_Callback(hObject, eventdata, handles)
% hObject    handle to listEvents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listEvents contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listEvents

handles = eventChange(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function listEvents_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listEvents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listDatasets.
function listDatasets_Callback(hObject, eventdata, handles)
% hObject    handle to listDatasets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listDatasets contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listDatasets

handles = clearGUI(hObject, eventdata, handles, 3);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function listDatasets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listDatasets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnList.
function btnList_Callback(hObject, eventdata, handles)
% hObject    handle to btnList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Clear everything
handles = clearGUI(hObject, eventdata, handles, 1);

% See if custom or MCS: Get filename from text box and see if .h5
file = get(handles.edtFile, 'String');
if contains(file, '.h5')
    handles = info_hdf5(hObject, eventdata, handles);
else
    handles = info_custom(hObject, eventdata, handles);
end

% Enable and disable objects
infoEnDis(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in menuRow.
function menuRow_Callback(hObject, eventdata, handles)
% hObject    handle to menuRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menuRow contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menuRow

menuRow(hObject, eventdata, handles);
% Enable/disable read button
btnReadOnOff(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menuRow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menuRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menuColumn.
function menuColumn_Callback(hObject, eventdata, handles)
% hObject    handle to menuColumn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menuColumn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menuColumn

menuColumn(hObject, eventdata, handles);
% Enable/disable read button
btnReadOnOff(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menuColumn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menuColumn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menuRowStart.
function menuRowStart_Callback(hObject, eventdata, handles)
% hObject    handle to menuRowStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menuRowStart contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menuRowStart

% Clear data pane
handles = clearGUI(hObject, eventdata, handles, 3);
% Enable/disable read button
btnReadOnOff(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menuRowStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menuRowStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menuRowEnd.
function menuRowEnd_Callback(hObject, eventdata, handles)
% hObject    handle to menuRowEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menuRowEnd contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menuRowEnd

% Clear data pane
handles = clearGUI(hObject, eventdata, handles, 3);
% Enable/disable read button
btnReadOnOff(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menuRowEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menuRowEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menuColumnStart.
function menuColumnStart_Callback(hObject, eventdata, handles)
% hObject    handle to menuColumnStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menuColumnStart contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menuColumnStart

% Clear data pane
handles = clearGUI(hObject, eventdata, handles, 3);
% Enable/disable read button
btnReadOnOff(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menuColumnStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menuColumnStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menuColumnEnd.
function menuColumnEnd_Callback(hObject, eventdata, handles)
% hObject    handle to menuColumnEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menuColumnEnd contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menuColumnEnd

% Clear data pane
handles = clearGUI(hObject, eventdata, handles, 3);
% Enable/disable read button
btnReadOnOff(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menuColumnEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menuColumnEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in btnsRowColumn.
function btnsRowColumn_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in btnsRowColumn 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

rowcolumn(hObject, eventdata, handles);
% Enable/disable read button
btnReadOnOff(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in menuHighlight.
function menuHighlight_Callback(hObject, eventdata, handles)
% hObject    handle to menuHighlight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menuHighlight contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menuHighlight

handles = eventChange(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menuHighlight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menuHighlight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menuEventElectrode.
function menuEventElectrode_Callback(hObject, eventdata, handles)
% hObject    handle to menuEventElectrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menuEventElectrode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menuEventElectrode

handles = electrodeChange(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menuEventElectrode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menuEventElectrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnClearData.
function btnClearData_Callback(hObject, eventdata, handles)
% hObject    handle to btnClearData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = clearGUI(hObject, eventdata, handles, 3);

% Update handles structure
guidata(hObject, handles);


function edtNsig_Callback(hObject, eventdata, handles)
% hObject    handle to edtNsig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtNsig as text
%        str2double(get(hObject,'String')) returns contents of edtNsig as a double

handles = clearGUI(hObject, eventdata, handles, 3);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edtNsig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtNsig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menuStartTime.
function menuStartTime_Callback(hObject, eventdata, handles)
% hObject    handle to menuStartTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menuStartTime contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menuStartTime

handles = startTime(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menuStartTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menuStartTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menuDur.
function menuDur_Callback(hObject, eventdata, handles)
% hObject    handle to menuDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menuDur contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menuDur

% Clear data analysis pane
handles = clearGUI(hObject, eventdata, handles, 3);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menuDur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menuDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSaveAll.
function btnSaveAll_Callback(hObject, eventdata, handles)
% hObject    handle to btnSaveAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Save times and amplitudes for each propagation unit
saveAllEvents(handles);


% --- Executes on button press in btnSaveEvent.
function btnSaveEvent_Callback(hObject, eventdata, handles)
% hObject    handle to btnSaveEvent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Save traces over plotting time window for current selected event
saveEvent(handles);


% --- Executes on button press in btnSaveData.
function btnSaveData_Callback(hObject, eventdata, handles)
% hObject    handle to btnSaveData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Save voltage traces and time in .csv file
saveData(handles)


% --- Executes on selection change in menuXCorr.
function menuXCorr_Callback(hObject, eventdata, handles)
% hObject    handle to menuXCorr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menuXCorr contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menuXCorr

handles = eventChange(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menuXCorr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menuXCorr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menuXCorrPV.
function menuXCorrPV_Callback(hObject, eventdata, handles)
% hObject    handle to menuXCorrPV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menuXCorrPV contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menuXCorrPV

handles = SPVcalculation(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menuXCorrPV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menuXCorrPV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edtIntEDist_Callback(hObject, eventdata, handles)
% hObject    handle to edtIntEDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtIntEDist as text
%        str2double(get(hObject,'String')) returns contents of edtIntEDist as a double

% Clear data analysis pane
handles = clearGUI(hObject, eventdata, handles, 3);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edtIntEDist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtIntEDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnLine.
function btnLine_Callback(hObject, eventdata, handles)
% hObject    handle to btnLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = kymoPV(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnStartSound.
function btnStartSound_Callback(hObject, eventdata, handles)
% hObject    handle to btnStartSound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Resample, reverb, different functions of signal
% Resampling factor of 80, audio sampling frequency of 2000 gives nice
% sound for 20 kHz file

handles = startAudio(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnPause.
function btnPause_Callback(hObject, eventdata, handles)
% hObject    handle to btnPause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pause(handles.player);
set(handles.btnPause, 'Enable', 'off');
set(handles.btnResume, 'Enable', 'on');

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnStop.
function btnStop_Callback(hObject, eventdata, handles)
% hObject    handle to btnStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = stopPlayback(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnResume.
function btnResume_Callback(hObject, eventdata, handles)
% hObject    handle to btnResume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

resume(handles.player);
set(handles.btnPause, 'Enable', 'on');
set(handles.btnResume, 'Enable', 'off');

% Update handles structure
guidata(hObject, handles);


function edtSoundStart_Callback(hObject, eventdata, handles)
% hObject    handle to edtSoundStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtSoundStart as text
%        str2double(get(hObject,'String')) returns contents of edtSoundStart as a double


% --- Executes during object creation, after setting all properties.
function edtSoundStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtSoundStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in btnsEventDetector.
function btnsEventDetector_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in btnsEventDetector 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Clear data analysis pane
handles = clearGUI(hObject, eventdata, handles, 3);

% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in menuChord.
function menuChord_Callback(hObject, eventdata, handles)
% hObject    handle to menuChord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menuChord contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menuChord


% --- Executes during object creation, after setting all properties.
function menuChord_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menuChord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSpikeOverlay.
function btnSpikeOverlay_Callback(hObject, eventdata, handles)
% hObject    handle to btnSpikeOverlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Store main GUI in root
mainFig = gcf();
mainHandles = guidata(mainFig);
setappdata(0, 'mainHandles', mainHandles);

% Call new GUI
uSpikeHunter_Sorting();
mainHandles.sortingGUIopen = 1;
setappdata(0, 'mainHandles', mainHandles);

% Update handles structure
guidata(hObject, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% If spike sorting GUI is open, close it
mainHandles = getappdata(0, 'mainHandles');
sortingHandles = getappdata(0, 'sortingHandles');
if mainHandles.sortingGUIopen == 1
    close(sortingHandles.figure1);
end

% Close main GUI
delete(hObject);
