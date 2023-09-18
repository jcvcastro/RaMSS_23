% NARMAX identification of the tank system

% dgree of nonlinearity
DG=10;
% number of (linear) noise terms
nnt=2;

% load data and normalize
%load desvios.dat;
y=Y';
ly=length(y);

ny=2;
% autonomous models
[Cand,tot2]=genterms(DG,ny);
Cand=[Cand;(3001:1:3000+nnt)' zeros(nnt,DG-1)];

lu=2000;
for np=10:10

[model,x,e,va]=orthreg(Cand,zeros(ly,1),y,[np 2],0);

Ym=simodeld(model,x(:,1),lu,y(1:ny));
figure(np);
plot(Ym(1:lu-1),Ym(2:lu),'.');
end;

% plot figure
t=1/1500:1/1500:1;
cinvert;
plot(t,Ym(1:1500),'r',Ym(1:1999),Ym(2:2000),'w.');


           0           0           0           0           0           0
        1001        1001        1001        1001        1001        1001
        1002        1002        1002        1002        1002        1002
        1002           0           0           0           0           0
        1001           0           0           0           0           0
        1001        1001        1001        1001        1001        1001
        1001        1001        1001        1001        1001        1001
        1001        1001           0           0           0           0
        1001        1001        1001        1001        1001        1001
        1001        1001        1001        1001        1001           0

  Columns 7 through 10 

           0           0           0           0
        1001        1001        1001        1001
        1002        1002        1002        1002
           0           0           0           0
           0           0           0           0
        1001        1001        1001           0
        1001        1001           0           0
           0           0           0           0
        1001           0           0           0
           0           0           0           0

x(1:10,1)

ans =

  4.0672e-002
 -6.4595e+003
 -3.0528e-002
  3.4341e-003
  9.9321e-001
  2.0621e+004
 -2.3470e+004
  1.5251e+001
  1.0096e+004
 -8.0546e+002
