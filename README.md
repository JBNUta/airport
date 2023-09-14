- air_portal.R
  - 마지막 칼럼에 공항 값 추가.(20230913)
  - **수정필요사항**
    - 1) 공항 값이 RKSI와 같이 대체값으로 들어가있음 -> 각 대체값에 대응되는 실제 공항 이름으로 대체하는 코드 필요
      2) 간소화 할 수 있는 변수명 수정 필요
      3) 스크래핑 과정을 함수로 수정 필요
      4) 스크래핑 결과 엑셀 파일 예시로 몇개 업로드 필요
      5) 중첩 for문 수정 필요
         \5-1) 병렬 처리를 통해 살짝이나마 실행 시간을 줄였지만 더 다듬어져야 함.
- 남은 과제
  - google scholar에서 관련 논문 서치
  - [airportal](https://www.airportal.go.kr/index.jsp)https://www.airportal.go.kr/index.jsp 에서 추가 수집할 데이터 여부 파악
  - 추가적으로 스크래핑 할 사이트 [datago](https://www.data.go.kr) #API 이용 
