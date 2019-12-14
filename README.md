# 겨울왕국 평점,리뷰 크롤링 및 분석
### 네이버 영화의 최근 평점과 리뷰 내용을 크롤링하고 분석했습니다.
```library(rvest)
library(RSelenium)
library(stringr)
library(R6)
library(XML)
require(lubridate)
library(dplyr)
library(wordcloud)
library(ggplot2)
```
### 먼저 필요한 패키지들을 불러옵니다.

```remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4446L,
  browserName = "chrome"
)

remDr$open()

remDr$navigate('https://movie.naver.com/movie/point/af/list.nhn?st=mcode&sword=136873&target=after')
```
### 리뷰 url을 불러옵니다.

```All_textreview=c()
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
```
### 상위 10개의 리뷰와 평점을 긁어오기 위한 작업입니다.
### remDr$getPageSource를 이용해서 페이지 소스를 모두 긁어옵니다.
### 이 소스를 read_html로 읽은 후 css가 .title인 부분을 긁어옵니다.
### 필요없는 부분을 gsub로 삭제하고 All_textreview에 넣습니다.

```mainfo=html_nodes(main,css='.list_netizen_score')
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
```
### 마찬가지로 평점 부분만 크롤링 하기위해 .list_netizen_score 부분의 css를 긁어옵니다.
### gsub로 필요없는 부분을 삭제하고 점수를 평균을 계산합니다.

```winter<- 'd:/winter'
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

remDr$close()
```
### 이제 시간별 추이를 알아보기 위해 별도의 폴더를 만들고 지정 후 시간별로 저장을 합니다.
### 하나는 점수, 하나는 텍스트로 저장을 합니다.
### 이제 제어한 창을 닫습니다.
