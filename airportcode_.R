library(httr)
library(rvest)
library(tidyverse)
library(writexl)
library(jsonlite)
library(XML)

####################################### 사전 준비
url <-
  'http://openapi.airport.co.kr/service/rest/AirportCodeList/getAirportCodeList' #메인 주소
service_key #접근을 위한 서비스 키

res <- GET(url = url,
           query = list(ServiceKey = service_key %>% I(),
                        pageNo = 1)) #메인주소 + 서비스키 + 페이지 조합으로 정보 추출
url
res %>%
  content(as = 'text' , encoding = 'UTF-8') %>%
  fromJSON() -> json #text 컨텐츠를 json으로 추출

str(object = json) #제이슨 구조 확인
numOfRows <-
  json$response$body$numOfRows #행 개수 확인 원래 다른 데이터들은 조절이 가능한데 항공사 코드는 10개 고정
totalCount <- json$response$body$totalCount #총 데이터 수 (행 수)
loopCount <-
  ceiling(totalCount / numOfRows) #행이 페이지마다 10개씩 나옴. 나누고 올림하여 루핑 횟수 결정

json$response$body$items$item #데이터 프레임 구조

##################################### 웹 스크래핑 시작

totalDataFrame <- data.frame() #빈 프레임

for (i in 1:loopCount) {
  #추출 시작
  res <- GET(url = url,
             query = list(ServiceKey = service_key %>% I(),
                          pageNo = i))
  
  res %>%
    content(as = 'text' , encoding = 'UTF-8') %>%
    fromJSON() -> json
  
  onlydf <- json$response$body$items$item
  
  totalDataFrame <- rbind(totalDataFrame, onlydf)
  
}

totalDataFrame %>% View() #전체 스크래핑 된 데이터
