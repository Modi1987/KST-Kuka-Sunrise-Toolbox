function fcnCallback_Disconnect()
%% ABout:
% This function is used to disconnect

% Copyright: Mohammad SAFEEA, 10th-July-2018

global iiwa;
global isConnected;
if fcn_isConnected()
    iiwa.net_turnOffServer();
    isConnected=false;
else
    message='Not connected, so can not disconnect !!!';
    fcn_errorMessage(message);
    return;
end
%% Stop timer
global read_state_var;
global executionNum;
global timerObject;
read_state_var=false;
executionNum=0;
stop(timerObject);
delete(timerObject);

global feedback_eef_pos;
global feedback_jpos;
feedback_eef_pos=[];
feedback_jpos=[];
end