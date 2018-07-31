function fcnCallback_cmd_PlayCommandLine()
%% About:
% This function is used to play the command entered in the command line of
% the command line interface of the GUI.

% Copyright: Mohammad SAFEEA, 18-July-2018

% Check connection first
if fcn_isConnected()
else
    message='Connect to the robot first !!!';
    fcn_errorMessage(message);
    return;
end

% get handle of command line
h=findobj(0,'tag','txt_CommandLine');
st=get(h,'String');

n_of_instrucitons=0;
if isempty(st)
    message='No commands are in the command line';
    fcn_errorMessage(message);
    return;
else
    n_of_instrucitons=max(size(st));
end

% Perform instructions, command the robot
for i=1:n_of_instrucitons
    command=st{i};
    fcn_decodeCommandMoveRobot(command);
end

end