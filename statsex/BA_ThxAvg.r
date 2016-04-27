#############################################################################
######## Extract Data from BA - ThickAverage for all the subjects ###########
            ########### Freesurfer 5.3 version ###############
                          ## Pratik Gandhi ## 

### Define the base directory
i<-0
setwd(basedir)
dir.create("Results")
dirs <- list.dirs(path=basedir, full.names=TRUE, recursive=FALSE) # List the directories

# Writing the column names and writing it to a csv file
colnames<-c("subjectid","Left_BA1_ThickAvg","Right_BA1_ThickAvg","Left_BA2_ThickAvg","Right_BA2_ThickAvg","Left_BA3a_ThickAvg","Right_BA3a_ThickAvg","Left_BA3b_ThickAvg","Right_BA3b_ThickAvg","Left_BA4a_ThickAvg","Right_BA4a_ThickAvg","Left_BA4p_ThickAvg","Right_BA4p_ThickAvg","Left_BA6_ThickAvg","Right_BA6_ThickAvg","Left_BA44_ThickAvg","Right_BA44_ThickAvg","Left_BA45_ThickAvg","Right_BA45_ThickAvg","Left_V1_ThickAvg","Right_V1_ThickAvg","Left_V2_ThickAvg","Right_V2_ThickAvg","Left_MT_ThickAvg","Right_MT_ThickAvg","Left_perirhinal_ThickAvg","Right_perirhinal_ThickAvg")
colnames<-t(colnames)
write.table(colnames,"Results/BA_ThickAvg.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
temp_dir <- "/home/pkgandhi/Templates_53" 
setwd(temp_dir)
local_files <- list.files(temp_dir)
base_file <- local_files[grepl("lh.BA.stats$",local_files)]
table_base<- read.table(base_file)

### Again directing to the base directory
setwd(basedir)
length_dirs<- length(dirs)-1

# Getting inside the individual directories
for (i in 1:length_dirs){
    
  setwd(dirs[i])
  allfiles<-list.files(,recursive=TRUE)
  lhBA<-allfiles[grepl("lh.BA.stats$",allfiles)] # Reading the lh-BA file
  rhBA<-allfiles[grepl("rh.BA.stats$",allfiles)] # Reading the rh-BA file

        linn_lh<-readLines(lhBA)
        linn_rh<-readLines(rhBA)

    split <- strsplit(linn_lh[15], " ")[[1]]
    subjectid<-split[length(split)]    

    table_lh<-read.table(lhBA)
    table_rh<-read.table(rhBA)

    # Converting them to matrix form for matching to template and inserting the missing values
    table_rh <- as.matrix(table_rh)
    table_lh <- as.matrix(table_lh)
    table_base <- as.matrix(table_base[,1])
    
    table_lh <- merge(x=table_base,y=table_lh, all.x = TRUE ) # Doing for LH
    table_lh <- table_lh[match(table_base[,1],table_lh[,1]),]
    table_lh <- as.matrix(table_lh)
    table_lh[is.na(table_lh)] <- 0
    
    table_rh <- merge(x=table_base,y=table_rh, all.x = TRUE ) # Doing for RH
    table_rh <- table_rh[match(table_base[,1],table_rh[,1]),]
    table_rh <- as.matrix(table_rh)
    table_rh[is.na(table_lh)] <- 0
    
    # Converting back to data frame
    table_lh <- as.data.frame(table_lh)
    table_rh <- as.data.frame(table_rh)
    
    table_values_lh<-data.frame(table_lh[,c("V5")])
    table_values_rh<-data.frame(table_rh[,c("V5")])
    
    tot_table <- data.frame(table_values_lh,table_values_rh)
    
    ext<-data.frame(matrix(ncol = 1,nrow = 1))
    
    for (k in 1:nrow(tot_table)){
      ind_row <- tot_table[k,]
      ext <- cbind(ext,ind_row)
    }
    
    ext[,1] <- NULL
    
    sub_id<-data.frame(subjectid)
    
    z<-cbind(sub_id,ext)  # Combining the values and the subjectid, putting in one data frame
    
    setwd(basedir)
    write.table(z,"Results/BA_ThickAvg.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE) # Writing it to the csv file created
}
setwd(basedir)
