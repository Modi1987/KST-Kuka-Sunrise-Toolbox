function rMat= getEEFOrientationR(t)
%% This function is used to get the orientation of the 
% media flange of the KUKA iiwa 7 R 800 robot.

%% Syntax:
% [R]= getEEFOrientationR(t)

%% About:
% This function is used to get the orientation of the 
% media flange of the KUKA iiwa 7 R 800 robot. The orientation is described
% by a 3x3 rotation matrix

%% Arreguments:
% R: is the rotation matrix descriping the orientation of the end-effector
% of the media flange of the robot.
% t : is the TCP/IP comunication object.

%% Copyright, Mohammad SAFEEA 7th of August 2017.

alfa={0,-pi/2,pi/2,pi/2,-pi/2,-pi/2,pi/2};
d={0.34,0.0,0.4,0.0,0.4,0.0,0.28}; 
a={0,0,0,0,0,0,0};
theta=getJointsPos(t);
T=zeros(4,4,7);
for i=1:7
    T(:,:,i)=getDHMatrix(alfa{i},theta{i},d{i},a{i});
end

eef_transform=eye(4);

for i=7:-1:1
    eef_transform=T(:,:,i)*eef_transform;
    normalizeColumns(eef_transform); % correct for numerical errors of 
    % the rotation matrix, where the rotation matrix is the upper left part 
    %of the transform matrix
end

rMat=eef_transform(1:3,1:3);
end

function normalizedT=normalizeColumns(T)
%% This function is used to normalize the columns of a rotation matrix with 
% some numerical errors resulting from matrix multiplication problems
r=zeros(4,3); % corrected rotatio matrix, with zero badding row at the end
for j=1:3
    r(1:3,1)=T(1:3,j)/norm(T(1:3,j));
end
normalizedT=[r,T(:,4)];
end

function q=r2quat(R)

tr = R(1,1) + R(2,2) + R(3,3);

    if (tr > 0)  
       S = sqrt(tr+1.0) * 2; % S=4*qw 
      qw = 0.25 * S;
      qx = (R(3,2) - R(2,3)) / S;
      qy = (R(1,3) - R(3,1)) / S; 
      qz = (R(2,1) - R(1,2)) / S; 
    elseif ((R(1,1) > R(2,2)) && (R(1,1) > R(3,3)))  
       S = sqrt(1.0 + R(1,1) - R(2,2) - R(3,3)) * 2; % S=4*qx 
      qw = (R(3,2) - R(2,3)) / S;
      qx = 0.25 * S;
      qy = (R(1,2) + R(2,1)) / S; 
      qz = (R(1,3) + R(3,1)) / S; 
    elseif (R(2,2) > R(3,3))  
       S = sqrt(1.0 + R(2,2) - R(1,1) - R(3,3)) * 2; % S=4*qy
      qw = (R(1,3) - R(3,1)) / S;
      qx = (R(1,2) + R(2,1)) / S; 
      qy = 0.25 * S;
      qz = (R(2,3) + R(3,2)) / S; 
    else  
       S = sqrt(1.0 + R(3,3) - R(1,1) - R(2,2)) * 2; % S=4*qz
      qw = (R(2,1) - R(1,2)) / S;
      qx = (R(1,3) + R(3,1)) / S;
      qy = (R(2,3) + R(3,2)) / S;
      qz = 0.25 * S;
    end
    q=[qw,qx,qy,qz];
end

function T=getDHMatrix(alfa,theta,d,a)
T=zeros(4,4);

calpha=cos(alfa);
sinalpha=sin(alfa);
coshteta=cos(theta);
sintheta=sin(theta);

T(1,1)=coshteta;
T(2,1)=sintheta*calpha;
T(3,1)=sintheta*sinalpha;				

T(1,2)=-sintheta;
T(2,2)=coshteta*calpha;
T(3,2)=coshteta*sinalpha;

T(2,3)=-sinalpha;
T(3,3)=calpha;

T(1,4)=a;
T(2,4)=-sinalpha*d;
T(3,4)=calpha*d;
T(4,4)=1;

end