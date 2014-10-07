function [x,y,z] = defSize(img,sp)
% Some initial sizes

% z-axis spacing
if nargin == 1 || isempty(sp)
    sp = 1;
end

% What are the coordinates?
px = sp:sp:(sp*size(img,1));
py = 1:size(img,2);
pz = 1:size(img,3);

% Meshgrid
[x,y,z] = meshgrid(py,px,pz);

end
