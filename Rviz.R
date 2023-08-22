library(dslabs)
data(murders)
ggplot(data = murders)
p <-murders %>% ggplot()
class(p)
print(p)
p

#first way 
murders |> ggplot() + 
  geom_point(aes(x = population/10^6, y = total))

#second way
p + geom_point(aes(population/10^6, total))

#second layer - labelling the points
p + geom_point(aes(population/10^6, total)) + 
  geom_text(aes(population/10^6, total, label = abb))

#third layer - changing point size
p + geom_point(aes(population/10^6, total, size = 3)) +
  geom_text(aes(population/10^6, total, label = abb))

#4th layer - moving the text from the point
p + geom_point(aes(population/10^6, total, size = 3)) +
  geom_text(aes(population/10^6, total, label = abb, nudge_x = 1.5))

#using global aesthetic mapping to reduce code redundancy
p <- murders %>% ggplot(aes(population/10^6, total, label = abb))
p + geom_point(size = 3) + 
  geom_text(nudge_x = 1.5)

#scaling axis
p + geom_point(size = 3) +  
  geom_text(nudge_x = 0.05) + 
  scale_x_continuous(trans = "log10") +
  scale_y_continuous(trans = "log10") 

#simplifying scaling
p + geom_point(size = 3) +  
  geom_text(nudge_x = 0.05) + 
  scale_x_log10() +
  scale_y_log10() 

#adding labels and a title
p + geom_point(size = 3) +  
  geom_text(nudge_x = 0.05) + 
  scale_x_log10() +
  scale_y_log10() +
  xlab("Populations in millions (log scale)") + 
  ylab("Total number of murders (log scale)") +
  ggtitle("US Gun Murders in 2010")

#redefining p without points function
p <-  murders |> ggplot(aes(population/10^6, total, label = abb)) +   
  geom_text(nudge_x = 0.05) + 
  scale_x_log10() +
  scale_y_log10() +
  xlab("Populations in millions (log scale)") + 
  ylab("Total number of murders (log scale)") +
  ggtitle("US Gun Murders in 2010")

#adding colour to points
p + geom_point(size = 3, color ="blue")

#adding colors based on region
p + geom_point(aes(col=region), size = 3)

#finding out the rate
r <- murders |> 
  summarize(rate = sum(total) /  sum(population) * 10^6) |> 
  pull(rate)

#adding the gradient line on to the plot
p + geom_point(aes(col=region), size = 3) + 
  geom_abline(intercept = log10(r))
p <- p + geom_abline(intercept = log10(r), lty = 2, color = "darkgrey") +
  geom_point(aes(col=region), size = 3) 
p <- p + scale_color_discrete(name = "Region") 

#adding a theme
ds_theme_set()
library(ggthemes)
p + theme_economist()

#SUMMARY 
library(ggthemes)
library(ggrepel)

r <- murders |> 
  summarize(rate = sum(total) /  sum(population) * 10^6) |>
  pull(rate)

murders |> ggplot(aes(population/10^6, total, label = abb)) +   
  geom_abline(intercept = log10(r), lty = 2, color = "darkgrey") +
  geom_point(aes(col=region), size = 3) +
  geom_text_repel() + 
  scale_x_log10() +
  scale_y_log10() +
  xlab("Populations in millions (log scale)") + 
  ylab("Total number of murders (log scale)") +
  ggtitle("US Gun Murders in 2010") + 
  scale_color_discrete(name = "Region") +
  theme_economist()



