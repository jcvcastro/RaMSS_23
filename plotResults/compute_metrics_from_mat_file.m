function metrics = compute_metrics_from_mat_file(datafile,nregs,SAVEDATA)
  addpath('../RaMSS')

  % datafile = '/home/joao/Documentos/GDRIVE/DOUTORADO/GIT/RaMSS_23/DATA23/RaMSS/2309/C1_1b5_CL/C1_1b5_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat';
  % % datafile = '/home/joao/Documentos/GDRIVE/DOUTORADO/GIT/RaMSS_23/DATA23/RaMSS/230925/ripinit03/C1_1b5_CL/C1_1b5_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat';
  % nregs = 6;

  %TODO: Terminar checagem de argumentos:
  % if (nargin < 1) || (nargin>3)
  %   error('Function needs 2 or 3 arguments!');
  % elseif nargin < 3
  %   SAVEDATA = false;
  % end

  load(datafile);

  [Nnl, Nmc] = size(ramssdata.rip);


  metrics = cell(Nnl,Nmc);      % Metrics for first 'nregs' regs


  for n = 1:Nnl % noise cases
    for c = 1:Nmc % monte carlo cases

      % Sorting RIPs
      rip.orig = ramssdata.rip{n,c};
      rc.orig = ramssdata.reg_comb{n,c};
      rip.srtd = regclassif(rip.orig);  % Reg/RIP classification
      rc.srtd = rc.orig(rip.srtd.ix,:);

      model = rc.srtd(1:nregs,:);
      ntr = ramssdata.parameters.ntr;
      e = simdata.e{n,c};
      u = simdata.u{n,c};
      model
      metrics{n,c}.nsregs = compute_metrics(model,e,u,ntr);
      metrics{n,c}.tregs = compute_metrics(simdata.model.true_regs,e,u,ntr);
      metrics{n,c}.noise_level =  simdata.noise.levels(n);

      metrics{n,c}.label =  simdata.model.name(1:4);
      metrics{n,c}.a =  ramssdata.parameters.alpha;
    end
  end

  if(SAVEDATA)
    [filepath,filename,fileext] = fileparts(datafile);
    filenamemetrics = strcat(filepath, '/', filename, '_metrics', fileext);
    save(filenamemetrics, 'metrics', '-v7.3');
  end

% end

