# Two normal variables:
A <- rnorm(100)
B <- A + rnorm(100)

# Two different regression models:
lm1 <- lm(A ~ B)
lm2 <- lm(B ~ A)

# Coefficient of first regression model:
coef(lm1)[2]

# A scalar:
c <- sigma(lm1)^2 / sigma(lm2)^2

# Scaled coefficient of the second regression model:
c * coef(lm2)[2]

# Exactly the same!