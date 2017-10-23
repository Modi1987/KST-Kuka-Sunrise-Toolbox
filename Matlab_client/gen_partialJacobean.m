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