- ### air_portal.R
  - 마지막 칼럼에 공항 값 추가.(20230913)
  - **TO DO**
    - 1) 공항 값이 RKSI와 같이 대체값으로 들어가있음 -> 각 대체값에 대응되는 실제 공항 이름으로 대체하는 코드 필요
      2) 변수명들 간소화
      3) 스크래핑 과정을 함수로 수정
      5) 중첩 for문 수정 필요\
         e-1) doParallel 패키지를 활용하여 중첩을 피하고 병렬처리를 해보려 했으나.. 실패.
              개선 필요

- ### schedule.R
  - 출발공항과 도착공항을 선택하지 않고 모든 공항 조회?
     - 데이터 양 상당해짐
  - 하지만 선택하도록 코드 구성하려면 경우의 수가 수백가지가 됨.
     - 그냥 출발공항과 도착 공항을 default로 지정해놓고 df에서 쿼리하는 방식이 나을 것 같음
  - **TO DO**
     - 끝 페이지를 알 수 없을테니 이때 해결방안?
     - for문 구성 방식?, 사용하지 않을거면 대책은?
    
- 남은 과제
  - google scholar에서 관련 논문 서치
  - [airportal](https://www.airportal.go.kr/index.jsp)https://www.airportal.go.kr/index.jsp 에서 추가 수집할 데이터 여부 파악
  - 추가적으로 스크래핑 할 사이트 [datago](https://www.data.go.kr) #API 이용
 
- 공공데이터 포털 : 한국공항공사_항공기 운항정보 [airportAPI]('https://www.data.go.kr/tcs/dss/selectApiDataDetailView.do?publicDataPk=15000126')
  - 항공사 코드 전부 추출. (20230915)
  - **해야 할 일**
       - 국제선 현황
       - 국내선 현황     
  - **사전 주의 사항**

       - url 별로 돌아다니면서 크롤링을 하려면 상당한 중첩이 생길 것으로 예견.. 복잡하지 않게 코드를 짜는 방안 모색
