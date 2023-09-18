%y=sdpi60(1:1900,2);
DG=3;
ny=5;
% number of (linear) noise terms
nnt=20;
[a b]=size(y);
if b>a,
  y=y';
end;
u=zeros(max([a b]),1);

% Generate set of candidate terms with: degree of nonlinearity=3,
% maximum lag for output terms=3, and 
% maximum lag for input terms=3.
[Cand,tot2]=genterms(DG,ny);
% Add 20 linear noise terms, i.e. from e(k-1) to e(k-20), in
% order to avoid bias during parameter estimation.
%Cand=[Cand(2:tot2,:);(3001:1:3000+nnt)' zeros(nnt,DG-1)];
Cand=[Cand;(3001:1:3000+nnt)' zeros(nnt,DG-1)];

% In most cases cross-product noise terms and nonlinear noise terms
% are not necessary.

% range for evaluating the static nonlinearity
%rg=-1.2*pi:pi/50:pi*1.2;
%rg=0:pi/50:pi;
%rg=22:0.25:34;
%rg=0:0.05:1;

for np=23:23

[a,b]=size(Cand);
% Now we can proceed to the identification
[model,x,e,va]=orthreg(Cand(1:a,1:b),u,y,[np nnt],5);

%[x(1:np,1) model(1:np,1:DG)];
%[s0,sy,lixo]=coefc(model(1:np,1:DG),x(1:np,1));

%S0(np)=s0;
%Sy(np)=sy(1,1);
%Sy2(np)=sy(2,1);
%Sy3(np)=sy(3,1);

% Clustered polynomial
% Sy3*y^3+Sy2*y^2+(Sy-1)*y+S0=0
% The fixed points are given by the roots of this polynomial
% cp=[Sy3(np) Sy2(np) (Sy(np)-1) S0(np)];
% fp(1:DG,np)=roots(cp)
% The static nonlinearity is given by this polynomial
% Cp=[Sy3(np) Sy2(np) Sy(np) S0(np)];
% Cpv=polyval(Cp,rg);
%figure(4);
%plot(rg,Cpv,y(1:499),y(2:500),'.');
%pause;

%disp('ok');pause;

% Simulate the identified model
ym=simodeld(model,x(:,1),1500,y(1:nnt));
%figure(np);
%plot(rg,Cpv,y(1:499),y(2:500),'.',ym(nnt+1:499),ym(nnt+2:500),'.');
%plot(y(1:499),y(2:500),'.',ym(1:499),ym(2:500),'.');
%figure(5)
%plot(ym);
%pause

% In the above command
% model and x(:,1) selects respectively
% the terms (nine chosen process terms and all noise terms) 
% and their respective coefficients. y(1:20) are
% the initial conditions which have been taken from the original
% data, i.e. on the attractor.

% MPO (or free-run) comparison

%figure(1);plot(ym);
%figure(2);plot(ym(1:499),ym(2:500),'.');
%plot(ym(1:499),ym(2:500),'.');
%pause;

end;

% pause;

figure(11);
plot(1:np,[S0' Sy' Sy2' Sy3']);
figure(12);
subplot(221);
plot(1:np,S0(1:np),'-w');
title('(a)');
subplot(222);
plot(1:np,Sy(1:np),'-w');
title('(b)');
subplot(223);
plot(1:np,Sy2(1:np),'-w');
title('(c)');
xlabel('np');
subplot(224);
plot(1:np,Sy3(1:np),'-w');
title('(d)');
xlabel('np');

%figure(13)
%plot(1:np,fp(:,1:np));