#######################################################################################################################
##### AEDE7415 SP2020: Tutorial Master Script
##### 21 January 2020
##### Author: Brian Cultice 
##### Description: This is a generic master script that illustrates some basic R workflow operations and practices.
#####              If you are unfamiliar w/ R, I recommend working through this script. We will set up our file paths,
#####              install our necessary packages, work w/ vectors and matrices in R, and download the assignment data 
#####              using R scraping tools
#####
##### ATTENTION: #CHANGE# will indicate that you should change the following line of code
#######################################################################################################################

#######################################################################################################################
### Preface: Base R stuff
### Note: This section shows some of the Base R functionality; go ahead and mess around with creating vectors, data
###       frames, loops, and whatnot here. Note that these work without any additional packages. 
#######################################################################################################################
print("See Tutorial_BaseR.R script for basic operations; seek a more formal tutorial if
       you need more assistance")

### Note: Open up Tutorial_BaseR.R and mess around if you need some basic practice in R

### Note: I can run scripts directly using the source function
baseR <- list.files(here(), pattern = "BaseR")
print(baseR)
source(here(baseR))

#######################################################################################################################
### Step 1: Packages and Paths
### Note: Base R has limited functionality; you'll always find that loading additional packages will be essential to 
###       getting the most out of R programming. You can also use the library() function 
###       to read in already installed packages, but this function will throw an error if 
###       the package is not installed. 
###
### Note: I am using the pacman package for package management. I highly recommend this for
###       purposes of concise workflow. Also, note one of the key advantages of projects.
###       By working from a project, we can use the here package to create simple file
###       paths that are relative to our working directory (e.g. the directory you assigned
###       this project to). This means we only need to specify one filepath, our downloads
###       folder. 
#######################################################################################################################
### Note: Install and load pacman
install.packages("pacman")

### Note: You can search for these packages online and get the CRAN describers on each one. 
  #       The key ones for our purposes are tidyverse, sf, here, and pacman.We are using the 
  #       pacman p_load function to a) check if these are installed and
  #       b) install/load them into our session. Each of my master scripts starts w/ a vector
  #       of packages and a loading function (note you can do library("package"))
packages_v <- c("here", "tidyverse", "sf", "rvest", "jsonlite",    
                  "httr", "pacman", "tictoc", "pryr", "tigris", "tidycensus") 
pacman::p_load(char = packages_v)

### Note: This section is the info we need for accessing data from IPUMS and the census FTP site. "sw_datadownload" is a switch 
  #       that indicates that we should run the IPUMS download script and whether we should run the script downloading the 
  #       highway data from the census FTP site. "auth_key" is your API key from IPUMS. Don't use my API key 
  #       please. Replace my file
sw_datadownload <- 0
auth_key        <- "59cba10d8a5da536fc06b59d72d1f1e2637842568a5496d40ca61ded"
file_downloads  <- "C:\\Users\\cultice.7\\Downloads" # CHANGE THIS TO YOURS #

### Examples: Illustrating the here package; for python users this is similar to make paths
print(here())
list.files(here())

test_here <- list.files(here(), pattern = ".R")
for (i in test_here){
  print(i)
}

########################################################################################################################
### Step 2: File management in Base R
### Note: Here we are going to create a set of directories to store our data, our scripts and our output in. We will use
###       an "if" condition to create the directories if they don't exist. Then we unzip our data and
###       scripts into our working directory. We then move files around using R file management 
###       tools.
###
### Note: If" statements in R are coded as such; the condition is put in parenthesis after the "if" call. The operations 
###       that are conducted if the condition is met are in the brackets. Here, the condition is generated by calling the
###       file exists function. This reads the relative file path and returns TRUE or FALSE whether that 
###       directory exists.
########################################################################################################################

### Note: For each of the directories we want to create, check if it exists, delete and create
  #       it if it does, or else just create the directory
dir_v <- c("Data", "Scripts", "Output")
for (i in dir_v){
  if (dir.exists(here(i))){
    unlink(here(i), recursive = TRUE)
    dir.create(here(i))
  }else{
    dir.create(here(i))
  }
}

### Example: Illustrating functions in R; I'm creating a function that does the same as the
  #          loop above
dir_v <- c("Data", "Scripts", "Output")
f_dir_recreate <- function(i){
  if (dir.exists(here(i))){
    unlink(here(i), recursive = TRUE)
    dir.create(here(i))
  }else{
    dir.create(here(i))
  }
}
map(dir_v, f_dir_recreate)

### Note: Unzip the sales data file into the data directory we created above using the unzip function
  #       Note that I am creating a data frame from the identified files so I can apply 
  #       tidyverse functions to the filenames to identify what directory I should unzip.
  #       Run this complicated thing and open zip_v by clicking on it in the global 
  #       environment. 
zip_v <- list.files(file_downloads, 
                    pattern = "AEDE8502_HW",
                    full.names = TRUE)                       %>% #list the files
  as.data.frame()                                            %>% #create a data frame
  filter(str_detect(., ".zip"))                              %>% #just in case, filter out the zipped folders
  rowwise()                                                  %>%
  mutate(Directory = if_else(str_detect(., "Scripts"), 
                             "Scripts",
                             "Data"))
  
### Note: for each number from 1 to the row dimension of zip_v, unzip our files
n <- dim(zip_v)[1]
for (i in 1:n){
  if (zip_v[[i,2]]=="Data"){
    unzip(zip_v[[i,1]], exdir = here(zip_v[[i,2]]))
  }else{
    unzip(zip_v[[i,1]], exdir = here())
  }
}

######################################################################################################################
### Step 3: Using R to scrape/download data from the web
### Note: In this section, we are going to use the IPUMS API to download cleaned census shapefiles. Then we will  
###       download data from the census FTP site using rvest package to download data directly from the website. The census
###       provides a FTP site for direct downloads of shapefiles and other data. If you set data download equal to 0, 
###       we simply read in this data from the downloaded folder. 
######################################################################################################################

if (sw_datadownload == 1){
  ### Note: Download county, census tract, and census block group shapefiles from IPUMS
  script_IPUMSdl <- paste0(file_scripts, "\\Tutorial_IPUMS_Download.R")
  source(script_IPUMSdl)
  
  ### Note: Clean and select shapefile data from IPUMS
  script_IPUMSclean <- paste0(file_scripts, "\\Tutorial_IPUMS_Clean.R")
  source(script_IPUMSclean)

  ### Note: Download highway network from census FTP site
  script_FTPdl <- paste0(file_scripts, "\\Tutorial_Census_Download.R")
  source(script_FTPdl)
  
  ### Note: Clean and select shapefile data from census FTP site
  script_FTPclean <- paste0(file_scripts, "\\Tutorial_Census_Clean.R")
  source(script_FTPclean)
}else {
  ### Note: st_read is the function in sf used to read shapefiles or other spatial data into R; here we are reading in the data 
    #       from our zipped folders
  cbgshape           <- st_read(here("Data", "Shapefiles", "NHGIS_TIGER2014_CensusBlockGroup.shp"), stringsAsFactors = FALSE)
  ctshape            <- st_read(here("Data", "Shapefiles", "NHGIS_TIGER2014_CensusTract.shp"), stringsAsFactors = FALSE)
  countyshape        <- st_read(here("Data", "Shapefiles", "NHGIS_TIGER2014_County.shp"), stringsAsFactors = FALSE)
  prisec_roads_final <- st_read(here("Data", "Shapefiles", "Census_TIGER2014_PriSecRoads.shp"), stringsAsFactors = FALSE)
}

### Note: People will find everything above as useless once I introduce this... 
  #       Another useful package/option to directly download data using an R package... 
  #       tigris and tidycensus are packages that have created wrapper functions and 
  #       cleaning operations similar to what we did above. 
tigrisroads <- tigris::roads(state = "Ohio", county = "Franklin") %>%
  filter(str_detect(FULLNAME, "Woody Hayes"))
ggplot(data = tigrisroads) +
  geom_sf()
rm(tigrisroads)

#######################################################################################################################
### Step 5: Import Housing Transactions and create shapefile
### Note: We unzip our housing data and create a shapefile from the lat-long; we then confirm that all geographies are
###       consistent (with regards to projection). We then mess around w/ our datasets using the sf package; it will be
###       up to you to relate the spatial data.
#######################################################################################################################

### Note: you can just run this here, but I recommend opening this up. 
script_spatial <- here("Scripts", "Tutorial_Spatial.R")
source(script_spatial)
