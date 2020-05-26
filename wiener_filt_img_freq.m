function spatial_image = wiener_filt_img_freq(image, noise, name)
%% DOCUMENTATION

% FUNCTION ACCPETS AN IMAGE, VARIANCE OF NOISE, AND IMAGE NAME.  FUNCTION
% APPLIES A CUSTOM LOW-PASS FILTER, ADDS NOISE, AND APPLIES AN OPTIMAL
% WIENER FILTER IN THE FREQUENCY DOMAIN.  FUNCTION RETURNS THE OPTIMALLY
% FILTERED IMAGE

% MADE BY: DANIEL SHERMAN
% JANUARY 27, 2020


%% START OF CODE

% define custom low pass filter size for the image
h0 = 0.8.^(abs(-128:127));
k = 1/sum(h0);
h = k.*h0;
filt_mag = abs(fftshift(fft2((h.')*h))).^2; %determine magnitude of the filter
H = fftshift(fft2((h.')*h)); %find the fourier transform of the filter matrix

P_s = abs(fftshift(fft2(image))).^2; %find the PSD of the clean image

%apply custom low-pass filter and add noise
clow_nimage = imfilter(imfilter(double(image), h, 'replicate'), h.', 'replicate') + sqrt(noise)*randn(size(image));

%find size of the image and find the PSD of the noise
[row, col] = size(image);
P_n = (row*col).* noise*ones(row, col);

%define optimal filter
opti_filter = H.*P_s./(filt_mag.*P_s + P_n);

%apply filter in the frequency domain
filtered_nimage = fftshift(fft2(clow_nimage)).*opti_filter;

%convert back to spatial domain
spatial_image = fftshift(ifft2(fftshift(filtered_nimage)));

%plot appropriately
figure
subplot(1,2,1)
imshow(uint8(clow_nimage))
ylabel(strcat(['\sigma^2 = ', num2str(noise)]))
title(strcat(['Low Passed ', name, ' with Noise']))
subplot(1,2,2)
imshow(uint8(spatial_image))
title('Optimally Filtered Image')
xlabel('Frequency Domain Approach')
