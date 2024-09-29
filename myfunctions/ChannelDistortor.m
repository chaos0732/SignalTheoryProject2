function [key_distorted] = ChannelDistortor(key)
b = [1, 0.7, 0.7];% b is the moving average coefficient if b = [1, 0.7], key(k)=1*key(k)+0.7*key(k-1);
a = [1];     %a is the auto regressive coefficient

key_distorted = filter(b,a,key);