## move
library(move)
data <- read.csv(system.file("extdata","ricky.csv.gz",package="move"))
ricky <- move(x = data$location.long, y = data$location.lat,
    time = as.POSIXct(data$timestamp, format = "%Y-%m-%d %H:%M:%OS",
        tz = "UTC"), proj = CRS("+proj=longlat"), data = data,
    animal = data$individual.local.identifier, sensor = data$sensor)
ricky

## trip
library(trip)
d <- data.frame(x=1:10,y=rnorm(10), tms=Sys.time() + 1:10, id=gl(2, 5))
coordinates(d) <- ~x+y
proj4string(d) <- CRS("+proj=laea +ellps=sphere")
tr <- trip(d, c("tms", "id"))
summary(tr)

## trajectories
library("trajectories")

## trackeR
library("trackeR")
filepath <- system.file("extdata/tcx/", "2013-06-01-183220.TCX", package = "trackeR")
runDF <- readTCX(file = filepath, timezone = "GMT")
runTr0 <- trackeRdata(runDF)
runTr0
str(runTr0)

## spacetime
library(adehabitatLT)
data("puechabonsp")
locs <- puechabonsp$relocs
xy <- coordinates(locs)
da <- as.character(locs$Date)
da <- as.POSIXct(strptime(as.character(locs$Date),"%y%m%d", tz = "GMT"))
ltr <- as.ltraj(xy, da, id = locs$Name)
foo <- function(dt) dt > 100*3600*24
l2 <- cutltraj(ltr, "foo(dt)", nextr <- TRUE)
library(spacetime)
sttdf <- as(l2, "STTDF")
stplot(sttdf, by = "time*id")
str(sttdf)
summary(sttdf)



## sftraj
library(tidyr)

set.seed <- 42
n <- 100
(df <- data.frame(
    ind = rep(LETTERS[1:4], each = 25),
    year = rep(2001:2005, each = 5),
    state = sample(1:2),
    m = Sys.time() + 1:n,
    x = cumsum(rnorm(n)),
    y = cumsum(rnorm(n)),
    z = cumsum(rnorm(n))
))

nest(as_tibble(df), ind)


bla <- nest(iris, -Species)

## dplyr not needed, but tidyr is (nest); print easier with dplyr
library(dplyr)
iris
as_tibble(iris)
as_tibble(iris) %>% nest(-Species)
bla <- nest(as_tibble(iris), -Species)
bla$Sepal.Length <- 1:3

bla$data[[1]]
unnest(bla)


## Syntax (ST stands for spatial type, from the simple feature standard)
st_as_traj = traj

creates or modify a sftraj = sftraj object with (LINESTRING [Z]M) list-column (Z for elevation and M for timestamp as either POSIXct or integer) and additional data columns

## At the step level (default):
traj(x) ~ x+y[+z]+m or traj(x, y, [z], t, data = df)
## Note: Drops (with warning) last row of data if nrow(data) =
## length(x) as two points are necessary to make one step

## Nested version (individual, year, burst, state, etc.):
traj(x, y, [z], t, by = var, data = df, data_by = TRUE) → data.frame(nest(traj(x, y, [z], t), -var, .key = "var"), data = df)
  or nest(traj(x, y, [z], t, data = df), -var, .key = "var") if data_by = FALSE
## Also works directly on sftraj object:
traj(sftraj, by = var) → nest(unest(traj), -var, .key = "var")
traj(sftraj, by = "steps") → unnest(traj)
traj(sftraj, by = ~var1+var2) → nest(unest(traj), -var1, -var2, .key = "var")


## sf
library(sf)
## How does it handle missing values?
st_point(c(1,2,3,4))
(l1 <- st_linestring(rbind(c(0,0, 1, 2),c(0,3, 1, 2),c(0,4, 3, 4),c(1,5, 5, 6),c(2,5, 7, 8))))
(l2 <- st_linestring(rbind(c(0,0, 1, 2),c(0,3, 1, 2),c(NA,NA, 3, 4),c(1,5, 5, 6),c(2,5, 7, 8))))

plot(st_zm(l1))
plot(st_zm(l2))

nc <- st_read(system.file("shape/nc.shp", package="sf"))
str(nc)

str(nc$geometry)
attributes(nc$geometry)

