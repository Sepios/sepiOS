% ------------------------------------------------------------------------------
% Function : Tests motion generation function (freq. dom.)
% Project  : 
% Author   :
% Version  : V01 26 MAR 2014 Initial version.
% Comment  :
% ------------------------------------------------------------------------------

%% initialize workspace

clear all;
close all;
addpath('../quaternion');


%% generate motion

% set parameters for motion generation
param.ts = 0.01;			% sampling time in s
param.duration = 100;			% duration in s
param.p.pwr = 0.2^2;			% power of position
param.p.f_cut = 0.02;			% cut-off frequency for position
param.q.pwr = 0.1^2;			% power of orientation
param.q.f_cut = 0.01;			% cut-off frequency for orientation
param.repeat = 2;			% additional number of times the motion
                                        %  should be repeated.
% generate motion
disp ' >> generating motion'
[x_sim, t_] = generate_motion_frequency(param);
q_BW = x_sim(1:4, :);
p_WB_W = x_sim(5:7, :);
v_WB_W = x_sim(8:10, :);
a_WB_W = x_sim(11:13, :);
w_WB_B = x_sim(14:16, :);


%% plot simulated motion

N = param.duration / param.ts * param.repeat;
ts = param.ts;

% plot position, velocity, acceleration
disp ' >> plotting position, velocity, acceleration'
figure();
subplot 311;
plot(t_, p_WB_W');
title 'p WB W';
subplot 312;
plot(t_, v_WB_W');
title 'v WB W';
subplot 313;
plot(t_, a_WB_W');
title 'a WB W';

% plot orientation, angular velocity
disp ' >> plotting orientation, angular velocity'
figure();
subplot 311;
plot(t_, q_BW');
title 'q WB';
subplot 312;
plot(t_, w_WB_B');
title 'w WB B';


%% forward propagation

% velocity
disp ' >> integrating velocity to obtain position'
p_WB_W_int = zeros(3, N);
p_WB_W_int(:, 1) = p_WB_W(:, 1);
for j = 2:N
  p_WB_W_int(:, j) = p_WB_W_int(:, j-1) + ts*1/2*(v_WB_W(:,j-1) + v_WB_W(:,j));
end

% acceleration
disp ' >> integrating acceleration to obtain velocity'
v_WB_W_int = zeros(3, N);
v_WB_W_int(:, 1) = v_WB_W(:, 1);
for j = 2:N
  v_WB_W_int(:, j) = v_WB_W_int(:, j-1) + ts*1/2*(a_WB_W(:,j-1) + a_WB_W(:,j));
end

% plot integrated velocity and acceleration
disp ' >> plotting integrated acceleration and velocity'
figure();
subplot 211;
plot(t_, p_WB_W');
hold on;
plot(t_, p_WB_W_int', '+');
title 'p WB W and trapezoid integrated v WB W'
subplot 212;
plot(t_, v_WB_W');
hold on;
plot(t_, v_WB_W_int', '+');
title 'v WB W and trapezoid integrated a WB W'

% attitude: integrate angular velocity
disp ' >> propagating attitude'
q_BW_int = zeros(4, N);
q_BW_int(:, 1) = q_BW(:, 1);
for j = 2:N
  q = (eye(4) + ts * 1/2 * q_w2Omega(w_WB_B(:, j))) * q_BW_int(:, j-1);
  q = q_min(q_norm(q));
  q_BW_int(:, j) = q;
end

disp ' >> plotting propagated attitude'
figure();
plot(q_BW');
hold on;
plot(q_BW_int', '+');
title 'true and propagated (+) attitude quaternion'



