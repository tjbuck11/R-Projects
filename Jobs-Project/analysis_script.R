# Imports
knitr::opts_chunk$set(echo = TRUE)
library(tidyverse)
library(lubridate)
library(scales)
library(grid)
library(gridExtra)
source("import_scripts/viridis.R")
source("import_scripts/ggprob.R")

# Initial Data Cleaning
ba_df = read_csv("BusinessAnalyst.csv") %>% 
  rename(title = "Job Title",
         avg_salary = "Salary Estimate",
         description = "Job Description",
         name = "Company Name",
         ownership = "Type of ownership",
         easy_apply = "Easy Apply",
         competitors = "Competitors",
         rating = "Rating",
         revenue = "Revenue",
         location = "Location",
         headquarters = "Headquarters",
         size = "Size",
         founded = "Founded",
         industry = "Industry",
         sector = "Sector") %>% 
  select(-...1, -index) %>% 
  filter(grepl("K", avg_salary)) %>% 
  filter(grepl("employees", size)) %>% 
  mutate(salaryrange = NA)

salary_rangels = list()
salary_list = list()
for (i in ba_df$avg_salary)
{
  i = str_extract_all(i, "\\d{2,}")
  salary = (as.numeric(i[[1]][[2]])+as.numeric(i[[1]][[1]]))/2
  salary_list[[length(salary_list) + 1]] = 1000*salary
  salary_range = as.numeric(i[[1]][[2]])-as.numeric(i[[1]][[1]])
  salary_rangels[[length(salary_rangels) + 1]] = 1000*salary_range
}

ba_df$avg_salary = salary_list
ba_df$salaryrange = salary_rangels

size_list = list()
for (i in ba_df$size)
{
  if (i == "10000+ employees"){
    size_list[[length(size_list) + 1]] = 10000
  } else{
    i = str_extract_all(i, "\\d{1,}")
    size = (as.numeric(i[[1]][[2]])+as.numeric(i[[1]][[1]]))/2
    size_list[[length(size_list) + 1]] = size
  }
}
ba_df$size = size_list
ba_df$rating = as.numeric(ba_df$rating)
ba_df$avg_salary = unlist(ba_df$avg_salary)
ba_df$size = unlist(ba_df$size)
ba_df$founded = as.numeric(ba_df$founded)
ba_df$salaryrange = unlist(ba_df$salaryrange)

# Plot

total = ggplot(ba_df, aes(founded, avg_salary))+
  geom_point(alpha = 0.25, color = "blue")+
  geom_smooth(se=FALSE, method = "lm", color = "black")+
  scale_x_continuous(limits = c(1675,2020))+
  ylab("Average Salary ($)")+
  xlab("Year Company was Founded")+
  ggtitle("Full View")

zoom = ggplot(ba_df, aes(founded, avg_salary))+
  geom_point(alpha = 0.25, color = "blue")+
  geom_smooth(se=FALSE, method = "lm", color = "black")+
  scale_x_continuous(limits = c(1675,2020))+
  ylim(55000,65000)+
  ylab("Average Salary ($)")+
  xlab("Year Company was Founded")+
  ggtitle("Zoomed in View")

grid.arrange(total, zoom, ncol=1, nrow=2, top=textGrob("Company's Founding Year in relation to Average Salary of Listing"))

# Linear Model to assess relationship between salary and company founding
lm1 = lm(avg_salary~founded, data = ba_df)
summary(lm1)

# t-plot for hypothesis test
gt(df = 3417)+
  geom_t_fill(df = 3417, a = 1.8335)+
  geom_t_fill(df = 3417, b = -1.8335)+
  xlab("t-statistic")

# p-value for t-test
pt(-1.8335, df=3417, lower.tail=TRUE)*2

# New York filtered dataframe
ny_df = ba_df %>%
  filter(location == "New York, NY") %>% 
  summarize(mean = mean(avg_salary),
            sd = sd(avg_salary),
            sum = n())
ny = ba_df %>% 
  filter(location == "New York, NY") %>% 
  pull(avg_salary)

# t-test and plot for NY salary
t.test(ny, mu = 84950, alternative = "greater")
gt(df = 230)+
  geom_t_fill(df = 230, a = 0.5831)+
  xlab("t-statistic")

# Determining good sectors
good_sector = ba_df %>% 
  group_by(sector) %>% 
  summarize(salary = mean(avg_salary), rating = mean(rating), count = n()) %>% 
  filter(count>=30) %>% 
  filter(sector != -1) %>% 
  filter(salary>=75000 & rating>=3.6)

final_df = ba_df %>%
  filter(sector %in% good_sector$sector)

good_sector

# Filter for good sectors and create separate dataframes and plots
final_df = ba_df %>%
  filter(sector %in% good_sector$sector)

accounting = final_df %>%
  filter(sector == "Accounting & Legal") %>%
  select(avg_salary, rating, salaryrange)

aerospace = final_df %>%
  filter(sector == "Aerospace & Defense") %>%
  select(avg_salary, rating, salaryrange)

bus = final_df %>%
  filter(sector == "Business Services") %>%
  select(avg_salary, rating, salaryrange)

it = final_df %>%
  filter(sector == "Information Technology") %>%
  select(avg_salary, rating, salaryrange)

media = final_df %>%
  filter(sector == "Media") %>%
  select(avg_salary, rating, salaryrange)

acc = ggplot()+
  geom_point(accounting, mapping = aes(avg_salary, as.numeric(rating)), color = "red", alpha=0.5)+
  geom_smooth(accounting, mapping = aes(avg_salary, as.numeric(rating)), se = FALSE, color = "black", method = "lm")+
  xlab("Average Salary Per Year ($)")+
  ylab("Job Rating")+
  ggtitle("Accounting & Legal")

aero = ggplot()+
  geom_point(aerospace, mapping = aes(avg_salary, as.numeric(rating)), color = "purple", alpha=0.5)+
  geom_smooth(aerospace, mapping = aes(avg_salary, as.numeric(rating)), se = FALSE, color = "black",method = "lm")+
  xlab("Average Salary Per Year ($)")+
  ylab("Job Rating")+
  ggtitle("Aerospace & Defense")

business= ggplot()+
  geom_point(bus, mapping = aes(avg_salary, as.numeric(rating)), color = "orange", alpha=0.5)+
  geom_smooth(bus, mapping = aes(avg_salary, as.numeric(rating)), se = FALSE, color = "black",method = "lm")+
  xlab("Average Salary Per Year ($)")+
  ylab("Job Rating")+
  ggtitle("Business Services")

info = ggplot()+
  geom_point(it, mapping = aes(avg_salary, as.numeric(rating)), color = "green", alpha=0.5)+
  geom_smooth(it, mapping = aes(avg_salary, as.numeric(rating)), se = FALSE, color = "black",method = "lm")+
  xlab("Average Salary Per Year ($)")+
  ylab("Job Rating")+
  ggtitle("Information Technology")

media_g = ggplot()+
  geom_point(media, mapping = aes(avg_salary, as.numeric(rating)), color = "blue", alpha=0.5)+
  geom_smooth(media, mapping = aes(avg_salary, as.numeric(rating)), se = FALSE, color = "black",method = "lm")+
  xlab("Average Salary Per Year ($)")+
  ylab("Job Rating")+
  ggtitle("Media")

grid.arrange(acc,aero,business,info,media_g, ncol=3, nrow=2, top=textGrob("Linear Model of Job Rating based on Average Salary by Sector"))

# Create linear models for each
accounting_lm = lm(rating ~ avg_salary, data = accounting)
accounting_lm
aerospace_lm = lm(rating ~ avg_salary, data = aerospace)
aerospace_lm
business_lm = lm(rating ~ avg_salary, data = bus)
business_lm
it_lm = lm(rating ~ avg_salary, data = it)
it_lm
media_lm = lm(rating ~ avg_salary, data = media)
media_lm

# Salary Distributions
salary = ggplot()+
  geom_density(bus, mapping = aes(avg_salary), fill = "blue", alpha = 0.5)+
  geom_density(it, mapping = aes(avg_salary), fill = "yellow", alpha = 0.5)+
  xlab("Average Salary ($)")+
  ylab("Density")+
  ggtitle("Average Salary")

salary_range = ggplot()+
  geom_density(bus, mapping = aes(salaryrange), fill = "blue", alpha = 0.5)+
  geom_density(it, mapping = aes(salaryrange), fill = "yellow", alpha = 0.5)+
  xlab("Range of Salaries ($)")+
  ylab("Density")+
  ggtitle("Salary Range")

grid.arrange(salary,salary_range,ncol=2, nrow=1, top=textGrob("Distribution of Salary and Salary Range for Information Technology and Business Services"))

# IT metrics
mean(it$avg_salary)
sd(it$avg_salary)
t.test(it$avg_salary)

sd(it$rating)
t.test(it$rating)

# Business Services metrics
sd(bus$avg_salary)
t.test(bus$avg_salary)

sd(bus$rating)
t.test(bus$rating)

