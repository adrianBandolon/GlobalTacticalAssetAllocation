stck.table <- function(shares, ext.price, ent.price, symbol, ent.date){
        t <- read.csv ("C:/Users/spyrokete/Desktop/STOCK ANALYSIS/stck_rscripts/stck_table.csv")   
          q <- ((ext.price-ent.price)*shares)
          r <- (q/ent.price)*shares
            s <- data.frame(Symbol=symbol, Entry.Date=ent.date, 
                            Buy.Price=ent.price, Sell.Price=ext.price, 
                            No.Shares=shares, Dollar.PL = q, Percent.PL = r)
       x <- rbind(t, s)
        write.csv(x, row.names = FALSE, 
                  file = "C:/Users/spyrokete/Desktop/STOCK ANALYSIS/stck_rscripts/stck_table.csv")
}
