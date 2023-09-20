%% Disabling warnings
clear
warn = "off";
warning(warn,'MATLAB:nearlySingularMatrix');
warning(warn,'MATLAB:singularMatrix');
warning(warn,'MATLAB:illConditionedMatrix');
warning(warn,'MATLAB:rankDeficientMatrix');
warning off

%cd '~/Documentos/GDRIVE/DOUTORADO/GIT/RaMSS_mat/'
%clc

scriptspath = '../../RaMSS_mat/';
% addpath(scriptspath)

%% Loading data
% sampled_data_path = "~/DOUTORADO/GIT/RaMSS_mat/DATA/Sampled/0829/";
sampled_data_path = "../DATA23/SampledData/2309/";
% Controler (1) cases:
% 2nd order linear controller to control a 2n order minimum phase process.
%   The controller is projected using direct syntesis to result to same
%   transitory behaviour, but with differrent final values cases, as follows:
% Cases:
%   1 -> ts2 = 10 ms,  0% ESS
%   2 -> ts2 = 10 ms, 10% ESS
%   3 -> ts2 = 50 ms,  0% ESS
%   4 -> ts2 = 50 ms, 10% ESS
% Model name structure:
%   C1_cbx_XX
%   -- - - --
%    | | | |
%    | | | +-------> (XX): Open Loop (OL) or Closed Loop (CL)
%    | | +---------> (x) : holded samples to generate excitation signal
%    | +-----------> (c) : Case of controller (see above)
%    +-------------> (C1): Linear Controller
% Valid modelnames: C1_cbx_XX, with c = {1-4}; x = {1,-2,-3,-4}; and LL = {OL, CL};
% the modelnames variables is a cell with any nymber of this modelanmes.
% modelsnames = {'C1_1b2_CL', 'C1_2b3_CL', ... };
modelsnames = {...
  'C1_1b1_OL'  , 'C1_2b1_OL'  , 'C1_3b1_OL'  , 'C1_4b1_OL'  , ...
  'C1_1b2_OL'  , 'C1_2b2_OL'  , 'C1_3b2_OL'  , 'C1_4b2_OL'  , ...
  'C1_1b5_OL'  , 'C1_2b5_OL'  , 'C1_3b5_OL'  , 'C1_4b5_OL'  , ...
  'C1_1b10_OL' , 'C1_2b10_OL' , 'C1_3b10_OL' , 'C1_4b10_OL' , ...
  'C1_1b50_OL' , 'C1_2b50_OL' , 'C1_3b50_OL' , 'C1_4b50_OL' , ...
  'C1_1b1_CL'  , 'C1_2b1_CL'  , 'C1_3b1_CL'  , 'C1_4b1_CL'  , ...
  'C1_1b2_CL'  , 'C1_2b2_CL'  , 'C1_3b2_CL'  , 'C1_4b2_CL'  , ...
  'C1_1b5_CL'  , 'C1_2b5_CL'  , 'C1_3b5_CL'  , 'C1_4b5_CL'  , ...
  'C1_1b10_CL' , 'C1_2b10_CL' , 'C1_3b10_CL' , 'C1_4b10_CL' , ...
  'C1_1b50_CL' , 'C1_2b50_CL' , 'C1_3b50_CL' , 'C1_4b50_CL' , ...
  };

% sampleddatafilename name convention:
% -> ni: 10th NEGATIVE power expoent for minimum noise (in the data);
% -> nx: 10th POSITIVE power expoent for maximum noise (in the data);
% -> R##: number (##) of monte Carlo realizations;
% -> N##: number (##) of monte noise levels;
%
%
% sampleddatafilename = "sampleddata_ni04nx01_R04N05.mat";
% sampleddatafilename = "sampleddata_ni04nx04_R04N01.mat";
sampleddatafilename = "sampleddata_ni03nx01_R04N05.mat";


% Caso C2
% modelsnames = {'C2_OL'};
% sampleddatafilename = "sampleddata_ni04nx01_R04N05.mat";
% sampleddatafilename = "sampleddata_ni04nx01_R30N20.mat";

%% Initial parameters (RaMSS)

savedir = '../DATA23/RaMSS/2309/';
% savedir = '~/DATA/RaMSS/230106/';
estimatortypes = {'IV'}; % Valid: LS: ord. least Square; IV: Instrumental Variables;
alphacases = [0 0.3 0.6 1];

mlagu = 6
mlage = 6
dg = 3

%----- Teste:
%sampleddatafilename = "sampleddata_ni04nx01_R30N10.mat";
%alphacases = [0.5];
%mlagu = 3
%mlage = 3
%dg = 1;
%-----  Fim do teste!


nm = 100  % Number of candidate structures (models)
ni = 50  % Maximum Number of RaMSS iterations
K = 1
minrip = 0.10
maxrip = 1
g = 2
% alpha = 0
ptst = 0.975;  % percentile of t-student test (for 95% ci?);
rem_red = true;
parallel = true;
SAVEDATA = true;

necases = length(estimatortypes);

files = strcat(modelsnames, '-', sampleddatafilename)
nccases = length(files);
ntr = 1000;

%% progressbar:
if (parallel)
  % progressbar('Alpha cases', 'Controller cases', 'Noise cases') % Init 2 bars
  progressbar('Controller cases', 'Alpha cases', 'Estimator cases', 'Noise cases') % Init 2 bars
else
  progressbar('Controller cases', 'Alpha cases', 'Estimator cases', 'Noise cases','Monte Carlo Trials','RaMSS iterations') % Init 3 bars
end

tic;
et = 0;    % elipsed time
etold = 0; % elipsed time old

%% Loops:

nacases = length(alphacases);
for c = 1:nccases   % controller cases
  for a = 1:nacases % "a" value cases
    alpha = alphacases(a)
    load(strcat(sampled_data_path, files{c}));
    modelname = simdata.model.name;

    for e = 1:necases
      fprintf("\na = %.1f case (%d/%d), %s controller (%d/%d), %s estimator (%d/%d):\n=================\n",...
        alphacases(a), a, nacases, modelsnames{c}, c, nccases, estimatortypes{e}, e, necases)
      % if (c==2 && alpha==0) continue; end

      Nmc = simdata.parameters.Nmc;
      Nnl = simdata.parameters.Nnl;
      nmin = simdata.parameters.noisemin;
      nmax = simdata.parameters.noisemax;

      ramssdata.info.estimator_type = estimatortypes{e};
      looptype = extractAfter(modelname, length(modelname)-2);
      ramssdata.info.loop_type = looptype;

      if (Nnl==1), nmax = nmin; end
      if (Nmc==1), parallel = false; end
      nl = simdata.noise.levels;

      %% Loading data:
      u0std = simdata.u0std;
      if looptype == 'CL'
        y0std = simdata.y0std;
      end

      tregs = simdata.model.true_regs;
      ramssdata.noiseinfo.levels = nl;
      if looptype == 'OL'
        ramssdata.noiseinfo.stds = nl*u0std;
        ramssdata.noiseinfo.u0std = u0std;
      elseif looptype == 'CL'
        ramssdata.noiseinfo.stds = nl*y0std;
        ramssdata.noiseinfo.u0std = y0std;
      else
        error('Loop type not recognized!')
      end

      ramssdata.rip = cell(Nnl,Nmc);
      ramssdata.final_sel_regs_idx = cell(Nnl,Nmc);
      ramssdata.reg_comb = cell(Nnl,Nmc);
      ramssdata.parameters = struct('ntr',ntr, 'mlagu',mlagu, 'mlage',mlage, 'dg',dg,...
        'nm',nm, 'ni',ni, 'K',K, 'minrip',minrip, 'maxrip',maxrip,...
        'g',g, 'alpha',alpha, 'rem_red',rem_red, 'p',ptst);
      % ramssdata.tssdmdls = cell(Nnl,Nmc);
      tssdmdls = cell(Nnl,Nmc);

      pbinfo.nccases = nccases;
      pbinfo.necases = necases;
      pbinfo.nacases = nacases;
      pbinfo.c = c;
      pbinfo.e = e;
      pbinfo.a = a;

      % Multi core:
      if ( parallel )
        % Disabling warnings:
        parfevalOnAll(gcp(), @warning, 0, warn, 'MATLAB:singularMatrix');
        parfevalOnAll(gcp(), @warning, 0, warn, 'MATLAB:nearlySingularMatrix');
        parfevalOnAll(gcp(), @warning, 0, warn, 'MATLAB:illConditionedMatrix');
        parfevalOnAll(gcp(), @warning, 0, warn, 'MATLAB:rankDeficientMatrix');

        rd.rip = cell(Nnl);
        rd.final_sel_regs_idx = cell(Nnl);
        rd.reg_comb = cell(Nnl);
        for i = 1:Nnl
          rip_t = cell(1,Nmc);
          fsrix_t = cell(1,Nmc);
          rc_t = cell(1,Nmc);
          parfor j = 1:Nmc
            if estimatortypes{e} == 'LS'
              [rip, J, final_sel_regs_idx, reg_comb, rmv, smdl] = ...
                RaMSSLS(simdata.u{i,j}, simdata.e{i,j}, ntr, mlagu, mlage, ...
                dg, nm, ni, K, minrip, maxrip, alpha, rem_red,...
                ptst, j, Nmc, i, Nnl, parallel, pbinfo);
            elseif estimatortypes{e} == 'IV'
              [rip, J, final_sel_regs_idx, reg_comb, rmv, smdl] = ...
                RaMSSIV(simdata.u{i,j}, simdata.e{i,j}, ntr, mlagu, mlage, ...
                dg, nm, ni, K, minrip, maxrip, alpha, rem_red,...
                ptst, j, Nmc, i, Nnl, parallel, pbinfo);
            else
              error('Unknown estimator type!')
            end
            % Creating data structure to save:
            rip_t{j} = rip;
            fsrix_t{j} = final_sel_regs_idx;
            rc_t{j} = reg_comb;
            sel_models{j} = smdl;
          end
          rd.rip{i} = rip_t;
          % rd.J = J;
          rd.final_sel_regs_idx{i} = fsrix_t;
          rd.reg_comb{i} = rc_t;
          rd.sel_models{i} = sel_models;

          % progressbar:
          frac4 = i/Nnl;
          frac3 = ((e-1) + frac4) / necases;
          frac2 = ((a-1) + frac3) / nacases;
          frac1 = ((c-1) + frac2) / nccases;
          progressbar(frac1, frac2, frac3, frac4)
          et = toc;
          fprintf('Noise level (%d de %d); Simulation time: %.0fs; Elipsed time: %f\n', i, Nnl, et-etold, toc);
          etold = et;
        end
        % Gambiarra que deu certo no processamento paralelo:
        for i = 1:Nnl
          for j = 1:Nmc
            ramssdata.rip{i,j} = rd.rip{i}{j};
            ramssdata.final_sel_regs_idx{i,j} = rd.final_sel_regs_idx{i}{j};
            ramssdata.reg_comb{i,j} = rd.reg_comb{i}{j};
            % ramssdata.tssdmdls{i,j} = rd.sel_models{i}{j};
            tssdmdls{i,j} = rd.sel_models{i}{j};
          end % monte carlo cases
        end % noise cases
        clear rd;

        % Single core:
      else
        for i = 1:Nnl
          for j = 1:Nmc
            if estimatortypes{e} == 'LS'
              [rip, J, final_sel_regs_idx, reg_comb, rmv, smdl] = ...
                RaMSSLS(simdata.u{i,j}, simdata.e{i,j}, ntr, mlagu, mlage, ...
                dg, nm, ni, K, minrip, maxrip, alpha, rem_red,...
                ptst, j, Nmc, i, Nnl, parallel, pbinfo);
            elseif estimatortypes{e} == 'IV'
              [rip, J, final_sel_regs_idx, reg_comb, rmv, smdl] = ...
                RaMSSIV(simdata.u{i,j}, simdata.e{i,j}, ntr, mlagu, mlage, ...
                dg, nm, ni, K, minrip, maxrip, alpha, rem_red,...
                ptst, j, Nmc, i, Nnl, parallel, pbinfo);
            else
              error('Unknown estimator type!')
            end
            % Creating data structure to save:
            ramssdata.rip{i,j} = rip;
            ramssdata.J{i,j} = J;
            ramssdata.final_sel_regs_idx{i,j} = final_sel_regs_idx;
            ramssdata.reg_comb{i,j} = reg_comb;
            ramssdata.rmv{i,j} = rmv;
            % ramssdata.tssdmdls = smdl;
            tssdmdls = smdl;  % É isso mesmo?
          end % monte carlo Cases
        end % noise cases
      end % estimator cases

      %% Saving data:
      if (SAVEDATA)
        mkdir(strcat(savedir, modelname))
        savename = strcat(modelname, '/', modelname, '_', estimatortypes(e), '-M', num2str(nm, '%03d'), 'I', ...
          num2str(ni, '%03d'), 'K', num2str(K), 'u', num2str(mlagu), ...
          'e', num2str(mlage), 'l', num2str(dg), 'ni', num2str(abs(nmin)), 'nx', ...
          num2str(abs(nmax)), 'p', num2str(ptst*1e3, '%03d'), '_R', ...
          num2str(Nmc, '%02d'), 'N', num2str(Nnl, '%02d'), '_a', num2str(alpha*1e2, '%03d'));

        mkdir(savedir);
        ramssdata.noise.u0std = simdata.u0std;
        save(strcat(savedir, savename, ".mat"), 'simdata', 'ramssdata', '-v7.3');
        save(strcat(savedir, savename, "tssdmdls.mat"), 'tssdmdls', '-v7.3');
        % save([savedir savename '.mat'], "ramssdata", "modelinfo");
      end
    end % a cases
  end  % "controllers" cases
end  % a cases loop
toc

%load handel
%sound(y,Fs)
%plot(ramssdata.rip{1,1}')
%%
% rmpath(scriptspath)
