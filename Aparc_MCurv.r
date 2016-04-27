#################################################################################
######### Extract Data from Aparc - MeanCurv for all the subjects ###############
              ######### Freesurfer 5.3 version ###############
                          ## Pratik Gandhi ## 

### Define the base directory
i<-0
setwd(basedir)
dir.create("Results")
dirs <- list.dirs(path=basedir, full.names=TRUE, recursive=FALSE) # List the directories

# Writing the column names and writing it to a csv file
colnames<-c("subjectid","Left_bankssts_MeanCurv ","Right_bankssts_MeanCurv ","Left_caudalanteriorcingulate_MeanCurv ","Right_caudalanteriorcingulate_MeanCurv ","Left_caudalmiddlefrontal_MeanCurv ","Right_caudalmiddlefrontal_MeanCurv ","Left_cuneus_MeanCurv ","Right_cuneus_MeanCurv ","Left_entorhinal_MeanCurv ","Right_entorhinal_MeanCurv ","Left_fusiform_MeanCurv ","Right_fusiform_MeanCurv ","Left_inferiorparietal_MeanCurv ","Right_inferiorparietal_MeanCurv ","Left_inferiortemporal_MeanCurv ","Right_inferiortemporal_MeanCurv ","Left_isthmuscingulate_MeanCurv ","Right_isthmuscingulate_MeanCurv ","Left_lateraloccipital_MeanCurv ","Right_lateraloccipital_MeanCurv ","Left_lateralorbitofrontal_MeanCurv ","Right_lateralorbitofrontal_MeanCurv ","Left_lingual_MeanCurv ","Right_lingual_MeanCurv ","Left_medialorbitofrontal_MeanCurv ","Right_medialorbitofrontal_MeanCurv ","Left_middletemporal_MeanCurv ","Right_middletemporal_MeanCurv ","Left_parahippocampal_MeanCurv ","Right_parahippocampal_MeanCurv ","Left_paracentral_MeanCurv ","Right_paracentral_MeanCurv ","Left_parsopercularis_MeanCurv ","Right_parsopercularis_MeanCurv ","Left_parsorbitalis_MeanCurv ","Right_parsorbitalis_MeanCurv ","Left_parstriangularis_MeanCurv ","Right_parstriangularis_MeanCurv ","Left_pericalcarine_MeanCurv ","Right_pericalcarine_MeanCurv ","Left_postcentral_MeanCurv ","Right_postcentral_MeanCurv ","Left_posteriorcingulate_MeanCurv ","Right_posteriorcingulate_MeanCurv ","Left_precentral_MeanCurv ","Right_precentral_MeanCurv ","Left_precuneus_MeanCurv ","Right_precuneus_MeanCurv ","Left_rostralanteriorcingulate_MeanCurv ","Right_rostralanteriorcingulate_MeanCurv ","Left_rostralmiddlefrontal_MeanCurv ","Right_rostralmiddlefrontal_MeanCurv ","Left_superiorfrontal_MeanCurv ","Right_superiorfrontal_MeanCurv ","Left_superiorparietal_MeanCurv ","Right_superiorparietal_MeanCurv ","Left_superiortemporal_MeanCurv ","Right_superiortemporal_MeanCurv ","Left_supramarginal_MeanCurv ","Right_supramarginal_MeanCurv ","Left_frontalpole_MeanCurv ","Right_frontalpole_MeanCurv ","Left_temporalpole_MeanCurv ","Right_temporalpole_MeanCurv ","Left_transversetemporal_MeanCurv ","Right_transversetemporal_MeanCurv ","Left_insula_MeanCurv ","Right_insula_MeanCurv ")
colnames<-t(colnames)
write.table(colnames,"Results/Aparc_MeanCurv.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
temp_dir <- "/home/pkgandhi/Templates_53"
setwd(temp_dir)
local_files <- list.files(temp_dir)
base_file <- local_files[grepl("lh.aparc.stats$",local_files)]
table_base<-read.table(base_file)

### Again directing to the base directory
setwd(basedir)
length_dirs<- length(dirs)-1

# Getting inside the individual directories
for (i in 1:length_dirs){
    
  setwd(dirs[i]) # Setting to individual directory by looping over all
  allfiles<-list.files(,recursive=TRUE)
  lhaparc<-allfiles[grepl("lh.aparc.stats$",allfiles)] # Reading the lh-aparc file
  rhaparc<-allfiles[grepl("rh.aparc.stats$",allfiles)] # Reading the rh-aparc file
  
        linn_lh<-readLines(lhaparc)
        linn_rh<-readLines(rhaparc)
    
    split <- strsplit(linn_lh[15], " ")[[1]]
    subjectid<-split[length(split)]    # Getting the subject id for the respective subject

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
    
    # Getting the column (Means-Curv) we are interested
    table_values_lh<-data.frame(table_lh[,c("V7")])
    table_values_rh<-data.frame(table_rh[,c("V7")])
    
    tot_table <- data.frame(table_values_lh,table_values_rh)  # Combining both the values of LH and RH after matching with the template
    
    ext<-data.frame(matrix(ncol = 1,nrow = 1))
    
    for (k in 1:nrow(tot_table)){
      ind_row <- tot_table[k,]
      ext <- cbind(ext,ind_row)
    }
    
    ext[,1] <- NULL
    
    sub_id<-data.frame(subjectid)
    
    z<-cbind(sub_id,ext)  # Combining the values and the subjectid, putting in one data frame
    
    setwd(basedir)
    write.table(z,"Results/Aparc_MeanCurv.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)
}
setwd(basedir)
