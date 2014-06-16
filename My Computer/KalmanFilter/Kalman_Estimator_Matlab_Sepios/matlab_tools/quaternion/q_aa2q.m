% ------------------------------------------------------------------------------
% Function : Angle/axis (three parameters) to quaternion
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 04 FEB 2013 Initial version
%            V02 08 MAY 2013 Covered all zero case. Untested.
%            V03 02 APR 2014 Formatting
% Comment  : 
% Status   : 
%
% qq       : 3xN Angle/axis vectors
%
% q        : 4xN quaternions
% ------------------------------------------------------------------------------

function q = q_aa2q(aa)

% check for correct dimenstions
si = size(aa);
% assert(si(1)==3);

N = si(2);
q = zeros(4,N);

% compute quaternion from angle/axis
for n=1:N
    if( (aa(1,n) == 0) && (aa(2,n) == 0) && (aa(3,n) == 0) )
        q(:,n) = [0;0;0;1];
    else
        angle_ = sqrt(aa(:,n)'*aa(:,n));
        axis_ = aa(:,n)/angle_;
        q(:,n) = q_R2q(q_aa2R([axis_;angle_]));
    end
end

end

