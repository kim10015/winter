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


filenames<-list.files(full.names = TRUE)
All<-lapply(filenames,function(i){
  read.csv(i,header=TRUE,skip=4)
})
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
### ggplot을 이용해서 35번 수집한 시간별 추이를 봅니다.
![1](https://user-images.githubusercontent.com/57972968/70847919-8ce1b880-1ead-11ea-8b48-bdb34e25fcbc.PNG)
### 전체 평균은 8.7정도이며 최대 10 최소 6.4로 나왔습니다

```xy<-as.matrix(x)
table(xy)
plot(table(xy))
```
### 이제 점수 빈도표를 만들어서 어느 점수가 많은지 확인해봅니다.
![2](https://user-images.githubusercontent.com/57972968/70847945-09749700-1eae-11ea-9416-25e64577c2fb.PNG)
### 10점이 제일 많은 빈도며 다음으로 9점대신 8점이 높은 점수 빈도를 보였습니다.
```y<-cbind(y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13,y14,y15,y16,y17,y18,y19,y20,y21,y22,y23,y24,y25,y26,y27,y28,y29,y30,y31,y32,y33,y34,y35)
y
example<-as.matrix(y)
sum(str_count(example,'재밌'))
sum(str_count(example,'재미'))
sum(str_count(example,'감동'))
sum(str_count(example,'최고'))
sum(str_count(example,'스토리'))
sum(str_count(example,'1편'))
sum(str_count(example,'노래'))
sum(str_count(example,'엘사'))
sum(str_count(example,'안나'))
sum(str_count(example,'올라프'))
sum(str_count(example,'전작'))
sum(str_count(example,'아이'))
sum(str_count(example,'렛잇고'))
sum(str_count(example,'여운'))
sum(str_count(example,'겨울왕국'))
sum(str_count(example,'노잼'))
sum(str_count(example,'좋아요'))
sum(str_count(example,'지루'))
sum(str_count(example,'명작'))
word<-c("재밌","재미","감동","최고","스토리","노래","엘사","안나","올라프","전작","아이","1편","렛잇고","여운","겨울왕국","노잼","좋아요","지루","명작")
fre<-c(57,28,27,18,59,62,40,51,15,16,11,25,6,11,38,2,3,8,3)
wordcloud(word,fre)
```
### 이제 많이 언급된 문자열을 찾기위해 stringr 패키지의 str_count를 이용하여 몇번 나왔는지 확인합니다.
### 구한 값들을 word와 fre에 행렬로 값을 넣습니다.
### wordcloud패키지의 wordcloud 함수를 이용해서 텍스트 시각화를 합니다
### ~~이 부분은 텍스트마이닝 때 더욱 자세하게 배우면 좋을 것 같습니다~~
![3](https://user-images.githubusercontent.com/57972968/70847949-15605900-1eae-11ea-8b5d-3b07bca87085.PNG)
### 나온 텍스트 시각화입니다.
