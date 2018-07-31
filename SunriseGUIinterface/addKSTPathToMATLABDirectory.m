function addKSTPathToMATLABDirectory()
cDir = pwd;
cDir=getTheKSTDirectory(cDir);
addpath(cDir);
end