function [LSH, LD_HH, LD_LH, LD_IH, LSL, LD_HL, LD_LL, LD_IL] = labor_demand2(wH, wL, wI, p)
    gamma = p.gamma;
    rho   = p.rho;
    alpha = p.alpha;
    d     = p.d;
    b     = p.b;
    kappa = p.kappa;
    
    G = ((b+ d*((wI/wL)*(d/b)))^((gamma)/(1-gamma)))^((rho-gamma)/gamma);
    J = ( (G^(rho/(rho - gamma))) + (wI/(G*b*wH))^(rho/(1-rho))  )^((alpha-rho)/(rho));

    commonExp1 = ((wI/wL)*(d/b))^(1/(1-gamma));
    commonExp2 = ( (wI/(G*b*wH)) )^(1/(1-rho));

    % High skill
    IzH =  ((p.avecH.* (kappa*alpha * J * G * b))./(wI)).^(1/(1-alpha));
    LzH =  IzH .*commonExp1;
    HzH =  IzH .*commonExp2;
    profitH = p.avecH.*kappa.*(   ( ( ((IzH.^gamma).*b + (LzH.^gamma).*d)).^(rho/gamma) + HzH.^rho ).^(alpha/rho)) - (HzH.*wH + LzH.*wL + IzH.*wI);

    LSH = sum(wH > profitH);

    LD_HH = sum(HzH(profitH > wH));
    LD_LH = sum(LzH(profitH > wH));
    LD_IH = sum(IzH(profitH > wH));

    % Low skill
    IzL =  ((p.avecL.* (alpha * J * G * b))./(wI)).^(1/(1-alpha));
    LzL =  IzL .*commonExp1;
    HzL =  IzL .*commonExp2;
    profitL = p.avecL.*((((IzL.^gamma).*b + (LzL.^gamma).*d).^(rho/gamma) + HzL.^rho ).^(alpha/rho)) - (HzL.*wH + LzL.*wL + IzL.*wI);

    LSL = sum(wL > profitL);

    LD_HL = sum(HzL(profitL > wL));
    LD_LL = sum(LzL(profitL > wL));
    LD_IL = sum(IzL(profitL > wL));

end
