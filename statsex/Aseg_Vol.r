#################################################################################
########### Extract Data from Aseg - IntMax for all the subjects ################
             ########## Freesurfer 5.3 version ###############
                        ## Pratik Gandhi ## 

### Define the base directory
i<-0
setwd(basedir)
dir.create("Results")
dirs <- list.dirs(path=basedir, full.names=TRUE, recursive=FALSE) # List the directories

### Writing the column names and writing it to a csv file
colnames<-c("subjectid","BrainSegVol","BrainSegVolNotVent","BrainSegVolNotVentSurf","lhCortexVol","rhCortexVol","CortexVol","lhCorticalWhiteMatterVol","rhCorticalWhiteMatterVol","CorticalWhiteMatterVol","SubCortGrayVol","TotalGrayVol","SupraTentorialVol","SupraTentorialVolNotVent","SupraTentorialVolNotVentVox","MaskVol","BrainSegVol-to-eTIV","MaskVol-to-eTIV","lhSurfaceHoles","rhSurfaceHoles","SurfaceHoles","eTIV","Left-Lateral-Ventricle_Vol","Left-Inf-Lat-Vent_Vol","Left-Cerebellum-White-Matter_Vol","Left-Cerebellum-Cortex_Vol","Left-Thalamus-Proper_Vol","Left-Caudate_Vol","Left-Putamen_Vol","Left-Pallidum_Vol","3rd-Ventricle_Vol","4th-Ventricle_Vol","Brain-Stem_Vol","Left-Hippocampus_Vol","Left-Amygdala_Vol","CSF_Vol","Left-Accumbens-area_Vol","Left-VentralDC_Vol","Left-vessel_Vol","Left-choroid-plexus_Vol","Right-Lateral-Ventricle_Vol","Right-Inf-Lat-Vent_Vol","Right-Cerebellum-White-Matter_Vol","Right-Cerebellum-Cortex_Vol","Right-Thalamus-Proper_Vol","Right-Caudate_Vol","Right-Putamen_Vol","Right-Pallidum_Vol","Right-Hippocampus_Vol","Right-Amygdala_Vol","Right-Accumbens-area_Vol","Right-VentralDC_Vol","Right-vessel_Vol","Right-choroid-plexus_Vol","5th-Ventricle","WM-hypointensities_Vol","Left-WM-hypointensities_Vol","Right-WM-hypointensities_Vol","non-WM-hypointensities_Vol","Left-non-WM-hypointensities_Vol","Right-non-WM_intensities_Vol","Optic-Chiasm_Vol","CC_Posterior_Vol","CC_Mid_Posterior_Vol","CC_Central_Vol","CC_Mid_Anterior_Vol","CC_Anterior_Vol")
colnames<-t(colnames)
write.table(colnames,"Results/Aseg_Vol.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
temp_dir <- "/home/pkgandhi/Templates_53"
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
            
        split <- strsplit(linn[19], " ")[[1]]
        p6_value<-split[length(split)-1]
        p6_value<-substr(p6_value, 1, nchar(p6_value)-1)
       
        split <- strsplit(linn[20], " ")[[1]]
        p7_value<-split[length(split)-1]
        p7_value<-substr(p7_value, 1, nchar(p7_value)-1)
          
        split <- strsplit(linn[21], " ")[[1]]
        p8_value<-split[length(split)-1]
        p8_value<-substr(p8_value, 1, nchar(p8_value)-1)
            
        split <- strsplit(linn[22], " ")[[1]]
        p9_value<-split[length(split)-1]
        p9_value<-substr(p9_value, 1, nchar(p9_value)-1)
        
        split <- strsplit(linn[23], " ")[[1]]
        p10_value<-split[length(split)-1]
        p10_value<-substr(p10_value, 1, nchar(p10_value)-1)

	split <- strsplit(linn[24], " ")[[1]]
	p11_value<-split[length(split)-1]
 	p11_value<-substr(p11_value, 1, nchar(p11_value)-1)

	split <- strsplit(linn[25], " ")[[1]]
	p12_value<-split[length(split)-1]
	p12_value<-substr(p12_value, 1, nchar(p12_value)-1)

	split <- strsplit(linn[26], " ")[[1]]
	p13_value<-split[length(split)-1]
	p13_value<-substr(p13_value, 1, nchar(p13_value)-1)

	split <- strsplit(linn[27], " ")[[1]]
	p14_value<-split[length(split)-1]
	p14_value<-substr(p14_value, 1, nchar(p14_value)-1)

	split <- strsplit(linn[28], " ")[[1]]
	p15_value<-split[length(split)-1]
	p15_value<-substr(p15_value, 1, nchar(p15_value)-1)

  	split <- strsplit(linn[29], " ")[[1]]
	p16_value<-split[length(split)-1]
	p16_value<-substr(p16_value, 1, nchar(p16_value)-1)

	split <- strsplit(linn[30], " ")[[1]]
	p17_value<-split[length(split)-1]
	p17_value<-substr(p17_value, 1, nchar(p17_value)-1)

	split <- strsplit(linn[31], " ")[[1]]
	p18_value<-split[length(split)-1]
	p18_value<-substr(p18_value, 1, nchar(p18_value)-1)

	split <- strsplit(linn[32], " ")[[1]]
	p19_value<-split[length(split)-1]
	p19_value<-substr(p19_value, 1, nchar(p19_value)-1)
	
	split <- strsplit(linn[33], " ")[[1]]
	p20_value<-split[length(split)-1]
	p20_value<-substr(p20_value, 1, nchar(p20_value)-1)

	split <- strsplit(linn[34], " ")[[1]]
	p21_value<-split[length(split)-1]
	p21_value<-substr(p21_value, 1, nchar(p21_value)-1)

        table<-read.table(asegfile)
        
        # Converting them to matrix form for matching to template and inserting the missing values
        #table <- table1[,c(5,2,3,4,1,6:10)]
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
        
        table_values<-data.frame(table[,c("V4")])
      
        x<-t(table_values)
  
    all_values<-c(subjectid,p1_value,p2_value,p3_value,p4_value,p5_value,p6_value,p7_value,p8_value,p9_value,p10_value,p11_value,p12_value,p13_value,p14_value,p15_value,p16_value,p17_value,p18_value,p19_value,p20_value,p21_value)
    
    combined<-data.frame(all_values)
    
    y<-t(combined)
  
    z<-cbind(y,x)
  
    setwd(basedir)
    write.table(z,"Results/Aseg_Vol.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)
}

setwd(basedir)

