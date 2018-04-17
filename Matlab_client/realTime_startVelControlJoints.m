function [ret]=realTime_startVelControlJoints( t_Kuka )
%% Applicable to KST 1.6

%% Syntax:
% realTime_startVelControlJoints( t_Kuka )

%% About:
% This function is used to turn on the soft real-time control at joints
% velocities level

%% Check also
% ((sendJointsVel)), refer also to the function
% ((realTime_stopVelControlJoints)).

%% Arreguments
% t_Kuka: is the TCP/IP connection object

%% Return value:
% ret: 'true' if the joints positions message has been received and processed
% successfully by the server, otherwise 'false' is returned.

% Copy right, Mohammad SAFEEA, 1st of April 2018

theCommand='stVelDcJoint_';
fprintf(t_Kuka, theCommand);
message=fgets(t_Kuka);
i=0;
ret=true;
if(size(message,2)>4)
    i=i+1;
    if(message(i)=='d')
            i=i+1;
        if(message(i)=='o')
                i=i+1;
            if(message(i)=='n')
                    i=i+1;
                if(message(i)=='e')
                    disp('Acknowledge, realtime control turned on');
                else
                    ret=false;
                end
            else
                ret=false;
            end
        else
            ret=false;
        end
    else
        ret=false;
    end    
end
delay(0.5); % introduce some time delay, so the robot turns on the direct servo before starting the motion
end

