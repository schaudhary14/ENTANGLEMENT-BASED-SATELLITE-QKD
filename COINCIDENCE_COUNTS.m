function [PARAMETERS] = COINCIDENCE_COUNTS(WINDOWLEFT, WINDOWRIGHT, A, B, C)

PARAMETERS =[];

        I = 1;
        J = 1;
        SIGNAL = 0;
        NOISE = 0;
        while I <= length(A) && J <= length(B)
            if B(J, 2) - A(I, 2) <= WINDOWLEFT
                J = J + 1;                
            
            elseif B(J, 2) - A(I, 2) <= WINDOWRIGHT && B(J, 2) - A(I, 2) >= WINDOWLEFT
                %SIGNAL = SIGNAL + 1;

                
                if length(intersect(A(I, 1), C)) == 1 %|| length(intersect(B(J, 1), C)) == 1
                    SIGNAL = SIGNAL + 1;
                else
                    NOISE = NOISE + 1;
                end
                I = I + 1;
                J = J + 1;
                
            
            elseif B(J, 2) - A(I, 2) >= WINDOWRIGHT
                I = I + 1;

            end
        end
        

        

PARAMETERS = [SIGNAL NOISE];

end