function y=fcn_isConnected()
%% About:
% Method to check the connection with the robot.

%% Return value:
% y: true, if a connection between the robot and the PC is active.
%     false, if no connection is present.

    global isConnected;
    y=isConnected;
end