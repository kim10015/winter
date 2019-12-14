# winter
###네이버 최근 평점과 리뷰 내용을 크롤링하고 분석했습니다.
```library(rvest)
library(RSelenium)
library(stringr)
library(R6)
library(XML)
require(lubridate)

remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4446L,
  browserName = "chrome"
)

remDr$open()

remDr$navigate('https://movie.naver.com/movie/point/af/list.nhn?st=mcode&sword=136873&target=after')


All_textreview=c()
source<-remDr$getPageSource()[[1]] 
main <- read_html(source)

textreview=html_nodes(main,css='.title')
textreview=textreview%>%html_text() 
textreview=gsub("(\r)(\n)(\t)*","",textreview)
textreview=gsub("\t","",textreview)
textreview=gsub("\n","",textreview)
textreview=gsub("신고","",textreview)
textreview=gsub("겨울왕국 2별점 - 총 10점 중","",textreview)
All_textreview=c(textreview)
All_textreview

mainfo=html_nodes(main,css='.list_netizen_score')
scorereview=mainfo%>%html_text() 
scorereview=gsub("\t","",scorereview)
scorereview=gsub("\n","",scorereview)
scorereview=gsub("신고","",scorereview)
scorereview=gsub("별점 - 총 10점 중","",scorereview)
All_scorereview=c(scorereview)
All_scorereview
score<-as.numeric(All_scorereview)
score
scoremean=sum(score)/length(score)
scoremean

winter<- 'd:/winter'
setwd(winter)
date<-Sys.Date()
h<-hour(Sys.time())
m<-minute(Sys.time())
now <- paste(date, h, m, sep='-')
now.folder <- paste(winter, now, sep='/')
if(!dir.exists(now.folder)) dir.create(now.folder)
setwd(now.folder)

write.csv(score,file="score.csv")
write.csv(All_textreview,file="textreview.csv")

remDr$close()```

