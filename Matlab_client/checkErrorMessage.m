function ret=checkErrorMessage(message)

ak='error';

if ~exist('message','var')
     ret=false;
    return;   
end

if isempty(message)
    ret=false;
    return;
end

for i=1:5
if(message(i)==ak(i))
else
    ret=false;
    return
end
    ret=true;
    return
end

