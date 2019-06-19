% Program for testing the array calibration function calibr4.m
% The following two functions from the "ARRAY TOOLBOX" are used
% music270.m and plot2d3d.m.
% Reference: .........
% written by: Dr A.Manikas
% date: 24 May 94
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear all;format compact;
load specs;
c=3*10^8;
ELarea=0:2:10;
AZarea=0:1:180;

%%%%%%%%%%%%%%%%calibration (4th algorithm)%%%%%%%%%%%%%%%%%%%%%%%
pilots(:,1)=270-pilots(:,1);
[esensors,egain,ephase]=calibr4([Rxx1,Rxx2,Rxx3],pilots,FQ,array,100*ones(8,3),zeros(8,3));

%%%%%%%%%%%%%%%%music with uncalibrated array (1st signal)%%%%%%%%%%%%%%%%%%%%%
Z=music270(Rxx1,array*2*FQ(1)/c,1,AZarea,ELarea); 
plot2d3d(Z,AZarea,ELarea,'music270','uncalibrated array for Rxx1'); 
pause;

%%%%%%%%%%%%%%%%music with calibrated array (1st signal)%%%%%%%%%%%%%%%%%%%%%
Z1=music270(Rxx1,esensors*2*FQ(1)/c,1,AZarea,ELarea,[],egain(:,1),ephase(:,1));
plot2d3d(Z1,AZarea,ELarea,'music270, with gain & phase i/p','calibrated array for Rxx1');         

dB1=[max(Z(:))-min(Z(:)),max(Z1(:))-min(Z1(:)),-(max(Z(:))-min(Z(:)))+max(Z1(:))-min(Z1(:))]
pause;

%%%%%%%%%%%%%%%%music with uncalibrated array (2nd signal)%%%%%%%%%%%%%%%%%%%%%
Z=music270(Rxx2,array*2*FQ(1)/c,1,AZarea,ELarea); 
plot2d3d(Z,AZarea,ELarea,'music270','uncalibrated array for Rxx2');                   
pause;

%%%%%%%%%%%%%%%%music with calibrated array (2nd signal)%%%%%%%%%%%%%%%%%%%%%
Z1=music270(Rxx2,esensors*2*FQ(1)/c,1,AZarea,ELarea,[],egain(:,2),ephase(:,2));
plot2d3d(Z1,AZarea,ELarea,'music270, with gain & phase i/p','calibrated array for Rxx2');         

dB2=[max(Z(:))-min(Z(:)),max(Z1(:))-min(Z1(:)),-(max(Z(:))-min(Z(:)))+max(Z1(:))-min(Z1(:))]
pause;

%%%%%%%%%%%%%%%%music with uncalibrated array (3rd signal)%%%%%%%%%%%%%%%%%%%%%
Z=music270(Rxx3,array*2*FQ(1)/c,1,AZarea,ELarea); 
plot2d3d(Z,AZarea,ELarea,'music270 ','uncalibrated array for Rxx3');                   
pause;

%%%%%%%%%%%%%%%%music with calibrated array (3rd signal)%%%%%%%%%%%%%%%%%%%%%
Z1=music270(Rxx3,esensors*2*FQ(1)/c,1,AZarea,ELarea,[],egain(:,3),ephase(:,3));
plot2d3d(Z1,AZarea,ELarea,'music270, with gain & phase i/p','calibrated array for Rxx3');         

dB3=[max(Z(:))-min(Z(:)),max(Z1(:))-min(Z1(:)),-(max(Z(:))-min(Z(:)))+max(Z1(:))-min(Z1(:))]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dBs=[dB1;dB2;dB3]
%%%%Note%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% music.m rather than music270 can be used but with plot2d3d called as follows:
% plot2d3d(Z,270-AZarea,ELarea,.....................


