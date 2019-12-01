Project outline
### Packages needed


### read in files




#### clean up data
## delete some unnecessary rows/columns
## standardize units
## remove values below threshold and replace with NA
## 

### merge .csv files


#### Create summary data file
## able to get summary by subsetting data. ex: find avg pH of lakes in Australia; analyze major ions of samples collected in year 2015; compare ion concentrations of a pH range.

## create plots in the same way, choosing what to subset

### Figures
Compare key ion plots

Study area map: use Mapping in R lecture
- Does Kathy have coordinates of lakes?
    
    ggplot(data = world) +
    geom_sf() +
    coord_sf(xlim = c(-102.15, -74.12), ylim = c(7.65, 33.97), expand = FALSE)

    ggplot(data = world) +
    geom_sf() +
    annotation_scale(location = "bl", width_hint = 0.5) +
    annotation_north_arrow(location = "bl", which_north = "true", 
        pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
        style = north_arrow_fancy_orienteering) +
    coord_sf(xlim = c(-102.15, -74.12), ylim = c(7.65, 33.97))

  Make a data frame with site ID and coordinates
    (sites <- data.frame(site_id = c("Coopers", "Seneca"), longitude = c(-79.7878, -79.3762), latitude = c(39.6556, 38.8348)))


## make a dataframe with site names and coordinates
     site_id <- c(list of site names)
     siteLongs <- c(list of site longitudes)
     siteLats <- c(list of site latittudes)
     sites <- as.data.frame(cbind(site_id, siteLongs, siteLats))


    ggplot(data = world) +
    geom_sf() +
    geom_point(data = sites, aes(x = longitude, y = latitude), size = 4, 
        shape = 16, color = "darkred") +
    coord_sf(xlim = c(#change -82, -77), ylim = c(37, 40), expand = FALSE) # change coords


