- ### air_portal.R
- ### abnormal.R
- ### schedule.R
  - airportal.R로 대체 가능 -> 폐기
       
- ### 남은 과제
  - google scholar에서 관련 논문 서치
  - 추가적으로 스크래핑 할 사이트 [datago](https://www.data.go.kr) 


 
 공공데이터 포털 : 한국공항공사_항공기 운항정보 [airportAPI]('https://www.data.go.kr/tcs/dss/selectApiDataDetailView.do?publicDataPk=15000126')
 
- ### 항공사 코드 전부 추출.
  - 국제선, 국내선을 추출 하려면 url에 공항코드를 매핑해야하므로 모든 공항의 코드 추출
   
- ### 국내선 운행 현황
   - 항공사 코드에서 한국 코드를 뽑으려 했는데 항공 코드 데이터에는 국가가 명시되지 않음 <- 따로 찾음
   - 공식적으로 등록된 국내 공항 코드 25개,, -> 출도착 고려시 600개의 데이터쌍을 고려해야함 **해결** 
   - 600개의 모든 쌍에 운항이 이뤄지지 않을 것 같아서 url만 600개를 만들고 데이터의 개수를 for문으로 추출 **해결** 페이지 수만 paste0 하면 됨
   - 데이터 수 / 페이지 단위(10) 에 올림을 하여 0이 나온 부분은 데이터가 없으므로 걸러냄 **해결**
   - 데이터가 있는 url만 스크래핑 하여 데이터 전부 추출
      - #### 아쉬운 점.
        - 정말 url을 600개를 만들었어야 했을지.. -> 해결, 기본 url만 검색하면 출,도착 상관없이 모든 데이터 프레임을 다 내어줌
- ### 국제선 운행 현황
   - 국내선 현황과 똑같이 url만 바꿔서 해주면 됨
 
- ### 실시간 운행 현황
   - 같은 방식으로 해결, 근데 날짜가 당일밖에 안되는 것 같음
