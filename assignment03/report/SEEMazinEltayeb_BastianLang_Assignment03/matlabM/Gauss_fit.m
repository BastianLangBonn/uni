function output = Gauss_fit(data)
%
    Mu = mean(data);
    display(Mu);
    Sigma = cov(data);
    display(Sigma);
    for sd = [1:3],
        plot_gaussian_ellipsoid(Mu, Sigma, sd);
    end