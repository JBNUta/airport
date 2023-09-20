library(httr)
library(rvest)
library(tidyverse)
library(writexl)
library(jsonlite)
library(XML)

#국제선 운항 스케줄

international_url <- 'http://openapi.airport.co.kr/service/rest/FlightScheduleList/getIflightScheduleList?serviceKey=NfIBFStCow3K8KJLHFzTb1%2BfCdTJATGDIZky59KDtytcktfIQ4BzFVHUobMAmr2ZMAoy5w7UdOOcp%2BKkuCW9Dw%3D%3D&'

res <- GET(url = international_url)

res %>%
  content(as = 'text' , encoding = 'UTF-8') %>%
  fromJSON() -> json

json$response$body$items$item # 예시 데이터 프레임

intrntnl_count <- json$response$body$totalCount
intrntnl_row <- json$response$body$numOfRows
roop_intrntnl <- (intrntnl_count/intrntnl_row) %>% ceiling()

###################### 결과물 저장장
international_flight_df <- data.frame()

for (pN in 1:roop_intrntnl){
  url <- international_url %>% paste0('&pageNo=',pN)
  
  res <- GET(url = url)
  
  res %>%
    content(as = 'text' , encoding = 'UTF-8') %>%
    fromJSON() -> json
  
  df_1page <- json$response$body$items$item
  
  international_flight_df <- rbind(domestic_total_flight, df_1page)
}

international_flight_df
international_url %>% paste0('&pageNo=',2)
