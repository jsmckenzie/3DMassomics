function [ output_args ] = printImage( name, type )
%printImage - high res image printing function

% What is the resolution?    
resol = '-r300';
    
% Select the format that you want...
switch lower(type)
    case 'eps'
        opt = '-depsc';
        
    case 'png'
        opt = '-dpng';
        %resol = '-r400';
        
    case {'jpeg', 'jpg'}
        opt = '-djpeg';
        
    otherwise 
        opt = '-dtiff';
        %resol = '-r400';
end
    
try
    % Set the size to match what is on the screen!
    set(gcf, 'PaperPositionMode', 'auto');
    print(gcf, opt, resol, name);

catch err
    err
    error('Failed to save for some reason.');
end


end

