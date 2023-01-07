%%%%%  DETECTION MODULE %%%%%%
function [D_H, D_V, D_Dia, D_Anti_Dia] = Detection_Module(INPUT, Runtime)
arm1 = [];
arm2 = [];

R = 0.48;           % Reflection probablity from beam splitter
T = 0.48;           % Transmission probability from beam splitter
for i = 1:length(INPUT)
    r = rand;
    if r < R
        arm1 = [arm1; INPUT(i,:)];
    elseif r >= R && r < R + T
        arm2 = [arm2; INPUT(i,:)];
    else
    end
end


value = (cos(arm1(:, 2))).^2;
H_basis = [];
V_basis = [];

for i = 1: length(arm1)
    r1 = rand;
    r2 = rand;
    if r1 < value(i) && r2 < 0.95
        H_basis = [H_basis; arm1(i, 1)];
        
    elseif r1 > value(i) && r2 < 0.95
        V_basis = [V_basis; arm1(i, 1)];
        
    else
        
    end
end
        
value2 = (cos(arm2(:, 2))).^2;
Dia_basis = [];
Anti_Dia_basis = [];

for i = 1: length(arm2)
    r1 = rand;
    r2 = rand;
    if r1 < value2(i) && r2 < 0.95
        Dia_basis = [Dia_basis; arm2(i, 1)];
        
    elseif r1 > value2(i) && r2 < 0.95
        Anti_Dia_basis = [Anti_Dia_basis; arm2(i, 1)];
        
    else
        
    end
end  

EFF = 50;
DARKCOUNT = 100;         % in Hz
DEADTIME =  10*10^3;     % in ps
STDEV = 500;             % in ps
MEAN = 0;

[D_H] = Single_Photon_Detector(EFF, DARKCOUNT, DEADTIME, STDEV, MEAN, H_basis, Runtime);
[D_V] = Single_Photon_Detector(EFF, DARKCOUNT, DEADTIME, STDEV, MEAN, V_basis, Runtime);
[D_Dia] = Single_Photon_Detector(EFF, DARKCOUNT, DEADTIME, STDEV, MEAN, Dia_basis, Runtime);
[D_Anti_Dia] = Single_Photon_Detector(EFF, DARKCOUNT, DEADTIME, STDEV, MEAN, Anti_Dia_basis, Runtime);

end

   
