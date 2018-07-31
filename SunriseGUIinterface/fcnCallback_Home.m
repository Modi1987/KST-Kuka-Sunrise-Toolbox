function fcnCallback_Home()
%% About:
% Method used to go home

% Copyright: Mohammad SAFEEA, 10th-July-2018

global read_state_var;
global iiwa;
% check connection
if fcn_isConnected()
else
    message='Connect to the robot first !!!';
    fcn_errorMessage(message);
    return;
end
% turn off state read
read_state_var=false;
pause(1);
% start the precise hand guiding
relVel=0.25;
iiwa.movePTPHomeJointSpace(relVel);
read_state_var=true;
end