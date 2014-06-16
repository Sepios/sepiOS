% ------------------------------------------------------------------------------
% Function : Generate motion with specific characteristics in freq. dom.
%            Under the assumption that the true signal is band-limited to half
%                the sampling frequency, the values of the simulated state are
%                perfect up to "numerical quantization"
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 26 MAR 2014 Initial version
% Comment  : Make sure the quaternion tool package path is loaded
%                addpath('~/git/tools/matlab_tools/quaternion');
% Status   : 
%
% param.ts       : sampling time in s
% param.duration : duration in s
% param.p.pwr    : power of position
% param.p.f_cut  : cut-off frequency for position
% param.q.pwr    : power of orientation
% param.q.f_cut  : cut-off frequency for orientation
% param.repeat   : additional number of times the motion should be repeated
%
% x_sim          : simulated state
%                      [q_BW;		% body attitude quaternion
%                       p_WB_W;		% position of the body
%                       v_WB_W;		% velocity of the body
%                       a_WB_W;		% linear acceleration of the body
%                       w_WB_B]		% angular velocity of the body
%                  "W": "Fixed" "World" frame
%                  "B": "Moving" "Body" frame
%                  p_WB_A means vector from W to B, expressed in frame A
%                  q_BW attitude quaternion that transforms vectors expressed in
%                      W to B. v_WB_B = q_q2R(q_BW) * v_WB_W.
% t_             : time vector in s
% ------------------------------------------------------------------------------

function [x_sim, t_] = generate_motion_frequency(param)

t_ = 0:param.ts:param.repeat*param.duration-param.ts;	% time vector

fs = 1 / param.ts;				% sampling frequency
N = param.duration / param.ts;			% number of samples

assert(N <= 1e5);				% current implementation is
						%     somewhat inefficient. N
						%     too large causes perf.
						%     problems.

f_delta = fs / N;				% frequency resolution
f_ = ifftshift(fs * (-1/2:1/N:1/2-1/N)');


%% position, velocity, acceleration

N_active_p = floor(param.p.f_cut / fs * N);	% number of active freq. bins P
Pr_lower = [ randn(N_active_p, 3);		% real part
             zeros(N/2 - N_active_p + 1, 3) ];
Pi_lower = [ randn(N_active_p, 3);		% imag part
             zeros(N/2 - N_active_p + 1, 3) ];
Pr = [ Pr_lower;				% real part of position spectrum
       flipud(Pr_lower(2:end-1, :)) ];
Pi = [ Pi_lower;				% imag part of position spectrum
       -flipud(Pi_lower(2:end-1, :)) ];
pwr = sqrt(param.p.pwr*N*fs/(param.p.f_cut*2));	% compute approx. mag. of spec.
P = pwr *(Pr + 1i * Pi);			% assemble position spectrum
P(1, :) = zeros(1, 3);				% set DC component to zero. At least
						% imaginary part must be zero for real
						% signals
p = ifft((P));					% compute position

% velocity
Pd = repmat(((1i*2*pi.*f_)), 1, 3) .* P(:, :);	% derivative operator in freq.
pd = ifft(Pd);					% compute velocity

% acceleration
Pdd = repmat(((1i*2*pi.*f_)), 1, 3) .* Pd(:, :);	% der. op. in freq.
pdd = ifft(Pdd);				% compute acceleration


%% attitude, angular velocity

N_active_q = floor(param.q.f_cut / fs * N);	% number of active frequency bins Q

Qr_lower = [ randn(N_active_q, 3);		% real
            zeros(N/2 - N_active_q + 1, 3) ];
Qi_lower = [ randn(N_active_q, 3);		% imag
            zeros(N/2 - N_active_q + 1, 3) ];
Qr = [ Pr_lower;				% real part of position spectrum
       flipud(Pr_lower(2:end-1, :)) ];
Qi = [ Pi_lower;				% imag part of position spectrum
       -flipud(Pi_lower(2:end-1, :)) ];
pwr = sqrt(param.q.pwr*N*fs/(param.p.f_cut*2));	% compute spec. ampl.
Q = pwr*(Qr + 1i * Qi);				% position spectrum
Q(1, :) = zeros(1, 3);				% set DC component to zero. At least
						% imaginary part must be zero for real
						% signals
r = ifft((Q));					% compute attitude (Gibbs)
F = dftmtx(N);					% alternative method
F_inv = conj(F)/N;

rd_F = F_inv.*repmat(conj(((1i*2*pi.*f_))'), N, 1) * Q(:, :);
						% compute derivative

q = zeros(N, 4);
w = zeros(N, 3);
for j = 1:N
  q(j, :) = q_R2q(q_r2R(r(j, :)')');
  q(j, :) = q_min(q_norm(q(j, :)'))';
  % compute angular velocity
  w(j, :) = real((q_r2S(r(j, :)')) * rd_F(j, :)');
end

x_sim = zeros(16, N);

x_sim(1:4, :) = q';			% orientation
x_sim(5:7, :) = real(p');		% position
x_sim(8:10, :) = real(pd');		% velocity
x_sim(11:13, :) = real(pdd');		% acceleration
x_sim(14:16, :) = real(w');		% angular velocity

x_sim = repmat(x_sim, 1, param.repeat);

end

