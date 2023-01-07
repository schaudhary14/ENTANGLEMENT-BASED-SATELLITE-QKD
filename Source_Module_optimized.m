% Experiment to built sub poissonian distribution

function [Timestamp] = Source_Module_optimized(RUNTIME, RATE, sigma)

% 3 INPIUS
%RUNTIME = 0.1;                    % in seconds
%RATE = 10^7;                      % Number of photons per second
%sigma = 200;                      % in units of picosecond

p0 = RATE/10^12;
n = 10000000;                      % considering pdf function upto n picoseconds


    %tic
    
  
    pdf = [];
    X = 0:n;
    p = p0*(1 - exp(-X.*X/(2*sigma^2)));
    q = 1 - p;

    pdf(1) = 0;
    pdf(2) = p(2);
    
    for i = 2:n
        pdf(i+1) = pdf(i)*p(i+1)*q(i)/p(i);


    end
    
    format long
    Sum = sum(pdf)
    CDF = cumsum(pdf);
    plot(X, pdf,'o-')
    grid minor

    
    CDF_eff = CDF(diff(CDF) ~= 0);
    
    xq = rand(1, round(RATE*RUNTIME));



    x = 0:length(CDF_eff) - 1;

    n = interp1(CDF_eff, x, xq);
    n = round(n);
    n = transpose(n);

    %histogram(n, 250000)
    
    Timestamp = cumsum(n);
    
    Timestamp = Timestamp(Timestamp < (10^12)*RUNTIME);
    Timestamp(length(Timestamp))
    
    

end