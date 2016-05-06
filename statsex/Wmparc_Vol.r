#################################################################################
############ Extract Data from Wmparc - Vol for all the subjects ################
              ######### Freesurfer 5.3 version ###############
                          ## Pratik Gandhi ## 

### Define the base directory

# Writing the column names and writing it to a csv file
colnames<-c("subjectid","lhCorticalWhiteMatterVol","rhCorticalWhiteMatterVol","CorticalWhiteMatterVol","MaskVol","EstimatedTotalICV","Wm_lh_bankssts_Vol","Wm_rh_bankssts_Vol","Wm_lh_caudalanteriorcingulate_Vol","Wm_rh_caudalanteriorcingulate_Vol","Wm_lh_caudalmiddlefrontal_Vol","Wm_rh_caudalmiddlefrontal_Vol","Wm_lh_cuneus_Vol","Wm_rh_cuneus_Vol","Wm_lh_entorhinal_Vol","Wm_rh_entorhinal_Vol","Wm_lh_fusiform_Vol","Wm_rh_fusiform_Vol","Wm_lh_inferiorparietal_Vol","Wm_rh_inferiorparietal_Vol","Wm_lh_inferiortemporal_Vol","Wm_rh_inferiortemporal_Vol","Wm_lh_isthmuscingulate_Vol","Wm_rh_isthmuscingulate_Vol","Wm_lh_lateraloccipital_Vol","Wm_rh_lateraloccipital_Vol","Wm_lh_lateralorbitofrontal_Vol","Wm_rh_lateralorbitofrontal_Vol","Wm_lh_lingual_Vol","Wm_rh_lingual_Vol","Wm_lh_medialorbitofrontal_Vol","Wm_rh_medialorbitofrontal_Vol","Wm_lh_middletemporal_Vol","Wm_rh_middletemporal_Vol","Wm_lh_parahippocampal_Vol","Wm_rh_parahippocampal_Vol","Wm_lh_paracentral_Vol","Wm_rh_paracentral_Vol","Wm_lh_parsopercularis_Vol","Wm_rh_parsopercularis_Vol","Wm_lh_parsorbitalis_Vol","Wm_rh_parsorbitalis_Vol","Wm_lh_parstriangularis_Vol","Wm_rh_parstriangularis_Vol","Wm_lh_pericalcarine_Vol","Wm_rh_pericalcarine_Vol","Wm_lh_postcentral_Vol","Wm_rh_postcentral_Vol","Wm_lh_posteriorcingulate_Vol","Wm_rh_posteriorcingulate_Vol","Wm_lh_precentral_Vol","Wm_rh_precentral_Vol","Wm_lh_precuneus_Vol","Wm_rh_precuneus_Vol","Wm_lh_rostralanteriorcingulate_Vol","Wm_rh_rostralanteriorcingulate_Vol","Wm_lh_rostralmiddlefrontal_Vol","Wm_rh_rostralmiddlefrontal_Vol","Wm_lh_superiorfrontal_Vol","Wm_rh_superiorfrontal_Vol","Wm_lh_superiorparietal_Vol","Wm_rh_superiorparietal_Vol","Wm_lh_superiortemporal_Vol","Wm_rh_superiortemporal_Vol","Wm_lh_supramarginal_Vol","Wm_rh_supramarginal_Vol","Wm_lh_frontalpole_Vol","Wm_rh_frontalpole_Vol","Wm_lh_temporalpole_Vol","Wm_rh_temporalpole_Vol","Wm_lh_transversetemporal_Vol","Wm_rh_transversetemporal_Vol","Wm_lh_insula_Vol","Wm_rh_insula_Vol","Left_UnsegmentedWhiteMatter_IntMax","Right_UnsegmentedWhiteMatter_IntMax")
colnames<-t(colnames)
write.table(colnames,"Results/Wmparc_Vol.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
local_files <- list.files(temp_dir)
base_file <- local_files[grepl("wmparc.stats$",local_files)]
table_base<- read.table(base_file)

### Again directing to the base directory
allfiles<-list.files(,recursive=TRUE)
wmp<-allfiles[grepl("wmparc.stats$",allfiles)] # Reading the wmparc file

### Reading all the lines of a file ###
linn<-readLines(wmp)

split <- strsplit(linn[13], " ")[[1]]
subjectid<-split[length(split)]

split <- strsplit(linn[14], " ")[[1]]
p1_value<-split[length(split)-1]
p1_value<-substr(p1_value, 1, nchar(p1_value)-1)

split <- strsplit(linn[15], " ")[[1]]
p2_value<-split[length(split)-1]
p2_value<-substr(p2_value, 1, nchar(p2_value)-1)

split <- strsplit(linn[16], " ")[[1]]
p3_value<-split[length(split)-1]
p3_value<-substr(p3_value, 1, nchar(p3_value)-1)
  
split <- strsplit(linn[17], " ")[[1]]
p4_value<-split[length(split)-1]
p4_value<-substr(p4_value, 1, nchar(p4_value)-1)
    
split <- strsplit(linn[18], " ")[[1]]
p5_value<-split[length(split)-1]
p5_value<-substr(p5_value, 1, nchar(p5_value)-1)

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

table_values_lh<-data.frame(table[c(1:34),c("V4")])
table_values_rh<-data.frame(table[c(35:68),c("V4")])
tot_table <- data.frame(table_values_lh,table_values_rh)

ext<-data.frame(matrix(ncol = 1,nrow = 1))

for (k in 1:nrow(tot_table)){
  ind_row <- tot_table[k,]
  ext <- cbind(ext,ind_row)
}

ext[,1] <- NULL

table_values_rem<-data.frame(table[c(69:70),c("V4")])
table_values_rem <- t(table_values_rem)
ext <- cbind(ext,table_values_rem)

all_values<-c(subjectid,p1_value,p2_value,p3_value,p4_value,p5_value)

combined<-data.frame(all_values)

combined <- t(combined)

z<-cbind(combined,ext)

write.table(z,"Results/Wmparc_Vol.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

