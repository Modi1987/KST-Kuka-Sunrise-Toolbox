function y=fcn_tokenize(str,del)
%% About:
% function used to split a string according to delemeter

%% Arreguments:
% str: input string to tokenize
% del: is the delemeter character

%% example:
% st='command_1.2_2.36_4.5_4'
% fcn_tokenize(str,'_')

% Copyright: Mohammad SAFEEA, 13th-July-2018

n=max(max(size(str)));

y=[];
temp=[];
counter=0;
for i=1:n
    if str(i)==char(13)
    elseif str(i)==del
        counter=counter+1;
        y{counter}=temp;
        temp=[];
    else
        temp=[temp,str(i)];
    end
end
% add the last element
counter=counter+1;
y{counter}=temp;
temp=[];

end