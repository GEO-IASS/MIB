function menuDatasetTransform(hObject, eventdata, handles, mode)
% function menuDatasetTransform(hObject, eventdata, handles, mode)
% a callback to Menu->Dataset->Transform...
% do different transformation with the dataset
%
% Parameters:
% hObject: handle to im_browser.m (see GCBO)
% eventdata: eventdata structure 
% handles: structure with handles of im_browser.m
% mode: a string with a transormation mode:
% @li 'flipH', flip the dataset horizontally
% @li 'flipV', flip the dataset vertically
% @li 'flipZ', flip the Z-stacks of the dataset
% @li 'flipT', flip the time vector of the dataset
% @li 'rot90', rotate dataset 90 degrees clockwise 
% @li 'rot-90', rotate dataset 90 degrees counterclockwise 
% @li 'xy2zx', transpose the dataset so that YX->XZ
% @li 'xy2zy', transpose the dataset so that YX->YZ
% @li 'zx2zy', transpose the dataset so that XZ->YZ

% Copyright (C) 14.05.2014, Ilya Belevich, University of Helsinki (ilya.belevich @ helsinki.fi)
% part of Microscopy Image Browser, http:\\mib.helsinki.fi 
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
%
% Updates
% 04.02.2016, IB, added the flipT mode


switch mode
    case {'flipH', 'flipV','flipZ','flipT'}
        handles = ib_flipDataset(handles, mode);
    case {'rot90', 'rot-90'}
        handles = ib_rotateDataset(handles, mode);
    case {'xy2zx', 'xy2zy','zx2zy','z2t'}
        handles = ib_transposeDataset(handles, mode);
end

handles = handles.Img{handles.Id}.I.updateAxesLimits(handles, 'resize');
% update widgets in the im_browser GUI
handles = updateGuiWidgets(handles);
handles.Img{handles.Id}.I.plotImage(handles.imageAxes, handles, 1);
end