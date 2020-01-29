#manipulating raster objects
library(sf)
library(raster)
library(sp)
library(dplyr)
library(spData)

elev = raster(nrows = 6, ncols = 6, res = 0.5,
              xmn = -1.5, xmx = 1.5, ymn = -1.5, ymx = 1.5,
              vals = 1:36)

#raster objects can contain values of class numeric, integer, logical or factor, but not character
grain_order = c("clay", "silt", "sand")
grain_char = sample(grain_order, 36, replace = TRUE)
grain_fact = factor(grain_char, levels = grain_order)
grain = raster(nrows = 6, ncols = 6, res = 0.5, 
               xmn = -1.5, xmx = 1.5, ymn = -1.5, ymx = 1.5,
               vals = grain_fact)

#ratify
levels(grain)[[1]] = cbind(levels(grain)[[1]], wetness = c("wet", "moist", "dry"))
levels(grain)
ratify(grain)

#retrieve value of ids 1,11,35
factorValues(grain, grain[c(1, 11, 35)])


#raster subsetting
#Raster subsetting is done with the base R operator [, which accepts a variety of inputs:
#Row-column indexing
#Cell IDs
#Coordinates
#Another raster object
            
#subsetting
# row 1, column 1
elev[1, 1]
# cell ID 1
elev[1]


#raster subset()
r_stack = stack(elev, grain)
names(r_stack) = c("elev", "grain")
# three ways to extract a layer of a stack
raster::subset(r_stack, "elev")
r_stack[["elev"]]
r_stack$elev


#summarizing raster objects
cellStats(elev, sd)

#using brick/stack to summarize each layer seaparately
summary(brick(elev,grain))

hist(elev)

boxplot(elev)

#if it doesn't work directly, values or getValues can be used
hist(values(elev))

vals_elev <- values(elev)


#us data exercise
library(spData)
data(us_states)
data(us_states_df)
library(dplyr)
library(stringr)

#Create a new object called us_states_name that contains only the NAME column from the us_states object. 
#What is the class of the new object and what makes it geographic? 
us_states_name <- us_states$NAME

#what's the class?
class(us_states_name)

us_states_pop <- us_states %>% 
  dplyr::select(contains('pop'))


us_midwest <- us_states %>%
  filter(REGION %in% 'Midwest')

us_midwest$AREA <- as.numeric(us_midwest$AREA)
us_midwest$total_pop_15 <- as.numeric(us_midwest$total_pop_15)

us_midwest_areabel_pop <- us_midwest %>% 
  dplyr::filter(total_pop_15 > 5000000,
         AREA < 250000)

#us south, pop>7M, area>150

us_states$AREA <- as.numeric(us_states$AREA)
us_states$total_pop_15 <- as.numeric(us_states$total_pop_15)

us_south_pop7M_ar150KM2 <- us_states %>% 
  dplyr::filter(REGION %in% 'South',
                total_pop_15>7000000,
                AREA>150000)

#totalpop in 15, min and max
us_states %>% 
  summarise(total = sum(total_pop_15),
            min_pop = min(total_pop_15),
            max_pop = max(total_pop_15))

#no. of states in each region
us_states %>% 
  group_by(REGION) %>% 
  summarise(count_states = n_distinct(NAME))

us_states %>% 
  group_by(REGION) %>% 
  summarise(total = sum(total_pop_15),
            min_pop = min(total_pop_15),
            max_pop = max(total_pop_15))

#since the vars in us_states and us_states_df contain the char var
#NAME and state we can rename state in the _df obj
us_states_df <- us_states_df %>% 
  rename(NAME = state)

#joining the two tables
us_states_data <- inner_join(us_states,
                             us_states_df,
                             by = 'NAME')

#using setdiff to see the diff
setdiff(us_states$NAME,
        us_states_df$NAME)

#anti join to see not overlapped data
diffdata <- dplyr::anti_join(us_states, us_states_df,
                             by = "NAME")





#creating a raster
new_raster <- raster(nrows = 9,
              ncols = 9,
              xmn = 0, xmx = 4.5, 
              ymn = 0, ymx = 4.5,
              res = 0.5,
              vals = 1:81)

#new_raster <- raster(vals = ncell(new_raster))

new_raster[1,1]
new_raster[1,9]
new_raster[9,1]
new_raster[9,9]
