library(tidyverse)
library(tidytext)

Vocab <- read_csv("data/clean_posts.csv") %>% 
  unnest_tokens(word, Content) %>% 
  group_by(word) %>%
  summarise() %>% 
  arrange(word) %>% 
  mutate(word_ID_full = 1:n())

weighted_d <- list.files("data/Tree_Distance", full.names = TRUE) %>% 
  as_tibble() %>% 
  select(path = value) %>% 
  mutate(data = map(
    path, ~read_csv(.x, col_names = c("Sample", "d"))
  )
  ) %>% 
  unnest(data) %>% 
  left_join(read_csv("data/Samples.info/samples_info.csv"), by = "Sample") %>% 
  select(-path) %>% 
  arrange(Sample) %>% 
  select(Sample, Sample_prop, d)

p <- weighted_d %>% 
  ggplot() + 
  geom_point(aes(x = Sample_prop, y = d), alpha = 0.3, show.legend = F) + 
  geom_smooth(aes(x = Sample_prop, y = d), se = F) + 
  labs(y = "Distance between Topic Structures",
       x = "Sampling Proportion") + 
  theme_minimal() + 
  lims(y = c(0,3), x = c(0,1)) +
  theme(legend.position = "bottom")

p
p %>% ggsave(filename = "Figures/distance.pdf", 
             device = "pdf", 
             height = 6, 
             width=8)
