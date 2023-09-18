% pre-anaise dos dados de Joao
% LAA 7/121

close all
clear

% carrega os dados
load DADOS_1aOrdem.dat;
y=DADOS_1aOrdem(:,1);
u=DADOS_1aOrdem(:,2);

figure(1)
subplot(211)
plot(1:length(u),u);
ylabel('u')
subplot(212)
plot(1:length(y),y);
ylabel('y')
xlabel('k')

%%
% verificacao do tempo de amostragem

figure(2)
mvt_ts(y);

% toleravel. Mas a entrada poderia ser um pouco mais lenta.
% alguma nao linearidade eh visivel...

% Calculo da FAC
[t,r,l]=myccf([y u],40,1,0,'k');
figure(3)
stem(t,r,'k');
hold on
plot([t(1) t(end)],[l l],'k',[t(1) t(end)],[-l -l],'k');
hold off

% temos problemas de causalidade. Note que ha correlacoes para
% atrasos negativos de u. Acredito que isto seja resultado da
% realimentacao (?? verificar).
%% identificacao
% os dados de identificacao serao de 100 a 700
% sem remocao dos niveis medios, por enquanto
% vou atrasar o sinal de saida em relacao ao de entrada por 4 amostras,
% na mao...

ui=u(104:700);
yi=y(100:696);

% dados de validacao de 701 a 1000
uv=u(705:1000);
yv=y(701:996);

% definicao de metaparametros
DG=2; % grau de nao linearidade
ny=3; % maximo atraso em y
nu=8; % maximo atraso em u

% sem termos de ruido => modelo NARX
[Cand,tot2]=genterms(DG,ny,nu);

%FIX: Cálculo de simodeld dando problemas, desativado por enquanto:
%
% mape=[];
% for np=2:6
%   [model,x,e,va] = orthreg(Cand(2:end,:),ui,yi,[np 0],0);
%   [npr,nno,lag,nny,nnu,nne,newmodel] = get_info(model);
%   noise = zeros(length(yi),1);
%   ym = simodeld(model,x(:,1),uv,yv(1:lag),noise(1:lag));
%
%   % mean absolute percentual error
%   mape(np)=(sum(abs(yv-ym))/(std(yv)*length(yv)))*100;
%   figure(np)
%   plot(1:length(ym),ym,1:length(yv),yv,'k');
% end
% mape_arx=mape;
