function [F_x, F_y, M_z, slipData, mfData, forceData, tireData] = ForceMomentReturn(F_z, V_x, V_y,  gamma, omega, PsiDot, tireData), 

%FORCEMOMENTRETURN Outputs Forces and Moments Acting on Tire
%   Takes velocities and slip quantities and returns the forces acting
%   on the tire. 
%=========================================================================%

% % - tire file name
% fileID      = '205_60_R15_91V_2-2bar.tire';
% 
% % - read tire parameters from .tire file -------------------------------- %
% [tireData]  = readTIRE(fileID);

%====================Arbitrary Values for testing=========================%

velocities.V_x = V_x;
velocities.V_y = V_y;
velocities.PsiDot = PsiDot;
slipData.gamma=0;
slipData.gammaStar=sin(gamma);

alpha = atan(-velocities.V_y/velocities.V_x);

% Zetas for camber < 5 degrees, turnslip < 3.8
mfData.zeta_0=1; 
mfData.zeta_1=1; 
mfData.zeta_2=1; 
mfData.zeta_3=1; 
mfData.zeta_4=1; 
mfData.zeta_5=1;
mfData.zeta_6=1;
mfData.zeta_7=1;
mfData.zeta_8=1;

% - calculate all velocities of interest: ------------------------------- %

% velocities used:
% V_c ..................... magnitude of the velocity of C (contact center)
% V_cx ................................................. x component of V_c
% V_cy ................................................. y component of V_c
% V_s ....................................... wheel slip speed (of point S)
% V_sx ....................................... x component of slip velocity
% V_sy ....................................... y component of slip velocity
% V_r .......... forward speed of rolling (V_r = R_e * omega = V_cx - V_sx)

velocities.V_cx = velocities.V_x;      % pg. 341

%WHICH IS CORRECT FOR V_R?
% From transientMF.m line 139
%velocities.V_r = velocities.V_cx - velocities.V_x + omega * tireData.R_e;
velocities.V_r = omega * tireData.R_e;
velocities.V_sx = velocities.V_x-omega*tireData.R_e; %pg. 67
%velocities.V_sy = velocities.V_x*alpha
velocities.V_sy = - abs(velocities.V_x) * alpha;
velocities.V_cy = velocities.V_sy; %pg. 184
velocities.V_s = sqrt( velocities.V_sx * velocities.V_sx +...
    velocities.V_sy * velocities.V_sy);
velocities.V_c = sqrt( velocities.V_cx * velocities.V_cx +...
    velocities.V_cy * velocities.V_cy );
velocities.V_s = sqrt( velocities.V_sx * velocities.V_sx +...
    velocities.V_sy * velocities.V_sy );

%Lateral Slip
slipData.alpha = atan(-velocities.V_y/velocities.V_x);
slipData.alphaStar  = - velocities.V_cy / abs(velocities.V_cx);
slipData.phi_t      = - velocities.PsiDot / (velocities.V_cx + 0.1);

%Longitudinal Slip
% kappa = -(velocities.V_x-tireData.R_e*omega)/velocities.V_x;
slipData.kappa = -(velocities.V_x-tireData.R_e*omega)/velocities.V_x;
%slipData.kappa = -velocities.V_cy/abs(velocities.V_cx);

%Creating Structure Arrays;
epsilons=struct;
forceData.F_z=F_z;
forceData.F_z0=tireData.F_z0;
forceData.Fprime_z0=forceData.F_z0*tireData.lambda_Fz0;


[ forceData, tireData, mfData ] = PureLongitudinalFunction(forceData, slipData, velocities, tireData, mfData );
[ forceData, tireData, mfData ] = PureLateralFunction(forceData, slipData, velocities, tireData, mfData );
[ forceData, tireData, mfData ] = PureAligningTorqueFunction( forceData, slipData, tireData, mfData );
[ forceData, mfData ] = CombinedLongitudinalFuntion(slipData,forceData,tireData,mfData);
[ forceData, mfData ] = CombinedLateralFunction(slipData,forceData,tireData,mfData);
[ forceData, mfData ] = CombinedAligningTorque( forceData, slipData, tireData, mfData);


F_x = forceData.F_x;
F_y = forceData.F_y;
M_z = forceData.M_z;

end


