function predicted = f(twi, slope, irrigation, distance, beta)
    
    predicted = beta(1) * twi + beta(2) * slope + beta(3) * irrigation + beta(4) * distance;
    
end