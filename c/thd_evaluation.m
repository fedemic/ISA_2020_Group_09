clear all;
close all;
clc;

read_file=fopen('results_c.txt', 'r');
y = [];

while ~feof(read_file)
   y = fscanf(read_file, '%d');
end
fclose(read_file);

distortion = thd(y)
