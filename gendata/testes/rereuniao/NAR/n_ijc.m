% Job for ijc example


% Load data
%load ijc.dat
%y=ijc(:,2);
%u=ijc(:,1);
%t=ijc(:,1);
%clear ijc

% dgree of nonlinearity
DG=3;
% number of (linear) noise terms
nnt=10;

[Cand,tot2]=genterms(DG,1,1);
Cand=[Cand;(3001:1:3000+nnt)' zeros(nnt,DG-1)];
%Cand=mcand(Cand,2,1);
%Cand=mcand(Cand,1,2);
%Cand=mcand(Cand,0,3);
%Cand=mcand(Cand,0,2);
%[a,b]=size(Cand);
%Cand=Cand(2:a,:);
for np=6:6

  [model,x,e,va]=orthreg(Cand,u(1:500),y(1:500),[np 10],3);

  ym=simodeld(model,x(:,1),u(501:1000),y(501:510));

figure(np);plot(1:500,y(501:1000),'w-',1:500,ym,'w:');
disp(np)
0.02*(2-x(1,1))/(1-x(1,1))
end;
[a,b,c]=coefc(model(1:np,:),x(1:np,1));
