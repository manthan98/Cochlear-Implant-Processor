function Phase3v1(fileName, extension, N)
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
    plotSignal(soundSize(1), y, 'Sample', 'Magnitude');
    % 3.6
    if Fs > 16000
        y = resample(y, 16000, Fs);
        %make our sampling rate variable equal to 16000 now that our signal has been resampled, just for future
        %reference
        Fs = 16000;
    end
    
    %sound(y, Fs);

    % 3.7
    newSize = size(y);
    
    % Duration of signal is number of samples divided by freq
    duration = newSize(1)/16000;
    
    % From time = 0 to duration of signal with n samples
    x = linspace(0, duration, newSize(1));
    
    %PHASE 2 STARTS HERE
    
    %Task 4 - Filter Design
    
    %Step A: Determining the frequency bands

    %Divide pitches into N channels of even width
    freqChannels = linspace(100, 7900, N + 1);
    
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
    plotSignal(channelLength, lowestChannel, 'Sample', 'Magnitude');
    
    %plotting highest channel as a function of sample num
    plotSignal(channelLength, highestChannel, 'Sample', 'Magnitude');
    
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
    plotSignal(channelLength, envelopedSoundChannels(1, :), 'Sample', 'Magnitude');
    
    %plotting highest channel as a function of sample num
    plotSignal(channelLength, envelopedSoundChannels(N, :), 'Sample', 'Magnitude');
    
    %PHASE 3 STARTS HERE
    
    %Task 10 - generate cosine functions
    
    %Create array of cosine signals at the center freq of each channel
    for elm = 1:N
        % Create vector from time = 0 to duration of signal with n samples.
        duration = channelLength/16000;
        x = linspace(0, duration, channelLength);
        % Each center freq is the arithmetic mean of the channel's two
        % cutoff frequencies
        centerFreq = sqrt(freqChannels(elm)*freqChannels(elm + 1));
        %create cos signal that resonates at center freq
        cosSignal =  cos(centerFreq*2*pi*x);
        cosineSignals(elm, :) = cosSignal;
    end
    
    %Task 11 - Amplitude modulate cosines using rectified signal of each channel
    
    %to amplitude modulate the cosine using the rectified signal, we must
    %multiply each point of the cosine with each point of the enveloped
    %signal
    for elm = 1:N
        carrier = envelopedSoundChannels(elm, :);
        modulator = cosineSignals(elm, :);
        AMSignals(elm, :) = carrier .* modulator;
    end 
    
    %Task 12 - Add signals from task 11
    outputSignal = zeros(1, channelLength);
    for elm = 1:N
        %add signals from task 11
        outputSignal = outputSignal + AMSignals(elm, :);
    end
    
    maxVal = max(outputSignal);
    %normalize the output signal by its max val
    outputSignal = outputSignal/maxVal;
    
    %Task 13
    %Play output sound
    sound(outputSignal, Fs)
    %Write to file
    audiowrite(strcat('output',fileName, '.wav'), outputSignal, Fs);
end