% ------------------------------------------------------------------------------
% Function : Makes a sequence of quaternions continuous (but non-minimal)
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 30 APR 2014 Initial version
% Comment  : 
% Status   : 
%
% q        : 4xN matrix of quaternions (each column is a quaternion, scalar part
%                is last). Must be minimal.
%
% q_       : 4xN matrix of continuous quaternions
% ------------------------------------------------------------------------------

function q_ = q_nonmin(q)

% check if input dimensions are correct
si = size(q);
% assert(si(1)==4);

N = si(2);
   
q_ = q;
for n=2:N
  if(max(abs(q(1:3,n-1) - q(1:3,n))) > 0.5)
    q_(:, n:end) = -q_(:, n:end);
  end
end

end

