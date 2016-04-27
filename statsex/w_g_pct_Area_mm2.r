#################################################################################
########## Extract Data from W_G_PCT - Area_mm2 for all the subjects ###########
              ######### Freesurfer 5.3 version ###############
                          ## Pratik Gandhi ## 

### Define the base directory
i<-0
setwd(basedir)
dir.create("Results")
dirs <- list.dirs(path=basedir, full.names=TRUE, recursive=FALSE) # List the directories

# Writing the column names and writing it to a csv file
colnames<-c("subjectid","Left_bakssts_Area_mm2","Right_bankssts_Area_mm2","Left_caudalanteriorcingulate_Area_mm2","Right_caudalanteriorcingulate_Area_mm2","Left_caudalmiddlefrontal_Area_mm2","Right_caudalmiddlefrontal_Area_mm2","Left_cuneus_Area_mm2","Right_cuneus_Area_mm2","Left_entorhinal_Area_mm2","Right_entorhinal_Area_mm2","Left_fusiform_Area_mm2","Right_fusiform_Area_mm2","Left_inferiorparietal_Area_mm2","Right_inferiorparietal_Area_mm2","Left_inferiortemporal_Area_mm2","Right_inferiortemporal_Area_mm2","Left_isthmuscingulate_Area_mm2","Right_isthmuscingulate_Area_mm2","Left_lateraloccipital_Area_mm2","Right_lateraloccipital_Area_mm2","Left_lateralorbitofrontal_Area_mm2","Right_lateralorbitofrontal_Area_mm2","Left_lingual_Area_mm2","Right_lingual_Area_mm2","Left_medialorbitofrontal_Area_mm2","Right_medialorbitofrontal_Area_mm2","Left_middletemporal_Area_mm2","Right_middletemporal_Area_mm2","Left_parahippocampal_Area_mm2","Right_parahippocampal_Area_mm2","Left_paracentral_Area_mm2","Right_paracentral_Area_mm2","Left_paropercularis_Area_mm2","Right_paropercularis_Area_mm2","Left_parsorbitals_Area_mm2","Right_parsorbitals_Area_mm2","Left_parstriangularis_Area_mm2","Right_parstriangularis_Area_mm2","Left_pericalcarine_Area_mm2","Right_pericalcarine_Area_mm2","Left_postcentral_Area_mm2","Right_postcentral_Area_mm2","Left_posteriorcingulate_Area_mm2","Right_posteriorcingulate_Area_mm2","Left_precentral_Area_mm2","Right_precentral_Area_mm2","Left_precuneus_Area_mm2","Right_precuneus_Area_mm2","Left_rostralanteriorcingulate_Area_mm2","Right_rostralanteriorcingulate_Area_mm2","Left_rostralmiddlefrontal_Area_mm2","Right_rostralmiddlefrontal_Area_mm2","Left_superiorfrontal_Area_mm2","Right_superiorfrontal_Area_mm2","Left_superiorparietal_Area_mm2","Right_superiorparietal_Area_mm2","Left_superiortemporal_Area_mm2","Right_superiortemporal_Area_mm2","Left_supramarginal_Area_mm2","Right_supramarginal_Area_mm2","Left_frontalpole_Area_mm2","Right_frontalpole_Area_mm2","Left_temporalpole_Area_mm2","Right_temporalpole_Area_mm2","Left_transversetemporal_Area_mm2","Right_transversetemporal_Area_mm2","Left_insula_Area_mm2","Right_insula_Area_mm2")
colnames<-t(colnames)
write.table(colnames,"Results/W_G_PCT_Area_mm2.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
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
    
    table_lh <- merge(x=table_W_G_PCTse,y=table_lh, all.x = TRUE ) # Doing for LH
    table_lh <- table_lh[match(table_base[,1],table_lh[,1]),]
    table_lh <- as.matrix(table_lh)
    table_lh[is.na(table_lh)] <- 0
    
    table_rh <- merge(x=table_W_G_PCTse,y=table_rh, all.x = TRUE ) # Doing for RH
    table_rh <- table_rh[match(table_base[,1],table_rh[,1]),]
    table_rh <- as.matrix(table_rh)
    table_rh[is.na(table_lh)] <- 0
    
    # Converting W_G_PCTck to data frame
    table_lh <- as.data.frame(table_lh)
    table_rh <- as.data.frame(table_rh)
    
    table_values_lh<-data.frame(table_lh[,c("V4")])
    table_values_rh<-data.frame(table_rh[,c("V4")])
    
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
    write.table(z,"Results/W_G_PCT_Area_mm2.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)  # Writing it to the csv file created
}
setwd(basedir)
