clear
scriptspath = './dependency/';
addpath(scriptspath)

%%%%%%%%%%
%%% Loading data
% sampled_data_path = "~/DOUTORADO/GIT/RaMSS_mat/DATA/Sampled/0829/";
sampled_data_path = "../DATA23/SampledData/2309/";
SAVEDATA = true;

% Controler (1) cases:
% 2nd order linear controller to control a 2n order minimum phase process.
%   The controller is projected using direct syntesis to result to same
%   transitory behaviour, but with differrent final values cases, as follows:
% Cases:
%   1 -> ts2 = 10 ms,  0% ESS
%   2 -> ts2 = 10 ms, 10% ESS
%   3 -> ts2 = 50 ms,  0% ESS
%   4 -> ts2 = 50 ms, 10% ESS
% Model name structure:
%   C1_cbx_XX
%   -- - - --
%    | | | |
%    | | | +-------> (XX): Open Loop (OL) or Closed Loop (CL)
%    | | +---------> (x) : holded samples to generate excitation signal
%    | +-----------> (c) : Case of controller (see above)
%    +-------------> (C1): Linear Controller
% Valid modelnames: C1_cbx_XX, with c = {1-4}; x = {1,-2,-3,-4}; and LL = {OL, CL};
% the modelnames variables is a cell with any nymber of this modelanmes.
% modelsnames = {'C1_1b2_CL', 'C1_2b3_CL', ... };

% modelsnames = {'C1_1b1_CL'};
% modelsnames = {'C1_1b5_CL', 'C1_2b5_CL', 'C1_3b5_CL', 'C1_4b5_CL'};

% sampled_data_filename name convention:
% -> ni: 10th NEGATIVE power expoent for minimum noise (in the data);
% -> nx: 10th POSITIVE power expoent for maximum noise (in the data);
% -> R##: number (##) of monte Carlo realizations;
% -> N##: number (##) of monte noise levels;

sampled_data_filename = 'sampleddata_ni03nx01_R04N05.mat';


% files = strcat(modelsnames, '-', sampled_data_filename);
% nccases = length(files);


% for c = 1:nccases   % controller cases
%   datafile = load(strcat(sampled_data_path, files{c}));
%   score{c} = perform_ERR_and_compute_score(datafile);
% end % controller cases

bv = [1 2 5 10 50];
nb = length(bv);
j=0;
loop_type = "CL";
for c=[1 2 3 4]
  for b=bv
      modelname = strcat('C1_', num2str(c), 'b', num2str(b), '_', loop_type);
      datafile = strcat(sampled_data_path, modelname, '-', sampled_data_filename);
      score = perform_ERR_and_compute_score(datafile);
      [Nn,Nmc] = size(score.values);
      for n = 1:Nn
        for m = 1:Nmc
          j = j+1;
          sc.noise_levels(j) = score.noise_levels(n);
          sc.values(j) = score.values(n,m);
          lb = score.label;
          sc.label{j} = [lb(1), '_', lb(2), '^{', lb(4), '}'] ;
          sc.b(j) = b;
        end
      end
  end
end
  %%%%%%%%%%%


figure(15); clf;
clear g

g=gramm('x',100.*sc.noise_levels,'y',sc.values,'color',sc.label,'column',sc.b);
g.set_names('color','Controller','x','100*\sigma(\eta)/\sigma(u)%','y','index',...
            'column','b');
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
g.export('file_name',strcat('figs/ERR_C1_1-4_b1-2-5-10-50_', loop_type, '.pdf'),'file_type','pdf','width',8*nb+4,'height',10);

% rmpath(scriptspath)
%%
