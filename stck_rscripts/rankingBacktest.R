rm(list=ls())

library(quantstrat)
library(PerformanceAnalytics)

# Rank.R contains functions for different ranking algorithms
source("C:/Users/spyrokete/Desktop/STOCK ANALYSIS/stck_rscripts/Rank.r")

# monthly-fun.R contains functions for prepping monthly data
source("C:/Users/spyrokete/Desktop/STOCK ANALYSIS/stck_rscripts/monthly-fun.r")

# qstratRank.R contains the function to run the Rank backtest using the
# quantstrat framework
source("C:/Users/spyrokete/Desktop/STOCK ANALYSIS/stck_rscripts/qstratRank.r")

ttz<-Sys.getenv('TZ')
Sys.setenv(TZ='UTC')

currency("USD")
symbols<- c(
        #SP500 sector ETFs
        "XLY", "XLP", "XLE", "XLF", "XLV", "XLI", "XLK", "XLB", "XLU"
)
stock(symbols, currency="USD")

# get data for the symbols
getSymbols(symbols, from="2005-01-01", to="2015-02-28")

# create an xts object of monthly adjusted close prices
symbols.close <- monthlyPrices(symbols)

# create an xts object of the symbol ranks
#sym.Rowrank <- applyRank(x=symbols.close, rankFun=rowRank)
#sym.aveOne3six <- applyRank(x=symbols.close, rankFun=ave3ROC, n=c(1,3,6))
sym.ave3six9 <- applyRank(x=symbols.close, rankFun=ave3ROC, n=c(3,6,9))
# this is an important step in naming the columns, e.g. XLY.Rank
# the "Rank" column is used as the trade signal (similar to an indicator)
# in the qstratRank function
#colnames(sym.Rowrank) <- gsub(".Adjusted", ".Rank", colnames(sym.Rowrank))
#colnames(sym.aveOne3six) <- gsub(".Adjusted", ".Rank", colnames(sym.aveOne3six))
colnames(sym.ave3six9) <- gsub(".Adjusted", ".Rank", colnames(sym.ave3six9))

# ensure the order of order symbols is equal to the order of columns 
# in symbols.close
stopifnot(all.equal(gsub(".Adjusted", "", colnames(symbols.close)), symbols))

# bind the rank column to the appropriate symbol market data
# loop through symbols, convert the data to monthly and cbind the data
# to the rank

for(i in 1:length(symbols)) {
        x <- get(symbols[i])
        x <- to.monthly(x,indexAt='lastof',drop.time=TRUE)
        indexFormat(x) <- '%Y-%m-%d'
        colnames(x) <- gsub("x",symbols[i],colnames(x))
        x <- cbind(x, sym.ave3six9[,i])
        assign(symbols[i],x)
}


# run the backtest
#Rowrank <- qstratRank(symbols=symbols, init.equity=10000, top.N=3,
 #                max.size=1000, max.levels=2)

#aveOne3six <- qstratRank(symbols=symbols, init.equity=10000, top.N=3,
 #                     max.size=1000, max.levels=2)

ave3six9 <- qstratRank(symbols=symbols, init.equity=10000, top.N=3,
                     max.size=1000, max.levels=2)

colnames(Rowrank$returns) <- gsub("total", "Rowrank", 
                                   colnames(Rowrank$returns))

colnames(aveOne3six$returns) <- gsub("total", "aveOne3six", 
                                   colnames(aveOne3six$returns))

colnames(ave3six9$returns) <- gsub("total", "ave3six9", 
                                   colnames(ave3six9$returns))

# get trade stats
Rowrank.stats <- Rowrank$stats
aveOne3six.stats <- aveOne3six$stats
ave3six9.stats <- ave3six9$stats

getSymbols("GSPC", from = '2005-01-01', to = '2014-12-31')
GSPC.month <- to.monthly(GSPC,indexAt='lastof',drop.time=TRUE)
GSPC.ret <- Return.calculate(Ad(GSPC.month))

# chart of returns
charts.PerformanceSummary(cbind(ave3six9$returns[,10], GSPC.ret), 
                          geometric=FALSE, wealth.index=TRUE, 
                          main="Total Performance of S$P 500 ETFs")
