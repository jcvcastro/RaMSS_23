% Script to test the ERR performance in connection with the identification
% of Cm from closed loop data

% LAA 4/1/22
% modified to Cm model JCVC 8/22

%
close all
clear

% length of data set
N = 1200;

% tempo de hold
b = 50;

% input
aux = (rand(N/b,1)*2-1)*1;   % referencia com dist. uniforme

% hold each value for b sampling times
r = zoh(aux,b);
clear aux

% null inicial conditions
u = zeros(N,1);
y = zeros(N,1);
e = zeros(N,1);
% initial conditions for the error are taken from the reference
e(1:2) = r(1:2);

% model C_2, plant P_2
% here the input is e(k) and the output is u(k)

for k = 4:N 
  % control law :
  % u(k-1) =  0.101100*e(k-1) - 0.118200*e(k-2) + 0.024530*e(k-3) + 1.945000*u(k-2) - 0.945000*u(k-3); % 1o caso (Relatorios 1 e 2 de maio 22)
  u(k-1) =  0.101100*e(k-1) - 0.118200*e(k-2) + 0.024530*e(k-3) + 1.944900*u(k-2) - 0.945000*u(k-3); %  (poles: 0.9981, 0.9468)
 
  % plant:
  %          0.01611 z + 0.0101
  %  Gd =  ----------------------
  %        z^2 - 1.169 z + 0.2427
  y(k) = 1.169*y(k-1) - 0.2427*y(k-2) + 0.01611*u(k-1) + 0.0101*u(k-2);
  % error:
  e(k) = r(k) - y(k);
end

stdy = std(y);

figure(1)
plot(1:N,e,'k',1:N,u,'b')
set(gca,'FontSize',16)
xlabel('samples')
% axis([0 N -0.15 0.15]);

figure(2)
% discarding the first 200 values (transiennts)
myccf2([u(201:end) e(201:end)],20,1,1);

figure(3)
plot(1:N,r,'k',1:N,y,'b')
set(gca,'FontSize',16)
xlabel('samples')
axis([0 N -0.15 0.15]);
%% Identificacao de C2

DG=3;		% Degree of nonlinearity.
lagy=6;		% Maximum lag of the output signals.
lagu=6;		% Maximum lag of the input signals.
lage=0;		% Maximum lag of the noise signals.
lnt=1;		% Number of linear noise terms.

[Cand,tot2] = genterms2(DG,lagy,lagu);
Cand=[Cand;(3101:1:(3100+lnt))' zeros(lnt,(DG-1))];

nprmd=12;	% Number of "process" and "noise" terms in the 
nnomd=0;	% model that should be used during parameter
		    % estimation.
ni=0;		% Noise iterations to be performed.

Nmc = 30; % Number of Monte Carlo runs
Nn = 10  % Number of noise levels
%ruido = logspace(-5,-3,Nn); % noise factors
ruido = logspace(-5,0.5,Nn); % noise factors

uk1 = zeros(Nmc,1);
uk2 = zeros(Nmc,1);
ek = zeros(Nmc,1);
ek1 = zeros(Nmc,1);
ek2 = zeros(Nmc,1);
nota = zeros(Nmc,Nn);

% noise loop
for j = 1:Nn
    disp(j)
    
    
    
% Monte Carlo loop
for MC = 1:Nmc

  % input
  aux = (rand(N/b,1)*2-1)*1;   % referencia com dist. uniforme

  % hold each value for b sampling times
  r = zoh(aux,b);
  % model C_2, plant P_2
  % here the input is e(k) and the output is u(k)
  for k = 4:N 
    % control law :
    % u(k-1) =  0.101100*e(k-1) - 0.118200*e(k-2) + 0.024530*e(k-3) + 1.945000*u(k-2) - 0.945000*u(k-3); % 1o caso (Relatorios 1 e 2 de maio 22)
    u(k-1) =  0.101100*e(k-1) - 0.118200*e(k-2) + 0.024530*e(k-3) + 1.944900*u(k-2) - 0.945000*u(k-3); %  (poles: 0.9981, 0.9468)

    % plant:
    %          0.01611 z + 0.0101
    %  Gd =  ----------------------
    %        z^2 - 1.169 z + 0.2427
    y(k) = 1.169*y(k-1) - 0.2427*y(k-2) + 0.01611*u(k-1) + 0.0101*u(k-2);
    % error:
    e(k) = r(k) - y(k);
  end
  [model,x,ME,va]=orthreg(Cand,e(201:end),u(201:end),[nprmd nnomd],ni);

  % regressor ranking
  for i = 1:nprmd
    % regressor u(k-1): 1001 0 0
    if model(i,1) == 1001 & model(i,2) == 0 & model(i,3) == 0
      uk1(MC) = i;   
      if i< 5 % if regressor is among the first 5
        nota(MC,j) = 0.2;
      else
        nota(MC,j) = 0.2*0.8^(i-5);
      end
    else
      % regressor u(k-2): 1002 0 0 
      if model(i,1) == 1002 & model(i,2) == 0 & model(i,3) == 0
        uk2(MC) = i;
        if i< 5 % if regressor is among the first 5
          nota(MC,j) = nota(MC,j) + 0.2;
        else
          nota(MC,j) = nota(MC,j) + 0.2*0.8^(i-5);
        end
      else
        % regressor e(k): 2000 0 0
        if model(i,1) == 2000 & model(i,2) == 0 & model(i,3) == 0
          ek(MC) = i;  
          if i< 5 % if regressor is among the first 5
            nota(MC,j) = nota(MC,j) + 0.2;
          else
            nota(MC,j) = nota(MC,j) + 0.2*0.8^(i-5);
          end
        else
          % regressor e(k-1): 2001 0 0
          if model(i,1) == 2001 & model(i,2) == 0 & model(i,3) == 0
            ek1(MC) = i;  
            if i< 5 % if regressor is among the first 5
              nota(MC,j) = nota(MC,j) + 0.2;
            else
              nota(MC,j) = nota(MC,j) + 0.2*0.8^(i-5);
            end
          else
            % regressor e(k-2): 2002 0 0
            if model(i,1) == 2002 & model(i,2) == 0 & model(i,3) == 0
              ek2(MC) = i;  
              if i< 5 % if regressor is among the first 5
                nota(MC,j) = nota(MC,j) + 0.2;
              else
                nota(MC,j) = nota(MC,j) + 0.2*0.8^(i-5);
              end
            end
          end
        end
      end
    end
  end % end for loop (regressor ranking)

% end Monte Carlo loop
end

% end noise loop
end

%%

% nota media
nm = mean(nota);
% desvio padrao
ns = std(nota);

figure(3)
semilogx(100*ruido,nm,'ko',100*ruido,nm+ns,'k+',100*ruido,nm-ns,'k+');
set(gca,'FontSize',16)
xlabel('100 x std(noise)/std(signal)');
ylabel('index');
axis([0.0005 1000 -0.2 1.2])

print -depsc2 MfCm.eps
% print -depsc2 MfCm_wide.eps

