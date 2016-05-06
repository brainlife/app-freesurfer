#################################################################################
######### Extract Data from Aparc - FoldInd for all the subjects ################
              ######### Freesurfer 5.3 version ###############
                        ## Pratik Gandhi ## 

### Define the base directory
#i<-0

### Writing the column names and writing it to a csv file
colnames<-c("subjectid","Left_bankssts_FoldInd","Right_bankssts_FoldInd","Left_caudalanteriorcingulate_FoldInd","Right_caudalanteriorcingulate_FoldInd","Left_caudalmiddlefrontal_FoldInd","Right_caudalmiddlefrontal_FoldInd","Left_cuneus_FoldInd","Right_cuneus_FoldInd","Left_entorhinal_FoldInd","Right_entorhinal_FoldInd","Left_fusiform_FoldInd","Right_fusiform_FoldInd","Left_inferiorparietal_FoldInd","Right_inferiorparietal_FoldInd","Left_inferiortemporal_FoldInd","Right_inferiortemporal_FoldInd","Left_isthmuscingulate_FoldInd","Right_isthmuscingulate_FoldInd","Left_lateraloccipital_FoldInd","Right_lateraloccipital_FoldInd","Left_lateralorbitofrontal_FoldInd","Right_lateralorbitofrontal_FoldInd","Left_lingual_FoldInd","Right_lingual_FoldInd","Left_medialorbitofrontal_FoldInd","Right_medialorbitofrontal_FoldInd","Left_middletemporal_FoldInd","Right_middletemporal_FoldInd","Left_parahippocampal_FoldInd","Right_parahippocampal_FoldInd","Left_paracentral_FoldInd","Right_paracentral_FoldInd","Left_parsopercularis_FoldInd","Right_parsopercularis_FoldInd","Left_parsorbitalis_FoldInd","Right_parsorbitalis_FoldInd","Left_parstriangularis_FoldInd","Right_parstriangularis_FoldInd","Left_pericalcarine_FoldInd","Right_pericalcarine_FoldInd","Left_postcentral_FoldInd","Right_postcentral_FoldInd","Left_posteriorcingulate_FoldInd","Right_posteriorcingulate_FoldInd","Left_precentral_FoldInd","Right_precentral_FoldInd","Left_precuneus_FoldInd","Right_precuneus_FoldInd","Left_rostralanteriorcingulate_FoldInd","Right_rostralanteriorcingulate_FoldInd","Left_rostralmiddlefrontal_FoldInd","Right_rostralmiddlefrontal_FoldInd","Left_superiorfrontal_FoldInd","Right_superiorfrontal_FoldInd","Left_superiorparietal_FoldInd","Right_superiorparietal_FoldInd","Left_superiortemporal_FoldInd","Right_superiortemporal_FoldInd","Left_supramarginal_FoldInd","Right_supramarginal_FoldInd","Left_frontalpole_FoldInd","Right_frontalpole_FoldInd","Left_temporalpole_FoldInd","Right_temporalpole_FoldInd","Left_transversetemporal_FoldInd","Right_transversetemporal_FoldInd","Left_insula_FoldInd","Right_insula_FoldInd")
colnames<-t(colnames)
write.table(colnames,"Results/Aparc_FoldInd.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

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
subjectid<-split[length(split)]    # Getting the subjectid for the respective subject

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

# Getting the column (Fold-Ind) we are interested
table_values_lh<-data.frame(table_lh[,c("V9")])
table_values_rh<-data.frame(table_rh[,c("V9")])

tot_table <- data.frame(table_values_lh,table_values_rh)  # Combining both the values of LH and RH after matching with the template

ext<-data.frame(matrix(ncol = 1,nrow = 1))

for (k in 1:nrow(tot_table)){
ind_row <- tot_table[k,]
ext <- cbind(ext,ind_row)
}

ext[,1] <- NULL
    
sub_id<-data.frame(subjectid)
    
z<-cbind(sub_id,ext)  # Combining the values and the subjectid, putting in one data frame
    
    
write.table(z,"Results/Aparc_FoldInd.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE) # Writing it to the csv file created
