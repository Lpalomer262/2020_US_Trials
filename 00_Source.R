# HEADER ------------------------------------------------------------------
#' PROGRAM NAME: SOURCE.R
#' PROJECTS: 
#' DESCRIPTIONS: SOURCE
#' 
#' 
#' PROGRAMMER: LEONARDO PALOMERA
#' DATE: 2/24/2020
#' R VERSION: 3.5.0
#' INPUT FILES
#' OUTPUT FILES
#' SECTION

rm(list = ls())
gc(reset = TRUE)

# SOURCE & PACKAGE IMPORT -------------------------------------------------
#' INSTALL PACKAGES
#' install.packages("tidyr")
#' install.packages("dplyr")
#' install.packages("readr")
#' install.packages("ggplot2")
#' install.packages("stringr")
#' install.packages("purrr")
#' install.packages("googlesheets")
#' install.packages("lubeidate")
#' install.packages("ggmap")
#' install.packages("sf)
#' install.packages("mapview")
#' install.packages("httr")
#' install.packages("rjson")
#' install.packages("leaflet")


#' LOAD LIBRARIES
library(tidyr)
library(tibble)
library(forcats)
library(dplyr)
library(readr)
library(ggplot2)
library(stringr)
library(purrr)
library(googlesheets)
library(lubridate)
library(ggmap)
library(geosphere) #' DISTM FUNCTION
library(sf)
library(mapview)
library(tidyverse)
library(knitr)
library(scales)


#' STRAVA LIBRARIES
library(httr)
library(rjson)

#' library(rJava) #' NEED HELP LOADING RJAVA
#' library(OpenStreetMap) #' NEEDS RJAVA TO LOAD
library(leaflet)

#'' #' MESSAGE FROM JENNY BRYAN
#'' #' googlesheets is going away fairly soon (March 2020)! It is not a good idea to write new code that uses it!
#'' install.packages("googlesheets4")
#'' devtools::install_github("tidyverse/googlesheets4")
#'' library(googlesheets4)
#'' 
#'' #' ACCESS TO MY GOOGLE DRIVE
#'' library(googledrive)