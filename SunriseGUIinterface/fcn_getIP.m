function [ip,errorflag]=fcn_getIP()
%% About:
% Get IP from text boxes

%% Return values:
% ip: string, ip of the robot
% errorFlag: a boolean equals to true, if the values intered in the
% textboxes are valid IP, false otherwise.

% Initiate the return values
ip=[];
errorflag=true;
ip_temp=[];
% first ip section
h=findobj(0, 'tag', 'txt_ip1');
x = get(h,'String'); 
disp(x)
if iserror(x)
   return;
end
ip_temp=[ip_temp,x,'.'];
% second ip section
h=findobj(0, 'tag', 'txt_ip2');
x = get(h,'String'); 
disp(x)
if iserror(x)
   return;
end
ip_temp=[ip_temp,x,'.'];
% third ip section
h=findobj(0, 'tag', 'txt_ip3');
x = get(h,'String'); 
disp(x)
if iserror(x)
   return;
end
ip_temp=[ip_temp,x,'.'];
% fourth ip section
h=findobj(0, 'tag', 'txt_ip4');
x = get(h,'String'); 
disp(x)
if iserror(x)
   return;
end
ip_temp=[ip_temp,x];
% if previous passed, assign return values
ip=ip_temp;
errorflag=false;
end


function flag=iserror(str)
% Initiate the return value    
flag=true;
    
% Check if input is correct size
if isempty(str)
    message='one of IP fields is empty';
    showErrorPopup(message)
    return;
end

if size(str,1)==1
else
    message='IP is not valid';
    showErrorPopup(message)
    return;
end

if size(str,2)>3
    message='IP is not valid';
    showErrorPopup(message)
    return;
end

string_of_allwable_Numeric_Values='0123456789';
n=max(max(size(str)));
for i=1:n
    if sum(sum(size(strfind(string_of_allwable_Numeric_Values,str(i)))))==0
        message='IP shall contain only numbers';
        showErrorPopup(message)
        return;
    end
end

if str2num(str)>255
    message='each segmnt of the IP shall be between 0 up to 255';
    showErrorPopup(message)
    return;
end
% If identification passed, return false, i.e no error detected
flag=false;
end

function showErrorPopup(message)
% disp(message)

ed = errordlg(message);

set(ed, 'WindowStyle', 'modal');

uiwait(ed);
end