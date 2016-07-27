function [ data ] = normr( data )
% Normalize rows of matrix
% normr(M) normalizes the rows of M to a length of 1.
% 
% Neural Network Toolbox's function
% http://jp.mathworks.com/help/nnet/ref/normr.html
%
% Examples
% m = [1 2; 3 4];
% normr(m)
% ans =
%       0.4472     0.8944
%       0.6000     0.8000
%       
% author: Igawa
% date: 20160607

    [n,~] = size(data);
    for i = 1:n
        data(i,:) = data(i,:)/norm(data(i,:));
    end
end