# update this file path to point toward appropriate folder on your computer
cryptocurrencies_folder <- "./data/cryptocurrencies/"
cryptocurrencies_folder_files_list <- list.files(path = cryptocurrencies_folder, pattern = "*.txt")
# read in each .txt file in file_list and rbind them into a data frame called  
cryptocurrencies_data <- do.call("rbind",
                                 lapply(cryptocurrencies_folder_files_list, 
                                        function(x)
                                          read.table(paste(cryptocurrencies_folder, x, sep = ''),
                                                     header = TRUE,
                                                     stringsAsFactors = FALSE)))
#View(cryptocurrencies_data)
currencies_major_folder <- "./data/currencies/major/"
currencies_major_folder_files_list <- list.files(path = currencies_major_folder, pattern = "*.txt")
currencies_major_folder_data <- do.call("rbind",
                                        lapply(currencies_major_folder_files_list,
                                               function(x)
                                                 read.table(paste(currencies_major_folder, x, sep = ''),
                                                            header = TRUE,
                                                            stringsAsFactors = FALSE)))
#View(currencies_major_folder_data)
currencies_other_folder <- "./data/currencies/other/"
currencies_other_folder_files_list <- list.files(path = currencies_other_folder, pattern = "*.txt")
currencies_other_folder_data <- do.call("rbind",
                                        lapply(currencies_other_folder_files_list,
                                               function(x)
                                                 read.table(paste(currencies_other_folder, x, sep = ''),
                                                            header = TRUE,
                                                            stringsAsFactors = FALSE)))
#View(currencies_other_folder_data)
indices_folder <- "./data/indices/"
indices_folder_files_list <- list.files(path = indices_folder, pattern = "*.txt")
indices_folder_data <- do.call("rbind",
                               lapply(indices_folder_files_list,
                                      function(x)
                                        read.table(paste(indices_folder, x, sep = ''),
                                                   header = TRUE,
                                                   stringsAsFactors = FALSE)))
#View(indices_folder_data)
stooq_stocks_indices_folder <- "./data/stooq stocks indices/"
stooq_stocks_indices_folder_files_list <- list.files(path = stooq_stocks_indices_folder, pattern = "*.txt")
stooq_stocks_indices_folder_data <- do.call("rbind",
                                            lapply(stooq_stocks_indices_folder_files_list,
                                                   function(x)
                                                     read.table(paste(stooq_stocks_indices_folder, x, sep =''),
                                                                header = TRUE,
                                                                stringsAsFactors = FALSE)))
#View(stooq_stocks_indices_folder_data)

clean.data <- function(df){
  df <- cbind(df,
              colsplit(df$X.TICKER...PER...DATE...TIME...OPEN...HIGH...LOW...CLOSE...VOL...OPENINT.,
                       ',',
                       names = c('ticker', 'per', 'date', 'time', 'open', 'high', 'low', 'close', 'vol', 'openInt'))) %>% 
    mutate(date = ymd(date),
           time = as.numeric(time),
           open = as.double(open),
           high = as.double(high),
           low = as.double(low),
           close = as.double(close)) %>%
    select(ticker, date, open, high, low, close)
  return(df)
}

cryptocurrencies_data <- clean.data(cryptocurrencies_data)
currencies_major_folder_data <- clean.data(currencies_major_folder_data)
currencies_other_folder_data <- clean.data(currencies_other_folder_data)
indices_folder_data <- clean.data(indices_folder_data)
stooq_stocks_indices_folder_data <- clean.data(stooq_stocks_indices_folder_data)

cryptocurrencies_data <- cryptocurrencies_data %>% 
  mutate(atr = ATR(cryptocurrencies_data[, c("high", "low", "close")], n = 14)) 

#View(cryptocurrencies_data)

currencies_major_folder_data <- currencies_major_folder_data %>%
  mutate(atr = ATR(currencies_major_folder_data[, c("high", "low", "close")], n = 14))

#View(currencies_major_folder_data)

currencies_other_folder_data <- currencies_other_folder_data %>%
  mutate(atr = ATR(currencies_other_folder_data[, c("high", "low", "close")], n = 14))

indices_folder_data <- indices_folder_data %>%
  mutate(atr = ATR(indices_folder_data[, c("high", "low", "close")], n = 14))

stooq_stocks_indices_folder_data <- stooq_stocks_indices_folder_data %>%
  mutate(atr = ATR(stooq_stocks_indices_folder_data[, c("high", "low", "close")], n = 14))

ticker_wise_currencies_major_folder_data <- currencies_major_folder_data %>%
  split(f = currencies_major_folder_data$ticker)
ticker_wise_currencies_other_folder_data <- currencies_other_folder_data %>%
  split(f = currencies_other_folder_data$ticker)

write.xlsx(ticker_wise_currencies_major_folder_data, file = "./xlsx/ticker_wise_currencies_major_folder_data.xlsx")

write.xlsx(ticker_wise_currencies_other_folder_data, file = "./xlsx/ticker_wise_currencies_other_folder_data.xlsx")

write.xlsx(cryptocurrencies_data, file = "./xlsx/cryptocurrencies_data.xlsx")
write.xlsx(indices_folder_data, file = "./xlsx/indices_folder_data.xlsx")
write.xlsx(stooq_stocks_indices_folder_data, file = "./xlsx/stooq_stocks_indices_folder_data.xlsx")