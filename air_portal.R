library(RSelenium)
library(rvest)
library(dplyr)
library(writexl)

setwd("/Users/gwagdoseong/Documents/TA")
path = "/Users/gwagdoseong/Documents/TA/geckodriver.exe"
driver <- rsDriver(browser = "firefox", extraCapabilities = list(firefoxOptions = list(binary = path)))
remote_driver <- driver[["client"]]




for(dep_arr in c("D","A")){
for(date in as.character(seq(as.Date("2023-09-01"), as.Date("2023-09-02"), by = "days"))){
df <- data.frame(matrix(ncol = 9))
colnames(df) <- c("airline", "flight_num", "dep_arr_region", "plan", "expect", "Arrival", "category", "status","airport")
  
for(airport in c("RKSI","RKSS" ,"RKTU", "RKNY", "RKJK", "RKNW", "RKPK", "RKPC", "RKTN",
                 "RKJJ", "RKJY", "RKPU", "RKTH", "RKPS","RKJB")){
  
  remote_driver$navigate("https://www.airportal.go.kr/life/airinfo/RbHanFrmMain.jsp")
  remote_driver$switchToFrame(remote_driver$findElement("xpath", '//iframe[@name="main"]'))
  
  radio_input_xpath <- paste("//input[@type='radio' and @value='", dep_arr, "']", sep = "")
  radio_input <- remote_driver$findElement("xpath", radio_input_xpath)
  remote_driver$executeScript("arguments[0].click();", list(radio_input))
  
  input_element <- remote_driver$findElement("id", "current_date")
  input_element$clearElement()
  input_element$sendKeysToElement(list(date))
  
  select_element <- remote_driver$findElement("name", "airport")
  remote_driver$executeScript( paste("arguments[0].value =", "'", airport, "';", sep = "")
                               , list(select_element))
  
  Sys.sleep(3.2)
  remote_driver$executeScript("go_search();")
  Sys.sleep(3.2)
  

remote_driver$switchToFrame(remote_driver$findElement("xpath", '//iframe[@name="sframe"]'))
page_content <- remote_driver$getPageSource()
page <- read_html(page_content[[1]])

form_element <- page %>%
  html_node("form")
table_element <- form_element %>%
  html_node("table")
table_element2 <- table_element %>%
  html_node("table")
tbody <- table_element2 %>%
  html_node("tbody")
tr <- tbody %>%
  html_nodes("tr")

td_contents_list <- list()
for (tr_node in tr) {
  td_contents <- tr_node %>%
    html_nodes("td") %>%
    html_text(trim = TRUE)
  
  td_contents_list <- append(td_contents_list, list(td_contents))}

td_contents_list_except_last <- td_contents_list[-length(td_contents_list)]
odd_td_contents_list <- td_contents_list_except_last[seq(1, length(td_contents_list_except_last), by = 2)]

cleaned_odd_td_contents_list <- lapply(odd_td_contents_list, function(td_contents) {
  cleaned_td_contents <- td_contents[c(TRUE, FALSE)]  
  cleaned_td_contents <- cleaned_td_contents[cleaned_td_contents != ""]  
  return(cleaned_td_contents)})

for (i in 1:length(cleaned_odd_td_contents_list)) {
  
  row <- cleaned_odd_td_contents_list[[i]]
  row$airport <- airport
  df= rbind( df, unlist(row)
  )
}


excel_file_name <- paste0(date, "_", dep_arr, ".xlsx")
write_xlsx(df, excel_file_name)
}}}


driver$server$stop()


