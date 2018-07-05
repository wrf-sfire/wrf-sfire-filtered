function [ likelihood ] = compute_likelihood(heat,mask,sig,radius,weight )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[m n] = size(heat);
pd = zeros(m,n);
log_sum = 0;

for i=1:m
    for j=1:n
        pd(i,j) = detection_probability(heat(i,j));
    end 
end




for i = radius+1:m-radius
    for j = radius+1:m-radius
        pp = 1;
        if mask(i,j)>0
            %pp = compute_pixel_probability(i,j,heat,radius,weight,pd); %old
            pp = compute_pixel_probability(i,j,heat,sig,weight,pd);
            %compute_pixel_probability(pixel_x,pixel_y,heats,sig, weight, detection_probabilities )
        else
            pp = 1;
            %pp = 1 - compute_pixel_probability(i,j,heat,sig,weight,pd);
        end
        
        
        log_sum = log_sum + log(pp);
    end
end

likelihood = log_sum;
    
    
end

