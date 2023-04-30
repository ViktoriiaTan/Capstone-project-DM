library(tidytext)
library(tm)
library(RColorBrewer)
library(wordcloud)
library(topicmodels)
library(syuzhet)

# Combine titles and abstracts
df$text <- paste(df$Title, df$Abstract, sep = " ")

# Create a corpus from the text data
corpus <- VCorpus(VectorSource(df$text))

# Clean and preprocess the text data
corpus_clean <- corpus %>%
  tm_map(content_transformer(tolower)) %>%
  tm_map(removePunctuation) %>%
  tm_map(removeNumbers) %>%
  tm_map(removeWords, stopwords("english")) %>%
  tm_map(stripWhitespace)

# Create a TermDocumentMatrix
tdm <- TermDocumentMatrix(corpus_clean)

# Convert to a data frame and sort by frequency
word_freq <- rowSums(as.matrix(tdm))
word_freq_df <- data.frame(word = names(word_freq), freq = word_freq) %>%
  arrange(desc(freq))

# Plot word cloud
wordcloud(words = word_freq_df$word, freq = word_freq_df$freq, min.freq = 5,
          random.order = FALSE, colors = brewer.pal(8, "Dark2"))
