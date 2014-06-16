% ------------------------------------------------------------------------------
% Function : Quaternion left multiplication matrix from quaternion
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 16 AUG 2014 Initial version
% Comment  : Follows [1] (16)
% Status   : Only implemented equation from reference.
%
% q        : 4x1 quaternion, [qx; qy; qz; qw]
%
% ML       : 4x4 uaternion left multiplication matrix
%
% [1]      : Nikolas Trawny, Stergios Roumeliotis,
%            Indirect Kalman Filter for 3D Attitude Estimation.
% ------------------------------------------------------------------------------

function ML = q_q2ML(q)

% check if input dimensions are correct
si = size(q);
% assert(si(1)==4);
% assert(si(2)==1);

ML = [ q(4),  q(3), -q(2), q(1);
      -q(3),  q(4),  q(1), q(2);
       q(2), -q(1),  q(4), q(3);
      -q(1), -q(2), -q(3), q(4)];

end

