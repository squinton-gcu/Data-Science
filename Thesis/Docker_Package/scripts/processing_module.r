library("MAI")
options(warn=-1)
ALZ_plasma <- read.table("application/ALZ_plasma.csv", header=TRUE, row.names = 1, sep =',')
ALZ_CSF <- read.table("application/ALZ_CSF2.csv", header=TRUE, row.names=1, sep=',')
trauma_human <- read.table("application/trauma_human.csv", header=TRUE, row.names=1, sep=',')
trauma_rat <- read.table("application/rat_stress.csv", header=TRUE, row.names=1, sep=',')

processing_step_impute <- function(Input_File) {
  #remove all metabolites with more than 70% missing values
  Input_File2 <- Input_File[, which(colMeans(!is.na(Input_File)) > 0.7)]
  # take care of missing values
  imputed_File <- MAI(Input_File2, 
					MCAR_algorithm = c("Multi_nsKNN"),
					MNAR_algorithm = c("nsKNN"),
					)
  imputed_File <- as.data.frame(imputed_File)
  row.names(imputed_File) = row.names(Input_File2)
  colnames(imputed_File) = colnames(Input_File2)
  if (ncol(Input_File2) != ncol(imputed_File)) {
    imputed_File2 <- imputed_File[1:(length(imputed_File)-(ncol(imputed_File) - ncol(Input_File2)))]
  }
  else {
    imputed_File2 = imputed_File
  }
  colnames(imputed_File2) = colnames(Input_File2)

  return(imputed_File2)
}

processing_step_normalize <- function(imputedFile) {
  # normalize with log2 and change NAs to zeros
  normalized_File <- as.data.frame(log2(imputedFile))
  normalized_File[is.na(normalized_File)] <- 0
  return(normalized_File)
}

processing_step_scale <- function(normalizedFile) {
  # Scale using the z scale function from R
  scale_File <- scale(t(normalizedFile))
  scale_File <- t(scale_File)
  return(scale_File)
}


# # will generate a few random initial exploratory graphs to ensure processing was successful
# graph_normalizeVSscale <- function(normalized_table, scale_table, table_name) {
  # png(paste("application/", table_name, "_scale1.png"))
  # scale1_hist <- hist(as.numeric(scale_table[1,]), main = paste("Histogram of " , table_name, "scale1"))
  # dev.off()
  # png(paste("application/", table_name, "_scale2.png"))
  # scale12_hist <- hist(as.numeric(scale_table[15,]), main = paste("Histogram of " , table_name, "scale2"))
  # dev.off()

  # png(paste("application/", table_name, "_normalized1.png"))
  # normalized1_hist <- hist(as.numeric(normalized_table[1,]), main = paste("Histogram of " , table_name, "normalized1"))
  # dev.off()
  # png(paste("application/", table_name, "_normalized2.png"))
  # normalized2_hist <- hist(as.numeric(normalized_table[15,]), main = paste("Histogram of " , table_name, "normalized2"))
  # dev.off()
# }

#outlier checker using IQR
outlier_checker <- function(normalized, name) {
  outlier_list = NULL
  options(warn=-1)
  for (x in 1:nrow(normalized)) {
    ALZ_Q3 <- quantile(normalized[x,], 0.75)
    ALZ_Q1<- quantile(normalized[x,], 0.21)
    ALZ_IQR <- IQR(normalized[x,])
    ALZ_outliers <-subset(normalized[x,], normalized[x,] > (as.numeric(ALZ_Q1 - 1.5*ALZ_IQR)) & normalized[x,] < (as.numeric(ALZ_Q3 + 1.5*ALZ_IQR)))
    ALZ_num_outliers <- length(ALZ_outliers[1,]) - ncol(normalized)
    outlier_list <- append(outlier_list, ALZ_num_outliers)
  }
  print(paste(name, " outlier list"))
  subset(outlier_list, outlier_list > 0)
}

ALZ_plasma_imputed <- processing_step_impute(ALZ_plasma)
ALZ_plasma_normalized <- processing_step_normalize(ALZ_plasma_imputed)
ALZ_plasma_scaled <- processing_step_scale(ALZ_plasma_normalized)

ALZ_csf_imputed <- processing_step_impute(ALZ_CSF)
ALZ_csf_normalized <- processing_step_normalize(ALZ_csf_imputed)
ALZ_csf_scaled <- processing_step_scale(ALZ_csf_normalized)

#no missing values to impute
trauma_human_imputed <- trauma_human
trauma_human_normalized <- processing_step_normalize(trauma_human_imputed)
trauma_human_scaled <- processing_step_scale(trauma_human_normalized)

#no missing values to impute
trauma_rat_imputed <- trauma_rat
trauma_rat_normalized <- processing_step_normalize(trauma_rat_imputed)
trauma_rat_scaled <- processing_step_scale(trauma_rat_normalized)

outlier_checker(ALZ_plasma_normalized, "ALZ_plasma")
outlier_checker(ALZ_csf_normalized, "ALZ_csf")
outlier_checker(trauma_human_normalized, "trauma_human")
outlier_checker(trauma_rat_normalized, "trauma_rat")


# graph_normalizeVSscale(ALZ_plasma_normalized, ALZ_plasma_scaled, "ALZ_plasma")
# graph_normalizeVSscale(ALZ_csf_normalized, ALZ_csf_scaled, "ALZ_csf")
# graph_normalizeVSscale(trauma_human_normalized, trauma_human_scaled, "trauma_human")
# graph_normalizeVSscale(trauma_rat_normalized, trauma_rat_scaled, "trauma_rat")

# save processed verisons of data frames
write.csv(ALZ_plasma_normalized, "application/ALZ_plasma_processed.csv", row.names=TRUE)
write.csv(ALZ_csf_normalized, "application/ALZ_csf_processed.csv", row.names=TRUE)
write.csv(trauma_human_normalized, "application/trauma_human_processed.csv", row.names=TRUE)
write.csv(trauma_rat_normalized, "application/trauma_rat_processed.csv", row.names=TRUE)

