#################################################################################
########### Extract Data from W_G_PCT - Max for all the subjects #################
              ######### Freesurfer 5.3 version ###############
                          ## Pratik Gandhi ## 

### Define the base directory
i<-0
setwd(basedir)
dir.create("Results")
dirs <- list.dirs(path=basedir, full.names=TRUE, recursive=FALSE) # List the directories

# Writing the column names and writing it to a csv file
colnames<-c("subjectid","Left_bakssts_Max","Right_bankssts_Max","Left_caudalanteriorcingulate_Max","Right_caudalanteriorcingulate_Max","Left_caudalmiddlefrontal_Max","Right_caudalmiddlefrontal_Max","Left_cuneus_Max","Right_cuneus_Max","Left_entorhinal_Max","Right_entorhinal_Max","Left_fusiform_Max","Right_fusiform_Max","Left_inferiorparietal_Max","Right_inferiorparietal_Max","Left_inferiortemporal_Max","Right_inferiortemporal_Max","Left_isthmuscingulate_Max","Right_isthmuscingulate_Max","Left_lateraloccipital_Max","Right_lateraloccipital_Max","Left_lateralorbitofrontal_Max","Right_lateralorbitofrontal_Max","Left_lingual_Max","Right_lingual_Max","Left_medialorbitofrontal_Max","Right_medialorbitofrontal_Max","Left_middletemporal_Max","Right_middletemporal_Max","Left_parahippocampal_Max","Right_parahippocampal_Max","Left_paracentral_Max","Right_paracentral_Max","Left_paropercularis_Max","Right_paropercularis_Max","Left_parsorbitals_Max","Right_parsorbitals_Max","Left_parstriangularis_Max","Right_parstriangularis_Max","Left_pericalcarine_Max","Right_pericalcarine_Max","Left_postcentral_Max","Right_postcentral_Max","Left_posteriorcingulate_Max","Right_posteriorcingulate_Max","Left_precentral_Max","Right_precentral_Max","Left_precuneus_Max","Right_precuneus_Max","Left_rostralanteriorcingulate_Max","Right_rostralanteriorcingulate_Max","Left_rostralmiddlefrontal_Max","Right_rostralmiddlefrontal_Max","Left_superiorfrontal_Max","Right_superiorfrontal_Max","Left_superiorparietal_Max","Right_superiorparietal_Max","Left_superiortemporal_Max","Right_superiortemporal_Max","Left_supramarginal_Max","Right_supramarginal_Max","Left_frontalpole_Max","Right_frontalpole_Max","Left_temporalpole_Max","Right_temporalpole_Max","Left_transversetemporal_Max","Right_transversetemporal_Max","Left_insula_Max","Right_insula_Max")
colnames<-t(colnames)
write.table(colnames,"Results/W_G_PCT_Max.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
temp_dir <- "/home/pkgandhi/Freesurfer_data_extraction/Templates_53" 
setwd(temp_dir)
local_files <- list.files(temp_dir)
base_file <- local_files[grepl("rh.w-g.pct.stats$",local_files)]
table_base<- read.table(base_file)

### Again directing to the W_G_PCTse directory
setwd(basedir)
length_dirs<- length(dirs)-1

# Getting inside the individual directories
for (i in 1:length_dirs){
    
  setwd(dirs[i])
  allfiles<-list.files(,recursive=TRUE)
  lhW_G_PCT<-allfiles[grepl("lh.w-g.pct.stats$",allfiles)] # Reading the lh-W_G_PCT file
  rhW_G_PCT<-allfiles[grepl("rh.w-g.pct.stats$",allfiles)] # Reading the rh-W_G_PCT file

        linn_lh<-readLines(lhW_G_PCT)
        linn_rh<-readLines(rhW_G_PCT)
    
    split <- strsplit(linn_lh[13], " ")[[1]]
    subjectid<-split[length(split)]     # Getting the subject id for the respective subject

    table_lh<-read.table(lhW_G_PCT)
    table_rh<-read.table(rhW_G_PCT)
    
    # Converting them to matrix form for matching to template and inserting the missing values
    table_rh <- as.matrix(table_rh)
    table_lh <- as.matrix(table_lh)
    table_W_G_PCTse <- as.matrix(table_base[,1])
    
    table_lh <- merge(x=table_base,y=table_lh, all.x = TRUE ) # Doing for LH
    table_lh <- table_lh[match(table_base[,1],table_lh[,1]),]
    table_lh <- as.matrix(table_lh)
    table_lh[is.na(table_lh)] <- 0
    
    table_rh <- merge(x=table_base,y=table_rh, all.x = TRUE ) # Doing for RH
    table_rh <- table_rh[match(table_base[,1],table_rh[,1]),]
    table_rh <- as.matrix(table_rh)
    table_rh[is.na(table_lh)] <- 0
    
    # Converting W_G_PCTck to data frame
    table_lh <- as.data.frame(table_lh)
    table_rh <- as.data.frame(table_rh)
    
    table_values_lh<-data.frame(table_lh[,c("V9")])
    table_values_rh<-data.frame(table_rh[,c("V9")])
    
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
    write.table(z,"Results/W_G_PCT_Max.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)  # Writing it to the csv file created
}
setwd(basedir)
