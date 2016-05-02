% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly executed under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 663.549991986855280 ; 661.127075684521170 ];

%-- Principal point:
cc = [ 311.012312550383910 ; 232.409981488914840 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ -0.290825545757387 ; 0.433660757715739 ; 0.000250245685752 ; -0.000944901838965 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 1.688314229262479 ; 1.826513428681401 ];

%-- Principal point uncertainty:
cc_error = [ 3.132516262477790 ; 2.956640455969292 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.013861521481298 ; 0.058124575038028 ; 0.000809621773338 ; 0.000840586414615 ; 0.000000000000000 ];

%-- Image size:
nx = 640;
ny = 480;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 20;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ 1.646446e+00 ; 1.636930e+00 ; -6.662403e-01 ];
Tc_1  = [ -1.878341e+02 ; -7.082598e+01 ; 8.580977e+02 ];
omc_error_1 = [ 3.800397e-03 ; 4.841375e-03 ; 6.120195e-03 ];
Tc_error_1  = [ 4.072786e+00 ; 3.883222e+00 ; 2.251023e+00 ];

%-- Image #2:
omc_2 = [ 1.840432e+00 ; 1.888020e+00 ; -3.922260e-01 ];
Tc_2  = [ -1.640468e+02 ; -1.480243e+02 ; 7.627049e+02 ];
omc_error_2 = [ 4.091592e-03 ; 4.906879e-03 ; 7.601165e-03 ];
Tc_error_2  = [ 3.638829e+00 ; 3.453123e+00 ; 2.207430e+00 ];

%-- Image #3:
omc_3 = [ 1.735811e+00 ; 2.064530e+00 ; -5.016937e-01 ];
Tc_3  = [ -1.345488e+02 ; -1.631134e+02 ; 7.811620e+02 ];
omc_error_3 = [ 3.758158e-03 ; 5.206696e-03 ; 7.883418e-03 ];
Tc_error_3  = [ 3.722542e+00 ; 3.535346e+00 ; 2.116952e+00 ];

%-- Image #4:
omc_4 = [ 1.826709e+00 ; 2.099654e+00 ; -1.100258e+00 ];
Tc_4  = [ -7.391334e+01 ; -1.433053e+02 ; 7.850663e+02 ];
omc_error_4 = [ 3.318164e-03 ; 5.331932e-03 ; 7.115902e-03 ];
Tc_error_4  = [ 3.739970e+00 ; 3.528529e+00 ; 1.697965e+00 ];

%-- Image #5:
omc_5 = [ 1.067392e+00 ; 1.906671e+00 ; -2.559650e-01 ];
Tc_5  = [ -1.010363e+02 ; -2.180226e+02 ; 7.425408e+02 ];
omc_error_5 = [ 3.212317e-03 ; 4.856136e-03 ; 5.561902e-03 ];
Tc_error_5  = [ 3.571456e+00 ; 3.368309e+00 ; 2.064517e+00 ];

%-- Image #6:
omc_6 = [ -1.710324e+00 ; -1.949313e+00 ; -7.872154e-01 ];
Tc_6  = [ -1.543604e+02 ; -7.295239e+01 ; 4.499714e+02 ];
omc_error_6 = [ 3.150780e-03 ; 4.991004e-03 ; 6.759106e-03 ];
Tc_error_6  = [ 2.146676e+00 ; 2.083401e+00 ; 1.790221e+00 ];

%-- Image #7:
omc_7 = [ 1.975909e+00 ; 1.928755e+00 ; 1.299954e+00 ];
Tc_7  = [ -8.815376e+01 ; -7.106104e+01 ; 4.444635e+02 ];
omc_error_7 = [ 5.753514e-03 ; 3.008988e-03 ; 7.011343e-03 ];
Tc_error_7  = [ 2.155772e+00 ; 2.034201e+00 ; 1.898302e+00 ];

%-- Image #8:
omc_8 = [ 1.940776e+00 ; 1.819246e+00 ; 1.315875e+00 ];
Tc_8  = [ -1.754593e+02 ; -9.643960e+01 ; 4.663611e+02 ];
omc_error_8 = [ 5.438178e-03 ; 3.056990e-03 ; 6.653389e-03 ];
Tc_error_8  = [ 2.378946e+00 ; 2.213706e+00 ; 2.123831e+00 ];

%-- Image #9:
omc_9 = [ -1.374880e+00 ; -1.990151e+00 ; 3.335096e-01 ];
Tc_9  = [ -1.052574e+01 ; -2.140522e+02 ; 7.360110e+02 ];
omc_error_9 = [ 3.838599e-03 ; 4.870421e-03 ; 6.377560e-03 ];
Tc_error_9  = [ 3.521888e+00 ; 3.318605e+00 ; 2.149991e+00 ];

%-- Image #10:
omc_10 = [ -1.523079e+00 ; -2.095457e+00 ; 2.026332e-01 ];
Tc_10  = [ -4.001035e+01 ; -2.872342e+02 ; 8.681690e+02 ];
omc_error_10 = [ 4.706728e-03 ; 5.605148e-03 ; 8.552390e-03 ];
Tc_error_10  = [ 4.231320e+00 ; 3.938745e+00 ; 2.861278e+00 ];

%-- Image #11:
omc_11 = [ -1.806058e+00 ; -2.084413e+00 ; -4.695967e-01 ];
Tc_11  = [ -1.597858e+02 ; -2.251674e+02 ; 7.132067e+02 ];
omc_error_11 = [ 4.368240e-03 ; 5.393564e-03 ; 9.427769e-03 ];
Tc_error_11  = [ 3.479170e+00 ; 3.383129e+00 ; 2.865816e+00 ];

%-- Image #12:
omc_12 = [ -1.850872e+00 ; -2.107270e+00 ; -5.077624e-01 ];
Tc_12  = [ -1.408928e+02 ; -1.683578e+02 ; 6.118811e+02 ];
omc_error_12 = [ 3.742657e-03 ; 5.192525e-03 ; 8.675112e-03 ];
Tc_error_12  = [ 2.960075e+00 ; 2.853925e+00 ; 2.396064e+00 ];

%-- Image #13:
omc_13 = [ -1.930017e+00 ; -2.136974e+00 ; -5.892074e-01 ];
Tc_13  = [ -1.393165e+02 ; -1.354535e+02 ; 5.507244e+02 ];
omc_error_13 = [ 3.508125e-03 ; 5.141261e-03 ; 8.459940e-03 ];
Tc_error_13  = [ 2.656616e+00 ; 2.553481e+00 ; 2.174789e+00 ];

%-- Image #14:
omc_14 = [ -1.965678e+00 ; -2.145967e+00 ; -5.823516e-01 ];
Tc_14  = [ -1.294049e+02 ; -1.298113e+02 ; 4.959169e+02 ];
omc_error_14 = [ 3.276107e-03 ; 4.993421e-03 ; 8.206411e-03 ];
Tc_error_14  = [ 2.398039e+00 ; 2.300424e+00 ; 1.948396e+00 ];

%-- Image #15:
omc_15 = [ -1.945993e+00 ; -2.091806e+00 ; -6.463873e-01 ];
Tc_15  = [ -1.887365e+02 ; -1.195836e+02 ; 4.382791e+02 ];
omc_error_15 = [ 3.347345e-03 ; 4.542167e-03 ; 7.577523e-03 ];
Tc_error_15  = [ 2.133408e+00 ; 2.091001e+00 ; 1.862315e+00 ];

%-- Image #16:
omc_16 = [ 1.877026e+00 ; 2.323101e+00 ; -1.414882e-01 ];
Tc_16  = [ -2.440867e+01 ; -1.599860e+02 ; 6.976653e+02 ];
omc_error_16 = [ 5.038119e-03 ; 5.207149e-03 ; 1.041321e-02 ];
Tc_error_16  = [ 3.321622e+00 ; 3.129299e+00 ; 2.511529e+00 ];

%-- Image #17:
omc_17 = [ -1.623710e+00 ; -1.970979e+00 ; -3.399720e-01 ];
Tc_17  = [ -1.410670e+02 ; -1.316672e+02 ; 4.957988e+02 ];
omc_error_17 = [ 3.161332e-03 ; 4.721990e-03 ; 6.735600e-03 ];
Tc_error_17  = [ 2.372363e+00 ; 2.287724e+00 ; 1.722284e+00 ];

%-- Image #18:
omc_18 = [ -1.354056e+00 ; -1.713502e+00 ; -2.926441e-01 ];
Tc_18  = [ -1.898420e+02 ; -1.510429e+02 ; 4.478065e+02 ];
omc_error_18 = [ 3.542911e-03 ; 4.547537e-03 ; 5.236012e-03 ];
Tc_error_18  = [ 2.163140e+00 ; 2.092903e+00 ; 1.618939e+00 ];

%-- Image #19:
omc_19 = [ -1.931413e+00 ; -1.860655e+00 ; -1.445910e+00 ];
Tc_19  = [ -1.105275e+02 ; -7.461786e+01 ; 3.378108e+02 ];
omc_error_19 = [ 3.080292e-03 ; 5.379626e-03 ; 6.660834e-03 ];
Tc_error_19  = [ 1.678091e+00 ; 1.594924e+00 ; 1.578201e+00 ];

%-- Image #20:
omc_20 = [ 1.875144e+00 ; 1.591017e+00 ; 1.463183e+00 ];
Tc_20  = [ -1.484097e+02 ; -8.191848e+01 ; 3.998354e+02 ];
omc_error_20 = [ 5.503461e-03 ; 3.093013e-03 ; 5.994240e-03 ];
Tc_error_20  = [ 2.065027e+00 ; 1.895295e+00 ; 1.900952e+00 ];

