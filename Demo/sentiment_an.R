# Perform sentiment analysis
df$sentiment <- get_sentiment(df$Abstract, method = "syuzhet")

# Group sentiment values by year_received
sentiment_by_year <- df %>%
  group_by(year_received) %>%
  summarise(avg_sentiment = mean(sentiment, na.rm = TRUE))

# Visualize the sentiment trend over time
ggplot(sentiment_by_year, aes(x = year_received, y = avg_sentiment, group = 1)) +
  geom_line() +
  labs(title = "Sentiment Trend Over Time",
       x = "Year",
       y = "Average Sentiment") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave(path = "figs", filename = "Sentiment trend over time.png")
