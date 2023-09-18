function v = house(x)
% function v = house(x) based on Algorithm 5.1.1
%    Matrix Computations - 2nd edition -page 196

% Eduardo Mendes - 28/12/92
% ACSE - Sheffield

n=length(x);
u=norm(x,2);
v=x;
if u ~= 0
  b=x(1) + sign(x(1))*u;
  v(2:n) = v(2:n)/b;
end;
v(1)=1;

end;
