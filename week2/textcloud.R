source('pttTestFunction.R')

#https://www.ptt.cc/bbs/WorldCup/index.html

id = c(1333:1334)
URL = paste0("https://www.ptt.cc/bbs/WorldCup/index", id, ".html")

filename = paste0(id, ".txt")
pttTestFunction(URL[1], filename[1])
mapply(pttTestFunction, 
       URL = URL, filename = filename)


rm(list=ls(all.names = TRUE))
library(NLP)
library(tm)
library(jiebaRD)
library(jiebaR)
library(RColorBrewer)
library(wordcloud)
filenames <- list.files(getwd(), pattern="*.txt")
files <- lapply(filenames, readLines)
docs <- Corpus(VectorSource(files))
#�����i�঳���D���Ÿ�
toSpace <- content_transformer(function(x, pattern) {
  return (gsub(pattern, " ", x))
}
)
docs <- tm_map(docs, toSpace, "��")
docs <- tm_map(docs, toSpace, "��")
docs <- tm_map(docs, toSpace, "��")
docs <- tm_map(docs, toSpace, "�E")
docs <- tm_map(docs, toSpace, "��")
docs <- tm_map(docs, toSpace, "��")
docs <- tm_map(docs, toSpace, "�O")
docs <- tm_map(docs, toSpace, "�ݪO")
docs <- tm_map(docs, toSpace, "�@��")
docs <- tm_map(docs, toSpace, "�o�H��")
docs <- tm_map(docs, toSpace, "�����~�{")
docs <- tm_map(docs, toSpace, "[a-zA-Z]")
#�������I�Ÿ� (punctuation)
#�����Ʀr (digits)�B�ť� (white space)
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, stripWhitespace)
docs

## <<SimpleCorpus>>
## Metadata:  corpus specific: 1, document level (indexed): 0
## Content:  documents: 10

mixseg = worker()
jieba_tokenizer=function(d){
  unlist(segment(d[[1]],mixseg))
}
seg = lapply(docs, jieba_tokenizer)
freqFrame = as.data.frame(table(unlist(seg)))
freqFrame = freqFrame[order(freqFrame$Freq,decreasing=TRUE), ]
library(knitr)

wordcloud(freqFrame$Var1,freqFrame$Freq,
          scale=c(5,0.1),min.freq=50,max.words=150,
          random.order=TRUE, random.color=FALSE, 
          rot.per=.1, colors=brewer.pal(8, "Dark2"),
          ordered.colors=FALSE,use.r.layout=FALSE,
          fixed.asp=TRUE)
kable(head(freqFrame), format = "markdown")

