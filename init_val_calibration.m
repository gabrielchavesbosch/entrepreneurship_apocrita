%% parameters, settings and moments
clear all

LE = 4;
rho_grid    = linspace(0.4, 0.8, LE);
gamma_grid  = linspace(0.4, 0.8, LE);
a_grid      = linspace(0.3, 0.8,LE); 
b_grid      = linspace(0.3, 0.8,LE);
muH_grid    = linspace(0.3, 0.6, LE);
muL_grid    = linspace(0.6, 0.6, LE);
sigmaH_grid = linspace(0.01, 0.3, LE);
sigmaL_grid = linspace(0.01, 0.3, LE);


parameters = combvec(rho_grid, gamma_grid, a_grid, b_grid, muH_grid, muL_grid, sigmaH_grid, sigmaL_grid )';
n = LE^8;
results = ones(n, 10);

tic
M = 24; % M specifies maximum number of workers
  parfor (it = 1:n,M)
 
 
p = [];
 
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


    % Parameters
    p.alpha = 0.9;                                    % DRS parameter. so profit share of income is 10%, as in Poschke 2018, bc profit = revenue * (1-alpha)),
    p.bins = 10000;                                  % number of people (and levels of ability)
    p.Ib = p.bins*0.0219;                             %  Chosen to make immigrant share equal baseline immigrant share (= 0.0214)
    p.Ia = p.bins*0.16274;                           %  Chosen to make immigrant share equal to post-shock immigrant share (= 0.14)
    p.shareL = 0.464;

    % Rho and gamma (substitution parameters); a and b (rel. productivity low
    % skill and relative productivity immigrants); lognormal mean H, L and
    % lognormal stde H and L
    p.rho    = parameters(it, 1);
    p.gamma  = parameters(it, 2);
    p.a      = parameters(it, 3);
    p.b      = parameters(it,4);
    p.muH    = parameters(it,5);
    p.muL    = parameters(it,6);
    p.sigmaH = parameters(it,7);
    p.sigmaL = parameters(it,8);
    p.kappa = 1;
 
        % distribution of a:
    % nr grid points
    p.avecH = sort(lognrnd(p.muH,p.sigmaH,p.bins*(1-p.shareL),1));
    p.avecL = sort(lognrnd(p.muL,p.sigmaL,p.bins*p.shareL,1));

    %p.kappa = parameters(5);
    options = optimset('Display','none');
    x0 = [1,1,1];
    

    % Before
    p.I = p.Ib;
    xb = fsolve(@excess_LD,x0, options, p);
    wHb = xb(1);
    wLb = xb(2);
    wIb = xb(3);
    [LSHb, LD_HHb, LD_LHb, LD_IHb, LSLb, LD_HLb, LD_LLb, LD_ILb] = labor_demand(wHb, wLb, wIb, p);
    share_entrepreneur_H_b = (p.bins*(1-p.shareL) -(LSHb))/(p.bins*(1-p.shareL));
    share_entrepreneur_L_b = (p.bins*(p.shareL) -  (LSLb))/(p.bins*(p.shareL));
    
    % After
    p.I = p.Ia;
    xa = fsolve(@excess_LD,x0, options, p);
    wHa = xa(1);
    wLa = xa(2);
    wIa = xa(3);
    [LSHa, LD_HHa, LD_LHa, LD_IHa, LSLa, LD_HLa, LD_LLa, LD_ILa] = labor_demand(wHa, wLa, wIa, p);
    share_entrepreneur_H_a = (p.bins*(1-p.shareL) -(LSHa))/(p.bins*(1-p.shareL));
    share_entrepreneur_L_a = (p.bins*(p.shareL) -  (LSLa))/(p.bins*(p.shareL));
    
    % Data moments
    Mhat = [p.data_share_entrepreneur_H_b, p.data_share_entrepreneur_L_b...
            , p.data_change_entrepreneur_H,p.data_change_entrepreneur_L...
            ,p.data_rel_wage_H, p.data_rel_wage_L ...
            ,p.data_change_wage_H, p.data_change_wage_L, p.data_rel_wage_I];

    change_entrepreneur_H  = share_entrepreneur_H_a - share_entrepreneur_H_b;
    change_entrepreneur_L = share_entrepreneur_L_a - share_entrepreneur_L_b;
    
    rel_wage_L = wLb / wIb;
    rel_wage_H = wHb / wLb;
    rel_wage_I = wLa/wIa;
    
    change_wage_L = wLa/wLb;
    change_wage_H = wHa/wHb;
    
    MS = [share_entrepreneur_H_b, share_entrepreneur_L_b, change_entrepreneur_H, change_entrepreneur_L...
        , rel_wage_H,  rel_wage_L, change_wage_H, change_wage_L, rel_wage_I]; 

    % For now, diagonal matrix
    variances = [1,0.5,0.1,0.1,1,0.1,1,1,1];
    W = diag(variances)^-1 ;

    Q = (MS-Mhat)*W*(MS-Mhat)';

    results(it,:) = [parameters(it,:), Q];

 end
toc



minimum = sortrows(results, 10);
howmany = 10;
bottom = minimum(1:howmany, :);
 
writematrix(bottom, 'initial.txt')

bottom




