% NARMAX Demonstration
%
% Modificado em 30/12/96 para trabalho da disciplina de estimacao
% de parametros e identificacao de sistemas
% Prof.: Luis A. Aguirre
% Aluno: Rubens M. Santos Filho
% -----------------------------------------------------------------

hold off;
clc;
clear all;
closeall;
echo on;

% Definição do modelo e parâmetros da estimação
% ---------------------------------------------

order = 2;    % ordem do polinomio
lagy  = 3;    % maximo atraso em y (saida)
lagu  = 3;    % maximo atraso em u (entrada)
lage  = 0;    % maximo atraso em e (ruido)
np    = 5;   % numero de termos do modelo
ne    = 20;   % numero de termos de ruido
N     = 5;    % numero de iteracoes                          
leny  = 2000; % numero de pontos do vetor de entrada

echo off;
disp (' ');

% Le dados
% --------

disp ('>>> Lendo dados...');
load acq7000.mat
u=acq7000(2,1:leny)'; 
y=acq7000(3,1:leny)'; 
u1=u;
y1=y;

clear acq7000;

% Display da massa de dados
% -------------------------

figure(1); subplot(211);
plot(y,'w-'); title('(a)'); ylabel('volts');
subplot(212); 
plot(u,'w-'); title('(b)'); ylabel('volts');
xlabel('samples');
long=input('Deseja uma simulacao detalhada? (sim=1): ');

y=y(1:1000);
u=u(1:1000);
umin=min(u);
umax=max(u);

% Verificar correlação cruzada entre sinais de entrada e saída
% ------------------------------------------------------------

if long==1,
  ruy=xcorr(y-mean(y),u-mean(u));
  figure(gcf+1);
  plot (ruy (length(ruy)/2 : 1 : length(ruy)) ); grid;
  title ('Correlação entre Entrada e Saída - xcorr(y,u)');
  clear ruy
  pause;
end; %end if long

% Verificar Autocorrelação do sinal de saída
% ------------------------------------------
 
ryy=xcorr(y-mean(y),y-mean(y));
figure(gcf+1); 
plot(ryy(length(ryy)/2:length(ryy))); grid;
title('Autocorrelação do sinal y(k) (Saída)');
clear ryy

% Entrar passo (Ts) de dizimação dos dados
% ----------------------------------------
% tm/25 < Ts < tm/5,  tm = ponto onde ocorreu o 1o. minimo em ryy

disp ('Clique sobre o primeiro mínimo do gráfico');
[tm,null] = ginput(1);
Ts = floor(tm/20); 
u=u(1:Ts:length(u));
y=y(1:Ts:length(y));

% Dados usados na validação
u3=u1(1000:Ts:2000);
y3=y1(1000:Ts:2000);
load acq6000.mat
u4=acq6000(2,1:Ts:leny)'; 
y4=acq6000(3,1:Ts:leny)'; 

disp(' ');


% Gera conjunto de termos candidatos
% ----------------------------------

disp ('>>> Gerando termos candidatos ...');
[Cand,tot2] = genterms(order,lagy,lagu);

% Add 20 linear noise terms, i.e. from e(k-1) to e(k-20), in
% order to avoid bias during parameter estimation.
% ----------------------------------------------------------

disp ('>>> Montando matriz dos termos candidatos ...');
Cand=[Cand; (3001:3000+ne)' zeros(ne,order-1)];

% eliminando clusters laa 11/11/97
if order ==1
 Cand=mcand(Cand,0,0);
end;
if order==2
% Cand=mcand(Cand,2,0);
% Cand=mcand(Cand,1,1);
% Cand=mcand(Cand,0,2);
end;
if order==3
 Cand=mcand(Cand,1,1);
 Cand=mcand(Cand,2,0);
 Cand=mcand(Cand,3,0);
 Cand=mcand(Cand,2,1);
 Cand=mcand(Cand,1,2);
% Cand=mcand(Cand,0,3);
end

% Procedendo à identificação
% --------------------------

for np=9:9
 
disp ('>>> Identificando ...');
disp (' ');
[model,x,e,va]=orthreg (Cand,u,y,[np,ne],N);

% Simulate the identified model
% We use 20 point of identification data as initial conditions.
% -------------------------------------------------------------



if long==1,
  disp ('>>> Simulando ...');
  ym=simodeld(model,x(:,1),u,y(1:ne));
  figure (gcf+1); plot(y); hold on; plot(ym,'b'); hold off;
  title ('Saídas Real (amarelo) e Estimada (azul) - "Acq7000"');
  pause;
end; 

% Resíduos
% --------

if long==1,
  figure (gcf+1);
  plot(e);
  title ('Resíduos');
  pause;


% Correlação cruzada entre os resíduos e o sinal de entrada
% ---------------------------------------------------------

  reu=xcorr(e-mean(e),u-mean(u));
  figure(gcf+1); 
  plot(reu);
  title('Xcorr(e,u)');
  pause;
end; % end if long

% Validação
% ---------

disp ('>>> Validando ...');

ym=simodeld(model,x(:,1),u3,y3(1:ne));
figure (gcf+1);subplot(211);
plot(ym,'w-.');
hold on;
plot(y3,'w-');
hold off;
%title ('Saídas Real (continuo) e Estimada (tracejado) - "Acq7000/2"');
title('(a)');
ylabel('volts');
%xlabel('samples');


ym4=simodeld(model,x(:,1),u4,y4(1:ne));
subplot(212);
plot(ym4,'w-.');
hold on;
plot(y4,'w-');
hold off;
%title ('Saídas Real (continuo) e Estimada (tracejado) - "Acq7000/2"');
title('(b)');
ylabel('volts');
xlabel('samples');
%end
%pause;


% static function determination

[y0,Y,Yc]=coefc(model(1:np,:),x(1:np,1));
uss=1:0.1:4;
if order==1
 pol=[Y(2,1) y0]/(1-Y(1,1));
end
if order==2
 pol=[Y(4,1) Y(3,1) y0]/(1-Y(1,1));
 %yss=(Y(4,1)*(uss.^2)+Y(3,1)*uss+y0)./(1-Y(1,1)-Yc(1,1)*uss);
 %plot(uss,yss,'w-');
end;
if order==3
 pol=[Y(6,1) Y(5,1) Y(4,1) y0]/(1-Y(1,1));
end;
yss(:,np)=polyval(pol,1:0.1:4)';
%yss(:,np)=((y0+Y(3,1).*uss)./(1-Y(1,1)-Yc(1,1).*uss))';
figure (gcf+1);
plot(uss,yss(:,np),'w-');


% steady-state simulation

%for uss=1:1:4
%  ym=simodeld(model,x(:,1),uss*ones(60,1),y3(1:ne));
%  Ym(uss,np)=ym(60);
%end;
%hold on;
%plot(1:4,Ym(:,np),'o');
%pause;

% theoretical steady state
hold on;
yss=32-8*[1:4];
plot(1:4,yss,'w-.');
% identification data limits
plot([umin umax],32-8*[umin umax],'wx');
hold off;
clear yss;
pause
end;

if long==10
  load acq6000.mat
  u2=acq6000(2,1:2000)'; 
  y2=acq6000(3,1:2000)'; 
  clear acq6000;

  u2=u2(1:Ts:length(u2));
  y2=y2(1:Ts:length(y2));

  ym=simodeld(model,x(:,1),u2,y2(1:ne));
  figure (gcf+1);
  hold on;

  plot(y2(1:length(y2)/2));
  plot(ym(1:length(ym)/2),'g');
  title ('Saídas Real (amarelo) e Estimada (verde) - "Acq6000/1"');
  pause;

  figure(gcf+1); hold on;
  plot(y2(length(y2)/2:length(y2)));
  plot(ym(length(ym)/2:length(ym)),'g');
  title ('Saídas Real (amarelo) e Estimada (verde) - "Acq6000/2"');
  hold off;

% Mostra Parâmetros
% -----------------

  disp (' ');
  format short e;
  disp ('[Modelo  Coeficientes err std]');
  [model(1:np,:)  x(1:np,:)]
  format;
end; %end if long

end; % end loop np