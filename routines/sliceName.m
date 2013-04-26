function name = sliceName(isVertical, lowercase)
    if nargin < 2
        lowercase = 0;
    end
    
    if isVertical
        name = 'Vertical';
    else
        name = 'Horizontal'; 
    end
    
    if lowercase
        name = lower(name);
    end
end