% ------------------------------------------------------------------------------
% Function : Angle/axis to rotation matrix
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 11 FEB 2013 Initial version
%            V02 02 APR 2014 Formatting
% Comment  : 
% Status   : 
%
% aa       : 4x1 [ax; ay; az; angle] axis, angle
%
% R        : 3x3 rotation matrix
% ------------------------------------------------------------------------------


function R = q_aa2R(aa)

% check input dimensions
si = size(aa);
% assert(si(1)==4);
% assert(si(2)==1);

c = cos(aa(4));
s = sin(aa(4));
t = 1.0 - c;

m00 = c + aa(1)*aa(1)*t;
m11 = c + aa(2)*aa(2)*t;
m22 = c + aa(3)*aa(3)*t;

tmp1 = aa(1)*aa(2)*t;
tmp2 = aa(3)*s;
m10 = tmp1 + tmp2;
m01 = tmp1 - tmp2;
tmp1 = aa(1)*aa(3)*t;
tmp2 = aa(2)*s;
m20 = tmp1 - tmp2;
m02 = tmp1 + tmp2;    tmp1 = aa(2)*aa(3)*t;
tmp2 = aa(1)*s;
m21 = tmp1 + tmp2;
m12 = tmp1 - tmp2;

R = [m00, m01, m02;
    m10, m11, m12;
    m20, m21, m22];

end

