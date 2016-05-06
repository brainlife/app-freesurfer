#################################################################################
######### Extract Data from Aparc - SurfArea for all the subjects ###############
              ######### Freesurfer 5.3 version ###############
                          ## Pratik Gandhi ## 

### Define the base directory

### Writing the column names and writing it to a csv file
colnames<-c("subjectid","Left_NumVert","Right_NumVert","Left_Cortex_WhiteSurfArea","Right_Cortex_WhiteSurfArea","Left_bankssts_SurfArea","Right_bankssts_SurfArea","Left_caudalanteriorcingulate_SurfArea","Right_caudalanteriorcingulate_SurfArea","Left_caudalmiddlefrontal_SurfArea","Right_caudalmiddlefrontal_SurfArea","Left_cuneus_SurfArea","Right_cuneus_SurfArea","Left_entorhinal_SurfArea","Right_entorhinal_SurfArea","Left_fusiform_SurfArea","Right_fusiform_SurfArea","Left_inferiorparietal_SurfArea","Right_inferiorparietal_SurfArea","Left_inferiortemporal_SurfArea","Right_inferiortemporal_SurfArea","Left_isthmuscingulate_SurfArea","Right_isthmuscingulate_SurfArea","Left_lateraloccipital_SurfArea","Right_lateraloccipital_SurfArea","Left_lateralorbitofrontal_SurfArea","Right_lateralorbitofrontal_SurfArea","Left_lingual_SurfArea","Right_lingual_SurfArea","Left_medialorbitofrontal_SurfArea","Right_medialorbitofrontal_SurfArea","Left_middletemporal_SurfArea","Right_middletemporal_SurfArea","Left_parahippocampal_SurfArea","Right_parahippocampal_SurfArea","Left_paracentral_SurfArea","Right_paracentral_SurfArea","Left_parsopercularis_SurfArea","Right_parsopercularis_SurfArea","Left_parsorbitalis_SurfArea","Right_parsorbitalis_SurfArea","Left_parstriangularis_SurfArea","Right_parstriangularis_SurfArea","Left_pericalcarine_SurfArea","Right_pericalcarine_SurfArea","Left_postcentral_SurfArea","Right_postcentral_SurfArea","Left_posteriorcingulate_SurfArea","Right_posteriorcingulate_SurfArea","Left_precentral_SurfArea","Right_precentral_SurfArea","Left_precuneus_SurfArea","Right_precuneus_SurfArea","Left_rostralanteriorcingulate_SurfArea","Right_rostralanteriorcingulate_SurfArea","Left_rostralmiddlefrontal_SurfArea","Right_rostralmiddlefrontal_SurfArea","Left_superiorfrontal_SurfArea","Right_superiorfrontal_SurfArea","Left_superiorparietal_SurfArea","Right_superiorparietal_SurfArea","Left_superiortemporal_SurfArea","Right_superiortemporal_SurfArea","Left_supramarginal_SurfArea","Right_supramarginal_SurfArea","Left_frontalpole_SurfArea","Right_frontalpole_SurfArea","Left_temporalpole_SurfArea","Right_temporalpole_SurfArea","Left_transversetemporal_SurfArea","Right_transversetemporal_SurfArea","Left_insula_SurfArea","Right_insula_SurfArea")
colnames<-t(colnames)
write.table(colnames,"Results/Aparc_SurfArea.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
local_files <- list.files(temp_dir)
base_file <- local_files[grepl("lh.aparc.stats$",local_files)]
table_base<-read.table(base_file)

allfiles<-list.files(,recursive=TRUE)
lhaparc<-allfiles[grepl("lh.aparc.stats$",allfiles)] # Reading the lh-aparc file
rhaparc<-allfiles[grepl("rh.aparc.stats$",allfiles)] # Reading the rh-aparc file

linn_lh<-readLines(lhaparc)
linn_rh<-readLines(rhaparc)

split <- strsplit(linn_lh[15], " ")[[1]]
subjectid<-split[length(split)]   # Getting the subject id for the respective subject 

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

# Getting the column (Surf-Area) we are interested
table_values_lh<-data.frame(table_lh[,c("V3")])
table_values_rh<-data.frame(table_rh[,c("V3")])

tot_table <- data.frame(table_values_lh,table_values_rh)  # Combining both the values of LH and RH after matching with the template

ext<-data.frame(matrix(ncol = 1,nrow = 1))

for (k in 1:nrow(tot_table)){
	ind_row <- tot_table[k,]
	ext <- cbind(ext,ind_row)
}

ext[,1] <- NULL

sub_id<-data.frame(subjectid,numvert_lh,numvert_rh,whiteSA_lh,whiteSA_rh)

z<-cbind(sub_id,ext) # Combining the values and the subjectid, putting in one data frame

write.table(z,"Results/Aparc_SurfArea.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE) # Writing it to the csv file created
