function [samples] = generate_inputs(N, filename)
    samples = floor(2^10*rand(N,1));
    f = fopen(filename, 'w');
    for n = 1:N
        fprintf(f, '@%s %s\n', dec2hex(n-1), dec2hex(samples(n) ) );
    end
end