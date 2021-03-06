function varargout = mib_MaskStatsProps(varargin)
% MIB_MASKSTATSPROPS MATLAB code for mib_MaskStatsProps.fig
%      MIB_MASKSTATSPROPS, by itself, creates a new MIB_MASKSTATSPROPS or raises the existing
%      singleton*.
%
%      H = MIB_MASKSTATSPROPS returns the handle to a new MIB_MASKSTATSPROPS or the handle to
%      the existing singleton*.
%
%      MIB_MASKSTATSPROPS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MIB_MASKSTATSPROPS.M with the given input arguments.
%
%      MIB_MASKSTATSPROPS('Property','Value',...) creates a new MIB_MASKSTATSPROPS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mib_MaskStatsProps_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mib_MaskStatsProps_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright (C) 01.06.2015 Ilya Belevich, University of Helsinki (ilya.belevich @ helsinki.fi)
% part of Microscopy Image Browser, http:\\mib.helsinki.fi 
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
%
% Updates
% 

% Last Modified by GUIDE v2.5 01-Jun-2015 20:45:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mib_MaskStatsProps_OpeningFcn, ...
                   'gui_OutputFcn',  @mib_MaskStatsProps_OutputFcn, ...
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
end

% --- Executes just before mib_MaskStatsProps is made visible.
function mib_MaskStatsProps_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mib_MaskStatsProps (see VARARGIN)

% Choose default command line output for mib_MaskStatsProps
handles.output = varargin{1};   % parameters that should be calculated
handles.properties = varargin{1};   % parameters that should be calculated
handles.obj3d = varargin{2};    % switch to define 3D or 2D objects

if handles.obj3d
    parent = get(handles.shape2dPanel, 'parent');
    set(handles.shape3dPanel, 'parent', parent);
    pos = get(handles.shape2dPanel, 'position');
    set(handles.shape3dPanel, 'position', pos);
    set(handles.shape2dPanel, 'visible', 'off');
    set(handles.shape3dPanel, 'visible', 'on');
end

pos = get(handles.mib_MaskStatsProps, 'position');
pos(3) = 330;
set(handles.mib_MaskStatsProps, 'position', pos);

% rescale widgets for Mac and Linux
mib_rescaleWidgets(handles.mib_MaskStatsProps);

% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

% Make the GUI modal
set(handles.mib_MaskStatsProps,'WindowStyle','modal')

% Update handles structure
guidata(hObject, handles);

updateWidgets(handles);

% UIWAIT makes mib_MaskStatsProps wait for user response (see UIRESUME)
uiwait(handles.mib_MaskStatsProps);
end

% --- Outputs from this function are returned to the command line.
function varargout = mib_MaskStatsProps_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
delete(handles. mib_MaskStatsProps);
end

% --- Executes on button press in cancelBtn.
function cancelBtn_Callback(hObject, eventdata, handles)
handles.output = {};

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.mib_MaskStatsProps);

end

% --- Executes when user attempts to close mib_MaskStatsProps.
function mib_MaskStatsProps_CloseRequestFcn(hObject, eventdata, handles)
handles.output = {};
if isfield(handles, 'mib_MaskStatsProps')
    guidata(handles.mib_MaskStatsProps, handles);
    uiresume(hObject);
else
    delete(hObject);
end

end

% --- Executes on button press in checkallBtn.
function checkallBtn_Callback(hObject, eventdata, handles)
excludeList = {'CurveLengthInPixels','CurveLengthInUnits','EndpointsLength','EndpointsLength3d','Correlation'};
if handles.obj3d == 1
    list = findall(handles.mib_MaskStatsProps, 'parent', handles.shape3dPanel,'style','checkbox');
    for i=1:numel(list)
        if sum(ismember(get(list(i),'tag'), excludeList)) == 0
            set(list(i),'value', 1);
        end
    end
else
    list = findall(handles.mib_MaskStatsProps, 'parent', handles.shape2dPanel,'style','checkbox');
    for i=1:numel(list)
        if sum(ismember(get(list(i),'tag'), excludeList)) == 0
            set(list(i),'value', 1);
        end
    end
end
list = findall(handles.mib_MaskStatsProps, 'parent', handles.intensityPanel,'style','checkbox');
for i=1:numel(list)
    if sum(ismember(get(list(i),'tag'), excludeList)) == 0
        set(list(i),'value', 1);
    end
end
end


% --- Executes on button press in uncheckBtn.
function uncheckBtn_Callback(hObject, eventdata, handles)
list = findall(handles.mib_MaskStatsProps, 'parent', handles.shape3dPanel,'style','checkbox');
set(list,'value', 0);
list = findall(handles.mib_MaskStatsProps, 'parent', handles.shape2dPanel,'style','checkbox');
set(list,'value', 0);
list = findall(handles.mib_MaskStatsProps, 'parent', handles.intensityPanel,'style','checkbox');
set(list,'value', 0);
end

function updateWidgets(handles)
% select defined checkboxes
properties = handles.properties;
if handles.obj3d == 1       % add 3d to the end of each property
    for i = 1:numel(properties)
        if ~ismember(properties(i),{'Correlation','MinIntensity','MaxIntensity','MeanIntensity','SumIntensity','StdIntensity'})
            properties{i} = [properties{i} '3d'];
        end
    end
end

if sum(ismember(properties, 'HolesArea')) > 0
   properties(ismember(properties, 'HolesArea')) = [];
end

for i = 1:numel(properties)
    set(handles.(properties{i}), 'value', 1);
end
end

% --- Executes on button press in okBtn.
function okBtn_Callback(hObject, eventdata, handles)
index = 1;
if handles.obj3d == 1
    list = findall(handles.mib_MaskStatsProps, 'parent', handles.shape3dPanel,'style','checkbox');
    for i=1:numel(list)
        if get(list(i),'value') == 1
            tagStr = get(list(i),'tag');
            properties{index} = tagStr(1:end-2);    % remove 3d from the end of the tag
            index = index + 1;
        end
    end
else
    list = findall(handles.mib_MaskStatsProps, 'parent', handles.shape2dPanel,'style','checkbox');
    for i=1:numel(list)
        if get(list(i),'value') == 1
            properties{index} = get(list(i),'tag');
            index = index + 1;
        end
    end

end
list = findall(handles.mib_MaskStatsProps, 'parent', handles.intensityPanel,'style','checkbox');
for i=1:numel(list)
    if get(list(i),'value') == 1
        properties{index} = get(list(i),'tag');
        index = index + 1;
    end
end
if exist('properties', 'var')
    handles.output = properties;
    guidata(handles.mib_MaskStatsProps, handles);
end
uiresume(handles.mib_MaskStatsProps);
end
