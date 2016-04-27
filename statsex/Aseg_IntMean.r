#################################################################################
########### Extract Data from Aseg - IntMean for all the subjects ################
                ######### Freesurfer 5.3 version ###############
                            ## Pratik Gandhi ## 

### Define the base directory
i<-0
setwd(basedir)
dir.create("Results")
dirs <- list.dirs(path=basedir, full.names=TRUE, recursive=FALSE) # List the directories

### Writing the column names and writing it to a csv file
colnames<-c("subjectid","Left-Lateral-Ventricle_IntMean","Left-Inf-Lat-Vent_IntMean","Left-Cerebellum-White-Matter_IntMean","Left-Cerebellum-Cortex_IntMean","Left-Thalamus-Proper_IntMean","Left-Caudate_IntMean","Left-Putamen_IntMean","Left-Pallidum_IntMean","3rd-Ventricle_IntMean","4th-Ventricle_IntMean","Brain-Stem_IntMean","Left-Hippocampus_IntMean","Left-Amygdala_IntMean","CSF_IntMean","Left-Accumbens-area_IntMean","Left-VentralDC_IntMean","Left-vessel_IntMean","Left-choroid-plexus_IntMean","Right-Lateral-Ventricle_IntMean","Right-Inf-Lat-Vent_IntMean","Right-Cerebellum-White-Matter_IntMean","Right-Cerebellum-Cortex_IntMean","Right-Thalamus-Proper_IntMean","Right-Caudate_IntMean","Right-Putamen_IntMean","Right-Pallidum_IntMean","Right-Hippocampus_IntMean","Right-Amygdala_IntMean","Right-Accumbens-area_IntMean","Right-VentralDC_IntMean","Right-vessel_IntMean","Right-choroid-plexus_IntMean","5th-Ventricle","WM-hypointensities_IntMean","Left-WM-hypointensities_IntMean","Right-WM-hypointensities_IntMean","non-WM-hypointensities_IntMean","Left-non-WM-hypointensities_IntMean","Right-non-WM_intensities_IntMean","Optic-Chiasm_IntMean","CC_Posterior_IntMean","CC_Mid_Posterior_IntMean","CC_Central_IntMean","CC_Mid_Anterior_IntMean","CC_Anterior_IntMean")
colnames<-t(colnames)
write.table(colnames,"Results/Aseg_IntMean.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
setwd(temp_dir)
local_files <- list.files(temp_dir)
base_file <- local_files[grepl("aseg.stats$",local_files)]
table_base<-read.table(base_file)

### Again directing to the base directory
setwd(basedir)
length_dirs<- length(dirs)-1

### Running the loop to extract data from one file at a time and writing to a csv file ###
for (j in 1:length_dirs){
  setwd(dirs[j]) # Setting to individual directory by looping over all
  allfiles<-list.files(,recursive=TRUE)
  asegfile<-allfiles[grepl("aseg.stats$",allfiles)] # Reading the aseg file
  
  ### Reading all the lines of a file ###
  linn<-readLines(asegfile)

        split <- strsplit(linn[13], " ")[[1]]
        subjectid<-split[length(split)]
       
        table<-read.table(asegfile)
        
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
        
        table_values<-data.frame(table[,c("V6")])
      
        x<-t(table_values)
  
    all_values<-c(subjectid)
    
    combined<-data.frame(all_values)
    
    y<-t(combined)
  
    z<-cbind(y,x)
  
    setwd(basedir)
    write.table(z,"Results/Aseg_IntMean.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)
  }
setwd(basedir)
