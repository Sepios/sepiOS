% ------------------------------------------------------------------------------
% Function : EKF Attitude Estimator Function
% Project  : Sepios
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : Alessandro Schäppi & Pascal Buholzer, Sepios
% Comment  : Similar to extended_kalman_filter_process, but with pressure and compass upd and external initialisation
% ------------------------------------------------------------------------------

% x            : 16x1 state vector [[qx; qy; qz; qw]; p; v; gyro_bias; acc_bias]
% m_m          : 3x1 magnetic field measurement (in IMU frame S, here assumed to be equal to body-frame) [uT]
% p_bp_B       : 3x1 offset [m] of pressure-sensor from body-center in body-cord
% p_m          : 1x1 measured depth [m]
% g            : 1x1 local gravity constant (negative) [m/s^2]
% magf_W:      : 3x1 local true magnetic flux density in world-frame [uT]
% sigmas_imu   : 5x1 vector with all imu-sigmas [sigmaw; sigmawb; sigmaa; sigmaab; sigmam]
% sigmas_mea   : 2x1 vector with all measurement-sigmas [sigmav[m/s]; sigmap[m]]
% press_upd    : Boolean (1=use pressure sensor)
% comp_upd     : Boolean (1=use compass)


% Run extended_kalman_filter_process_p_c_init.m to generate x and P for first iteration!

function [x, P] = extended_kalman_filter_process_wpressure_offset_compass_exinit(w_m, a_m, m_m, p_m, p_bp_B, ts, x, P, g, magf_W, sigmas_imu, sigmas_mea, press_upd, comp_upd)
%% set constants
g_ = [0; 0; g];		% gravity vector Zurich

% imu sigmas
imuparam.sigmaw    = sigmas_imu(1);   % gyro noise        
imuparam.sigmawb   = sigmas_imu(2);   % gyro bias 
imuparam.sigmaa    = sigmas_imu(3);   % accel noise
imuparam.sigmaab   = sigmas_imu(4);   % accel bias
imuparam.sigmam    = sigmas_imu(5);   % magnetic field sigma
% continuous-time imu noise matrix
Qc = [imuparam.sigmaw^2*eye(3),                  zeros(3),                 zeros(3),                  zeros(3);
                      zeros(3), imuparam.sigmawb^2*eye(3),                 zeros(3),                  zeros(3);
                      zeros(3),                  zeros(3), imuparam.sigmaa^2*eye(3),                  zeros(3);
                      zeros(3),                  zeros(3),                 zeros(3), imuparam.sigmaab^2*eye(3)];
% discrete-time imu noise matrix
Qd = ts*Qc;

% measurement update sigmas
meaparam.sigmav = sigmas_mea(1);			% zero-velocity update sigma
meaparam.sigmap = sigmas_mea(2);            % pressure sigma

Rv = meaparam.sigmav^2;
Rp = meaparam.sigmap^2;
Rm = imuparam.sigmam^2;

% R = Measurement noise covariance
if  (press_upd && comp_upd)                             % Switch sensor-cases
    R = [[Rv,0,0 ; 0,Rv,0 ; 0,0,Rp], zeros(3);...
      zeros(3) , eye(3)*Rm];
elseif (press_upd && ~comp_upd)
    R = [[Rv,0,0 ; 0,Rv,0];
         0,0,Rp];
else    % IMU only
    R = Rv*eye(3);
end

%% propagate state
% first-order attitude propagation
x(1:4, 1) = (eye(4) + ts * 1/2 * ...
    q_w2Omega(w_m(:, 1)-x(11:13, 1))) * x(1:4, 1);
R_BW = q_q2R(x(1:4, 1));            % compute actual Rotation-Matrix Body against World
% velocity
a_WB_W_hat = R_BW' * (a_m(:, 1) - x(14:16, 1)) - g_;
x(8:10, 1) = x(8:10, 1) + ts*a_WB_W_hat;
% position
x(5:7, 1) = x(5:7, 1) + ts*(x(8:10, 1));
% gyro bias
x(11:13, 1) = x(11:13, 1);
% accel bias
x(14:16, 1) = x(14:16, 1);

% continuous-time error state transition matrix
Fc = [      -skewOp(w_m(:, 1) - x(11:13, 1)), zeros(3), zeros(3),  -eye(3), zeros(3);
                                    zeros(3), zeros(3),   eye(3), zeros(3), zeros(3);
      -R_BW'*skewOp(a_m(:, 1) - x(14:16, 1)), zeros(3), zeros(3), zeros(3),   -R_BW';
                                    zeros(3), zeros(3), zeros(3), zeros(3), zeros(3);
                                    zeros(3), zeros(3), zeros(3), zeros(3), zeros(3)];
% discrete-time error state transition matrix
Fd = eye(15) + ts * Fc;
G = [-eye(3),  zeros(3), zeros(3), zeros(3);
     zeros(3), zeros(3), zeros(3), zeros(3);
     zeros(3), zeros(3), -R_BW',   zeros(3);
     zeros(3), eye(3),   zeros(3), zeros(3);
     zeros(3), zeros(3), zeros(3), eye(3)];
% propagate covariance matrix
P = Fd*P*Fd' + G*Qd*G';


%% update
% compute estimated depth-measurement-error due to attitude and sensor-offset
p_bp_W = R_BW' * p_bp_B;          % Offset-Vector in World-coordinates
p_err_z = p_bp_W(3,1);            % Extract Z-Dimension
p_m = p_m-p_err_z;                % Correct measured depth with estimated error due to attitude

% observation matrix H for position measurements
Hp_q = -R_BW'*skewOp(p_bp_B);                                                % Influence of offset position update on attitude
Hp = [Hp_q(3,:), [0, 0, 1]  , zeros(1, 3), zeros(1, 3), zeros(1, 3)];        % Influence of offset z-position update on attitude and z-position
% Hp = [zeros(1,3), [0, 0, 1]  , zeros(1, 3), zeros(1, 3), zeros(1, 3)];     % Influence of offset z-position update on z-position only (for testing)
Hv = [zeros(3),    zeros(3) ,      eye(3),    zeros(3),    zeros(3)];        % Influence of Velocity update on velocity
Hm = [skewOp(R_BW * magf_W) , zeros(3) ,zeros(3) ,zeros(3) , zeros(3)];      % Influence of magnetometer-measurement on attitude

if  (press_upd && comp_upd)     % Switch sensor-cases
    H = [Hv(1:2,:); Hp; Hm];
elseif (press_upd && ~comp_upd)
    H = [Hv(1:2,:); Hp];
else
    H=Hv;
end

% compute velocity,pressure and compass measurement residual
rv = zeros(3, 1) - x(8:10, 1);                     % zero velocity update assumed
rp = p_m - x(7, 1);                                % z-position measurement update
rm = m_m / norm(m_m) - R_BW'*magf_W/norm(magf_W);  % Compass update

if  (press_upd && comp_upd)     % Switch sensor-cases
    r = [rv(1:2);rp;rm];
elseif (press_upd && ~comp_upd)
    r = [rv(1:2);rp];
else
    r=rv;
end

% compute Kalman gain
K = P*H'*inv(H*P*H' + R);
% compute correction
dx = K*r;
% apply correction
x(5:7, 1)   = x(5:7, 1)   + dx(4:6);
x(8:10, 1)  = x(8:10, 1)  + dx(7:9);
x(1:4, 1)   = q_mul( ([1/2*dx(1:3); 1]), x(1:4, 1));
x(1:4, 1)   = q_norm(q_min(x(1:4, 1)));
x(11:13, 1) = x(11:13, 1) + dx(10:12);
%x(14:16, 1) = x(14:16, 1) + dx(13:15);		% TODO: we should switch accel
                                            % bias tracking on

% update covariance matrix
P = (eye(15) - K*H) * P;

end

