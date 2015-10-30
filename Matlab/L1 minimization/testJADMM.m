% Test Jacobi ADMM for solving BP
clc;clear;
seed = 2012;
addpath('l1testpack');
fprintf('Seed = %d\n',seed);
RandStream.setGlobalStream(RandStream('mt19937ar','seed',seed));

%% generate random matrix data
m = 1500;  % number of measurements
n = 2.5 * m; % solution length
k = 0.05*n;   % sparsity

sigma = 0*1e-3;
A = randn(m,n);
xs = zeros(n,1); % ground truth
p = randperm(n);
xs(p(1:k)) = randn(k,1);
b = A*xs + sigma*randn(m,1);

maxit = 400;
tol = -1; %max(5e-8,0.1*sigma);
N = 1;

idx = cell(N,1);
for i=1:N 
    % indices of i-th block
    idx{i}= (i-1)*n/N+1:i*n/N;
end


%% set parameters
opts0.rho = 10/norm(b,1);
opts0.gamma = 1;
opts0.maxit = maxit;
opts0.tol = tol;
opts0.tau = (0.1*N*opts0.rho)*ones(N,1);
opts0.record = false;
opts0.xTrue = xs;

%% Run Jacobi ADMM
[x,~,out] = BP_ProxJADMM(A,b,idx,opts0);

%% Plot the relative error
figure(1);
semilogy(out.relerr);
xlabel('number of iterations');
ylabel('||x^k - x^*|| / ||x^*||');