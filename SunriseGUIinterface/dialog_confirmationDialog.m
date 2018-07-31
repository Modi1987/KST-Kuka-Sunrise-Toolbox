function y=dialog_confirmationDialog(message)
%% This is a confirmation dialog
% That asks the user a confirmation for some message
quest=message;
title='Confirmation request!!!';
btn1='Apply';
btn2='Cancel';
defbtn=btn2;
answer = questdlg(quest,title,btn1,btn2,defbtn);
% return value
y=0;
switch answer
    case btn1
        % clar interface
        y=1;
end

end