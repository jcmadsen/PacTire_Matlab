function [ forceData, mfData ] = CombinedAligningTorque( forceData, slipData, tireData, mfData)
%=========================================================================%
% This function computes the quantities needed to calculate the
% self-aligning torque for combined slip.
%=========================================================================%

mfData.FPrime_y  = forceData.F_y - mfData.lateralForce.S_VyKap;

mfData.aligningTorque.alpha_tEq = sqrt( mfData.aligningTorque.alpha_t* mfData.aligningTorque.alpha_t + ( mfData.longitudinalForce.K_xKap*mfData.longitudinalForce.K_xKap)/( mfData.aligningTorque.KPrime_yAlp*...
     mfData.aligningTorque.KPrime_yAlp) * slipData.kappa*slipData.kappa) * sign( mfData.aligningTorque.alpha_t);

mfData.t =  mfData.aligningTorque.D_t * cos(mfData.aligningTorque.C_t * atan(mfData.aligningTorque.B_t* mfData.aligningTorque.alpha_tEq - mfData.aligningTorque.E_t * (mfData.aligningTorque.B_t* mfData.aligningTorque.alpha_tEq - ...
    atan(mfData.aligningTorque.B_t* mfData.aligningTorque.alpha_tEq)))) * mfData.cosPrimeAlpha;

mfData.MPrime_z  = - mfData.t * mfData.FPrime_y;

mfData.aligningTorque.alpha_rEq = sqrt( mfData.aligningTorque.alpha_r* mfData.aligningTorque.alpha_r + (mfData.longitudinalForce.K_xKap*mfData.longitudinalForce.K_xKap)/(mfData.aligningTorque.KPrime_yAlp*...
     mfData.aligningTorque.KPrime_yAlp) * slipData.kappa*slipData.kappa) * sign(mfData.aligningTorque.alpha_r);

mfData.M_zr = mfData.aligningTorque.D_r * cos(mfData.aligningTorque.C_r * atan(mfData.aligningTorque.B_r* mfData.aligningTorque.alpha_rEq));


mfData.s = tireData.R_0 * (tireData.s_sz1 + tireData.s_sz2 * (forceData.F_y/forceData.Fprime_z0) + (tireData.s_sz3 + tireData.s_sz4 * ...
    forceData.df_z) * slipData.gammaStar) * tireData.lambda_s;




%=========================================================================%

forceData.M_z = mfData.MPrime_z + mfData.M_zr + mfData.s * forceData.F_x;

%=========================================================================%
end