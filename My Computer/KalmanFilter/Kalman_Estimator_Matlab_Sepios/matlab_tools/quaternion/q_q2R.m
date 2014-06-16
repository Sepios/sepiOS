% ------------------------------------------------------------------------------
% Function : Quaternion to rotation matrix conversion
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 15 JAN 2013 Initial version
%            V02 02 APR 2014 Added references
% Comment  : Follows [1] (78)
% Status   : Verified that code reflects eqs. in references. Gives inverse of
%                what is implemented in Eigen and Stefans old matlab code.
%
% q        : 4x1 quaternion, [qx; qy; qz; qw]
%
% R        : 3x3 rotation matrix
%
% [1]      : Nikolas Trawny, Stergios Roumeliotis,
%            Indirect Kalman Filter for 3D Attitude Estimation.
% ------------------------------------------------------------------------------

function R = q_q2R(q)

% check if input dimensions are correct
si = size(q);
% assert(si(1)==4);
% assert(si(2)==1);

% compute rotation matrix    
R = (2*q(4)^2-1)*eye(3)-2*q(4)*skewOp(q(1:3))+2*q(1:3)*q(1:3)';

% if eigen conventions were to be followed, the inverse coulb be comp. as fol.:
%R = (2*q(4)^2-1)*eye(3)+2*q(4)*skewOp(q(1:3))+2*q(1:3)*q(1:3)';

end

