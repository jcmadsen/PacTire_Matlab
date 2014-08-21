function [forceData,mfData] = CombinedLateralFunction(slipData,forceData,tireData,mfData)

%=========================================================================%
% This function computes the quantities needed to calculate the
% lateral force for combined slip.
%=========================================================================%

mfData.lateralForce.S_HyKap = tireData.r_Hy1 + tireData.r_Hy2 * forceData.df_z;

mfData.lateralForce.kappa_s = slipData.kappa + mfData.lateralForce.S_HyKap;

mfData.lateralForce.B_yKap  = (tireData.r_By1 + tireData.r_By4 * ...
    slipData.gammaStar * slipData.gammaStar) * cos(atan(tireData.r_By2 * ...
    (slipData.alphaStar - tireData.r_By3))) * tireData.lambda_yKap;

mfData.lateralForce.C_yKap  = tireData.r_Cy1;

mfData.lateralForce.E_yKap  = tireData.r_Ey1 + tireData.r_Ey2 * forceData.df_z;

mfData.lateralForce.D_VyKap = mfData.lateralForce.mu_y * forceData.F_z * ...
    (tireData.r_Vy1 + tireData.r_Vy2 * forceData.df_z + tireData.r_Vy3 * ...
    slipData.gammaStar) * cos(atan(tireData.r_Vy4 * slipData.alphaStar)) * ...
    mfData.zeta_2;

mfData.lateralForce.S_VyKap = mfData.lateralForce.D_VyKap * sin(tireData.r_Vy5 * ...
    atan(tireData.r_Vy6 * slipData.kappa)) * tireData.lambda_VyKap;

mfData.lateralForce.G_yKap0 = cos(mfData.lateralForce.C_yKap * ...
    atan(mfData.lateralForce.B_yKap * mfData.lateralForce.S_HyKap - ...
    mfData.lateralForce.E_yKap * (mfData.lateralForce.B_yKap * ...
    mfData.lateralForce.S_HyKap - ...
    atan(mfData.lateralForce.B_yKap * mfData.lateralForce.S_HyKap))));

mfData.lateralForce.G_yKap  = cos(mfData.lateralForce.C_yKap * ...
    atan(mfData.lateralForce.B_yKap * mfData.lateralForce.kappa_s - ...
    mfData.lateralForce.E_yKap * (mfData.lateralForce.B_yKap * mfData.lateralForce.kappa_s - ...
    atan(mfData.lateralForce.B_yKap*mfData.lateralForce.kappa_s)))) / ...
    mfData.lateralForce.G_yKap0;

%=========================================================================%

forceData.F_y     = mfData.lateralForce.G_yKap * forceData.F_y0 + ...
    mfData.lateralForce.S_VyKap;

%=========================================================================%
end