% ------------------------------------------------------------------------------
% Function : Normalize quaternion
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 01 FEB 2013 Initial version
%            V02 02 APR 2014 Formatting
% Comment  : 
% Status   : 
%
% q        : 4xN input quaternions [qx; qy; qz; qw]
%
% p        : 4xN normalized quaternions of q
% ------------------------------------------------------------------------------

function p = q_norm(q)

% check input dimensions
% assert(size(q,1)==4);

N = size(q,2);
p=zeros(4,N);

% normalize quaternions    
for i=1:N
  p(:,i) = q(:,i)/norm(q(:,i));
end

end

