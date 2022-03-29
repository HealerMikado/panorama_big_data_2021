# library(readr)
# 
# files <- list.files(path="ncdc_data", pattern="*.gz", full.names=TRUE, recursive=FALSE)
# process_file <- function(file){
#   df <- read_fwf(
#     file,
#     col_positions = fwf_cols(temperature = c(88, 92), quality = c(93, 93)),
#   col_types="nf"
#   )
#   lapply(df[df$quality %in% c("0", "1", "4" ,"5" ,"9") & df$temperature < 9999 , "temperature"], max)
# }
# 
# lapply(files, process_file)
# 


files <- list.files(path="ncdc_data", pattern="*.gz", full.names=TRUE, recursive=FALSE)
process_file <- function(file){
  df <- read.fwf(
    file,
    widths=c(-87,5,1),
    col.names=c("temperature","quality")
  )
  max(df[df$quality %in% c("0", "1", "4" ,"5" ,"9") & df$temperature < 9999 , "temperature"])
}

lapply(files, process_file)


