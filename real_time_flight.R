library(httr)
library(rvest)
library(tidyverse)
library(writexl)
library(jsonlite)
library(XML)

#국제선 운항 스케줄

real_time_url <- 'http://openapi.airport.co.kr/service/rest/FlightStatusList/getFlightStatusList?serviceKey=NfIBFStCow3K8KJLHFzTb1%2BfCdTJATGDIZky59KDtytcktfIQ4BzFVHUobMAmr2ZMAoy5w7UdOOcp%2BKkuCW9Dw%3D%3D&'

res <- GET(url = real_time_url)

res %>%
  content(as = 'text' , encoding = 'UTF-8') %>%
  fromJSON() -> json

json$response$body$items$item # 예시 데이터 프레임

real_time_count <- json$response$body$totalCount
real_time_row <- json$response$body$numOfRows
real_time_roop <- (intrntnl_count/intrntnl_row) %>% ceiling()

real_time_roop


###################### 결과물 저장장
real_time_flight_df <- data.frame()

for (pN in 1:real_time_roop){
  url <- real_time_url %>% paste0('&pageNo=',pN)
  
  res <- GET(url = url)
  
  res %>%
    content(as = 'text' , encoding = 'UTF-8') %>%
    fromJSON() -> json
  
  df_1page <- json$response$body$items$item
  
  real_time_flight_df <- rbind(real_time_flight_df, df_1page)
}

real_time_flight_df
