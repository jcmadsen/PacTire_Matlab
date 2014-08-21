clear
close all
clc

F_z = [6000,10000];
V_x = 20;
V_y = 0;
omega = 32.786; %V_x~=omega*R_e => omega=V_x/R_e, 10[m/s]/.305=32.786
gamma = 0;
PsiDot=0;

% - tire file name
%fileID      = '205_60_R15_91V_2-2bar.tire';
% TODO: figure out C_Fx and C_Fy from the input file below do in the calcs
fileID      = '235_60_R16.tir';
% - read tire parameters from .tire file -------------------------------- %
[tireData]  = readTIRE(fileID);

%Longitudinal Slip Curve Generation
% zero slip when V_x=R_e*omega, so max slip occurs at 2*omega
omegaArray=linspace(0, 2.0*V_x/tireData.R_e ,100);  % tire angular velocity
kappa=zeros(length(omegaArray));
F_x_arr=zeros(length(omegaArray), length(F_z));
F_y_arr=zeros(length(omegaArray), length(F_z));
M_z_arr=zeros(length(omegaArray), length(F_z));
alpha_arr=zeros(length(omegaArray), length(F_z));
kappa_arr=zeros(length(omegaArray), length(F_z));
% for each vertical tire load, iterate over the range of omegas
for j=1:length(F_z)
    for i=1:length(omegaArray)
        [F_x, F_y, M_z, slipData, mfData, forceData, tireData] = ForceMomentReturn(F_z(j), V_x, V_y, gamma, omegaArray(i), PsiDot, tireData);
        F_x_arr(i,j) = F_x;
        F_y_arr(i,j) = F_y;
        M_z_arr(i,j) = M_z;
        alpha_arr(i,j) = slipData.alpha;
        kappa_arr(i,j) = slipData.kappa;
    end
end

% always plot F_x, F_y and M_z
figure('Name','Longitudinal: F_x [N]')
plot(kappa_arr(1:end,1),F_x_arr(1:end,1));
hold on;
plot(kappa_arr(1:end,2),F_x_arr(1:end,2),'r--');
xlabel('kappa'), ylabel('F_x [N]');
grid on;
legend('F_z = 6 kN','F_z = 10 kN','Location','NorthWest')

figure('Name','Longitudinal: F_y [N]')
plot(kappa_arr(1:end,1),F_y_arr(1:end,1));
hold on;
plot(kappa_arr(1:end,2),F_y_arr(1:end,2),'r--');
xlabel('kappa'), ylabel('F_y [N]');
grid on;
legend('F_z = 6 kN','F_z = 10 kN','Location','NorthWest')

figure('Name','Longitudinal: M_z [N-m]')
plot(kappa_arr(1:end,1),M_z_arr(1:end,1));
hold on;
plot(kappa_arr(1:end,2),M_z_arr(1:end,2),'r--');
xlabel('kappa'), ylabel('M_z [N-m]');
grid on;
legend('F_z = 6 kN','F_z = 10 kN','Location','NorthWest')

%Lateral Slip and Aligning Torque Curve Generation
alpha_max = 15.0*pi/180.0;  % maximum lateral slip angle, radians
maxVy = -V_x*tan(alpha_max);    % alpha = atan(-V_y/V_x)
V_yArray = linspace(-maxVy,maxVy,100);
%V_yArray=-57:0.5:57; %Correlates to alpha range -80 to 80 degrees.
%V_yArray=-3.65:0.05:3.65; %Correlates to alpha range -20 to 20 degrees. 
alpha_arr = zeros(length(V_yArray),length(F_z));
F_x_arr_lat = zeros(length(V_yArray),length(F_z));
F_y_arr_lat = zeros(length(V_yArray),length(F_z));
M_z_arr_lat = zeros(length(V_yArray),length(F_z));
for j=1:length(F_z)
    for i=1:length(V_yArray)
        V_x_curr = sqrt(V_x^2 - V_yArray(i));
        [F_x, F_y, M_z, slipData, mfData, forceData, tireData] = ForceMomentReturn(F_z(j), V_x_curr, V_yArray(i), gamma, omega, PsiDot, tireData);
        % [F_x, F_y, M_z, slipData, mfData, forceData, tireData] = ForceMomentReturn(F_z(j), V_x, V_yArray(i), gamma, omega, PsiDot, tireData);
        alpha_arr(i,j) = slipData.alpha*180/pi;%convert alpha to degrees
        F_y_arr_lat(i,j) = F_y;
        F_x_arr_lat(i,j) = F_x;
        M_z_arr_lat(i,j) = M_z;
    end
end

% pure lateral slip: plot F_x, F_y and M_z vs. alpha
figure('Name','Lateral, F_x [N]')
plot(alpha_arr(1:end,1),F_x_arr_lat(1:end,1));
hold on;
plot(alpha_arr(1:end,2),F_x_arr_lat(1:end,2),'r--');
xlabel('alpha'), ylabel('F_x [N]');
grid on;
legend('F_z = 6 kN','F_z = 10 kN','Location','NorthWest')

figure('Name','Lateral F_y [N]')
plot(alpha_arr(1:end,1),F_y_arr_lat(1:end,1));
hold on;
plot(alpha_arr(1:end,2),F_y_arr_lat(1:end,2),'r--');
xlabel('alpha'), ylabel('F_y [N]');
grid on;
legend('F_z = 6 kN','F_z = 10 kN')

figure('Name','Lateral M_z [N-m]')
plot(alpha_arr(1:end,1),M_z_arr_lat(1:end,1));
hold on;
plot(alpha_arr(1:end,2),M_z_arr_lat(1:end,2),'r--');
xlabel('alpha'), ylabel('M_z [N-m]');
grid on;
legend('F_z = 6 kN','F_z = 10 kN','Location','NorthWest')
