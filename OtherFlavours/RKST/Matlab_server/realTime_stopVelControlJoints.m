function realTime_stopVelControlJoints( t_Kuka )
%% Applicable to KST 1.6

%% Syntax:
% realTime_stopVelControlJoints( t_Kuka )


%% About:
% This function is used to turn on the soft real-time control at joints
% velocities level

%% Check also
% ((sendJointsVel)), refer also to the function
% ((realTime_startVelControlJoints)).

% Copy right, Mohammad SAFEEA, 1st of April 2018

pause(0.1); % introduce some time delay, so the robot finish his motion before turining off the direct servo
theCommand='stopDirectServoJoints';
fprintf(t_Kuka, theCommand);

message=fgets(t_Kuka); % Acknowledge  message of direct servo turned off is
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

