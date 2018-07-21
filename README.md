# Cochlear Implant Analyzer

Cochlear implant signal processor that reads an input sound file, processes it, and outputs filtered file. The sound
signal is divided into N frequency channels, and processed through a bank of bandpass filters. In this processor, 
the segregated frequency bands are modulated and combined to make the output signal.

<p align="center">
<img width="600" alt="screen shot 2018-07-20 at 9 32 20 pm" src="https://user-images.githubusercontent.com/19896167/43030855-7394cdb8-8c64-11e8-987d-3579021c74fb.png">
</p>

## Filter
This processor makes use of a Kaiser-Window FIR filter, which offers linear phase response (negligible pre and post band ripple), 
and sharp attenuation at the stopbands. The system transfer function of FIR filters allows for accurate computation of desired
frequency responses, since all the coefficients are in the numerator (as opposed to the pole-zero configuration of IIR filter 
system response).

<p align="center">
<img width="143" alt="screen shot 2018-07-19 at 6 29 38 pm" src="https://user-images.githubusercontent.com/19896167/43031519-47c72282-8c71-11e8-9864-afc619ea0d0a.png">
</p>

## Channel Spacing
Spacing of the frequency channels involves bi-directional mappings between the mel and frequency domains. Human sound processing
is much more accurately done through pitch (mel scale). Thus, N channels are first transformed into the mel-domain and then linearly
spaced. These are then mapped back into the frequency domain where they exhibit near logarthmic spacing.

## Authors
Austin Atmaja, Daniel Javaheri-Zadeh, Manthan Shah
