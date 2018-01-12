Fsnew = 8000;  % Sampling Frequency

N     = 10;   % Order
Fstop = 100;  % Stopband Frequency
Fpass = 200;  % Passband Frequency
Wstop = 1;    % Stopband Weight
Wpass = 1;    % Passband Weight
dens  = 20;   % Density Factor

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, [0 Fstop Fpass Fs/2]/(Fs/2), [0 0 1 1], [Wstop Wpass], ...
           {dens});
Hd = dfilt.dffir(b);

yfiltered = filter(Hd,y2);