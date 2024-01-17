function [LSH, LD_HH, LD_LH, LD_IH, LSL, LD_HL, LD_LL, LD_IL] = labor_demand(wH, wL, wI, p)
    gamma = p.gamma;
    rho   = p.rho;
    alpha = p.alpha;
    a     = p.a;
    b     = p.b;
    kappa = p.kappa;
    
    G = (b+ (wI/(wL*b))^((gamma)/(1-gamma)) )^((rho-gamma)/gamma);
    J = ( (a*G^(rho/(rho - gamma))) + (wI/(G*a*b*wH))^(rho/(1-rho))  )^((alpha-rho)/(rho));

    commonExp1 = (wI/(wL*b))^(1/(1-gamma));
    commonExp2 = ( (wI/(G*a*b*wH)) )^(1/(1-rho));

    % High skill
    IzH =  ((p.avecH.* (kappa*alpha * J * G * a * b))./(wI)).^(1/(1-alpha));
    LzH =  IzH .*commonExp1;
    HzH =  IzH .*commonExp2;
    profitH = p.avecH.*kappa.*(   ( ( ((IzH.^gamma).*b + (LzH.^gamma)).*a).^(rho/gamma) + HzH.^rho ).^(alpha/rho)) - (HzH.*wH + LzH.*wL + IzH.*wI);
    wvecH = wH * ones(length(profitH), 1);
    LSH = sum(wvecH > profitH);

    LD_HH = sum(HzH(profitH > wH));
    LD_LH = sum(LzH(profitH > wH));
    LD_IH = sum(IzH(profitH > wH));

    % Low skill
    IzL =  ((p.avecL.* (alpha * J * G * a * b))./(wI)).^(1/(1-alpha));
    LzL =  IzL .*commonExp1;
    HzL =  IzL .*commonExp2;
    profitL = p.avecL.*(   ( ( ((IzL.^gamma).*b + (LzL.^gamma)).*a).^(rho/gamma) + HzL.^rho ).^(alpha/rho)) - (HzL.*wH + LzL.*wL + IzL.*wI);
    wvecL = wL * ones(length(profitL), 1);
    LSL = sum(wvecL > profitL);

    LD_HL = sum(HzL(profitL > wL));
    LD_LL = sum(LzL(profitL > wL));
    LD_IL = sum(IzL(profitL > wL));

end
