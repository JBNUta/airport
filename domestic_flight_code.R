library(httr)
library(rvest)
library(tidyverse)
library(writexl)
library(jsonlite)
library(XML)

########################################
# GET 함수에 query를 찍자니 잘 안된다..

sample_url <- #일람 책자에서 알려준 예시를 활용
  'http://openapi.airport.co.kr/service/rest/FlightScheduleList/getDflightScheduleList?ServiceKey=NfIBFStCow3K8KJLHFzTb1%2BfCdTJATGDIZky59KDtytcktfIQ4BzFVHUobMAmr2ZMAoy5w7UdOOcp%2BKkuCW9Dw%3D%3D&schDeptCityCode=GMP&schArrvCityCode=PUS&pageNo=1'

domestic_url <- #고유한 놈
  'http://openapi.airport.co.kr/service/rest/FlightScheduleList/getDflightScheduleList?ServiceKey=NfIBFStCow3K8KJLHFzTb1%2BfCdTJATGDIZky59KDtytcktfIQ4BzFVHUobMAmr2ZMAoy5w7UdOOcp%2BKkuCW9Dw%3D%3D&'

#비슷한 url 을 만들어 보자
pseudo_url <-
  paste0(
    domestic_url,
    'schDeptCityCode=',
    'GMP',
    '&schArrvCityCode=',
    'PUS',
    '&pageNo=',
    1,
    collapse = ''
  )
#여기에 출발,도착,page만 바꿔준다면.. 모든 출도착 데이터프레임 출력 가능


#####예시
res <- GET(url = sample_url)

res %>%
  content(as = 'text' , encoding = 'UTF-8') %>%
  fromJSON() -> json


json$response$body$items$item
##### 잘 됨, 이제 페이지를 변경해서 밑에 계속 붙이자
(numOfRows <-
    json$response$body$numOfRows) #행 개수 확인 원래 다른 데이터들은 조절이 가능한데 항공사 코드는 10개 고정
(totalCount <- json$response$body$totalCount) #총 데이터 수 (행 수)
(loopCount <- ceiling(totalCount / numOfRows)) #루핑 횟수

GMP_PUS_df <- data.frame()

for (i in 1:loopCount) {
  #추출 시작
  res <- GET(url = pseudo_url)
  
  res %>%
    content(as = 'text' , encoding = 'UTF-8') %>%
    fromJSON() -> json
  
  onlydf <- json$response$body$items$item
  
  GMP_PUS_df <- rbind(GMP_PUS_df, onlydf)
  
}

GMP_PUS_df %>% View()
#우려... 출도착이 다름.. 그러면
kor_airport_code <-
  c(
    'ICN','GMP','PUS','CJU','MWX','YNY','CJJ','TAE',
    'WJU','KPO','USN','HIN','KUV','KWJ','RSU','CHF',
    'SSN','SWU','OSN','MPK','KAG','YEC',
    'HMY','CHN','JDG')

kor_airport_code %>% duplicated()

kor_airport_code

#조합이..
kor_airport_code %>% length()
choose(25, 2) * 2 #출도착이 달라지면 다르니까..
#총 600가지의 경우의 수 존재...


domestic_urls <- c()

for (i in 1:length(kor_airport_code)) {
  for (j in 1:length(kor_airport_code)) {
    if (i != j) {
      url <- paste0(
        domestic_url,
        "schDeptCityCode=", kor_airport_code[i],
        "&schArrvCityCode=", kor_airport_code[j],
        "&pageNo=1"
      )
      domestic_urls <- append(domestic_urls, url)
    }
  }
}
#모든 쌍 생성 완료
domestic_urls

loopcounts <- c() #출도착 쌍 별 루핑 횟수

for (i in 1:length(domestic_urls)){
  res <- GET(url = domestic_urls[i])
  
  res %>% 
    content(as = 'text' , encoding = 'UTF-8') %>%
    fromJSON() -> json
  
  numOfRows <-    json$response$body$numOfRows
  totalCount <- json$response$body$totalCount
  loopCount <- ceiling(totalCount / numOfRows)
  
  loopcounts[i] <- loopCount
}

#ceiling 함수를 썼기 때문에 무조건 1회는 루핑이 돌아야 함
#0은 데이터 프레임이 없다는 뜻이므로 루핑에 포함시키지 않는다
#사실상
sum(loopcounts!=0) #68개.. 68개 쌍만 관찰하도록 하자.

filtered_url <- domestic_urls[loopcounts!=0]
fltr_loop <- filtered_url %>% length()

domestic_df <- data.frame()

for (i in 1:fltr_loop) {
  #추출 시작
  res <- GET(url = filtered_url[i])
  
  res %>%
    content(as = 'text' , encoding = 'UTF-8') %>%
    fromJSON() -> json
  
  onedf <- json$response$body$items$item
  
  domestic_df <- rbind(domestic_df, onedf)
  
}

domestic_df #중복되지 않은 국내선 데이터 프레임 



#################################
#근데 필수 요소를 넣지 않는 다면 모든 데이터가 다 나온다...

service_key
base_domestic_url <- 'http://openapi.airport.co.kr/service/rest/FlightScheduleList/getDflightScheduleList?serviceKey='
domestic_url <- paste0(base_domestic_url, service_key)

res <- GET(url = domestic_url)

res %>%
  content(as = 'text' , encoding = 'UTF-8') %>%
  fromJSON() -> json

domestic_count <- json$response$body$totalCount
domestic_num_of_row <- json$response$body$numOfRows

roop <- (domestic_count/domestic_num_of_row) %>% ceiling()
roop

domestic_url %>% paste0('&pageNo=',2)


domestic_total_flight <- data.frame()

for (pN in 1:roop){
  url <- domestic_url %>% paste0('&pageNo=',pN)
  
  res <- GET(url = url)
  
  res %>%
    content(as = 'text' , encoding = 'UTF-8') %>%
    fromJSON() -> json
  
  df_1page <- json$response$body$items$item
  
  domestic_total_flight <- rbind(domestic_total_flight, df_1page)
}

domestic_total_flight
# 49920 까지 스크래핑 됨.. 근데 access 제한
################ 해외 데이터 