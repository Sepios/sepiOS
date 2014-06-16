% ------------------------------------------------------------------------------
% Function : Roll-pitch-yaw to quaternion
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 03 JAN 2013 Initial version
%            V02 02 APR 2014 Revised code
% Comment  : 
% Status   : 
%
% rpy      : 3x1 vector of roll-pitch-yaw angles
%
% q        : 4x1 vector of quaternions [qx; qy; qz; qw]
% ------------------------------------------------------------------------------

function q = q_rpy2q(rpy)

r = rpy(1);
p = rpy(2);
y = rpy(3);

cRh = cos(r/2);
sRh = sin(r/2);
cPh = cos(p/2);
sPh = sin(p/2);
cYh = cos(y/2);
sYh = sin(y/2);

q = [ sRh.*cPh.*cYh - cRh.*sPh.*sYh
      cRh.*sPh.*cYh + sRh.*cPh.*sYh
      cRh.*cPh.*sYh - sRh.*sPh.*cYh
      cRh.*cPh.*cYh + sRh.*sPh.*sYh];

end

