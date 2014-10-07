function [h5P] = hdfPath
%hdfPath - provides the default path of the HDF file that will be used
%subsequently. This can be (eventually) downloaded from the Gigascience
%repository, where the dataset will be / has been published.

% James McKenzie, Imperial College, London, 2014.

% Define folder and names here
loc = '/Users/jmckenzi/DB/3D/Giga/';
nam = 'ICL-Colorectal-140919-172528.h5';

% Filesep
if ~strcmp(loc(end),filesep)
    loc = [loc filesep];
end

% Join
h5P = [loc nam];

% Check exist
if ~exist(h5P,'file')
    error('Your file does not exist.');
end

end

