%% Activation functions used in neural network
%
% p.f{1} = @(x)(x);                     % Linear
% p.f{2} = @(x)tanh(x);                 % Hyperbolic Tangent
% p.f{3} = @(x)1./(1+exp(-4.9*x));      % Unsigned higher slope sigmoid
% p.f{4} = @(x)exp(-(x-0).^2/(2*1^2));  % Gausian with mean 0 and sigma 1
% p.f{5} = @(x)(x>0);                   % Step Function
% p.f{6} = @(x)(0.05 + tanh(x)   + -0.1.*sin(7.*x) + -0.05.*cos(3.*x) );    % Modified Dolinsky
% p.f{7} = @(x)(0.05 + p.f{3}(x) + -0.1.*sin(7.*x) + -0.05.*cos(3.*x) );    % Unsigned Higher Slope Dolinsky
% p.activate = @(x,y)p.f{y}(x);
%
%
% To view all activation functions run the following:
%
% activationFunctions;
% x = linspace(-2.5,2.5,1000);
% plot(x,p.f{1}(x),x,p.f{2}(x),x,p.f{3}(x),x,p.f{4}(x),x,p.f{5}(x),x,p.f{6}(x),x,p.f{7}(x))
% axis equal
% axis([-2.5 2.5 -1.5 1.5])
% grid on
%
%

p.f{1} = @(x)(x);                     % Linear
p.f{2} = @(x)tanh(x);                 % Hyperbolic Tangent
p.f{3} = @(x)1./(1+exp(-4.9*x));      % Unsigned higher slope sigmoid
p.f{4} = @(x)exp(-(x-0).^2/(2*1^2));  % Gausian with mean 0 and sigma 1
p.f{5} = @(x)(x>0);                   % Step Function
p.f{6} = @(x)(0.05 + tanh(x) + -0.1.*sin(7.*x) + -0.05.*cos(3.*x) );    % Modified Dolinsky
p.f{7} = @(x)(0.05 + p.f{3}(x) + -0.1.*sin(7.*x) + -0.05.*cos(3.*x) );  % Unsigned Higher Slope Dolinsky
p.activate = @(x,y)p.f{y}(x);