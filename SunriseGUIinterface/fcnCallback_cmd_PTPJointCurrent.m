function fcnCallback_cmd_PTPJointCurrent()
%% Adds motion command to commandline
% The motion command is point to point line.

% check connection
if fcn_isConnected()
else
    message='Connect to the robot first !!!';
    fcn_errorMessage(message);
    return;
end

global feedback_jpos;
if exist('feedback_jpos')
else
    disp('Error in {fcnCallback_cmd_PTPJointCurrent}')
    disp('Variable {feedback_jpos} does not exist or cleared')
    return;
end

if isempty(feedback_jpos)
    disp('Error in {fcnCallback_cmd_PTPJointCurrent}')
    disp('Variable {feedback_jpos} is empty')
    return;
end

if max(size(feedback_jpos))==7
    fcn_addToTextboxJointsPTPMotion(feedback_jpos)
else
    disp('Error in {fcnCallback_cmd_PTPJointCurrent}')
    disp('Variable {feedback_jpos} is not right size')   
end

end