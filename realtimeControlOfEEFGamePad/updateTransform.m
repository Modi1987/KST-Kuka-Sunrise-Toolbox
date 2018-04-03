function [ Tt ] = updateTransform(T,w,v,dt)
% Copyright Mohammad SAFEEA, 17th-Aug-2017
% This function takes the input of the 
normw=norm(w);
if norm(w)>0
    c=cos(normw*dt/2);
    s=sin(normw*dt/2);
    quat=[c,s*w'/normw];
    R=T(1:3,1:3);
    dR=quat2rot(quat);
    Rt=R*dR;
else
    Rt=T(1:3,1:3);
end

dx=v*dt;
xt=T(1:3,4)+dx;

Tt=[Rt,xt];
Tt=[Tt;
    0 0 0 1];
Tt=normalizeTransformMatrix(Tt);
end


function R=quat2rot(q)
R=[(1-2*q(3)*q(3)-2*q(4)*q(4)), 2*(q(1)*q(3)-q(1)*q(4)), 2*(q(2)*q(4)+q(1)*q(3));
2*(q(2)*q(3)+q(1)*q(4)), (1-2*q(2)*q(2)-2*q(4)*q(4)), 2*(q(3)*q(4)-q(1)*q(2));
2*(q(2)*q(4)-q(1)*q(3)), 2*(q(3)*q(4)+q(1)*q(2)), (1-2*q(2)*q(2)-2*q(3)*q(3))];
end

function T=normalizeTransformMatrix(t)
T=zeros(4,4);
T(:,4)=t(:,4);
for i=1:3
    T(1:3,i)=t(1:3,i)/norm(t(1:3,i));
end
end

