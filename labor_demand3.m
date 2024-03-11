function [LSH, LD_HH, LD_LH, LD_IH, LSL, LD_HL, LD_LL, LD_IL] = labor_demand3(wH, wL, wI, p)
    rho   = p.rho;
    alpha = p.alpha;
    a    = p.a;
    b    = p.b;
    c    = p.c;
    kappa = p.kappa;
    
    exponent = (alpha-rho)/(rho*(1-alpha));
    commonExp1 = ((a/(wI^rho))^(1/(1-rho)) + (b/(wL^rho))^(1/(1-rho)) + (c/(wH^rho))^(1/(1-rho)))^exponent;
 
    % High skill
    IzH =  (p.avecH.* (alpha).^(1/(1-alpha))).*((a/wI)^(1/(1-rho))).*commonExp1 ;
    LzH =  (p.avecH.* (alpha).^(1/(1-alpha))).*((b/wL)^(1/(1-rho))).*commonExp1 ;
    HzH =  (p.avecH.* (alpha).^(1/(1-alpha))).*((c/wH)^(1/(1-rho))).*commonExp1 ;
    profitH = p.avecH.*kappa.*((a*IzH.^rho + b*LzH.^rho + c*HzH.^rho).^(alpha/rho)) - (HzH.*wH + LzH.*wL + IzH.*wI);

    LSH = sum(wH > profitH);

    LD_HH = sum(HzH(profitH > wH));
    LD_LH = sum(LzH(profitH > wH));
    LD_IH = sum(IzH(profitH > wH));

    % Low skill
    IzL =  (p.avecL.* (alpha).^(1/(1-alpha))).*((a/wI)^(1/(1-rho))).*commonExp1 ;
    LzL =  (p.avecL.* (alpha).^(1/(1-alpha))).*((b/wL)^(1/(1-rho))).*commonExp1 ;
    HzL =  (p.avecL.* (alpha).^(1/(1-alpha))).*((c/wH)^(1/(1-rho))).*commonExp1 ;
    profitL = p.avecL.*kappa.*((a*IzL.^rho + b*LzL.^rho + c*HzL.^rho).^(alpha/rho)) - (HzL.*wH + LzL.*wL + IzL.*wI);

    LSL = sum(wL > profitL);

    LD_HL = sum(HzL(profitL > wL));
    LD_LL = sum(LzL(profitL > wL));
    LD_IL = sum(IzL(profitL > wL));

end
