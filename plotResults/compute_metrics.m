function metrics = compute_metrics(model,e,u,ntr)
      [npr,~,lag,nu,ne,~,~]=get_info(model);
      Psi_comp = build_pr(model, e, u);

      % [nregs, ~] = size(model);

      Psi = Psi_comp(1+lag:ntr, :);
      u_train = u(1+lag:ntr);
      e_train = e(1+lag:ntr);
      u_test = u(ntr+1:end);
      e_test = e(ntr+1:end);

      theta_hat = Psi\u_train;
      u_hat = Psi*theta_hat;

      % Solving with instrumental variables:
      Z = build_pr(model, e_train , u_hat);  % instrumental variables matrix
      theta_hat = Z'*Psi \ Z'*u_train;
      % u_hat = Psi*theta_hat;

      % Computing metrics:

      % One-step-ahead prediction:
      Psi_1sa = Psi_comp(ntr+1:end,:);
      u_1sa = Psi_1sa*theta_hat;
      metrics.mspe = mspe(u_test, u_1sa);

      % Free-run simulation:
      if (ne>0)
        u_fr = simmodeld(model,theta_hat,e_test,u(ntr+1-lag:ntr));
        metrics.msse = mspe(u_test, u_fr);
        metrics.mape = mape(u_test, u_fr);
      else
        metrics.msse = nan;
        metrics.mape = nan;
      end

      metrics.nregs = npr;
      metrics.model = model;
end
