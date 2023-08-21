#!/usr/bin/env Rscript
library(data.table)
library(readr)
library(dplyr)
library(purrr)

# Make function to append filename during initial reading
read_plus <- function(flnm) {
    read_csv(flnm) %>% 
        mutate(filename = flnm)
}

# Use function when reading in data (this should be corrected so that each 
# end_diff colum will be created for the df before combining
tbl_with_sources <- 
    list.files(path = ".",
          pattern=".csv",
          full.names = T) %>%
    map_df(~read_plus(.))



# Subsetting data frame to get only desired columns
sub_df <- tbl_with_sources[,c("RIL_Start","end","filename")]

# removing duplicates in df
temp <- sub_df[!duplicated(sub_df$RIL_Start),]

temp



# Creating new column with difference in end location value
diff_df <- 
    temp %>%
    mutate(end_diff = end - lag(end))
#    mutate(end_diff = temp$end - lag(temp$end))

diff_df
# subsetting for mping that are within 1 kb from one another

df_6kb <- diff_df[diff_df$end_diff < 6000, ]

# Remove negative values
df_6kb <- df_6kb %>% filter(end_diff >= 0)
# Save csv
write.csv(df_6kb, "./mPing_within_6kb.csv", row.names=FALSE, quote=FALSE)

