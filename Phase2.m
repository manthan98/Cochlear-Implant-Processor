function Phase2(fileName, extension, N)
    soundFile = strcat(fileName, '.', extension);
    % 3.1
    [y, Fs] = audioread(soundFile);

    % 3.2
    soundSize = size(y);
    if soundSize(2) > 1
        % Converting to mono
        y = sum(y, 2)/size(y,2);
    end

    % 3.3
    %sound(y, Fs);

    % 3.4
    %audiowrite(strcat('mono',fileName, '.wav'), y, Fs);

    % 3.5
    %plotting audio as a function of sample num
    sampleNumVector = linspace(1, soundSize(1), soundSize(1));
    figure;
    plot(sampleNumVector, y);

    % 3.6
    if Fs > 16000
        y = resample(y, 16000, Fs);
    end
    
    %sound(y, Fs);

    % 3.7
    newSize = size(y);
    % Duration of signal is number of samples divided by freq
    duration = newSize(1)/16000;
    % From time = 0 to duration of signal with n samples
    x = linspace(0, duration, newSize(1));
    
    %DON'T NEED THIS FOR PHASE 2
    % cos(2*pi*frequency*x)
    %frequensy = 1000;
    %cosSignal = cos(2*frequency*pi*x);
    %sound(cosSignal, Fs);
    %now taking a subset of the x and cos signals so that we can plot 2
    %waveforms
    %x_subset = x(1, 1:33);
    %cos_subset = cosSignal(1, 1:33);
    %figure;
    %plot(x_subset, cos_subset);
    
    %Phase 2 Starts Here
    %Task 4 - Filter Design
    
    %Step A: Determining the frequency bands
    %Determine upper and lower bounds of human hearing in mels (unit of
    %pitch)
    melsLowerBound = frq2mel(100);
    melsUpperBound = frq2mel(8000);
    
    %Divide pitches into N channels of even width
    melsChannels = linspace(melsLowerBound, melsUpperBound, N + 1)
    
    %Convert channels from pitches (mels) to frequency (Hz)
    freqChannels = mel2frq(melsChannels)
    
    arr = ones(N + 1);
    %Plotting visual rep of channel widths (pitch in mels)
    figure;
    plot(melsChannels, arr, '-x');
    
    %Plotting visual rep of channel widths (frequency in Hz)
    figure;
    plot(freqChannels, arr, '-o');
    
    %initialize an array to store each channel of the inputted sound
    soundChannels = zeros(N, length(y));
    %use a filter to split the noise into N channels
    for elm = 1:N
        filteredChannel = elliptic(y, freqChannels(elm) - 50, freqChannels(elm), freqChannels(elm + 1), freqChannels(elm) + 50);
        soundChannels(elm, :) = transpose(filteredChannel);
    end
  
    sound(elliptic(y, 100, 150, 800, 850), Fs);
    %sound(chebyshev2(y, 100, 150, 8000, 8050), Fs);
    %sound(y, Fs);
    valid = elliptic(y, 100, 150, 800, 850) == elliptic(y, 900, 950, 1800, 1850)
    
    %Task 5 - Filter the sound
    
    %Task 6 - Plot output signals of lowest/highest freq channels
    
    %Task 7 - Rectify output of bandpass signals (envelope pt 1)
    
    %Task 8 - Detect envelopes of rectified signals using LPF 400Fc (envelope pt
    %2)
    
    %Task 9 - Plot envelope of lowest and highest frequency signals
    
end


