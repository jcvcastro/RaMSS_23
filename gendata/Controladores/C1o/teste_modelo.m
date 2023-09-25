clear

N = 100;
% null inicial conditions
u = ones(N,1);
y = zeros(N,1);

% controller Cso 
% here the input is e(k) and the output is u(k)

for k = 5:N 
  % switch c
  %   case 1
  %     u(k-1) = 0.12297*e(k-2)-0.14378*e(k-3)+0.029841*e(k-4)+1.3194*u(k-2)+0.27354*u(k-3)-0.59292*u(k-4);
  %   case 2
  %     u(k-1) = 0.11682*e(k-2)-0.13659*e(k-3)+0.028349*e(k-4)+1.3194*u(k-2)+0.27344*u(k-3)-0.59298*u(k-4);
  %   case 3
  %     u(k-1) = 0.061484*e(k-2)-0.071888*e(k-3)+0.014921*e(k-4)+1.3194*u(k-2)+0.27255*u(k-3)-0.59354*u(k-4);
  % end
  y(k) = 1.169*y(k-1) - 0.2427*y(k-2) + 0.01611*u(k-1) + 0.0101*u(k-2);
  % error:
  % e(k) = r(k) - y(k);
end

stdy = std(y);

figure(1); clf;
plot(1:N,u,'k',1:N,y,'b')
set(gca,'FontSize',16)
xlabel('samples')
% axis([0 N -0.15 0.15]);

