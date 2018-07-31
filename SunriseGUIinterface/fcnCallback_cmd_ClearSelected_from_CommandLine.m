function fcnCallback_cmd_ClearSelected_from_CommandLine()
%% About:
% This function is used to clear the currently selected command in the
% command line interface 

% Copyright: Mohammad SAFEEA, 20th-July-2018

% show confirmation dialog box
quest='Are you sure you want to delete the selected command / commands from the command line!!!';
title='Confirmation request!!!';
btn1='Apply';
btn2='Cancel';
defbtn=btn2;
answer = questdlg(quest,title,btn1,btn2,defbtn);

switch answer
    case btn1
        % delete selected items
        h=findobj(0,'tag','txt_CommandLine');
        selectedItems = get(h, 'Value');
        nomOfSelectedItems=max(max(size(selectedItems)));
        if nomOfSelectedItems>0
            set(h, 'Value',1) % very important, fix the bug when deleting the last element of the listbox
            st=get(h,'String');
            n=max(max(size(st)));
            st1=[];
            counter=0;
            for j=1:n
                flagOfNestedLoop=false;
                 for i=1:nomOfSelectedItems
                     index=selectedItems(i);
                     if j==index
                         flagOfNestedLoop=true;
                     end
                 end
                 % if the item is not selected, then added to the new list
                 if flagOfNestedLoop==false
                     counter=counter+1;
                     st1{counter}=st{j};
                 end
            end
            set(h,'String',st1);
        end
    case btn2
        % nothing
end

end