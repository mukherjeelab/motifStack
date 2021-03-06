% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clusterMotifs.R
\name{clusterMotifs}
\alias{clusterMotifs}
\title{cluster motifs}
\usage{
clusterMotifs(motifs, ...)
}
\arguments{
\item{motifs}{A list of pcms of pfms.}

\item{...}{parameter to be passed to \link{matalign} function.}
}
\value{
An object of hclust.
}
\description{
A help function to do matalign and motifHclust in one function.
}
\examples{
 if(interactive() || Sys.getenv("USER")=="jianhongou"){
  fp <- system.file("extdata", package="motifStack")
  fs <- dir(fp, "pcm$")
  pcms <- importMatrix(file.path(fp, fs), format="pcm")
  hc <- clusterMotifs(pcms)
 }
}
