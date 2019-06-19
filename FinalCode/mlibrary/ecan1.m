%program name: e2can.m
%Example No.2  on can17820 : application of Music
%*****************************************************
%
can17820; %f=17820000; This has 16 different Rxx (of 64 samples); 
                       % and one Rxxtotal of 16*64 samples;
                       % array geometry : pusher;

Rxx=input('type Rxx1 or Rxx2 ... or Rxx16 or Rxxtotal:  ');   
            % the Rxxi means that the ith situation has 
            % been selected
            % Rxx=Rxx/max(Rxx(:));
array=toxyz(pusher);
%***************************************************** 
% Estimation of the  number of sources : M

figure(1);M=detect2(Rxx,64);                  

%*****************************************************

N=length(pusher(:,1));
h=0;	c=3*10^8;

%*****************************************************
% simulation mode: remove % from the following 5 lines
% sources=[30,0;50,6];M=length(sources(:,1));Rmm=eye(M,M);
% S=spv(array*2*f/c,[30,0;50,6]);
% Rxx=S*Rmm*S'+0.1*eye(N,N);
% figure(10);M=detect2(Rxx,1/eps);    
% Z=music(Rxx,array*2*f/c,M,1:5:360,0:5:90); 
%*****************************************************


Z=music270(Rxx,array*2*f/c,M,0:5:360,0:5:90);
plot2d3d(Z,0:5:360,0:5:90,'dB','MUSIC for can17820');