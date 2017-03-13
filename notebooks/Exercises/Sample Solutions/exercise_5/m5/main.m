close all;

% Generate the measured data from given position 
% of the cell phone and the base stations

MS = [5, 5]; % true position of the cell phone in [km]

K = 3; % Number of equations in the final set of equation
N = K + 1; % Number of base stations available

% Base station positions in [km]
BS = [0, 0; -5, 6; 7, 8; 0, 15];
BS = BS(1:N, :);


%% Calculate the time of flights (TOF)
c = 3 * 10^2; % Propagation speed in [km/ms]
d_true = zeros(N, 1); 
for n = 1:N % True distances between BS_n and MS
    d_true(n, 1) = ...
end
t_true = ... % True propagation delay in [ms];


%% Measurments are true observations corrupted by additive noise
% chose either random noise or given ones
% noise = sqrt(0.00001)*randn(size(t_true));
% noise = sqrt(0.0001)*(rand(size(t_true))-0.5);
noise = [0.0001; 0.003; 0.0014; -0.0004];
noise = noise(1:N);

t_measured = t_true + noise;
d_measured = ...


%% Calculate TDOA based on noisy TOF
% Run time difference with respect to BS 0
Dt_measured_0 = ...


%% Solve the different Least Squares problems
% Base station positions relative to base station 0.
BS_0 = zeros(K, 2);
for k = 1:K
    BS_0(k, :) = BS(k + 1, :) - BS(1, :);
end


%% 1. Time of flight method (TOF)
A = ...
b = ...
a_TOF = ...


%% 2. Time difference of arrival (TDOA)
B = ...
d = ...
w_TDOA = ...
a_TDOA = ...

%% 3. TDOA with Taylor series approximation
a_TDOA_tilde = a_TDOA;
w_tilde = w_TDOA;
num_it = 1000; % Iterations for the Newton algorithm
for i = 1:num_it
    C = [a_TDOA_tilde.' / sqrt(a_TDOA_tilde' * a_TDOA_tilde); eye(2, 2)];
    delta = [sqrt(a_TDOA_tilde' * a_TDOA_tilde); a_TDOA_tilde] - w_tilde;
    
    % Explicit notation of pseudo inverse
    a_TDOA_tilde = ...
        a_TDOA_tilde - 0.5 * inv(C' * B' * B * C) * C' * (B' * B) * delta;
    
    w_tilde = [norm(a_TDOA_tilde); a_TDOA_tilde];
end


%% Compute the error as the difference of the true and the estimated position
e_TOA = sqrt((a_TOF - MS')' * (a_TOF - MS'));
e_TDOA = sqrt((a_TDOA - MS')' * (a_TDOA - MS'));
e_TDOA_tilde = sqrt((a_TDOA_tilde - MS')' * (a_TDOA_tilde - MS'));

disp('       | TOA     | TDOA   | TDOA~   ');
disp('------------------------------------');
disp([ ...
    '   e   | ', ...
    num2str(e_TOA), ' | ', ...
    num2str(e_TDOA), ' | ', ...
    num2str(e_TDOA_tilde)
    ]);


%% Plot the whole scenario
% Calculate display size 
delta = 10;
xmax = max(max(max(BS(:,1)), a_TDOA(1)), a_TOF(1)) + delta;
xmin = min(min(min(BS(:,1)), a_TDOA(1)), a_TOF(1)) - delta;
ymax = max(max(max(BS(:,2)), a_TDOA(2)), a_TOF(2)) + delta;
ymin = min(min(min(BS(:,2)), a_TDOA(2)), a_TOF(2)) - delta;

x_lim = max(abs(xmax),abs(xmin));
y_lim = max(abs(ymax),abs(ymin));
lim = max(y_lim,x_lim);

% The mobile station
h1 = plot(MS(1), MS(2), 'r*');
hold on;

% The base stations
h2 = plot(BS(:,1),BS(:,2), 'k+', 'MarkerSize', 8);
hold on;
for i = 1:N
    text(BS(i, 1), BS(i, 2) - 1, ['BS', num2str(i - 1)], ...
    'EdgeColor', 'magenta', 'BackgroundColor', [1, 1, 1]);
end

for b=1:N
    h3 = CirclePlot(BS(b,:), d_measured(b,1),'b--' );
    hold on;
    if b > 1
        h4 = HyperbelPlot(BS(b, :), BS(1, :), c, ...
            Dt_measured_0(b - 1, 1), [-lim, lim, -lim, lim], 'r--');
    end
end

h5 = plot(a_TOF(1),a_TOF(2), 'gd'); hold on;
h6 = plot(a_TDOA(1),a_TDOA(2), 'go'); hold on;
h0 = plot(a_TDOA_tilde(1), a_TDOA_tilde(2),'gs');
h = [h1, h2, h3, h4, h5, h6, h0];

legend(h, 'True MS position', 'BS positions', ...
      'Points of equal TOF',...
      'Points of equal TDOA',...
      'TOF-estimate', 'TDOA-estimate', 'TDOA~-estimate');
grid on;
axis equal;
