% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datasets.R
\docType{data}
\name{imdb}
\alias{imdb}
\title{Film reviews from the IMDB website (2000-2015)}
\format{
A tibble with 2,607 rows and 5 variables:
\describe{
\item{title,year}{The title of the film and its year of release.}
\item{score}{The aggregate rating for the film (from 0 to 10), based on
voluntary user reviews at the site.}
\item{budget,gross}{The reported budget for the film and its worldwide
gross earnings (both in U.S. dollars).}
}
}
\usage{
imdb
}
\description{
Film reviews from the IMDB website (2000-2015)
}
\examples{
# Here is a glimpse at the data
# available in `imdb`
dplyr::glimpse(imdb)
}
\keyword{datasets}
