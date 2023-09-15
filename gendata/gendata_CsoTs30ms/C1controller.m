function [u] = C1cotroller(C,d,k,e,u) 
  %% for reference model with 10*Ts ms of settling time.
  switch C
    case 1 % C1a
      u(k-d) = 18.8332*e(k-d-1)-22.0201*e(k-d-2)+4.5704*e(k-d-3)+0.51919*u(k-d-1)+0.57225*u(k-d-2)-0.091434*u(k-d-3)
    case 2 % C1a
      u(k-d) = 16.9499*e(k-d-1)-19.8181*e(k-d-2)+4.1133*e(k-d-3)+0.51919*u(k-d-1)+0.5419*u(k-d-2)-0.11045*u(k-d-3)
    case 2 % C1c
      u(k-d) = 1.0488*e(k-d-1)-1.2263*e(k-d-2)+0.25452*e(k-d-3)+1.2085*u(k-d-1)+0.31492*u(k-d-2)-0.52346*u(k-d-3)
    case 2 % C1d
      u(k-d) = 0.94393*e(k-d-1)-1.1037*e(k-d-2)+0.22907*e(k-d-3)+1.2085*u(k-d-1)+0.31323*u(k-d-2)-0.52451*u(k-d-3)
  otherwise
    error('Error: Invalid controller!')
  end
end


