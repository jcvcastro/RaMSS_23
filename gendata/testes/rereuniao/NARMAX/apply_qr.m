function P1 = apply_qr(P0,A)
% function P1 = apply_qr(P0,A) applies QR factorization to P0
%	A is in the format present on Golub's book

% Eduardo Mendes - 11/08/94
% ACSE - Sheffield

if nargin ~= 2
	error('apply_qr requires 2 input arguments.');
end;

[a,b]=size(P0);

[m,n]=size(A);

if a ~= m
	error('P0 and A must have the same length.');
end;


v=zeros(m,1);
for j=1:n
  v(j)=1;
  v(j+1:m)=A(j+1:m,j);
  P0(j:m,:)=rowhouse(P0(j:m,:),v(j:m));
end;

P1=P0;

end;
