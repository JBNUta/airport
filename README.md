- air_portal.R
  - 마지막 칼럼에 공항 값 추가.(20230913)
  - **수정필요사항**
    - 1) 공항 값이 RKSI와 같이 대체값으로 들어가있음 -> 각 대체값에 대응되는 실제 공항 이름으로 대체하는 코드 필요
      2) 간소화 할 수 있는 변수명 수정 필요
      3) 스크래핑 과정을 함수로 수정 필요
      4) 스크래핑 결과 엑셀 파일 예시로 몇개 업로드 필요
      5) 중첩 for문 수정 필요\
         e-1) doParallel 패키지를 활용하여 중첩을 피하고 병렬처리를 해보려 했으나.. 실패 개선 필요
- 남은 과제
  - google scholar에서 관련 논문 서치
  - [airportal](https://www.airportal.go.kr/index.jsp)https://www.airportal.go.kr/index.jsp 에서 추가 수집할 데이터 여부 파악
  - 추가적으로 스크래핑 할 사이트 [datago](https://www.data.go.kr) #API 이용
 
- 공공데이터 포털 : 한국공항공사_항공기 운항정보 [data_of_airport]('https://www.data.go.kr/tcs/dss/selectApiDataDetailView.do?publicDataPk=15000126')
  - 항공사 코드 전부 추출. (20230915)\
     **해야 할 일**
       - 국제선 현황
       - 국내선 현황
    **사전 주의 사항**
       - url 별로 돌아다니면서 크롤링을 하려면 상당한 중첩이 생길 것으로 예견.. 복잡하지 않게 코드를 짜는 방안 모색
