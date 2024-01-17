function [LSH, LD_HH, LD_LH, LD_IH, LSL, LD_HL, LD_LL, LD_IL] = labor_demand(wH, wL, wI, p)
    gamma = p.gamma;
    rho   = p.rho;
    alpha = p.alpha;
    a     = p.a;
    b     = p.b;
    kappa = p.kappa;
    
    G = (b+ (wI/(wL*b))^((gamma)/(1-gamma)) )^((rho-gamma)/gamma);
    J = ( (a*G^(rho/(rho - gamma))) + (wI/(G*a*b*wH))^(rho/(1-rho))  )^((alpha-rho)/(rho));
    
    % High skill
    IzH =  ((p.avecH.* (kappa*alpha * J * G * a * b))./(wI)).^(1/(1-alpha));
    LzH =  IzH .*( (wI/(wL*b))^(1/(1-gamma)) );
    HzH =  IzH .*( (wI/(G*a*b*wH)) )^(1/(1-rho));
    profitH = p.avecH.*kappa.*(   ( ( ((IzH.^gamma).*b + (LzH.^gamma)).*a).^(rho/gamma) + HzH.^rho ).^(alpha/rho)) - (HzH.*wH + LzH.*wL + IzH.*wI);
    wvecH = wH * ones(length(profitH), 1);
    LSH = sum(wvecH > profitH);
    LD_HH = (profitH > wH)' * HzH;
    LD_LH = (profitH > wH)' * LzH;
    LD_IH = (profitH > wH)' * IzH;

    % Low skill
    IzL =  ((p.avecL.* (alpha * J * G * a * b))./(wI)).^(1/(1-alpha));
    LzL =  IzL .*( (wI/(wL*b))^(1/(1-gamma)) );
    HzL =  IzL .*( (wI/(G*a*b*wH)) )^(1/(1-rho));
    profitL = p.avecL.*(   ( ( ((IzL.^gamma).*b + (LzL.^gamma)).*a).^(rho/gamma) + HzL.^rho ).^(alpha/rho)) - (HzL.*wH + LzL.*wL + IzL.*wI);
    wvecL = wL * ones(length(profitL), 1);
    LSL = sum(wvecL > profitL);
    LD_HL = (profitL > wL)' * HzL;
    LD_LL = (profitL > wL)' * LzL;
    LD_IL = (profitL > wL)' * IzL;
    
end    
    
   
