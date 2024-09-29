clear;
load("training.mat");
load("spydata.mat");
key_received = received;
key_training = training;
%equalizer
omega = LSEtraining(key_received(1:32),key_training,8);%least square estimation
key_equalized = filter(omega,1,key_received);

%detector
key_detected = sign(key_equalized);

%decode
dpic = decoder(key_detected,cPic);%decode picture with transmitted key and get the original picture

%display picture
image(dpic);
axis square;