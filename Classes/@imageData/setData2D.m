function result = setData2D(obj, type, slice, slice_no, orient, col_channel, custom_img, options)
% function slice = setData2D(obj, type, slice, slice_no, orient, col_channel, custom_img, options)
% set the 3D slice: height:width:colors to the dataset
%
% Parameters:
% type: type of the slice to set, 'image', 'model','mask', 'selection', 'custom' ('custom' indicates to use custom_img as the dataset), 'everything'('model','mask' and 'selection' for imageData.model_type==''uint6'' only)
% slice: 3D image. For the 'image' type: [1:height, 1:width, 1:colors]; for all other types: [1:height, 1:width]
% slice_no: [@em optional], an index of the slice to update, when @em NaN updates the current slice
% orient: [@em optional], can be @em NaN 
% @li when @b 0 (@b default) updates the dataset transposed from the current orientation (obj.orientation)
% @li when @b 1 returns transposed dataset from the zx configuration: [x,z,c,y,t] -> [y,x,c,z,t]
% @li when @b 2 returns transposed dataset from the zy configuration: [y,z,c,y,t] -> [y,x,c,z,t]
% @li when @b 3 not used
% @li when @b 4 returns original dataset from the yx configuration: [y,x,c,z,t]
% @li when @b 5 not used
% col_channel: [@em optional], can be @e NaN
% @li when @b type is 'image', col_channel is a vector with color numbers to take, when @b NaN [@e default] take the colors
% selected in the imageData.slices{3} variable, when @b 0 - take all colors of the dataset.
% @li when @b type is 'model' col_channel may be @em NaN - to take all materials of the model or an integer to take specific material. In the later case the selected material in @b slice will have index = 1.
% custom_img: [@em optional], can be @e NaN; the function return a slice not from the imageData class but from this custom_img, requires to
% specify the 'custom' @b type. 'custom_img' should be a 3D dataset.
% options: [@em optional], a structure with extra parameters
% @li .blockModeSwitch -> override the imageData.blockModeSwitch (@b 0 - update the full dataset, @b 1 - update only the shown part)
% @li .y -> [@em optional], [ymin, ymax] of the part of the slice to set
% @li .x -> [@em optional], [xmin, xmax] of the part of the slice to set
% @li .t -> [@em optional], [tmin, tmax] indicate the time point to set, when missing return the currently selected time point
%
% Return values:
% slice: 3D image. For the 'image' type: [1:height, 1:width, 1:colors]; for all other types: [1:height, 1:width]

%| 
% @b Examples:
% @code slice = handles.Img{handles.Id}.I.setData2D('image', slice, 5);      // set the 5-th slice of the current stack orientation  @endcode
% @code slice = handles.Img{handles.Id}.I.setData2D('image', slice, 5, 4, 2); // set the 5-th slice of the XY-orientation, color channel=2 @endcode
% @code slice = handles.Img{handles.Id}.I.setData2D('custom', slice, 5, 1, 2, custom_img); // set the 5-th slice of the YZ-orientation, color channel=2 from the custom_image @endcode
% @code slice = obj.setData2D(img, 'image', slice, 5);      // Call within the class; set the 5-th slice of the current stack orientation  @endcode
% @attention @b sensitive to the @code imageData.blockModeSwitch @endcode
% @attention @b not @b sensitive to the shown ROI
% @attention for normal calls it is recommended to use ib_getSlice.m wrapper function, as @code
% slice = ib_getSlice('image', handles); @endcode

% Copyright (C) 03.09.2015, Ilya Belevich, University of Helsinki (ilya.belevich @ helsinki.fi)
% 
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
%
% Updates
% 18.01.2016, changed .slices() to .slices{:}; .slicesColor->.slices{3}


if nargin < 8; options = struct();   end;
if nargin < 7; custom_img = NaN;   end;
if nargin < 6; col_channel = NaN;   end;
if nargin < 5; orient = NaN; end;
if nargin < 4; slice_no = NaN; end;

if orient == 0 || isnan(orient); orient=obj.orientation; end;
if isnan(slice_no); slice_no=obj.slices{orient}(1); end;

if strcmp(type,'image')
    if isnan(col_channel); col_channel=obj.slices{3}; end;
    if col_channel(1) == 0;  col_channel = 1:size(obj.img,3); end;
end

optionsOut.z = [slice_no slice_no];
if isfield(options, 'x')
    optionsOut.x = options.x;
end
if isfield(options, 'y')
    optionsOut.y = options.y;
end
if isfield(options, 't')
    optionsOut.t = options.t;
else
   optionsOut.t = [obj.slices{5}(1), obj.slices{5}(2)];
end
if isfield(options, 'blockModeSwitch')
    optionsOut.blockModeSwitch = options.blockModeSwitch;
end

result = obj.setData4D(type, slice, orient, col_channel, optionsOut);
end