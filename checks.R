library(dplyr)

## see aceecostats
dp <- "/home/acebulk/data"
db <- dplyr::src_sqlite(file.path(dp, "habitat_assessment.sqlite3"))
d <- tbl(db, "chl_sst_25k_monthly")


library(croc)  ## devtools::install_github("sosoc/croc")

## a representative month
library(raster)
vgpm <- setExtent(raster("data-raw/2017/vgpm.2017001.hdf"), extent(-180, 180, -90, 90))
projection(vgpm) <- "+init=epsg:4326"

vgpm[vgpm < 0] <- NA

mon <- d %>% dplyr::filter(year == 2017, mon == 1) %>%
  dplyr::select(chla_johnson, chla_nasa, par, sst, daylength, cell) %>% collect(n = Inf)

default_grid <- function() {
  prjj <-         "+proj=laea +lat_0=-90 +datum=WGS84"
  raster(spex::buffer_extent(projectExtent(raster(extent(-180, 180, -90, -30),
                                                  crs = "+init=epsg:4326"),
                                           prjj), 25000),
         res = 25000, crs = prjj)


}

mon <- mon %>% mutate(vgpm = croc::prod_BeFa(chla_johnson, irrad = par, stemp = sst, daylength = daylength))

g <- default_grid()
g[mon$cell] <- mon$vgpm
g <- g/(area(g)/1e6)
par(mfrow = c(1, 2))
plot(sqrt(g), col = viridis::viridis(100), zlim = sqrt(c(0, 50)))
plot(sqrt(g2), col = viridis::viridis(100), zlim = sqrt(c(0, 50)))
g2 <- projectRaster(vgpm/area(vgpm), g)
#ag2 <- projectRaster(area(vgpm), g)
chl <- default_grid()
chl[mon$cell] <- mon$chla_nasa
pal <- palr::chlPal(palette = TRUE)
plot(chl, breaks = pal$breaks, col = pal$cols)
r <- projectRaster(raster("data-raw/20170012017031.L3m_MO_CHL_chl_ocx_9km.nc"), default_grid())
