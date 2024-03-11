function excessLD = excess_LD2(x, p) 

wH = x(1);
wL = x(2);
wI = x(3); 

[LSH, LD_HH, LD_LH, LD_IH, LSL, LD_HL, LD_LL, LD_IL] = labor_demand2(wH, wL, wI, p);

excessLD(1) = (LD_HH + LD_HL - LSH)^2;
excessLD(2) = (LD_LH + LD_LL - LSL)^2;
excessLD(3) = (LD_IH + LD_IL - p.I)^2;
end


