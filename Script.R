# Final Project Script
library("tidyverse")
library("base")
library("ggplot2")
library("plotly")
library("knitr")
library("kableExtra")

library("sf")
library("rnaturalearth")

library("maps")

library("oz") #install necessary packages for site map
library("grid")



FieldData <- data.frame("Sample" = c(NA, NA, NA, NA, "KCB 1", "KCB 2", "KCB 3", "KCB 4", "KCB 5", "KCB 6", "KCB 7", "KCB 8", "KCB 9", "KCB 10", "KCB 11"),
                        "Location" = c(NA, NA, NA, NA, "Gneiss Lake", "Lake Magic I", "Lake Magic II", "Lake Aerodrome", "Twin Lake West", "Salar Gorbea site 7", "Salar Gorbea site 10","Salar Ignorado site 3", "Saline Valley", "Bonneville Salt Flats", "Crosbie Lake"),
                        "Country" = c(NA, NA, NA, NA, "Australia", "Australia", "Australia", "Australia", "Australia", "Chile", "Chile", "Chile", "USA", "USA", "Canada"),
                        "Year Collected" = c(NA, NA, NA, NA,2015, 2015, 2015, 2009, 2009, 2009, 2007, 2007, NA, NA, NA),
                        "Water Depth (cm)" = c(NA, NA, NA, NA,2.5, 2.5, 5, 1.2, 10, 1, 2, 10, NA, NA, NA),
                        "Water Color" = c(NA, NA, NA, NA,"Yellow","Yellow", "Yellow", "Yellow", "Green", "Clear", "Pink", "Clear", NA, NA, NA),
                        "pH" = c(NA, NA, NA, NA,1.4, 2, 1.6, 1.8, 2.6, 2.7, 1.8, 3.8, NA, NA, NA),
                        "Salinity (%TDS)" = c(NA, NA, NA, NA,32, 30, 30, 29, 27, 28, 18, 5, NA, NA, NA),
                        "Latitude" = c(NA, NA, NA, NA,-33.21984, -32.43031 ,-32.42846, -32.20949, -33.05573, -25.42514, -25.42161, -25.49993,NA,NA,NA),
                        "Longitude" = c(NA, NA, NA, NA,121.75405, 118.90505, 118.90552, 121.76072, 121.67550, -68.68759, -68.69366, -69.62456,NA,NA,NA),
                        stringsAsFactors = FALSE)

write.csv(FieldData, "/Users/saraschredergomes/Desktop/GEOG693/FinalProject/data/FieldData.csv", row.names = FALSE)

FieldData %>%
  kable() %>%
  kable_styling()






LabData <- as.data.frame(read.csv("/Users/saraschredergomes/Desktop/GEOG693/FinalProject/data/BrineCompostions_ActLabsResults_RAWData.csv", stringsAsFactors = FALSE), header= FALSE, sep= ",", dec = ".", col.names = NULL) 

# for any value containing "<" (indicating uncertainty in the measurement), replace value with NA
for (col in colnames(LabData)){
  is.na(LabData[[col]]) <- startsWith(LabData[[col]], "<")
}

# exclude columns with no analyte data
for (col in colnames(LabData)){
  if (col == "Sample" || col == "Analyte.Symbol" || col == "Date.Time") 
    next
  
  # define multiplier to convert units
  multiplier <- 1
  if (LabData[1,col] == "mg/L")
    multiplier <- .001
  
  # Define detection limit for an analyte
  limit <- as.numeric(LabData[2,col]) * multiplier
  
  #remove values that are less than multiplied value (detection limit)
  for(i in 1:nrow(LabData))
  {
    if (i < 3) 
      next
    if (is.na(LabData[i,col]) == FALSE && LabData[i,col] < limit)
      is.na(LabData[i,col]) <- TRUE
  }
}



MajorIonLabData <- LabData %>% select(Sample,Analyte.Symbol, Na, Si, Fe, Al, Cl, Mg, Ca, K, Br, SO4) 
#choose the ion concentrations for analysis. This makes it easy to add analytes to the shorter data frame at a later point.

MajorIonLabData %>%
  kable() %>%
  kable_styling()




REELabData <- LabData %>% select(Sample,Analyte.Symbol, Ce, Dy, Er, Eu, Gd, Ho, La, Lu, Nd, Pr, Sm, Sc,Tb, Tm, Yb, Y) 
#choose the ion concentrations for analysis. This makes it easy to add analytes to the shorter data frame at a later point.

REELabData %>%
  kable() %>%
  kable_styling()




#merge LabData and FieldData to one df
MergedDatasets <- merge(FieldData, LabData, by.x = "Sample", by.y = "Sample")

MergedDatasets %>%
  kable() %>%
  kable_styling()




# Create basic scatter plot

#___ Make this a function
#Usage: pHvs(elementAbbrev, concentration unit?)
# throw error if abbrev isnt in the data. Message: 'Element abbreviation not found in data'

pHvs <- function(Element){
  TestPlot <- ggplot(MergedDatasets, aes(x=as.numeric(pH), y=as.numeric(Element))) +
    xlab("pH") + ylab("Fe (mg/L)") + geom_point(size = 3, shape = 20) +
    geom_text(aes(label=Sample), vjust=-.5) + ggtitle("pH vs. Fe content for Acid Saline Lake Systems")
  return(TestPlot)
}

# for (col in EnteredList)
#{
#   find matching column: data <- TestMerge$col

#   plot : ggplot(TestMerge, aes(x=as.numeric(pH), y=as.numeric(ElAbbrev))) + xlab("pH") + ylab(ElAbbrev) + geom_point() + geom_text(aes(label=Sample), vjust=-.5) + ggtitle("pH vs. ElAbbrev (unit)")

#}

for (col in colnames(MergedDatasets)){
  if (col == "Sample" || col == "Analyte.Symbol" || col == "Date.Time") 
    next #ignore columns that do not contain data
}

ggplot(MergedDatasets, aes(x=as.numeric(pH), y=as.numeric(Fe))) + xlab("pH") + ylab("Fe (mg/L)") + geom_point(size = 3, shape = 20) + geom_text(aes(label=Sample), vjust=-.5) + ggtitle("pH vs. Fe content for Acid Saline Lake Systems")
#by setting aes(x and y) as.numeric, it fixes a data coersion problem. In previous coercion, they were set to 'chr', which led to samples with 'NA' values being plotted and a very "wonky" y-axis.






# sort pH in ascending order
MergedDatasets <- MergedDatasets[order(MergedDatasets$pH),] 

#plot selcted rare earth elements vs. pH as line plot. More traces can be added. 
pHvsRareEarthElements <- plot_ly(MergedDatasets, x = as.numeric(MergedDatasets$pH), y = as.numeric(MergedDatasets$Gd), name = 'Gd', type = 'scatter', mode = 'lines',
                                 line = list(color = 'rgb(205, 12, 24)', width = 2)) %>%
  add_trace(y = MergedDatasets$Dy, name = 'Dy', line = list(color = 'rgb(22, 96, 167)', width = 2)) %>% #add another element
  add_trace(y = MergedDatasets$Yb, name = 'Yb', line = list(color = 'rgb(205, 12, 24)', width = 2, dash = 'dash')) %>%
  
  layout(title = "Selected Rare Earth Elements vs. pH",
         xaxis = list(title = "pH"),
         yaxis = list (title = "Concentration (ug/L)"))

pHvsRareEarthElements




world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)

#create dataframe with site latitude and longitude
site_id <- c("Gneiss Lake", "Lake Magic I", "Lake Magic II", "Lake Aerodrome", "Twin Lake West")
siteLongs <- c(121.75405, 118.90505, 118.90552, 121.76072, 121.67550)
siteLats <- c(-33.21984, -32.43031 ,-32.42846, -32.20949, -33.05573)
sites <- data.frame(site_id = site_id, longitude = siteLongs, latitude = siteLats)

#set coordinate system and sites
sites <- st_as_sf(sites, coords = c("longitude", "latitude"), 
                  crs = 4326, agr = "constant")

#create study site map
SiteMap <- ggplot(data = world) +
  geom_sf() +
  geom_sf(data = sites, size = 4, shape = 16, color = "darkred") +
  coord_sf(xlim = c(113, 127), ylim = c(-29, -36), expand = TRUE) +
  geom_sf_label(data=sites, aes(label = site_id), nudge_x = 1.2, nudge_y = .4) +
  coord_sf(xlim = c(113, 127), ylim =c(-29, -36), expand = TRUE)

#Create inset map
AustraliaMap <- ggplot(data = world) + geom_sf() + geom_sf(data = sites, size = 4, shape = 16, color = "darkred") + coord_sf(xlim = c(111, 156), ylim = c(-41, -7)) 

#Create combined map with inset
library(grid)
grid.newpage()
vp_b <- viewport(width = 1, height = 1, x = 0.5, y = 0.5)  # the larger map
vp_a <- viewport(width = 0.3, height = 0.3, x = 0.85, y = 0.25)  # dimentions and location of inset in the lower right 
print(SiteMap, vp = vp_b)
print(AustraliaMap, vp = vp_a)



