function [rxSymbols, rxSymbols_cut, rxSymbols_cut_ref, testName, startTime] = loadNodeData_v2Audio (directory, ref_node, folder_index)


%% Paramaters

SAMPLERATE = 192000;
N = 5;

%% Loading Code


folder = dir(directory);
folder(1:2) = []; %Remove . and ..


ChosenFolder = strcat(directory, folder(folder_index).name, '/*.wav');

testName = folder(folder_index).name
%Gets all filenames
filenames = dir(ChosenFolder);
splitnames = cell(size(filenames, 1), 7); %For the split up filenames


%find a way to preallocate for multiple tests too?? or use cell array..

for n = 1:size(filenames, 1)    %Splits the filenames up using _ as a divider
    splitnames(n,1:7) = split(filenames(n).name, {'_','.wav'});
end
splitnames = splitnames(:, [2,4,6]);

nameoutput = splitnames;
nameoutput = cell2table(nameoutput,'VariableNames', {'Node', 'IntendedT', 'StartT'});
nameoutput.Node = str2double(nameoutput.Node);
nameoutput.IntendedT = str2double(nameoutput.IntendedT);
nameoutput.StartT = str2double(nameoutput.StartT);

x = audioread(strcat(filenames(n).folder,'\',filenames(n).name));
NOSAMPLES = size(x,1);


rxSymbols = zeros(N, NOSAMPLES);
%% Timing stuff

StartT = nameoutput.StartT;

[startTime,b] = max(StartT);

Reffered_Start = StartT - StartT(b);

time_step = 1/SAMPLERATE;


Reffered_Start_Samples = Reffered_Start./time_step;
%Reffered_Start_Samples = round(Reffered_Start_Samples + abs(min(Reffered_Start_Samples)))
Reffered_Start_Samples = round(Reffered_Start_Samples);
NoSamplesCut = max(abs(Reffered_Start_Samples));

rxSymbols_cut = zeros(N, NOSAMPLES);

Reffered_Start_Samples


for n = 1:size(filenames,1)
    x = audioread(strcat(filenames(n).folder,'\',filenames(n).name));
    rxSymbols(nameoutput.Node(n),:) = (x(:,1) + 1j*x(:,2)).';
end





%% Cutting

for i = 1:5
    rxSymbols_cut(i,:) = circshift(rxSymbols(i,:),Reffered_Start_Samples(i));
    %circshift individual row by negative ammount, cut the last bits off.
end

rxSymbols_cut = rxSymbols_cut(:,1:end-NoSamplesCut);


%Zero Elements have to be replaced with 1 before referencing to that node.

rxSymbols_cut_Copy = rxSymbols_cut;
rxSymbols_cut_Copy(ref_node,rxSymbols_cut_Copy(ref_node,:)==0) = 1;


%Refference to specific node.
rxSymbols_cut_ref = rxSymbols_cut_Copy./rxSymbols_cut_Copy(ref_node,:);

end
