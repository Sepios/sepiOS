% ------------------------------------------------------------------------------
% Function : Rotation Matrix to Quaternion
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 13 FEB 2013 Initial version
%            V02 01 APR 2014 Check that R is a proper rotation matrix. If
%                not, caller must make sure det(R) = 1, if det(R) = -1,
%                consider R = -R.
%            V03 02 APR 2014 Formatting
% Comment  : 
% Status   : 
%
% R        : 3x3 input (proper) rotation matrix in SO(3)
%
% q        : 4x1 quaternion [qx; qy; qz; qw]
% ------------------------------------------------------------------------------

function q = q_R2q(R)

% make sure rotation matrix is proper (det(R) = +1)
% assert(det(R) > 0);

m00 = R(1,1);
m10 = R(2,1);
m20 = R(3,1);

m01 = R(1,2);
m11 = R(2,2);
m21 = R(3,2);

m02 = R(1,3);
m12 = R(2,3);
m22 = R(3,3);

tr = m00 + m11 + m22;

% compute quaternion from rotation matrix
if (tr > 0)
    S = sqrt(tr+1.0) * 2;
    qw = 0.25 * S;
    qx = (m21 - m12) / S;
    qy = (m02 - m20) / S;
    qz = (m10 - m01) / S;
else
    if ((m00 > m11)&&(m00 > m22))
        S = sqrt(1.0 + m00 - m11 - m22) * 2;
        qw = (m21 - m12) / S;
        qx = 0.25 * S;
        qy = (m01 + m10) / S;
        qz = (m02 + m20) / S;
    elseif (m11 > m22)
        S = sqrt(1.0 + m11 - m00 - m22) * 2;
        qw = (m02 - m20) / S;
        qx = (m01 + m10) / S;
        qy = 0.25 * S;
        qz = (m12 + m21) / S;
    else
        S = sqrt(1.0 + m22 - m00 - m11) * 2;
        qw = (m10 - m01) / S;
        qx = (m02 + m20) / S;
        qy = (m12 + m21) / S;
        qz = 0.25 * S;
    end
end
    
q = [qx;qy;qz;-qw];
    
end

