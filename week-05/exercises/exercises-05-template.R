	# Exercise: Data Wrangling with dplyr — Part 2
	
	# Estimated time: 30–40 minutes
	
	# Learning goals:
	
	# By the end of this exercise, you should be able to:
	# - apply the same operation to multiple variables with across()
	# - count observations by groups with count()
	# - create categories from logical conditions with case_when()
	# - use keys and joins to combine related data frames
	# - clean and manipulate character strings with {stringr}
	# - use simple regular expressions to identify and extract text patterns
	# - convert and extract information from dates and date-times with {lubridate}
	# - round numeric values with round()
	# - distinguish between log() and log10()
	# - create factors and control the order of factor levels
	# - combine these tools in a data-wrangling pipeline
	
	# Instructions:
	# 1. Write your code below each question.
	# 2. Use descriptive object names written in snake_case.
	# 3. Run your script from top to bottom before you finish.
	# 4. Do not delete the questions or instructions - these will help you later.
	
	# ------------------------------------------------------------
	# Setup
	# ------------------------------------------------------------
	
	library(tidyverse)
	library(palmerpenguins)
	library(nycflights13)
	
	# ============================================================
	# Part 1: across()
	# ============================================================
	
	# 1. For each penguin species, calculate the mean of:
	# bill_length_mm
	# bill_depth_mm
	# flipper_length_mm
	
	# Use across() rather than writing mean() three times.
	
	# Remember to remove missing values.
	

	
	# 2. For each penguin species, calculate BOTH the mean and
	# standard deviation of bill_length_mm and flipper_length_mm.
	
	# Use across() with a named list of functions.
	
	# Name the resulting columns using the pattern:
	# mean_bill_length_mm
	# sd_bill_length_mm
	# mean_flipper_length_mm
	# sd_flipper_length_mm
	
	
	
	# ============================================================
	# Part 2: count()
	# ============================================================
	
	# 3. How many observations are there for each species and island?
	
	# Use count().
	
	
	
	# 4. How many observations are there of male and female Adelie and Gentoo penguins?

	# Write this as one pipeline.
	
	
	
	
	# ============================================================
	# Part 3: case_when()
	# ============================================================
	
	# 5. Create a new variable called flipper_size using these rules:
	
	# flipper_length_mm >= 210               -> "long"
	# flipper_length_mm >= 190 and < 210     -> "medium"
	# flipper_length_mm < 190                -> "short"
	# Save the resulting data frame as penguin_flipper_size.
	
	

	# 6. Starting with penguin_flipper_size, count how many
	# observations fall into each flipper_size category.

	
	
	
	# ============================================================
	# Part 4: joins
	# ============================================================
	
	# We will now use data frames from nycflights13.
	
	# Create a smaller version of flights to make the joins
	# easier to inspect.
	
	
	
	# 7. Add the full airline name from airlines to flights_small.
	#
	# Use left_join(), explicitly specify carrier as the join key using join_by(), and
	# save the result as flights_airlines.
	
	
	
	# 8. Add the destination airport name to each flight in flights_small.
	
	# Hint: if flight$dest == "LAX, left-join() matches that to airports$faa = "LAX" and adds name = "Los Angeles Intl".
	# The new name column tells you which airport each flight was flying to, rather than just giving the 3-letter code.
	
	# The foreign key in flights_small is dest.
	# The primary key in airports is faa.
	#
	# First select only faa and name from airports, then use
	# left_join() with: join_by(dest == faa)
	#
	# Save the result as flights_destinations.
	
	
	
	# 9. Use semi_join() to keep only airports that appear as
	# origin airports in flights_small.
	
	# Match:
	# airports$faa with flights_small$origin
	
	
	
	# 10. Use anti_join() to identify tail numbers in flights_small
	# that do NOT have a matching record in planes.
	#
	# After the join, use distinct() so that each missing tail
	# number appears only once.
	

	
	
	# ============================================================
	# Part 5: strings
	# ============================================================
	
	# Here is a small dataset containing messy character strings:
	

	
	
	# 11. Starting with fish_records:
	# a. remove extra whitespace from species with str_trim()
	# b. convert species names to title case with str_to_title()
	# c. create a new variable called state containing the first
	# two characters of sample_id with str_sub()
	#
	# Save the result as fish_clean.
	

	
	
	# 12. Starting with fish_clean, create a new variable called
	# contains_shark that is TRUE when species contains the word
	# "Shark" and FALSE otherwise.
	
	# Use str_detect().

	
	
	
	# ============================================================
	# Part 6: regular expressions
	# ============================================================
	
	# 13. Which sample IDs begin with either DE or NJ?
	
	# Use str_detect() and a regular expression.
	# Hint: ^ means "beginning of the string" and | means OR
	

	
	# 14. Extract the numeric portion of each sample_id.
	
	# Use str_extract().
	
	# Hint: [0-9]+ means one or more digits.
	

	
	# ============================================================
	# Part 7: dates and times
	# ============================================================
	
	# We will use sampling_times for the following questions:
		
	sampling_times <- tibble(
		sample_id = c("DE-101", "NJ-205", "DE-310"),
		datetime = c(
			"2026-05-15 08:30:00",
			"2026-06-20 14:15:00",
			"2026-07-10 21:45:00"
		)
	)
	
	sampling_times
	
	# 15. Right now, datetime is stored as a character variable.
	#
	# Starting with sampling_times:
	# a. convert datetime to a date-time using ymd_hms()
	# b. create year from datetime
	# c. create month using month() with labels
	# d. create hour from datetime
	
	# Save the result as sampling_times_clean.
	

	
	# 16. From the dataframe below, create a new column called "sample_date" from the separate year, month, and day
	# variables below using make_date().
	
	
	
	
	# ============================================================
	# Part 8: rounding, logarithms, and factors
	# ============================================================
	
	# 17. Calculate the mean body mass of all penguins and round
	# the result to TWO decimal places.
	
	# Hint: You can put round() around mean().
	

	# 18. Run the following two calculations:
	
	log(100)
	
	log10(100)
	
	# Are the results the same?
	
	# In a comment below, write what base each function uses.
	
	# No. log() uses base e (the natural logarithm).
	
	# log10() uses base 10.
	
	# 19. From the following character vector, convert size_class to a factor with the levels in this order:
	# small, medium, and large. Use levels() to check the order.
	
	size_class <- c(
		"medium",
		"small",
		"large",
		"small",
		"medium",
		"large"
	)
	
	# Write code here:
	
	
	
	
	# ============================================================
	# Part 9: Integrated challenge
	# ============================================================
	
	# We will use survey_data for the following questions. 
	
	survey_data <- tibble(
		sample_id = c(
			"DE-001",
			"DE-002",
			"NJ-003",
			"NJ-004",
			"MD-005",
			"MD-006"
		),
		species = c(
			" sandbar shark ",
			"SANDBAR SHARK",
			"Blacktip Shark ",
			"BLACKTIP SHARK",
			" lemon shark",
			"LEMON SHARK "
		),
		datetime = c(
			"2026-06-01 08:15:00",
			"2026-06-03 13:30:00",
			"2026-06-10 19:45:00",
			"2026-07-02 10:15:00",
			"2026-07-12 15:30:00",
			"2026-07-20 21:10:00"
		),
		length_cm = c(
			135,
			165,
			120,
			155,
			145,
			175
		)
	)
	
	survey_data
	
	# 20. Starting with survey_data, write ONE pipeline that:
	# a. removes extra whitespace from species
	# b. converts species names to title case
	# c. converts datetime from character to a date-time
	# d. creates state from the first two characters of sample_id
	# e. creates month from datetime using month(..., label = TRUE)
	# f. creates a variable called size_class using:
	# 	length_cm >= 150 -> "large"
	# 	length_cm < 150  -> "small"
	# g. counts observations by:
	# 	state
	# 	species
	# 	month
	# 	size_class
	
	# Save the final result as survey_summary.
	

	
	
	
	# ------------------------------------------------------------
	# Final check
	# ------------------------------------------------------------
	
	# Run your entire script from top to bottom.
	
	# You should now have practiced:
	# across()
	# count()
	# case_when()
	# left_join()
	# semi_join()
	# anti_join()
	# join_by()
	# str_trim()
	# str_to_title()
	# str_sub()
	# str_detect()
	# str_extract()
	# regular expressions
	# ymd_hms()
	# year()
	# month()
	# hour()
	# make_date()
	# round()
	# log()
	# log10()
	# factor()
	# levels()
	
	# Before finishing, make sure:
	# - all of your code runs without errors
	# - object names are descriptive
	# - you have used correct style and indentation
	# - you understand what each step in your pipelines is doing
	