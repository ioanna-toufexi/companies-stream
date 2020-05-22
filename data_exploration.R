resource_kind <- selected_df %>% 
  group_by(SICCode) %>% 
  summarise(count = n())

arranged <- streamed_df %>% 
  arrange(desc(event.published_at))

merged <- rbind(selected, selected_df)

selected_df <- selected_df %>% 
  mutate(SICCode.SicText_1 = map(SICCode.SicText_1,conc_or_repl))
  


# Concatenates vector data
conc_or_repl <- function(x) {
  if(identical(x,character(0))) {
    "No data"
  }
  else {
    str_c(x,collapse=", ")
  }
}