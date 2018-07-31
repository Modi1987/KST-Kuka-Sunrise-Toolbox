function fcnCallback_cmd_PTPLineCurrent()
%% Adds motion command to commandline
% The motion command is point to point line.

% check connection
if fcn_isConnected()
else
    message='Connect to the robot first !!!';
    fcn_errorMessage(message);
    return;
end

global feedback_eef_pos;
% global feedback_jpos;
if exist('feedback_eef_pos')
else
    disp('Error in {fcnCallback_cmd_PTPLineCurrent}')
    disp('Variable {feedback_eef_pos} does not exist or cleared')
    return;
end

if isempty(feedback_eef_pos)
    disp('Error in {fcnCallback_cmd_PTPLineCurrent}')
    disp('Variable {feedback_eef_pos} is empty')
    return;
end

if max(size(feedback_eef_pos))==6
    fcn_addToTextboxCartesianPTPLineMotion(feedback_eef_pos)
else
    disp('Error in {fcnCallback_cmd_PTPLineCurrent}')
    disp('Variable {feedback_eef_pos} is not right size')   
end

end