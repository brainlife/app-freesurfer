#################################################################################
########## Extract Data from Aparc - ThickStd for all the subjects ##############
              ######### Freesurfer 5.3 version #############
                         ## Pratik Gandhi ## 

### Define the base directory
i<-0
setwd(basedir)
dir.create("Results")
dirs <- list.dirs(path=basedir, full.names=TRUE, recursive=FALSE) # List the directories

### Writing the column names and writing it to a csv file
colnames<-c("subjectid","Left_bankssts_ThickStd","Right_bankssts_ThickStd","Left_caudalanteriorcingulate_ThickStd","Right_caudalanteriorcingulate_ThickStd","Left_caudalmiddlefrontal_ThickStd","Right_caudalmiddlefrontal_ThickStd","Left_cuneus_ThickStd","Right_cuneus_ThickStd","Left_entorhinal_ThickStd","Right_entorhinal_ThickStd","Left_fusiform_ThickStd","Right_fusiform_ThickStd","Left_inferiorparietal_ThickStd","Right_inferiorparietal_ThickStd","Left_inferiortemporal_ThickStd","Right_inferiortemporal_ThickStd","Left_isthmuscingulate_ThickStd","Right_isthmuscingulate_ThickStd","Left_lateraloccipital_ThickStd","Right_lateraloccipital_ThickStd","Left_lateralorbitofrontal_ThickStd","Right_lateralorbitofrontal_ThickStd","Left_lingual_ThickStd","Right_lingual_ThickStd","Left_medialorbitofrontal_ThickStd","Right_medialorbitofrontal_ThickStd","Left_middletemporal_ThickStd","Right_middletemporal_ThickStd","Left_parahippocampal_ThickStd","Right_parahippocampal_ThickStd","Left_paracentral_ThickStd","Right_paracentral_ThickStd","Left_parsopercularis_ThickStd","Right_parsopercularis_ThickStd","Left_parsorbitalis_ThickStd","Right_parsorbitalis_ThickStd","Left_parstriangularis_ThickStd","Right_parstriangularis_ThickStd","Left_pericalcarine_ThickStd","Right_pericalcarine_ThickStd","Left_postcentral_ThickStd","Right_postcentral_ThickStd","Left_posteriorcingulate_ThickStd","Right_posteriorcingulate_ThickStd","Left_precentral_ThickStd","Right_precentral_ThickStd","Left_precuneus_ThickStd","Right_precuneus_ThickStd","Left_rostralanteriorcingulate_ThickStd","Right_rostralanteriorcingulate_ThickStd","Left_rostralmiddlefrontal_ThickStd","Right_rostralmiddlefrontal_ThickStd","Left_superiorfrontal_ThickStd","Right_superiorfrontal_ThickStd","Left_superiorparietal_ThickStd","Right_superiorparietal_ThickStd","Left_superiortemporal_ThickStd","Right_superiortemporal_ThickStd","Left_supramarginal_ThickStd","Right_supramarginal_ThickStd","Left_frontalpole_ThickStd","Right_frontalpole_ThickStd","Left_temporalpole_ThickStd","Right_temporalpole_ThickStd","Left_transversetemporal_ThickStd","Right_transversetemporal_ThickStd","Left_insula_ThickStd","Right_insula_ThickStd")
colnames<-t(colnames)
write.table(colnames,"Results/Aparc_ThickStd.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
setwd(temp_dir)
local_files <- list.files(temp_dir)
base_file <- local_files[grepl("lh.aparc.stats$",local_files)]
table_base<-read.table(base_file)

### Again directing to the base directory
setwd(basedir)
length_dirs<- length(dirs)-1

### Getting inside the individual directories
for (i in 1:length_dirs){
    
  setwd(dirs[i]) # Setting to individual directory by looping over all
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
    table_values_lh<-data.frame(table_lh[,c("V6")])
    table_values_rh<-data.frame(table_rh[,c("V6")])
    
    tot_table <- data.frame(table_values_lh,table_values_rh) # Combining both the values of LH and RH after matching with the template
    
    ext<-data.frame(matrix(ncol = 1,nrow = 1))
    
    for (k in 1:nrow(tot_table)){
      ind_row <- tot_table[k,]
      ext <- cbind(ext,ind_row)
    }
    
    ext[,1] <- NULL
    
    sub_id<-data.frame(subjectid)
    
    z<-cbind(sub_id,ext)  # Combining the values and the subjectid, putting in one data frame
    
    setwd(basedir)
    write.table(z,"Results/Aparc_ThickStd.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE) # Writing it to the csv file created
    
}
setwd(basedir)
