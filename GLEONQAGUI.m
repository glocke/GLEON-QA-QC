function varargout = GLEONQAGUI(varargin)
% GLEONQAGUI M-file for GLEONQAGUI.fig
%      GLEONQAGUI, by itself, creates a new GLEONQAGUI or raises the existing
%      singleton*.
%
%      H = GLEONQAGUI returns the handle to a new GLEONQAGUI or the handle to
%      the existing singleton*.
%
%      GLEONQAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GLEONQAGUI.M with the given input arguments.
%
%      GLEONQAGUI('Property','Value',...) creates a new GLEONQAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GLEONQAGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GLEONQAGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GLEONQAGUI

% Last Modified by GUIDE v2.5 03-Aug-2010 13:42:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLEONQAGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GLEONQAGUI_OutputFcn, ...
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


% --- Executes just before GLEONQAGUI is made visible.
function GLEONQAGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLEONQAGUI (see VARARGIN)

% Choose default command line output for GLEONQAGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GLEONQAGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GLEONQAGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('GLEONQA has been stopped, program will finish parsing data from this minute.');
set(hObject,'Visible','off');

% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1
if get(hObject,'Value') == 1
    set(hObject,'String','Resume');
end
if get(hObject,'Value') == 0
    set(hObject,'String','Pause');
end
    