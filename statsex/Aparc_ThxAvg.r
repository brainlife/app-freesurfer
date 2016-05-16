#################################################################################
########## Extract Data from Aparc - ThxAvg for all the subjects ################
                ######### Freesurfer 5.3 version ###############
                            ## Pratik Gandhi ## 

colnames<-c("subjectid","Left_Cortex_MeanThickness","Right_Cortex_MeanThickness","Left_bankssts_ThxAvg","Right_bankssts_ThxAvg","Left_caudalanteriorcingulate_ThxAvg","Right_caudalanteriorcingulate_ThxAvg","Left_caudalmiddlefrontal_ThxAvg","Right_caudalmiddlefrontal_ThxAvg","Left_cuneus_ThxAvg","Right_cuneus_ThxAvg","Left_entorhinal_ThxAvg","Right_entorhinal_ThxAvg","Left_fusiform_ThxAvg","Right_fusiform_ThxAvg","Left_inferiorparietal_ThxAvg","Right_inferiorparietal_ThxAvg","Left_inferiortemporal_ThxAvg","Right_inferiortemporal_ThxAvg","Left_isthmuscingulate_ThxAvg","Right_isthmuscingulate_ThxAvg","Left_lateraloccipital_ThxAvg","Right_lateraloccipital_ThxAvg","Left_lateralorbitofrontal_ThxAvg","Right_lateralorbitofrontal_ThxAvg","Left_lingual_ThxAvg","Right_lingual_ThxAvg","Left_medialorbitofrontal_ThxAvg","Right_medialorbitofrontal_ThxAvg","Left_middletemporal_ThxAvg","Right_middletemporal_ThxAvg","Left_parahippocampal_ThxAvg","Right_parahippocampal_ThxAvg","Left_paracentral_ThxAvg","Right_paracentral_ThxAvg","Left_parsopercularis_ThxAvg","Right_parsopercularis_ThxAvg","Left_parsorbitalis_ThxAvg","Right_parsorbitalis_ThxAvg","Left_parstriangularis_ThxAvg","Right_parstriangularis_ThxAvg","Left_pericalcarine_ThxAvg","Right_pericalcarine_ThxAvg","Left_postcentral_ThxAvg","Right_postcentral_ThxAvg","Left_posteriorcingulate_ThxAvg","Right_posteriorcingulate_ThxAvg","Left_precentral_ThxAvg","Right_precentral_ThxAvg","Left_precuneus_ThxAvg","Right_precuneus_ThxAvg","Left_rostralanteriorcingulate_ThxAvg","Right_rostralanteriorcingulate_ThxAvg","Left_rostralmiddlefrontal_ThxAvg","Right_rostralmiddlefrontal_ThxAvg","Left_superiorfrontal_ThxAvg","Right_superiorfrontal_ThxAvg","Left_superiorparietal_ThxAvg","Right_superiorparietal_ThxAvg","Left_superiortemporal_ThxAvg","Right_superiortemporal_ThxAvg","Left_supramarginal_ThxAvg","Right_supramarginal_ThxAvg","Left_frontalpole_ThxAvg","Right_frontalpole_ThxAvg","Left_temporalpole_ThxAvg","Right_temporalpole_ThxAvg","Left_transversetemporal_ThxAvg","Right_transversetemporal_ThxAvg","Left_insula_ThxAvg","Right_insula_ThxAvg")
colnames<-t(colnames)
write.table(colnames,"Results/Aparc_ThxAvg.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

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

split <- strsplit(linn_lh[21], " ")[[1]]
meanthx_lh<-split[length(split)-1]
meanthx_lh<-substr(meanthx_lh, 1, nchar(meanthx_lh)-1)

split <- strsplit(linn_rh[21], " ")[[1]]
meanthx_rh<-split[length(split)-1]
meanthx_rh<-substr(meanthx_rh, 1, nchar(meanthx_rh)-1)

# Reading the table from both left and right hemispheres
table_lh<-read.table(lhaparc)
table_rh<-read.table(rhaparc)

# Converting them to matrix form for matching to template and inserting the missing values
table_rh <- as.matrix(table_rh)
table_lh <- as.matrix(table_lh)
table_base <- as.matrix(table_base[,1])

table_lh <- merge(x=table_base,y=table_lh, all.x = TRUE ) # Doing for LH
table_lh <- table_lh[match(table_lh[,1],table_base[,1]),]
table_lh <- as.matrix(table_lh)
table_lh[is.na(table_lh)] <- 0

table_rh <- merge(x=table_base,y=table_rh, all.x = TRUE ) # Doing for RH
table_rh <- table_rh[match(table_rh[,1],table_base[,1]),]
table_rh <- as.matrix(table_rh)
table_rh[is.na(table_lh)] <- 0

# Converting back to data frame
table_lh <- as.data.frame(table_lh)
table_rh <- as.data.frame(table_rh)

# Getting the column (Thx-Avg) we are interested
table_values_lh<-data.frame(table_lh[,c("V5")])
table_values_rh<-data.frame(table_rh[,c("V5")])

tot_table <- data.frame(table_values_lh,table_values_rh)

ext<-data.frame(matrix(ncol = 1,nrow = 1))

for (k in 1:nrow(tot_table)){
  ind_row <- tot_table[k,]
  ext <- cbind(ext,ind_row)
}

ext[,1] <- NULL

sub_id<-data.frame(subjectid,meanthx_lh,meanthx_rh)

z<-cbind(sub_id,ext)

write.table(z,"Results/Aparc_ThxAvg.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

