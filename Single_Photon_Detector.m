%%%% This algorithm simulates the Single Photon detector 

% EFF in %
% Deadtime in ps
% stdev in ps
% Mean in ps
% Darkcount in Hz

function [OPTIMESTAMPS] = Single_Photon_Detector(EFF, DEADCOUNT, DEADTIME, STDEV, MEAN, IPTIMESTAMPS, RUNTIME)
OPTIMESTAMPS = [];
DETTIMESTAMP = 0;
IPTIMESTAMPS = [IPTIMESTAMPS IPTIMESTAMPS];

bg_rate = 0.912*1.5*10^3;             % Background photon noise reaching detector in counts per second
D = [];
D = ones(round(DEADCOUNT*RUNTIME*100/EFF + RUNTIME*bg_rate), 2);
D(:, 1) = round(RUNTIME*10^12*rand(round(DEADCOUNT*RUNTIME*100/EFF + RUNTIME*bg_rate), 1));

temp = [IPTIMESTAMPS; D];
IPTIMESTAMPS = sortrows(temp);

I = 1;
while I <= length(IPTIMESTAMPS)
    if IPTIMESTAMPS(I, 1) - DETTIMESTAMP >= DEADTIME
        RAND = rand;
        if RAND <= EFF/100
            NORMRAND = normrnd(MEAN, STDEV);
            JITTER = round(NORMRAND);
            OPTIMESTAMPS = [OPTIMESTAMPS; IPTIMESTAMPS(I, 2) (IPTIMESTAMPS(I, 1) + JITTER)];
            DETTIMESTAMP = IPTIMESTAMPS(I, 1);
        end
    end
    I = I + 1;
end

end