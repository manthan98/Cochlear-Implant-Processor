function y = butterworth(input, pass1, pass2, stop1, stop2)
% Butterworth filter takes input, passband range, and stopband range and returns output y.

persistent Hd;

if isempty(Hd)
    
    Fstop1 = stop1;    % First Stopband Frequency
    Fpass1 = pass1;  % First Passband Frequency
    Fpass2 = pass2;  % Second Passband Frequency
    Fstop2 = stop2;    % Second Stopband Frequency
    Astop1 = 60;      % First Stopband Attenuation (dB)
    Apass  = 1;       % Passband Ripple (dB)
    Astop2 = 60;      % Second Stopband Attenuation (dB)
    Fs     = 16000;   % Sampling Frequency
    
    h = fdesign.bandpass('fst1,fp1,fp2,fst2,ast1,ap,ast2', Fstop1, Fpass1, ...
        Fpass2, Fstop2, Astop1, Apass, Astop2, Fs);
    
    Hd = design(h, 'butter', ...
        'MatchExactly', 'stopband', ...
        'SOSScaleNorm', 'Linf');
    
    
    
    set(Hd,'PersistentMemory',true);
    
end

y = filter(Hd,input);