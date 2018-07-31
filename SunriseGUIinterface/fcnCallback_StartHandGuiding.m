function fcnCallback_StartHandGuiding()
%% ABout:
% Method used to start hand guiding functionality

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
iiwa.startHandGuiding();
read_state_var=true;
end