
function [TIMESTAMPS] = Source_Module(RUNTIME)
RATE = 10^7;
PROBSINPHOT = RATE/10^12;
PROBMULPHOT = 0;
TOTBINS = RUNTIME*10^12;        % TOTAL TIME IN picoseconds
SIGMA  = 10000;                 % THESE ARE THE 4 INPUTS


FACTOR = 1 - PROBMULPHOT/PROBSINPHOT;
PROBARRAY = zeros(TOTBINS, 1);
TIMESTAMPS = [];

for I = 1:TOTBINS
PROBARRAY(I) = PROBSINPHOT;
end

I = 1;
while I <= TOTBINS
    RANDNUM = rand;
    if RANDNUM <= PROBARRAY(I, 1)
        TIMESTAMPS = [TIMESTAMPS; I];

        
        for J = 0:TOTBINS-I
            PROBARRAY(I+J,1) = PROBSINPHOT*(1 - FACTOR*exp(-J^2/(2*SIGMA^2)));
        end
        I = I-1;
    end
    I = I+1;
    
end

histogram(diff(TIMESTAMPS), 100)


end


    