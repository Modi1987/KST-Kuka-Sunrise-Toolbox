function res=rot2eulZYX(R)
% calculates ZYX euler rotation angles from 
% the rotation matrix R

% Matlab implementation of the method descirped in:
% "Computing Euler angles from a rotation matrix"
% Author: Gregory G. Slabaugh

% Copyright, Mohammd SAFEEA, 9th August 2018

% test:
% R=rotz(45)*roty(22)*rotx(30);
% res=rot2eulZYX(R)*180/pi

% res=rot2eulZYX(eye(3))

    [res]=eulerAngles(R) ;
end

function y=closeEnough(a,b)
    epsilon=0.000001;
    if (epsilon>abs(a-b))
        y=1;
    else
        y=0;
    end
end

function [res]=eulerAngles(R) 
    %% check for gimbal lock
    R=R';
    if (closeEnough(R(1,3), -1.0)) 
        b = 0; %% gimbal lock, value of x doesn't matter
        c = pi / 2;
        a = b + atan2(R(2,1), R(3,1));
    elseif (closeEnough(R(1,3), 1.0)) 
        b = 0;
        c = -pi / 2;
        a = -b + atan2(-R(2,1), -R(3,1));
    else  %% two solutions exist
        b1 = -asin(R(1,3));
        b2 = pi - b1;

        c1 = atan2(R(2,3) / cos(b1), R(3,3) / cos(b1));
        c2 = atan2(R(2,3) / cos(b2), R(3,3) / cos(b2));

        a1 = atan2(R(1,2) / cos(b1), R(1,1)/ cos(b1));
        a2 = atan2(R(1,2) / cos(b2), R(1,1) / cos(b2));

        %% choose one solution to return
        %% for example the "shortest" rotation
        condition=((abs(b1) + abs(c1) + abs(a1)) <= (abs(b2) + abs(c2) + abs(a2)));
        if condition 
            a=a1;
            b=b1;
            c=c1;   
        else 
            a=a2;
            b=b2;
            c=c2;   
        end
    end
    res=[a,b,c];
end
