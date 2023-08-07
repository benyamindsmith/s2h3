# s2h3  <a href='https://github.com/benyamindsmith/s2h3'><img src='https://github.com/benyamindsmith/s2h3/blob/main/logo.png' align="right" height="300" /></a>

A R package for simultaneous usage of Google's s2 and Uber's h3 frameworks.

# Installing this package

```r
# install.packages("devtools")
devtools::install_github("benyamindsmith/s2h3")
```

# Usage

```r
library(s2h3)
# Get s2 and h3 grid IDs at varying specified resolutions
sf_trees <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-28/sf_trees.csv') %>%
 filter(!is.na(latitude) | !is.na(longitude)) %>%
  s2h3(longitude,
       latitude,
       s2_level = 21,
       h3_resolution = 10)
```
# Blog Posts

(Coming Soon)


