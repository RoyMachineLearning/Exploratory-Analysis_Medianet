################################ Visualizing campaign Data using Plotly ##################################


#install the following packages only once.
install.packages("ggplot2")
install.packages("plotly")


#Skip these packages for now.
install.packages("viridis") # dependency
install.packages("devtools")
install.packages("reshape2")
install.packages("ggvis")
install.packages("grid")
install.packages("dplyr")


# create the dataset from the csv file.
setwd("U:/Optimization/") # set your working directory

#getwd() - test

Source_folder <- "U:/Optimization/"
Source_File <- "AnalyticsManager_TestAssignment.csv"

Source_location <- paste(Source_folder,Source_File, sep="")


# read the file in df variable
allocationdf <- read.csv(Source_location)


#getOption("max.print")

#create scatter plot and normal distribution
plot(allocationdf$Clicks)
plot(allocationdf$Click.Rate..CTR.)

#the graph is skewed towards right

################ Now split the campaign into two rows #############

allocationdf$Campaign_num <- substr(allocationdf$Campaign,1,8)

allocationdf$Campaign_type <- substr(allocationdf$Campaign,12,length(allocationdf$Campaign))

#################################################################################################

#code for other campaigns
identifyCampaign_Type <- "CPM - Mobile"


##Code for  IBV and Expandable
identifyCampaign_Type_1 <- "CPM - IBV"
identifyCampaign_Type_2 <- "CPM - Expandable"
identifyCampaign_Type   <- "CPM - IBV/Expandable"
#########################Insert System Date################################

File_Type = Sys.Date()

###########################################################################


# Take the log of the periods for the size of the bubble
allocationdf$New_Impressions <- log(as.numeric(allocationdf$Impressions), base = 2)

allocationdf$New_Clicks <- log(as.numeric(allocationdf$Clicks), base = 2)

##################Code for other campaigns##################################################

#Apply filters

filtered_df = ""
filtered_df = subset(allocationdf,allocationdf$Campaign_type == identifyCampaign_Type)


###############################Code used for CPM - IBV/Expandible#############################

# Two filters for IBV and Expandable and then concat

filtered_df_1 = ""
filtered_df_1 = subset(allocationdf, allocationdf$Campaign_type == identifyCampaign_Type_1)

filtered_df_2 = ""
filtered_df_2 = subset(allocationdf, allocationdf$Campaign_type == identifyCampaign_Type_2)

# use rbind to combine the data from two filters

filtered_df = rbind(filtered_df_1,filtered_df_2)
##############################normal ggplots#############################
library(ggplot2)

library(plotly)

set.seed(100)


Destination_File = paste("Filtered_",File_Type,".csv")
Destination_location <- paste(Source_folder,Destination_File, sep="")


#delete the existing file
do.call(file.remove, list(list.files(Destination_location, full.names = TRUE)))

file.create(Destination_location)

write.csv(filtered_df, file = Destination_location,row.names=FALSE, na="")

#########################################################################################


# read the filtered file

resultAllocationDF = read.csv(Destination_location)

#####################################GRAPHS INITIATED - TRANSIT#######################################

#Histogram to check if the click rate are normalized?

Histo_Graph <- plot_ly(x = ~resultAllocationDF$Click.Rate..CTR., type = "histogram",
             histnorm = "probability")


#display the histogram  
Histo_Graph

#Box plot graphs to determine interquartile range

Boxplot_Graph <- plot_ly(resultAllocationDF, y = ~resultAllocationDF$Click.Rate..CTR., type = "box") %>%

 layout(                                                            # all of layout's properties: /r/reference/#layout
   title = ~paste("Box plot diagram for",identifyCampaign_Type),        # layout's title: /r/reference/#layout-title
   xaxis = list(zeroline = FALSE,                                                    # layout's xaxis is a named list. List of valid keys: /r/reference/#layout-xaxis
    title = "",                                              # xaxis's title: /r/reference/#layout-xaxis-title
    showgrid = F),                                                  # xaxis's showgrid: /r/reference/#layout-xaxis-showgrid
  yaxis = list(zeroline = FALSE,                                                     # layout's yaxis is a named list. List of valid keys: /r/reference/#layout-yaxis
    title = "Click Rate")                                           # yaxis's title: /r/reference/#layout-yaxis-title
)

#Print the Graph
Boxplot_Graph




