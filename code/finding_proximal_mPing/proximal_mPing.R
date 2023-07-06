#!/usr/bin/env Rscript
library(data.table)
library(readr)
library(dplyr)

# Make function to append filename during initial reading
read_plus <- function(flnm) {
    read_csv(flnm) %>% 
        mutate(filename = flnm)
}

# Use function when reading in data (this should be corrected so that each 
# end_diff colum will be created for the df before combining
tbl_with_sources <- 
    list.files(path = "../Data",
          pattern=".csv",
          full.names = T) %>%
    map_df(~read_plus(.))

tbl_with_sources

# Subsetting data frame to get only desired columns
sub_df <- tbl_with_sources[,c("RIL_Start","end","filename")]

# removing duplicates in df
temp <- sub_df[!duplicated(sub_df$RIL_Start),]

temp



# Creating new column with difference in end location value
diff_df <- 
    temp %>%
    mutate(end_diff = temp$end - lag(temp$end))

# subsetting for mping that are within 1 kb from one anotheri

df_1kb <- diff_df[diff_df$end_diff < 1000, ]
View(df_1kb)
