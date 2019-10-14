### GEOG 693: Final Project Proposal
Sara Schreder-Gomes

---------------
#### Objectives
Some modern ephemeral lakes in Western Australia are extreme environments. They can have a pH as low as 1.4, and salinity up to 10x that of seawater. We want to investigate how pH affects water chemistry by analyzing major ions in water from several locations and compare them to pH measured in the field. 
Additonally, we want to know how different the common ions in these saline lakes are from those common in seawater. 
1. Clean up data: format data that is recieved back from lab analysis and merge with field collected data
2. Automate basic statistical analysis that was previously done by hand
3. Create publication quality figures

#### Data Sources
1. Lab-analyzed water chemistry data for 11 modern ephemeral lakes in Western Australia
Example of lab data:
``` bash
Analyte Symbol	              Na	  Li	    Be	  Mg	  Al	  Si	  K	    Ca	Sc
Unit Symbol	                  mg/L	mg/L	  mg/L	mg/L	mg/L	mg/L	mg/L	mg/L	ug/L
Detection Limit (all in ug/L)	5	    1	      0.1	  2	    2     200	  30	  700	  1
KCB 1 Gniess Lake 4Jan'15	    99000	7.64	  0.21	34600	2870	93.9	5340	299	< 300
KCB 2 Lake Magic 1Jan'15	    94600	0.00749	0.44	12000	432	  72.7	1970	555	< 300
KCB 3 Lake Magic 15Jan'15	    85500	1.27	  0.065	23200	751	  61.8	3240	388	< 300
```
2. Field data
Example:
```bash
sample	lake	                        date collected	water depth (cm)	water color	pH  salinity (%TDS)
KCB 1	  Gneiss Lake, W. Australia	    4 Jan. 2015	    2.5	              yellow	    1.4	  32
KCB 2	  Lake Magic I, W. Australia	  1 Jan. 2015	    2.5	              yellow	    2	    30
KCB 3	  Lake Magic II, W. Australia	  15 Jan. 2015	  5	                yellow	    1.6	  30
```
3. Seawater chemistry data from NOAA World Ocean Database ([WOD](https://www.nodc.noaa.gov/OC5/WOD/pr_wod.html))

#### Languages Used
1. Bash for data formatting/data wrangling
2. R for statistical analysis and making figures

#### Implementation
I will create a bash script that will clean up incoming data. This script will merge field data (text file) and lab analysis (excel file). It will standardize units, as some are reported in mg/L and others are in ug/L. Another bash script will pull seawater data from NOAA WOD for comparison. In R, I will make a script for basic statistical analysis and create plots that will allow us to visually examine correlations between certain ions and pH, and the difference of ions in seawater and lake water. 

#### Expected Products
1. Basic statistical analysis: summary text file and script that can be run again if new data is obtained
2. Correlation plots of major ions vs pH, for each sample site (maybe a [scatterplot matrix?](https://www.r-graph-gallery.com/98-basic-scatterplot-matrix.html))
3. Plot that compares selected major ions in seawater and saline lakes

#### Questions for Instructor
What packages might be useful in addition to ggplot?
Do you know of other types of figures that might be useful to display the data? Or to compare between lakes?
