function [ output_args ] = multiSlice( img )
%multiSlice - arrange serial slices for visualisation and customisation,
%eventually...

% James McKenzie, Imperial College, London, 2014.

% Define the slice numbers which you want drawn in here
sl = [1:3:26]

% Default view angle
vw = [81 36];

% Close existing
f0 = findobj('Name','multiSlice');
close(f0);


% Transpose the image so that z is now along the x axis... (actually y when
% the images are drawn, but it works so all is fine).
img = permute(img,[3 1 2]);

% Get the grids
[x,y,z] = defSize(img,1);


% These functions actually draw the images
imgSlice(x,y,z,img,sl,vw)
globalSlice(x,y,z,img,sl,vw)

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fig] = drawWindow
% Draw the window

% Window
fig.fig = figure('Name','multiSlice',...
    'Units','normalized',...
    'Position',[0.25 0.25 0.5 0.5],...
    'Toolbar','figure',...
    'Menubar','none');

% Axes
fig.ax = axes('Parent',fig.fig,...
    'Units','normalized',...
    'Position',[0.05 0.05 0.9 0.9]);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function imgSlice(x,y,z,img,sl,vw)
% Draw the main image with a series of slices using classification images

% Draw a window...
drawWindow;

% Actually the slices here
h = slice(x,y,z,img,[],sl,[]);

% Modify colours / transparencies
set(h,'EdgeColor','none',...
    'FaceColor','interp',...
    'FaceAlpha','interp');

% Define various operations for transparency
alpha('color');
fa = get(gcf,'Alphamap');
fa(1:11) = [0:0.1:1];
fa(12:end) = 1;
fa = fliplr(fa);
set(gcf,'Alphamap',fa);
alphamap('increase',0.1)

% Set a colourmap to show nice colours rather than horrible ones
colormap([0 0 0; 1 0 0; 0 0 1; 0 1 0]);

% Few final options
axis tight
grid off
box off;
view(vw);

% Save image...
printImage('Image1','png')

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function globalSlice(x,y,z,img,sl,vw)

% Now how about a full volumetric thing
drawWindow;
hold on;

isoVal = 3;
imgLog = double(img == isoVal);
isoVal = 0;

% Surfaces
iso = isosurface(x,y,z,imgLog,isoVal,y);

pp = patch(iso);
set(pp,...
    'FaceColor','interp',...
    'EdgeColor','none',...
    'FaceAlpha',0.5);

h2 = slice(x,y,z,double(imgLog == -1),[],sl,[]);
set(h2,'EdgeColor','none',...
    'FaceColor','black',...
    'FaceAlpha',0.5);

axis tight;
box off;
axis off
view(vw);

graphFormat('Image2','png');


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%