% Copyright Mohammad SAFEEA, 17th-Aug-2017
function setBackGroundColor(labelTextHandlesCellArray, index )
%% Set the joint angle in degrees for the 
    for i=1:7
        set(labelTextHandlesCellArray{i},'BackgroundColor',[1 1 1]);
    end
    
    set(labelTextHandlesCellArray{index},'BackgroundColor','red');


end

