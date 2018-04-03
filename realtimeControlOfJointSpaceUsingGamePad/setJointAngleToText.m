% Copyright Mohammad SAFEEA, 17th-Aug-2017
function setJointAngleToText(anglesTextHandlesCellArray, index,angle )
%% Set the joint angle in degrees for the 
    angle=180*angle/pi;
    set(anglesTextHandlesCellArray{index},'String',num2str(angle));
    %set(anglesTextHandlesCellArray{1},'BackgroundColor','red');


end

