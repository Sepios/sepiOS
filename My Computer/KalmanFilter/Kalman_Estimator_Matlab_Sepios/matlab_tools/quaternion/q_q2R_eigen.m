% ------------------------------------------------------------------------------
% Function : Quaternion to rotation matrix conversion matching Eigen conventions
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 09 APR 2014 initial version
% Comment  : Follows Eigen code, inverse rotation matrix w.r.t. q_q2R
% Status   : 
%
% q        : 4x1 quaternion, [qx; qy; qz; qw]
%
% R        : 3x3 rotation matrix
% ------------------------------------------------------------------------------

function R = q_q2R_eigen(q)

% check if input dimensions are correct
si = size(q);
% assert(si(1)==4);
% assert(si(2)==1);

x = q(1);
y = q(2);
z = q(3);
w = q(4);

tx  = 2*x;
ty  = 2*y;
tz  = 2*z;
twx = tx*w;
twy = ty*w;
twz = tz*w;
txx = tx*x;
txy = ty*x;
txz = tz*x;
tyy = ty*y;
tyz = tz*y;
tzz = tz*z;

R = zeros(3);

R(1,1) = 1-(tyy+tzz);
R(1,2) = txy-twz;
R(1,3) = txz+twy;
R(2,1) = txy+twz;
R(2,2) = 1-(txx+tzz);
R(2,3) = tyz-twx;
R(3,1) = txz-twy;
R(3,2) = tyz+twx;
R(3,3) = 1-(txx+tyy);

end

