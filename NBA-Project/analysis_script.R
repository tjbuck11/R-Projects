# Imports
knitr::opts_chunk$set(echo = TRUE)
library(tidyverse)
library(lubridate)
library(scales)
library(gridExtra)
library(grid)
library(modelr)
library(stringr)

# Loading data and transformations
rookie_1 = read_csv("Data/NBA_rookies.csv") %>%
  rename(hof = "Hall of Fame Class",
         name = "Name")
player = read_csv("Players_info.csv")

rookie_1$hof[rookie_1$name=="Tracy McGrady"] = 2017
rookie_1$hof[rookie_1$name=="Ray Allen"] = 2018
rookie_1$hof[rookie_1$name=="Grant Hill"] = 2018
rookie_1$hof[rookie_1$name=="Jason Kidd"] = 2018
rookie_1$hof[rookie_1$name=="Steve Nash"] = 2018
rookie_1$hof[rookie_1$name=="Dino Radja"] = 2018
rookie_1$hof[rookie_1$name=="Vlade Divac"] = 2019
rookie_1$hof[rookie_1$name=="Kobe Bryant"] = 2020
rookie_1$hof[rookie_1$name=="Tim Duncan"] = 2020
rookie_1$hof[rookie_1$name=="Kevin Garnett"] = 2020
rookie_1$hof[rookie_1$name=="Chris Bosh"] = 2021
rookie_1$hof[rookie_1$name=="Paul Pierce"] = 2021
rookie_1$hof[rookie_1$name=="Ben Wallace"] = 2021
rookie_1$hof[rookie_1$name=="Chris Webber"] = 2021
rookie_1$hof[rookie_1$name=="Toni Kukoc"] = 2021
rookie_1$hof[rookie_1$name=="Manu Ginobili"] = 2022
rookie_1$hof[rookie_1$name=="Tim Hardaway"] = 2022

names(rookie_1) <- str_to_lower(names(rookie_1))

rookie = rookie_1 %>% 
  left_join(player, by = c("name" = "Player")) %>% 
  select(-...1) %>% 
  rename(college = "collage",
         year_drafted = "year drafted",
         made_3p = "3p made") %>% 
  mutate(hof_new = case_when(is.na(hof) ~ "Not HOF",
                             hof != "NA" ~ "HOF"),
         approximate_age = year_drafted - born)

rookie$height[rookie$name=="Kevin McHale"] = 208
rookie$weight[rookie$name=="Kevin McHale"] = 210/2.2
rookie$height[rookie$name=="Isiah Thomas"] = 73*2.54
rookie$weight[rookie$name=="Isiah Thomas"] = 180/2.2
rookie$height[rookie$name=="Dominique Wilkins"] = 80*2.54
rookie$weight[rookie$name=="Dominique Wilkins"] = 215/2.2
rookie$height[rookie$name=="James Worthy"] = 81*2.54
rookie$weight[rookie$name=="James Worthy"] = 225/2.2
rookie$height[rookie$name=="Clyde Drexler"] = 79*2.54
rookie$weight[rookie$name=="Clyde Drexler"] = 225/2.2
rookie$height[rookie$name=="Ralph Sampson"] = 88*2.54
rookie$weight[rookie$name=="Ralph Sampson"] = 228/2.2
rookie$height[rookie$name=="Charles Barkley"] = 78*2.54
rookie$weight[rookie$name=="Charles Barkley"] = 252/2.2
rookie$height[rookie$name=="Hakeem Olajuwon"] = 84*2.54
rookie$weight[rookie$name=="Hakeem Olajuwon"] = 255/2.2
rookie$height[rookie$name=="John Stockton"] = 73*2.54
rookie$weight[rookie$name=="John Stockton"] = 170/2.2
rookie$height[rookie$name=="Michael Jordan"] = 78*2.54
rookie$weight[rookie$name=="Michael Jordan"] = 198/2.2
rookie$height[rookie$name=="Chris Mullin"] = 78*2.54
rookie$weight[rookie$name=="Chris Mullin"] = 200/2.2
rookie$height[rookie$name=="Joe Dumars"] = 75*2.54
rookie$weight[rookie$name=="Joe Dumars"] = 190/2.2
rookie$height[rookie$name=="Karl Malone"] = 81*2.54
rookie$weight[rookie$name=="Karl Malone"] = 250/2.2
rookie$height[rookie$name=="Patrick Ewing"] = 84*2.54
rookie$weight[rookie$name=="Patrick Ewing"] = 240/2.2
rookie$height[rookie$name=="Dennis Rodman"] = 79*2.54
rookie$weight[rookie$name=="Dennis Rodman"] = 210/2.2
rookie$height[rookie$name=="Reggie Miller"] = 79*2.54
rookie$weight[rookie$name=="Reggie Miller"] = 185/2.2
rookie$height[rookie$name=="Scottie Pippen"] = 80*2.54
rookie$weight[rookie$name=="Scottie Pippen"] = 210/2.2
rookie$height[rookie$name=="Mitch Richmond"] = 77*2.54
rookie$weight[rookie$name=="Mitch Richmond"] = 215/2.2
rookie$height[rookie$name=="David Robinson"] = 85*2.54
rookie$weight[rookie$name=="David Robinson"] = 235/2.2
rookie$height[rookie$name=="Gary Payton"] = 76*2.54
rookie$weight[rookie$name=="Gary Payton"] = 180/2.2
rookie$height[rookie$name=="Dikembe Mutombo"] = 86*2.54
rookie$weight[rookie$name=="Dikembe Mutombo"] = 245/2.2
rookie$height[rookie$name=="Alonzo Mourning"] = 82*2.54
rookie$weight[rookie$name=="Alonzo Mourning"] = 240/2.2
rookie$height[rookie$name=="Shaquille O'Neal"] = 85*2.54
rookie$weight[rookie$name=="Shaquille O'Neal"] = 325/2.2
rookie$height[rookie$name=="Arvydas Sabonis"] = 87*2.54
rookie$weight[rookie$name=="Arvydas Sabonis"] = 279/2.2
rookie$height[rookie$name=="Allen Iverson"] = 72*2.54
rookie$weight[rookie$name=="Allen Iverson"] = 165/2.2
rookie$height[rookie$name=="Yao Ming"] = 90*2.54
rookie$weight[rookie$name=="Yao Ming"] = 310/2.2


rookie = rookie %>%
  filter(!is.na(pts)) %>% 
  filter(!is.na(eff)) %>% 
  filter(!is.na(height)) %>% 
  filter(!is.na(weight)) %>%
  select(name, hof, year_drafted, gp, min, pts, eff, height, weight)

hof = rookie %>%
  drop_na(hof)

all_rookie = rookie %>% 
  filter(is.na(hof)) %>% 
  filter(!is.na(height)|!is.na(weight))

rookie = rookie %>% 
  mutate(hof_new = case_when(is.na(hof) ~ "Not HOF",
                             hof != "NA" ~ "HOF"))

# Determining prevalence of Hall of Fame player
prob = rookie %>% 
  group_by(hof_new) %>% 
  summarize(count = n())
total = prob$count[1]+prob$count[2]
prob2 = prob %>% 
  mutate(p = count/total)
prob2

# Statistics by HOF vs non-HOF players
pts = ggplot(rookie)+
  geom_boxplot(aes(x = hof_new, pts), fill = "yellow", color = "black", width = 0.5)+
  ylab("Points Per Game")+
  xlab("Hall of Fame Status")+
  ggtitle("Points Per Game Summary")

eff = ggplot(rookie)+
  geom_boxplot(aes(hof_new, eff), fill = "cyan", color = "black", width = 0.5)+
  ylab("Efficiency")+
  xlab("Hall of Fame Status")+
  ggtitle("Efficiency Summary")

grid.arrange(pts,eff, ncol=2, nrow=1, top = textGrob("Summary of Key Variables"))

# How key stats change over time for HOF players
points = ggplot(hof, aes(x = year_drafted, y = pts))+
  geom_point()+
  geom_smooth(formula = y~x, se=FALSE, method = "lm")+
  xlab("Year Drafted")+
  ylab("Points")+
  ggtitle("Points Per Game")

efficiency = ggplot(hof, aes(x = year_drafted, y = eff))+
  geom_point()+
  geom_smooth(formula = y~x, se=FALSE, method= "lm")+
  xlab("Year Drafted")+
  ylab("Efficiency Rating")+
  ggtitle("Efficiency Rating")

grid.arrange(points,efficiency,ncol=2, nrow=1, top = textGrob("Trend in Key Game Statistics"))

# Games played for HOF players over time
ggplot(hof, aes(x = year_drafted, y = gp))+
  geom_point()+
  geom_smooth(formula = y~x, se=FALSE, method = "loess")+
  xlab("Year Drafted")+
  ylab("Games Played")+
  ggtitle("Trend in Games Played Among Hall of Fame Rookies")

# Examining if a linear model is appropriate
pts_lm = lm(pts~year_drafted, hof)
eff_lm = lm(eff~year_drafted, hof)

hof_pts = hof %>% 
  add_residuals(pts_lm)

hof_eff = hof %>% 
  add_residuals(eff_lm)

resid_pts = ggplot(hof_pts, aes(year_drafted, resid))+
  geom_point()+
  geom_hline(yintercept = 0, color = "red")+
  xlab("Year Drafted")+
  ylab("Residuals")+
  ggtitle("Points Per Game")

resid_eff = ggplot(hof_eff, aes(year_drafted, resid))+
  geom_point()+
  geom_hline(yintercept = 0, color = "red")+
  xlab("Year Drafted")+
  ylab("Residuals")+
  ggtitle("Efficiency Rating")

geom_norm_density = function(mu=0,sigma=1,a=NULL,b=NULL,color="blue",...)
{
  if ( is.null(a) )
  {
    a = qnorm(0.0001,mu,sigma)
  }
  if ( is.null(b) )
  {
    b = qnorm(0.9999,mu,sigma)
  }
  x = seq(a,b,length.out=1001)
  df = data.frame(
    x=x,
    y=dnorm(x,mu,sigma)
  )
  geom_line(aes(x=x,y=y), data = df, color=color,...)
}

pts_mean = mean(hof_pts$resid)
pts_sd = sd(hof_pts$resid)

den_pts = ggplot(hof_pts, aes(resid))+
  geom_density()+
  geom_norm_density(mu = pts_mean, sigma = pts_sd, color = "blue")+
  ylab("Density")+
  xlab("Residuals")+
  ggtitle("Points Per Game")

eff_mean = mean(hof_eff$resid)
eff_sd = sd(hof_eff$resid)

den_eff = ggplot(hof_eff, aes(resid))+
  geom_density()+
  geom_norm_density(mu = eff_mean, sigma = eff_sd, color = "blue")+
  ylab("Density")+
  xlab("Residuals")+
  ggtitle("Efficiency Rating")


grid.arrange(resid_pts,resid_eff,den_pts, den_eff, ncol=2, nrow=2, top = textGrob("Residuals and Distributions in Game Statistics for Hall of Famers"))

# Looking at models output for t-test and getting p-value
## Points
summary(pts_lm)
pt(-0.708, df=40, lower.tail=TRUE)

## Efficiency
summary(eff_lm)
pt(-0.288, df=40, lower.tail=TRUE)

# Calculating statistics for hypothesis tests
## Points
mean(hof$pts) - mean(all_rookie$pts)
sd(hof$pts)
sd(all_rookie$pts)

t.test(hof$pts, all_rookie$pts, alternative = "greater")

## Efficiency
mean(hof$eff) - mean(all_rookie$eff)
sd(hof$eff)
sd(all_rookie$eff)

t.test(hof$eff, all_rookie$eff, alternative = "greater")

# Calculating Confidence Intervals
##Points
pts = hof %>% 
  pull(pts)
t.test(pts)

confidence <- function(vector) {
  n <- length(vector)
  stan_dev <- sd(vector)
  average <- mean(vector)
  error <- qt((0.95 + 1)/2, df = n - 1) * stan_dev / sqrt(n)
  result <- c(average - error,average + error)
  return(result)
}

confidence(pts)
rookie_pts = all_rookie %>% 
  pull(pts)
confidence(rookie_pts)

## Efficiency
eff = hof %>% 
  pull(eff)
rookie_eff = all_rookie %>% 
  pull(eff)

confidence(eff)
confidence(rookie_eff)

# Predicting HOF players points per game based on their height
height_pts_lm = lm(pts~height, hof)
summary(height_pts_lm)

# Plotting the model
ggplot(hof, aes(height, pts)) +
  geom_point() +
  xlab("Height (cm)") +
  ylab("Points Per Game") +
  ggtitle("Linear Regression model for Height vs Points per Game")+
  geom_abline(aes(slope = 0.137, intercept = -13.612), color="red", size = 1)

# Calculating p-value for a hypothesis test
pt(1.619, df=40, lower.tail=FALSE)