#################################################################################
########### Extract Data from Aseg - IntMin for all the subjects ################
              ########## Freesurfer 5.3 version ###############
                          ## Pratik Gandhi ## 

### Define the base directory

### Writing the column names and writing it to a csv file
colnames<-c("subjectid","Left-Lateral-Ventricle_IntMin","Left-Inf-Lat-Vent_IntMin","Left-Cerebellum-White-Matter_IntMin","Left-Cerebellum-Cortex_IntMin","Left-Thalamus-Proper_IntMin","Left-Caudate_IntMin","Left-Putamen_IntMin","Left-Pallidum_IntMin","3rd-Ventricle_IntMin","4th-Ventricle_IntMin","Brain-Stem_IntMin","Left-Hippocampus_IntMin","Left-Amygdala_IntMin","CSF_IntMin","Left-Accumbens-area_IntMin","Left-VentralDC_IntMin","Left-vessel_IntMin","Left-choroid-plexus_IntMin","Right-Lateral-Ventricle_IntMin","Right-Inf-Lat-Vent_IntMin","Right-Cerebellum-White-Matter_IntMin","Right-Cerebellum-Cortex_IntMin","Right-Thalamus-Proper_IntMin","Right-Caudate_IntMin","Right-Putamen_IntMin","Right-Pallidum_IntMin","Right-Hippocampus_IntMin","Right-Amygdala_IntMin","Right-Accumbens-area_IntMin","Right-VentralDC_IntMin","Right-vessel_IntMin","Right-choroid-plexus_IntMin","5th-Ventricle","WM-hypointensities_IntMin","Left-WM-hypointensities_IntMin","Right-WM-hypointensities_IntMin","non-WM-hypointensities_IntMin","Left-non-WM-hypointensities_IntMin","Right-non-WM_intensities_IntMin","Optic-Chiasm_IntMin","CC_Posterior_IntMin","CC_Mid_Posterior_IntMin","CC_Central_IntMin","CC_Mid_Anterior_IntMin","CC_Anterior_IntMin")
colnames<-t(colnames)
write.table(colnames,"Results/Aseg_IntMin.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
local_files <- list.files(temp_dir)
base_file <- local_files[grepl("aseg.stats$",local_files)]
table_base<-read.table(paste(temp_dir,base_file,sep="/"))

### Again directing to the base directory
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

table_values<-data.frame(table[,c("V8")])

x<-t(table_values)

all_values<-c(subjectid)

combined<-data.frame(all_values)

y<-t(combined)

z<-cbind(y,x)

write.table(z,"Results/Aseg_IntMin.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)
