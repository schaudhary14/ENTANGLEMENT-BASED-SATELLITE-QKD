%%%% Simulation Module performs following tasks
%%%% 1. Runs the Single Photon Source on satellite (SPDC produces Entangled pair)
%%%% 2. Prepares Entangled state.
%%%% 3. Transmits the single photons to the ground stations (process loss as function of time)
%%%% 4. Detection Module performs the measurement of photons in either of X
%%%%    or Z basis.
%%%% 5. Coincidence Count module counts the signal bits and the error bits
%%%%    within some coincidence window

%%%% Here we load the link efficiency file prepared from the
%%%% Dual_downlink.m function

%%%% INPUT ARGUMENTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% 1. RUNTIME: Runtime of the protocol.
%%%%% 2. RATE: Single photon pair generation rate .
%%%%% 3. SIGMA: Spectral width signal or idler photon (to determine Coherence length )


%%%% OUTPUT ARGUMENTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [SIGNAL, NOISE] = Simulation_Module(RUNTIME, RATE, SIGMA, link_eff1, link_eff2)
               
tic

%%%%% Optimized Single Photon Source Module %%%%%%


p0 = RATE/10^12;
n = 10000000;              % considering probability distribution function (pdf) function upto n picoseconds
    
  
    pdf = [];
    X = 0:n;
    p = p0*(1 - exp(-X.*X/(2*SIGMA^2)));
    q = 1 - p;

    pdf(1) = 0;
    pdf(2) = p(2);
    
    for i = 2:n
        pdf(i+1) = pdf(i)*p(i+1)*q(i)/p(i);

    end
    
    format long
    Sum = sum(pdf);
    CDF = cumsum(pdf);
    plot(X, pdf,'o-')
    grid minor

    CDF_eff = CDF(diff(CDF) ~= 0);
    
    signal_X = [];
    signal_Z = [];
   
    SIGNAL = [];
    NOISE = [];
    
    %%%%% link_eff1: Column vector containing the values of link efficiency for
    %%%%%    channel 1.
    %%%%% link_eff2: Column vector containing the values of link efficiency for
    %%%%%    channel 2.
    load('link_eff1.mat')
    load('link_eff2.mat')
    
    
    for i = 1:RUNTIME
        
        xq = rand(1, round(RATE*1));
        x = 0:length(CDF_eff) - 1;

        n = interp1(CDF_eff, x, xq);
        n = round(n);
        n = transpose(n);

        %histogram(n, 250000)
    
        Timestamp = cumsum(n);
    
        Timestamp = Timestamp(Timestamp < (10^12));
        Timestamp(length(Timestamp));       % Timestamp of single photon pairs generated from SPDC in 1 second
    
        
        
    %%%%% Preparing the Entangled State %%%%%%%%%%%%%%%%%%%%%%%%%
        % INPUT: Timestamp from the SPDC source
        % Output1_H = Timestamp of single photons with horizontal
        %             polarization going to channel 1
        % Output1_V = Timestamp of single photons with vertical
        %             polarization going to channel 1
        % Output2_H = Timestamp of single photons with horizontal
        %             polarization going to channel 2
        % Output2_V = Timestamp of single photons with vertical
        %             polarization going to channel 2
        [Output1_H, Output1_V, Output2_H, Output2_V] = State_prep(Timestamp);
        
        
        
    %%%%% Processing the Transmission through Channel %%%%%%%%%%%    


        Atm_jitter = 0;         % Atmospheric jitter
    
    %%%%% Simulating the Channel losses %%%%%
        [Alice_temp] = Channel(Output1_V, Output1_H, link_eff1(i), link_eff1(i), Atm_jitter, 1);
        [Bob_temp] = Channel(Output2_V, Output2_H, link_eff2(i), link_eff2(i), Atm_jitter, 1);

    % Alice_temp: [array having two columns] Photons reaching Alice's ground
    %             station
    %             Column 1 is timestamp data
    %             Column 2 is polarization angle data
    % Bob_temp: [array having two columns] Photons reaching Bob's ground
    %             station
    %             Column 1 is timestamp data
    %             Column 2 is polarization angle data
      



    %%%% Detection Module gives the timestamps from all four detectors at a
    %%%% ground station
    [t_Alice_D_H, t_Alice_D_V, t_Alice_D_Dia, t_Alice_D_Anti_Dia] = Detection_Module(Alice_temp,1);
    [t_Bob_D_H, t_Bob_D_V, t_Bob_D_Dia, t_Bob_D_Anti_Dia] = Detection_Module(Bob_temp, 1);
    
    a = []; b = []; c =[]; d = []; e = []; f = []; g = []; h = [];
    
    a = t_Alice_D_H(t_Alice_D_H(:,1) ~= 1);
    b = t_Alice_D_V(t_Alice_D_V(:,1) ~= 1);
    c = t_Alice_D_Dia(t_Alice_D_Dia(:,1) ~= 1);
    d = t_Alice_D_Anti_Dia(t_Alice_D_Anti_Dia(:,1) ~= 1);
    e = t_Bob_D_H(t_Bob_D_H(:,1) ~= 1);
    f = t_Bob_D_V(t_Bob_D_V(:,1) ~= 1);
    g = t_Bob_D_Dia(t_Bob_D_Dia(:,1) ~= 1);
    h = t_Bob_D_Anti_Dia(t_Bob_D_Anti_Dia(:,1) ~= 1);
    
    ent_Alice_H = intersect(a, f);
    ent_Alice_V = intersect(b, e);
    ent_Alice_Dia = intersect(c, h);
    ent_Alice_Anti_Dia = intersect(d, g);
    
    signal_bit_X = length(intersect(a, f)) + length(intersect(b, e));
    signal_bit_Z = length(intersect(c, h)) + length(intersect(d, g));
    
    signal_X = [signal_X; signal_bit_X];
    signal_Z = [signal_Z; signal_bit_Z];
     

%%% COINCIDENCE_COUNT calculates the signal bits and the error bits


    WINDOWLEFT = -1000;
    WINDOWRIGHT = 1000;
    [PARAMETERS00] = COINCIDENCE_COUNTS(WINDOWLEFT, WINDOWRIGHT, t_Alice_D_H, t_Bob_D_V, ent_Alice_H);
    [PARAMETERS11] = COINCIDENCE_COUNTS(WINDOWLEFT, WINDOWRIGHT, t_Alice_D_V, t_Bob_D_H, ent_Alice_V);
    [PARAMETERS10] = COINCIDENCE_COUNTS(WINDOWLEFT, WINDOWRIGHT, t_Alice_D_Dia, t_Bob_D_Anti_Dia, ent_Alice_Dia);
    [PARAMETERS01] = COINCIDENCE_COUNTS(WINDOWLEFT, WINDOWRIGHT, t_Alice_D_Anti_Dia, t_Bob_D_Dia, ent_Alice_Anti_Dia);

    t_SIGNAL = (PARAMETERS00(1)+PARAMETERS11(1)+PARAMETERS01(1)+PARAMETERS10(1));
    t_NOISE = (PARAMETERS00(2)+PARAMETERS11(2)+PARAMETERS01(2)+PARAMETERS10(2));
    
    SIGNAL = [SIGNAL; t_SIGNAL];
    NOISE = [NOISE; t_NOISE];
    
    iteration = i               % time (in seconds) processed
    
    end
    
time_elapsed = toc
end