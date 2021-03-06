% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datasets.R
\docType{data}
\name{nycweather}
\alias{nycweather}
\title{Weather in New York City}
\format{
A tibble with 13,306 rows and 6 variables:
\describe{
\item{time}{The date-time value for the observations}
\item{wd,wd}{The wind speed and wind direction at the time of observation;
units are degrees (blowing from) and meters per second}
\item{temp}{Temperature in degrees Celsius at the time of observation}
\item{p}{The atmospheric pressure in hPa units}
\item{rh}{The relative humidity as a percentage value (in range of \code{0} to
\code{100})}
}
}
\usage{
nycweather
}
\description{
This contains select weather data for New York City in 2010. The
meteorological data was recorded at Laguardia Airport. Data was retrieved by
using the \pkg{stationaRy} R package. The data was originates from the
Integrated Surface Dataset (ISD), which is maintained by the National Oceanic
and Atmospheric Administration (NOAA).
}
\examples{
# Here is a glimpse at the data
# available in `nycweather`
dplyr::glimpse(nycweather)
}
\keyword{datasets}
