#' Get data from ONS on England smoking prevalence
#'
#' @description The data from ONS is in wide form and the spreadsheet has many tabs
#' This data extraction relates to the data Table 1. Proportion of cigarette smokers,
#' by sex and age, Great Britain, 1974 to 2019.
#'
#' @return data frame
#' @export
get_ons_smoking <- function() {
  url1 <- "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fhealthandsocialcare%2fdrugusealcoholandsmoking%2fdatasets%2fadultsmokinghabitsingreatbritain%2f2019/adultsmokinghabitsingreatbritain2019final.xls"
  p1f <- withr::local_tempfile(fileext = "xls")

  utils::download.file(url1, p1f, mode = "wb")
  readxl::read_xls(path = p1f, sheet = "Table 1", skip = 5)
}

#' Tidy data from ONS on England smoking prevalence
#'
#' @description Because the column names are split between two rows in this dataset,
#' this function tidies the columns names to merge these data so it reads "Gender Age Band".
#' The dataset remains in wide form.
#'
#' @return data frame
#' @export
tidy_ons_smoking <- function() {

  # Create the age bands and gender labels
  cnames_age <- c(
    "16-24",
    "25-34",
    "35-49",
    "50-59",
    "60 and over",
    "All aged 16 and over"
  )

  cnames_gender <- c(
    "Men",
    "Women",
    "All persons"
  )

  # remove the hyphen as this necessitates the use of back ticks in variable names

  cnames_clean <- stringr::str_remove(cnames_age, "-")

  # remove spaces in the age bands like '60 and over'

  cnames_clean <- stringr::str_replace_all(cnames_clean, stringr::fixed(" "), "")

  # Code to tidy up the spreadsheet but retain the wide form, merges the two
  # headers of sex and age bands together. Keeping the two apart will mean duplication
  # as there are multiple columns for each name (All persons, Women or 16-24, 16-24
  # instead of All person 16-24, Women 16-24).

  clean_data <- get_ons_smoking() %>%
    janitor::clean_names() %>%
    janitor::remove_empty(c("rows", "cols")) %>%
    tidyr::pivot_longer(-all_persons_aged_16_and_over,
      values_to = "values",
      names_to = "names"
    ) %>%
    tidyr::fill(values) %>%
    dplyr::mutate(
      all_persons_aged_16_and_over =
        dplyr::case_when(
          is.na(all_persons_aged_16_and_over) & .$values %in% cnames_age ~ "cname_age",
          is.na(all_persons_aged_16_and_over) & .$values %in% cnames_gender ~ "cname_gender",
          TRUE ~ all_persons_aged_16_and_over
        )
    ) %>%
    dplyr::filter(!stringr::str_detect(all_persons_aged_16_and_over, tolower("weight")))

  #### Take the top two rows to make new column names

  cnames <- clean_data %>%
    dplyr::filter(all_persons_aged_16_and_over == "cname_gender") %>%
    cbind(clean_data %>%
      dplyr::filter(all_persons_aged_16_and_over == "cname_age") %>%
      dplyr::rename(
        age_values = values,
        age_names = names
      )) %>%
    dplyr::select(
      names,
      values,
      age_values
    ) %>%
    tidyr::unite(values, values:age_values, sep = " ") %>%
    dplyr::mutate(
      all_persons_aged_16_and_over = "header",
      values =
        dplyr::case_when(
          stringr::str_detect(.$values, "All persons") == TRUE
          ~ stringr::str_replace(
            .$values, "All persons",
            "Allpersons"
          ),
          # Remove space for later use of separate()
          # which uses space to determine first part of string
          TRUE ~ .$values
        )
    )

  # Put the column names and data back into one table
  one_colname <- clean_data %>%
    dplyr::filter(
      all_persons_aged_16_and_over != "cname_gender",
      all_persons_aged_16_and_over != "cname_age"
    ) %>%
    dplyr::union(cnames) %>%
    tidyr::pivot_wider(
      names_from = names,
      values_from = values
    ) %>%
    janitor::row_to_names(row_number = nrow(.), remove_rows_above = FALSE) %>%
    dplyr::filter(
      stringr::str_length(.$header) <= 8,
      .$header != "Notes"
    ) %>%
    dplyr::mutate(
      header = substring(.$header, 1, 4),
      dplyr::across(tidyselect::vars_select_helpers$where(is.character), as.numeric),
      dplyr::across(tidyselect::vars_select_helpers$where(is.numeric), round, 1)
    )

  return(one_colname)
}
