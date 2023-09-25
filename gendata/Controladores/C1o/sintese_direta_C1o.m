
clear
% close all

%% Parametros do motor:

% Motor 0 (não me lembro de onde tirei isso)
%TODO: Olhar de onde foi que tirei esses dados. Se é do motor que tenho!
tipo_motor = '';
% Ke = 2.8;
% Kt = Ke;
% Ra = 0.8; % Ra parece ser muito pequena para ser do motorzinho que costumo usar!
% La = 1.13e-3;
% Jm = 0.2;
% Bm = 0.01;
%
% % Motor 1 Se não me engano são parâmetros do motor com encoder de 334ppr
% tipo_motor = 'b';
% Ke = .0253;     % Constante de F.C.E.M.
% Kt = Ke;        % Constante de torque
% Ra = 12;        % Resistencia de armadura
% La = 0.00216;   % Indutância de armadura
% Jm = 1.3e-6;    % Momento de inercia
% Bm = 4.175e-6;  % Coeficiente de atrito
% % Kg = 1/21;    % Razao de engrenagens

% Motor 2 (motor com encoder de 32ppr)
dados = dlmread('/home/joao/Documentos/GDRIVE/DOUTORADO/Subjects/VRFT/Codigos/Arduino/MotorVRFT/Reves/Motor_VRFT_identifica/Matlab/dados_oq_Ts5m.csv',',',1,0);
figure(10);
plot(1:length(dados),dados(:,1),'.',1:length(dados),dados(:,2),'x')
% /home/joao/Documentos/GDRIVE/DOUTORADO/Subjects/VRFT/Codigos/Arduino/MotorVRFT/Reves/Motor_VRFT_identifica/Matlab/
tipo_motor = 'c';
Ke = 11.87e-3;
Kt = Ke;
Ra = 33.37; % Ra parece ser muito pequena para ser do motorzinho que costumo usar!
La = 13.7e-3;
Jm = 1.33e-8;
Bm = 8.86e-7;



%% Criando Função de transferência:
s = tf('s');
Ga = 1/(La*s+Ra);
Gm = 1/(Jm*s+Bm);
G = feedback(Ga*Kt*Gm,Ke);

%% Discretizando:
% Ts = 0.002;
Ts = 0.005;
Gd = c2d(G,Ts)
z = tf('z',Ts)
%          0.01611 z + 0.0101
%  Gd =  ----------------------
%        z^2 - 1.169 z + 0.2427
figure(1);
clf;
step(Gd,'.');
title('Resposta ao degrau - Malha aberta')
ylabel('y(k)')

%% Projeto controlador

ts_values = [10*Ts 50*Ts];
for c=1:2

  %% Parametros desejados:
  MP = 0.1;    % Maximo sobressalto
  ts2 = ts_values(c); % Tempo de acomodacao

  xi = -log(MP)/sqrt(log(MP)^2+pi^2);  % MP = exp(-xi*pi/sqrt(1-xi^2))
  wn = 4/ts2/xi;
  wd = wn*sqrt(1-xi^2);
  modulo_z = exp(-xi*wn*Ts);
  fase_z = wd*Ts;

  pd1 = modulo_z*(cos(fase_z)+sin(fase_z)*1j);
  pd2 = conj(pd1);
  pd = [pd1; pd2]'

  pm = pole(Gd)                 % d polos do motor
  Tdtemp = zpk([],pd,1,Ts)      % reference model;

  K0 = 1/dcgain(Tdtemp);
  Td{2*c-1} = zpk([],pd,K0,Ts)      % reference model;
  Td{2*c} = zpk([],pd,K0*0.9,Ts)  % reference model;
  % Td{3} = zpk([],pd,K0*0.95,Ts) % reference model;

end

%% Projeto por sintese direta:
% Td = GC/(1+GC)
% Td+TdGC = GC
% Td = GC-TdGC
% Td = GC(1-Td)
% GC = Td/(1-Td)
% C = Td/G/(1-Td)
printARX(Gd,0,'u','y');
for i = 1:length(Td)
   C{i} = minreal(Td{i}/Gd/(1-Td{i}));
   fprintf(['\nC' num2str(i) ':\n']);
   % printARX(C{i},0);
   printARX(C{i},1,'e','u');
   % Somando os coeficientes de agrupamento de termos:
   Ctf{i} = tf(C{i});
   cat_u{i} = Ctf{i}.den{1}; cat_u{i} = cat_u{i}(2:end);
   atCso_u(i) = -sum(cat_u{i});
end

atCso_u % soma dos coeficientes de agrupamento de termos.

%%
figure(4); clf
   f=gcf;
   yd=step(Td{1});
   stairs(1:length(yd),yd, 'k:');
   % legenda = cell(length(C)+1);
   legenda = {'reference model'};
   hold on
   grid on
   linetype = {'bo', 'rx', 'k.', 'm+'};
   for i = 1:length(C)
      y = step(feedback(Gd*C{i},1),linetype{i});
      legenda{i+1} = ['C_1^' num2str(i)];
      plot(1:length(y),y,linetype{i});
   end
   xlabel('samples');
   ylabel('u(k)');
   ylim([0 1.4]);
   % legend(legenda, 'location', 'best');
   legend(legenda,'Location','NorthOutside','Orientation','horizontal','Box','off')
   % title('Resposta ao degrau do sistema controlado em malha fechada')
   %
   f.PaperSize = [7 4];
   figpath = './figs/';
   figname = ['C1', tipo_motor, '_ts20e100_Ts', Ts, 'm_time_response.pdf'];
   print([figpath figname], '-dpdf', '-fillpage');

   system(['pdf-crop-margins -mo ' figpath, figname])
   system(['pdftoppm -singlefile -png ', figpath figname, ' ', figpath 'png/' figname(1:end-4)])
   % print(['figs/C1_ts', num2str(ts2*1e3), '_Ts', num2str(Ts*1e3),...
   %   '_time_response.pdf'], '-dpdf', '-fillpage');

   g=figure(1);
   g.PaperSize = [7 4];
   figname = ['C1', tipo_motor, 'Ts' Ts, 'm_MA.pdf'];
   print([figpath figname], '-dpdf', '-fillpage');
   system(['pdf-crop-margins -mo ' figpath, figname])
   system(['pdftoppm -singlefile -png ', figpath figname, ' ', figpath 'png/' figname(1:end-4)])
