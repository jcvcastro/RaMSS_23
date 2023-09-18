% pre-anaise dos dados de Joao
% agora na ordem certa dos sinais
% LAA 7/121

close all
clear

% carrega os dados
load DADOS_1aOrdem.dat;
e=DADOS_1aOrdem(:,1); % erro de acionamento (entrada)
m=DADOS_1aOrdem(:,2); % acao de controle (saida)

figure(1)
subplot(211)
plot(1:length(e),e);
ylabel('e')
subplot(212)
plot(1:length(m),m);
ylabel('m')
xlabel('k')

%%
% veriuficacao do tempo de amostragem

figure(2)
mvt_ts(m);

% toleravel. Mas a entrada poderia ser um pouco mais lenta.
% alguma nao linearidade eh visivel... 

% Calculo da FAC
[t,r,l]=myccf([m e],40,1,0,'k');
figure(3)
stem(t,r,'k');
hold on
plot([t(1) t(end)],[l l],'k',[t(1) t(end)],[-l -l],'k');
hold off

% temos problemas de causalidade. Note que ha correlacoes para
% atrasos negativos. Acredito que isto seja resultado da
% realimentacao (?? verificar). Farei um ajuste de 2 amostras,
% mas note que ainda haverah um bocado de correlacao do lado esquerdo...
%% identificacao
% os dados de identificacao serao de 100 a 700
% COM remocao dos niveis medios
% vou atrasar o sinal de saida em relacao ao de entrada por 2 amostras,
% na mao...

ei=e(102:700)-mean(e(102:700));
mi=m(100:698)-mean(m(100:698));

% dados de validacao de 701 a 1000
ev=e(703:1000)-mean(e(703:1000));
mv=m(701:998)-mean(m(701:998));

% definicao de metaparametros
DG=2; % grau de nao linearidade
ny=3; % maximo atraso em m
nu=7; % maximo atraso em e

% sem termos de ruido => modelo NARX
[Cand,tot2]=genterms(DG,ny,nu);

mape=[];
for np=2:6
  [model,x,E,va]=orthreg(Cand(2:end,:),ei,mi,[np 0],0); 
  [npr,nno,lag,nny,nnu,nne,newmodel] = get_info(model);
  ym=simodeld(model,x(:,1),ev,mv(1:lag)); 

  % mean absolute percentual error
  mape(np)=(sum(abs(mv-ym))/(std(mv)*length(mv)))*100;
  figure(np)
  plot(1:length(ym),ym,1:length(mv),mv,'k');
end
mape_arx=mape;
