% ------------------------------------------------------------------------------
% Function : Quaternion to roll-pitch-yaw
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 03 JAN 2013 Initial version
%            V02 02 APR 2014 Revised code
% Comment  : 
% Status   : 
%
% q_       : 4xN matrix of quaternions (each column is a quaternion, scalar part
%                is last)
%
% rpy      : 3xN matrix of roll-pitch-yaw angles
% ------------------------------------------------------------------------------

function rpy = q_q2rpy(q_)

[rows, cols] = size(q_);

Y = zeros(1,cols);
P = zeros(1,cols);
R = zeros(1,cols);

for i=1:cols
  q = q_(:,i);

  Y(i)=atan2(2.*(q(1).*q(2)+q(3).*q(4)),(q(4).^2+q(1).^2-q(2).^2-q(3).^2));
  P(i)=asin(2.*(q(2).*q(4)-q(1).*q(3)));
  R(i)=atan2(2.*(q(1).*q(4)+q(3).*q(2)),(q(4).^2-q(1).^2-q(2).^2+q(3).^2));
end

rpy = [R;P;Y];

end

