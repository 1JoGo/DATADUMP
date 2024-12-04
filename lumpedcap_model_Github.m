% Matlab m-script to calculate the cooling of a solid by cold
% fluid injection based on a simplified lumped 
% capacitance approach, assuming the solid temperature is uniform 
% at any given time. 
% The heat transfer rate depends on the fluid properties, 
% heat transfer coefficient, and the surface area of contact 
% between the fluid and the solid.
% written by J. Gottsmann (November 2024)

clc; clear; close all;

%% Parameters
T_solid_initial = 950+273; % Initial temperature of the solid (K)
T_fluid = 283;         % Temperature of the cold fluid (K)
h = 1000;                % Heat transfer coefficient (W/m^2.K)
r1=0.2;                % Radius of bore hole (m)
ht1=200;                  %length of drill  inside solid (m)
A =2*pi*r1*ht1%+r1^2*pi; % Surface area of solid exposed to fluid; walls only / remove % to also include bottom (m^2)
k=1; %modulator of surface area by cracking; use k=1, or k=500 to reproduce data presented in Fig. 3 of the paper
A=A*k;
r2=930;               %radius of solid (m)
ht2=ht1;               % thickness of solid
V_solid = r2^2*pi*ht2; % Volume of the solid (m^3)
rho_solid = 2315;      % Density of the solid (kg/m^3)
cp_solid = 1200;        % Specific heat capacity of the solid (J/kg.K)
t_final = 1.3e7;  % Total simulation time (s)
dt = 86400;            % Time step (s)

%% Derived parameters
mass_solid = rho_solid * V_solid; % Mass of the solid (kg)

% Time array
t = 0:dt:t_final;

% Initialise temperature array
T_solid = zeros(size(t));
T_solid(1) = T_solid_initial; % Set initial temperature of the solid

%% Simulation loop
for i = 2:length(t)
    % Heat transfer rate (Q_dot)
    Q_dot(i) = h * A * (T_solid(i-1) - T_fluid); % Heat loss from the solid

    % Temperature change using energy balance (Q = m * c * dT)
    T_solid(i) = T_solid(i-1) - (Q_dot(i) * dt) / (mass_solid * cp_solid);
end
