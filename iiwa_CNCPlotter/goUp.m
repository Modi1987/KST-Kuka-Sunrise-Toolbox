function [Tt,qs]=goUp(iiwa,qs,TefTool,vz,zUp1)
%% About
% This funciton is used to move uo the robot above the drawing sheet

%% Syntax
% [Tt,qs]=goUp(t_Kuka,qs,TefTool,vz,zCord)

%% Arreguments
% iiwa: is the KST object
% qs: is 7x1 column vector of joint angles of the robot
% TefTool: is the transform matrix of the tool with respect to robot's flange
% vz: is the velocity along the Z axes
% zCord: 

%% Return value
%Tt: final trnsform matrix acheived
% qs: final joints poisition acheived

% Copyright: Mohammad SAFEEA, 27th-April-2018

    T0=iiwa.directKinematics(qs); 
    Tt=T0;
    
    z0=T0(3,4);
    z1=zUp1;
    
    wattar=((z0-z1)*(z0-z1))^0.5;
    if wattar==0
        return;
    end

    vz=abs(vz)*(z1-z0)/wattar;
    
    trajectoryTime0=toc;
    transmittionTime0=trajectoryTime0;
    motionFlag=1;
    while motionFlag
        deltaT=toc-trajectoryTime0;
        z=z0+vz*deltaT;
        wattar1=((z0-z)*(z0-z))^0.5;
        if wattar1>wattar
            motionFlag=0;
        end
        if(toc-transmittionTime0)>0.003
            Tt(3,4)=z;
            [ qs ] = iiwa.gen_InverseKinematics( qs, Tt, 10,0.1 );
            transmittionTime0=toc;
            for k=1:7
                jPos{k}=qs(k);
            end
            iiwa.sendJointsPositionsf(jPos);
        end
    end
end
