function [theta, model, sr, uh, r, taun, rmv, Psi] = rmv_rdndt_ls(u, uh, ...
          Psi, theta, model, sr, p)
      r = u - uh;
      ntr = length(u);
      tau = length(theta);
      % NOTE: Disabling exacly computing of t-student test to test if the runing
      % time is improved a little. Unsing dof as 1000 (tt \approx 1.9623) .
      % nu = ntr - tau;   % DoF to t-student test
      % tt = tinv(p,nu);  % computing t-student for p-th percentile with nu DOF
      tt = 1.9623;
      rmv = false(tau,1);
      rsvix = find(sr);
      V = inv(Psi'* Psi);
      sige2 = r' * r / (ntr - tau);
      sig2 = sige2 * diag(V);
      sig = sqrt(sig2);
      ci_inf = theta - sig * tt;
      ci_sup = theta + sig * tt;

      for h = 1:tau
        if (ci_inf(h) < 0) && (ci_sup(h) > 0)  % if interval contain zero
          rmv(h) = true;
%           fprintf('\nq%d removido', h);
          sr(rsvix(h)) = false;
        end
      end
      taun = sum(sr);
      if (taun < tau) && (taun>0)
          model = model(~rmv,:);
          Psi = Psi(:, ~rmv);
          theta = Psi\u;
          uh = Psi * theta;
          r = u - uh;
      end
end


%% 

