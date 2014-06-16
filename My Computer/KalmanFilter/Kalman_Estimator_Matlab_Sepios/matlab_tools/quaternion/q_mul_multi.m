% ------------------------------------------------------------------------------
% Function : Quaternion multiplication (multiple quaternions)
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 25 APR 2014 Initial version
% Comment  : Follows [1] (8)
% Status   : Verified that code reflects eqs. in references
%
% p, q     : 4xN N quaternions
%
% [1]      : Nikolas Trawny, Stergios Roumeliotis,
%            Indirect Kalman Filter for 3D Attitude Estimation.
% ------------------------------------------------------------------------------

function r = q_mul_multi(q, p)
  sq = size(q);
  sp = size(p);
  
  % assert(sq(1) == 4);
  % assert(sp(1) == 4);
  
  N = sq(2);
  assert(sp(2) == N);
  
  r = zeros(4, N);
  
  for i=1:N
    r(:, i) = [ + q(4, i)*p(1, i) + q(3, i)*p(2, i) - q(2, i)*p(3, i) + q(1, i)*p(4, i) ;
                - q(3, i)*p(1, i) + q(4, i)*p(2, i) + q(1, i)*p(3, i) + q(2, i)*p(4, i) ;
                + q(2, i)*p(1, i) - q(1, i)*p(2, i) + q(4, i)*p(3, i) + q(3, i)*p(4, i) ;
                - q(1, i)*p(1, i) - q(2, i)*p(2, i) - q(3, i)*p(3, i) + q(4, i)*p(4, i) ];
  end
end

