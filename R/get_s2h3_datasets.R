#' Get Corresponding S2 and H3 cells for given longitude and latitude
#'
#' This function is a work in progress!
#'
#' @param data The dataframe or tibble that contains a longitude and latitude field for individual points of interest
#' @param long The longitude field name in `data`
#' @param lat The latitude field name in `data`
#' @param s2_level The desired [s2 level](https://s2geometry.io/resources/s2cell_statistics.html)
#' @param h3_resolution The desired [h3 resolution](https://h3geo.org/docs/core-library/restable/)
#' @param grouped Returns a grouped dataset if set `TRUE`. Default is `TRUE`.
#' @import dplyr
#' @import rlang
#' @import h3jsr
#' @import s2
#' @import sf
#' @export
#' @examples
#' \dontrun{
#' sf_trees <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-28/sf_trees.csv') %>%
#' filter(!is.na(latitude) | !is.na(longitude)) %>%
#'  get_s2h3_datasets(longitude,
#'  latitude,
#'  s2_level = 21,
#'  h3_resolution = 10)
#'}
#'

get_s2h3_datasets <- function(data,
                 long,
                 lat,
                 s2_level,
                 h3_resolution,
                 grouped = TRUE){

  s2_data <-  data %>%
    mutate(
      point =  s2_lnglat({{long}}, {{lat}}) %>% st_geometry(),
      s2_cell =  s2_lnglat({{long}}, {{lat}}) %>%
        as_s2_cell() %>%
        s2_cell_parent(level = s2_level)) %>%
    st_drop_geometry() %>%
    mutate(
      s2_polygon = s2_cell_polygon(s2_cell) %>% s2_as_text()
    ) %>%
    st_as_sf(wkt="s2_polygon",
             crs=4326)

  h3_data <-  data %>%
    mutate(
      point =  s2_lnglat({{long}}, {{lat}}) %>% st_geometry()
    ) %>%
    st_drop_geometry() %>%
    st_as_sf(crs=4326) %>%
    mutate(h3_cell = point_to_cell(point,res= h3_resolution),
           h3_polygon = cell_to_polygon(h3_cell))

  if(grouped){

    s2_data_grouped <- s2_data %>%
      group_by(s2_cell,
               s2_polygon)

    h3_data_grouped <- h3_data %>%
      group_by(h3_cell,
               h3_polygon)

    return(
      list(
        "s2_data_grouped"=s2_data_grouped,
        "h3_data_grouped"=h3_data_grouped
      )
    )
  }else{
    return(
      list(
        "s2_data" = s2_data,
        "h3_data" = h3_data
      )
    )

  }



}
