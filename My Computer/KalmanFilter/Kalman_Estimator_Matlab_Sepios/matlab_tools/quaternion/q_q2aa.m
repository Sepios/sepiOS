% ------------------------------------------------------------------------------
% Function : Quaternion to angle/axis
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 30 JAN 2013 Initial version
%            V02 02 APR 2014 Formatting
% Comment  : 
% Status   : 
%
% q        : 4xN input quaternions
%
% aa       : 3xN angle/axis
% angle_   : 1xN angles
% axis_    : 3xN axes
% ------------------------------------------------------------------------------

function [aa, angle_, axis_] = q_q2aa_vB(q)

% check input dimensions
si = size(q);
% assert(si(1)==4);

N = si(2);
aa = zeros(3,N);
angle_ = zeros(1,N);
axis_ = zeros(3,N);

for n=1:N
aa2 = vrrotmat2vec(q2_q2R(q(:,n)));
aa(:,n) = aa2(4) * aa2(1:3)';
angle_(n) = aa2(4);
axis_(:,n) = aa2(1:3)';

if (q(4,n) > 1)
  q(:,n) = q_norm(q(:,n));
end

qx = q(1,n);
qy = q(2,n);
qz = q(3,n);
qw = q(4,n);

angle = 2 * acos(qw);
s = sqrt(1-qw*qw);
if (s < 0.001) % test to avoid divide by zero, s is always positive due to sqrt
               % if s close to zero then direction of axis not important
  x = qx;      % if it is important that axis is normalised then replace with
               %     x=1; y=z=0;
  y = qy;
  z = qz;
else
  x = qx / s; % normalise axis
  y = qy / s;
  z = qz / s;
end

aa(:,n) = [x;y;z]*angle;
angle_(n) = angle;
axis_(:,n) = [x;y;z];

end

end

