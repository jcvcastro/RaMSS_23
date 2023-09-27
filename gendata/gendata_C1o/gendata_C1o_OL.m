% Script to generate open loop data for Cs3:
%
% Cso3 controller:
%          0.96245 (z-0.8994) (z-0.2698)
% Cso3 = ----------------------------------
%        (z+0.6267) (z^2 - 1.432z + 0.5711)
%
% In this case controller poles are FAR from the unit circle (Cso3)
% Poles in: ( -0.6267, 0.9730 +- 0.0162i)
%
% JCVC 21/8/22
%
% NOTE: the 100ms in file title refers do 100 ms of settling time to reference
% model.

clear
savepath = '../../DATA23/SampledData/2309/';


for C=1:4
  disp(C);

seed = 24;
rng(seed);

% length of data set
N = 1500;
Nd = 200; % number of discarded samples;
% tempo de hold
b = 5;

Nmc = 4; % Number of Monte Carlo runs
Nnl = 5;  % Number of noise levels
%nlf = logspace(-5,-3,Nn); % noise factors
nmin = -3;
nmax = 1;

modelname = ['C1_', num2str(C), 'b', num2str(b) '_OL', ];

% input
% aux = (rand(N/b)*2-1)*0.1;
aux = (rand(N/b,1)*2-1)*1;   % referencia com dist. uniforme
% hold each value for b sampling times
e = zoh(aux,b);
clear aux

% null inicial conditions
u = zeros(N,1);
% initial conditions for the error are taken from the reference

for k = 4:N 
  u=C1controller(C,0,k,e,u);
end
u0 = u;
e0 = e;


u0std = std(u(Nd+1:end-1));


%% Adding noise at output (output error model):

if (Nnl==1) nmax = nmin; end
nlf = logspace(nmin,nmax,Nnl); % noise factors

nnlf = length(nlf);

un = cell(Nnl,Nmc);
en = cell(Nnl,Nmc);
noise = cell(Nnl,1);

for i=1:Nnl
  % null inicial conditions
  u = zeros(N,1);
  % e = zeros(N,1);
  % initial conditions for the error are taken from the reference
  for j=1:Nmc
    for k = 4:N
      u = C1controller(C,0,k,e,u);
    end
    noise = nlf(i)*u0std*randn(N,1); % generating noise (gaussian)
    u = u + noise;
    un{i,j} = u(Nd+1:end);
    en{i,j} = e(Nd+1:end);
  end
end

% True Regressors:
tregs = [1001; 1002; 1003; 2001; 2002; 2003]; % Cso1

%% Figures:

figure(1)
  subplot(2,1,1)
    plot(1:N,e0,'k',1:N,u0,'r')
    % set(gca,'FontSize',16)
    ylabel('e0(k), u0(r)')
    xlabel('samples')
    % axis([0 N -0.15 0.15]);
  subplot(2,1,2)
    myccf2([u0(Nd+1:end) e0(Nd+1:end)],20,1,1);
    % myccf2([u0(Nd+1:end)-mean(u0(Nd+1:end)) e0(Nd+1:end)-mean(e0(Nd+1:end))],20,1,1);

figure(2)
clf;
  for n = 1:Nnl
    subplot(Nnl,2,2*n-1)
      plot(1:N-Nd,en{n,1},'k',1:N-Nd,un{n,1},'r')
      ylabel('e(k), u(r)')
      % set(gca,'FontSize',16)
      xlabel('samples')
      % axis([0 N -0.15 0.15]);
    subplot(Nnl,2,2*n)
      % discarding the first 200 values (transiennts)
      myccf2([un{n,1} en{n,1}],20,1,1);
      % myccf2([u(Nd+1:end)-mean(u0(Nd+1:end)) e(Nd+1:end)-mean(e0(Nd+1:end))],20,1,1);
  end


%% Saving data:
% Structure to save:
simdata.e0 = e0(Nd+1:end);
simdata.u0 = u0(Nd+1:end);
simdata.e = en;
simdata.u = un;
simdata.u0std = u0std;

simdata.model.true_regs = tregs;
simdata.model.name = modelname;

simdata.noise.values = noise;
simdata.noise.levels = nlf;

simdata.parameters.n = N-Nd;
simdata.parameters.noisemin = nmin;
simdata.parameters.noisemax = nmax;
simdata.parameters.Nmc = Nmc;
simdata.parameters.Nnl = Nnl;
simdata.parameters.rng_seed = seed;


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


