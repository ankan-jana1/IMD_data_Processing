#Downloading IMD Daily data
url <- paste0("https://www.imdpune.gov.in/Seasons/Temperature/min/min", format(Sys.Date()-1, "%d%m%Y"), ".grd")
url1 <- paste0("https://www.imdpune.gov.in/Seasons/Temperature/max/max", format(Sys.Date()-1, "%d%m%Y"), ".grd")
#url2 <- paste0("https://www.imdpune.gov.in/Seasons/Temperature/gpm/", format(Sys.Date()-5, "%d%m%Y"), ".grd")
download.file(url, paste0("D:/DATABASE/IMD_RF/IMD/Daily_Tmin_Data_IMD/", basename(url)),quiet = T, mode = "wb")
download.file(url1, paste0("D:/DATABASE/IMD_RF/IMD/Daily_Tmax_Data_IMD/", basename(url1)),quiet = T, mode = "wb")
#download.file(url2, paste0("D:/DATABASE/IMD_RF/IMD/Daily_RF_Data_IMD/", basename(url2)),quiet = T, mode = "wb")

#Processing IMD Min Temp Daily data
#install.packages("raster")
library(raster) 
setwd("D:/DATABASE/IMD_RF/IMD/Daily_Tmin_Data_IMD/") #Change Directory#
lt <- basename(url)
myconn <- file(lt,"rb")
b <- readBin(myconn, numeric(), n=61*61, size=4, endian = "little")
close(myconn)
ts <- substr(lt, 4, 11)
date_seq <- as.Date(ts, format = "%d%m%y")
outfile<-paste0("D:/DATABASE/IMD_RF/IMD/Daily_Tmin_Data_IMD/Text/Min_", date_seq,".txt") #Change Folder for .txt files
cat(paste("ncols         61",
          "nrows         61",
          "xllcorner     67.5",
          "yllcorner     7.5",
          "cellsize      0.5",
          "NODATA_value  -999 \n",sep="\n"),file=outfile)
cat(b,file=outfile, append=T)
#cat(folder=outfile, append=T)
r<-raster::raster(outfile)
r<-flip(r,direction='y')
crs(r) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
#r[r>60]=NA
outfile1<-paste0("D:/DATABASE/IMD_RF/IMD/Daily_Tmin_Data_IMD/Raster/Min_", date_seq,".tif") #Change Folder for raster files
writeRaster(r, outfile1, overwrite=T)

#Processing IMD Max Temp Daily data

setwd("D:/DATABASE/IMD_RF/IMD/Daily_Tmax_Data_IMD/") #Change Directory
lt <- basename(url1)
myconn <- file(lt,"rb")
b <- readBin(myconn, numeric(), n=61*61, size=4, endian = "little")
close(myconn)
ts <- substr(lt, 4, 11)
date_seq <- as.Date(ts, format = "%d%m%Y")
outfile<-paste0("D:/DATABASE/IMD_RF/IMD/Daily_Tmax_Data_IMD/Text/Max_", date_seq,".txt") #Change Folder for .txt files
cat(paste("ncols         61",
          "nrows         61",
          "xllcorner     66.5",
          "yllcorner     7.5",
          "cellsize      0.5",
          "NODATA_value  -999 \n",sep="\n"),file=outfile)
cat(b,file=outfile, append=T)
r1<-raster(outfile)
r1<-flip(r1,direction='y')
crs(r1) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
r1[r1>60]=NA
outfile1<-paste0("D:/DATABASE/IMD_RF/IMD/Daily_Tmax_Data_IMD/Raster/Max_", date_seq,".tif") #Change Folder for raster files
writeRaster(r1, outfile1, overwrite=T)


############## Average Temperature#######
r2 <- raster(r1)
bb <- extent(67.5, 98, 7.5, 38)
extent(r1) <- bb
r2 <- setExtent(r1, bb, keepres=TRUE)
Tavg<-mean(r,r2)
outfile1<-paste0("D:/DATABASE/IMD_RF/IMD/Daily_Tmean_Data_IMD/Tmean_", date_seq,".tif") #Change Folder for raster files
writeRaster(Tavg, outfile1, overwrite=T)



