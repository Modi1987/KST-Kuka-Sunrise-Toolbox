function movePTPEllipse_XZ_1(iiwa,c,ratio,theta,velocity,accel,TefTool)
%% This funciton is used to
% Move end-effector of the robot on an ellipse the plane of the ellipse is
% parallel to the XY plane of the robot base.

%% Syntax:
% movePTPEllipse_XY(iiwa,c,ratio,theta,velocity,accel,TefTool)

%% Arreguments:
% iiwa: KST obejct.
% c: 2x1 vector, is a vector defining the displacment of the the center
% point of the ellipse in the XZ plane in relation to the starting point of the ellipse,
% position units in (mm). 
% ratio: the radious ratio (a/b) of the ellipse.
% theta: is the angle of the ellipe part , for drawing a complete
% ellipse this angle is equal to 2*pi.
% TefTool: 4X4 Transform matrix of the end-efector in the reference frame
% of the flange of the KUKA iiwa, position units in (mm).
% accel: is the acceleration (mm/sec2).
% velocity: is the motion velocity (mm/sec).
 
% Copy right: Mohammad SAFEEA
% 27th-June-2018

%% Convert inputs to a column vectors
c=colVec(c);
ratio=colVec(ratio);
theta=colVec(theta);
velocity=colVec(velocity);
accel=colVec(accel);

%% Check input variables
if(size(c,1)~=2)
fprintf('Error: the vector (c) shall be a 2x1 vector \n');
return;
end

if(size(ratio,1)~=1)
fprintf('Error: the ratio shall be a scalar  \n');
return;
end

if(size(theta,1)~=1)
fprintf('Error: the variable (theta) shall be a scalar  \n');
return;
end

if(size(TefTool,1)~=4)
fprintf('Error: the transform matrix (TefTool) shall be 4x4  \n');
return;
end

if(size(TefTool,2)~=4)
fprintf('Error: the transform matrix (TefTool) shall be 4x4  \n');
return;
end

if(size(velocity,1)~=1)
fprintf('Error: the velocity on the path shall be a scalar  \n');
return;
end

if(size(accel,1)~=1)
fprintf('Error: the acceleration on the path shall be a scalar  \n');
return;
end

dir=[1;0;0];
c=[c(1);
    0;
    c(2)];

% perform the elliptical motion
movePTPEllipse(iiwa,c,dir,ratio,theta,velocity,accel,TefTool);
end


function y=colVec(x)
if size(x,2)==1
    y=x;
else
    y=x';
end
end