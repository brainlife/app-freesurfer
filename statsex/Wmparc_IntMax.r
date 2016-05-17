#################################################################################
########### Extract Data from Wmparc - IntMax for all the subjects #############
                ######### Freesurfer 5.3 version ###############
                          ## Pratik Gandhi ## 

### Define the base directory

# Writing the column names and writing it to a csv file
colnames<-c("subjectid","Wm_lh_bankssts_IntMax","Wm_rh_bankssts_IntMax","Wm_lh_caudalanteriorcingulate_IntMax","Wm_rh_caudalanteriorcingulate_IntMax","Wm_lh_caudalmiddlefrontal_IntMax","Wm_rh_caudalmiddlefrontal_IntMax","Wm_lh_cuneus_IntMax","Wm_rh_cuneus_IntMax","Wm_lh_entorhinal_IntMax","Wm_rh_entorhinal_IntMax","Wm_lh_fusiform_IntMax","Wm_rh_fusiform_IntMax","Wm_lh_inferiorparietal_IntMax","Wm_rh_inferiorparietal_IntMax","Wm_lh_inferiortemporal_IntMax","Wm_rh_inferiortemporal_IntMax","Wm_lh_isthmuscingulate_IntMax","Wm_rh_isthmuscingulate_IntMax","Wm_lh_lateraloccipital_IntMax","Wm_rh_lateraloccipital_IntMax","Wm_lh_lateralorbitofrontal_IntMax","Wm_rh_lateralorbitofrontal_IntMax","Wm_lh_lingual_IntMax","Wm_rh_lingual_IntMax","Wm_lh_medialorbitofrontal_IntMax","Wm_rh_medialorbitofrontal_IntMax","Wm_lh_middletemporal_IntMax","Wm_rh_middletemporal_IntMax","Wm_lh_parahippocampal_IntMax","Wm_rh_parahippocampal_IntMax","Wm_lh_paracentral_IntMax","Wm_rh_paracentral_IntMax","Wm_lh_parsopercularis_IntMax","Wm_rh_parsopercularis_IntMax","Wm_lh_parsorbitalis_IntMax","Wm_rh_parsorbitalis_IntMax","Wm_lh_parstriangularis_IntMax","Wm_rh_parstriangularis_IntMax","Wm_lh_pericalcarine_IntMax","Wm_rh_pericalcarine_IntMax","Wm_lh_postcentral_IntMax","Wm_rh_postcentral_IntMax","Wm_lh_posteriorcingulate_IntMax","Wm_rh_posteriorcingulate_IntMax","Wm_lh_precentral_IntMax","Wm_rh_precentral_IntMax","Wm_lh_precuneus_IntMax","Wm_rh_precuneus_IntMax","Wm_lh_rostralanteriorcingulate_IntMax","Wm_rh_rostralanteriorcingulate_IntMax","Wm_lh_rostralmiddlefrontal_IntMax","Wm_rh_rostralmiddlefrontal_IntMax","Wm_lh_superiorfrontal_IntMax","Wm_rh_superiorfrontal_IntMax","Wm_lh_superiorparietal_IntMax","Wm_rh_superiorparietal_IntMax","Wm_lh_superiortemporal_IntMax","Wm_rh_superiortemporal_IntMax","Wm_lh_supramarginal_IntMax","Wm_rh_supramarginal_IntMax","Wm_lh_frontalpole_IntMax","Wm_rh_frontalpole_IntMax","Wm_lh_temporalpole_IntMax","Wm_rh_temporalpole_IntMax","Wm_lh_transversetemporal_IntMax","Wm_rh_transversetemporal_IntMax","Wm_lh_insula_IntMax","Wm_rh_insula_IntMax","Left_UnsegmentedWhiteMatter_IntMax","Right_UnsegmentedWhiteMatter_IntMax")
colnames<-t(colnames)
write.table(colnames,"Results/Wmparc_IntMax.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
local_files <- list.files(temp_dir)
base_file <- local_files[grepl("wmparc.stats$",local_files)]
table_base<-read.table(paste(temp_dir,base_file,sep="/"))

### Again directing to the base directory
allfiles<-list.files(,recursive=TRUE)
wmp<-allfiles[grepl("wmparc.stats$",allfiles)] # Reading the wmparc file

### Reading all the lines of a file ###
linn<-readLines(wmp)

split <- strsplit(linn[13], " ")[[1]]
subjectid<-split[length(split)]   # Getting the subject id for the respective subject

table<-read.table(wmp)

# Converting them to matrix form for matching to template and inserting the missing values
table <- as.matrix(table)
table_base_mod <- table_base[,c(5,2,3,4,1,6:10)]
table_base_mod <- as.matrix(table_base_mod[,1])
colnames(table_base_mod) <- c("V5")

table <- merge(x=table_base_mod,y=table, all.x = TRUE ) 
table <- table[match(table_base_mod[,1],table[,1]),]
table <- as.matrix(table)
table[is.na(table)] <- 0

# Converting back to data frame
table <- as.data.frame(table)

table_values_lh<-data.frame(table[c(1:34),c("V9")])
table_values_rh<-data.frame(table[c(35:68),c("V9")])
tot_table <- data.frame(table_values_lh,table_values_rh)

ext<-data.frame(matrix(ncol = 1,nrow = 1))

for (k in 1:nrow(tot_table)){
  ind_row <- tot_table[k,]
  ext <- cbind(ext,ind_row)
}

ext[,1] <- NULL

table_values_rem<-data.frame(table[c(69:70),c("V9")])
table_values_rem <- t(table_values_rem)
ext <- cbind(ext,table_values_rem)

all_values<-c(subjectid)

combined<-data.frame(all_values)

combined <- t(combined)

z<-cbind(combined,ext)

write.table(z,"Results/Wmparc_IntMax.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE) # Writing it to the csv file created

