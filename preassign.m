clear;
pic = imread('kth.jpg');
[key,cpic] = encoder(pic);%encode picture and get key, encoded picture

%pass the channel
b = [1, 0.7, 0.7];% b is the moving average coefficient if b = [1, 0.7], key(k)=1*key(k)+0.7*key(k-1);
a = [1];     %a is the auto regressive coefficient
key_distorted = filter(b,a,key);
%add AWGN (maybe not needed in this task)

%equalizer
omega = LSEtraining(key_distorted,key,4);%least square estimation
key_equalized = filter(omega,1,key_distorted);

%detector
key_detected = sign(key_equalized);

%decode
dpic = decoder(key_detected,cpic);%decode picture with transmitted key and get the original picture

%count number of different bits between key_detected and original key
difference = sum(key~=key_detected)

%display
image(dpic);
axis square;