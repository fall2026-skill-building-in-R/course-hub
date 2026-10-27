# ============================================================================
# Multiple regression in R 
#
# The exercises use palmerpenguins::penguins, restricted to Chinstrap penguins.
# Requires tidyverse, broom, and palmerpenguins to be installed.
# ============================================================================

	library(tidyverse)
	library(broom)
	library(palmerpenguins)
	
	theme_set(theme_bw(base_size = 12))

# ----------------------------------------------------------------------------
# 1. Prepare and explore the data
# ----------------------------------------------------------------------------
# Question: How does mean flipper length vary with body mass and sex
# in Chinstrap penguins?
#
# a. Create chinstrap_dat: keep Chinstrap penguins, remove missing values
#    in flipper_length_mm, body_mass_g, bill_depth_mm, and sex, and make
#    female the reference level for sex. Use this sample throughout.


# b. Count the penguins of each sex.

# Answer: 

# c. Plot body mass (x) and flipper length (y), colored by sex.

# d. Describe the relationship and the overlap in body-mass ranges.
	


# ----------------------------------------------------------------------------
# 2. Fit and interpret an additive model 
# ----------------------------------------------------------------------------
# a. Fit an additive model using body mass and sex as predictors.
	


# b. Examine coefficients with 95% confidence intervals.


# c. Interpret each coefficient, including units and what is held constant.

	
# d. Calculate the predicted change for a 100 g increase in body mass.
	


# e. Does the sexmale confidence interval include zero? Interpret it.



# f. What assumption is made about slopes?
	

# ----------------------------------------------------------------------------
# 3. Generate and plot predictions 
# ----------------------------------------------------------------------------
# a. Generate 100 masses within each sex's observed body-mass range.



# b. Generate predicted means and 95% confidence intervals.
	

# c. Plot observations, predictions, and confidence ribbons.


# d. Why are the predicted lines parallel?
	

# e. What do the shaded bands describe?
	

# ----------------------------------------------------------------------------
# 4. Fit and evaluate an interaction model 
# ----------------------------------------------------------------------------
# a. Fit a model that allows the body-mass slope to differ by sex.
	
	

# b. Inspect coefficients and confidence intervals.
	
	
# c. Report the female slope, slope difference, and male slope.
	

# d. Explain the change in the sexmale interpretation.
	

# e. Compare AIC values and calculate the difference.
	

# f. Examine uncertainty in the interaction coefficient.


# g. Which model would you select, and why?
	
# ----------------------------------------------------------------------------
# 5. Examine model diagnostics 
# ----------------------------------------------------------------------------
# Use the additive model for the following diagnostics.
# a. Inspect all four default diagnostic plots.


# b. Obtain fitted values and residuals.


# c. Plot residuals against body mass, colored by sex.
	


# d. Describe any patterns in the residuals, including curvature,
#    changes in spread, or differences between sexes.

# e. Examine the Q-Q plot. Are there substantial departures from the line?


# ----------------------------------------------------------------------------
# 6. Center and standardize numeric predictors 
# ----------------------------------------------------------------------------
# New question: How does mean flipper length vary with body mass and
# bill depth?
#
# a. Fit the model in original units.
	


# b. Center each predictor using its mean.
	


# c. Fit a model with centered predictors.
	


# d. Standardize both predictors: subtract the mean, then divide by SD.
	


# e. Fit a model with standardized predictors.
	


# f. Examine the coefficients from all three models.
#    Interpret the intercept in the centered model and both slopes
#    in the standardized model. Include units and explain what
#    is held constant.
	



# g. Verify that the fitted values are equal across all three models,
# allowing for numerical rounding.
   
# h. Explain what happens to the slopes when you center or
#    standardize the predictors.	

# Optional check of the means, SDs, and fit summaries:
	
	
# i. Would standardizing fix curvature or unequal residual variance?
	

# ============================================================================
# Optional extension if time:
# compare additive and interaction predictions visually
# ============================================================================
# Generate predictions on the same grid and plot models side by side.
	
