# Week 5: Extra practice - Data wrangling challenges
# Estimated time: 30 minutes
# For students who finish the main exercises early.
#
# Instructions:
# - This is a separate script; it does not need objects from the main exercises.
# - Use the supplied fictional survey data.
# - Write code and requested explanations below each question.
# - Keep descriptive object names and use readable pipelines.
# - Run the completed script from top to bottom.
#
# The examples are fictional and intended only for coding practice.
# Each survey_data row represents one sampled shark.
# length_cm is body length in centimeters; mass_kg is body mass in kilograms.
# Sampling times below are local times in America/New_York.

library(tidyverse)
library(lubridate)

survey_data <- tibble(
  sample_id = c(
    "DE-001", "DE-002", "NJ-003", "NJ-004", "MD-005", "MD-006",
    "DE-007", "NJ-008", "DE-009", "NJ-010", "MD-011", "MD-012"
  ),
  site_id = c("A", "A", "B", "B", "C", "C", "A", "B", "A", "B", "C", "C"),
  species = c(
    " sandbar shark ", "SANDBAR SHARK", "Blacktip Shark ", "BLACKTIP SHARK",
    " lemon shark", "LEMON SHARK ", "Sandbar Shark ", " blacktip shark ",
    "SANDBAR SHARK", "Blacktip Shark", " Lemon Shark ", "LEMON SHARK"
  ),
  datetime = c(
    "2026-06-01 08:15:00", "2026-06-01 13:30:00",
    "2026-06-10 19:45:00", "2026-07-02 10:15:00",
    "2026-07-12 15:30:00", "2026-07-20 21:10:00",
    "2026-06-08 09:00:00", "2026-06-18 11:45:00",
    "2026-07-05 14:00:00", "2026-07-05 16:20:00",
    "2026-06-12 10:30:00", "2026-06-12 14:45:00"
  ),
  length_cm = c(135, 165, 120, 155, 145, 175, 140, 125, 160, 150, 150, NA),
  mass_kg = c(12, 20, 10, 17, 15, 25, 13, 11, 19, 16, 18, NA)
)

# Each row of site_lookup describes one site.
# It deliberately contains an unused site and omits an observed site.
site_lookup <- tibble(
  site_id = c("A", "B", "D"),
  site_name = c("Cape Henlopen", "Sandy Hook", "Practice Site")
)

# ============================================================
# 1. Clean text and decode IDs (about 5 minutes)
# ============================================================

# Starting with survey_data, create survey_clean in one pipeline:
# - standardize species names by removing surrounding spaces and using title case;
# - create state from the first two characters of sample_id;
# - extract the digits from sample_id into sample_number using a regex.
# Keep the original sample_id.
#
# Then create de_nj_samples containing only IDs beginning with DE or NJ.
# Use a regex that checks the beginning of the ID for both alternatives.
#
# In comments, explain why cleaning names matters before grouping by species,
# and whether sample_number is numeric or character.

# Solution:

survey_clean <- survey_data |>
  mutate(
    species = str_to_title(str_trim(species)),
    state = str_sub(sample_id, 1, 2),
    sample_number = str_extract(sample_id, "[0-9]+")
  )
survey_clean

de_nj_samples <- survey_clean |>
  filter(str_detect(sample_id, "^DE|^NJ"))
de_nj_samples

# Differences in spaces and capitalization could split one species into
# several apparent groups. Cleaning gives exactly three species groups.
# sample_number is character: str_extract() returns text, preserving zeros.
# de_nj_samples has 8 rows; the four MD IDs are excluded.
# Both ^DE and ^NJ are anchored to the start of the string.


# ============================================================
# 2. Categories and multiple summaries (about 7 minutes)
# ============================================================

# Starting with survey_clean, create survey_categories with length_class:
# - "large" for length_cm >= 150;
# - "small" for length_cm < 150;
# - NA when length_cm is missing.
# Set its factor levels in the order small, large.
#
# Then create species_summary containing the mean and standard deviation
# of length_cm and mass_kg for each species. Use across() with a named list
# of functions, ignore missing values, and give the columns descriptive names.
#
# Check the length_class counts. In comments, state which category contains
# a shark exactly 150 cm long and explain what happens to the missing length.

# Solution:

survey_categories <- survey_clean |>
  mutate(
    length_class = case_when(
      length_cm >= 150 ~ "large",
      length_cm < 150 ~ "small",
      .default = NA_character_
    ),
    length_class = factor(length_class, levels = c("small", "large"))
  )
levels(survey_categories$length_class)
count(survey_categories, length_class)

species_summary <- survey_categories |>
  group_by(species) |>
  summarise(
    across(
      c(length_cm, mass_kg),
      list(
        mean = ~ mean(.x, na.rm = TRUE),
        sd = ~ sd(.x, na.rm = TRUE)
      ),
      .names = "{.fn}_{.col}"
    )
  )
species_summary

# Counts: small = 5, large = 6, NA = 1.
# Exactly 150 cm belongs to large because the condition uses >=.
# The missing length stays unclassified (NA), rather than becoming small.
# Species means (length in cm, mass in kg):
# Blacktip Shark: 137.5 cm, 13.5 kg.
# Lemon Shark: approximately 156.67 cm, 19.33 kg (three measured sharks).
# Sandbar Shark: 150 cm, 16 kg.


# ============================================================
# 3. Investigate join matches (about 7 minutes)
# ============================================================

# Use survey_categories and site_lookup for three tasks:
# a. Add site_name to every shark record; save as survey_sites.
# b. Keep only lookup entries whose site_id occurs in the survey;
#    save as sites_used.
# c. Identify observed site IDs absent from site_lookup, returning each
#    unmatched ID only once; save as sites_without_lookup.
#
# Use an appropriate join for each task and specify its key with join_by().
# For a and c, start with survey_categories. For b, start with site_lookup.
#
# In comments, identify the primary and foreign keys. Explain why one site
# is missing from sites_used and why some survey_sites rows have NA site_name.

# Solution:

survey_sites <- survey_categories |>
  left_join(site_lookup, join_by(site_id))
survey_sites

sites_used <- site_lookup |>
  semi_join(survey_categories, join_by(site_id))
sites_used

sites_without_lookup <- survey_categories |>
  anti_join(site_lookup, join_by(site_id)) |>
  distinct(site_id)
sites_without_lookup

# Primary key: site_lookup$site_id, which uniquely identifies a lookup row.
# Foreign key: survey_categories$site_id, which repeats for sampled sharks.
# survey_sites retains 12 rows. Four C records have NA site_name because C
# has no matching lookup row. The unique lookup keys prevent extra rows.
# sites_used contains A and B. D has no matching survey records.
# sites_without_lookup contains one row: C.
# The filtering joins do not add columns from the other table.


# ============================================================
# 4. Dates and an afternoon summary (about 6 minutes)
# ============================================================

# Starting with survey_sites, parse datetime and create labelled month
# and numeric hour columns. Save as survey_times.
#
# In one pipeline, keep records sampled at or after 12:00 noon and count
# them by month and species. Save as afternoon_counts.
#
# In comments, state how many afternoon/evening records remain in total.
# Does the record with missing length still contribute to these counts? Why?

# Solution:

survey_times <- survey_sites |>
  mutate(
    datetime = ymd_hms(datetime, tz = "America/New_York"),
    month = month(datetime, label = TRUE),
    hour = hour(datetime)
  )

afternoon_counts <- survey_times |>
  filter(hour >= 12) |>
  count(month, species)
afternoon_counts

# Seven records remain.
# June: Blacktip Shark = 1, Lemon Shark = 1, Sandbar Shark = 1.
# July: Blacktip Shark = 1, Lemon Shark = 2, Sandbar Shark = 1.
# MD-012 has missing length but a valid time (14:45), so it is counted.
# This pipeline counts sampling records and does not filter on length.


# ============================================================
# 5. Count rows or count sharks? (about 5 minutes)
# ============================================================

# Run the supplied code below to create size_counts.
# Each row now represents a species-length_class combination.
#
# Starting with size_counts, calculate the total number of sharks represented
# for each species; save as species_totals. Use count() with an appropriate wt.
# Also run count(species) on size_counts without a weight.
#
# In comments, explain why those outputs differ and why the unweighted count
# is larger for Lemon Shark than for the other species. Include missing
# length_class in the totals; do not drop it.

# Solution:

size_counts <- survey_categories |>
  count(species, length_class, name = "n_sharks")
size_counts

species_totals <- size_counts |>
  count(species, wt = n_sharks)
species_totals

size_counts |>
  count(species)

# Weighted totals: 4 sharks for each species, including the unmeasured shark.
# Without wt, count() counts summarized rows rather than individual sharks.
# Unweighted counts: Blacktip Shark = 2, Lemon Shark = 3, Sandbar Shark = 2.
# Lemon Shark has small, large, and NA length_class groups; the other species
# have only small and large groups. The NA group still represents a shark.


# Final check: run the entire script and check your written explanations.
