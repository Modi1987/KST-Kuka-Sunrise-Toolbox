function moveWaitForDTWhenInterrupted( t_Kuka ,...
     Pos, VEL,joints_indices,max_torque,min_torque, w)
 %% Perform line motion the motion is interruptile through a collision with the environment
 % After a collision the robot waits for a double touch on the end-effector
 % along the Z axes, upon which the robot returns to its motion again.
 
 % Copyright: Mohammad SAFEEA, 11th-April-2018
 
 while true
    [ res ] = movePTP_ConditionalTorque_LineEEF( t_Kuka ,...
     Pos, VEL,joints_indices,max_torque,min_torque);
    if(res==1)
        disp('Motion completed successfully');
        break;
    elseif(res==0)
        disp('Motion interrupted');
        detectDoubleTouch(t_Kuka,w);
        pause(0.5);
    elseif(res==-1)
        disp('Error while performing the motion');
        break;
    end
end
end

function x=detectDoubleTouch(t_Kuka,w)
%% Detect double touch at the EEF along the Z axes
buffer=zeros(50,1);
daSum=0;
while true
    [ f ] = getEEF_Force( t_Kuka );
    normForce=(f{3}*f{3})^0.5;
    buffer(1)=[];
    buffer=[buffer;normForce];
    pause(0.04);
    temp=buffer>(5+w);
    for i=2:50
        if (temp(i)-temp(i-1))==1
            daSum=daSum+1;
        end
    end
    if daSum==2
        x=1;
        return;
    end
end
end