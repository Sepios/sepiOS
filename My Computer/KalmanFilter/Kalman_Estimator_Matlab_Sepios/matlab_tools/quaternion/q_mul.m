% ------------------------------------------------------------------------------
% Function : Quaternion multiplication
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 15 JAN 2013 Initial version
%            V02 02 APR 2014 Added references
% Comment  : Follows [1] (8)
% Status   : Verified that code reflects eqs. in references
%
% p, q     : 4x1 quaternions
%
% [1]      : Nikolas Trawny, Stergios Roumeliotis,
%            Indirect Kalman Filter for 3D Attitude Estimation.
% ------------------------------------------------------------------------------

function r = q_mul(q, p)
  r = [ + q(4)*p(1) + q(3)*p(2) - q(2)*p(3) + q(1)*p(4) ;
        - q(3)*p(1) + q(4)*p(2) + q(1)*p(3) + q(2)*p(4) ;
        + q(2)*p(1) - q(1)*p(2) + q(4)*p(3) + q(3)*p(4) ;
        - q(1)*p(1) - q(2)*p(2) - q(3)*p(3) + q(4)*p(4) ];
end

