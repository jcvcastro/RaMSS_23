% NARMAX Demonstration -
% Competition


% Load data
load datacom.dat
y=datacom;

clear datacom;


% Generate set of candidate terms with: degree of nonlinearity=3,
% maximum lag for output terms=5 
l=3;
[Cand,tot2]=genterms(l,5);

% Add 20 linear noise terms, i.e. from e(k-1) to e(k-20), in
% order to avoid bias during parameter estimation.
Cand=[Cand;(3001:1:3020)' zeros(20,l-1)];

% Now we can proceed to the identification

for np=1:10
%[model,x,e,va]=orthreg(Cand,[],y,[np,20],3);

% Simulate the identified model
% We use 20 point of identification data as initial conditions.
ym=simodeld(model,[x(1,1)+0.112*np/10; x(2:60,1)],1000,y(1:20));

% In the above command
% model and x(:,1) selects respectively
% the terms (nine chosen process terms and all noise terms) 
% and their respective coefficients. y(1:20) are
% the initial conditions which have been taken from the original
% data, i.e. on the attractor.

figure(np);
plot(y(1:1995),y(6:2000),'y-',ym(1:995),ym(6:1000),'r-');

end;

break;

[Cand,tot2]=genterms(3,5);

Cand=[Cand;(3001:1:3020)' zeros(20,2)];

u=zeros(1500,1);

for np=13:25
[model,x,e,va]=orthreg(Cand,u,y,[np,20],5);

ym=simodeld(model,x(:,1),3000,y(1:20));

figure(np+2);plot(ym(300:size(ym)),shift_co(ym(300:size(ym)),8),'-');title('model spiral Tp=8 ny=5');

end;

[Cand,tot2]=genterms(3,6);

Cand=[Cand;(3001:1:3020)' zeros(20,2)];

u=zeros(1500,1);

for np=13:25
[model,x,e,va]=orthreg(Cand,u,y,[np,20],5);

ym=simodeld(model,x(:,1),u,y(1:20));

figure(np+15);plot(ym(300:size(ym)),shift_co(ym(300:size(ym)),8),'-');title('model spiral Tp=8 ny=6');

end;