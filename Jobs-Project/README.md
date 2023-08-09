## Business Analyst Position Analysis

### Introduction

One day, I hope to enter a career as a business analyst, but it would probably be good to know some information about the field instead of heading in blind. Due to this career being a future interest of mine, I was curious about what factors made on business analyst job better over another. I decided to explore a large data set containing information about business analyst job listings within the United States in 2019 and 2029. Through this analysis, I want to address the following questions: does the founding date of the firm have any relationship with the expected salary of the position? Is there significant evidence that Business Analyst Positions in New York pay a better average salary than any other job in New York? Which job title and sector appear to be the “best” ones to get a job in ("Best" in this case referring to a combination of expected salary and overall rating)?   



## Background

The data set I have decided to use for this honors project can be found on [kaggle](https://www.kaggle.com/datasets/andrewmvd/business-analyst-jobs). This data set focuses on Business Analyst job listings and various information about these listings. The data set contains approximately 4092 distinct job listings of 15 different variables (although 2 of these are just indexes which I have removed).

Some of the information listed about each job title include salary estimates, the job’s respective location, industry, sector, and the job description which users could use to search for specific skills needed or desired. The Business Analyst data also contains information about the company that listed the job such as their name, competitors, revenue, headquarters, and size. Finally, there are columns dedicated to the overall rating of the position (on Glass Door) and whether “easy apply” was available.

The key variables I will be utilizing will mainly be the year in which the company was founded, average salary (per year), rating (given by other users on GlassDoor who have held a similar job within that company), and the location of the job position. The initial salary column values were strings with ranges such as “56K-102K”, so I made this easier to analyze by taking the average of the two values. I used the same techniques with the size of the company. It should be noted that most of the other columns are in the same format and the method I utilized isn’t necessarily the best way, but it was the best that could be done with the data provided. I also created a salary range column that takes the upper and lower limits of the expected salary and computes the difference between them (which could help for filtering out observations that have large salary ranges). The location column contains the city and states the job is located in, and the rating is based on the ratings other individuals give the specific job listing on GlassDoor. Additionally, I renamed most of the columns to make the coding aspect easier.

All of this data is from the Glass Door website using various web scraping techniques by an independent user. The independent user created the data set to make job searching easier for individuals who may have lost their jobs during the COVID-19 pandemic.

# INSERT GRAPH

### Analysis

To start, we will first look into the question: does the founding date of the firm or company have any relationship with the expected salary? To do so, we will investigate the founding year of the company and the expected salary of the listing.

These graphics show the relationship between the year the company was founded and the expected salary for that specific company. The graphics also displays the general density of when companies were founded, and it appears most companies hiring business analysts were founded recently, around 1980 or later. Initially, there appears to be a slight, positive relationship between expected salary and the year founded in the top plot. However, by zooming in on our regression line in the graphic on the bottom, we see a slight negative trend. 

To test whether the relationships between year founded and average salary is significant, we will conduct a hypothesis test relating to the true slope of the regression line and determine if our findings are significant. We will carry out a hypothesis test to determine if the slope of the least squares regression line is statistically significant. Our data set has 3,419 observations of average salaries of business analyst positions. Since n = 3,419 is greater than 30, we would be able to conclude the data has an approximately normal distribution. However, the standard deviation of the population is unknown, so we can use a Student T Distribution with 3,418 degrees of freedom. The t-test is robust meaning the only time we cannot use it is if we have an extremely non-normal distribution, and previous data on salaries appear not to be extremely non-normal. Since there are two estimated parameters in our linear model (slope and intercept), our test statistic $T$ is t-distributed with 3,417 degrees of freedom. 


```math
T \sim t(df=3417)
```
Therefore, we have the following hypotheses:

```math
H_0: \hat{\beta}_1 = 0 \\
H_a: \hat{\beta}_1 \neq 0
```
The estimated slope is $\hat{\beta}_1 = -1.0185$ with an estimated standard error of $SE(\hat{\beta}_1)=0.5555$.

This leads to a t-statistic of 
```math
T = \frac{-1.0185  - 0}{0.5555} = -1.8335
```
Which can graphically be represented as:

# INSERT GRAPH

This leads to a p-value of 0.0668, which is greater than 0.05, therefore there is no evidence to reject the null hypothesis.


#### Question 2: Is there significant evidence that Business Analyst Positions in New York pay a better average salary than any other job in New York?

Coming out of college, I plan on living in New York for a period of time, and will hopefully work as a business analyst. Is this a good decision? We will first filter the job listings to only ones based in New York City, New York, and then use the mean of all the expected salaries. Luckily, there is ample information online about salary statistics, so I will also be utilizing outside calculations and statistics from the [U.S Census Bureau](https://data.census.gov/cedsci/table?q=new%20york%20city%20wage&tid=ACSST5Y2020.S2001)

Let us define $\mu$ as the true mean salary of a worker in New York City, New York in 2020. (the link above has $\mu$ = $84,950). It should be noted this value incorporates business analyst positions in New York City, but this shouldn't have a major impact on our analysis.

We will specify a p-value < 0.05 as statistically significant and a p-value < 0.01 as highly statistically significant.

Our data set has 231 observations of average salaries in New York City, New York. Since n = 231 is greater than 30, we would be able to conclude the data has an approximately normal distribution. However, the standard deviation of the population is unknown, so we can use a Student T Distribution with 230 degrees of freedom. The t-test is robust meaning the only time we cannot use it is if we have an extremely non-normal distribution, and previous data on salaries appear not to be extremely non-normal. Thus, our test statistic $T$ is t-distributed with 230 degrees of freedom.

$$
T \sim t(df=230)
$$


Therefore, we have the following hypotheses:

$$
H_0: \mu = 84950 \\
H_a: \mu > 84950
$$

We calculate our $\bar{X}$ to be 85,722.94 with a $s$ = 20132.96.
Using this formula to find the t-statistic:
```math
T = \frac{\bar{X} - \mu}{s / \sqrt{n}}
```

# T-TEST OUTPUT

We get $t = 0.5831$. Graphically, this can be represented as:

# INSERT T-TEST GRAPH

Running a t-test with 230 degrees of freedom we find a p-value of 0.2801. Since our p-val = 0.2801 is greater than 0.05, we fail to reject the null hypothesis. We have no evidence the mean salary of business analyst positions in New York City is greater than the average salary in New York City.


#### Question 3: Which sector appears to be the “best” one to get a job in?

When defining "best" in this case, I'm referring to a combination of expected salary and overall rating. When looking at the different sectors within the data, many only have minimal observations which could mess up our analysis due to an insufficient amount of data. Therefore, sectors with less than 50 observations (since by keeping n > 30 we can assume the distribution for each sector is approximately normal and a higher number of observations produces more accurate data). 

Additionally, by grouping the job postings by sector and finding the mean salary and rating for that sector, the data can be further filtered. As stated before, we are characterizing "best" as a combination of average salary and rating. Thus, many sectors have both lower mean salaries and ratings than other sectors, so those have been filtered out. Additionally, the rating is a particularly important component since we want to enjoy our job and have a healthy work environment. Some sectors had similar mean salaries but some had lower ratings such as the Finance, Retail, and Biotech sectors, so those have been filtered out. Therefore, we have narrowed it down to 5 sectors: Aerospace and Defense, Accounting and Legal, Business Services, Information Technology, and Media.

# INSERT TABLE
# INSERT INDUSTRY GRAPH

This graphic displays the overall trend of ratings of job postings within a given sector as the average salary within the sector increases. It utilizes a linear model to decrease noise and clarify the pattern between average salary and job rating. The slopes of these linear regression lines are difficult to see visually, but looking at the corresponding equation for each regression line helps display the trend. For our regression analysis, let $x_i$ be a given salary, and the resulting $\hat{y}_i$ is the predicted rating for the given salary.

Accounting:
$$
\hat{y}_i = 3.931 -0.0000006102 x_i
$$
Aerospace and Defense:
$$
\hat{y}_i = 3.723 -0.0000009955 x_i
$$
Business Services:
$$
\hat{y}_i = 3.776 + 0.0000006622 x_i
$$
Information Technology:
$$
\hat{y}_i = 3.849 + 0.0000006064 x_i
$$
Media:
$$
\hat{y}_i = 3.680 -0.0000008317 x_i
$$
I hope to have a career (20+ years) in this field and a declining rating as average salary increases is not a good sign. As I progress within the sector, I don't want the quality of my positions to decrease. Based on this, we want a strictly positive relationship between average salary and rating, which the regression equations for each sector help us find. Based on the regression models, there are 2 sectors that display an increasing trend between average salary and job rating: Business Services and Information Technology. We will further analyze these 2 sectors to determine which one is superior.

Now that we have visualized the trends in job rating and filtered down the sectors to analyze, we can now look at the distribution of average salaries in both sectors.

# INSERT GRAPH

The graphic on the left shows the density of salaries in each sector. It appears the Information Technology sector has a larger density of observations in the right tail, which means there are more job postings for Information Technology positions on GlassDoor with larger salaries when compared to Business Services positions. However, both of the distributions are very similar. 

The second graphic shows the density of the range in salaries in each sector (recall we computed the range by taking the upper salary limit and subtracting the lower salary limit). The distribution of salary ranges for each sector is almost identical, making it difficult to distinguish one sector has a tighter range of salaries than another. Neither of these distributions tell us much about which sector is superior.

Based on the previous graphic, we can see that the Information Technology and Business Services sectors have a positive linear relationship between average salary and overall job ratings. Therefore, we will construct a 95% confidence interval to determine what an individual can expect for an average salary and job rating in each of these sectors.

Since we filtered out sectors that had less than 30 observations, by the Central Limit Theorem, we can assume the ratings and average salary variables in each sector are approximately normally distributed. Additionally, prior data shows that the distribution of salaries is not extremely non-normal. Since we do not know the population standard deviation for any sector, we will assume each sector's average salary and rating follows a Student-T distribution with n-1 degrees of freedom.

# SHOW T-TEST OUTPUT

Let's start with the Information Technology sector. We find the Information Technology sector has 1056 observations with a mean average salary of 80,424.24 dollars and a standard deviation of 27,179.44 dollars. We find the mean rating to be 3.9 with a standard deviation of 0.98. Running a t-test using R, we find the 95% confidence interval for the average salary and rating to be 
$$
Salary \ CI = [78783.07,82065.42]\\
Rating \ CI = [3.84, 3.96]
$$
Under repeated sampling, we are 95% confident the true mean salary of job postings in the Information Technology sector to be between 78,783.07 and 82,065.42 dollars and the true mean rating to be between 3.84 and 3.96.

# SHOW T-TEST OUTPUT

For the Business Services sector, there are 792 observations with a mean average salary of 78,893.31 dollars and a standard deviation of 26,329.50 dollars. We find the mean rating to be 3.83 with a standard deviation of 0.645. Running a t-test using R, we find the 95% confidence interval for average salary and rating to be 
$$
Salary \ CI = [77056.80, 80729.82]\\
Rating \ CI  = [3.78, 3.87]
$$
Under repeated sampling, we are 95% confident the true mean salary of job postings in the Business Services sector to be between 77,056.80 and 80,729.82 dollars and the true mean rating to be between 3.78 and 3.87. 

### Discussion

We analyzed and conducted a hypothesis test on the slope of our linear regression model to determine if there was a significant relationship between the year a company was founded and the average salary. Based on the analysis of our linear regression model, we cannot conclude there is a statistically significant relationship between the founding year of a company and the average salary. We found the probability of finding a t-statistic as extreme or more extreme than the one we calculated to be 0.0668, which is less than our 0.05 significance level. This is a very interesting finding and it possibly displays the idea that newer companies base their salaries on older companies, but more analysis would be required to accurately assume this conclusion.

When attempting to prove that business analyst positions in New York City pay more than the average salary in New York City, we fail to reject the null hypothesis since our p-value = 0.2801 which is greater than 0.05. Therefore, we have no evidence to conclude the true mean salary of business analyst positions in New York City is greater than the true mean salary in New York City. 

Even though we couldn't directly see which sector was superior through the distribution of average salaries and salary ranges, the confidence intervals provide good evidence the Information Technology Sector is the best sector to get a job in. For the confidence interval about salaries, both the Information Technology sector's lower confidence limit and upper confidence limit are greater than the Business Services. Additionally, both the Information Technology sector's lower confidence limit and upper confidence limit are greater than the Business Services for the rating. This doesn't mean one sector is truly better than another but is a statistic that should be considered when attempting to answer this question, but further analysis is necessary. 

There are a few shortcomings to this analysis. For one, the rating and average salary variables were vital to our analysis, but the data set provides other variables that would also be useful for answering our last question. Additionally, our average salary variable could be problematic since only ranges of the expected salary were given in the data set. To truly know the average salary of a given position, the distribution of the position's salary should be examined and the density of each salary value should be taken into account within the calculation. Finally, we had to use a Student-T distribution since we didn't know the standard deviation of the entire population, which often leads to wider confidence intervals and it is harder to reject null hypotheses. If we knew the standard deviation of the populations within our analysis, we could potentially gain more accurate results. One thing we could do to address some of these shortcomings is to find how salaries are typically distributed and use this to answer the question "what is the true average salary of each position based on prior data?" The calculation would become much more complex and would take the prior distributions into account. One last aspect of the analysis that could pose problems is we took business analyst positions into account when we found the true mean salary of individuals in New York City, and this could have potentially impacted our ability to reject the null hypothesis.

Another question we could answer is whether or not a company has competitors influences aspects of their job posting such as salary, rating, or potentially job description (although this would be difficult). This could possibly be done by taking all companies posting that have competitors and comparing them to companies postings that don't have any competitors. Hypothesis tests could be conducted to determine if there is a true difference in any of these metrics and can thus make conclusions about the influence of competitors within the business analyst career sector. We could also refine our research to a city (such as New York City) and compare the data we have with more general job posting data from New York City. In order to do this, we would need a new data set that contains similar information about job listings but isn't refined to business analyst positions. An in-depth analysis could thus be conducted to possibly analyze how good a career in business analytics is within a given city. 
