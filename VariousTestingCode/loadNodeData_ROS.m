function [rxSymbols, rxSymbols_ref, testName] = loadNodeData_ROS (directory, ref_node, folder_index)


%% Paramaters

CHUNKSIZE = 192000;
N = 5;

%% Loading Code


folder = dir(strcat(directory, '/*.mat'));

ChosenFile = strcat(directory,'/', folder(folder_index).name);

testName = folder(folder_index).name

load(ChosenFile);

rxSymbols = X;

%Zero Elements have to be replaced with 1 before referencing to that node.
rxSymbols_Copy = rxSymbols;
rxSymbols_Copy(ref_node,rxSymbols_Copy(ref_node,:)==0) = 1;



%Refference to specific node.

rxSymbols_ref = rxSymbols_Copy./rxSymbols_Copy(ref_node,:);



end
