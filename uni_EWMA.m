%Moving Average 
%Created by Qianao Ju

function [d_pred, Err] = uni_EWMA(rdata, alpha)
    d_pred = zeros(length(rdata),1);
    d_pred(1) = rdata(1);
    for i = 1: length(rdata)-1
       d_pred(i+1) = alpha * rdata(i) + (1-alpha) * d_pred(i);
        
    end

    Err = d_pred - rdata;








end