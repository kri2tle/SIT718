################################# 
# SIT718 Assessment 2 - White Wine Quality Analysis
# This script analyzes white wine quality based on physicochemical properties
# Student: Krishna Chaudhari
# Student ID: s223751702
# Student Email: s223751702@deakin.edu.au
# Date: August 2025
#################################

#############################################################################################
# References 
# [1] P. Cortez, A. Cerdeira, F. Almeida, T. Matos and J. Reis. Modeling wine preferences 
#     by data mining from physicochemical properties. In Decision Support Systems, Elsevier, 
#     47(4):547-553, 2009.
#############################################################################################

# Clear workspace and set working directory
rm(list = ls())
cat("Starting White Wine Quality Analysis...\n")

##################################
# Question 1 - Understand the Data
##################################

cat("\n=== Question 1: Understanding the Data ===\n")

# (i) Import the CSV file and save it to R working directory
cat("Importing WhiteWine.csv data...\n")
data.raw <- as.matrix(read.csv("WhiteWine.csv", sep=","))

# Display basic information about the dataset
cat("Dataset dimensions:", dim(data.raw), "\n")
cat("First few rows of data:\n")
print(head(data.raw))

# (ii) Assign the data to a matrix (already done above)
# data.raw is now our matrix

# (iii) Generate a subset of 1500 data points
cat("\nGenerating subset of 1500 samples...\n")
set.seed(223751702) # Using student ID s223751702 for reproducible sampling
data.subset <- data.raw[sample(1:4897, 1500), c(1:7)]

# Verify subset dimensions
cat("Subset dimensions:", dim(data.subset), "\n")

# (iv) Create variable names for better understanding
data.variable.names <- c("fixed acidity", "volatile acidity", "residual sugar", 
                        "free sulfur dioxide", "total sulfur dioxide", "alcohol", "quality")

# Create scatter plots for each X variable against Y (quality)
cat("\nCreating scatter plots to understand relationships...\n")

# Set up plotting parameters
par(mfrow = c(2, 3)) # 2 rows, 3 columns for 6 plots

for(i in 1:6) {
  plot(data.subset[, i], data.subset[, 7], 
       xlab = data.variable.names[i], 
       ylab = "Quality", 
       main = paste("Quality vs", data.variable.names[i]),
       pch = 16, col = "steelblue", cex = 0.6)
  # Add trend line
  abline(lm(data.subset[, 7] ~ data.subset[, i]), col = "red", lwd = 2)
}

# Create histograms for each variable
cat("Creating histograms for all variables...\n")
par(mfrow = c(2, 4)) # 2 rows, 4 columns for 7 plots

for(i in 1:7) {
  hist(data.subset[, i], 
       main = paste("Distribution of", data.variable.names[i]),
       xlab = data.variable.names[i],
       col = "lightblue", border = "black")
}

# Reset plotting parameters
par(mfrow = c(1, 1))

# Display summary statistics
cat("\nSummary statistics for the subset:\n")
summary_stats <- summary(data.subset)
print(summary_stats)

################################
# Question 2 - Transform the Data
################################

cat("\n=== Question 2: Data Transformation ===\n")

# Choose four variables for transformation (X1, X2, X3, X6 - excluding X4, X5)
# These seem to have more direct relationships with quality based on domain knowledge
cat("Selecting variables X1 (fixed acidity), X2 (volatile acidity), X3 (residual sugar), and X6 (alcohol) for transformation\n")

I <- c(1, 2, 3, 6, 7) # Indices for the chosen variables + quality
variables_for_transform <- data.subset[, I]

cat("Selected variables dimensions:", dim(variables_for_transform), "\n")

# Initialize transformed data matrix
data.transformed <- matrix(0, nrow = 1500, ncol = 5)

# Transform each variable individually
cat("\nApplying transformations to each variable...\n")

# Variable 1 (fixed acidity) - log transformation (often works well for acidity)
cat("Transforming X1 (fixed acidity) with log transformation...\n")
data.transformed[, 1] <- log(variables_for_transform[, 1])

# Variable 2 (volatile acidity) - square root transformation (reduces skewness)
cat("Transforming X2 (volatile acidity) with square root transformation...\n")
data.transformed[, 2] <- sqrt(variables_for_transform[, 2])

# Variable 3 (residual sugar) - log transformation (sugar often has exponential distribution)
cat("Transforming X3 (residual sugar) with log transformation...\n")
data.transformed[, 3] <- log(variables_for_transform[, 3] + 1) # +1 to avoid log(0)

# Variable 4 (alcohol) - power transformation p=0.5 (reduces skewness)
cat("Transforming X6 (alcohol) with power transformation p=0.5...\n")
data.transformed[, 4] <- variables_for_transform[, 4]^0.5

# Variable 5 (quality) - no transformation needed, but we'll normalize
cat("Preparing quality variable for normalization...\n")
data.transformed[, 5] <- variables_for_transform[, 5]

# Apply min-max normalization to all transformed variables
cat("\nApplying min-max normalization to all variables...\n")

minmax <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}

for(i in 1:5) {
  data.transformed[, i] <- minmax(data.transformed[, i])
  cat("Variable", i, "normalized. Range:", range(data.transformed[, i]), "\n")
}

# Save transformed data
cat("\nSaving transformed data...\n")
write.table(data.transformed, "krishna-chaudhari-transformed.txt", row.names = FALSE, col.names = FALSE)

cat("Transformation complete! Data saved to 'krishna-chaudhari-transformed.txt'\n")

##########################################
# Question 3 - Build Models and Investigate
##########################################

cat("\n=== Question 3: Building Models ===\n")

# Import AggWaFit718.R file
cat("Loading AggWaFit718.R...\n")
source("AggWaFit718.R")

# Read the saved transformed data
cat("Reading transformed data...\n")
data.transformed_copy <- as.matrix(read.table("krishna-chaudhari-transformed.txt"))

# Verify data structure
cat("Transformed data dimensions:", dim(data.transformed_copy), "\n")

# (i) Get weights for Weighted Arithmetic Mean (WAM)
cat("\n--- Fitting Weighted Arithmetic Mean (WAM) ---\n")
wam_result <- fit.QAM(data.transformed_copy, "krishna-chaudhari-wam-output.txt", "krishna-chaudhari-wam-stats.txt")
cat("WAM fitting completed. Check output files for results.\n")

# (ii) Get weights for Power Mean p=0.5
cat("\n--- Fitting Power Mean p=0.5 ---\n")
pm05_result <- fit.QAM(data.transformed_copy, "krishna-chaudhari-pm05-output.txt", "krishna-chaudhari-pm05-stats.txt", g = PM05, g.inv = invPM05)
cat("Power Mean p=0.5 fitting completed.\n")

# (iii) Get weights for Power Mean p=2
cat("\n--- Fitting Power Mean p=2 ---\n")
pm2_result <- fit.QAM(data.transformed_copy, "krishna-chaudhari-pm2-output.txt", "krishna-chaudhari-pm2-stats.txt", g = QM, g.inv = invQM)
cat("Power Mean p=2 fitting completed.\n")

# (iv) Get weights for Ordered Weighted Average (OWA)
cat("\n--- Fitting Ordered Weighted Average (OWA) ---\n")
owa_result <- fit.OWA(data.transformed_copy, "krishna-chaudhari-owa-output.txt", "krishna-chaudhari-owa-stats.txt")
cat("OWA fitting completed.\n")

cat("\nAll models have been fitted! Check the output files for detailed results.\n")

#######################################
# Question 4 - Use Model for Prediction
#######################################

cat("\n=== Question 4: Making Predictions ===\n")

# New input values
new_input <- c(6.7, 0.18, 4.7, 57, 161, 10.5)
cat("New input values:", new_input, "\n")

# Select the same four variables as in Question 2
new_input_for_transform <- new_input[c(1, 2, 3, 6)] # X1, X2, X3, X6
cat("Selected variables for transformation:", new_input_for_transform, "\n")

# Apply the same transformations as in Question 2
cat("\nApplying transformations to new input...\n")

# Transform X1 (fixed acidity) - log
transformed_x1 <- log(new_input_for_transform[1])

# Transform X2 (volatile acidity) - square root
transformed_x2 <- sqrt(new_input_for_transform[2])

# Transform X3 (residual sugar) - log
transformed_x3 <- log(new_input_for_transform[3] + 1)

# Transform X6 (alcohol) - power 0.5
transformed_x6 <- new_input_for_transform[4]^0.5

# Combine transformed values
transformed_new_input <- c(transformed_x1, transformed_x2, transformed_x3, transformed_x6)

cat("Transformed values:", transformed_new_input, "\n")

# Now we need to normalize these values using the same min-max parameters from our training data
# For this, we'll need to read the original transformed data to get the min/max values

# Read the original data to get normalization parameters
original_data <- data.subset[, c(1, 2, 3, 6)]

# Calculate min and max for each variable
mins <- apply(original_data, 2, min)
maxs <- apply(original_data, 2, max)

# Normalize the new transformed input
normalized_new_input <- numeric(4)
for(i in 1:4) {
  normalized_new_input[i] <- (transformed_new_input[i] - mins[i]) / (maxs[i] - mins[i])
}

cat("Normalized transformed values:", normalized_new_input, "\n")

# For prediction, we'll use the best model from Question 3
# Based on typical results, WAM often performs well, so we'll use that
cat("\nUsing WAM model for prediction...\n")

# Read the WAM weights from the output file
wam_weights <- read.table("krishna-chaudhari-wam-output.txt", header = FALSE)
cat("WAM weights loaded:", wam_weights, "\n")

# Make prediction using WAM
prediction <- sum(normalized_new_input * wam_weights[1:4, 1])
cat("Predicted normalized quality:", prediction, "\n")

# Reverse the transformation to get quality in original scale
# First, denormalize
denorm_prediction <- prediction * (max(data.subset[, 7]) - min(data.subset[, 7])) + min(data.subset[, 7])

# Round to nearest integer (quality scores are integers)
final_prediction <- round(denorm_prediction)

cat("\n=== Final Results ===\n")
cat("Predicted wine quality:", final_prediction, "/10\n")
cat("This prediction is based on the WAM model using the transformed physicochemical properties.\n")

cat("\n=== Analysis Complete ===\n")
cat("All tasks have been completed successfully!\n")
cat("Check the output files for detailed model results and statistics.\n")

