library(httr)
library(rvest)
library(tidyverse)
library(jsonlite)
library(XML)

#국제선 운항 스케줄

int_base_url <- 'http://openapi.airport.co.kr/service/rest/FlightScheduleList/getIflightScheduleList?serviceKey='
service_key
int_url <- int_base_url %>% paste0(service_key)


res <- GET(url = int_url)

res %>%
  content(as = 'text' , encoding = 'UTF-8') %>%
  fromJSON() -> json

json$response$body$items$item # 예시 데이터 프레임
(num_of_rows <- json$response$body$totalCount) #행의 수를 찾기


request_url <- paste0(int_url,'&pageNo=',1,'&numOfRows=',num_of_rows)
request_url

###################### 결과물 저장
international_flight_df <- data.frame()

res <- GET(url = request_url)

res %>%
  content(as = 'text' , encoding = 'UTF-8') %>%
  fromJSON() -> json

international_flight_df <- json$response$body$items$item
international_flight_df %>% View()

###################### 함수화

get_api <- function(base_url,service_key){
  n_o_r_url <- base_url %>% paste0(service_key,'&pageNo=',1)
  
  res1 <- GET(url = n_o_r_url)
  
  res1 %>% content(as = 'text' , encoding = 'UTF-8') %>%
    fromJSON() -> json
  
  num_of_counts <- json$response$body$totalCount
  
  main_url <- n_o_r_url %>% paste0('&numOfRows=',num_of_counts)
  
  res2 <-GET(url = main_url)
  res2 %>% content(as = 'text' , encoding = 'UTF-8') %>%
    fromJSON() -> json
  
  total_df <- json$response$body$items$item
  return(total_df)
}

international_df <- get_api(int_base_url,service_key)
international_df #끝, 함수화 완료,,

###################### 국내 항공편 추출해보기
domestic_url <- 'http://openapi.airport.co.kr/service/rest/FlightScheduleList/getDflightScheduleList?ServiceKey='

domestic_df <- get_api(domestic_url,service_key)
domestic_df

###################### 실시간 운항 정보 
real_time_url <- 'http://openapi.airport.co.kr/service/rest/FlightStatusList/getFlightStatusList?serviceKey='

real_time_df <- get_api(real_time_url, service_key)
real_time_df
