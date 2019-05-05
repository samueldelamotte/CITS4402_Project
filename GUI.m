function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 02-May-2019 00:42:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in selectDirButton.
function selectDirButton_Callback(hObject, eventdata, handles)
% hObject    handle to selectDirButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selectedDir imageSets;
[selectedDir, imageSets] = select_dataset();
handles.selectDirText.String = selectedDir;

set(handles.partitionButton,'visible','on');
set(handles.pText,'visible','on');
set(handles.pValue,'visible','on');
set(handles.iText,'visible','on');
set(handles.iValue,'visible','on');
set(handles.infoText,'visible','on');
set(handles.selectDirButton,'Enable','off');

% --- Executes on button press in partitionButton.
function partitionButton_Callback(hObject, eventdata, handles)
% hObject    handle to partitionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selectedDir imageSets datasetDir P I;
P = str2num(get(handles.pValue,'string'));
I = str2num(get(handles.iValue,'string'));
for iterations = 1:I
    [trainPath, testPath, datasetDir] = dataset_partition(iterations,selectedDir,imageSets,P);
end
set(handles.trainButton,'visible','on');
set(handles.partitionButton,'Enable','off');
set(handles.pValue,'Enable','off');
set(handles.iValue,'Enable','off');

% --- Executes on button press in trainButton.
function trainButton_Callback(hObject, eventdata, handles)
% hObject    handle to trainButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imageSets datasetDir P I;

for iterations = 1:I
    trainPath = fullfile(datasetDir,strcat('dataset',num2str(iterations)),'train');
    [X] = train_on_dataset(trainPath,imageSets, P);
    save(fullfile(datasetDir,strcat('dataset',num2str(iterations)),'ClassSpecificModel'),'X');
end

set(handles.trainText,'visible','on');
set(handles.autoTestButton,'visible','on');
set(handles.trainButton,'Enable','off');
%set(handles.userTestButton,'visible','on');

% --- Executes on button press in autoTestButton.
function autoTestButton_Callback(hObject, eventdata, handles)
% hObject    handle to autoTestButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imageSets datasetDir selectedDir P I;

result = "Below are the SuccessRates for each dataset permutation:";
set(handles.resultsText,'min',0,'max',2);
set(handles.resultsText,'visible','on');
set(handles.autoTestButton,'Enable','off');
set(handles.stopButton,'visible','on');
drawnow;

for iterations = 1:I
    load(fullfile(datasetDir,strcat('dataset',num2str(iterations)),'ClassSpecificModel'),'X');
    testPath = fullfile(datasetDir,strcat('dataset',num2str(iterations)),'test');
    [Solutions,Answers,Match,SuccessRate] = automated_test(X,selectedDir,testPath,imageSets, P, handles);
    SR = strcat("Dataset",num2str(iterations)," - ",fileread('resultsLog'));
    result = sprintf("%s\n\n%s",result,SR);
    set(handles.resultsText,'string',result);
    drawnow;
    delete resultsLog;
end
set(handles.stopButton,'visible','off');

% --- Executes on button press in userTestButton.
function userTestButton_Callback(hObject, eventdata, handles)
% hObject    handle to userTestButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
% hObject    handle to stopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all force;
codeDir = pwd;
cd ..\.;
rmdir Datasets s;
cd(codeDir);
warning('off','all')
delete resultsLog;