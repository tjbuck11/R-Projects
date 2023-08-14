# Loan Default Prediction
### By Thomas Buck

## Project Introduction
The majority of individuals have previously taken out a loan and everyone intends on paying the loan back, but the payment does not always go as expected. When a borrower stops making the required payments, they go into what is known as “default”. Defaults are a frequent occurrence and banks incur losses on the outstanding loan amount that were never repaid. The current default rate for bank loans in the U.S. is approximately 1.21%, but rates have been as high as 7.4% during times of economic crisis, such as the [Great Recession](www.federalreserve.gov/releases/chargeoff/delallsa.htm). These economic crises result in drastic losses for banks, and during the COVID-19 pandemic, the four biggest U.S. banks’ had a combined loss reserve of over [$80 billion](news.bloombergtax.com/daily-tax-report/tax-virus-briefing-companies-banks-brace-for-far-away-recovery). Large monetary losses on loan defaults can affect a country’s economic growth and health. Therefore, large economic incentives are involved with accurately predicting whether a borrower will default since it helps banks plan for future losses. This project will utilize classification models to accurately predict a loan’s default status, which is either “Defaulted” or “Not Defaulted”.

## Loan Default Prediction Data and Cleaning
The dataset came from a MachineHacks Hackathon called the “Bank Loan Defaulter Prediction” (which I found on [Kaggle](www.kaggle.com/datasets/ankitkalauni/bank-loan-defaulter-prediction-hackathon?select=train.csv). The initial dataset has 67,463 rows, 34 variable columns, and 1 outcome column which is a loan’s default status. The loan status column takes a value of 1 if the loan defaulted and 0 if it did not default. Each row represents a loan an individual has taken out and the columns include various predictive attributes (see Figure 1.1 in Appendix A for attribute descriptions). Before analysis, I excluded all null values and removed the following columns: “ID” (a unique identifier), “Payment.Plan” (always “no”), “Accounts.Delinquent” (always 0), “Sub.Grade” (insufficient information), and “Application.Type” (always “Individual”). 

## Exploratory Data Analysis
The overall prevalence of loan defaults was 9.25% indicating the dataset is imbalanced, but I will not be resampling as can remove relevant information or create new data that is not representative of the true population. There were limited significant relationships between loan default status and categorical variables when analyzing the overall default percentage and default frequency (see Figure 1.2 in Appendix B). A home living status (Home.Status) of “OWN” and “RENT” as well as a grade of F or G had slightly larger default percentages and grade C had the majority of defaults. The batch a loan was enrolled in and the loan title both have a large number of categories. The curse of dimensionality prevents us from creating 116 predictors for each category, so the batch and title variables were instead ordered by the total number of loan defaults. The total number of defaults and default percentages were used in unison to determine which batches and titles would be the most useful (see Figure 1.5 in Appendix B for tables).

Additionally, some numeric predictors appeared to have a relationship to the default status (See Figures 1.3-4 in Appendix B). The borrower’s revolving utilities (Revolving.Utilities), months since payment to the bank (Last.week.Pay), number of delinquencies (Delinquency…two.years), the total amount of collections (Total.Collection.Amount), number of derogatory public records (Public.Records), and the number of inquiries in the past 6 months (Inquires…six.months) were slightly all larger for defaulted loans. In contrast, the borrower’s number of open accounts (Open.Accounts) and the post-charge-off collection fee (Collection.Recovery.Fee) were generally lower for loans that defaulted. There was also minimal multicollinearity between each numerical predictor. 

I determined the most important predictors based on this analysis and these variables will be used for all models except logistic regression (see Figure 1.6 in Appendix B for the variables).

## Model Construction and Results
A seed was set in the beginning to ensure randomness is accounted for when assessing each model. All models used 5-fold cross-validation for assessment, where each model was fit on the training data, and then generated predictions for the testing data to compare with the true results. The prediction error rate is the main measure of interest, but specificity, sensitivity, and false positive and negative rates will also be evaluated. The 5 testing prediction error rates will be averaged to summarize the model’s overall error rate. 

## Logistic Regression
First, the cross-validation feature of the “glmnet” package determined the optimal lambda (lambda.min) value for the selection of predictors. The family parameter was set to binomial for classification and the type measure was specified to “auc”, which measures the area under the ROC curve and helps determine how well a logistic regression model classifies positive and negative outcomes at all possible [cutoffs](www.graphpad.com/guides/prism/latest/curve-fitting/reg_logistic_roc_curves.htm). The optimal lambda value was then used with a binomial LASSO regression to identify important predictors for the logistic regression model (see Figure 1.7 of Appendix C), and the variables were similar to those I selected. 

After fitting and testing the model, I determined the default imbalance caused the model to always predict a loan did not default. Typically, we would predict 1 if the model predicts a probability greater than 0.5, but I adjusted the threshold so some predictions would be seen as a loan default. This value was selected by analyzing the trade-off between the false positive and negative rate as well as the overall error rate, but I settled on a value of 0.12 (I also spoke with Professor Chiang and he approved this practice was acceptable for the project). The model had an overall error rate of 10.75% (See appendix C for the results) with the number of delinquencies, “Renting” and “Own” home statuses, and the initial list status variables having statistically significant coefficients.

### Naive Bayes, LDA, QDA
To reiterate, the Naive Bayes, LDA, and QDA models used the predictors included in Figure 1.6, with the initial listing status variable added since it was statistically significant in the logistic regression models. The Naive Bayes model had an error rate of 11.63%. The LDA model also simply predicted that all loans would not default, so I took the posterior probabilities calculated from the testing data and used a similar technique to logistic regression to determine an optimal threshold of 0.12. After this, the LDA model achieved an error rate of 10.62%. The QDA model did not experience the same issues as the LDA model and had an 11.69% error rate. 

### K-Nearest Neighbors
The predictors from Figure 1.6 were utilized in the KNN model to prevent overfitting. Across numerous k values, predicted loan defaults generally decreased as k was increased. This can be explained by the KNN algorithm and the imbalance of data. With a larger k value, the algorithm will look at a larger number of near data points when making a prediction and since the vast majority of loans do not default, the algorithm’s calculated average predicts loans to not default more often. Based on this, lower k values appeared to be optimal (but this typically is not best practice) so I chose a value of 3 since it will avoid ties between data points. The KNN model had an error rate of 11.33%. 

## Model Analysis

No model was particularly successful at predicting loan defaults. I believe this is largely due to the imbalanced data and the minimal significant relations between a loan’s default status and any predictor. Additionally, variables expected to be related to loan defaults such as interest rates or a debt-to-income ratio displayed no relationship to loan default status. 

All models performed similarly with the range of error rates being less than 2% (see Figure 1.8 from Appendix C for full metrics). From only looking at the error rate, the LDA model performed best with a 10.62% error rate, followed closely by the Logistic Regression model with 10.75%. However, these models had the highest false negative rates and lowest sensitivities, likely due to the relatively small number of predicted defaults. In contrast, the Naive Bayes and QDA models boast the highest sensitivity and lowest false negative rates across all models, but also the largest error rates. The KNN model falls in the middle, with an error rate of 11.33% and other metrics falling between the Logistic Regression and Naive Bayes models.  

When choosing the best model, it is important to understand the context surrounding the models. In the case of loan defaults, I would argue false negatives are more impactful than false positives due to the planning aspect for banks. If banks predict a large number of loans to default, they can plan for this by holding more loss reserves and the only downside is being overprepared which would only impact potential business opportunities. However, if banks overpredict that loans do not default when they actually do, they would be unprepared and unable to effectively deal with the repercussions, which could have drastic consequences for the bank or even the economy if this occurs at a large scale. 

Weighing all of the metrics together, I would narrow it down to the logistic regression and KNN models since they have relatively low false negative rates (amongst the other models) and are in the top three when looking at error rates. From these models, if I had to decide, I would choose the KNN model as the best-performing model since it provided the best balance of all metrics and had a reasonable error rate. However, this is under the assumption one of these models must be chosen, but the best choice would be to conduct further research on the topic and explore other model options.  

## Conclusion
From my analysis, some important findings can be useful for future loan default model formulations. The main takeaway is that predicting loan defaults is extremely difficult. I hypothesize there was some omitted-variable bias within the data that made my specific prediction much for difficult, but I think this concept can be stretched generally to loan defaults. Typically, people do not intend on defaulting but instead have extenuating circumstances that lead to it, which rarely show up within the data. Data could potentially get updated with new information, but specific financially straining events may never show up. This specific case can help show that we cannot always rely on the model and that mistakes are likely to be made. However, I do believe my analytical method can prove useful in mitigating the effects of model mistakes. With loan defaults models, the false negative rate should be minimized so banks avoid being blindsided by loan defaults and can effectively plan for them, but the false positive rate should still be kept in check to mitigate overcompensating. 

When looking specifically at the data, it appears bank grades are limited in predicting defaults, as evident by the same default rate for grade A and E loans. Some obvious variables did prove to be useful such as the borrower’s number of delinquencies in the past 2 years and the time since the last payment. However, no one statistic proved to be useful in predicting loan defaults. Future analysis should be conducted to determine if there are substantial relationships between the interaction of multiple variables or sequences of variables satisfying a specific criterion since this could lead to more accurate predictions. A random forest model could be utilized to test if sequences of variables generate more accurate classifications than using them independently. Additionally, the KNN model showed that as k increased the number of defaults predicted decreased, which could indicate the predictor variables and default status display extremely local relationships since small changes in the predictor variables correspond to small changes in the default status. However, this needs to be explored further to ensure this trend was not simply the result of imbalanced data. Variable selection techniques could also be done for each model type so the best predictors are selected to produce maximum performance.

During my initial research, other loan default prediction projects I found displayed similar results to those I achieved. This could indicate the data itself is the root cause of the models misclassifying many loans since the analysis did not provide definitive clues as to how the loan default status should be predicted. Therefore, future analysis and model predictions on another dataset with similar attributes would help test this claim. Comprehensive data gathering may be the biggest challenge to creating an accurate loan default prediction model. However, overcoming this hurdle would revolutionize the banking industry and hopefully make large-scale loan default catastrophes a thing of the past.

| ![Street View](https://github.com/tjbuck11/NYC-Living-Optimization/blob/main/Images/street_view.png)| ![Map View 1](https://github.com/tjbuck11/NYC-Living-Optimization/blob/main/Images/map_view_1.png)  |
|-|-|
| ![Map View 2](https://github.com/tjbuck11/NYC-Living-Optimization/blob/main/Images/map_view_2.png) |

## Appendix A

### Figure 1.1
A table with the name, type, and description of each variable from the loan data.
![variable table](https://github.com/tjbuck11/R-Projects/blob/main/Loan-Default-Prediction/Visuals/variable_table.png)

## Appendix B
### Figure 1.2 
Box Plots showing each categorical variable’s default percentage and default frequency per category. It appears the home status “Rent” and “Own” as well as grades F and G have slightly higher default rates than the average.
| ![Box Plot 1](https://github.com/tjbuck11/R-Projects/blob/main/Loan-Default-Prediction/Visuals/category_var_1.png) | 
|-|-|
| ![Box Plot 2](https://github.com/tjbuck11/R-Projects/blob/main/Loan-Default-Prediction/Visuals/category_var_2.png) |

### Figure 1.3
Some numerical predictors had few unique values, so boxplots were better for visualizations, and others had spread-out distributions, so summary statistic comparisons were used. The default rate appears to be larger for more than 4 delinquencies, more than 2 public records, and exactly 4 inquiries in the past 6 months. Additionally, all statistics for the collection amount are larger for defaulted loans, and all statistics for the recovery fees are smaller for defaulted loans. 
| ![Box Plot 3](https://github.com/tjbuck11/R-Projects/blob/main/Loan-Default-Prediction/Visuals/category_var_3.png) |
|-|-|
| ![odd variables](https://github.com/tjbuck11/R-Projects/blob/main/Loan-Default-Prediction/Visuals/odd_var_graph.png) |

### Figure 1.4
A heat map showing the correlation between all numerical predictors and boxplots showing the distribution of numerical predictors by default status. There is essentially no multicollinearity or strong relationships between numerical predictors and limited variation in all predictors when comparing default statuses. However, borrowers of defaulted loans appear to have slightly higher homeownership values and weeks since the last payment, but a lower number of open accounts on average. 
| ![Heat Map](https://github.com/tjbuck11/R-Projects/blob/main/Loan-Default-Prediction/Visuals/heatmap.png) | ![box plot 1](https://github.com/tjbuck11/R-Projects/blob/main/Loan-Default-Prediction/Visuals/numerical_var_1.png) |
|-|-|
| ![box plot 2](https://github.com/tjbuck11/R-Projects/blob/main/Loan-Default-Prediction/Visuals/numerical_var_2.png) | ![box plot 3](https://github.com/tjbuck11/R-Projects/blob/main/Loan-Default-Prediction/Visuals/numerical_var_3.png) |

### Figure 1.5
These are bar plots showing the default rate for the top 10 titles and batches with the most defaults. The number on top of each bar corresponds to the total number of defaults which provides a frame of reference so the values with the highest default percentage are not always chosen since they may only correspond to a couple of loans.
| ![Top 10 titles](https://github.com/tjbuck11/R-Projects/blob/main/Loan-Default-Prediction/Visuals/top_10_titles.png) |
|-|-|
| ![Top 10 batches](https://github.com/tjbuck11/R-Projects/blob/main/Loan-Default-Prediction/Visuals/top_10_batches.png) |

### Figure 1.6
A table of the predictors being used for models besides logistic regression that includes the variable type and description.
![predictor variables](https://github.com/tjbuck11/R-Projects/blob/main/Loan-Default-Prediction/Visuals/final_predictors.png)

## Appendix C
### Figure 1.7
The output of LASSO regression where the optimal lambda was determined using cross-validation with the “glmnet” package.
![LASSO output](https://github.com/tjbuck11/R-Projects/blob/main/Loan-Default-Prediction/Visuals/LASSO_output.png)

### Figure 1.8
The confusion matrix output for all models, with the predictions column an abbreviated version of the model as well as a table showing the sensitivity, specificity, false positive rate, false negative rate, and overall error rate for each model.
![Model Summaries](https://github.com/tjbuck11/R-Projects/blob/main/Loan-Default-Prediction/Visuals/models_summary.png)








