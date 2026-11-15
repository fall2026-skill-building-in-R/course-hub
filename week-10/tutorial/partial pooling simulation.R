set.seed(316)  # Reproduce the same simulated data each time

# Set the true values used to simulate the data.
n_groups <- 25  # Number of groups
N <- 20         # Number of observations per group
alpha <- 0.2    # Common intercept for all groups
mu_beta <- 0.7  # Mean of the distribution of group slopes
sd_beta <- 0.4  # How much the true slopes vary among groups
sigma <- 2      # How much observations scatter around their group's line

# Draw one true slope for each group.
betas <- rnorm(n_groups, mean = mu_beta, sd = sd_beta)

# Give every group the same 20 predictor values.
x <- rnorm(N)

# Create one row per observation. Each group uses its own true slope.
d <- data.frame(
  group = factor(rep(seq_len(n_groups), each = N)),
  x = rep(x, times = n_groups),
  beta = rep(betas, each = N)
)

# Calculate the expected response on each group's line, then add noise.
d$expected_y <- alpha + d$beta * d$x
d$y <- rnorm(nrow(d), mean = d$expected_y, sd = sigma)

# Optional: look at the data for each group before fitting the models.
# ggplot2::ggplot(d, ggplot2::aes(x, y)) +
#   ggplot2::geom_point() +
#   ggplot2::facet_wrap(~ group)

# NO POOLING
# Fit a separate regression to each group. Each regression estimates its
# own intercept and slope using only observations from that group.
separate_slopes <- sapply(split(d, d$group), function(group_data) {
  model <- lm(y ~ x, data = group_data)
  coef(model)[["x"]]
})

# PARTIAL POOLING
# The fixed effect x estimates the overall slope.
# (0 + x | group) lets each group have a slope adjustment.
# The 0 applies inside the random-effects term. The model still has
# a shared fixed intercept.
m <- lme4::lmer(y ~ x + (0 + x | group), data = d)

# coef() adds each group's slope adjustment to the overall slope.
# Match the groups explicitly so each line connects the same group.
group_ids <- names(separate_slopes)
mixed_slopes <- coef(m)$group[group_ids, "x"]
true_slopes <- betas[as.integer(group_ids)]

# Give each group the same small horizontal offset in all three columns.
offset <- runif(n_groups, min = -0.10, max = 0.10)

plot(
  1 + offset, separate_slopes,
  xlim = c(0.8, 3.2),
  ylim = range(separate_slopes, mixed_slopes, true_slopes),
  xaxt = "n", xlab = "", ylab = "Slope",
  pch = 19
)

axis(1, at = 1:3, labels = c("Separate models", "Mixed model", "True slopes"))

# The dashed line shows the estimated overall slope in the mixed model.
abline(h = lme4::fixef(m)[["x"]], lty = 2, col = "grey50")

# Connect the two estimated slopes for each group.
segments(1 + offset, separate_slopes, 2 + offset, mixed_slopes, col = "grey65")
points(2 + offset, mixed_slopes, pch = 19)
points(3 + offset, true_slopes, pch = 19, col = "red")