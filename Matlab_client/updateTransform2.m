function [ Tt ] = updateTransform2(T,w,v,dt)
% This function takes the input of the 
normw=norm(w);
if normw>0
    R1=T(1:3,1:3);
    wCrossR1=zeros(3,3);
    for i=1:3
        wCrossR1(:,i)=cross(w,R1(:,i));
    end
    Rt=R1+wCrossR1*dt;
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

