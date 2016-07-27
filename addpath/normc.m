function [ data ] = normc( data )
% Normalize columns of matrix
% normc(M) normalizes the columns of M to a length of 1.
% 
% Neural Network Toolbox's function
% http://jp.mathworks.com/help/nnet/ref/normc.html
% 
% Examples
% m = [1 2; 3 4];
% normc(m)
% ans =
%      0.3162     0.4472
%      0.9487     0.8944
%
% author: Igawa
% date: 20160607

    [~,m] = size(data);
    for i = 1:m
        data(:,i) = data(:,i)/norm(data(:,i));
    end

end
