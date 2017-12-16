function [ thetaVec,sVec ] = getEllipseLengthVector( a,b, theta0,theta1 )
%% About:
% This function is used to return the length of the ellipse as a function
% of the angle theta.

%% Inputs:
% theta0, theta1: start/end angle of the arc of the ellipse (from the parametric equation of the ellipse)
% a,b: the big and the small radious of the ellipse.

% Mohammad SAFEEA 10-Nov-2017

thetaSpan = [theta0 theta1];
s0 = 0;
opts = odeset('RelTol',1e-2,'AbsTol',1e-4);
[thetaVec,sVec] = ode45(@(theta,s) ((a*a*sin(theta)*sin(theta)+b*b*cos(theta)*cos(theta))^0.5), thetaSpan, s0,opts);

end

