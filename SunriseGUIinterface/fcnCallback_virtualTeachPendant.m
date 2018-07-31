function fcnCallback_virtualTeachPendant()
%% About
% Method used to start the virtual teach penant of the GUI interface

% Copyright: Mohammad SAFEEA, 24th-July-2018

global read_state_var;
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
% start the virtual tach pendant by calling its main method
virtualTeachPendant_main();

read_state_var=true;
end