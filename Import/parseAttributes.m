function [att,numSlices] = parseAttributes(info)
% Parse the attributes from the info structure

% James McKenzie, Imperial College, London, 2014.
numA = size(info.Attributes,1);

att = cell(numA,2);

for n = 1:numA
    att{n,1} = info.Attributes(n).Name;
    att{n,2} = info.Attributes(n).Value;
    
    % Alternatively (classier) call h5readatt(fN,'/','numSlices')
    if strcmp(att{n,1},'numSlices')
        numSlices = str2double(att{n,2});
    end
end

end
