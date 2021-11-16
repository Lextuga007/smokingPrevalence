
<!-- README.md is generated from README.Rmd. Please edit that file -->

# smokingPrevalence

<!-- badges: start -->
<!-- badges: end -->

The goal of smokingPrevalence is to store functions that are used in
analysis for smoking prevalence including ONS public prevalence
information to compare to.

## Installation

You can install the development version of smokingPrevalence from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Lextuga007/smokingPrevalence")
```

## ONS public smoking prevalence data

The data is released in wide form and the following imports this data as
it appears in the spreadsheet form:

``` r
library(smokingPrevalence)

get_ons_smoking()
#> New names:
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> * `` -> ...6
#> * ...
#> # A tibble: 52 x 21
#>    `All persons age~ ...2  ...3  ...4  ...5  ...6  ...7  ...8  ...9  ...10 ...11
#>    <chr>             <chr> <chr> <chr> <chr> <chr> <chr> <lgl> <chr> <chr> <chr>
#>  1 <NA>              Men   <NA>  <NA>  <NA>  <NA>  <NA>  NA    Women <NA>  <NA> 
#>  2 <NA>              16-24 25-34 35-49 50-59 60 a~ All ~ NA    16-24 25-34 35-49
#>  3 <NA>              <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  NA    <NA>  <NA>  <NA> 
#>  4 Unweighted 1      <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  NA    <NA>  <NA>  <NA> 
#>  5 1974 2 3          47.3~ 55.1~ 55.2~ 52.7~ 44.5  51.3~ NA    41.2~ 46.8~ 49   
#>  6 1976 2 3          42.7~ 48.2~ 50.5  49.8~ 39.7~ 46.2~ NA    40.2~ 42.8~ 45.2~
#>  7 1978 2 3          40.1~ 48.3~ 48    47.7~ 38.2~ 44.5  NA    38.2~ 42.3~ 42.7~
#>  8 1980 2 3          38.2~ 47.2~ 45.3~ 46.7~ 35.6~ 42.3~ NA    36.5  44    42.6~
#>  9 1982 2 3          35.7~ 40.2~ 40.2~ 41.6~ 32.7~ 37.7~ NA    35    36.7~ 37.7~
#> 10 1984 2 3          35    40.2~ 38.6~ 39.3~ 30.3~ 36.2~ NA    34.5  35.7~ 35.7~
#> # ... with 42 more rows, and 10 more variables: ...12 <chr>, ...13 <chr>,
#> #   ...14 <chr>, ...15 <lgl>, ...16 <chr>, ...17 <chr>, ...18 <chr>,
#> #   ...19 <chr>, ...20 <chr>, Percentages <chr>
```

To tidy the data, as in move it to long form and to clean the 2 row
headers to 1:

``` r
library(smokingPrevalence)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(stringr) # cannot knit without - should be ok with dependency?

tidy_ons_smoking()
#> New names:
#> * `` -> ...2
#> * `` -> ...3
#> * `` -> ...4
#> * `` -> ...5
#> * `` -> ...6
#> * ...
#> # A tibble: 33 x 19
#>    header `Men 16-24` `Men 25-34` `Men 35-49` `Men 50-59` `Men 60 and over`
#>     <dbl>       <dbl>       <dbl>       <dbl>       <dbl>             <dbl>
#>  1   1974        47.4        55.1        55.3        52.8              44.5
#>  2   1976        42.8        48.2        50.5        49.9              39.8
#>  3   1978        40.1        48.4        48          47.7              38.3
#>  4   1980        38.3        47.3        45.4        46.7              35.6
#>  5   1982        35.8        40.2        40.2        41.6              32.8
#>  6   1984        35          40.3        38.6        39.4              30.3
#>  7   1986        36.1        36.9        37.4        35.2              28.5
#>  8   1988        33.2        36.9        37          32.5              25.8
#>  9   1990        33.2        36.3        34.3        27.8              24.1
#> 10   1992        34.8        34.3        31.9        28.2              21  
#> # ... with 23 more rows, and 13 more variables: Men All aged 16 and over <dbl>,
#> #   Women 16-24 <dbl>, Women 25-34 <dbl>, Women 35-49 <dbl>, Women 50-59 <dbl>,
#> #   Women 60 and over <dbl>, Women All aged 16 and over <dbl>,
#> #   Allpersons 16-24 <dbl>, Allpersons 25-34 <dbl>, Allpersons 35-49 <dbl>,
#> #   Allpersons 50-59 <dbl>, Allpersons 60 and over <dbl>,
#> #   Allpersons All aged 16 and over <dbl>
```

Reference: The function format of getting data and tidying data was
introduced to the CDU Data Science Team by Milan Wiedemann who [blogged
about
it](https://cdu-data-science-team.github.io/team-blog/posts/2021-08-06-nottshcverse/)
