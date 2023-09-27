% function plot_scores_c1toc4_gram_OL(files, pathfig)

clear 

% if nargin < 1
% end
% switch nargin
%    case 0
%       error("the function needs a data file!")
%    case 1
%       pathfig = [];
%    case 2
%    otherwise
%       error("Function must have 1 or 2 arguments!")
% end

scriptspath = '../ERR/dependency/';
addpath(scriptspath)

ramsdatapath = '../DATA23/RaMSS/2309/';

fi = 0;
bv = [5];
nb = length(bv);
% for c=1:8
% for c=[1 2 5 6] % Caso com Td mais rápido (ts2 = 10*Ts)
for c=[1] % Caso com Td mais rápido (ts2 = 10*Ts)
% for c=[3 4 7 8] % Caso com Td mais lento (ts2 = 50*Ts)
  for b=bv
    % for a=[0 30 60 100]
    for a=[0]
      fi = fi +1;
      modelname = ['C1_' num2str(c) 'b', num2str(b), '_OL'];
      files{fi} = [ramsdatapath modelname '/' modelname '_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a' num2str(a,'%0.3d') '.mat'];
      fb(fi) = b;
    end
  end
end
% files = {'../DATA23/RaMSS/2309/C1_1b1_CL/C1_1b1_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a030.mat',...
%          '../DATA23/RaMSS/2309/C1_2b1_CL/C1_2b1_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a030.mat',...
%          '../DATA23/RaMSS/2309/C1_3b1_CL/C1_3b1_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a030.mat',...
%          '../DATA23/RaMSS/2309/C1_4b1_CL/C1_4b1_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a030.mat'
%   };


nf = length(files);
j = 0;
for i = 1:nf
  score = compute_score(files{i});
  [Nn,Nmc] = size(score.values);
  for n = 1:Nn
    for m = 1:Nmc
      j = j+1;
      sc.noise_levels(j) = score.noise_levels(n);
      sc.values(j) = score.values(n,m);
      lb = score.label;
      sc.label{j} = [lb(1), '_', lb(2), '^{', lb(4), '}'] ;
      sc.a(j) = score.info.a;
      sc.b(j) = fb(i);
    end
  end
end

figure(15); clf;
f = gcf;
clear g

g=gramm('x',100.*sc.noise_levels,'y',sc.values,'color',sc.label,'row',sc.a,'column',sc.b);
g.set_names('color','Controller','x','100*\sigma(\eta)/\sigma(u)%','y','index',...
            'row','\alpha','column','b');
g.axe_property('XLim',[0 1100],'YLim',[0 1.1],'XTick', [1e0 1e1 1e2],...
  'YTick',0:0.2:1,'XScale','log','XGrid','on','Ygrid','on',...
  'GridColor',[0.8 0.8 0.8]);
g.set_text_options('interpreter','tex');
% g.draw()
% g.set_color_options('lightness',70);
g.geom_point();
% g.set_line_options('styles',{'--'})
g.stat_summary('geom','area','type','std');
g.stat_summary('geom','point');
% g.set_color_options('map','brewer1');
% g.set_color_options('map','brewer2');
g.set_color_options('map','matlab');
% g.set_color_options('hue_range',[-60 60],'chroma',40,'lightness',90); % (bad)
% g.set_color_options('lightness_range',[0 95],'chroma_range',[0 0]);
g.draw();
set([g.results.geom_point_handle],'MarkerSize',4);
set([g.results.stat_summary.point_handle],'MarkerSize',6);

g.update('y',ones(1,length(sc.noise_levels)))
g.set_color_options('chroma',0,'lightness',70);
g.set_line_options('styles',{':'})
g.set_layout_options('legend',false);
g.geom_line();
g.draw();
g.redraw(0.01)

fig_width = 8;
% g.export('file_name','C1_5-6b5_OL_IV_a000-030-060-100.pdf','file_type','pdf','width',8*nb+4,'height',15);
% g.export('file_name','C1_Td_rapida_b5_OL_IV_a000-030-060-100.pdf','file_type','pdf','width',8*nb+4,'height',15);

% g.axe_property();
% g.set_layout_options('legend',false)
% g.facet_grid(sc.label,[],'scale','fixed');
% g.set_point_options('markers',{'o' 'd' 's' '^' 'v' '>' '<' 'p' 'h' '+' 'o' 'x'});
% g.draw();
% g.stat_summary('geom','point');
% g.geom_hline('yintercept',1);
% g.draw();
% g.export('file_name','MaCso.pdf','file_type','pdf','width',16,'height',15);
% g.set_point_options( 'marker', 'd', 'alpha', 0.5);
% g.stat_glm();
% g.stat_smooth();
% g=gramm('x',sc.ruido,'y',sc.mean,'color',sc.controller)
