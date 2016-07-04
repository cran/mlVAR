# STANMODEL <- '
# data {
#   // Number of nodes:
#   int<lower=0> nY;
# 
#   // Number of predictors:
#   int<lower=0> nX;
#   
#   // Maximum number of observations per person:
#   int<lower=0> nSample;
#   
#   // Number of clusters (people):
#   int<lower=0> nCluster;
#   
#   // The data matrix:
#   vector[nY] Y[nSample];
# 
#   // The predictor matrix:
#   vector[nX] X[nSample]; 
# 
#   // The ID vector (linking row in Y to cluster)
#   int<lower=0> ID[nSample];
# 
#   // Number of randoms (intercepts plus slopes):
#   int<lower=0> nRandom;
# 
#   // Index of beta:
#   int<lower=0> Beta_ix[nY,nX];
# }
# 
# parameters {
#   // DF of contemporaneous relationships:
#   real<lower=nY> nu;
#   
#   // Correlation matrix of means:
#   corr_matrix[nRandom] Omega; // prior correlation
#   
#   // Scaling of correlation matrix of means (SD):
#   vector<lower=0>[nRandom] Omega_scale; // prior scale
#   
#   // Fixed effects contemporaneous:
#   cov_matrix[nY] Theta_fixed;
#   
#   // Person-specific contemporaneous covariances:
#   cov_matrix[nY] Theta[nCluster];
# 
#   // Fixed parameters:
#   vector[nRandom] Fixed;
# 
#   // Random parameters per subject:
#   vector[nRandom] Random[nCluster];
# }
# 
# transformed parameters {
#   matrix[nY,nY] identity;
#   vector[nY] zeros;
# 
#   matrix[nY,nX] Beta_fixed;
#   matrix[nY,nX] Beta[nCluster];
# 
#   vector[nY] mu_fixed;
#   vector[nY] mu[nCluster];
#   
#   // Vector of zeroes:
#   zeros <- rep_vector(0, nY);
#   
#   // Identity matrix:
#   identity <- diag_matrix(rep_vector(1.0,nY)); 
# 
#   // Mu and beta:
#   for (i in 1:nY){
#     mu_fixed[i] <- Fixed[i];
#     // Beta:
#     for (j in 1:nX){
#       Beta_fixed[i,j] <- Fixed[Beta_ix[i,j]];
#     }
#   }
# 
#  // Random effects:
#   for (c in 1:nCluster){
#       for (i in 1:nY){
#         mu[c][i] <- Random[c][i];
#         // Beta:
#         for (j in 1:nX){
#             Beta[c][i,j] <- Random[c][Beta_ix[i,j]]; 
#         }
#     }
#   }
# 
# 
# 
# }
# 
# model {
#   // Prior for Omega:
#   Omega_scale ~ cauchy(0,2.5);
#   Omega ~ lkj_corr(2);
#   
#   // Fixed effects:
#   Fixed ~ normal(0, 5);
# 
#   // Random effects:
#   for (c in 1:nCluster){
#     Random[c] ~ multi_normal(Fixed, quad_form_diag(Omega, Omega_scale));
#   }
#   
#   // Prior for contemporaneous fixed:
#   Theta_fixed ~ inv_wishart(nY+1, identity);
#   
#   // Prior for DF of contemporaneous:
#   nu ~ uniform(nY + 1, nY * 1000);
#   
#   for (c in 1:nCluster){
#     // Distribution of person specific contemporaneous:
#     Theta[c] ~ inv_wishart(nu, Theta_fixed);
#   }
# 
#   // Likelihood:
#   for (t in 1:nSample){
#         Y[t] ~ multi_normal(mu[ID[t]] + Beta[ID[t]] * X[t], Theta[ID[t]]);
#   }
# }
# '