library(PerseusR)
library(stringr) 

args = commandArgs(trailingOnly=TRUE)
if (length(args) < 3) {
  stop("Additional arguments are needed!", call.=FALSE)
}

inFile <- args[length(args)-1]
outFile <- args[length(args)]

mdata <- read.perseus(inFile) # read data in Perseus text format 

mainMatrix <- main(mdata) # extract main columns
anotCol<-annotCols(mdata) # extract rest of the columns

doMean=TRUE
doMedian=TRUE
doId=TRUE
doSum=TRUE

for (normalizeTo in args){
  if (str_detect(normalizeTo,"mean")&doMean){
    meanPerColumn<-apply(mainMatrix, MARGIN=2, function(x) mean(na.omit(x)))
    meanTotal<-mean(meanPerColumn, na.rm=TRUE)
    factorsPerColumnMean<-meanTotal/meanPerColumn
    mainMatrixMeanNorm<-apply(mainMatrix, MARGIN=1, function(x) x*factorsPerColumnMean)
    mainMatrixMeanNorm<-as.data.frame(t(mainMatrixMeanNorm))
    colnames(mainMatrixMeanNorm)<-paste(colnames(mainMatrixMeanNorm),"meanNorm", sep="_")
    doMean=FALSE
  }
  if (str_detect(normalizeTo,"median")&doMedian){
    medianPerColumn<-apply(mainMatrix, MARGIN=2, function(x) median(na.omit(x)))
    medianTotal<-median(medianPerColumn, na.rm=TRUE)
    factorsPerColumnMedian<-medianTotal/medianPerColumn
    mainMatrixMedianNorm<-apply(mainMatrix, MARGIN=1, function(x) x*factorsPerColumnMedian)
    mainMatrixMedianNorm<-as.data.frame(t(mainMatrixMedianNorm))
    colnames(mainMatrixMedianNorm)<-paste(colnames(mainMatrixMedianNorm),"medianNorm", sep="_")
    doMedian=FALSE
  }
  if(str_detect(normalizeTo,"=")&doId){
    normalizeTo<-gsub("[,. ]","",normalizeTo)
    splitByEqual<-strsplit(normalizeTo,"=")
    columnName=splitByEqual[[1]][1]
    Value=splitByEqual[[1]][2]
    column=anotCol[columnName]
    index<-which(column[columnName]==Value)
    meanTotalId<-apply(mainMatrix[index,], MARGIN=1, mean)
    factorsPerColumnId<-unlist(meanTotalId/mainMatrix[index,])
    mainMatrixIdNorm<-apply(mainMatrix, MARGIN=1, function(x) x*factorsPerColumnId)
    mainMatrixIdNorm<-as.data.frame(t(mainMatrixIdNorm))
    colnames(mainMatrixIdNorm)<-paste(colnames(mainMatrixIdNorm),"IdNorm", sep="_")
    doId=FALSE
  }
  if(str_detect(normalizeTo,"sum")&doSum){
    sumPerColumn<-apply(mainMatrix, MARGIN=2, function(x) sum(na.omit(x)))
    meanOfSum<-mean(sumPerColumn, na.rm=TRUE)
    factorsPerColumnSum<-meanOfSum/sumPerColumn
    mainMatrixSumNorm<-apply(mainMatrix, MARGIN=1, function(x) x*factorsPerColumnSum)
    mainMatrixSumNorm<-as.data.frame(t(mainMatrixSumNorm))
    colnames(mainMatrixSumNorm)<-paste(colnames(mainMatrixSumNorm),"SumNorm", sep="_")
    doSum=FALSE
  }
}

if(length(mdata@annotRows)>0){
  if(!doMean){anotCol<-as.data.frame(c(anotCol, mainMatrixMeanNorm))}
  if(!doMedian){anotCol<-as.data.frame(c(anotCol,mainMatrixMedianNorm))}
  if(!doId){anotCol<-as.data.frame(c(anotCol,mainMatrixIdNorm))}
  if(!doSum){ anotCol<-as.data.frame(c(anotCol,mainMatrixSumNorm))}
  annotCols(mdata)<-anotCol
}else{
  if(!doMean){mainMatrix<-as.data.frame(c(mainMatrix,mainMatrixMeanNorm))}
  if(!doMedian){mainMatrix<-as.data.frame(c(mainMatrix,mainMatrixMedianNorm))}
  if(!doId){mainMatrix<-as.data.frame(c(mainMatrix,mainMatrixIdNorm))}
  if(!doSum){ mainMatrix<-as.data.frame(c(mainMatrix,mainMatrixSumNorm))}
  main(mdata)<-mainMatrix
}

write.perseus(mdata, outFile) #write Perseus data