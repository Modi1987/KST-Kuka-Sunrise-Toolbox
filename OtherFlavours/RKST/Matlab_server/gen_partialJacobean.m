function [J]=gen_partialJacobean(q,linkNum,Pos)
%% Syntax:
% [J]=gen_partialJacobean(q,linkNum,Pos)

%% Arreguments:
% q: is (7x1) vector of the joint angles of the manipulator
% linkNum: The number of the link at which the partial Jacobean is
% associated, linkNum shall be an integer in the range (1 to 7)
% Pos: is (3x1) vector, the position vector of the point of the
% link where the partial jacobean is to be calculated. The vector (Pos) is
% described in the local frame of the link where the partial jacobean is
% to be calculated

%% Return value:
% J: is the partial jacobean

% Mohammad SAFEEA 23rd Oct 2017


if linkNum>7
    disp('Error linkNum shall be less than 8');
    j=[];
    return;
end
if linkNum<1
    disp('Error linkNum shall be more than 0');
    j=[];
    return;
end

alfa={0,-pi/2,pi/2,pi/2,-pi/2,-pi/2,pi/2};
d={0.34,0.0,0.4,0.0,0.4,0.0,0.28}; 
a={0,0,0,0,0,0,0};

T=zeros(4,4,7);
i=1;
T(:,:,i)=getDHMatrix(alfa{i},q(i),d{i},a{i});
    for i=2:7
        T(:,:,i)=T(:,:,i-1)*getDHMatrix(alfa{i},q(i),d{i},a{i});
        T(:,:,i)=normalizeColumns(T(:,:,i));
    end
        T(:,:,7)=T(:,:,7)*TefTool;
        T(:,:,7)=normalizeColumns(T(:,:,7));
        
% parital jacobean
    J=zeros(6,linkNum);
    pef=T(1:3,1:3,linkNum)*Pos+T(1:3,4,linkNum);
    for i=1:linkNum
        k=T(1:3,3,i);
        pij=pef-T(1:3,4,i);
        J(1:3,i)=cross(k,pij);
        J(4:6,i)=k;
    end
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

function normalizedT=normalizeColumns(T)
%% This function is used to normalize the columns of a rotation matrix with 
% some numerical errors resulting from matrix multiplication problems
r=zeros(4,3); % corrected rotatio matrix, with zero badding row at the end
for j=1:3
    r(1:3,j)=T(1:3,j)/norm(T(1:3,j));
end
normalizedT=[r,T(:,4)];
end