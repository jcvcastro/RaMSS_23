function [u] = C1cotroller(C,d,k,e,u) 
  %% for reference model with 10*Ts ms of settling time.
  switch C
    case 1 % C1a
      u(k-1) = 18.8332*e(k-2)-22.0201*e(k-3)+4.5704*e(k-4)+0.51919*u(k-2)+0.57225*u(k-3)-0.091434*u(k-4)
    case 2 % C1a
      u(k-1) = 16.9499*e(k-2)-19.8181*e(k-3)+4.1133*e(k-4)+0.51919*u(k-2)+0.5419*u(k-3)-0.11045*u(k-4)
    case 2 % C1c
      u(k-1) = 1.0488*e(k-2)-1.2263*e(k-3)+0.25452*e(k-4)+1.2085*u(k-2)+0.31492*u(k-3)-0.52346*u(k-4)
    case 2 % C1d
      u(k-1) = 0.94393*e(k-2)-1.1037*e(k-3)+0.22907*e(k-4)+1.2085*u(k-2)+0.31323*u(k-3)-0.52451*u(k-4)
  otherwise
    error('Error: Invalid controller!')
  end
end


