#################################################################################
########### Extract Data from Wmparc - IntMin for all the subjects #############
                ######### Freesurfer 5.3 version ###############
                            ## Pratik Gandhi ## 

### Define the base directory
i<-0
dir.create("Results")
dirs <- list.dirs(path=basedir, full.names=TRUE, recursive=FALSE) # List the directories

# Writing the column names and writing it to a csv file
colnames<-c("subjectid","Wm_lh_bankssts_IntMin","Wm_rh_bankssts_IntMin","Wm_lh_caudalanteriorcingulate_IntMin","Wm_rh_caudalanteriorcingulate_IntMin","Wm_lh_caudalmiddlefrontal_IntMin","Wm_rh_caudalmiddlefrontal_IntMin","Wm_lh_cuneus_IntMin","Wm_rh_cuneus_IntMin","Wm_lh_entorhinal_IntMin","Wm_rh_entorhinal_IntMin","Wm_lh_fusiform_IntMin","Wm_rh_fusiform_IntMin","Wm_lh_inferiorparietal_IntMin","Wm_rh_inferiorparietal_IntMin","Wm_lh_inferiortemporal_IntMin","Wm_rh_inferiortemporal_IntMin","Wm_lh_isthmuscingulate_IntMin","Wm_rh_isthmuscingulate_IntMin","Wm_lh_lateraloccipital_IntMin","Wm_rh_lateraloccipital_IntMin","Wm_lh_lateralorbitofrontal_IntMin","Wm_rh_lateralorbitofrontal_IntMin","Wm_lh_lingual_IntMin","Wm_rh_lingual_IntMin","Wm_lh_medialorbitofrontal_IntMin","Wm_rh_medialorbitofrontal_IntMin","Wm_lh_middletemporal_IntMin","Wm_rh_middletemporal_IntMin","Wm_lh_parahippocampal_IntMin","Wm_rh_parahippocampal_IntMin","Wm_lh_paracentral_IntMin","Wm_rh_paracentral_IntMin","Wm_lh_parsopercularis_IntMin","Wm_rh_parsopercularis_IntMin","Wm_lh_parsorbitalis_IntMin","Wm_rh_parsorbitalis_IntMin","Wm_lh_parstriangularis_IntMin","Wm_rh_parstriangularis_IntMin","Wm_lh_pericalcarine_IntMin","Wm_rh_pericalcarine_IntMin","Wm_lh_postcentral_IntMin","Wm_rh_postcentral_IntMin","Wm_lh_posteriorcingulate_IntMin","Wm_rh_posteriorcingulate_IntMin","Wm_lh_precentral_IntMin","Wm_rh_precentral_IntMin","Wm_lh_precuneus_IntMin","Wm_rh_precuneus_IntMin","Wm_lh_rostralanteriorcingulate_IntMin","Wm_rh_rostralanteriorcingulate_IntMin","Wm_lh_rostralmiddlefrontal_IntMin","Wm_rh_rostralmiddlefrontal_IntMin","Wm_lh_superiorfrontal_IntMin","Wm_rh_superiorfrontal_IntMin","Wm_lh_superiorparietal_IntMin","Wm_rh_superiorparietal_IntMin","Wm_lh_superiortemporal_IntMin","Wm_rh_superiortemporal_IntMin","Wm_lh_supramarginal_IntMin","Wm_rh_supramarginal_IntMin","Wm_lh_frontalpole_IntMin","Wm_rh_frontalpole_IntMin","Wm_lh_temporalpole_IntMin","Wm_rh_temporalpole_IntMin","Wm_lh_transversetemporal_IntMin","Wm_rh_transversetemporal_IntMin","Wm_lh_insula_IntMin","Wm_rh_insula_IntMin","Left_UnsegmentedWhiteMatter_IntMin","Right_UnsegmentedWhiteMatter_IntMin")
colnames<-t(colnames)
write.table(colnames,"Results/Wmparc_IntMin.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
temp_dir <- "/home/pkgandhi/Templates_53"
setwd(temp_dir)
local_files <- list.files(temp_dir)
base_file <- local_files[grepl("wmparc.stats$",local_files)]
table_base<- read.table(base_file)

### Again directing to the base directory
setwd(basedir)
length_dirs<- length(dirs)-1

# Getting inside the individual directories
for (j in 1:length_dirs){
  setwd(dirs[j])
  allfiles<-list.files(,recursive=TRUE)
  wmp<-allfiles[grepl("wmparc.stats$",allfiles)] # Reading the wmparc file
  
  ### Reading all the lines of a file ###
  linn<-readLines(wmp)

        split <- strsplit(linn[13], " ")[[1]]
        subjectid<-split[length(split)]

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
        
        table_values_lh<-data.frame(table[c(1:34),c("V8")])
        table_values_rh<-data.frame(table[c(35:68),c("V8")])
        tot_table <- data.frame(table_values_lh,table_values_rh)
        
        ext<-data.frame(matrix(ncol = 1,nrow = 1))
        
        for (k in 1:nrow(tot_table)){
          ind_row <- tot_table[k,]
          ext <- cbind(ext,ind_row)
        }
        
        ext[,1] <- NULL
      
        table_values_rem<-data.frame(table[c(69:70),c("V8")])
        table_values_rem <- t(table_values_rem)
        ext <- cbind(ext,table_values_rem)
  
    all_values<-c(subjectid)
    
    combined<-data.frame(all_values)
    
    combined <- t(combined)
  
    z<-cbind(combined,ext)
  
    setwd(basedir)
    write.table(z,"Results/Wmparc_IntMin.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)
  }
setwd(basedir)
