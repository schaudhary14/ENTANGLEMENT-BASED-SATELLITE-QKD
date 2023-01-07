%%%%%%%%%%%%%% TRANSMISSION CHANNEL %%%%%%%%%%%%%%

function [Output] = Channel(Input_V, Input_H, Link_eff_V, Link_eff_H, Atm_jitter, Runtime)

Random1 = rand(length(Input_V), 1);
Random2 = rand(length(Input_H), 1);

index1 = Random1 < Link_eff_V;
index2 = Random2 < Link_eff_H;

Output_V = Input_V(find(index1));
Output_H = Input_H(find(index2));

%%% ADDING ATMOSPHERIC JITTER %%%

%%% POLARIZATION %%%
Pol_V = normrnd(pi/2, pi/8, [length(Output_V), 1]);
Pol_H = normrnd(0, pi/8, [length(Output_H), 1]);

Output_V = [Output_V Pol_V];
Output_H = [Output_H Pol_H];


%%% ADDING BACKGROUND NOISE %%%

bg_rate = 0*10^-10;                % per ps

bg_timestamp1 = 10^12*Runtime*rand(round(10^12*Runtime*bg_rate/2),1);
bg_timestamp2 = 10^12*Runtime*rand(round(10^12*Runtime*bg_rate/2),1);

bg_Pol1 = 2*pi*rand(length(bg_timestamp1), 1);
bg_Pol2 = 2*pi*rand(length(bg_timestamp2), 1);

Output_bg1 = [bg_timestamp1 bg_Pol1];
Output_bg2 = [bg_timestamp2 bg_Pol2];

%%% OUTPUT %%%
Output_V = [Output_V; Output_bg1];
Output_H = [Output_H; Output_bg2];

Output_V = sortrows(Output_V);
Output_H = sortrows(Output_H);

Output = sortrows([Output_V; Output_H]);

end