% This code is meant to analyze the SNR value in dB of a single raw sensor data from the inverter system
% This is a Matlab m-file
% Extract each data from the combined sensor file (column 1 is time)
raw_data = combined_sensor{:,n}; #replace the column number (n) corresponding to the intended data
fs = 2.50e9; % 2.50 GHz Sampling Rate

% Define the moving average window. A window of 50 samples covers 200ns at 2.50GHz. 
window_size = 50; 
signal_smooth = movmean(raw_data, window_size);

% Noise = Raw Data - Smoothed Trend, isolate the noise (residuals)
noise_components = raw_data - signal_smooth;

% Compute signal and noise power
conduction_idx = raw_data > 3; 
signal_power = mean(signal_smooth(conduction_idx).^2);
noise_power = var(noise_components(conduction_idx));

% Calculate SNR in decibels (dB)
snr_linear = signal_power / noise_power;
snr_db = 10 * log10(snr_linear);

% Plotting the result
figure;
subplot(2,1,1);
plot(raw_data(1:5000), 'Color', [0.7 0.7 0.7]); hold on; % Raw in Light Gray
plot(signal_smooth(1:5000), 'r', 'LineWidth', 1.5);      % Smooth Signal in Red
title(['Signal vs. Moving Average Trend (SNR: ', num2str(snr_db, '%.2f'), ' dB)']);
legend('Raw Data', 'Moving Average (Signal)'); #replace the legend 'Raw Data' to which data you're analyzing
grid on;

subplot(2,1,2);
plot(noise_components(1:5000), 'b');
title('Extracted Measurement Noise (Residuals)');
xlabel('Sample Index'); ylabel('Amplitude');
grid on;

fprintf('Calculated Measurement SNR: %.2f dB\n', snr_db);
