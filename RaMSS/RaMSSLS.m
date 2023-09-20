function [rip, J, fsrix, rcmb, rmv, mdl] = RaMSSLS(u, e, ntr, mlagu, mlage,...
  dg, nm, ni, K, minrip, maxrip, alpha, rem_red, p_tst, imc, Nmc, inl, Nnl)

% u: output (control) signal
% e: input (error) signal
% mlagu: max lag on u signal
% mlage: max lag on e signal
% dg: degree of the model (non-linearity)
% nm: number of
% ni: number of
% minrip: minumum value allowed for the RIP
% maxrip: maximum value allowed for the RIP
% alpha : porcentage of the one-step-ahead versus mspe used in RaMSS
% rem_red: remove redundants [boolean]
% p_tst: percentil (for t-student test in redundants removal)
% imc: index? of monte-Carlo try?
% Nmc: Number of monte-Carlo tries
% inl: index? of noise-try?
% Nnl: Number of noise tries


% parallel: run in multi-core (true) or single (false) [boolean]
% pbinfo: ??? for progressbar


%% RaMSS
% rmv = zeros(1,
% Regressor combination matrix
rcmb = genterms2(dg,mlagu,mlage);

[nr, ~] = size(rcmb);
n = length(u);

% Initial RIPs:
rip = zeros(nr,ni+1);
rip(:,1) = ones(nr,1)./nr; % initial RIPs
% rip(:,1) = ones(nr,1)/20; % initial RIPs

% Initial definitions

Jmax = 0;

mdl.mspe = zeros(ni,nm);
mdl.msse = zeros(ni,nm);
mdl.regs = cell(ni,nm);  %WARN: Pre-creating cell to store regressors (check if no error)

for k = 1:ni
  % j = 1
  % k = 1
  J = zeros(nm,1);
  Jfr = zeros(nm,1);
  i = 1;
  sr = false(nm,nr);

  while (i <= nm)

    % 'Tossing' models
    %WARN: Look if nothing wrong is occurring here, until now, seems ok:
    x = rand(nr,1);
    idx = find(x <= rip(:,k));
    sr(i,idx) = true;

    % Forcing the true model "for test":
    % tregs = [1001 0 0; 2001 0 0; 1001 1001 0; 2001 2001 1001]; % true regs for C2;
    % sc = selregvec(tregs, rcmb);

    tau = sum(sr(i,:));   % Number of selected regressors(i,:))), continue; end  % If no reg is selected, try again

    srix = find(sr(i,:));
    model = rcmb(srix,:);

    [npr,~,lag,nu,ne,~,~]=get_info(model);

    if ~ne || ~nu, continue; end % Try another model if no error inputs or no control outputs
    % if (nu == 0), continue; end

    %% Estimating parameters:
    % Psi_comp = build_pr(model, e, u);
    Psi_comp = build_prcss(model, e, ne, npr, u, nu);
    Psi = Psi_comp(1+lag:ntr, :);
    % cond(Psi);  %BUG: checking conditioning of Psi (debug)
    u_train = u(1+lag:ntr);
    % e_train = e(1+lag:ntr);
    theta_hat = Psi\u_train;
    u_hat = Psi*theta_hat;
    % res = u_train - u_hat;

    if rem_red
      % Removing Redundants
      [theta_hat, model, sr(i,:), u_hat, ~, tau, rmv, ~] = rmv_rdndt_ls(u_train, u_hat, Psi, theta_hat,...
        model, sr(i,:), p_tst);

      if any(rmv)
        [~,~,lag,nu,ne,~,~] = get_info(model);
      end

      %stop if all regressors are removed (tau = 0) or only u or only e regressors:
      if ~tau || ~nu || ~ne
        % fprintf("tau nulo!\n");
        continue;  % If all regressors are removed, try again!
      end

      Psi_1sa = Psi_comp(ntr+1:n, ~rmv);
    else
      Psi_1sa = Psi_comp(ntr+1:n,:);
    end

    % One-step-ahead prediction:
    u_1sa = Psi_1sa*theta_hat;
    u_test = u(ntr+1:n);

    %%%%%% COMPUTING INDEX J %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mdl.regs{k,i} = model;
    mdl.mspe(k,i) = mspe(u_test, u_1sa);
    J(i) = exp(-K*mdl.mspe(k,i));   % index J based on one-step-ahead
    % J(i) = exp(-K*mspe(u_train, u_hat));   % index J based on residues
    if alpha > 0  % index based on free-run prediction:
      e_test = e(ntr+1:n);
      u_fr = simmodeld(model,theta_hat,e_test,u(ntr+1-lag:ntr));
      mdl.msse(k,i) = mspe(u_test, u_fr);
      Jfr(i) = exp(-K*mdl.msse(k,i));   % J one-step-ahead
      J(i) = alpha*Jfr(i) + (1-alpha)*J(i);
    end
    i = i + 1;    % number of selected models
  end % end of model selection and J computation
  clear i;  %TODO: is it necessary?

  %% Updating RIPs

  Jmean = mean(J);
  if(max(J) > Jmax), Jmax = max(J); end

  g = 1/(10*(Jmax-Jmean) + 0.1);
  % g = 1/(5*(Jmax-Jmean) + 0.2);

  for j = 1:nr
    Jplus = 0; nplus = 0; Jminus = 0; nminus = 0;
    for i = 1:nm
      if(sr(i,j))
        Jplus = Jplus + J(i);
        nplus = nplus + 1;
      else
        Jminus = Jminus + J(i);
        nminus = nminus + 1;
      end
    end
    rip(j,k+1) = rip(j,k) + g * (Jplus/(max(nplus,1)) - Jminus/(max(nminus,1)));
    rip(j,k+1) = max(min(rip(j,k+1), maxrip), minrip);
  end

  %if ~parallel && pbinfo.show  %% for progressbar
  % if ~parallel %% for progressbar
  %   % progressbar:
  %   % frac3 = k/ni;
  %   % frac2 = ((imc-1) + frac3) / Nmc;
  %   % frac1 = ((inl-1) + frac2) / Nnl;
  %   % progressbar(frac1, frac2, frac3)
  %
  %   frac6 = k/ni;
  %   frac5 = ((imc-1) + frac6) / Nmc;
  %   frac4 = ((inl-1) + frac5) / Nnl;
  %   frac3 = ((pbinfo.e-1) + frac4) / pbinfo.necases;
  %   frac2 = ((pbinfo.c-1) + frac3) / pbinfo.nccases;
  %   frac1 = ((pbinfo.a-1) + frac2) / pbinfo.nacases;
  %   progressbar(frac1, frac2, frac3, frac4, frac5, frac6);
  % end

end
fsrix = find(rip(:,k) >= 1);  % Final selected regressor indexes

end
