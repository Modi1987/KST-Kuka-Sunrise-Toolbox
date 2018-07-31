function fcnCallback_cmd_ClearCommandLine()
%% About:
% This function is used to clear the command line interface

% Copyright: Mohammad SAFEEA, 20th-July-2018


% show confirmation dialog box
quest='Are you sure you want to clear the command line, this will delete all entered instructions!!!';
title='Confirmation request!!!';
btn1='Apply';
btn2='Cancel';
defbtn=btn2;
answer = questdlg(quest,title,btn1,btn2,defbtn);

switch answer
    case btn1
        % clar interface
        h=findobj(0,'tag','txt_CommandLine');
        st=[];
        set(h,'String',st);
    case btn2
        % nothing
end

end