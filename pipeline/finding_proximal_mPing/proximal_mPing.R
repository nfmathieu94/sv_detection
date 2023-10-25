#!/usr/bin/env Rscript
library(data.table)
library(readr)
library(tidyr)
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
    list.files(path = "../../input/csv_mPing",
          pattern=".csv",
          full.names = T) %>%
    map_df(~read_plus(.))


# Subsetting data frame to get only desired columns
sub_df <- tbl_with_sources[,c("RIL_Start","end","filename")]

# removing duplicates in df
temp <- sub_df[!duplicated(sub_df$RIL_Start),]


# Creating new column with difference in end location value
diff_df <- 
    temp %>%
    mutate(end_diff = end - lag(end))
#    mutate(end_diff = temp$end - lag(temp$end))

# subsetting for mping that are within 10 kb from one another
cutoff_10kb <- 10000
df_cutoff <- diff_df[diff_df$end_diff < cutoff_10kb, ]

# Remove negative values
df_cutoff <- df_cutoff %>% filter(end_diff >= 0)


# Simplifying and cleaning data before saving as a file
# First split first column So we have the chromosome and start position as separate columns
df_cutoff <- separate(df_cutoff, RIL_Start, into = c("Column1", "Column2", "Column3"), sep = "_")
df_cutoff$Chr <- paste(df_cutoff$Column1, df_cutoff$Column2, sep = "_")
colnames(df_cutoff)[colnames(df_cutoff) == "Column3"] <- "Start"
colnames(df_cutoff)[colnames(df_cutoff) == "end"] <- "End"

# Removing temporary columns made when splitting
df_cutoff <- subset(df_cutoff, select = -c(Column1, Column2))

# Reordering columns
df_cutoff <- df_cutoff %>%
  select(Chr, Start, End, end_diff, filename)

# Removing path from file name and only keepin the name of the file
df_cutoff$filename <- sub(".*/", "", df_cutoff$filename)

# Changing accession numbers to chromosome number 
mapping_df <- read.csv("../../input/chrom_nums.txt", header = FALSE)
colnames(mapping_df) <- c("NC", "Chr")
df_cutoff$Chr <- mapping_df$Chr[match(df_cutoff$Chr, mapping_df$NC)]
df_cutoff
# Save csv
write.csv(df_cutoff, "../../results/mPing_within_10kb.csv",  row.names=FALSE, quote=FALSE)

