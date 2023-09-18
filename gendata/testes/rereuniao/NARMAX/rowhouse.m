function B = rowhouse(A,v)
% function B = rowhouse(A,v) 

% Eduardo Mendes - 29/1/93
% ACSE - Sheffield

b=-2/(v'*v);
w=b*A'*v;
A=A+v*w';

B=A;

end;
