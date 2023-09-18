% Script to generate closed loop data for P1:
%          0.01611 z + 0.0101
%  P1 =  ----------------------
%        z^2 - 1.169 z + 0.2427
%
% with Cso3 controller:
%          0.96245 (z-0.8994) (z-0.2698)
% Cso3 = ----------------------------------
%        (z+0.6267) (z^2 - 1.432z + 0.5711)
%
% In this case controller poles are FAR from the unit circle (Cso3)
% Poles in: ( -0.6267, 0.9730 +- 0.0162i)
%
% JCVC 21/8/22

% WARN: Not seeing difference between these case (CsoTs30msxx_CL) to
% CsoTs100msxx_CL!


clear

scriptspath = '../';
addpath(scriptspath)
savepath = '../../DATA23/SampledData/2309/';

for C=1:4
  disp(C)

  seed = 24;
  rng(seed);

  % length of data set
  N = 1500;  % number off samples
  Nd = 200;  % number of discarded samples;
  b = 50;    % number off samples holded

  Nmc = 4;  % Number of Monte Carlo runs
  Nnl = 5;  % Number of noise levels
  nmin = -3; % noise minimum value (power of ten)
  nmax = 1;  % noise maximum value (power of ten)
  %nlf = logspace(-5,-3,Nn); % noise factors

  modelname = ['C1_', num2str(C), 'b', num2str(b) '_CL', ];

  % input
  % aux = (rand(N/b)*2-1)*0.1;
  % aux = (rand(N/b,1)*2-1)*500;   % referencia com dist. uniforme, entre -500 a 500 rad/s
  aux = (rand(N/b,1)*2-1)*1;   % referencia com dist. uniforme
  % hold each value for b sampling times
  r = zoh(aux,b);
  clear aux

  % null inicial conditions
  u = zeros(N,1);
  y = zeros(N,1);
  e = zeros(N,1);
  % initial conditions for the error are taken from the reference
  e(1:3) = r(1:3);

  for k = 5:N 
    % control law
    u = C1controller(C,1,k,e,u);
    % plant:
    %          0.01611 z + 0.0101
    %  Gd =  ----------------------
    %        z^2 - 1.169 z + 0.2427
    y(k) = 0.016112*u(k-1)+0.010097*u(k-2)+1.1692*y(k-1)-0.24268*y(k-2);

    % error:
    e(k) = r(k) - y(k);
  end
  u0 = u;
  e0 = e;
  y0 = y;


  y0std = std(y(Nd+1:end-1));
  u0std = std(u(Nd+1:end-1));


  %% Adding noise:

  if (Nnl==1), nmax = nmin; end
  nlf = logspace(nmin,nmax,Nnl); % noise factors

  nnlf = length(nlf);
  un = cell(Nnl,Nmc);
  en = cell(Nnl,Nmc);
  yn = cell(Nnl,Nmc);
  % noise = cell(Nnl,1);

  for i=1:Nnl
    % null inicial conditions
    u = zeros(N,1);
    y = zeros(N,1);
    e = zeros(N,1);
    % initial conditions for the error are taken from the reference
    e(1:2) = r(1:2);
    % noise{i} = randn(N/b,1)*nlf(i)*y0std;
    for j=1:Nmc
      for k = 5:N 

        % Controller:
        u = C1controller(C,1,k,e,u);

        % plant:
        %          0.01611 z + 0.0101
        %  P1 =  ----------------------
        %        z^2 - 1.169 z + 0.2427
        % y(k) = 1.169*y(k-1) - 0.2427*y(k-2) + 0.01611*u(k-1) + 0.0101*u(k-2);
        y(k) = 0.016112*u(k-1)+0.010097*u(k-2)+1.1692*y(k-1)-0.24268*y(k-2);

        % error and noise:
        noise = nlf(i)*randn*y0std;
        e(k) = r(k) - y(k) + noise;

      end
      un{i,j} = u(Nd+1:end);
      en{i,j} = e(Nd+1:end);
      yn{i,j} = y(Nd+1:end);
    end
  end

  % True Regressors:
  tregs = [1001; 1002; 1003; 2001; 2002; 2003]; % Cso;

  %% Figures:

  figure(1)
    subplot(3,1,1)
      plot(1:N,e0,'k',1:N,u0,'r')
      % set(gca,'FontSize',16)
      ylabel('e0(k), u0(r)')
      xlabel('samples')
      % axis([0 N -0.15 0.15]);
    subplot(3,1,2)
      plot(1:N,r,'g',1:N,y0,'b')
      % set(gca,'FontSize',16)
      ylabel('r(g), y0(b)')
      xlabel('samples')
      subplot(3,1,3)
      myccf2([u0(Nd+1:end) e0(Nd+1:end)],20,1,1);

  figure(2)
  for n = 1:Nnl
    subplot(Nnl,3,3*n-2)
      plot(1:N,e,'k',1:N,u,'r')
      ylabel('e(k), u(r)')
      % set(gca,'FontSize',16)
      xlabel('samples')
      % axis([0 N -0.15 0.15]);
    subplot(Nnl,3,3*n-1)
      plot(1:N,r,'g',1:N,y,'b')
      % set(gca,'FontSize',16)
      ylabel('r(g), y(b)')
      xlabel('samples')
      % axis([0 N -0.15 0.15]);
    subplot(Nnl,3,3*n)
      % discarding the first 200 values (transiennts)
      myccf2([u(Nd+1:end) e(Nd+1:end)],20,1,1);
  end

%NOTE: Caso antigo: soh plota ultimo caso de ruido.
% figure(2)
%   subplot(3,1,1)
%     plot(1:N,e,'k',1:N,u,'r')
%     ylabel('e(k), u(r)')
%     % set(gca,'FontSize',16)
%     xlabel('samples')
%     % axis([0 N -0.15 0.15]);
%   subplot(3,1,2)
%     plot(1:N,r,'g',1:N,y,'b')
%     % set(gca,'FontSize',16)
%     ylabel('r(g), y(b)')
%     xlabel('samples')
%     % axis([0 N -0.15 0.15]);
%   subplot(3,1,3)
%     % discarding the first 200 values (transiennts)
%     myccf2([u(Nd+1:end) e(Nd+1:end)],20,1,1);

  %% Saving data:
  % Structure to save:
  simdata.e0 = e0(Nd+1:end);
  simdata.u0 = u0(Nd+1:end);
  simdata.e = en;
  simdata.u = un;
  simdata.y = yn;
  simdata.u0std = u0std;
  simdata.y0std = y0std;

  simdata.model.true_regs = tregs;
  simdata.model.name = modelname;

  simdata.noise.values = noise;
  simdata.noise.levels = nlf;
  simdata.noise.stds = nlf*y0std;

  simdata.parameters.n = N-Nd;
  simdata.parameters.noisemin = nmin;
  simdata.parameters.noisemax = nmax;
  simdata.parameters.Nmc = Nmc;
  simdata.parameters.Nnl = Nnl;
  simdata.parameters.rng_seed = seed;

  warning('off','MATLAB:MKDIR:DirectoryExists'); % Turn off directory creating warning
  mkdir(savepath);
  savename = strcat(simdata.model.name, '-sampleddata_ni', num2str(abs(nmin), '%02d'),...
    'nx', num2str(abs(nmax), '%02d'), '_R', num2str(Nmc, '%02d'), 'N',...
    num2str(Nnl, '%02d'));
  save(strcat(savepath, savename, '.mat'), 'simdata')


  figure(2)
  f=gcf;
  f.PaperSize = [14 10];
  % disp(pathfig)
  namefig = savename;
  print(strcat(savepath, namefig, '.pdf'), '-dpdf', '-fillpage');
  savefig(strcat(savepath, namefig, 'fig'))

  %% Corta bordas das figuras
  system(['pdf-crop-margins -o ', savepath, ' -mo ', savepath, namefig '.pdf'])
  system(['rm ', savepath, namefig, '_uncropped.pdf'])

end

rmpath(scriptspath)


