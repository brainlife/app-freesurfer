#################################################################################
########### Extract Data from BA - SurfArea for all the subjects ################
              ########### Freesurfer 5.3 version ###############
                            ## Pratik Gandhi ## 

# Writing the column names and writing it to a csv file
colnames<-c("subjectid","Left_NumVert","Right_NumVert","Left_Cortex_WhiteSurfArea","Right_Cortex_WhiteSurfArea","Left_BA1_SurfArea","Right_BA1_SurfArea","Left_BA2_SurfArea","Right_BA2_SurfArea","Left_BA3a_SurfArea","Right_BA3a_SurfArea","Left_BA3b_SurfArea","Right_BA3b_SurfArea","Left_BA4a_SurfArea","Right_BA4a_SurfArea","Left_BA4p_SurfArea","Right_BA4p_SurfArea","Left_BA6_SurfArea","Right_BA6_SurfArea","Left_BA44_SurfArea","Right_BA44_SurfArea","Left_BA45_SurfArea","Right_BA45_SurfArea","Left_V1_SurfArea","Right_V1_SurfArea","Left_V2_SurfArea","Right_V2_SurfArea","Left_MT_SurfArea","Right_MT_SurfArea","Left_perirhinal_SurfArea","Right_perirhinal_SurfArea")
colnames<-t(colnames)
write.table(colnames,"Results/BA_SurfArea.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
local_files <- list.files(temp_dir)
base_file <- local_files[grepl("lh.BA.stats$",local_files)]
table_base<-read.table(paste(temp_dir,base_file,sep="/"))

allfiles<-list.files(,recursive=TRUE)
lhBA<-allfiles[grepl("lh.BA.stats$",allfiles)] # Reading the lh-BA file
rhBA<-allfiles[grepl("rh.BA.stats$",allfiles)] # Reading the rh-BA file

linn_lh<-readLines(lhBA)
linn_rh<-readLines(rhBA)

split <- strsplit(linn_lh[15], " ")[[1]]
subjectid<-split[length(split)]    # Getting the subject id for the respective subject

split <- strsplit(linn_lh[19], " ")[[1]]
numvert_lh<-split[length(split)-1]
numvert_lh<-substr(numvert_lh, 1, nchar(numvert_lh)-1)

split <- strsplit(linn_lh[20], " ")[[1]]
whiteSA_lh<-split[length(split)-1]
whiteSA_lh<-substr(whiteSA_lh, 1, nchar(whiteSA_lh)-1)

split <- strsplit(linn_rh[19], " ")[[1]]
numvert_rh<-split[length(split)-1]
numvert_rh<-substr(numvert_rh, 1, nchar(numvert_rh)-1)

split <- strsplit(linn_rh[20], " ")[[1]]
whiteSA_rh<-split[length(split)-1]
whiteSA_rh<-substr(whiteSA_rh, 1, nchar(whiteSA_rh)-1)

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

table_values_lh<-data.frame(table_lh[,c("V3")])
table_values_rh<-data.frame(table_rh[,c("V3")])

tot_table <- data.frame(table_values_lh,table_values_rh)

ext<-data.frame(matrix(ncol = 1,nrow = 1))

for (k in 1:nrow(tot_table)){
  ind_row <- tot_table[k,]
  ext <- cbind(ext,ind_row)
}

ext[,1] <- NULL

sub_id<-data.frame(subjectid,numvert_lh,numvert_rh,whiteSA_lh,whiteSA_rh)

z<-cbind(sub_id,ext)  # Combining the values and the subjectid, putting in one data frame

write.table(z,"Results/BA_SurfArea.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE) # Writing it to the csv file created

