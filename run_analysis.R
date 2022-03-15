
# DESCARGA E IMPORTACIÓN DE LA DATA

# Descarga
url<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("./UCI HAR Dataset.zip")){
  download.file(url,"./UCI HAR Dataset.zip", method= "curl")
  unzip("UCI HAR Dataset.zip", exdir = getwd())
}

#Importación