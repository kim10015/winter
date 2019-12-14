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
### 이제 시간별 추이를 알아보기 위해 별도의 폴더를 만들고 지정 후 시간별로 .csv로 저장을 합니다.
### 하나는 점수, 하나는 텍스트로 저장을 합니다.
### 이제 제어한 창을 닫습니다.

```x1<-read.csv("D:\\winter\\2019-12-11-11-38\\score.csv")
x1$X<-NULL
x2<-read.csv("D:\\winter\\2019-12-11-13-11\\score.csv")
x2$X<-NULL
x3<-read.csv("D:\\winter\\2019-12-11-14-46\\score.csv")
x3$X<-NULL
.
.
x34<-read.csv("D:\\winter\\2019-12-14-0-41\\score.csv")
x34$X<-NULL
x35<-read.csv("D:\\winter\\2019-12-14-1-1\\score.csv")
x35$X<-NULL
y1<-read.csv("D:\\winter\\2019-12-11-11-38\\textreview.csv")
y1$X<-NULL
y2<-read.csv("D:\\winter\\2019-12-11-13-11\\textreview.csv")
y2$X<-NULL
.
.
.
y34<-read.csv("D:\\winter\\2019-12-14-0-41\\textreview.csv")
y34$X<-NULL
y35<-read.csv("D:\\winter\\2019-12-14-1-1\\textreview.csv")
y35$X<-NULL
```
### 시간별로 저장한 파일을 불러옵니다.
### 첫 칼럼은 삭제해줍니다.

```x<-cbind(x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,x32,x33,x34,x35)
a<-sum(x)/350
xx<-apply(x,2,mean)
xx<-data.frame(xx)
ggplot(xx,aes(1:35,xx))+
  geom_line()
```
### cbind를 이용해 합친 후 apply함수를 이용해 각 시간별로 평균 평점을 구합니다.
### ggplot을 이용해서 시간별 추이를 봅니다.
![1](https://user-images.githubusercontent.com/57972968/70847919-8ce1b880-1ead-11ea-8b48-bdb34e25fcbc.PNG)
