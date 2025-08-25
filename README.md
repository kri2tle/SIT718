# SIT718 Assessment 2 - White Wine Quality Analysis

## Student Information
- **Name**: Krishna Chaudhari
- **Student ID**: s223751702
- **Email**: s223751702@deakin.edu.au
- **Course**: SIT718 - Real World Analytics
- **Assessment**: Assessment 2

## Overview
This project analyzes white wine quality based on physicochemical properties using various aggregation functions. The analysis follows a step-by-step approach to understand the data, transform it appropriately, build predictive models, and make quality predictions.

## Files Description
- **`krishna-chaudhari-code.R`** - Main R script containing all the analysis code
- **`WhiteWine.csv`** - Dataset containing white wine physicochemical properties and quality scores
- **`AggWaFit718.R`** - R functions for fitting aggregation functions
- **`README.md`** - This file explaining the project

## Dataset Information
The dataset contains 4,897 white wine samples with the following variables:
- **X1** - Fixed acidity
- **X2** - Volatile acidity  
- **X3** - Residual sugar
- **X4** - Free sulfur dioxide
- **X5** - Total sulfur dioxide
- **X6** - Alcohol
- **Y** - Quality (score between 0 and 10)

## How to Run the Analysis

### Prerequisites
1. Make sure you have R installed on your system
2. Ensure all files are in the same working directory
3. Install required packages if prompted (the script will handle this)

### Running the Script
1. Open R or RStudio
2. Set your working directory to the folder containing these files
3. Run the script: `source("krishna-chaudhari-code.R")`

## What Each Section Does

### Question 1: Understanding the Data
- **Data Import**: Loads the CSV file into R
- **Subset Creation**: Randomly samples 1500 data points for analysis
- **Exploratory Analysis**: Creates scatter plots and histograms to understand relationships
- **Summary Statistics**: Provides basic statistical information about the data

### Question 2: Data Transformation
- **Variable Selection**: Chooses 4 key variables (X1, X2, X3, X6) for transformation
- **Transformations Applied**:
  - X1 (Fixed acidity): Log transformation
  - X2 (Volatile acidity): Square root transformation
  - X3 (Residual sugar): Log transformation (with +1 offset)
  - X6 (Alcohol): Power transformation (p=0.5)
- **Normalization**: Applies min-max normalization to all variables
- **Data Saving**: Saves transformed data to a text file

### Question 3: Model Building
- **Model Fitting**: Fits four different aggregation functions:
  - Weighted Arithmetic Mean (WAM)
  - Power Mean with p=0.5
  - Power Mean with p=2
  - Ordered Weighted Average (OWA)
- **Output Files**: Creates separate output files for each model

### Question 4: Prediction
- **New Input Processing**: Takes the given input values and applies the same transformations
- **Quality Prediction**: Uses the best-fitting model to predict wine quality
- **Result Interpretation**: Converts the prediction back to the original quality scale

## Output Files Generated
- **`krishna-chaudhari-01-transformed.txt`** - Transformed and normalized data
- **`krishna-chaudhari-02-wam-output.txt`** - WAM model results and weights
- **`krishna-chaudhari-03-wam-stats.txt`** - WAM model statistics
- **`krishna-chaudhari-04-pm05-output.txt`** - Power Mean p=0.5 results
- **`krishna-chaudhari-05-pm05-stats.txt`** - Power Mean p=0.5 statistics
- **`krishna-chaudhari-06-pm2-output.txt`** - Power Mean p=2 results
- **`krishna-chaudhari-07-pm2-stats.txt`** - Power Mean p=2 statistics
- **`krishna-chaudhari-08-owa-output.txt`** - OWA model results
- **`krishna-chaudhari-09-owa-stats.txt`** - OWA model statistics

## Key Features
- **Reproducible Results**: Uses set.seed() for consistent sampling
- **Comprehensive Analysis**: Covers all required tasks with clear explanations
- **Professional Output**: Generates publication-ready plots and statistics
- **Error Handling**: Includes basic error checking and informative messages

## Customization
- **Student ID**: The seed value is already set to your student ID (223751702) in line 67
- **Variable Selection**: Modify the `I` vector in line 108 to choose different variables
- **Transformations**: Adjust transformation methods in lines 115-130 based on your analysis
- **File Names**: All output files are already named with your name (krishna-chaudhari-*)

## Troubleshooting
- **Package Issues**: If you get package errors, install them using `install.packages("package_name")`
- **File Paths**: Ensure all files are in the same directory
- **Memory Issues**: The script is optimized for the dataset size, but you can reduce the subset size if needed

## Academic Integrity
This script provides a framework for your analysis. Make sure to:
- Understand each transformation and why it was chosen
- Interpret the results in your own words
- Cite all sources appropriately
- Follow your institution's academic integrity guidelines

## Support
If you encounter issues:
1. Check that all files are present and in the correct location
2. Verify R is properly installed and updated
3. Ensure you have write permissions in the working directory
4. Review the error messages for specific guidance

Good luck with your assessment!
