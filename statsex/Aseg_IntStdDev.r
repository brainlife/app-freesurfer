#################################################################################
######### Extract Data from Aseg - IntStdDev for all the subjects ###############
             ######### Freesurfer 5.3 version ###############
                          ## Pratik Gandhi ## 

### Define the base directory

### Writing the column names and writing it to a csv file
colnames<-c("subjectid","Left-Lateral-Ventricle_IntStd","Left-Inf-Lat-Vent_IntStd","Left-Cerebellum-White-Matter_IntStd","Left-Cerebellum-Cortex_IntStd","Left-Thalamus-Proper_IntStd","Left-Caudate_IntStd","Left-Putamen_IntStd","Left-Pallidum_IntStd","3rd-Ventricle_IntStd","4th-Ventricle_IntStd","Brain-Stem_IntStd","Left-Hippocampus_IntStd","Left-Amygdala_IntStd","CSF_IntStd","Left-Accumbens-area_IntStd","Left-VentralDC_IntStd","Left-vessel_IntStd","Left-choroid-plexus_IntStd","Right-Lateral-Ventricle_IntStd","Right-Inf-Lat-Vent_IntStd","Right-Cerebellum-White-Matter_IntStd","Right-Cerebellum-Cortex_IntStd","Right-Thalamus-Proper_IntStd","Right-Caudate_IntStd","Right-Putamen_IntStd","Right-Pallidum_IntStd","Right-Hippocampus_IntStd","Right-Amygdala_IntStd","Right-Accumbens-area_IntStd","Right-VentralDC_IntStd","Right-vessel_IntStd","Right-choroid-plexus_IntStd","5th-Ventricle","WM-hypointensities_IntStd","Left-WM-hypointensities_IntStd","Right-WM-hypointensities_IntStd","non-WM-hypointensities_IntStd","Left-non-WM-hypointensities_IntStd","Right-non-WM_intensities_IntStd","Optic-Chiasm_IntStd","CC_Posterior_IntStd","CC_Mid_Posterior_IntStd","CC_Central_IntStd","CC_Mid_Anterior_IntStd","CC_Anterior_IntStd")
colnames<-t(colnames)
write.table(colnames,"Results/Aseg_IntStd.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
local_files <- list.files(temp_dir)
base_file <- local_files[grepl("aseg.stats$",local_files)]
table_base<-read.table(base_file) 

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

table_values<-data.frame(table[,c("V7")])

x<-t(table_values)

all_values<-c(subjectid)

combined<-data.frame(all_values)

y<-t(combined)

z<-cbind(y,x)

write.table(z,"Results/Aseg_IntStd.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

