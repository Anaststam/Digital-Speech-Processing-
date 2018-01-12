function Hd = sf
%SF Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 8.5 and the Signal Processing Toolbox 7.0.
% Generated on: 03-Jun-2016 18:41:33

% Equiripple Highpass filter designed using the FIRPM function.

% All frequency values are in Hz.
Fs = 8000;  % Sampling Frequency

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

% [EOF]