function plotscore(score)

sm = score.mean;
ss = score.std;
nl = score.noise_levels(1:length(sm));

%% Scores Plot:

fontsz = 8;

semilogx(100*nl,sm,'ko',100*nl,sm+ss,'k+',100*nl,sm-ss,'k+');
set(gca,'FontSize', fontsz)
xlabel('100 x std(noise)/std(signal)');
ylabel('index');
ylim([-0.2 1.2]);
hold on;
limite = 100*[0.9*nl(1) 1.1*nl(end)];
plot(limite, [1, 1], 'k--');
plot(limite, [0, 0], 'k--');
xlim(limite);
% hold off;
grid on;


end

