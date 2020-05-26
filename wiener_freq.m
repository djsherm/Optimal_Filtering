function filtered_spat = wiener_filter_freq(image, variance, name)
%% DOCUMENTATION

% FUNCTION ACCEPTS AN IMAGE, VARIANCE OF NOISE, AND IMAGE NAME.  FUNCTION
% ADDS NOISE AND APPLIES AN OPTIMAL WIENER FILTER IN THE FREQUENCY DOMAIN.
% FUNCTION RETURNS THE OPTIMALLY FILTERED IMAGE

% MADE BY: DANIEL SHERMAN
% JANUARY 27, 2020

%% ADD NOISE TO MRI IMAGE

noise_image = double(image) + sqrt(variance)*randn(size(image));

%% OPTIMAL LEAST-SQUARES FILTERING

P_simage = abs(fftshift(fft2(image))).^2; %find PSD of image
P_n = (row*col).* variance*ones(row, col); %find PSD of noise, based on equation from lab manual

opti_filter = P_simage./(P_simage + P_n); %define optimal filter

filtered = fftshift(fft2(noise_image)).*opti_filter; %apply optimal filter in frequency domain

filtered_spat = ifft2(fftshift(filtered)); %convert to spatial domain

%plot appropriately
figure()
subplot(1,2,1)
imshow(uint8(noise_image))
title(strcat([name ' with Noise']))
ylabel(strcat(['\sigma^2 = ', num2str(variance)]))
subplot(1,2,2)
imshow(uint8(filtered_spat))
title('Optimally Filtered Image')
xlabel('Frequency Domain Approach')