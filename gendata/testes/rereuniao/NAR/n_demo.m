% NARMAX Demonstration - Householder Transformation Algorithm

% Eduardo Mendes & Luis Aguirre, January 1995.
% mendes@acse.shef.ac.uk & aguirre@cpdee.ufmg.br

echo on;


% Example - Non-Autonomous System - Duffing_Ueda
% See the paper                         
%
% Aguirre, L.A. and Billings, S.A., (1994), Validating nonlinear
%    identified models with chaotic dynamics, Int. J. Bifurcation
%    and Chaos, vol. 4, no. 1, 109-125.


% Load data
load sdpi60.dat
%y=sdpi60(1:1900,2);
%u=sdpi60(1:1900,1);

% short-cut
yi=sdpi60(1:500,2);
ui=sdpi60(1:500,1);
y=sdpi60(1001:1900,2);
u=sdpi60(1001:1900,1);
 

% Generate set of candidate terms with: degree of nonlinearity=3,
% maximum lag for output terms=3, and 
% maximum lag for input terms=3.
[Cand,tot2]=genterms(3,3,3);
% Add 20 linear noise terms, i.e. from e(k-1) to e(k-20), in
% order to avoid bias during parameter estimation.
Cand=[Cand;(3001:1:3020)' zeros(20,2)];

% In most cases cross-product noise terms and nonlinear noise terms
% are not necessary.

% Now we can proceed to the identification
[model,x,e,va]=orthreg(Cand,ui,yi,[7 20],5);


% Here, 9 defines the total number of "process" terms
% in the model. The 20 indicates that all linear noise
% terms should be used during parameter estimation. 
% Finally, 5 indicates the number of noise iterations
% to be performed. This is a 'standard' choice. For systems
% in which the convergence of the residuals is slow this 
% can be increased. The choice of the number of process terms
% should be carefully considered for each case. For some
% details on this see, for instance,
%
% Aguirre, L.A. and Billings, S.A. (1994), Dynamical effects of
%    overparametrization in nonlinear models, Physica D, vol 80,
%    nos. 1/2, pp. 26-40.


% Simulate the identified model
% ym=simodeld(model,x(:,1),u,y(1:20));
ym=simodeld(model,x(:,1),u(31:200),y(31:50));

% In the above command
% model and x(:,1) selects respectively
% the terms (nine chosen process terms and all noise terms) 
% and their respective coefficients. y(1:20) are
% the initial conditions which have been taken from the original
% data, i.e. on the attractor.

% MPO (or free-run) comparison

%figure(1);plot([y ym]);title('Free-run comparison');
figure(1);plot([u(31:200) y(31:200) ym]);
%figure(2);plot(y,shift_co(y,4),'-');title('Original');
%figure(3);plot(ym,shift_co(ym,4),'-');title('Model');

% Listing the model in latex format

%t2=ols2tex(model,x(:,1))

