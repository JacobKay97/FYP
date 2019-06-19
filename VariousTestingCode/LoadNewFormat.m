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
folder = {folder(3:end).name; folder(3:end).folder};

folder_index = 12;
ChosenFolder = strcat('../NewData/', folder{folder_index}, '/*.mat');
ChosenFolder = strcat('../NewData//20190222/', folder{folder_index}, '/*.mat');

folder{folder_index}
%Gets all filenames
filenames = dir(ChosenFolder);
splitnames = cell(size(filenames, 1), 7); %For the split up filenames


%find a way to preallocate for multiple tests too?? or use cell array..

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



figure;
subplot(1,2,1);
plot(rad2deg(unwrap(angle(rxSymbols(startSample:endSample,:)))));
legend('1','2','3','4','5');
title('Phase, Pre Reference')
grid on;

subplot(1,2,2);
plot(rad2deg(unwrap(angle(rxSymbols_ref(startSample:endSample,:)))));
legend('1','2','3','4','5');
title('Phase, Node 1 = reference')
grid on;




%{
figure;
subplot(1,2,1);
plot(real(rxSymbols(startSample:endSample,:)));
legend('1','2','3','4','5');
title('Real, Pre Reference')
grid on;

subplot(1,2,2);
plot(real(rxSymbols_ref(startSample:endSample,:)));
legend('1','2','3','4','5');
title('Real, Node 1 = reference')
grid on;


figure;
subplot(1,2,1);
plot(imag(rxSymbols(startSample:endSample,:)));
legend('1','2','3','4','5');
title('Imag, Pre Reference')
grid on;

subplot(1,2,2);
plot(imag(rxSymbols_ref(startSample:endSample,:)));
legend('1','2','3','4','5');
title('Imag, Node 1 = reference')
grid on;

%}

%New ones:
%{

%New ones
figure;
subplot(1,2,1);
plot(rad2deg(angle(rxSymbols(startSample:endSample,:))));
legend('1','2','3','4','5');
title('Phase, Pre Reference')
grid on;

subplot(1,2,2);
plot(rad2deg(angle(rxSymbols_ref(startSample:endSample,:))));
legend('1','2','3','4','5');
title('Phase, Node 1 = reference')
grid on;


figure;
subplot(1,2,1);
plot(rad2deg(unwrap(angle(rxSymbols(startSample:endSample,:)))));
legend('1','2','3','4','5');
title('Phase, Pre Reference')
grid on;

subplot(1,2,2);
plot(rad2deg(unwrap(angle(rxSymbols_ref(startSample:endSample,:)))));
legend('1','2','3','4','5');
title('Phase, Node 1 = reference')
grid on;



figure;
subplot(1,2,1);
plot(rad2deg(unwrap(angle(rxSymbols_cut(startSample:endSample,:)))));
legend('1','2','3','4','5');
title('Phase cut, Pre Reference')
grid on;

subplot(1,2,2);
plot(rad2deg(unwrap(angle(rxSymbols_cut_ref(startSample:endSample,:)))));
legend('1','2','3','4','5');
title('Phase cut, Node 1 = reference')
grid on;



figure;
subplot(1,2,1);
plot(abs(rxSymbols(startSample:endSample,:)));
legend('1','2','3','4','5');
title('Mag, Pre Reference')
grid on;

subplot(1,2,2);
plot(abs(rxSymbols_ref(startSample:endSample,:)));
legend('1','2','3','4','5');
title('Mag, Node 1 = reference')
grid on;


figure;
subplot(1,2,1);
plot(abs(rxSymbols_cut(startSample:endSample,:)));
legend('1','2','3','4','5');
title('Mag cut, Pre Reference')
grid on;

subplot(1,2,2);
plot(abs(rxSymbols_cut_ref(startSample:endSample,:)));
legend('1','2','3','4','5');
title('Mag cut, Node 1 = reference')
grid on;


%}
