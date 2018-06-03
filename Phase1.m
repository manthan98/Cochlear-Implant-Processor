% 3.1
[y, Fs] = audioread('GMM.mp3');

% 3.2
soundSize = size(y);
if soundSize(2) > 1
    % Converting to mono.
    y = sum(y, 2)/size(y,2);
end

%3.3
sound(y, Fs);

%3.4
audiowrite('monoGMM.mp3', audio, Fs);

%3.5
%plotting audio as a function of sample num
sampleNumVector = linspace(1, soundSize(1), soundSize(1));
figure;
plot(sampleNumVector, y);

%3.6
if Fs > 16000
    y = resample(y, 16000, Fs);
end

%3.7
newSize = size(y);

% Duration of signal is number of samples divided by freq
duration = newSize(1)/16000;

% From time = 0 to duration of signal with n samples.
x = linspace(0, duration, newSize(1));
cosSignal = cos(2000*pi*x);
figure;
plot(x, cosSignal);

sound(cosSignal, Fs);
