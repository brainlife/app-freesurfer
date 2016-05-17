#################################################################################
######### Extract Data from Aparc - GausVol for all the subjects ###############
            ######### Freesurfer 5.3 version ###############
                        ## Pratik Gandhi ## 

### Define the base directory

# Writing the column names and writing it to a csv file
colnames<-c("subjectid","Left_bankssts_GrayVol","Right_bankssts_GrayVol","Left_caudalanteriorcingulate_GrayVol","Right_caudalanteriorcingulate_GrayVol","Left_caudalmiddlefrontal_GrayVol","Right_caudalmiddlefrontal_GrayVol","Left_cuneus_GrayVol","Right_cuneus_GrayVol","Left_entorhinal_GrayVol","Right_entorhinal_GrayVol","Left_fusiform_GrayVol","Right_fusiform_GrayVol","Left_inferiorparietal_GrayVol","Right_inferiorparietal_GrayVol","Left_inferiortemporal_GrayVol","Right_inferiortemporal_GrayVol","Left_isthmuscingulate_GrayVol","Right_isthmuscingulate_GrayVol","Left_lateraloccipital_GrayVol","Right_lateraloccipital_GrayVol","Left_lateralorbitofrontal_GrayVol","Right_lateralorbitofrontal_GrayVol","Left_lingual_GrayVol","Right_lingual_GrayVol","Left_medialorbitofrontal_GrayVol","Right_medialorbitofrontal_GrayVol","Left_middletemporal_GrayVol","Right_middletemporal_GrayVol","Left_parahippocampal_GrayVol","Right_parahippocampal_GrayVol","Left_paracentral_GrayVol","Right_paracentral_GrayVol","Left_parsopercularis_GrayVol","Right_parsopercularis_GrayVol","Left_parsorbitalis_GrayVol","Right_parsorbitalis_GrayVol","Left_parstriangularis_GrayVol","Right_parstriangularis_GrayVol","Left_pericalcarine_GrayVol","Right_pericalcarine_GrayVol","Left_postcentral_GrayVol","Right_postcentral_GrayVol","Left_posteriorcingulate_GrayVol","Right_posteriorcingulate_GrayVol","Left_precentral_GrayVol","Right_precentral_GrayVol","Left_precuneus_GrayVol","Right_precuneus_GrayVol","Left_rostralanteriorcingulate_GrayVol","Right_rostralanteriorcingulate_GrayVol","Left_rostralmiddlefrontal_GrayVol","Right_rostralmiddlefrontal_GrayVol","Left_superiorfrontal_GrayVol","Right_superiorfrontal_GrayVol","Left_superiorparietal_GrayVol","Right_superiorparietal_GrayVol","Left_superiortemporal_GrayVol","Right_superiortemporal_GrayVol","Left_supramarginal_GrayVol","Right_supramarginal_GrayVol","Left_frontalpole_GrayVol","Right_frontalpole_GrayVol","Left_temporalpole_GrayVol","Right_temporalpole_GrayVol","Left_transversetemporal_GrayVol","Right_transversetemporal_GrayVol","Left_insula_GrayVol","Right_insula_GrayVol")
colnames<-t(colnames)
write.table(colnames,"Results/Aparc_GrayVol.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

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
subjectid<-split[length(split)]     # Getting the subject id for the respective subject

# Reading the table for both left and right hemispheres 
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

# Getting the column (Gauss-Vol) we are interested
table_values_lh<-data.frame(table_lh[,c("V4")])
table_values_rh<-data.frame(table_rh[,c("V4")])

tot_table <- data.frame(table_values_lh,table_values_rh)  # Combining both the values of LH and RH after matching with the template

ext<-data.frame(matrix(ncol = 1,nrow = 1))

for (k in 1:nrow(tot_table)){
	ind_row <- tot_table[k,]
	ext <- cbind(ext,ind_row)
}

ext[,1] <- NULL

sub_id<-data.frame(subjectid)

z<-cbind(sub_id,ext) # Combining the values and the subjectid, putting in one data frame

write.table(z,"Results/Aparc_GrayVol.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE) # Writing it to the csv file created
