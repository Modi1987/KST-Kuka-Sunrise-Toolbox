function [J]=gen_partialJacobean_1(a, d, alfa, TefTool, q, linkNum, Pos)
%% Syntax:
% [J]=gen_partialJacobean(q,linkNum,Pos)

%% Arreguments:
% a, d, alfa, TefTool: DH parameters and transform matrix for eef tranform in flange frame
% q: is (7x1) vector of the joint angles of the manipulator
% linkNum: The number of the link at which the partial Jacobean is
%           associated, linkNum shall be an integer in the range (1 to 7)
% Pos: is (3x1) vector, the position vector of the point of the
%      link where the partial jacobean is to be calculated. The vector (Pos) is
%      described in the local frame of the link where the partial jacobean is
%      to be calculated

%% Return value:
% J: is the partial jacobean

% Mohammad SAFEEA 3rd Nov 2024


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
