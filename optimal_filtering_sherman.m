%% ENGG 4660: MEDICAL IMAGE PROCESSING
% LAB 2: OPTIMAL FILTERING
% DANIEL SHERMAN
% 0954083
% FEBRUARY 3, 2020

%% CLEAN UP

close all
clear all
clc

%%  LOAD IN IMAGES

checker = imread('checker.png');
mri = imread('mri.jpg');

%% APPLY WEINER FILTERS IN THE FREQUENCY DOMAIN

mri100f = wiener_freq(mri, 100, 'mri.jpg');
mri900f = wiener_freq(mri, 900, 'mri.jpg');

%% APPLY LEAST-SQUARES FILTER IN THE SPATIAL DOMAIN

mri100_11s = least_squares(mri, 'mri.jpg', 100, 11);
mri900_11s = least_squares(mri, 'mri.jpg', 900, 11);
mri100_21s = least_squares(mri, 'mri.jpg', 100, 21);
mri900_21s = least_squares(mri, 'mri.jpg', 900, 21);

checker100_11 = least_squares(checker, 'checker.png', 100, 11);
checker900_11 = least_squares(checker, 'checker.png', 900, 11);
checker100_21 = least_squares(checker, 'checker.png', 100, 21);
checker900_21 = least_squares(checker, 'checker.png', 900, 21);

%% COMPARE IN FUCNTION

compare_images(mri100f, mri100_11s, mri100_21s, 100, [11 21], 'mri.jpg');
compare_images(mri900f, mri900_11s, mri900_21s, 900, [11 21], 'mri.jpg');

%% APPLY WIENER FILTER IN THE FREQUENCY DOMAIN TO THE LOW PASSED IMAGE

fmri25f = wiener_filt_img_freq(mri, 25, 'mri.jpg');
fmri400f = wiener_filt_img_freq(mri, 400, 'mri.jpg');

%% APPLY FILTERING IN THE SPATIAL DOMAIN AFTER LOW PASS FILTER

fmri25_11s = least_squares_spat(mri, 25, 11, 'mri.jpg');
fmri25_21s = least_squares_spat(mri, 25, 21, 'mri.jpg');
fmri400_11s = least_squares_spat(mri, 400, 11, 'mri.jpg');
fmri400_21s = least_squares_spat(mri, 400, 21, 'mri.jpg');

fchecker25_11s = least_squares_spat(checker, 25, 11, 'checker.png');
fchecker25_21s = least_squares_spat(checker, 25, 21, 'checker.png');
fchecker400_11s = least_squares_spat(checker, 400, 11, 'checker.png');
fchecker400_21s = least_squares_spat(checker, 400, 21, 'checker.png');

%% COMPARE IMAGES THAT HAVE BEEN FILTERED

compare_images(fmri25f, fmri25_11s, fmri25_21s, 25, [11 21], ' Low Passed mri.jpg');
compare_images(fmri400f, fmri400_11s, fmri400_21s, 400, [11 21], 'Low Passed mri.jpg');
