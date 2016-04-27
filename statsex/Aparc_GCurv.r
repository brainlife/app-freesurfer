#################################################################################
######### Extract Data from Aparc - GausCurv for all the subjects ###############
              ######### Freesurfer 5.3 version ###############
                          ## Pratik Gandhi ## 

### Define the base directory
i<-0
setwd(basedir)
dir.create("Results")
dirs <- list.dirs(path=basedir, full.names=TRUE, recursive=FALSE) # List the directories

# Writing the column names and writing it to a csv file
colnames<-c("subjectid","Left_bankssts_GausCurv","Right_bankssts_GausCurv","Left_caudalanteriorcingulate_GausCurv","Right_caudalanteriorcingulate_GausCurv","Left_caudalmiddlefrontal_GausCurv","Right_caudalmiddlefrontal_GausCurv","Left_cuneus_GausCurv","Right_cuneus_GausCurv","Left_entorhinal_GausCurv","Right_entorhinal_GausCurv","Left_fusiform_GausCurv","Right_fusiform_GausCurv","Left_inferiorparietal_GausCurv","Right_inferiorparietal_GausCurv","Left_inferiortemporal_GausCurv","Right_inferiortemporal_GausCurv","Left_isthmuscingulate_GausCurv","Right_isthmuscingulate_GausCurv","Left_lateraloccipital_GausCurv","Right_lateraloccipital_GausCurv","Left_lateralorbitofrontal_GausCurv","Right_lateralorbitofrontal_GausCurv","Left_lingual_GausCurv","Right_lingual_GausCurv","Left_medialorbitofrontal_GausCurv","Right_medialorbitofrontal_GausCurv","Left_middletemporal_GausCurv","Right_middletemporal_GausCurv","Left_parahippocampal_GausCurv","Right_parahippocampal_GausCurv","Left_paracentral_GausCurv","Right_paracentral_GausCurv","Left_parsopercularis_GausCurv","Right_parsopercularis_GausCurv","Left_parsorbitalis_GausCurv","Right_parsorbitalis_GausCurv","Left_parstriangularis_GausCurv","Right_parstriangularis_GausCurv","Left_pericalcarine_GausCurv","Right_pericalcarine_GausCurv","Left_postcentral_GausCurv","Right_postcentral_GausCurv","Left_posteriorcingulate_GausCurv","Right_posteriorcingulate_GausCurv","Left_precentral_GausCurv","Right_precentral_GausCurv","Left_precuneus_GausCurv","Right_precuneus_GausCurv","Left_rostralanteriorcingulate_GausCurv","Right_rostralanteriorcingulate_GausCurv","Left_rostralmiddlefrontal_GausCurv","Right_rostralmiddlefrontal_GausCurv","Left_superiorfrontal_GausCurv","Right_superiorfrontal_GausCurv","Left_superiorparietal_GausCurv","Right_superiorparietal_GausCurv","Left_superiortemporal_GausCurv","Right_superiortemporal_GausCurv","Left_supramarginal_GausCurv","Right_supramarginal_GausCurv","Left_frontalpole_GausCurv","Right_frontalpole_GausCurv","Left_temporalpole_GausCurv","Right_temporalpole_GausCurv","Left_transversetemporal_GausCurv","Right_transversetemporal_GausCurv","Left_insula_GausCurv","Right_insula_GausCurv")
colnames<-t(colnames)
write.table(colnames,"Results/Aparc_GausCurv.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
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
    
    table_values_lh<-data.frame(table_lh[,c("V8")])
    table_values_rh<-data.frame(table_rh[,c("V8")])
    
    tot_table <- data.frame(table_values_lh,table_values_rh)
    
    ext<-data.frame(matrix(ncol = 1,nrow = 1))
    
    for (k in 1:nrow(tot_table)){
      ind_row <- tot_table[k,]
      ext <- cbind(ext,ind_row)
    }
    
    ext[,1] <- NULL
    
    sub_id<-data.frame(subjectid)
    
    z<-cbind(sub_id,ext) # Combining the values and the subjectid, putting in one data frame
    
    setwd(basedir)
    write.table(z,"Results/Aparc_GausCurv.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE) # Writing it to the csv file created
    
}
setwd(basedir)
