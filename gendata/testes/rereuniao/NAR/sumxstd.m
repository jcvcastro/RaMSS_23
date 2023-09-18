% determines the summation of all cross-std's
% the indices of the parameters in question come in i
% the covariance matrix comes in S

SS=0;
for k=1:length(i)-1
  for j=k+1:length(i)
   SS=SS+real(S(k,j));
  end;
end;