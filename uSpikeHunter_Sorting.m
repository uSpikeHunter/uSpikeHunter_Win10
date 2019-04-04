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

function varargout = uSpikeHunter_Sorting(varargin)
% USPIKEHUNTER_SORTING MATLAB code for uSpikeHunter_Sorting.fig
%      USPIKEHUNTER_SORTING, by itself, creates a new USPIKEHUNTER_SORTING or raises the existing
%      singleton*.
%
%      H = USPIKEHUNTER_SORTING returns the handle to a new USPIKEHUNTER_SORTING or the handle to
%      the existing singleton*.
%
%      USPIKEHUNTER_SORTING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in USPIKEHUNTER_SORTING.M with the given input arguments.
%
%      USPIKEHUNTER_SORTING('Property','Value',...) creates a new USPIKEHUNTER_SORTING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before uSpikeHunter_Sorting_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to uSpikeHunter_Sorting_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help uSpikeHunter_Sorting

% Last Modified by GUIDE v2.5 30-Apr-2018 13:39:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uSpikeHunter_Sorting_OpeningFcn, ...
                   'gui_OutputFcn',  @uSpikeHunter_Sorting_OutputFcn, ...
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


% --- Executes just before uSpikeHunter_Sorting is made visible.
function uSpikeHunter_Sorting_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to uSpikeHunter_Sorting (see VARARGIN)

% Choose default command line output for uSpikeHunter_Sorting
handles.output = hObject;

% Get main handles as input and convert to current GUI handles variable
handles = main2sorting(hObject, eventdata, handles);

% Initialize has sorted and close attempt to 0
handles.hasSorted = 0;

% Create array of subplots
handles = subplotArray(hObject, eventdata, handles);

% Plot all events on each electrode
handles = plotSpikes(hObject, eventdata, handles);

% Store sorting GUI in root
sortingFig = gcf();
sortingHandles = guidata(sortingFig);
setappdata(0, 'sortingHandles', sortingHandles);

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = uSpikeHunter_Sorting_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnGrp1ROI1.
function btnGrp1ROI1_Callback(hObject, eventdata, handles)
% hObject    handle to btnGrp1ROI1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set indices for ROI creation
handles.grp = 1;
handles.reg = 1;

% User draws ROI
handles = drawROI(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnGrp1ROI2.
function btnGrp1ROI2_Callback(hObject, eventdata, handles)
% hObject    handle to btnGrp1ROI2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set indices for ROI creation
handles.grp = 1;
handles.reg = 2;

% User draws ROI
handles = drawROI(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnGrp2ROI1.
function btnGrp2ROI1_Callback(hObject, eventdata, handles)
% hObject    handle to btnGrp2ROI1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set indices for ROI creation
handles.grp = 2;
handles.reg = 1;

% User draws ROI
handles = drawROI(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnGrp2ROI2.
function btnGrp2ROI2_Callback(hObject, eventdata, handles)
% hObject    handle to btnGrp2ROI2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set indices for ROI creation
handles.grp = 2;
handles.reg = 2;

% User draws ROI
handles = drawROI(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnGrp3ROI1.
function btnGrp3ROI1_Callback(hObject, eventdata, handles)
% hObject    handle to btnGrp3ROI1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set indices for ROI creation
handles.grp = 3;
handles.reg = 1;

% User draws ROI
handles = drawROI(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnGrp3ROI2.
function btnGrp3ROI2_Callback(hObject, eventdata, handles)
% hObject    handle to btnGrp3ROI2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set indices for ROI creation
handles.grp = 3;
handles.reg = 2;

% User draws ROI
handles = drawROI(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnGrp4ROI1.
function btnGrp4ROI1_Callback(hObject, eventdata, handles)
% hObject    handle to btnGrp4ROI1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set indices for ROI creation
handles.grp = 4;
handles.reg = 1;

% User draws ROI
handles = drawROI(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnGrp4ROI2.
function btnGrp4ROI2_Callback(hObject, eventdata, handles)
% hObject    handle to btnGrp4ROI2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set indices for ROI creation
handles.grp = 4;
handles.reg = 2;

% User draws ROI
handles = drawROI(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnSort.
function btnSort_Callback(hObject, eventdata, handles)
% hObject    handle to btnSort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Populate drop-down menu
handles = PVelectrodes(hObject, eventdata, handles);

% Sort spikes, plot, and update spike table
handles = plotSpikesSorted(hObject, eventdata, handles);
handles = spikeRealign(hObject, eventdata, handles);
handles = spikeTable(hObject, eventdata, handles);

% Enable sorted objects and populate drop-down menu
handles = sortEnable(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnReturn.
function btnReturn_Callback(hObject, eventdata, handles)
% hObject    handle to btnReturn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Move necessary variables into structure for transfer back to main GUI

% Update events list in main GUI
eventsUpdate(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % Set sorting GUI open to zero
% mainHandles = getappdata(0, 'mainHandles');
% mainHandles.sortingGUIopen = 1;
% setappdata(0, 'mainHandles', mainHandles);

% Update main GUI before deleting figure
if handles.hasSorted == 1
    eventsUpdate(hObject, eventdata, handles);
end

% Get main GUI handles structure from root
mainHandles = getappdata(0, 'mainHandles');
% Set sorting GUI open to 0
mainHandles.sortingGUIopen = 0;
% Update main handles structure
setappdata(0, 'mainHandles', mainHandles);

% Delete figure object
delete(hObject);


% --- Executes on selection change in menuPair.
function menuPair_Callback(hObject, eventdata, handles)
% hObject    handle to menuPair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menuPair contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menuPair



% --- Executes during object creation, after setting all properties.
function menuPair_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menuPair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnPV.
function btnPV_Callback(hObject, eventdata, handles)
% hObject    handle to btnPV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Recalculate PV based on selected electrodes and update table
handles = spikeTable(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnSaveSort.
function btnSaveSort_Callback(hObject, eventdata, handles)
% hObject    handle to btnSaveSort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Save sorted data
saveSorted(handles);

% Update handles structure
guidata(hObject, handles);
