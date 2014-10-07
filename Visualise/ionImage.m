function [ img ] = ionImage( h5P, mz )
%ionImage - extract an ion image from all sections.
% Provide either an m/z range or a central m/z with a ppm or Da tolerance,
% see examples:
% INPUTs
%   h5P: full path of the file.
%   mz:  range over which to extract intensities. Provide either a defined
%   range (a), or a tolerance in either Da (b) or ppm (c). For (b) and (c),
%   values of mz(2) less than 1 are treated as Da and those between 1-50
%   are treated as ppm values. In both instances, this is a ± window, i.e. 
%   plus 5 ppm and minus 5 ppm. If mz(2) is greater than 50, then the
%   function will stop.
%           (a) mz = [855.50 855.60]; mz = [600 900]; mz(1) > mz(2)
%           (b) mz = [855.55   0.05];                 mz(2) < 1  Da
%           (c) mz = [855.55   5   ];                 mz(2) < 50 ppm

% Method?
method = 'sum';

% Decide on the mz range defined by the user. This has to use the 'logic'
% defined above.
[mz] = getMZrange(mz);

% Now import the m/z vector and then find the range of variables that it
% encompasses...
[ind] = getMZvector(h5P,mz);

% Now we know which variable(s) to extract, let's get the data from the
% file. First, we need to preallocate enough space to prevent extreme lag.
[img] = getImage(h5P,ind,method);


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mz2] = getMZrange(mz)
% Convert input into standard format

% Run through the logical options
if mz(2) > mz(1)
    % Straightforward case...
    mz2 = mz;
    
elseif mz(2) < 1
    % Add/subtract
    mz2(1) = mz(1) - mz(2);
    mz2(2) = mz(1) + mz(2);    
    
elseif mz(2) < 50
    % Converyt to ppm diffs
    da = mz(2) * mz(1) / 1e6;    
    mz2(1) = mz(1) - da;
    mz2(2) = mz(1) + da;
    
else
    % This is incompatible with the logic!
    error('Woops.  See explanatory notes');
    
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ind] = getMZvector(h5P,mz)
% Import the mz vector from the h5 file

vec = h5read(h5P,'/mz');

% These are the indices from which the image is to be formed
ind = find(vec >= mz(1) & vec <= mz(2));

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [img] = getImage(h5P,ind,method)
% Read in the h5 file and get the ion images from each of the slices.

numS = str2double(h5readatt(h5P,'/','numSlices'));

for n = 1:numS
    disp([int2str(n) '/' int2str(numS)]);
    
    % Generic name for this group
    name = ['/data/s' int2str(n) '/'];
    
    % This is the spectral data
    tmp = h5read(h5P,[name 'x']);
    
    % Do some stuff exclusively with the first file
    if n == 1        
        % Image size
        sz = size(tmp);
        
        % Preallocate
        img = zeros(sz(1),sz(2),numS);        
    end
    
    % Now use ind to generate the images
    switch method
        case 'sum'
            img(:,:,n) = sum(tmp(:,:,ind),3);
                        
        case 'mean'
            img(:,:,n) = mean(tmp(:,:,ind),3);
            
        otherwise
            error('fail');
    end
    
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
