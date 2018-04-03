function [t0,t1,t2]=calculateInterpolationTimes(L,v,a)
%% About:
% calculates the times of the acceleration, stable motion, deceleration

%% Arreguments:
% L: length of the curve (mm).
% v: linear velocity of eef on the the curve (mm/sec).
% a: linear acceleration of eef on the the curve (mm/sec2).

%% Return values:
% t0; time for acceleration.
% t1: time for acceleration, constant velocity.
% t2: time for acceleration, constant velocity and for deceleration

% Copy right: Mohammad SAFEEA
% 16th-Oct-2017

taw=v/a;

if(L>a*taw*taw)
    t0=taw;
    deltat=(L-a*taw*taw)/v;
    t1=t0+deltat;
    t2=t1+taw;
else
    taw1=(L/a)^0.5;
    t0=taw1;
    t1=taw1;
    t2=2*taw1;
end

end

