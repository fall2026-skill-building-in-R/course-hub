	# Linear and generalized additive mixed-effects models in R
	#
	# In the tutorial, we modeled log beak height using log wing length and taxon.
	# Here, we model log eelgrass biomass using depth and site. Each row is
	# one quadrat. Depth is already centered at 3 m in the setup below.
	#

	# Load packages for data wrangling, plotting, and fitting GAMMs.
	library(dplyr)
	library(ggplot2)
	library(mgcv)
	
	# Set the seed so everyone simulates the same dataset.
	set.seed(316)
	
	# Simulate one observation per quadrat at 12 eelgrass sites. 
	# All sites span 1–5 m, with different sample sizes. 
	# Create one row per site with its quadrat count and the values used to 
	# create group-level intercepts and slopes. 
	sites <- tibble::tibble(
	  site = factor(sprintf("Site %02d", 1:12)),
	  n_quadrats = c(5, 6, 8, 9, 10, 12, 14, 16, 18, 20, 24, 28),
	  intercept_shift = c(9, -8, 3, 6, -6, 4, -4, 1, 7, -3, -2, -7),
	  slope_shift = c(1, -2, 3, -4, 2, -3, 4, -1, 3, 1, -3, -2)
	)
	
	# Generate one row per quadrat. Depth ranges from 1 to 5 m, so depth_c is zero at 3 m.
	# Add Gaussian noise to the shared curve and site adjustments to simulate log biomass.
	eelgrass <- sites |>
	  group_by(site) |>
	  reframe(
	    depth_m = seq(1, 5, length.out = first(n_quadrats)),
	    depth_c = depth_m - 3,
	    log_biomass = 4.2 + first(intercept_shift) / 20 +
	      (-0.35 + first(slope_shift) / 20) * depth_c +
	      0.16 * depth_c^2 + rnorm(length(depth_c), sd = 0.14),
	    biomass = exp(log_biomass)
	  )
	
	# 1. Plot the data and compare complete pooling and no pooling----------------------------
	
	# Identify the response, predictor, and grouping variable. Make one plot
	# with a line for all quadrats and another with a separate line per site.
	# What does each approach assume about differences among sites?
	
	# SOLUTION
	
	# Count the quadrats per site. Notice which sites have more data to estimate their own lines.
	count(eelgrass, site)
	
	# Color only the points by site. The regression layer fits one line to all quadrats.
	ggplot(eelgrass, aes(depth_m, log_biomass)) +
	  geom_point(aes(colour = site)) +
	  geom_smooth(method = "lm", formula = y ~ x, se = FALSE) +
	  labs(x = "Depth (m)", y = "Log eelgrass biomass")
	
	# Map color to site for both layers. The regression layer fits one line per site.
	ggplot(eelgrass, aes(depth_m, log_biomass, colour = site)) +
	  geom_point() +
	  geom_smooth(method = "lm", formula = y ~ x, se = FALSE) +
	  labs(x = "Depth (m)", y = "Log eelgrass biomass")
	
	# Log biomass is the response, depth in meters is the predictor,
	# and site groups quadrats. A single line uses complete pooling.
	# Separate lines use only each site's own observations.
	
	
	# 2. Fit and interpret a random intercept -----------------------
	
	# Fit one shared depth slope with a random intercept for site.
	# Interpret the overall intercept, depth slope, site SD, and
	# residual SD. What does the random adjustment for Site 01 mean?
	
	# SOLUTION
	
	# Use depth_c for the shared slope and (1 | site) to let each site have its own intercept.
	m_intercept <- lme4::lmer(
	  log_biomass ~ depth_c + (1 | site),
	  data = eelgrass
	)
	
	# Read the fixed coefficients and the two SDs in the model summary.
	summary(m_intercept)
	
	# Compare the overall coefficients, the site adjustments, and the full site-specific coefficients.
	lme4::fixef(m_intercept)
	lme4::ranef(m_intercept)$site
	coef(m_intercept)$site
	
	# The fixed intercept is overall predicted log biomass at 3 m, where
	# depth_c is zero. The slope gives the estimated change in log biomass
	# per 1 m increase. The site SD measures how much the lines shift
	# vertically by group. The residual SD measures how much quadrats vary around their
	# own site's line. Both SDs are in log biomass units.
	# Add Site 01's random adjustment to the fixed intercept to get
	# its fitted intercept. coef() reports the sum directly.
	
	# fixef() gives the coefficients for the overall fitted line.
	# The intercept (4.443) is the predicted log biomass at 3 m,
	# where centered depth is zero. The slope (-0.358) means that
	# for each additional meter of depth, predicted log biomass
	# decreases by 0.358 log units.

	# ranef() gives each site's adjustment to the overall intercept.
	# Site 01's adjustment is +0.369, so its fitted line sits above
	# the overall line. Site 12's adjustment is -0.379, so its line
	# sits below the overall line.

	# coef() gives the full fitted equation for each site.
	# At 3 m, Site 01's predicted log biomass is 4.443 + 0.369 = 4.812.
	# At 3 m, Site 12's predicted log biomass is 4.443 - 0.379 = 4.064.
	# Every site has the same slope (-0.358), so the fitted lines
	# are parallel and the gap between them stays the same with depth.

	# 3. Plot overall and site predictions --------------------
	
	# Use predict() to generate predictions (like the tutorial). 
	# Plot the overall fitted line and the site-specific lines. 
	# Why are the lines parallel? 
	# Check the residuals against fitted values and inspect the Q–Q plot.
	
	# SOLUTION
	
	# Save two predictions for each observed quadrat. The first includes the site adjustment.
	# With re.form = NA, the second uses only the fixed effects.
	eelgrass <- eelgrass |>
	  mutate(
	    fit_intercept = predict(m_intercept),
	    fit_overall = predict(m_intercept, re.form = NA)
	  )
	
	# Overlay the overall line and site lines on the observed data. Compare their heights at 3 m.
	ggplot(eelgrass, aes(depth_m, log_biomass)) +
	  geom_point(aes(colour = site), alpha = 0.5) +
	  geom_line(aes(y = fit_intercept, colour = site)) +
	  geom_line(aes(y = fit_overall), colour = "black") +
	  labs(x = "Depth (m)", y = "Log eelgrass biomass", colour = "Site")
	
	# The black line uses the fixed intercept and shared slope. The colored
	# lines add site intercept adjustments while retaining that slope.
	# Each adjustment uses information from its own site and from the
	# other sites. This is partial pooling.
	
	
	# Check the random-intercept fit before adding slopes, as in the tutorial.
	plot(m_intercept)
	
	# Compare the residual quantiles with the normal reference line. 
	# Look for systematic departures.
	qqnorm(residuals(m_intercept))
	qqline(residuals(m_intercept))
	
	# Residuals vs fitted: residuals tend to be more positive at low and 
	# 	high fitted values and more negative in the middle. 
	# The model tends to predict too low at the ends and too high in the middle.
	# That suggests the shared straight line may be missing curvature.


	# QQ plot: the points depart from the line at both ends. The lower tail sits
	# above the line, and the upper tail bends below it. The residuals
	# are less extreme at the ends than the reference line suggests.
	
	# 4. Fit a random slope and check the fit------------------------
	
	# Fit a model that lets the relationship between eelgrass biomass and depth vary by site 
	# 	(random slope); also include a random intercept. 
	# Compare fitted lines with the random-intercept only model. 
	# Inspect residual spread and the Q–Q plot.
	# Then look for patterns in residuals vs. depth within sites.
	
	# SOLUTION
	
	# Add depth_c inside the random-effects term so each site can also have its own slope.
	m_slopes <- lme4::lmer(
	  log_biomass ~ depth_c + (1 + depth_c | site),
	  data = eelgrass
	)
	
	# Find the site slope SD and check whether the fitted random-effects structure is singular.
	summary(m_slopes)
	# 0.1140 (Std Dev column, random effect of depth_c)
	lme4::isSingular(m_slopes)
	
	# Save the new fitted values and residuals. Each residual is observed minus fitted log biomass.
	eelgrass <- eelgrass |>
	  mutate(
	    fit_slopes = predict(m_slopes),
	    resid_slopes = residuals(m_slopes)
	  )
	
	# Compare the two linear fits within each site. Look for changes in the fit lines.
	ggplot(eelgrass, aes(depth_m, log_biomass)) +
	  geom_point(alpha = 0.5) +
	  geom_line(aes(y = fit_intercept, colour = "Random intercept")) +
	  geom_line(aes(y = fit_slopes, colour = "Random intercept + slope")) +
	  facet_wrap(~ site) +
	  labs(x = "Depth (m)", y = "Log eelgrass biomass", colour = NULL)
	
	# Plot residuals against fitted log biomass for all quadrats.
	# Look for a cloud of points centered around the horizontal zero line.
	plot(m_slopes)

	# What we see: Residuals tend to be positive at low and high fitted
	# values and negative in the middle. The center of the cloud changes,
	# suggesting a pattern in the mean that the model has missed.

	# Compare the residual distribution with a normal distribution.
	# qqnorm() draws the points, and qqline() adds the reference line.
	qqnorm(eelgrass$resid_slopes)
	qqline(eelgrass$resid_slopes)

	# What we see: The points bend away from the line at both ends.
	# The smallest residuals sit above the line, and the largest sit
	# below it. The simulated errors are Gaussian, but the residuals
	# also contain the depth pattern that the straight lines missed.

	# Plot residuals against depth separately for each site.
	# Positive means observed log biomass was higher than predicted.
	# Negative means observed log biomass was lower than predicted.
	ggplot(eelgrass, aes(depth_m, resid_slopes)) +
	  geom_point() +
	  geom_hline(yintercept = 0, linetype = "dashed") +
	  facet_wrap(~ site) +
	  labs(x = "Depth (m)", y = "Residual (log units)")

	# What we see: Start with Site 12, which has the most quadrats.
	# The model tends to predict too little biomass at shallow and deep
	# depths and too much in the middle. Look for the same U-shape at
	# Sites 09–11.
	#
	# Random intercepts let each site's line shift, and random slopes
	# let it tilt. The U-shape repeats across sites, so next we'll try
	# a shared smooth of depth that lets the fitted curves bend.
	
	# 5. Fit and check two GAMMs ---------------------------------------------
	# Fit a shared smooth of depth with a random intercept for site.
	# Then fit a second GAMM that also includes a random slope for depth.
	# Plot the fitted curves from both GAMMs within each site.
	#
	# At Site 12, compare residuals from the linear mixed model and the
	# GAMM with random intercepts and slopes. Does the U-shape weaken
	# after adding the smooth?
	#
	# Run k.check() on both GAMMs. Focus on the depth smooth and explain
	# whether the results give you a reason to try a larger k.
	
	# SOLUTION
	
	# Model
	m_gamm_int <- mgcv::gam(
	  log_biomass ~ s(depth_c, k = 5) + s(site, bs = "re"),
	  data = eelgrass,
	  family = gaussian(),
	  method = "REML"
	)
	
	# Add a random slope so each site can also tilt the shared curve.
	m_gamm <- mgcv::gam(
	  log_biomass ~ s(depth_c, k = 5) +
	    s(site, bs = "re") +
	    s(site, depth_c, bs = "re"),
	  data = eelgrass,
	  family = gaussian(),
	  method = "REML"
	)
	
	# Save the fitted log biomass from each GAMM and the residuals from the model with random slopes.
	eelgrass <- eelgrass |>
	  mutate(
	    fit_gamm_int = predict(m_gamm_int, type = "response"),
	    fit_gamm = predict(m_gamm, type = "response"),
	    resid_gamm = residuals(m_gamm, type = "response")
	  )
	
	# Plot both GAMM fits within each site.
	# Look for where adding a slope changes the fitted curve.
	ggplot(eelgrass, aes(depth_m, log_biomass)) +
	  geom_point(alpha = 0.5) +
	  geom_line(aes(y = fit_gamm_int, colour = "Random intercept")) +
	  geom_line(aes(y = fit_gamm, colour = "Random intercept + slope")) +
	  facet_wrap(~ site) +
	  labs(x = "Depth (m)", y = "Log eelgrass biomass", colour = NULL)
	
	# Compare both residual plots using the same axes.
	# Stack the two sets of residuals and keep Site 12, which has the most quadrats.
	
	residual_comparison <- bind_rows(
	  eelgrass |> transmute(site, depth_m, residual = resid_slopes,
	                   model = "Linear mixed model"),
	  eelgrass |> transmute(site, depth_m, residual = resid_gamm,
	                   model = "GAMM")) |>
	  filter(site == "Site 12")
	
	# Use the same axes for both fits. Does the U-shape weaken after adding the smooth?
	ggplot(residual_comparison, aes(depth_m, residual)) +
	  geom_hline(yintercept = 0, linetype = "dashed") +
	  geom_point() +
	  facet_wrap(~ model) +
	  labs(x = "Depth (m)", y = "Residual (log units)")
	
	# Check the basis dimension for the depth smooth in each GAMM.
	mgcv::k.check(m_gamm_int)
	mgcv::k.check(m_gamm)
	
	# Site 12 shows a clear U-shape in the linear mixed model's residuals.
	# The model underpredicts log biomass at shallow and deep depths and
	# overpredicts it in the middle. The GAMM residuals scatter more evenly
	# around zero, with no obvious U-shape. The shared smooth captures
	# curvature, while the site adjustments let each curve shift and tilt.

	# k.check() asks whether k = 5 gives the depth smooth enough flexibility.
	# The maximum EDF is k' = 4. Both smooths use most of that flexibility:
	# EDF = 3.70 for the random-intercept GAMM and 3.86 when slopes also vary.
	# The k-index is 1.17 (p = 0.98) and 0.93 (p = 0.12), respectively.
	# Neither check clearly flags k as too small. Because the EDFs are
	# close to 4, we could try k = 10 and see whether the fits change.
	# The NA values are expected for the site random-effect terms.
	
	# 6. Summarize the results --------------------------------------------------
	# In three sentences, describe how predicted log biomass changes with
	# depth, how the fitted curves differ among sites, and what the Site 12
	# residual plots show about adding a smooth.
	
	# EXAMPLE ANSWER
	# Predicted log biomass generally decreases from shallow to intermediate
	# depths, then rises again at deeper depths.
	# The fitted curves share the same curvature, while site-specific
	# intercepts and slopes let them differ in height and tilt.
	# At Site 12, the linear mixed model's residuals form a U-shape, while
	# the GAMM residuals scatter more evenly around zero across depths.
	
	# Optional if you have time class: refit using nlme -------------------
	
	# Try writing the same random-intercept model with a separate random
	# formula. Compare the fixed coefficients with lme4::fixef(m_intercept).
	#
	# m_intercept_nlme <- nlme::lme(
	#   log_biomass ~ depth_c,
	#   random = ~ 1 | site,
	#   data = eelgrass,
	#   method = "REML"
	# )
	# nlme::fixef(m_intercept_nlme)
	# lme4::fixef(m_intercept)
	#
	# The two sets of fixed coefficients should agree up to rounding.
	
	
	# Optional if you have time class: fit a shared smooth with gamm() -----
	# This uses the tutorial syntax to estimate intercept–slope correlation.
	# Uncomment to run.
	# m_gamm_nlme <- mgcv::gamm(
	#   log_biomass ~ s(depth_c, k = 5),
	#   random = list(site = ~ 1 + depth_c),
	#   data = eelgrass,
	#   method = "REML"
	# )
	# nlme::VarCorr(m_gamm_nlme$lme)
