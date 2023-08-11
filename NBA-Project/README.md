# NBA Rookie Hall of Fame Prediction
### By Thomas Buck

This project utilized R and R Studio to predict if a player will make the NBA Hall of Fame based on their rookie year. 

## Introduction

Have you ever wondered what getting into the Naismith Basketball Hall of Fame takes? The NBA Hall of Fame is one of the most prestigious honors in the entire basketball world, with only [177](https://en.wikipedia.org/wiki/List_of_members_of_the_Naismith_Memorial_Basketball_Hall_of_Fame#:~:text=In%20total%2C%20177%20or%20178,into%20the%20Hall%20of%20Fame) former NBA or ABA (the association before the NBA) players being inducted out of about 4,374 players who have played in at least one [NBA game](https://bleacherreport.com/articles/2854727-bleacher-reports-all-time-player-rankings-nbas-top-50-revealed#:~:text=A%20total%20of%204%2C374%20players,large%20as%20the%20list%20itself). The process to get in involves a holistic view of a player's career with their game-play statistics such as points per game and efficiency rating being important factors. I always think of Hall of Fame players as the best of the best, but were these players truly that far above the pack since the beginning of their NBA career? A rookie year can be an important determinant of a player's future career, so I hope to analyze this indicator of future success. This topic interests us due to my shared interest in NBA basketball and the challenge of predicting a player's future based on their first year in the NBA. To explore this area of interest, I needed to find a data set that corresponded to NBA rookies. I eventually found an “NBA rookies” data set and will use it to predict if a given player will get into the Hall of Fame from only their rookie year statistics. More specifically, I pose the question “How many points must a player average and how efficient must a player be in their rookie year to be considered for Hall of Fame induction?”. Additionally, I want to question the validity of using a rookie's performance as an adequate predictor of a future career by answering “Is there a significant difference in a Hall of Fame player's rookie year points per game and efficiency per game vs. non-Hall of Fame players rookie year points per game and efficiency per game?” To answer these, I will examine trends in points per game and efficiency rating stratified by Hall of Fame players and non-Hall of Fame players. I believe that there is a significant difference between Hall of Fame players' performances in their rookie year versus non-Hall of Fame players in their rookie year. I also believe points per game and efficiency rating are relatively good indicators of the chances a rookie will make the Hall of Fame.

## Data Description

The first data set contains rookie data from 1980 to 2016 about a player's statistics in their rookie season in the NBA. The data set comes from [data.world](https://data.world/gmoney/nba-rookies-by-min-1980-2016/workspace/project-summary?agentid=gmoney&datasetid=nba-rookies-by-min-1980-2016) and the user who created and posted the data goes by username "gmoney". The user got all statistics and information from NBA.com, the official website of the National Basketball Association. NBA.com has an “all player stats” section where one can filter by season (i.e. year) and “Rookies”. The user scraped this webpage using various web scraping techniques and then inputted the information into a CSV file so analysis could be conducted in a more accessible fashion. All variables within the rookie data set are on a per-game basis. For example, if the points column says 15.0, that player averages 15 points per game. This data set also contains a Hall of Fame variable with a year as the value if the player made the Hall of Fame. Due to the long process it takes to get into the Hall of Fame (players have to wait a couple of years after they retire), the most recent Hall of Fame rookie I have is from about 2005, so whenever I use data on only Hall of Fame rookies, the timeline of my data is from 1980 to 2005, so graphics plotting only Hall of Fame rookies will only go from 1980 to around 2005. 

The second data set I will be using is NBA player data found on [Kaggle](https://www.kaggle.com/datasets/drgilermo/nba-players-stats?select=Players.csv) and was created and posted by Omri Goldstein. All information in the data was scraped by Omri Goldstein using various web scraping techniques from Basketball Reference. The data contains information about every NBA player since 1950. The data set contains the height, weight, college attended, birth year, and birth location of every player in the data set. I combined these data sets by name to add these columns to my rookie data frame. I will use each rookie's height to construct a linear regression model to predict how many points a rookie of a given height will average.

The data is relatively comprehensive, however, it should be noted this data does have a larger population which would be all rookies that have ever been in the NBA from its beginning (so before 1980 and after 2016). When analyzing the Hall of Fame players, it can best be described as a sample of players in the Hall of Fame since there is a large number of players inducted into the Hall of Fame that were drafted before 1980. Therefore, the larger population for the Hall of Fame sample is all NBA players ever inducted into the Hall of Fame. 

The remainder of the report will attempt to determine the expected stat line of a Hall of Fame player in their rookie year. I hope to determine if there is a statistically significant difference between Hall of Fame rookie statistics versus non-Hall of Fame rookie statistics. Another analysis to be explored is attempting to predict a Hall of Fame rookie's points per game based solely on their height and to determine if there is a statistically significant relationship between the two variables.

I will use points and efficiency because they are primary statistics associated with any given player and are often used to gauge a player’s success. It is important to consider, however, that a player’s success is not solely contingent on points which is why I are also analyzing efficiency, a holistic measure of a player's impact. Its values come from the equation: (Points + Rebounds (missed shot and grabbed ball)  + Assists (passed to a player who scored) + Steals (took the ball from the other team) + Blocks (blocked a shot) − Missed Field Goals(missed shot attempt) − Missed Free Throws - Turnovers (lost possession of the ball to another team) / Games Played. 

### Variables
| Variable  | Description |
| ------------- | ------------- |
| **Points**  | Player’s average number of points per game  |
| **Efficiency**  | Holistic measure of the player’s success ([Points + Rebounds + Assists + Steals + Blocks − Missed Field Goals − Missed Free Throws - Turnovers] / Games Played) |
| **Height**  |  Height of the player in centimeters  |
| **Weight**  |  Weight of a player in kilograms  |
| **Hall of Fame** | Year the player was inducted to the Hall of Fame, NA if the player did not make the Hall of Fame |

## Analysis

As stated before, I believe making the Hall of Fame is a very prestigious award that only a small fraction of NBA players achieve. I find that my data also represents this since only 2.83% of the rookies in my data set were eventually inducted into the Hall of Fame and 97.17% were never inducted. 
Let's look at how these Hall of Fame players compare to non-Hall of Fame players in various aspects.

# Insert Box Plot

The box plot on the left is a player's points per game in their rookie year grouped by Hall of Fame status and the box plot on the right is a player's efficiency rating grouped by Hall of Fame status. From these plots, I can see there are differences between Hall of Fame and non-Hall of Fame players, but are these differences significant? 

To answer this question, I want to first look at trends in the data that could impact my analysis. Specifically, I will examine how points per game and efficiency rating change over time for Hall of Fame players. If I find that there is a significant change in points per game and efficiency, I should take this into account for my further analysis.

# Insert Line Plot

Both of my linear regression models display a negative slope, implying a decrease in points per game and efficiency rating over time. Let's look at the games played variable to see if it can offer a possible explanation.

## Checking Trends in the Data

# Insert Graph of Year vs games played

There appears to be a weak negative relationship between the year a player was drafted and their number of games played. It is possible this slight decrease in games played could partially explain the slight negative trends in points per game and efficiency rating over time, but much more analysis would need to be conducted to conclude this.

Before I conduct a hypothesis test on my linear regression models, I first want to ensure using a linear model is appropriate. I can do so by looking at the residuals associated with my linear models, which takes a given data point from my data and measures how far that value is from my predicted value.

# Insert Residual Plot

The first row of graphics display scatter plots of the residuals for the points per game and efficiency rating variables, respectively, for Hall of Famer's. There is also a horizontal line at 0 to help visualize where each residual falls. There is no pattern between the residuals, which means my use of a linear model is appropriate. The second row displays the distribution of the residuals for points per game and efficiency rating respectively. The distribution of the residuals is the black line and the normal distribution with a similar mean and standard deviation is the blue line. They appear to follow the normal distribution pretty close, so I can assume the distribution of the residuals is approximately normal, which I will utilize to conduct a hypothesis test on the slopes of my linear models.

Now I conduct a hypothesis test to determine if the relationship between the year a player was drafted and points per game and efficiency is significant. I know the Hall of Fame players sampling distribution of average points per game and average efficiency per game follows a t-distribution since I do not know the standard deviation of the entire population and my residuals follow an approximately normal distribution for these variables. However, because I are estimating for the slope and the intercept of my regression model, I are using up 2 degrees of freedom, so I now have v = n-2 degrees of freedom. Therefore, both my points per game and efficiency rating variables for Hall of Fame rookies have the following distribution:

$$
t(df=40)
$$

Therefore, I will construct a left-tail hypothesis test with the following hypotheses:

```math
H_0: \beta_1 = 0
```
```math
H_a: \beta_1 < 0
```

Where $\beta_1$ represents the expected change in points per game as the year increases.

# Insert Summary table for the linear model (points)

The estimated slope is $\hat{\beta}_1 = -0.1077$ with an estimated standard error of $SE(\hat{\beta}_1)=0.1521$.

This leads to a t-statistic of 
```math
t = \frac{-0.1077  - 0}{0.1521} = -0.708
```

This t-statistic has a corresponding p-value of **0.2415**, which is greater than 0.05. Therefore, I fail to reject the null hypothesis.

I can follow the same sampling distribution and hypotheses to test the relationship between the year a player was drafted and the efficiency rating. In this case, $\beta_1$ represents the expected change in efficiency rating as the year increases.

# Insert Summary table of the linear model (efficiency)
The estimated slope is $\hat{\beta}_1 = -0.04876$ with an estimated standard error of $SE(\hat{\beta}_1)=0.16908$.

This leads to a t-statistic of 
```math
t = \frac{-0.04876  - 0}{0.16908} = -0.288
```

This t-statistic has a corresponding p-value of **0.3874**, which is greater than 0.05. Therefore, I fail to reject the null hypothesis.
I can now move forward with the analysis under the assumption that both points per game and efficiency rating have remained constant over time for Hall of Fame players.

## Hypothesis Testing: Hall of Fame vs Non-Hall of Fame Players

I will now conduct hypotheses tests to determine if the true mean points per game for a Hall of Fame rookie is greater than the true mean points per game for a non-Hall of Fame rookie.

I have two independent samples and I will treat the data as randomly sampled from larger populations.

Let $X_p$ be the true mean points per game for a Hall of Fame rookie with distribution $t(df = 41)$

Let $Y_p$ be the true mean points per game for a non-Hall of Fame rookie with distribution $t(df = 1440)$\

Under these distributions, I have the following hypotheses:
```math
H_0: X_p-Y_p = 0
```
```math
H_a: X_p-Y_p > 0
```

# Insert t-test output

I calculate a t-statistic of 8.39. This value has a corresponding $p-val = 7.816*10^{-11}$ which is essentially 0.

Now I will conduct a similar test for the efficiency rating of a Hall of Fame rookie versus a non-Hall of Fame rookie. 

Let $X_e$ be the true mean efficiency rating for a Hall of Fame rookie with distribution $t(df = 41)$\

Let $Y_e$ be the true mean efficiency rating for a non-Hall of Fame rookie with distribution $t(df = 1440)$\

Under these distributions, I have the following hypotheses:
```math
H_0: X_e-Y_e = 0
```
```math
H_a: X_e-Y_e > 0
```

# Insert t-test output

I calculate a t-statistic of 8.890, which has a corresponding $p-val = 1.673 *10^{-11}$ which is essentially 0.

## Confidence Intervals

Now that I have determined there is a significant difference in points per game and efficiency rating for Hall of Fame players, it is appropriate to construct a confidence interval that should give us a good estimate of what a rookie's statistics must be in order to have a good chance of making the Hall of Fame. Using the same distribution for $X_p$ as above, I find the 95% confidence interval for a player's points per game to be:

$$
[12.427, 16.163]
$$

I are 95% confident a Hall of Fame rookie averaged between 12.427 and 16.163 points per game. This is a large difference between the confidence interval for non-Hall of Fame rookies of 6.275 to 6.689 points per game.

I can repeat this calculation to determine an interval for the efficiency rating of a Hall of Fame rookie. Using the same distribution for $X_e$, I find the 95% confidence interval for a Hall of Fame rookies efficiency rating to be:

$$
[14.185, 18.315]
$$

I are 95% confident a Hall of Fame rookie had an efficiency rating between 14.185 and 18.315, which is much higher than the efficiency rating confidence interval for Non-Hall of Fame rookies which is 6.886 to 7.322.

## Linear Regression Model

Lastly, I will construct a linear regression model to predict a Hall of Fame player's points per game based on their height.
I found my linear regression model of points per game based on height to take the following form:
$$
Predicted \ Points = -13.612 + 0.137(height)
$$

I can see how it fits with the Hall of Fame rookie data below:

# Insert Graph

However, I want to determine if there is a significant relationship between a Hall of Fame rookie's height and their average points per game. Since I found my slope coefficient is positive, I will construct a one-sided hypothesis test with the following hypotheses:

```math
H_0: \beta_1 = 0
```
```math
H_a: \beta_1 > 0
```

Where $\beta_1$ represents the expected change in points per game as height increases for Hall of Fame rookies. In this case, if I cannot reject that $\beta_1 = 0$, then I cannot conclude there is a significant positive relationship between points per game and the height of a Hall of Fame rookie and a linear model then may not be appropriate to use. 

Running the hypothesis test, I find a t-statistic of $t = 1.619$ which has a corresponding p-value of 0.0566. Therefore, I have weak evidence to reject the null hypothesis and conclude there is a significant positive relationship between points per game and height for Hall of Fame rookies.

## Discussion

I started by observing differences in points per game and efficiency rating between Hall of Fame rookies and non-Hall of Fame rookies and Hall of Famers make up a very small portion of rookies from 1980 to 2016. I first examined the trends of points per game and efficiency rating for Hall of Fame players over time and checked the proper conditions to ensure a linear model was appropriate to use. I then conducted a hypothesis test to determine if there was a significant negative relationship between points per game and efficiency versus time. The p-value for the points per game test was 0.2415 and the p-value for the efficiency rating test was 0.3874, and both are greater than 0.05. Therefore, I fail to reject the null hypothesis and have no evidence there is a significant negative relationship between the year a player was drafted and points per game or the year a player was drafted and efficiency rating in their rookie year. However, I found the insignificant negative relationship could be due to a decrease in games played over time. Particularly for rookies, gaining experience and becoming comfortable in the NBA is very important. When you play more games, you have more opportunities to get acclimated to NBA-level play and can become comfortable in a faster time frame. This comfort can possibly lead to more points per game and efficiency rating, however, further analysis would need to be conducted in order to conclude the decrease in the variables is solely due to a decrease in games played.

I then conducted a hypothesis test to determine if there was a true difference in the mean points per game for Hall of Fame rookies versus non-Hall of Fame rookies. I found a p-value of $7.816*10^{-11}$ = 0, so I reject the null hypothesis and have evidence Hall of Fame rookies score more points per game than non-Hall of Fame rookies. I conducted a similar hypothesis test to determine if there was a true difference in the mean efficiency rating for Hall of Fame rookies versus non-Hall of Fame rookies. I found a p-value of $1.673*10^{-11}$ = 0, so I reject the null hypothesis and have evidence Hall of Fame rookies have a higher efficiency rating than non-Hall of Fame rookies. Therefore, I have some evidence that points per game and efficiency rating can be good indicators of whether or not a player will get into the Hall of Fame, but more analysis is needed to officially conclude this.

Now that I determined these were relatively good indicators of a player's chance to make the Hall of Fame, I conducted analysis to answer the main question "What statistics must a player average in their rookie year to have a good chance of making the Hall of Fame?" I calculated the 95% confidence interval for a Hall of Fame player's points per game in their rookie year to be [12.427, 16.163]. Under repeated sampling, I are 95% confident a Hall of Fame player will average between 12.427 and 16.163 points per game in their rookie year. Additionally, I calculated the 95% confidence interval for a Hall of Fame player's efficiency rating in their rookie year to be [14.185, 18.315]. Under repeated sampling, I are 95% confident a Hall of Fame player will have an efficiency rating between 14.185 and 18.315 in their rookie year. Both of these confidence intervals contained statistics larger than non-Hall of Fame rookies, which again helps display that the statistics I utilized can possibly be good indicators of getting into the Hall of Fame, but further analysis would need to be conducted to draw definite conclusions. 

Finally, I thought it would be interesting to predict a Hall of Fame player's points per game in their rookie year when the only information I have is their height in centimeters. I used a least squares regression model relating to height and predicted points. I found a positive relationship between height and points per game for Hall of Fame players in their rookie year and my linear model equation was of the form $Predicted \ Points = -13.612 + 0.137(height)$. This means that for every 1-centimeter increase in height, a Hall of Fame rookie's points per game increase by 0.137 points. However, when conducting a one-sided hypothesis test on the slope of my model to determine if there was a significant relationship between points per game and height for Hall of Fame rookies, I found a p-value of 0.0566. Therefore, I only have weak evidence to reject the null hypothesis and weak evidence to conclude there is a significant positive relationship between points per game and the height of Hall of Fame rookies. Given that I only found weak evidence, the result should be approached with caution, and more data should be collected and analyzed before determining a definite conclusion. Additionally, the play style in the NBA changes over time, where one period can favor tall players (forwards and centers) and others can favor shorter players (guards). Therefore, to get the most accurate conclusion, stratification by time period may be helpful.  

However, there are some shortcomings in my analysis. First of all, a large factor that is taken into account for a player to get into the Hall of Fame is their team's success. The underlying meaning of this is that the player is good enough to help their team do well as a whole because, after all, basketball is a team sport. my analysis didn't take the success of the team a player was on into account since I didn't have the relevant data. my data set of Hall of Fame players was also relatively small since it had 42 observations. This is still enough to assume an approximately normal distribution by the central limit theorem, however, more observations would lead to more accurate confidence intervals and regression models and I could be more confident in what my hypothesis tests found. 

One interesting question to look at when conducting further analysis is to analyze if the record of the team a player is on in their rookie year has any influence on their Hall of Fame chances. This could be done by obtaining information about the teams of all the Hall of Fame players and non-Hall of Fame players and conducting analysis and inference tests as I did. I could use some other methods within my analysis such as a simulation to directly determine whether the distribution of points and efficiency rating was normally distributed. I also could have analyzed other measures such as points per minute to determine if that has any impact on Hall of Fame status. It would also be interesting to construct a model to predict how many points a player scores given their minutes played or games played.

In conclusion, I found strong evidence there is a difference between Hall of Fame players' points per game and efficiency rating in their rookie year versus non-Hall of Fame players. I used this analysis to construct a confidence interval so I could predict whether a rookie will make the Hall of Fame given their points and efficiency rating. I also determined a potential model to predict a Hall of Fame rookie's points per game given their height in centimeters. More generally, I found some evidence that a player's rookie year is a possible indicator of future Hall of Fame induction, but more analysis would need to be conducted to confidently conclude this more generalized question of interest.
