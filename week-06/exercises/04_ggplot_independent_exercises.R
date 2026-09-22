# Independent Exercises: ggplot2
# Approximately 30 minutes
#
# Goal:
# Practice building, modifying, polishing, and combining ggplot2 figures
# without following a complete worked example.
#
# Suggested timing:
# 1. Build a scatterplot ............ 5 min
# 2. Add groups and facets .......... 5 min
# 3. Show a distribution ........... 5 min
# 4. Polish a figure ............... 6 min
# 5. Combine plots with patchwork .. 6 min
# 6. Save the figure ............... 3 min

# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------

library(tidyverse)
library(palmerpenguins)
library(patchwork)

penguins_plot <- penguins |>
  drop_na(
    species,
    island,
    bill_length_mm,
    bill_depth_mm,
    flipper_length_mm,
    body_mass_g,
    sex
  )


# -----------------------------------------------------------------------------
# Exercise 1: Build a scatterplot
# -----------------------------------------------------------------------------
#
# Create a scatterplot showing the relationship between:
#   x = bill_length_mm
#   y = bill_depth_mm
#
# Requirements:
# - use ggplot()
# - map both variables inside aes()
# - use geom_point()

# Your code here:


# Before moving on, answer in a comment:
# Do you see one clear relationship, or does the pattern look more complicated?
#
# Answer:


# -----------------------------------------------------------------------------
# Exercise 2: Add groups and facets
# -----------------------------------------------------------------------------
#
# Modify your scatterplot so that:
# 1. point color represents species
# 2. the plot is faceted by sex
# 3. all points have alpha = 0.7
#
# Save the finished plot as an object named p_scatter.
#
# Hint: Which instructions describe a variable mapping, and which describe
# a fixed setting?

# Your code here:


# -----------------------------------------------------------------------------
# Exercise 3: Show a distribution
# -----------------------------------------------------------------------------
#
# Create a plot showing the distribution of body_mass_g for each species.
#
# Choose ONE approach:
# - a boxplot
# - a histogram faceted by species
#
# Save the plot as p_mass.

# Your code here:


# Challenge within the exercise:
# - If you used a boxplot, add individual observations with geom_jitter().
# - If you used histograms, choose a sensible binwidth and explain your choice
#   in a comment.

# Optional modification / explanation:


# -----------------------------------------------------------------------------
# Exercise 4: Polish one figure
# -----------------------------------------------------------------------------
#
# Improve p_scatter so that it is understandable to someone who has never
# seen the dataset.
#
# Add:
# - a descriptive title
# - x- and y-axis labels with units
# - a useful legend title
# - one built-in theme such as theme_minimal(), theme_bw(), or theme_classic()
#
# Overwrite p_scatter with the improved version.

# Your code here:


# Display the finished plot:
p_scatter


# -----------------------------------------------------------------------------
# Exercise 5: Combine plots with patchwork
# -----------------------------------------------------------------------------

# Part A
# Put p_scatter and p_mass side by side and save the result as combined_plot.

# Your code here:


# Part B
# Add an overall title with plot_annotation().

# Your code here:


# Part C: quick layout experiment
# Change the layout so that the two plots are stacked vertically instead.

# Your code here:


# Which layout works better for these two plots? Explain in one comment.
#
# Answer:


# -----------------------------------------------------------------------------
# Exercise 6: Save the figure
# -----------------------------------------------------------------------------
#
# Use ggsave() to save combined_plot as a PNG.
#
# Requirements:
# - filename: penguin_exercise_figure.png
# - width: 9 inches
# - height: 5 inches
# - resolution: 300 dpi

# Uncomment and complete the code when ready.

# ggsave(
#   filename = ,
#   plot = ,
#   width = ,
#   height = ,
#   units = "in",
#   dpi =
# )


# -----------------------------------------------------------------------------
# If you finish early: choose ONE challenge
# -----------------------------------------------------------------------------

# Challenge A: a third plot
# Create a third plot showing flipper length by species.
# Add it to your patchwork figure.

# Your code here:


# Challenge B: change the visual encoding
# Return to p_scatter. Instead of faceting by sex, try mapping shape = sex.
# Which version is easier to read?

# Your code here:


# Challenge C: add a trend
# Add geom_smooth() to a scatterplot of flipper length vs. body mass.
# Try:
#
# geom_smooth(method = "lm", se = FALSE)
#
# Decide whether the trend should be fit separately by species or across all
# penguins.

# Your code here:
