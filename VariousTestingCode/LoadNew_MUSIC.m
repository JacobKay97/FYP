%Read the csv files, gather info from file name, then run stuff on said
%data I read in.

%Node_N_I_time_A_time

clear;
%close all;
%% Paramaters

CHUNKSIZE = 192000;
CHUNKCOUNT = 5;
NOSAMPLES = CHUNKSIZE*CHUNKCOUNT;
N = 5;

%% Loading Code

folder = dir('../NewData');
folder = dir('../NewData/20190222');
folder = {folder(3:end).name};

folder_index = 11;
ChosenFolder = strcat('../NewData/', folder{folder_index}, '/*.mat');
ChosenFolder = strcat('../NewData//20190222/', folder{folder_index}, '/*.mat');

folder{folder_index}
%Gets all filenames
filenames = dir(ChosenFolder);
splitnames = cell(size(filenames, 1), 7); %For the split up filenames

for n = 1:size(filenames, 1)    %Splits the filenames up using _ as a divider
    splitnames(n,1:7) = split(filenames(n).name, {'_','.mat'});
end
splitnames = splitnames(:, [2,4,6]);

nameoutput = splitnames;
nameoutput = cell2table(nameoutput,'VariableNames', {'Node', 'IntendedT', 'StartT'});
nameoutput.Node = str2double(nameoutput.Node);
nameoutput.IntendedT = str2double(nameoutput.IntendedT);
nameoutput.StartT = str2double(nameoutput.StartT);

rxSymbols = zeros(N, NOSAMPLES);


%% Timing stuff
IntendedTime = nameoutput.IntendedT;
StartT = nameoutput.StartT;

Delta_t = StartT - IntendedTime;

Reffered_Intend = IntendedTime - IntendedTime(1);
Reffered_Start = StartT - StartT(1);

time_step = 1/CHUNKSIZE;


Reffered_Start_Samples = Reffered_Start./time_step;
Reffered_Start_Samples = round(Reffered_Start_Samples + abs(min(Reffered_Start_Samples)));
NoSamplesCut = max(Reffered_Start_Samples);

rxSymbols_cut = zeros(N, NOSAMPLES);


for n = 1:size(filenames,1)
    load(strcat(filenames(n).folder,'\',filenames(n).name));
    rxSymbols(nameoutput.Node(n),:) = x;
end



%% Cutting

for i = 1:5
    rxSymbols_cut(i,:) = circshift(rxSymbols(i,:),-Reffered_Start_Samples(i));
    %circshift individual row by negative ammount, cut the last bits off.
end


rxSymbols_cut = rxSymbols_cut(:,1:end-NoSamplesCut);
rxSymbols_cut_ref = rxSymbols_cut./rxSymbols_cut(1,:);
rxSymbols_cut = rxSymbols_cut.';
rxSymbols_cut_ref = rxSymbols_cut_ref.';


NoSamplesPlot = 192000;
%NoSamplesPlot = 500;


startSample = 00001;
endSample = startSample + NoSamplesPlot;
%Reference to Node 0.

rxSymbols_ref = rxSymbols./rxSymbols(1,:);

rxSymbols = transpose(rxSymbols);
rxSymbols_ref = transpose(rxSymbols_ref);


SV = rxSymbols_ref.';
SV = rxSymbols_cut.';

array = [-2,0,0;-1,0,0;0,0,0;1,0,0;2,0,0];
%load("C:\Users\Jacob Kay\OneDrive\Documents\Year 4\FYP\NewData\OldTechnique_90\Data_ROS_90_PLANAR.mat");
%SV = X;

Rxx=SV*SV'/length(SV);L=length(SV);

  figure(1); M = detect2(Rxx,L);  
  fprintf('the number of sources is: '),M
 M = 1;

Azarea=0:1:180; Elarea=0:2:90;
%Z=music270(Rxx,array,M,Azarea,Elarea);
Z_2 = music(Rxx,array,M,Azarea, 0);
%plot2d3d(Z,Azarea,Elarea);
plot(Azarea,Z_2);
%BestDirections=minnmatr(-Z,Azarea,Elarea,5);