function [ vec ] = ellipseParametricFunction( a,b,theta )
%% About:
% Calculate the X and Y coordinates of the ellipse point corrsponding to
% angle (theta) from the parametric equation

%% inputs:
% theta: angle of point on the ellipse (from the parametric equation of the ellipse)
% a,b: the big and the small radious of the ellipse

%% Return value:
% The return value is a column vector, vec=[x;y;0] where:
% x: the x coordiante of the point on the ellipse correspodning to angle
% (theta) as described in the frame of the ellipse
% y: the y coordiante of the point on the ellipse  correspodning to angle
% (theta) as described in the frame of the ellipse

% Mohammad SAFEEA 10-Nov-2017

x=a*cos(theta);
y=b*sin(theta);
vec=[x;y;0];

end

