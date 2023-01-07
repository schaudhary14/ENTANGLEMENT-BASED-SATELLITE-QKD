%%%%%%%%%%%%%%%%% DUAL DOWNLINK CONFIGURATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%

R = 6378.1;         % Radius of earth in km
h = 500;            % Altitute of satellite above earth surface in km 
G = 6.67408*10^-11; % Gravitational constant (SI units)
M = 5.972*10^24;    % Mass of earth in kg

theta_dot  = sqrt(G*M/((R + h)*1000)^3);        % Angular speed of satellite w.r.t earth
phi_dot = 2*pi/(24*3600);                       % Angular speed of earth's rotation

%%%%%%% COORDINATES OF GROUND STATIONS "A" AND "B"    %%%%%%%%%%%%
theta_a = 0.0*pi;                   % Polar angle of station A
phi_a = 0.0*pi;                     % Azimuthal angle of station A
theta_b = 0.188;                   % Polar angle of station B
phi_b = 0*pi;                     % Azimuthal angle of station B 

%%%%%%% COORDINATES IN CARTESIAN FORM %%%%%%%%%%%%%%%%%%%%%%%%%%%%
A = [(R)*sin(theta_a)*cos(phi_a), (R)*sin(theta_a)*sin(phi_a), (R)*cos(theta_a)];
B = [(R)*sin(theta_b)*cos(phi_b), (R)*sin(theta_b)*sin(phi_b), (R)*cos(theta_b)];


Rth = sqrt((R + h)^2 - R^2);        % Threshold value of slant range in km

%%%%%% INITIAL POSITION OF SATELLITE (at time t = 0 sec) %%%%%%%%%
angle_initial = pi;                    % Polar angle
phi_initial = -0.02487;               % Azimuthal angle

data = [];

t = -1000;

 while t < 10000                   % run for 50000 seconds
     
     theta = angle_initial + theta_dot*t;           % updating theta for satellite
     phi = phi_initial + phi_dot*t;                 % updating phi for satellite
     
     vector1 = [0 1];
     vector2 = [cos(theta) sin(theta)];
     theta = acos(dot(vector1, vector2));
     
     % S is the satellite coordinate in cartesian form
     S = [(R + h)*sin(theta_dot*t)*cos(phi_dot*t), (R + h)*sin(theta_dot*t)*sin(phi_dot*t), (R + h)*cos(theta_dot*t)];
     Slant_range1 = sqrt((A(1)-S(1))^2 + (A(2)-S(2))^2 + (A(3)-S(3))^2);  % Slant range from station 1
     Slant_range2 = sqrt((B(1)-S(1))^2 + (B(2)-S(2))^2 + (B(3)-S(3))^2);  % Slant range from station 2
     
     data = [data; t Slant_range1 Slant_range2 theta phi];
     
     t = t + 1;
     
 end
index = data(:, 2) < Rth & data(:, 3) < Rth ;       % Condition that both ground stations are visible from satellite
data_file = data(index, :);
 
 plot(data(:, 1), data(:,2), 'r')
 xlabel('time (seconds)')
 ylabel('Slant range (km)')
 hold on
 plot(data(:, 1), data(:,3), 'b')
 yline(Rth)