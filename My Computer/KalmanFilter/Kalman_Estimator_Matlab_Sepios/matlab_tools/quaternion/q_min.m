% ------------------------------------------------------------------------------
% Function : Ensures quaternion represents minimal rotation (positive scalar).
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 04 FEB 2013 Initial version
%            V02 02 APR 2014 Revised code
% Comment  : 
% Status   : 
%
% q        : 4xN matrix of quaternions (each column is a quaternion, scalar part
%                is last)
%
% q_       : 4xN matrix of minimal quaternions (with positive scalar part)
% ------------------------------------------------------------------------------

function q_ = q_min(q)

% check if input dimensions are correct
si = size(q);
% assert(si(1)==4);

N = si(2);
   
q_ = q;
for n=1:N
  if(q(4,n) < 0)
    q_(:,n)=-q_(:,n);
  end
end

end

