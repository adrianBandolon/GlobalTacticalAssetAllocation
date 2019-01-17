stck.graph <- function(symbol, en.date, ex.date){
        
        s <- get(getSymbols("UA", from = "2015-01-01", warnings = FALSE))
        
        date <- dates(c(en.date, ex.date))
        colnames(s) <- c("Open", "High", "Low", "Close", "Volume", "Adjusted")
        
        #create the Donchian Channel indicator
        dc25 <- DonchianChannel(s[ ,c("High", "Low")], n = 25, include.lag = TRUE)
        dc25[is.na(dc25)] <- 0
        dc10 <- DonchianChannel(s[ ,c("High", "Low")], n = 10, include.lag = TRUE)
        dc10[is.na(dc10)] <- 0
        #Visualize Donchian Channels
        newDC25 <-(dc25[ , c("high", "low")], on = 1, col = c("black", "black"), 
                        lty = c("longdash", "longdash"), lwd = c(2, 2))
        newDC10 <- (dc10[ , c("high", "low")], on = 1, col = c("black", "black"), 
                 lty = c("dotted", "dotted"), lwd = c(2, 2))
        newM1 <- (xts(TRUE,as.POSIXlt(date[1],tz="GMT"), on=1, lty = "dotted"))
        newM2 <- (xts(TRUE,as.POSIXlt(date[2],tz="GMT"), on=1, lty = "dotdash")
        
        chartSeries(s, theme = chartTheme('white', up.col = 'grey70', dn.col = 'gray8'), type = c('candles'),
                    multi.col = FALSE, major.ticks = 'months', 
                    TA = c(newDC25(), newDC10(), newM1(), newM2()), use.adjusted = TRUE,
                    name = "")
        
        
      
}

stck.graph("UA", "01/02/15", "03/20/15")
