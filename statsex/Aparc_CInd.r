#################################################################################
######### Extract Data from Aparc - CurvInd for all the subjects ################
              ######### Freesurfer 5.3 version ###############
                          ## Pratik Gandhi ## 

### Define the base directory
#i<-0
## basedir <- "C:/USers/pkgandhi/Documents/Testdata53" ### Change to the directory where data is stored

### Writing the column names and writing it to a csv file
colnames<-c("subjectid","Left_bankssts_CurvInd","Right_bankssts_CurvInd","Left_caudalanteriorcingulate_CurvInd","Right_caudalanteriorcingulate_CurvInd","Left_caudalmiddlefrontal_CurvInd","Right_caudalmiddlefrontal_CurvInd","Left_cuneus_CurvInd","Right_cuneus_CurvInd","Left_entorhinal_CurvInd","Right_entorhinal_CurvInd","Left_fusiform_CurvInd","Right_fusiform_CurvInd","Left_inferiorparietal_CurvInd","Right_inferiorparietal_CurvInd","Left_inferiortemporal_CurvInd","Right_inferiortemporal_CurvInd","Left_isthmuscingulate_CurvInd","Right_isthmuscingulate_CurvInd","Left_lateraloccipital_CurvInd","Right_lateraloccipital_CurvInd","Left_lateralorbitofrontal_CurvInd","Right_lateralorbitofrontal_CurvInd","Left_lingual_CurvInd","Right_lingual_CurvInd","Left_medialorbitofrontal_CurvInd","Right_medialorbitofrontal_CurvInd","Left_middletemporal_CurvInd","Right_middletemporal_CurvInd","Left_parahippocampal_CurvInd","Right_parahippocampal_CurvInd","Left_paracentral_CurvInd","Right_paracentral_CurvInd","Left_parsopercularis_CurvInd","Right_parsopercularis_CurvInd","Left_parsorbitalis_CurvInd","Right_parsorbitalis_CurvInd","Left_parstriangularis_CurvInd","Right_parstriangularis_CurvInd","Left_pericalcarine_CurvInd","Right_pericalcarine_CurvInd","Left_postcentral_CurvInd","Right_postcentral_CurvInd","Left_posteriorcingulate_CurvInd","Right_posteriorcingulate_CurvInd","Left_precentral_CurvInd","Right_precentral_CurvInd","Left_precuneus_CurvInd","Right_precuneus_CurvInd","Left_rostralanteriorcingulate_CurvInd","Right_rostralanteriorcingulate_CurvInd","Left_rostralmiddlefrontal_CurvInd","Right_rostralmiddlefrontal_CurvInd","Left_superiorfrontal_CurvInd","Right_superiorfrontal_CurvInd","Left_superiorparietal_CurvInd","Right_superiorparietal_CurvInd","Left_superiortemporal_CurvInd","Right_superiortemporal_CurvInd","Left_supramarginal_CurvInd","Right_supramarginal_CurvInd","Left_frontalpole_CurvInd","Right_frontalpole_CurvInd","Left_temporalpole_CurvInd","Right_temporalpole_CurvInd","Left_transversetemporal_CurvInd","Right_transversetemporal_CurvInd","Left_insula_CurvInd","Right_insula_CurvInd")
colnames<-t(colnames)
write.table(colnames,"Results/Aparc_CurvInd.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
local_files <- list.files(temp_dir)
base_file <- local_files[grepl("lh.aparc.stats$",local_files)]
table_base<-read.table(paste(temp_dir,base_file,sep="/"))

allfiles<-list.files(,recursive=TRUE)
lhaparc<-allfiles[grepl("lh.aparc.stats$",allfiles)] # Reading the lh-aparc file
rhaparc<-allfiles[grepl("rh.aparc.stats$",allfiles)] # Reading the rh-aparc file

linn_lh<-readLines(lhaparc)
linn_rh<-readLines(rhaparc)

split <- strsplit(linn_lh[15], " ")[[1]]
subjectid<-split[length(split)]   # Getting the subject id for the respective subject 

# Reading the table from both left and right hemispheres
table_lh<-read.table(lhaparc)
table_rh<-read.table(rhaparc)

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

# Getting the column (Curv-Ind) we are interested
table_values_lh<-data.frame(table_lh[,c("V10")])
table_values_rh<-data.frame(table_rh[,c("V10")])

tot_table <- data.frame(table_values_lh,table_values_rh) # Combining both the values of LH and RH after matching with the template

ext<-data.frame(matrix(ncol = 1,nrow = 1))

for (k in 1:nrow(tot_table)){
  ind_row <- tot_table[k,]
  ext <- cbind(ext,ind_row)
}

ext[,1] <- NULL

sub_id<-data.frame(subjectid)

z<-cbind(sub_id,ext) # Combining the values and the subjectid, putting in one data frame

write.table(z,"Results/Aparc_CurvInd.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE) # Writing it to the csv file created
