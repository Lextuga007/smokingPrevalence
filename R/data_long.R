#' Tidy ONS data into long form
#'
#' @param add_year Logical, add a column with a real date which is the beginning
#' of the year. Default is to add this column
#' @param rounding Logical, rounding the population values to whole numbers to
#' reduce spurious accuracy. Default is to round to whole number
#' @param separate_cols Logical, separates the previously merged columns of
#' gender and age to separate columns in long form. Default is to separate
#'
#' @return Data frame
#' @export
tidy_smoking_long <- function(add_year = TRUE,
                              rounding = TRUE,
                              separate_cols = TRUE) {
  df <- smokingPrevalence::get_smoking_wide() # default is clean

  df <- df %>%
    tidyr::pivot_longer(
      cols = c(-"header"),
      names_to = "age_bands",
      values_to = "pop_values"
    )


  if (add_year) {
    df <- df %>%
      dplyr::mutate(year = lubridate::ymd(paste0(header, "-01", "-01")))
  }

  if (rounding) {
    df <- df %>%
      dplyr::mutate(pop_values = round(pop_values, 0))
  }

  if (separate_cols) {
    df <- df %>%
      tidyr::separate(age_bands, c("gender", "age"), extra = "merge") %>%
      # remove hyphen and spaces to match cnames_clean
      dplyr::mutate(
        age = stringr::str_remove(age, "-"),
        age = stringr::str_replace_all(age, stringr::fixed(" "), "")
      )
  }

  df
}
