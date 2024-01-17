%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
% This program runs the MM estimation of the parameter vector /
% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

clear all
 
% Eight moments: 
% not too bad: 0.3023    0.4966    0.8064    0.4021    0.3050    0.2015    0.0101    0.1078
% other nice values: [0.3033   , 0.5200 ,   0.8200  ,  0.3800  ,  0.3100  ,  0.1500   , 0.0170   , 0.1500];
% 27/11 BEST values so far:  0.2704    0.5201    0.8221    0.3935    0.3330
% 0.1841    0.0171    0.150 (with eight moments)
% quite good 27/11: 0.2746    0.5284    0.8337    0.3980    0.3378    0.1849    0.0167    0.1476

% 0.5125    0.8000    0.8000    0.5250    0.3000    0.1000    0.0100    0.1550    0.0038
%     0.2500    0.8000    0.9000    0.5250    0.4000    0.2250    0.0100    0.1550    0.0072
%     0.6000    0.6000    0.5000    0.3000    0.3500    0.2250    0.0100    0.0825    0.0075
%     0.6000    0.8000    0.7000    0.4500    0.2000    0.1000    0.0100    0.0825    0.0080
%     0.2500    0.6000    0.9000    0.3750    0.4000    0.2250    0.0100    0.1550    0.0084
%     0.4250    0.8000    0.7000    0.5250    0.4000    0.2250    0.0100    0.1550    0.0086
%     0.6000    0.6000    0.5000    0.3000    0.4000    0.2875    0.0100    0.0825    0.0086
%     0.3375    0.7000    0.9000    0.4500    0.3000    0.1000    0.0100    0.1550    0.0087
%     0.6000    0.6000    0.7000    0.3000    0.2000    0.1000    0.0100    0.0825    0.0088
%     0.6000    0.8000    0.7000    0.4500    0.2500    0.1625    0.0100    0.0825    0.0094

% Moments to be matched
p.data_share_entrepreneur_H_b   = 0.113;  % baseline, data
p.data_share_entrepreneur_L_b   = 0.142;  % baseline, data
p.data_change_entrepreneur_H    = 0.0143; % (6.27-1.8)*3.01*(0.66 * 0.13 + 0.064 * 0.33)
p.data_change_entrepreneur_L    = 0.0039; % (6.27-1.8)*3.01*(0.66 * 0.051 - 0.013 * 0.33)
p.data_rel_wage_H               = 1.19;   % baseline, data
p.data_rel_wage_L               = 1.03;    % baseline, data
p.data_rel_wage_I               = 1.43;   % after shock, data 
p.data_change_wage_H            = 1;      % not significant
p.data_change_wage_L            = 1.0609; % (6.27-1.8)*(1.364) (log change so percentage increase in wages) 


%% Parameters
p.alpha = 0.9;                                    % DRS parameter. so profit share of income is 10%, as in Poschke 2018, bc profit = revenue * (1-alpha)),
p.bins = 100000;                                  % number of people (and levels of ability)
p.Ib = p.bins*0.0219;                             %  Chosen to make immigrant share equal baseline immigrant share (= 0.0214)
p.Ia = p.bins*0.16274;                           %  Chosen to make immigrant share equal to post-shock immigrant share (= 0.14)
p.shareL = 0.464;
p.kappa =1;
%p.sigmaH=.2;
%p.sigmaL=.1;

%% SMM
% If I introduce heterogeneity, I might have to simulate for several data
% sets, as in Ulyssea (2018).
     
% Rho and gamma (substitution parameters); a and b (rel. productivity low
% skill and relative productivity immigrants); lognormal mean H, L and
% lognormal stde H and L
parameters0 = [ 0.2500  ,  0.8000  ,  0.9000   , 0.5250  ,  0.4000 ,   0.2250  ,  0.0100 ,   0.1550  ,  0.0072 ];
 
 
% not too bad (before diferent moments, 14 nov) ->  0.3044    0.9167    0.9024    0.6798    0.4074    0.2961    0.0101    0.1058    0.0089
  

% Actually, to find initial parameters, one must create a grid of "likely
% values" for each parameter, and then simulate the model for each one of
% them, and take the one that minimises the distance (maybe sum relative
% absolute deviations, to take a different measure). Use these as initial
% values in this loop.

options = optimset('Display', 'none','TolFun',0.000000001,'TolX',0.00000001,'MaxIter',3000,'MaxFunEvals',3000);
[estimates,fval] = fminsearch(@SMM_estimate,parameters0, options, p);

