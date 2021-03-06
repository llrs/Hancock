% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllGenerics.R, R/GeneSet-helpers.R,
%   R/GeneSetCollection-helpers.R
\docType{methods}
\name{uniqueSetNames}
\alias{uniqueSetNames}
\alias{uniqueSetNames,tbl_geneset-method}
\alias{uniqueSetNames,GeneSetCollection-method}
\title{Extract Unique Signature Names from a Collection of Gene Sets}
\usage{
uniqueSetNames(object)

\S4method{uniqueSetNames}{tbl_geneset}(object)

\S4method{uniqueSetNames}{GeneSetCollection}(object)
}
\arguments{
\item{object}{A \code{\link{tbl_geneset}} or \code{GeneSetCollection}.}
}
\value{
A character vector of unique set names across all gene sets.
}
\description{
Extract Unique Signature Names from a Collection of Gene Sets
}
\examples{
# Example data ----
library(GeneSet)
tgs <- tbl_geneset(
    "Cell type 1"=c("Gene001", "Gene002"),
    "Cell type 2"=c("Gene002", "Gene003", "Gene004")
)

# Example usage ----
uniqueSetNames(tgs)
}
\author{
Kevin Rue-Albrecht
}
