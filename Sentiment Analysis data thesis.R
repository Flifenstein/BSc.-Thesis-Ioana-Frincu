install.packages("tidyverse")
install.packages("tokenizers")
install.packages("jtools")
install.packages("stringr")  
install.packages("tm")
install.packages("SentimentAnalysis")
install.packages("syuzhet")
install.packages("tidyverse")
install.packages("SnowballC")
install.packages("wordcloud")
install.packages("RColorBrewer")
install.packages("ggplot2")
install.packages("RCurlr")

library(jtools)
library(tidyverse)
library(foreign)
library(broom)
library(tokenizers)
library(stringr) 
library(tm)
library(SentimentAnalysis)
library(syuzhet)
library(tidyverse)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(ggplot2)
library(RCurlr)

setwd("C:/Users/Ioana/Desktop")


data1 <- read.csv("storm.csv", header= T, sep = ',')

#create corpus. Select the colomun which you want to analyze 

dfCorpus <- SimpleCorpus(VectorSource(data1$Q.QUESTIONS..CHRONOLOGICAL.ORDER.))
View(dfCorpus)

# clean data
data1 <- na.omit(data1)

# 1. Stripping any extra white space:
dfCorpus <- tm_map(dfCorpus, stripWhitespace)
# 2. Transforming everything to lowercase
dfCorpus <- tm_map(dfCorpus, content_transformer(tolower))
# 3. Removing numbers 
dfCorpus <- tm_map(dfCorpus, removeNumbers)
# 4. Removing punctuation
dfCorpus <- tm_map(dfCorpus, removePunctuation)
# 5. Removing stop words
dfCorpus <- tm_map(dfCorpus, removeWords, stopwords("english"))

# test the content
dfCorpus[["460"]]$content

dfCorpus <- tm_map(dfCorpus, stemDocument)


#create document matrix

DTM <- DocumentTermMatrix(dfCorpus)
View(DTM)

inspect(DTM)

#form the frequency  words
sums <- as.data.frame(colSums(as.matrix(DTM)))
sums <- rownames_to_column(sums) 
colnames(sums) <- c("term", "count")
sums <- arrange(sums, desc(count))
head <- sums[1:75,]

#create frequency barplot

barplot(head$count, names = head$term,  beside = TRUE, main = "Top 10 words" ,las = 1,  xlab="Frequency of words", col="#69b3a2", horiz=T , xlim = c(0, 800))

#create wordcloud
wordcloud(words = head$term, freq = head$count, min.freq = 100,
          max.words=100, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))



#start sentiment analysis
sent <- analyzeSentiment(DTM, language = "english")
# were going to just select the Harvard-IV dictionary results ..  
sent <- sent[,1:4]
#Organizing it as a dataframe
sent <- as.data.frame(sent)
sent <- na.omit(sent)
# Now lets take a look at what these sentiment values look like. 
head(sent)

summary(sent$SentimentGI)

# Start by attaching to other data which has the company names 
final <- bind_cols(data1$score, sent)
# now lets get the top 5 
final %>% group_by(data1$score) %>%
  summarize(sent = mean(SentimentGI)) %>%
  arrange(sent) %>%
  head(n= 5)


sent2 <- get_nrc_sentiment(data1$Q.QUESTIONS..CHRONOLOGICAL.ORDER.)
# Let's look at the corpus as a whole again:
sent3 <- as.data.frame(colSums(sent2))
sent3 <- rownames_to_column(sent3) 
colnames(sent3) <- c("emotion", "count")
plot <- ggplot(sent3, aes(x = emotion, y = count, fill = emotion)) + geom_bar(stat = "identity") + theme_minimal() + theme(legend.position="none", panel.grid.major = element_blank()) + labs( x = "Emotion", y = "Total Count") + ggtitle("Sentiment of Posts") + theme(plot.title = element_text(hjust=0.5))
plot




