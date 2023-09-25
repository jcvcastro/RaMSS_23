% Script to test the ERR performance in connection with the identification
% in open of Cso1-3

% JCVC 2023/9/21

%
clear
scriptspath = './dependency/';
addpath(scriptspath)

modelnames = {'C1', 'Cso2', 'Cso3'};
% modelnames = {'Cso1', 'Cso2'};
% modelnames = {'Cso1'};

item = 1;
j = 1;

Nmc = 4; % Number of Monte Carlo runs
Nn = 5;  % Number of noise levels

for c = 1:length(modelnames)
  % for b = [1 5 10 20 50]
  for b = 10
    modelname = modelnames{c};

    % length of data set
    N = 1200;
    % tempo de hold
    % b = 50;

    modelname2 = strcat(modelname, 'b', num2str(b))

    % input
    aux = (rand(N/b)*2-1)*0.1;

    % hold each value for b sampling times
    e = zoh(aux,b);
    % e = e - mean(e);
    clear aux

    % null inicial conditions
    u = zeros(N,1);

    % controller Cso1
    % here the input is e(k) and the output is u(k)

    for k = 4:N 
      switch c
        case 1
          u(k) = 0.12297*e(k-1)-0.14378*e(k-2)+0.029841*e(k-3)+1.3194*u(k-1)+0.27354*u(k-2)-0.59292*u(k-3);
        case 2
          u(k) = 0.11682*e(k-1)-0.13659*e(k-2)+0.028349*e(k-3)+1.3194*u(k-1)+0.27344*u(k-2)-0.59298*u(k-3);
        case 3
          u(k) = 0.061484*e(k-1)-0.071888*e(k-2)+0.014921*e(k-3)+1.3194*u(k-1)+0.27255*u(k-2)-0.59354*u(k-3);
        otherwise

      end
    end

    % tregs = 1001 1002 1003 2001 2002 2003
    figure(1); clf;
    plot(1:N,e,'k',1:N,u,'b')
    set(gca,'FontSize',16)
    xlabel('samples')
    axis([0 N -0.15 0.15]);

    figure(2); clf;
    % discarding the first 200 values (transiennts)
    myccf2([u(201:end) e(201:end)],20,1,1);

    %% Identificacao de C2

    DG=3;		% Degree of nonlinearity.
    lagy=6;		% Maximum lag of the output signals.
    lagu=6;		% Maximum lag of the input signals.
    % lage=10;		% Maximum lag of the noise signals.
    lnt=1;		% Number of linear noise terms.

    [Cand,tot2] = genterms2(DG,lagy,lagu);
    Cand=[Cand;(3101:1:(3100+lnt))' zeros(lnt,(DG-1))];

    nprmd=10;	% Number of "process" and "noise" terms in the 
    nnomd=0;	% model that should be used during parameter
    % estimation.
    ni=0;		% Noise iterations to be performed.

    % ruido = logspace(-2.5,0.5,Nn); % noise factors
    ruido = logspace(-5,0.5,Nn); % noise factors

    uk1 = zeros(Nmc,1);
    uk1uk1 = zeros(Nmc,1);
    ek1 = zeros(Nmc,1);
    ek1ek1uk1 = zeros(Nmc,1);
    nota = zeros(Nmc,Nn);

    % noise loop
    for n = 1:Nn
      disp(n)
      % Monte Carlo loop
      for MC = 1:Nmc

        ui = u + randn(size(u))*std(u)*ruido(n);
        [model,x,ME,va]=orthreg(Cand,e(201:end),ui(201:end),[nprmd nnomd],ni);

        % regressor ranking
        nr = 6; % numero de regressores verdadeiros
        nt = 1/nr; % nota maxima para regressor (corretamente selecionado)
        for i = 1:nprmd
          % regressor u(k-1): 1001 0 0
          if model(i,1) == 1001 & model(i,2) == 0 & model(i,3) == 0
            uk1(MC) = i;   
            if i<nr+1 % if regressor is among the first nr
              nota(MC,n) = nt;
            else
              nota(MC,n) = nt*0.8^(i-nr);
            end
          else
            % regressor u(k-2): 1002 0 0 
            if model(i,1) == 1002 & model(i,2) == 0 & model(i,3) == 0
              uk2(MC) = i;
              if i<nr+1 % if regressor is among the first nr
                nota(MC,n) = nota(MC,n) + nt;
              else
                nota(MC,n) = nota(MC,n) + nt*0.8^(i-nr);
              end
            else
              % regressor u(k-3): 1003 0 0 
              if model(i,1) == 1003 & model(i,2) == 0 & model(i,3) == 0
                uk3(MC) = i;
                if i<nr+1 % if regressor is among the first nr
                  nota(MC,n) = nota(MC,n) + nt;
                else
                  nota(MC,n) = nota(MC,n) + nt*0.8^(i-nr);
                end
              else
                % regressor e(k-1): 2001 0 0
                if model(i,1) == 2001 & model(i,2) == 0 & model(i,3) == 0
                  ek(MC) = i;  
                  if i<nr+1 % if regressor is among the first nr
                    nota(MC,n) = nota(MC,n) + nt;
                  else
                    nota(MC,n) = nota(MC,n) + nt*0.8^(i-nr);
                  end
                else
                  % regressor e(k-2): 2002 0 0
                  if model(i,1) == 2002 & model(i,2) == 0 & model(i,3) == 0
                    ek1(MC) = i;  
                    if i<nr+1 % if regressor is among the first nr
                      nota(MC,n) = nota(MC,n) + nt;
                    else
                      nota(MC,n) = nota(MC,n) + nt*0.8^(i-nr);
                    end
                  else
                    % regressor e(k-3): 2003 0 0
                    if model(i,1) == 2003 & model(i,2) == 0 & model(i,3) == 0
                      ek2(MC) = i;  
                      if i<nr+1 % if regressor is among the first nr
                        nota(MC,n) = nota(MC,n) + nt;
                      else
                        nota(MC,n) = nota(MC,n) + nt*0.8^(i-nr);
                      end
                    end
                  end
                end
              end
            end
          end
        end % end for loop (regressor ranking)
        sc.controller{j} = modelname;
        sc.b(j) = b;
        sc.ruido(j) = ruido(n);
        sc.nota(j) = nota(MC,n);
        j = j+1;

      end % end Monte Carlo loop
      % end noise loop
    end

    %%

    % nota media
    nm{c} = mean(nota);
    % desvio padrao
    ns{c} = std(nota);
    sc.mean(item:item+Nn-1,1) = mean(nota)';
    sc.std(item:item+Nn-1,1) = ns{c}';
    item = item+Nn;

    figure(3); clf;
    semilogx(100*ruido,nm{c},'ko',100*ruido,nm{c}+ns{c},'k+',100*ruido,nm{c}-ns{c},'k+');
    grid on;
    set(gca,'FontSize',16)
    xlabel('std(noise)/std(signal)');
    ylabel('index');
    axis([0.0005 1000 -0.2 1.2])

    %% Salvando figuras:

    namefig = strcat('Ma', modelname2);
    pathfig = 'figs/';
    mkdir(pathfig)
    f.PaperSize = [21 15];

    figure(1);
    pause(0.5);
    print(strcat(pathfig, namefig, '_signal.pdf'), '-dpdf', '-fillpage');

    figure(2);
    pause(0.5);
    print(strcat(pathfig, namefig, '_acf.pdf'), '-dpdf', '-fillpage');

    figure(3);
    pause(0.5);
    print(strcat(pathfig, namefig, '_score.pdf'), '-dpdf', '-fillpage');
    % Salvando em .fig:
    % savefig(strcat(savepath, namefig))
    % print -depsc2 MaC2_wide.eps
  end
end

figure(4)
for i = 1:length(modelnames)
  subplot(3,1,i)
  semilogx(100*ruido,nm{i},'ko',100*ruido,nm{i}+ns{i},'k+',100*ruido,nm{i}-ns{i},'k+');
  grid on;
  set(gca,'FontSize',16)
  xlabel('std(noise)/std(signal)');
  ylabel('index');
  axis([0.0005 1000 -0.2 1.2])
end

figure(5); clf;
f = gcf;
% g=gramm('x',sc.ruido,'y',sc.mean,'color',sc.controller)
g=gramm('x',100.*sc.ruido,'y',sc.nota,'color',sc.controller);
% g.geom_point();
% g.stat_smooth();
g.stat_summary('geom','area','type','std','width',1);
g.set_text_options('interpreter','tex');
g.set_names('row','','x','100*\sigma(\eta)/\sigma(u)%','y','index');
g.axe_property('XLim',[0 400],'YLim',[0 1.1],'YTick',0:0.2:1,'XScale','log','XGrid','on','Ygrid','on','GridColor',[0.6 0.6 0.6]);
g.facet_grid(sc.controller,[],'scale','fixed');
g.set_layout_options('legend',false)
% g.set_point_options('markers',{'o' 'd' 's' '^' 'v' '>' '<' 'p' 'h' '+' 'o' 'x'});
g.draw();
g.update();
g.stat_summary('geom','point');
g.draw();
g.redraw(0.01)
g.export('file_name','MaCso.pdf','file_type','pdf','width',16,'height',15);
%
% g.update('x',100*sc.ruido,'y',sc.mean-sc.std,'marker',sc.controller);
% g.geom_point();
% g.axe_property('XLim',[0 400],'YLim',[0 1.2],'YTick',0:0.2:1,'XScale','log','XGrid','on','Ygrid','on','GridColor',[0.6 0.6 0.6]);
% g.draw();

% g.update('x',100*sc.ruido,'y',sc.mean+sc.std);
% g.geom_point();
% g.axe_property('XLim',[0 400],'YLim',[0 1.2],'YTick',0:0.2:1,'XScale','log','XGrid','on','Ygrid','on','GridColor',[0.6 0.6 0.6]);
% g.draw();


rmpath(scriptspath)
%%
