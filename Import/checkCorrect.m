function checkCorrect(fN)
% Simple test to ensure that only the correct 3D files are processed. Test
% using a simple attribute name/value match.

% James McKenzie, Imperial College, London, 2014.

try
    tmp = h5readatt(fN,'/','projectName');    
    if ~strcmp(tmp,'3D-Massomics');
        flag = false;
    else
        flag = true;
    end
catch
   flag = false;
end

if ~flag
    error('Woops. This isn''t a compatible file.');
else
    disp(['Loading: ' fN]);
end

end
