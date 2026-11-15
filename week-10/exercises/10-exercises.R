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
	

	
	# 2. Fit and interpret a random intercept -----------------------
	
	# Fit one shared depth slope with a random intercept for site.
	# Interpret the overall intercept, depth slope, site SD, and
	# residual SD. What does the random adjustment for Site 01 mean?
	

	
	# 3. Plot overall and site predictions --------------------
	
	# Use predict() to generate predictions (like the tutorial). 
	# Plot the overall fitted line and the site-specific lines. 
	# Why are the lines parallel? 
	# Check the residuals against fitted values and inspect the Q–Q plot.
	

	
	# 4. Fit a random slope and check the fit------------------------
	
	# Fit a model that lets the relationship between eelgrass biomass and depth vary by site 
	# 	(random slope); also include a random intercept. 
	# Compare fitted lines with the random-intercept only model. 
	# Inspect residual spread and the Q–Q plot.
	# Then look for patterns in residuals vs. depth within sites.
	

	
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
	

	# 6. Summarize the results --------------------------------------------------
	# In three sentences, describe how predicted log biomass changes with
	# depth, how the fitted curves differ among sites, and what the Site 12
	# residual plots show about adding a smooth.
	

	# Optional if you have time class: refit using nlme -------------------
	
	# Try writing the same random-intercept model with a separate random
	# formula. Compare the fixed coefficients with lme4::fixef(m_intercept).
	
	
	# Optional if you have time class: fit a shared smooth with gamm() -----
