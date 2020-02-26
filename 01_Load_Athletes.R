# HEADER ------------------------------------------------------------------
#' PROGRAM NAME: 01_LOAD_ATHLETES
#' PROJECTS: 2020 US TRIALS
#' DESCRIPTIONS: LOAD AND PROCESS 2020 US OLYIPIC TRIALS QUALIFIERS
#' 
#' 
#' PROGRAMMER: LEONARDO PALOMERA
#' DATE: 2/24/2020
#' R VERSION: 3.5.0
#' INPUT FILES
#' OUTPUT FILES
#' SECTION


source("./00_Source.R")

time_conversion <- function(x) {
  hr  <- as.numeric(str_extract(x, "^[0-9]{1,2}")) * 3600
  min <- str_extract(x, "\\:[0-9]{1,2}\\:")
  min <- as.numeric(str_remove_all(min, ":")) * 60
  sec <- as.numeric(str_extract(x, "[0-9]{1,2}$"))
  
  seconds <- hr + min + sec
  return(seconds)
}  

states <- tibble(state_abbr = state.abb, state_name = state.name, 
                 #' LAT, LONG
                 state_lat = state.center$y, 
                 state_long = state.center$x)


quali <- read_csv("../../Input/raw/2020_US_Qualifiers.csv", 
                 col_names = TRUE, col_types = cols(.defualt = 'c')) %>%
  rename_all(~ str_to_lower(.)) %>%
  rename(qualification = `qualification(s)`) %>%
  ungroup()

quali_clean <- quali %>%
  mutate(state = str_extract(athlete, "\\(..\\)"),
         state = str_remove_all(state, "\\(|\\)"),
         athlete = str_remove_all(athlete, ".\\(.*\\)"),
         #' CLEAN QULIFICATIONS
         qualification_clean = str_replace_all(qualification, "\n", "||")) %>%
  #' JOIN IN STATE INFORMATION
  left_join(states, by = c("state" = "state_abbr")) %>%
  separate(qualification_clean, sep = "\\|\\|", into = paste0('race_', letters[1:10])) %>%
  gather(-rank, -athlete, -qualification, -entered, 
         -state, -state_name, - state_lat, -state_long,
         key = "race", value = "info") %>%
  mutate(info_length = str_length(info)) %>%
  filter(info_length > 0 & !is.na(info_length)) %>%
  #' select(-info_length, -race) %>%
  mutate(
    race_time = str_extract(info, "[0-9]{1}:[0-9]{2}:[0-9]{2}"),
    race_date = str_extract(info,"[0-9]{1,2}/[0-9]{1,2}/[0-9]{2}"),
    race_date = mdy(race_date),
    race_info = str_extract(info, "\\(.*\\-")
  ) %>%
  separate(race_info, sep = "-", 
           into = c("race_type", "race"), 
           extra = "merge") %>%
  mutate(race_type = str_remove_all(race_type, "\\("),
         race_type = str_trim(race_type),
         race = str_remove_all(race, "-| $"),
         race = str_trim(race, side = "both")) %>%
  #' CONVERT INFORMATION
  mutate(
    time_sec = time_conversion(race_time)
  ) %>%
  #' RANK TIMES
  mutate(
    half_rank = if_else(race_type == 'Half Marathon', time_sec, NA_real_),
    half_rank = rank(half_rank),
    half_rank = if_else(race_type == 'Half Marathon', half_rank, NA_real_),
    marathon_rank = if_else(race_type == 'Marathon', time_sec, NA_real_),
    marathon_rank = rank(marathon_rank),
    marathon_rank = if_else(race_type == 'Marathon', marathon_rank, NA_real_)
  ) %>%
  #' ADDITIONAL DATA CLEANING ON RACE NAMES
  mutate(race = str_replace_all(race, "HalfMarathon", "Half Marathon"),
         race = str_remove_all(race, "\\'")) %>%
  #' YOU'LL NEED INFORMATION FOR EACH OF THESE MARATHONS
  #' ELEVATION
  #' NET PROFILE
  write_csv("../../Input/rds/01_qualified.rds")

