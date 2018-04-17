function realTime_stopDirectServoCartesian( t )
%% Syntax:
% realTime_stopDirectServoCartesian( t_Kuka )


%% About
% This function is used to turn off the direct servo function on the robot
% this function is for direct-servoing in joint space

%% Arreguments
% t_Kuka: is the TCP/IP connection object

% Copy right, Mohammad SAFEEA, 1st of April 2018
pause(1); % introduce some time delay, so the robot finish his motion before turining off the direct servo
theCommand='stopDirectServoJoints';
fprintf(t, theCommand);

message=fgets(t); % Acknowledge  message of direct servo turned off is
i=0;
if(size(message,2)>4)
    i=i+1;
    if(message(i)=='d')
            i=i+1;
    if(message(i)=='o')
            i=i+1;
    if(message(i)=='n')
            i=i+1;
    if(message(i)=='e')
        disp('Acknowledge, real time control turned off');
    end
    end
    end
    end
    
end

end

