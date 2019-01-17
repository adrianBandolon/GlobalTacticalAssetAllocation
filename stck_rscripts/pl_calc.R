pl <- function(entry, exit, en_date, ex_date, shares){
        Dollar1 <- round((exit - entry)*shares, 2)
        Dollar <- format(Dollar1, nsmall = 2)
        Percent <- format(round((Dollar1 / (entry*shares))*100, 2), nsmall = 2)
        PL <- rbind(Dollar, Percent, "")
        Price <- rbind(entry, exit, "")
        d.diff <- abs(as.Date(en_date)-as.Date(ex_date))
        Date <- c(en_date, ex_date, d.diff)
        df <- data.frame(Date, Price, PL, row.names = c("Entry","Exit", "Days in Trade"))
        colnames(df) <- c("Date", "Price", "PL($/%)")
        return(df)
}
