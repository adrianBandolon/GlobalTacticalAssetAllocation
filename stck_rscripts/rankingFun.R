rm(list=ls())

require(quantmod); require(PerformanceAnalytics)
# Rank.R contains functions for different ranking algorithms
source("C:/Users/spyrokete/Desktop/STOCK ANALYSIS/stck_rscripts/Rank.r")

# monthly-fun.R contains functions for prepping monthly data
source("C:/Users/spyrokete/Desktop/STOCK ANALYSIS/stck_rscripts/monthly-fun.r")

symbols<- c(
        #SP500 sector ETFs
        "XLY", "XLP", "XLE", "XLF", "XLV", "XLI", "XLK", "XLB", "XLU",
        #Bond ETFs
        "BIV", "BLV", "BSV", "BND", "VCIT", "VCLT", "VCSH", "VGIT", "VGLT", 
        "VGSH",
        #International ETFs
        "VEA", "VWO", "VEU", "VT", "VGK", "VSS", "BKF", #"ADRE",
        #Commodities ETFs
        "DBC", "DBO", #"DBA", "AGOL", "SIVR", "IAU", "SLV", "FMF", "FUTS", 
#        "WDTI",
        #Currency ETFs
        "DBV", #"FORX", "UDN", "USDU", "UUP", "FXY", "FXF", "FXE", "FXCH", 
#        "FXB", "CYB",
        #Real Estate ETFs
        "RWR", "VNQ" #"SCHH", "FTY", "IVR", "ICF", "IFNA",
        # Miscellaneous ETFs 
#        "GAA", "GVAL"
)

# There are 57 symbols!!

# get data for the symbols
getSymbols(symbols, from="2013-01-01", to = "2015-03-31")

# create an xts object of monthly adjusted close prices
symbols.close <- monthlyPrices(symbols)

# create an xts object of the symbol ranks
sym.rank1 <- applyRank(x=symbols.close, rankFun=singleROC)
sym.rank2 <- applyRank(x=symbols.close, rankFun=ave3ROC, n=c(3,6,9))
# this is an important step in naming the columns, e.g. XLY.Rank
# the "Rank" column is used as the trade signal (similar to an indicator)
# in the qstratRank function
colnames(sym.rank1) <- gsub(".Adjusted", "", colnames(sym.rank1))
colnames(sym.rank2) <- gsub(".Adjusted", "", colnames(sym.rank2))

# ensure the order of order symbols is equal to the order of columns 
# in symbols.close
stopifnot(all.equal(gsub(".Adjusted", "", colnames(symbols.close)), symbols))

sym.rank1 <- as.xts(t(apply(sym.rank1, 1, rank)), dateFormat="Date")
sym.rank2 <- as.xts(t(apply(sym.rank2, 1, rank)), dateFormat="Date")

res.1month <- data.frame(head(sort(t(sym.rank1)[ ,nrow(sym.rank1)]), n=10L))
res.3month <- data.frame(head(sort(t(sym.rank2)[ ,nrow(sym.rank2)]), n=10L))

colnames(res.1month) <- c("Rank");colnames(res.3month) <- c("Rank") 

View(res.1month); View(res.3month)

t1 <- apply(sym.rank1, 2, table)
t3 <- apply(sym.rank1, 2, table)

par(mfrow=c(3,3))
plot(t1$XLY)
plot(t1$XLP)
plot(t1$XLE)
plot(t1$XLF)
plot(t1$XLV)
plot(t1$XLI)
plot(t1$XLK)
plot(t1$XLB)
plot(t1$XLU)

par(mfrow=c(3,3))
plot(t3$XLY)
plot(t3$XLP)
plot(t3$XLE)
plot(t3$XLF)
plot(t3$XLV)
plot(t3$XLI)
plot(t3$XLK)
plot(t3$XLB)
plot(t3$XLU)