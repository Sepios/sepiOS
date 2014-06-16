% ------------------------------------------------------------------------------
% Function : Skew-symmetric matrix operator
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 01 FEB 2013 Initial version
%            V02 02 APR 2014 Formatting
% Comment  : Follows [1] (6)
% Status   : 
%
% w        : 3x1 input vector
%
% W        : 3x3 skew-symmetric matrix
%
% [1]      : Nikolas Trawny, Stergios Roumeliotis,
%            Indirect Kalman Filter for 3D Attitude Estimation.
% ------------------------------------------------------------------------------

function W = skewOp(w)
  W = [    0 -w(3)  w(2);
        w(3)     0 -w(1);
       -w(2)  w(1)     0];
end

