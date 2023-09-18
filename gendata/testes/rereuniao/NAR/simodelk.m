function ym=simodelk(model,x,u,y,nic,k,mode);
% ym=simodelk(model,x,u,y,nic,k,mode);
%
% simulates model k steps ahead, using nic number
% of initial conditions every k steps ahead (mode=1)
% or every step ahead (mode=2)
% mode indicates de mode of simulation desired
% mode=1- the model is simulated k steps ahead and reset
%		every k steps
% mode=2- the model is simulated k steps ahead and reset
%		every step

% Luis A. Aguirre, BH 8/10/96

[r c]=size(u);
% if u is a vector
if r~=c
  lu=max([r c]);
else
  lu=u;
end;

if mode==1
  k=k+nic;
  if r~=c,
    ym=simodeld(model,x(:,1),u(1:k),y(1:nic));
  else
    ym=simodeld(model,x(:,1),k,y(1:nic));
  end;

  for i=2:lu/k
    if r~=c,
      yy=simodeld(model,x(:,1),u((i-1)*k+1:i*k),y((i-1)*k+1:nic+(i-1)*k));
    else
      yy=simodeld(model,x(:,1),k,y((i-1)*k+1:nic+(i-1)*k));
    end;
    ym=[ym; yy];
  end;
end;

if mode==2
  k=k+nic;
  if r~=c,
    ym=simodeld(model,x(:,1),u(1:k),y(1:nic));
  else
    ym=simodeld(model,x(:,1),k,y(1:nic));
  end;

  for i=2:lu-k+1
    if r~=c,
      yy=simodeld(model,x(:,1),u(i:i+k-1),y(i:i+nic-1));
    else
      yy=simodeld(model,x(:,1),k,y(i:i+nic-1));
    end;
    ym=[ym; yy(length(yy))];
  end;
end;
