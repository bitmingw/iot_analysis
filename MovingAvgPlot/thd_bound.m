%return upper control 
%created by Qianao Ju


function [mu, phi] = thd_bound(rdata, w, type)
    mu = zeros(length(rdata), 1);
    phi = zeros(length(rdata), 1);
    
    
    if type == 1
        for i = 1:w
            mu(i) = mean(rdata(1:i));
            phi(i) = var(rdata(1:i));
        end
    
    
        for i = w : length(mu)
            mu(i) = mean(rdata(i-w+1:i));
            phi(i) = var(rdata(i-w+1:i));
        end
        
    elseif type == 2
        for i = 1: length(rdata)
            mu(i) = mean(rdata(1:i));
            phi(i) = var(rdata(1:i));
        end
    end




end