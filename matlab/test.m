clear;clc;

% generate inputs
inputfile = 'input.dat';
outputfile = 'output.dat';
N = 32;
samples = generate_inputs(N, inputfile);

%compare outputs
[acc,in_add,samp,out_add,coeff] = compare_outputs(N, inputfile, outputfile);
