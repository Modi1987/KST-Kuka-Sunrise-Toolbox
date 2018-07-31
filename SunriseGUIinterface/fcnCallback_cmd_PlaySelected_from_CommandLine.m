function fcnCallback_cmd_PlaySelected_from_CommandLine()
%% About:
% This function is used to play the currently selected command in the
% command line interface 

% Copyright: Mohammad SAFEEA, 20th-July-2018

% Check connection first
if fcn_isConnected()
else
    message='Connect to the robot first !!!';
    fcn_errorMessage(message);
    return;
end

% show confirmation dialog box
quest='Are you sure you want to perfrom the selected command!!!';
title='Confirmation request!!!';
btn1='Apply';
btn2='Cancel';
defbtn=btn2;
answer = questdlg(quest,title,btn1,btn2,defbtn);

switch answer
    case btn1
        % Perfrom the selected command
        h=findobj(0,'tag','txt_CommandLine');
        selectedItems = get(h, 'Value');
        nomOfSelectedItems=max(max(size(selectedItems)));
        if nomOfSelectedItems==0
            message='No item is selected';
            fcn_errorMessage(message);
            return;
        end
        if nomOfSelectedItems>1
            message='Select only one item';
            fcn_errorMessage(message);
            return;
        end      
        strArray=get(h,'String');
        if sum(sum(size(strArray)))==0
            message='No items to play';
            fcn_errorMessage(message);
            return;
        else
            str=strArray{selectedItems(1)};
            fcn_decodeCommandMoveRobot(str);
        end
    case btn2
        % nothing
end

end