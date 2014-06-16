% ------------------------------------------------------------------------------
% Function : Quaternion to rotation matrix conversion matching Stefan conv.
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 09 APR 2014 initial version
% Comment  : Follows Stefans code, identiacal with eigen, inverse of q_q2R
% Status   : 
%
% q        : 4x1 quaternion, [qx; qy; qz; qw]
%
% R        : 3x3 rotation matrix
% ------------------------------------------------------------------------------

function R = q_q2R_stefan(q)

% check if input dimensions are correct
si = size(q);
% assert(si(1)==4);
% assert(si(2)==1);

q = [q(4, 1); q(1:3, 1)];

Q = permute(q,[1 3 2]);

R = [
   Q(1,1,:).^2+Q(2,1,:).^2-Q(3,1,:).^2-Q(4,1,:).^2 2.0.*(Q(2,1,:).*Q(3,1,:)-Q(1,1,:).*Q(4,1,:))   2.0.*(Q(2,1,:).*Q(4,1,:)+Q(1,1,:).*Q(3,1,:))
   2.0.*(Q(2,1,:).*Q(3,1,:)+Q(1,1,:).*Q(4,1,:))   Q(1,1,:).^2-Q(2,1,:).^2+Q(3,1,:).^2-Q(4,1,:).^2 2.0.*(Q(3,1,:).*Q(4,1,:)-Q(1,1,:).*Q(2,1,:))
   2.0.*(Q(2,1,:).*Q(4,1,:)-Q(1,1,:).*Q(3,1,:))   2.0.*(Q(3,1,:).*Q(4,1,:)+Q(1,1,:).*Q(2,1,:))   Q(1,1,:).^2-Q(2,1,:).^2-Q(3,1,:).^2+Q(4,1,:).^2];


end

