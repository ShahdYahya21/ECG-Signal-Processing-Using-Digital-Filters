% Define the filename and sheet name
filename = 'Data_ECG_raw.xlsx';
fs =360;
ts= 1/fs;
% Read the table from the specified sheet
data1 = readtable(filename, 'Sheet', 'ECG1');
data2 = readtable(filename, 'Sheet', 'ECG2');
% Remove unnecessary columns from data1
data1(:, {'Var5', 'Var6', 'Var7', 'Var8'}) = [];
% Access specific columns
sample_number1 = data1.('sampleNumber');
temps1 = data1.('temps_s_');
amplitude1 = data1.('amplitude_mv_'); % First amplitude column
% Insert the real-time column
sampling_frequency = 360; % 360 Hz
real_time1 = sample_number1 / sampling_frequency;
% Check for NaN values in amplitude1
nan_indices = isnan(amplitude1);
if any(nan_indices)
% Interpolate or remove NaN values
amplitude1 = fillmissing(amplitude1, 'linear');
end
% Append the real-time column to the data table
data1.real_time = real_time1;
disp(head(data1));
%rescle
gain=200;
% Create the first figure
figure;
% Plot the original ECG signal
subplot(3, 1, 1);
%plot(real_time1(1:2*fs),amplitude1(1:2*fs));
plot(data1.real_time, amplitude1, 'LineWidth', 0.5);
title('Amplitude 1 (mv)');
xlabel('Time (s)');
ylabel('Amplitude (mv)');
legend('JENIN & SHAHD');
xlim([0 22.5]);
grid on;
%%%
amplitude1 = amplitude1/gain;
% Plot the original ECG signal
subplot(3, 1, 2);
%plot(real_time1(1:2*fs),amplitude1(1:2*fs));
plot(data1.real_time, amplitude1, 'LineWidth', 0.5);
title('Scaled Amplitude 1 (mv)');
xlabel('Time (s)');
ylabel('Amplitude (mv)');
xlim([0 10]);
legend('JENIN & SHAHD');
grid on;
%%%
%plot the signal in frequency domain
subplot(3, 1, 3);
[pxx,f] = pwelch(amplitude1 ,[],[],[],fs);
plot(f,10*log10(pxx),'b');
xlabel('frequency (Hz)');
ylabel('PSD (DB/HZ)');
title('Power Spectral Density of Original ECG Signal');
legend('JENIN & SHAHD');
grid on;
%%%
% Coefficients of the high-pass filter
b_hp = [-1/32, zeros(1, 15), 1, -1, zeros(1, 14), 1/32]; % Numerator
a_hp = [1, -1]; % Denominator
% Frequency response
[h_hp, w_hp] = freqz(b_hp, a_hp, 1024, sampling_frequency); % 1024 points, 360 Hz sampling frequency
figure;
% Plot frequency response in radians per sample
subplot(3, 1, 1);
plot(w_hp, abs(h_hp));
title('Frequency Response of the High-Pass Filter');
xlabel('Frequency (rad/sample)');
ylabel('Magnitude');
legend('JENIN & SHAHD');
grid on;
% Apply the high-pass filter to the amplitude_mv signal
hp_amplitude1 = filter(b_hp, a_hp , amplitude1);
% Plot the filtered ECG signal
subplot(3, 1, 2);
plot(real_time1, hp_amplitude1, 'LineWidth', 0.5);
%plot(real_time1(1:2*fs),hp_amplitude1(1:2*fs));
title('High-Pass Filtered ECG1 Signal');
xlabel('Time (s)');
ylabel('Amplitude (mv)');
xlim([0 20]);
legend('JENIN & SHAHD');
grid on;
%plot the signal in frequency domain
subplot(3, 1, 3);
[pxx,f] = pwelch(hp_amplitude1 ,[],[],[],fs);
plot(f,10*log10(pxx),'b');
xlabel('frequency (Hz)');
ylabel('PSD (DB/HZ)');
title('Power Spectral Density of High-Pass Filtered ECG Signal');
legend('JENIN & SHAHD');
grid on;
% Create the second figure
figure;
% Define the low-pass filter coefficients
b_lp = [1, 0, 0, 0, 0, 0, -2, 0, 0, 0, 0, 0, 1];
a_lp = [1, -2, 1];
% Compute the frequency response of the low-pass filter
[h_lp, w_lp] = freqz(b_lp, a_lp);
% Plot frequency response of the low-pass filter
subplot(3, 1, 1);
plot(w_lp,abs(h_lp));
title('Frequency Response of the Low-Pass Filter');
xlabel('Frequency (rad/sample)');
ylabel('Magnitude');
legend('JENIN & SHAHD');
grid on;
lp_amplitude1 = filter(b_lp, a_lp,amplitude1);
subplot(3, 1, 2);
plot(real_time1, lp_amplitude1, 'LineWidth', 0.5);
%plot(real_time1(1:2*fs),lp_amplitude1(1:2*fs));
title('Low-Pass Filtered ECG1 Signal');
xlabel('Time (s)');
ylabel('Amplitude (mv)');
xlim([0 10]);
legend('JENIN & SHAHD');
grid on;
%plot the signal in frequency domain
subplot(3, 1, 3);
[pxx,f] = pwelch(lp_amplitude1 ,[],[],[],fs);
plot(f,10*log10(pxx),'b');
xlabel('frequency (Hz)');
ylabel('PSD (DB/HZ)');
title('Power Spectral Density of Low pass Filtered ECG Signal');
legend('JENIN & SHAHD');
grid on;
figure;
% Apply the low-pass filter to the high-pass filtered ECG signals
ecg1_hp_lp = filter(b_lp, a_lp, hp_amplitude1);
% Plot the high-pass and low-pass filtered ECG signal
subplot(2, 1, 1);
% plot(real_time1(1:2*fs),ecg1_hp_lp(1:2*fs));
plot(real_time1, ecg1_hp_lp, 'LineWidth', 0.5);
title('ECG1 Signal (High-Pass Filtered, then Low-Pass Filtered)');
xlabel('Time (s)');
ylabel('Amplitude (mv)');
legend('JENIN & SHAHD');
xlim([0 20]);
grid on;
%plot the signal in frequency domain
subplot(2, 1, 2);
[pxx,f] = pwelch(ecg1_hp_lp ,[],[],[],fs);
plot(f,10*log10(pxx),'b');
xlabel('frequency (Hz)');
ylabel('PSD (DB/HZ)');
title('Power Spectral Density of Low pass then high pass Filtered ECG Signal');
legend('JENIN & SHAHD');
grid on;
%%%%%%%%%%%%
figure;
% Apply the filters in reverse order: low-pass then high-pass
ecg1_lp_hp = filter(b_hp, a_hp,lp_amplitude1);
% Plot the low-pass then high-pass filtered signals
subplot(2, 1, 1);
%plot(real_time1(1:2*fs),ecg1_lp_hp(1:2*fs));
plot(real_time1, ecg1_lp_hp, 'LineWidth', 0.5);
title('ECG1 Signal (Low-Pass Filtered, then High-Pass Filtered)');
xlabel('Time (s)');
ylabel('Amplitude (mv)');
xlim([0 20]);
grid on;
%plot the signal in frequency domain
subplot(2, 1, 2);
[pxx,f] = pwelch(ecg1_lp_hp ,[],[],[],fs);
plot(f,10*log10(pxx),'b');
xlabel('frequency (Hz)');
ylabel('PSD (DB/HZ)');
title('Power Spectral Density of Low pass then high pass Filtered ECG Signal');
legend('JENIN & SHAHD');
grid on;
%%%%%%%%%%%%
% Calculate poles and zeros of the high-pass filter
z_hp = roots(b_hp); % Zeros
p_hp = roots(a_hp); % Poles
% Plot the pole-zero plot for the high-pass filter
figure;
zplane(z_hp, p_hp);
title('Pole-Zero Plot of the High-Pass Filter');
xlabel('Real Part');
ylabel('Imaginary Part');
grid on;
% Calculate poles and zeros of the low-pass filter
z_lp = roots(b_lp); % Zeros
p_lp = roots(a_lp); % Poles
% Plot the pole-zero plot for the low-pass filter
figure;
zplane(z_lp, p_lp);
title('Pole-Zero Plot of the Low-Pass Filter');
xlabel('Real Part');
ylabel('Imaginary Part');
legend('JENIN & SHAHD');
grid on;
%%%%%%ECG2**************************************************
% Access specific columns
sample_number2 = data2.('n');
temps2 = data2.('temps_s_');
amplitude2 = data2.('amplitude_mv_'); % First amplitude column
% Insert the real-time column
real_time2 = sample_number2 / sampling_frequency;
% Check for NaN values in amplitude1
nan_indices = isnan(amplitude2);
if any(nan_indices)
% Interpolate or remove NaN values
amplitude2 = fillmissing(amplitude2, 'linear');
end
% Append the real-time column to the data table
data2.real_time = real_time2;
% Display the first few rows to verify the real-time column
disp(head(data2));
figure;
% Plot the original ECG signal
subplot(3, 1, 1);
plot(data2.real_time, amplitude2, 'LineWidth', 0.5);
title('Amplitude 2 (mv)');
xlabel('Time (s)');
ylabel('Amplitude (mv)');
legend('JENIN & SHAHD');
grid on;
amplitude2 = amplitude2/gain;
% Plot the original ECG signal
subplot(3, 1, 2);
plot(data2.real_time, amplitude2, 'LineWidth', 0.5);
% plot(real_time1(1:2*fs),amplitude2(1:2*fs));
title('Scaled Amplitude 2 (mv)');
xlabel('Time (s)');
ylabel('Amplitude (mv)');
legend('JENIN & SHAHD');
xlim([0 25]);
grid on;
%plot the signal in frequency domain
subplot(3, 1, 3);
[pxx,f] = pwelch(amplitude2 ,[],[],[],fs);
plot(f,10*log10(pxx),'b');
xlabel('frequency (Hz)');
ylabel('PSD (DB/HZ)');
title('Power Spectral Density of Original ECG2 Signal');
legend('JENIN & SHAHD');
grid on;
%%%%%%%%%%%%%%%
figure;
% Apply the high-pass filter to the amplitude2_mv signal
hp_amplitude2 = filter(b_hp, a_hp,amplitude2);
% Plot frequency response in radians per sample
subplot(3, 1, 1);
plot(w_hp, abs(h_hp));
title('Frequency Response of the High-Pass Filter');
xlabel('Frequency (rad/sample)');
ylabel('Magnitude');
legend('JENIN & SHAHD');
grid on;
% Plot the filtered ECG signal
subplot(3, 1, 2);
% plot(real_time2(1:2*fs),hp_amplitude2(1:2*fs));
plot(real_time2, hp_amplitude2, 'LineWidth', 0.5);
title('High-Pass Filtered ECG2 Signal');
xlabel('Time (s)');
ylabel('Amplitude 2 (mv)');
legend('JENIN & SHAHD');
grid on;
%plot the signal in frequency domain
subplot(3, 1, 3);
[pxx,f] = pwelch(hp_amplitude2 ,[],[],[],fs);
plot(f,10*log10(pxx),'b');
xlabel('frequency (Hz)');
ylabel('PSD (DB/HZ)');
title('Power Spectral Density of High-Pass Filtered ECG2 Signal');
legend('JENIN & SHAHD');
grid on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
% Plot frequency response of the low-pass filter
subplot(3, 1, 1);
plot(w_lp, h_lp);
title('Frequency Response of the Low-Pass Filter');
xlabel('Frequency (rad/sample)');
ylabel('Magnitude');
legend('JENIN & SHAHD');
grid on;
lp_amplitude2 = filter(b_lp, a_lp,amplitude2);
subplot(3, 1, 2);
% plot(real_time2(1:2*fs),lp_amplitude2(1:2*fs));
plot(real_time2, lp_amplitude2, 'LineWidth', 0.5);
title('Low-Pass Filtered ECG2 Signal');
xlabel('Time (s)');
ylabel('Amplitude (mv)');
legend('JENIN & SHAHD');
grid on;
%plot the signal in frequency domain
subplot(3, 1, 3);
[pxx,f] = pwelch(lp_amplitude2 ,[],[],[],fs);
plot(f,10*log10(pxx),'b');
xlabel('frequency (Hz)');
ylabel('PSD (DB/HZ)');
title('Power Spectral Density of low-Pass Filtered ECG2 Signal');
legend('JENIN & SHAHD');
grid on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
% Apply the low-pass filter to the high-pass filtered ECG signals
ecg2_hp_lp = filter(b_lp, a_lp, hp_amplitude2);
% Plot the high-pass and low-pass filtered ECG signal
subplot(2, 1, 1);
plot(real_time2, ecg2_hp_lp, 'LineWidth', 0.5);
title('ECG2 Signal (High-Pass Filtered, then Low-Pass Filtered)');
xlabel('Time (s)');
ylabel('Amplitude (mv)');
legend('JENIN & SHAHD');
xlim([0 45]);
grid on;
%plot the signal in frequency domain
subplot(2, 1, 2);
[pxx,f] = pwelch(ecg2_hp_lp ,[],[],[],fs);
plot(f,10*log10(pxx),'b');
xlabel('frequency (Hz)');
ylabel('PSD (DB/HZ)');
title('Power Spectral Density of hp then lp');
legend('JENIN & SHAHD');
grid on;
%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
% Apply the filters in reverse order: low-pass then high-pass
ecg2_lp_hp = filter(b_hp, a_hp,lp_amplitude2);
% Plot the low-pass then high-pass filtered signals
subplot(2, 1, 1);
plot(real_time2, ecg2_lp_hp, 'LineWidth', 0.5);
%plot(real_time1(1:2*fs),ecg2_lp_hp(1:2*fs));
title('ECG2 Signal (Low-Pass Filtered, then High-Pass Filtered)');
xlabel('Time (s)');
ylabel('Amplitude (mv)');
xlim([0 45]);
legend('JENIN & SHAHD');
grid on;
%plot the signal in frequency domain
subplot(2, 1, 2);
[pxx,f] = pwelch(ecg2_lp_hp ,[],[],[],fs);
plot(f,10*log10(pxx),'b');
xlabel('frequency (Hz)');
ylabel('PSD (DB/HZ)');
title('Power Spectral Density of lp the hp');
legend('JENIN & SHAHD');
grid on;