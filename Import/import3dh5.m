function [ h5 ] = import3dh5( fN )
%import3dh5 - import the 3D-Massomics 3D dataset in H5 format.
%   Import the 3D dataset provided as part of the Gigascience publication
%   (insert link here).
%
%   INPUT
%       fN : provide the location of the file (optional).
%   OUTPUT
%       h5 : a structure containing all the information from the H5 file
%       with the following fields:
%           h5.mz   - the m/z values
%           h5.data - structure containing optical & MS images, and zPos
%           h5.meta - {r x 2} cell containing name/value metadata pairs
%
%   This file will read in all of the data within the HDF5/H5 file, and may
%   therefore be rather large and memory consuming. Due to the excellent
%   indexing in H5 files, it may be more efficient to adapt this code to
%   read in only one slice at a time (to do...)
%
%   The optical image (h5.data(n).op) is an RGB image, i.e. [m,n,3]
%   This MS image (h5.data(n).x) is a 3D data matrix of size [p,q,r] where
%   r = numel(h5.mz).
%
%   James S. McKenzie, Imperial College, London. 2014.

warning('on','all');

% Get / check file
if nargin == 0
    [fN] = getFile;
else
    if ~exist(fN,'file')
        warning('Your file was not found. Pick another...');
        [fN] = getFile;
    end
end

% This won't work for any old h5 file
checkCorrect(fN);

% Create a structure in which to store the data
data = struct('op',[],'x',[],'zPos',[]);

% Add a waitbar to keep the customer satisfied
wb = waitbar(0,'Gathering necessary information','Name','import3dh5');

% Get the file information, and hence the attributes and sizes
info = h5info(fN);

% Parse attributes and get the number of slices
[att,numSlices] = parseAttributes(info);

% Read in the common elements (m/z values, metadata)
h5.mz = h5read(fN,'/mz');

% Now start to read in the file
for n = 1:numSlices
    
    % Generic name for this group (akin to a folder)
    name = ['/data/s' int2str(n) '/'];
    
    % This is the optical image
    data(n).op   = h5read(fN,[name 'op']);
    
    % This is the MS image
    data(n).x    = h5read(fN,[name 'x']);
    
    % This is the z position
    data(n).zPos = h5read(fN,[name 'zPosition']);
        
    % Update the waitbar...
    waitbar(n/numSlices,wb,[int2str(n) '/' int2str(numSlices)]);

end

% Put into a single output structure
h5.data = data;
h5.meta = att;

% Remove the waitbar.
delete(wb);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fN] = getFile
% Get the file name if it wasn't provided / incorrect

[uN,uP] = uigetfile('*.h5','Select H5 file');

% Don't know if strictly necessary
if ~strcmp(uP(end),filesep)
    uP = [uP filesep];
end

fN = [uP uN];

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
