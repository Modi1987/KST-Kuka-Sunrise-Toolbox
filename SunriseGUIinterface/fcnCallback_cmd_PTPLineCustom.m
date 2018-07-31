function fcnCallback_cmd_PTPLineCustom()
%% Adds motion command to commandline
% The motion command is point to point line.

global read_state_var;
read_state_var=false;
pause(0.2);
try
    [flag,eef_pos]=dialog_EEFPoseInput();
catch
    read_state_var=true;
end
read_state_var=true;

if exist('eef_pos')
else
    disp('Error in {fcnCallback_cmd_PTPLineCurrent}')
    disp('Variable {eef_pos} does not exist or cleared')
    return;
end

if isempty(eef_pos)
    disp('Error in {fcnCallback_cmd_PTPLineCurrent}')
    disp('Variable {eef_pos} is empty')
    return;
end

if max(size(eef_pos))==6
    if flag==1
        fcn_addToTextboxCartesianPTPLineMotion(eef_pos)
    else
        return;
    end
else
    disp('Error in {fcnCallback_cmd_PTPLineCurrent}')
    disp('Variable {eef_pos} is not right size')   
end

end