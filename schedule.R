library(RSelenium)
library(rvest)
library(dplyr)
library(writexl)


setwd("/Users/gwagdoseong/Documents/TA")
path = "/Users/gwagdoseong/Documents/TA/geckodriver.exe"
driver <- rsDriver(browser = "firefox", extraCapabilities = list(firefoxOptions = list(binary = path)))
remote_driver <- driver[["client"]]


remote_driver$navigate("https://www.airportal.go.kr/life/airinfo/RaSkeFrmMain.jsp")
for (page in 2:52) {
  
  remote_driver$switchToFrame(remote_driver$findElement("xpath", '//iframe[@name="main"]'))
  
  input_element <- remote_driver$findElement("id", "current_dt_from")
  input_element$clearElement()
  input_element$sendKeysToElement(list("20230915"))
  
  input_element <- remote_driver$findElement("id", "current_dt_to")
  input_element$clearElement()
  input_element$sendKeysToElement(list("20230916"))
  
  
  remote_driver$switchToFrame(remote_driver$findElement("xpath", '//iframe[@name="airportframe"]'))
  
  select_element <- remote_driver$findElement("name", "ser_airport")
  remote_driver$executeScript( "arguments[0].value =''; "
                               , list(select_element))
  
  remote_driver$executeScript(
    "var selectElement = arguments[0];
   var event = new Event('change', { bubbles: true });
   selectElement.dispatchEvent(event);",
    list(select_element)
  )
  
  remote_driver$switchToFrame(NULL)
  remote_driver$switchToFrame(remote_driver$findElement("xpath", '//iframe[@name="main"]'))
  
  remote_driver$executeScript("go_search();")
  
  
  
  remote_driver$switchToFrame(remote_driver$findElement("xpath", '//iframe[@name="sframe"]'))
  

  
  # 여기에 스크래핑 코드 작성...
  
  
  
  script <- paste0("go_page(", page, ");")
  remote_driver$executeScript(script)
  
  Sys.sleep(2)  # 2초 대기
  
  
}

driver$server$stop()





page_content <- remote_driver$getPageSource()
page <- read_html(page_content[[1]])


form_element <- page %>%
  html_node("form")
tables <- form_element %>%
  html_nodes("table")
third_table <- tables[[3]]
tr <- third_table %>%
  html_nodes("tr")


td_contents_list <- list()
for (tr_node in tr) {
  td_contents <- tr_node %>%
    html_nodes("td") %>%
    html_text(trim = TRUE)
  
  td_contents_list <- append(td_contents_list, list(td_contents))}

odd_td_contents_list <- td_contents_list[seq(1, length(td_contents_list), by = 2)]

cleaned_odd_td_contents_list <- lapply(odd_td_contents_list, function(td_contents) {
  cleaned_td_contents <- td_contents[c(TRUE, FALSE)]  
  cleaned_td_contents <- cleaned_td_contents[cleaned_td_contents != ""]  
  return(cleaned_td_contents)})

cleaned_odd_td_contents_list


df <- data.frame(matrix(character(0), ncol = 9))
for (i in 1:length(cleaned_odd_td_contents_list)) {
  row <- as.data.frame(t(cleaned_odd_td_contents_list[[i]]))
  df <- rbind(df, row)
}

df

