clear
scriptspath = '../ERR/dependency/';
addpath(scriptspath)

ramsdatapath = '../DATA23/RaMSS/2309/';

fi = 0;
bv = [1 2 5 10 50];
nb = length(bv);
% for c=1:8
for c=1:4
% for c=[3 4 7 8] % Caso com Td mais lento (ts2 = 50*Ts)
  for b=bv
    % for a=[0 30 60 100]
    for a=[0 30 60 100]
      fi = fi +1;
      modelname = ['C1_' num2str(c) 'b', num2str(b), '_OL'];
      files{fi} = [ramsdatapath modelname '/' modelname '_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a' num2str(a,'%0.3d') '.mat'];
      fb(fi) = b;
    end
  end
end

nf = length(files);
j = 0;
for i = 1:nf
  % score = compute_score(files{i});
  metrics = compute_metrics_from_mat_file(files{i},6,true);
  [Nn,Nmc] = size(metrics);
   for n = 1:Nn
     for c = 1:Nmc
       j = j+1;
       mtrc.noise_level(j) = metrics{n,c}.noise_level;
       mtrc.mape.nsregs(j) = metrics{n,c}.nsregs.mape;
       mtrc.mape.tregs(j) = metrics{n,c}.tregs.mape;
       mtrc.mape.diff(j) =  metrics{n,c}.nsregs.mape/metrics{n,c}.tregs.mape;
       mtrc.a(j) = metrics{n,c}.a;
       mtrc.b(j) = fb(i);
       mtrc.label{j} = metrics{n,c}.label;
     end
   end
end


figure(9); clf;
clear g
% g=gramm('x',100.*mtrc.noise_level,'y',mtrc.mape.diff,'color',mtrc.label,'row',mtrc.a,'column',mtrc.b);
g=gramm('x',100.*mtrc.noise_level,'y',mtrc.mape.diff,'color',mtrc.label);
g.set_names('color','Controller','x','100*\sigma(\eta)/\sigma(u)%','y','index',...
            'row','\alpha','column','b');
g.axe_property('XLim',[0 1100],'XTick', [1e0 1e1 1e2],...
  'XScale','log','XGrid','on','YLim',[0 5],'Ygrid','on','YTick', 1:5,...
  'GridColor',[0.8 0.8 0.8]);
% g.axe_property('XLim',[0 1100],'XTick', [1e0 1e1 1e2],...
%   'XScale','log','YScale','log','XGrid','on','Ygrid','on',...
%   'GridColor',[0.8 0.8 0.8]);
g.set_text_options('interpreter','tex');
g.facet_grid(mtrc.a,mtrc.b,'scale','free');
% g.geom_point();
g.stat_summary('geom','area','type','std');
g.stat_summary('geom','point');
% g.stat_boxplot();
g.set_color_options('map','matlab'); % brewer1, brewer2, hue_range, lightness_range
g.draw();
set([g.results.geom_point_handle],'MarkerSize',4);
set([g.results.stat_summary.point_handle],'MarkerSize',6);
% g.set_color_options('chroma',0,'lightness',70);
g.set_line_options('styles',{':'})
g.set_layout_options('legend',false);
% g.geom_line();
g.draw();
% g.redraw(0.01);

% fig_width = 8;

% g.export('file_name','C1_5-6b5_OL_IV_a000-030-060-100.pdf','file_type','pdf','width',8*nb+4,'height',15);
% g.export('file_name','C1_Td_rapida_b5_OL_IV_a000-030-060-100.pdf','file_type','pdf','width',8*nb+4,'height',15);
