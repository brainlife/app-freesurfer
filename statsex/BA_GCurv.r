#################################################################################
########## Extract Data from BA - GaussCurv for all the subjects ################
            ########### Freesurfer 5.3 version ###############
                          ## Pratik Gandhi ## 


# Writing the column names and writing it to a csv file
colnames<-c("subjectid","Left_BA1_GausCurv","Right_BA1_GausCurv","Left_BA2_GausCurv","Right_BA2_GausCurv","Left_BA3a_GausCurv","Right_BA3a_GausCurv","Left_BA3b_GausCurv","Right_BA3b_GausCurv","Left_BA4a_GausCurv","Right_BA4a_GausCurv","Left_BA4p_GausCurv","Right_BA4p_GausCurv","Left_BA6_GausCurv","Right_BA6_GausCurv","Left_BA44_GausCurv","Right_BA44_GausCurv","Left_BA45_GausCurv","Right_BA45_GausCurv","Left_V1_GausCurv","Right_V1_GausCurv","Left_V2_GausCurv","Right_V2_GausCurv","Left_MT_GausCurv","Right_MT_GausCurv","Left_perirhinal_GausCurv","Right_perirhinal_GausCurv")
colnames<-t(colnames)
write.table(colnames,"Results/BA_GausCurv.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
local_files <- list.files(temp_dir)
base_file <- local_files[grepl("lh.BA.stats$",local_files)]
table_base<- read.table(base_file)

### Again directing to the base directory

allfiles<-list.files(,recursive=TRUE)
lhBA<-allfiles[grepl("lh.BA.stats$",allfiles)] # Reading the lh-BA file
rhBA<-allfiles[grepl("rh.BA.stats$",allfiles)] # Reading the rh-BA file

linn_lh<-readLines(lhBA)
linn_rh<-readLines(rhBA)

split <- strsplit(linn_lh[15], " ")[[1]]
subjectid<-split[length(split)]     # Getting the subject id for the respective subject

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

table_values_lh<-data.frame(table_lh[,c("V8")])
table_values_rh<-data.frame(table_rh[,c("V8")])

tot_table <- data.frame(table_values_lh,table_values_rh)

ext<-data.frame(matrix(ncol = 1,nrow = 1))

for (k in 1:nrow(tot_table)){
ind_row <- tot_table[k,]
ext <- cbind(ext,ind_row)
}

ext[,1] <- NULL

sub_id<-data.frame(subjectid) 

z<-cbind(sub_id,ext)  # Combining the values and the subjectid, putting in one data frame

write.table(z,"Results/BA_GausCurv.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE) # Writing it to the csv file created
