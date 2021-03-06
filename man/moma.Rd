% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datasets.R
\docType{data}
\name{moma}
\alias{moma}
\title{The moma dataset}
\format{
A tibble with 2,253 rows and 23 variables:
\describe{
\item{title}{title}
\item{artist}{artist}
\item{artist_bio}{artist_bio}
\item{artist_birth_year, artist_death_year}{artist_birth_year, artist_death_year}
\item{n_female_artists, n_male_artists}{n_female_artists, n_male_artists}
\item{artist_gender}{artist_gender}
\item{year_acquired}{year_acquired}
\item{year_created}{year_created}
\item{circumference_cm,depth_cm,diameter_cm,height_cm,length_cm,width_cm,seat_height_cm}{dimensions}
\item{purchase}{purchase}
\item{gift}{gift}
\item{exchange}{exchange}
\item{classification}{classification}
\item{department}{department}
}
}
\usage{
moma
}
\description{
The moma dataset
}
\examples{
# Here is a glimpse at the data
# available in `moma`
dplyr::glimpse(moma)
}
\keyword{datasets}
