%

function score = perform_ERR_and_compute_score(datafile)

% scriptspath = './dependency/';
% addpath(scriptspath)

  mlagu = 6
  mlage = 6
  dg = 3

  item = 1;
  j = 1;

  % files = strcat(modelsnames, '-', sampleddatafilename)
  ntr = 1000;

  % for c = 1:nccases   % controller cases

  load(datafile);

  modelname = simdata.model.name;
  % ttncases_iter = ttncases_iter+1;

  Nmc = simdata.parameters.Nmc;
  Nnl = simdata.parameters.Nnl;
  nmin = simdata.parameters.noisemin;
  nmax = simdata.parameters.noisemax;
  looptype = extractAfter(modelname, length(modelname)-2);

  nl = simdata.noise.levels;

  % %% Loading data:
  % u0std = simdata.u0std;
  % if looptype == "CL"
  %   y0std = simdata.y0std;
  % end
  %
  % tregs = simdata.model.true_regs;
  % errdata.noiseinfo.levels = nl;
  % if looptype == "OL"
  %   errdata.noiseinfo.stds = nl*u0std;
  %   errdata.noiseinfo.u0std = u0std;
  % elseif looptype == "CL"
  %   errdata.noiseinfo.stds = nl*y0std;
  %   errdata.noiseinfo.u0std = y0std;
  % else
  %   error('Loop type not recognized!')
  % end

  uk = zeros(Nmc,1);
  uk1 = zeros(Nmc,1);
  uk2 = zeros(Nmc,1);
  uk3 = zeros(Nmc,1);
  ek = zeros(Nmc,1);
  ek1 = zeros(Nmc,1);
  ek2 = zeros(Nmc,1);
  ek3 = zeros(Nmc,1);
  nota = zeros(Nmc,Nnl);

  DG=dg;		% Degree of nonlinearity.
  lagy=mlagu;		% Maximum lag of the output signals.
  lagu=mlage;		% Maximum lag of the input signals.
  % lage=10;		% Maximum lag of the noise signals.
  lnt=1;		% Number of linear noise terms.

  [Cand,tot2] = genterms2(DG,lagy,lagu);
  Cand=[Cand;(3101:1:(3100+lnt))' zeros(lnt,(DG-1))];

  nprmd=10;	% Number of "process" and "noise" terms in the 
  nnomd=0;	% model that should be used during parameter
  % estimation.
  ni=0;		% Noise iterations to be performed.


  for n = 1:Nnl % noise loop
    for m = 1:Nmc % Monte Carlo loop


      ui = simdata.u{n,m}(1:ntr);
      e = simdata.e{n,m}(1:ntr);

      % ui = u + randn(size(u))*std(u)*ruido(n);
      % [model,x,ME,va]=orthreg(Cand,e(1:end),ui(1:end),[nprmd nnomd],ni);
      [model,x,ME,va]=orthreg(Cand,e(201:end),ui(201:end),[nprmd nnomd],ni);

      % regressor ranking
      nr = 6; % numero de regressores verdadeiros
      nt = 1/nr; % nota maxima para regressor (corretamente selecionado)
      for i = 1:nprmd
        % regressor u(k-1): 1001 0 0
        if model(i,1) == 1001 & model(i,2) == 0 & model(i,3) == 0
          uk1(m) = i;   
          if i<nr+1 % if regressor is among the first nr
            nota(m,n) = nt;
          else
            nota(m,n) = nt*0.8^(i-nr);
          end
        else
          % regressor u(k-2): 1002 0 0 
          if model(i,1) == 1002 & model(i,2) == 0 & model(i,3) == 0
            uk2(m) = i;
            if i<nr+1 % if regressor is among the first nr
              nota(m,n) = nota(m,n) + nt;
            else
              nota(m,n) = nota(m,n) + nt*0.8^(i-nr);
            end
          else
            % regressor u(k-3): 1003 0 0 
            if model(i,1) == 1003 & model(i,2) == 0 & model(i,3) == 0
              uk3(m) = i;
              if i<nr+1 % if regressor is among the first nr
                nota(m,n) = nota(m,n) + nt;
              else
                nota(m,n) = nota(m,n) + nt*0.8^(i-nr);
              end
            else
              % regressor e(k-1): 2001 0 0
              if model(i,1) == 2001 & model(i,2) == 0 & model(i,3) == 0
                ek1(m) = i;
                if i<nr+1 % if regressor is among the first nr
                  nota(m,n) = nota(m,n) + nt;
                else
                  nota(m,n) = nota(m,n) + nt*0.8^(i-nr);
                end
              else
                % regressor e(k-2): 2002 0 0
                if model(i,1) == 2002 & model(i,2) == 0 & model(i,3) == 0
                  ek2(m) = i;
                  if i<nr+1 % if regressor is among the first nr
                    nota(m,n) = nota(m,n) + nt;
                  else
                    nota(m,n) = nota(m,n) + nt*0.8^(i-nr);
                  end
                else
                  % regressor e(k-3): 2003 0 0
                  if model(i,1) == 2003 & model(i,2) == 0 & model(i,3) == 0
                    ek3(m) = i;
                    if i<nr+1 % if regressor is among the first nr
                      nota(m,n) = nota(m,n) + nt;
                    else
                      nota(m,n) = nota(m,n) + nt*0.8^(i-nr);
                    end
                  end
                end
              end
            end
          end
        end
      end % end for loop (regressor ranking)
      % sc.controller{j} = modelname;
      % sc.b(j) = b;
      % sc.ruido(j) = ruido(n);
      % sc.nota(j) = nota(m,n);
      j = j+1;
    end % monte carlo Cases
  end % noise cases

  % % nota media
  % nm{c} = mean(nota);
  % % desvio padrao
  % ns{c} = std(nota);
  % sc.mean(item:item+Nnl-1,1) = mean(nota)';
  % sc.std(item:item+Nnl-1,1) = ns{c}';
  % item = item+Nnl;


  score.values = nota'; %NOTE: meu algoritimo ERR estava salvando o valor das
                        % notas trasposto em relação ao RaMSS, por isso a
                        % transposta aqui
  score.mean = mean(score.values,2);
  score.std = std(score.values,0,2);
  score.noise_levels = simdata.noise.levels;
  score.label = simdata.model.name;

  % rmpath(scriptspath)

end % end function
