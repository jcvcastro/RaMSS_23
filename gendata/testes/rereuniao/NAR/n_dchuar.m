% NARMAX Demonstration -
% Chua Circuit - Double Scroll Atractor 
% Simulation - 05/02/95
% Real Data  - 05/10/95
% Spiral Atractor - 06/21/95

echo on;

% Load data
load dspvc1f.mat
y=yf(1:5:7500);

clear yf;

%Original model simulation
%figure(1);plot(y,shift_co(y,4),'-');title('Original Tp=4');

% Generate set of candidate terms with: degree of nonlinearity=3,
% maximum lag for output terms=5 
[Cand,tot2]=genterms(3,5);

% Add 20 linear noise terms, i.e. from e(k-1) to e(k-20), in
% order to avoid bias during parameter estimation.
Cand=[Cand;(3001:1:3020)' zeros(20,2)];

% Creating the vector of inputs
u=zeros(1500,1);

% Now we can proceed to the identification

%for np=15:30
[model,x,e,va]=orthreg(Cand,u,y,[23,20],5);

clear Cand;
disp('ok');

% Simulate the identified model
% We use 20 point of identification data as initial conditions.
ym=simodeld(model,x(:,1),2000,y(1:20));

% In the above command
% model and x(:,1) selects respectively
% the terms (nine chosen process terms and all noise terms) 
% and their respective coefficients. y(1:20) are
% the initial conditions which have been taken from the original
% data, i.e. on the attractor.
figure(np-8);plot(ym(300:size(ym)),shift_co(ym(300:size(ym)),4),'-');title('model vc1 Tp=4 ny=4 np=');
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