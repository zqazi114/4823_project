function [accuracy,in_add,samp,out_add,coeff] = compare_outputs(N, inputfile, outputfile)    
    inf = fopen(inputfile, 'r');
    cells = textscan(inf, ['@' '%s' '%s']);
    in_add = cells(1,1);
    in_add = in_add{1};
    in_add = cellfun(@hex2dec,in_add);
    samp = cells(1,2);
    samp = samp{1};
    samp = cellfun(@hex2dec,samp);
    
    outf = fopen(outputfile, 'r');
    cells = textscan(outf, ['@' '%s' '%s']);
    out_add = cells(1,1);
    out_add = out_add{1};
    out_add = cellfun(@hex2dec,out_add);
    out_add = out_add + 1;
    coeff = cells(1,2);
    coeff = coeff{1};
    coeff = cellfun(@hex2dec,coeff);
    coeff = coeff(out_add);
    
    ideal_coeff = fft(samp);
    
    accuracy = sum( abs( (coeff-ideal_coeff) ./ ideal_coeff ) )/N;
    
end