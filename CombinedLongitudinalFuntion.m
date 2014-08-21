function [forceData,mfData] = CombinedLongitudinalFuntion(slipData,forceData,tireData,mfData)

%=========================================================================%
% This function computes the quantities needed to calculate the
% longitudinal force for combined slip.
%=========================================================================%

mfData.longitudinalForce.S_HxAlp = tireData.r_Hx1;

mfData.longitudinalForce.alpha_S = slipData.alphaStar + mfData.longitudinalForce.S_HxAlp;

mfData.longitudinalForce.B_xAlp  = (tireData.r_Bx1 + tireData.r_Bx3 * ...
    slipData.gammaStar*slipData.gammaStar) * cos(atan(tireData.r_Bx2*slipData.kappa))*...
    tireData.lambda_xAlp;

mfData.longitudinalForce.C_xAlp  = tireData.r_Cx1;

mfData.longitudinalForce.E_xAlp  = tireData.r_Ex1 + tireData.r_Ex2 * forceData.df_z;

mfData.longitudinalForce.G_xAlp0 = cos(mfData.longitudinalForce.C_xAlp * ...
    atan(mfData.longitudinalForce.B_xAlp * mfData.longitudinalForce.S_HxAlp - ...
    mfData.longitudinalForce.E_xAlp * (mfData.longitudinalForce.B_xAlp * ...
    mfData.longitudinalForce.S_HxAlp - ...
    atan(mfData.longitudinalForce.B_xAlp * mfData.longitudinalForce.S_HxAlp))));

mfData.longitudinalForce.G_xAlp  = cos(mfData.longitudinalForce.C_xAlp * ...
    atan(mfData.longitudinalForce.B_xAlp * mfData.longitudinalForce.alpha_S - ...
    mfData.longitudinalForce.E_xAlp * (mfData.longitudinalForce.B_xAlp * ...
    mfData.longitudinalForce.alpha_S - ...
    atan(mfData.longitudinalForce.B_xAlp * mfData.longitudinalForce.alpha_S)))) / ...
    mfData.longitudinalForce.G_xAlp0;

%=========================================================================%

forceData.F_x     = mfData.longitudinalForce.G_xAlp * forceData.F_x0;

%=========================================================================%
end