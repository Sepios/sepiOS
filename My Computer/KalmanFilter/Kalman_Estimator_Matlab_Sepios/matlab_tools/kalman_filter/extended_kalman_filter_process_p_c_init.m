% ------------------------------------------------------------------------------
% Function : Attitude initialization from acceleration and magnetometer measurement
% Project  : Sepios
% Author   : ETH (www.eth.ch), Alessandro Schäppi & Pascal Buholzer, Janosch Nikolic
% Version  : V01 12 May 2014 Initial version
% Comment  : Initializes filter attitude based on acceleration and magnetometer measurements.
%            Gravity-aligned, yaw set to actual heading if comp_upd enabled
%            If comp_upd disabled yaw is set to zero.
%            
% Status   : Initial Gyro-Bias-Offset tuned to fit ADIS16488 of Sepios
%            Initial Gyro-Bias-Covariance tuned to fit ADIS16488 of Sepios
%
% a_m      : 3x1 linear acceleration measurements (accel. reading in m/s^2)
% b_x_init : 6x1 initial biases [gyro-bias_init; acc-bias_init]
% b_P_init : 2x1 initial biases covariances [sigmawbon; sigmaabon]
% m_m      : 3x1 magnetic field measurement (in IMU frame S, here assumed to be equal to body-frame) [uT]
% magf_W:  : 3x1 local true magnetic flux density in world-frame [uT]
% p_m      : 1x1 measured depth in world-frame [m] (not implemented yet)
% comp_upd : Boolean (1=use compass, 0=align using only gravity vector)

% x_init   : initial state [16 x 1] [[qx; qy; qz; qw]; p; v; gyro_bias; acc_bias]
% P_init   : initial covariance [15 x 15]
% error    : initialization error accured (1=error, 0=no error)

% ------------------------------------------------------------------------------


function [x_init, P_init, error] = extended_kalman_filter_process_p_c_init(a_m, m_m, b_x_init, b_P_init, comp_upd)

error = 0;                      % initialize error-variable

%% Gravity alignment for roll and pitch
i3 = a_m / norm(a_m);
i1 = [1;0;-i3(1)/i3(3)];
i1 = i1/norm(i1);
i2 = cross(i1, i3);
M = [i1, i2, i3];       %Rotation matrix body against world.

% Make sure M is proper, an element of SO(3)
if(det(M) < 0)
  M = -M;
end

q_init_hat = q_R2q(M);                         % Rotation Matrix Gravity to Quaternion
rpy_init_hat = q_q2rpy(q_init_hat);            % Quaternion to roll-pitch-jaw
dq = q_rpy2q([0;0;-rpy_init_hat(3)]);          % Read Jaw-Angle negative and create a dq quaternion containing a negative rotation only on yaw
q_init = q_mul(q_init_hat, dq);                % Quaternion multiplication to set initial yaw to zero.
                                               % q_init initial attitude quaternion [qx; qy; qz; qw]

%% Compass alignment for initial yaw
if (comp_upd == 1)
    R_BW_init = q_q2R(q_min(q_init));              % calculate initial rotation matrix body ag. world
    m_m_W = R_BW_init' * m_m;                      % transfer measured magnetic flux to world frame

    % To be verified!! Seems to be working
    % Calculate actual heading neglecting z-component of mag-field-measurement
    x = m_m_W(1);
    y = m_m_W(2);     
    if (x>0 && y>0)
        yaw_mag_hat = atan(abs(y/x));
    elseif (x>0 && y<0)
        yaw_mag_hat = (2*pi-atan(abs(y/x)));    
    elseif (x<0 && y>0)
        yaw_mag_hat = (pi - atan(abs(y/x)));    
    elseif (x<0 && y<0)        
        yaw_mag_hat = (pi + atan(abs(y/x)));
    else 
          disp 'initialization error'
          error = 1;
    end

    dq_mag = q_rpy2q([0;0; -yaw_mag_hat]);    % Read Jaw-Angle and create a dq quaternion containing a rotation only on yaw
    q_init = q_mul(q_init, dq_mag);         % Quaternion multiplication to set initial yaw to calculated compass heading
end

%% Create initialized state and covariance
x_init = [q_init; zeros(3,1); zeros(3,1); b_x_init];
P_init = diag([ones(3, 1)*0.1^2;
            ones(3, 1)*0.1^2;
            ones(3, 1)*0.1^2;
            ones(3, 1)*b_P_init(1,1)^2;
            ones(3, 1)*b_P_init(2,1)^2]);

end

