function [mel, mr] = frq2mel(frq)
    %    [mel,mr] = frq2mel(frq) converts a vector of frequencies (in Hz)
    %    to the corresponding values on the Mel scale which corresponds
    %    to the perceived pitch of a tone.
    %    mr gives the corresponding gradients in Hz/mel.
    
    persistent k
    if isempty(k)
        k = 1000/log(1+1000/700); % 1127.01048
    end
    af = abs(frq);
    mel = sign(frq).*log(1+af/700)*k;
    mr = (700 + af) / k;
end