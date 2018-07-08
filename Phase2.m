function Phase2(fileName, extension, N)
    soundFile = strcat(fileName, '.', extension);
    % 3.1
    [y, Fs] = audioread(soundFile);

    % 3.2
    soundSize = size(y);
    if soundSize(2) > 1
        % Converting to Mono.
        y = sum(y, 2)/size(y,2);
    end

    % 3.3
    %sound(y, Fs);

    % 3.4
    %audiowrite(strcat('mono',fileName, '.wav'), y, Fs);

    % 3.5
    %plotting audio as a function of sample num
    plotSignal(soundSize(1), y);
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
    
    %Task 4 - Filter Design
    
    %Step A: Determining the frequency bands
    %Determine upper and lower bounds of human hearing in mels (unit of
    %pitch)
    melsLowerBound = frq2mel(100);
    melsUpperBound = frq2mel(7900); % Should be 8000.
    
    %Divide pitches into N channels of even width
    melsChannels = linspace(melsLowerBound, melsUpperBound, N + 1);
    
    %Convert channels from pitches (mels) to frequency (Hz)
    freqChannels = mel2frq(melsChannels);
    
    arr = ones(N + 1);
    %Plotting visual rep of channel widths (pitch in mels)
    figure;
    plot(melsChannels, arr, '-x');
    
    %Plotting visual rep of channel widths (frequency in Hz)
    figure;
    plot(freqChannels, arr, '-o');
    
    %initialize an array to store each channel of the inputted sound
    soundChannels = zeros(N, length(y));
    
    %Task 5 - Filter the sound
    
    %use a filter to split the noise into N channels
    for elm = 1:N
        % Generate Kaiser Window filter with the given bands.
        filt = getKaiserWindow(freqChannels(elm), freqChannels(elm + 1));
        
        % Use the filter on the given sound input.
        filteredChannel = filter(filt, y);
        
        % Store it in the soundChannels matrix.
        soundChannels(elm, :) = transpose(filteredChannel);
    end
    
    % Task 6 - Plot output signals of lowest/highest freq channels
    lowestChannel = soundChannels(1, :);
    highestChannel = soundChannels(N, :);
    channelLength = length(lowestChannel);
    
    %plotting lowest channel as a function of sample num
    plotSignal(channelLength, lowestChannel);
    
    %plotting highest channel as a function of sample num
    plotSignal(channelLength, highestChannel);
    
    %Plotting the highest and lowest channels against frequency
    lowestFFT = abs(fft(lowestChannel));
    highestFFT = abs(fft(highestChannel));
    %Calculate the frequency axis, which is defined by the sampling rate
    figure;
    plot(lowestFFT);
    figure;
    plot(highestFFT);
    
    % Task 7 - Rectify output of bandpass signals (envelope pt 1)
    rectifiedSoundChannels = abs(soundChannels);
    plotSignal(channelLength, rectifiedSoundChannels(1, :));
    
    % Task 8 - Detect envelopes of rectified signals using LPF 400Fc
    % (envelope part 2).
    
    %initialize an array to store each enveloped channel
    envelopedSoundChannels = zeros(N, length(y));
    
    lpf = getKaiserWindowLPF();
    
    for elm = 1:N
        %filter each rectified channel using a kaiser window LPF and store it in
        %envelopedSoundChannels
        envelopedSoundChannels(elm, :) = filter(lpf, rectifiedSoundChannels(elm, :));
    end
   
    % Task 9 - Plot envelope of lowest and highest frequency signals.
    %plotting lowest channel as a function of sample num
    plotSignal(channelLength, envelopedSoundChannels(1, :));
    
    %plotting highest channel as a function of sample num
    plotSignal(channelLength, envelopedSoundChannels(N, :));
    
end


