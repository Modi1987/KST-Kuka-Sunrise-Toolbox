function fcnCallback_StartPreciseHandGuiding()
%% About
% Method used to start precise hand guiding functionality

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
wot=0;
com=[0,0,0];
iiwa.startPreciseHandGuiding(wot,com);
read_state_var=true;
end