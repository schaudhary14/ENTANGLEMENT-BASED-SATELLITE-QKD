%%%%%%%%%%%%% ENTANGLED STATE PREPARATION %%%%%%%%%%%%%%%%
function [Output1_H, Output1_V, Output2_H, Output2_V] = State_prep(Input)

r = rand(length(Input), 1);
index = r < 0.5;
OP1 = Input(index);
OP2 = Input(~index);

Output1_H = OP1;
Output1_V = OP2;

Output2_H = OP2;  
Output2_V = OP1;

end
