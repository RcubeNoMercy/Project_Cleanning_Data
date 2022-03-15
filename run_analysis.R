
# DESCARGA E IMPORTACIÓN DE LA DATA

# Descarga
url<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("./UCI HAR Dataset.zip")){
  download.file(url,"./UCI HAR Dataset.zip", method= "curl")
}
unzip("./UCI HAR Dataset.zip", exdir = getwd())

#Importación
library(data.table)
features <- read.table("UCI HAR Dataset/features.txt",col.names = c("n","functions"))


# test
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt",col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt",col.names = "code")

test<-data.table(subject_test, y_test, x_test)


# train
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt",col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt",col.names = "code")

train<-data.table(subject_train, y_train, x_train)




#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$
# 1. Combina los conjuntos de entrenamiento y prueba para crear un conjunto de
# datos.

MergeData <- rbind(train, test)


# 2. Extrae solo las mediciones sobre la media y la desviación estándar para
# cada medición. 
library(dplyr)
data2 <- select(MergeData, subject, code,
                                 contains("mean"),
                                 contains("std"))
data2[1:6, 1:5] #Algunos valores


# 3.Utiliza nombres de actividad descriptivos para asignar un nombre a las 
#actividades del conjunto de datos
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", 
                              col.names = c("code", "activity"))
data2$code <- activity_labels[data2$code, 2]
data2[1:6, 1:5] #Algunos valores

# 4.Etiqueta adecuadamente el conjunto de datos con nombres de variables
# descriptivas. 
newData <- names(data2)
newData <- gsub("Mag", "Magnitude", newData)
newData <- gsub("-mean-", "_Mean_", newData)
newData <- gsub("-std-", "_StandardDeviation_", newData)
newData <- gsub("^t", "TimeDomain_", newData)
newData <- gsub("^f", "FrequencyDomain_", newData)
newData <- gsub("Acc", "Accelerometer", newData)
newData <- gsub("Gyro", "Gyroscope", newData)
newData <- gsub("-", "_", newData)
names(data2) <- newData


# 5. A partir del conjunto de datos en el paso 4, crea un segundo 
# conjunto de datos ordenado e independiente con el promedio de cada variable
# para cada actividad y cada sujeto.

TidyData <- aggregate(data2[,3:81], 
                       by = list(activity = data2$code,
                                 subject = data2$subject),
                       FUN = mean)

TidyData[1:6, 1:3] # algunos valores
