
u <- "http://orca.science.oregonstate.edu/data/1x2/monthly/vgpm.v.chl.v.sst/hdf/vgpm.v.2017.tar"
f <- basename(u)
curl::curl_download(u, file.path("data-raw", f))

untar(file.path("data-raw", f), exdir = "data-raw/2017")
#system("gunzip data-raw/2017/vgpm.2017001.hdf.gz")

download.file("https://oceandata.sci.gsfc.nasa.gov/cgi/getfile/A20170012017031.L3m_MO_CHL_chl_ocx_9km.nc", "data-raw/20170012017031.L3m_MO_CHL_chl_ocx_9km.nc", mode = "wb")
