#################################################################################
########### Extract Data from Aseg - IntMax for all the subjects ################
              ######### Freesurfer 5.3 version ###############
                            ## Pratik Gandhi ## 

### Define the base directory

### Writing the column names and writing it to a csv file
colnames<-c("subjectid","Left-Lateral-Ventricle_IntMax","Left-Inf-Lat-Vent_IntMax","Left-Cerebellum-White-Matter_IntMax","Left-Cerebellum-Cortex_IntMax","Left-Thalamus-Proper_IntMax","Left-Caudate_IntMax","Left-Putamen_IntMax","Left-Pallidum_IntMax","3rd-Ventricle_IntMax","4th-Ventricle_IntMax","Brain-Stem_IntMax","Left-Hippocampus_IntMax","Left-Amygdala_IntMax","CSF_IntMax","Left-Accumbens-area_IntMax","Left-VentralDC_IntMax","Left-vessel_IntMax","Left-choroid-plexus_IntMax","Right-Lateral-Ventricle_IntMax","Right-Inf-Lat-Vent_IntMax","Right-Cerebellum-White-Matter_IntMax","Right-Cerebellum-Cortex_IntMax","Right-Thalamus-Proper_IntMax","Right-Caudate_IntMax","Right-Putamen_IntMax","Right-Pallidum_IntMax","Right-Hippocampus_IntMax","Right-Amygdala_IntMax","Right-Accumbens-area_IntMax","Right-VentralDC_IntMax","Right-vessel_IntMax","Right-choroid-plexus_IntMax","5th-Ventricle","WM-hypointensities_IntMax","Left-WM-hypointensities_IntMax","Right-WM-hypointensities_IntMax","non-WM-hypointensities_IntMax","Left-non-WM-hypointensities_IntMax","Right-non-WM_intensities_IntMax","Optic-Chiasm_IntMax","CC_Posterior_IntMax","CC_Mid_Posterior_IntMax","CC_Central_IntMax","CC_Mid_Anterior_IntMax","CC_Anterior_IntMax")
colnames<-t(colnames)
write.table(colnames,"Results/Aseg_IntMax.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
local_files <- list.files(temp_dir)
base_file <- local_files[grepl("aseg.stats$",local_files)]
table_base<-read.table(paste(temp_dir,base_file,sep="/"))

allfiles<-list.files(,recursive=TRUE)
asegfile<-allfiles[grepl("aseg.stats$",allfiles)] # Reading the aseg file

### Reading all the lines of a file ###
linn<-readLines(asegfile)

split <- strsplit(linn[13], " ")[[1]]
subjectid<-split[length(split)]    # Getting the subjectid for the respective subject

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

table_values<-data.frame(table[,c("V9")])

x<-t(table_values)

all_values<-c(subjectid)

combined<-data.frame(all_values)

y<-t(combined)

z<-cbind(y,x)  # Combining the values and the subjectid, putting in one data frame

write.table(z,"Results/Aseg_IntMax.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)  # Writing it to the csv file created
