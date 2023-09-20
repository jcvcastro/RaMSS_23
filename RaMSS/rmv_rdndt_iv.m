function [theta, model, sr, uh, r, taun, rmv, Psi] = rmv_rdndt_iv(e, u, uh, ...
          Psi, theta, model, sr, p)
      r = u - uh;
      ntr = length(u);
      tau = length(theta);  
      nu = ntr - tau;   % DoF to t-student test
      tt = tinv(p,nu);  % computing t-student for p-th percentile with nu DOF
      rmv = false(tau,1);
      rsvix = find(sr);
      V = inv(Psi'* Psi);
      sige2 = r' * r / (ntr - tau);
      sig2 = sige2 * diag(V);
      sig = sqrt(sig2);
      ci_inf = theta - sig * tt;
      ci_sup = theta + sig * tt;

      for h = 1:tau
        if((ci_inf(h)<0 && ci_sup(h)>0))  % if interval contain zero
          rmv(h) = true;
%           fprintf('\nq%d removido', h);
          sr(rsvix(h)) = false;
        end
      end
      taun = sum(sr);
      if((taun < tau) && (taun>0))
          model = model(~rmv,:);
          Psi = Psi(:, ~rmv);
          theta = Psi\u;
          uh = Psi * theta;
          r = u - uh;

          % % Solving with instrumental variables:
          % Z = build_pr(model, e , uh);  % instrumental variables matrix
          % theta_hat = Z'*Psi \ Z'*u;
          % u_hat = Psi*theta_hat;
      end
end


%% 

