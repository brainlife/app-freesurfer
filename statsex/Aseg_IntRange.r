#################################################################################
######### Extract Data from Aseg - IntRange for all the subjects ################
            ########### Freesurfer 5.3 version ###############
                          ## Pratik Gandhi ## 

### Define the base directory

### Writing the column names and writing it to a csv file
colnames<-c("subjectid","Left-Lateral-Ventricle_IntRag","Left-Inf-Lat-Vent_IntRag","Left-Cerebellum-White-Matter_IntRag","Left-Cerebellum-Cortex_IntRag","Left-Thalamus-Proper_IntRag","Left-Caudate_IntRag","Left-Putamen_IntRag","Left-Pallidum_IntRag","3rd-Ventricle_IntRag","4th-Ventricle_IntRag","Brain-Stem_IntRag","Left-Hippocampus_IntRag","Left-Amygdala_IntRag","CSF_IntRag","Left-Accumbens-area_IntRag","Left-VentralDC_IntRag","Left-vessel_IntRag","Left-choroid-plexus_IntRag","Right-Lateral-Ventricle_IntRag","Right-Inf-Lat-Vent_IntRag","Right-Cerebellum-White-Matter_IntRag","Right-Cerebellum-Cortex_IntRag","Right-Thalamus-Proper_IntRag","Right-Caudate_IntRag","Right-Putamen_IntRag","Right-Pallidum_IntRag","Right-Hippocampus_IntRag","Right-Amygdala_IntRag","Right-Accumbens-area_IntRag","Right-VentralDC_IntRag","Right-vessel_IntRag","Right-choroid-plexus_IntRag","5th-Ventricle","WM-hypointensities_IntRag","Left-WM-hypointensities_IntRag","Right-WM-hypointensities_IntRag","non-WM-hypointensities_IntRag","Left-non-WM-hypointensities_IntRag","Right-non-WM_intensities_IntRag","Optic-Chiasm_IntRag","CC_Posterior_IntRag","CC_Mid_Posterior_IntRag","CC_Central_IntRag","CC_Mid_Anterior_IntRag","CC_Anterior_IntRag")
colnames<-t(colnames)
write.table(colnames,"Results/Aseg_IntRag.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
local_files <- list.files(temp_dir)
base_file <- local_files[grepl("aseg.stats$",local_files)]
table_base<-read.table(base_file) 

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

table_values<-data.frame(table[,c("V10")])

x<-t(table_values)

all_values<-c(subjectid)

combined<-data.frame(all_values)

y<-t(combined)

z<-cbind(y,x)

write.table(z,"Results/Aseg_IntRag.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)
