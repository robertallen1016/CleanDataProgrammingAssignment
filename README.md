# CleanDataProgrammingAssignment
This repository contains my work for the Programming Assignment for the course Getting and Cleaning Data.

run_analysis.R Script

This script utilizes the Samsung Galaxy S datasets from the UCI Machine Learning Repository.

The script is design to take the raw data and clean it in order to do downstream analysis on.

This script requires the dplyr package.  Please install before proceeding.


1.  The script reads in the necessary datasets.
2.  Real column names for the data are applied
3.  The 3 training and test files each are combined into one file.
4.  The two test and training datasets are combined into one file.
5.  A dataset is created containing only the variables regarding the mean and standard deviation.
6.  Variable names are change to easy reading.
7.  A tidy dataset is created of the mean of each variable summarized by subject and activity.
8.  The tidy dataset is exported.
