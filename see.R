library(dplyr)
library(wordcloud)
library(ggplot2)
library(stringr)


filenames<-list.files(full.names = TRUE)
All<-lapply(filenames,function(i){
  read.csv(i,header=TRUE,skip=4)
})

x<-cbind(x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,x32,x33,x34,x35)
a<-sum(x)/350
xx<-apply(x,2,mean)
xx<-data.frame(xx)
ggplot(xx,aes(1:35,xx))+
  geom_line()

xy<-as.matrix(x)
table(xy)
plot(table(xy))


y<-cbind(y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13,y14,y15,y16,y17,y18,y19,y20,y21,y22,y23,y24,y25,y26,y27,y28,y29,y30,y31,y32,y33,y34,y35)
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

