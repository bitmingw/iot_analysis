function [mu, phi] = mv_thd_bound(rdata, w, type)
    [a, b] = size(rdata);
    mu = zeros(size(rdata));
    phi = zeros(b*a,b);
    
    
    if type == 1
        for i = 1:w
            mu(i,:) = mean(rdata(1:i,:));
            phi(b*i-b+1:b*i,:) = cov(rdata(1:i,:));
        end
    
    
        for i = w : length(mu)
            mu(i,:) = mean(rdata(i-w+1:i,:));
            phi(b*i-b+1:b*i,:) = cov(rdata(i-w+1:i,:));
        end
        
    elseif type == 2
        for i = 1: length(rdata)
            mu(i,:) = mean(rdata(1:i,:));
            phi(b*i-b+1:b*i,:) = cov(rdata(1:i,:));
        end
    end




end