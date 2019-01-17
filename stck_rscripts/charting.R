library(quantmod)
getSymbols(c("SPY","SPYG"))

chartSeries(SPY, theme = chartTheme('white', up.col = 'grey70', dn.col = 'gray8'), 
            type = c('candles'), multi.col = FALSE, major.ticks = 'months', 
            use.adjusted = TRUE, name = "SPY", 
            subset = "2014-10-01::")
chartSeries(SPYG, theme = chartTheme('white', up.col = 'grey70', dn.col = 'gray8'), 
            type = c('candles'), multi.col = FALSE, major.ticks = 'months', 
            use.adjusted = TRUE, name = "SPYG", 
            subset = "2014-10-01::")
