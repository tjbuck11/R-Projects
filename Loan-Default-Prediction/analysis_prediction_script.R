# Regression imports
library(ISLR2)
library(MASS)
library(FNN)
library(e1071)
library(boot)
library(leaps)
library(glmnet)
library(tree)
library(randomForest)
library(caret)

# Knitting and Design imports
library(knitr)
library(kableExtra)
library(xtable)
library(dplyr)
library(ggplot2)
library(scales)
library(grid)
library(gridExtra)
library(corrplot)
library(tidyr)

# Setting the seed for reproducibility
set.seed(1)

# Load in the data
loans = na.omit(read.csv("Bank_Loan_Default.csv"))
names(loans)[names(loans) == "Employment.Duration"] = "Home.Status"

variables = names(loans)

type = rep("Non-Predictive", 35)
type[c(2:5, 7, 11, 15:22, 24:28, 30:34)] = "Numeric"
type[c(6, 8:10, 12:14, 23, 29)] = "Categorical"
type[35] = "Categorical"

descriptions = c("Unique ID of representative",
                 "Loan amount applied",
                 "Loan amount funded",
                 "Loan amount approved by the investors",
                 "Term of loan (in months)",
                 "Batch number of the loan",
                 "Interest rate (%) on loan",
                 "Grade given by the bank", 
                 "Sub-grade given by the bank",
                 "Representative home ownership status",
                 "Value paid on home",
                 "Income verification by the bank",
                 "If any payment plan has started against loan",
                 "Loan title given",
                 "Ratio of representative's total monthly debt repayment divided by self reported monthly income excluding mortgage",
                 "Number of 30+ days delinquency in past 2 years",
                 "Total number of inquiries in last 6 months",
                 "Number of open credit line in representative's credit line",
                 "Number of derogatory public records",
                 "Total credit revolving balance",
                 "Amount of credit a representative is using relative to revolving_balance",
                 "Total number of credit lines available in representatives credit line",
                 "Unique listing status of the loan - W(Waiting), F(Forwarded)",
                 "Total interest received till date",
                 "Total late fee received till date",
                 "Post charge off gross recovery",
                 "Post charge off collection fee",
                 "Total collections in last 12 months excluding medical collections",
                 "Indicates when the representative is an individual or joint",
                 "Indicates how long (in weeks) a representative has paid EMI after batch enrolled",
                 "Number of accounts on which the representative is delinquent",
                 "Total amount collected one the loan",
                 "Total current balance from all accounts",
                 "Total revolving credit limit",
                 "1 = Defaulter, 0 = Non Defaulters")

variable_table = data.frame(variables, type, descriptions)
colnames(variable_table) = c("Variable Name", "Variable Type", "Description")


variable_table %>%
  kable(col.names = c("Variable Name", "Variable Type", "Description")) %>%
  
  # adjust the column width of the "Description" column
  column_spec(3, width = "25em") %>%
  column_spec(1, bold=T) %>% 
  
  # add styling
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  row_spec(0, bold = TRUE)

# Reordering columns so numeric columns are at the end
types = sapply(loans, class)
loans = loans[, order(types %in% c("integer", "numeric"))]

loans$Verification.Status = ifelse(loans$Verification.Status == "Source Verified", "Verified", loans$Verification.Status)
names(loans)[names(loans) == "Employment.Duration"] = "Home.Status"
loans$Loan.Title = tolower(loans$Loan.Title)

loans = select(loans, -c("ID", "Payment.Plan", "Accounts.Delinquent", "Application.Type"))

predictors = c("Home.Status", "Verification.Status", "Initial.List.Status", "Grade")

# Exploratory Analysis

## Looking at default percentage by variable
default_percent = (sum(loans$Loan.Status)/nrow(loans))*100
plot_list = list()
plot_frequency = list()
for (predictor in predictors) {
  loans_predict = loans %>%
    group_by(.data[[predictor]], Loan.Status) %>%
    summarise(count = n()) %>%
    group_by(.data[[predictor]]) %>%
    mutate(percentage = count / sum(count) * 100)
  
  p = ggplot(loans_predict, aes_string(x = predictor, y = "percentage", fill = "factor(Loan.Status)")) +
    geom_bar(stat="identity") +
    geom_hline(yintercept=default_percent, color="black") +
    labs(fill = "Loan Default\n1 = Default\n0 = No Default") +
    xlab(predictor) +
    ylab("% of Applications") +
    theme(text = element_text(size = 8))
  
  q = ggplot(loans_predict, aes_string(x = predictor, y = "count", fill = "factor(Loan.Status)")) +
    geom_bar(stat="identity") +
    labs(fill = "Loan Default\n1 = Default\n0 = No Default") +
    xlab(predictor) +
    ylab("# of Applications") +
    theme(text = element_text(size = 8))
  
  plot_list[[length(plot_list)+1]] = p
  plot_frequency[[length(plot_frequency)+1]] = q
  
}

# arrange the plots using grid.arrange() and display the grid
grid.arrange(grobs = plot_list, ncol = 2, top="Default Percentage Comparison for Categorical Variables")
grid.arrange(grobs = plot_frequency, ncol = 2, top="Frequency and Total Default Comparison for Categorical Variables")

par(mfrow = c(1, 4), mgp = c(2, 1, 0))

few_numbers = c("Term", "Delinquency...two.years", "Inquires...six.months", "Public.Record", "Collection.12.months.Medical")

## Looking at numerical variables
plot_few = list()
for (predictor in few_numbers) {
  loans_predict = loans %>%
    group_by(.data[[predictor]], Loan.Status) %>%
    summarise(count = n()) %>%
    group_by(.data[[predictor]]) %>%
    mutate(percentage = count / sum(count) * 100)
  
  p = ggplot(loans_predict, aes_string(x = predictor, y = "percentage", fill = "factor(Loan.Status)")) +
    geom_bar(stat="identity") +
    geom_hline(yintercept=default_percent, color="black") +
    labs(fill = "Loan Default\n1 = Default\n0 = No Default") +
    xlab(predictor) +
    ylab("% of Applications") +
    theme(text = element_text(size = 8))
  
  plot_few[[length(plot_few)+1]] = p
}

grid.arrange(grobs = plot_few, ncol = 2, top="Default Percentage Comparison for Numerical Variables with Few Values")

## Looking at few category variables
predictors = names(loans[,8:30])
odd_columns = c("Recoveries", "Collection.Recovery.Fee", "Total.Received.Late.Fee", "Total.Collection.Amount")
par(mfrow = c(1, 5), mgp = c(2, 1, 0), main = "Boxplots of Numerical Predictors by Loan Status")

for (predictor in predictors) {
  if (predictor %in% few_numbers){
    next
  } 
  if (predictor %in% odd_columns){
    next
  }
  else{
    boxplot(loans[, predictor] ~ loans$Loan.Status, main = predictor, 
            xlab = "Loan.Status", ylab = predictor)
  }
}

## Looking at odd variables
odd_columns = c("Recoveries", "Collection.Recovery.Fee", "Total.Received.Late.Fee", "Total.Collection.Amount")

plot_list <- list()

# Loop through each column in odd_columns
for (column in odd_columns) {
  
  # Compute summary statistics by Loan.Status
  summary_df <- loans %>% 
    group_by(Loan.Status) %>% 
    summarize(
      mean = mean(!!sym(column), na.rm = TRUE),
      median = median(!!sym(column), na.rm = TRUE),
      p25 = quantile(!!sym(column), 0.25, na.rm = TRUE),
      p75 = quantile(!!sym(column), 0.75, na.rm = TRUE)
    )
  
  # Reshape the data for plotting
  plot_df <- summary_df %>% 
    pivot_longer(cols = c("mean", "median", "p25", "p75"), names_to = "stat", values_to = "value")
  
  # Plot the data
  plot <- ggplot(plot_df, aes(x = factor(Loan.Status), y = value, color = stat)) +
    geom_point(size = 4) +
    scale_color_manual(values = c("mean" = "red", "median" = "blue", "p25" = "green", "p75" = "purple")) +
    labs(x = "Loan Status", y = column, color = "Statistic") +
    theme_bw()
  
  # Add the plot to the list
  plot_list[[column]] <- plot
}

# Display all plots
grid.arrange(grobs = plot_list, ncol = 2, top="Distribution Statistics by Loan Default Status")


## Looking at relationship between all numerical predictors
n = ncol(loans) - 1
cor = as.matrix(cor(loans[,8:30]))
diag(cor) = NA
get_lower_tri<-function(cormat){
  cormat[upper.tri(cormat)] <- NA
  return(cormat)
}
# Get upper triangle of the correlation matrix
get_upper_tri <- function(cormat){
  cormat[lower.tri(cormat)]<- NA
  return(cormat)
}

upper_tri = get_upper_tri(cor)

kable(xtable(get_lower_tri(cor)))
library(reshape2)
melted_cormat = melt(upper_tri, na.rm = TRUE)

# Heatmap
ggplot(data = melted_cormat, aes(Var2, Var1, fill = value))+
  geom_tile(color = "white")+
  scale_fill_gradient2(low = "white", high = "red", mid = "yellow",
                       midpoint = 0, limit = c(-0.1,0.1), space = "Lab",
                       name="Pearson\nCorrelation") +
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 90, vjust = 1,
                                   size = 7, hjust = 1))+
  coord_fixed() + 
  ggtitle("Correlation Heat Map for Numerical Predictors")

cor_plot = round(as.matrix(cor(loans[,8:29])), 3)
upper = cor_plot
upper[upper.tri(cor_plot)] = ""
upper = as.data.frame(upper)
kable(xtable(upper))


# Looking at top 10 loan titles
top_10_titles = loans %>%
  group_by(Loan.Title, Loan.Status) %>%
  summarise(n = n()) %>% 
  ungroup() %>%
  group_by(Loan.Title) %>% 
  summarise(Total = sum(n), Num.Defaults = sum(n[Loan.Status == 1])) %>% 
  ungroup() %>%
  arrange(desc(Num.Defaults)) %>% 
  mutate(percent = Num.Defaults/Total) %>%
  filter(!Loan.Title %in% c("business", "consolidation")) %>% 
  head(10) %>%
  ungroup()

for (title in top_10_titles$Loan.Title) {
  title_cleaned = gsub(" ", ".", title, fixed = TRUE)
  loans[paste0("title.", title_cleaned)] = as.integer(loans$Loan.Title == title)
}
ggplot(top_10_titles, aes(x = Loan.Title, y = percent)) +
  geom_bar(stat = "identity", fill = "blue") +
  geom_text(aes(label = Num.Defaults), vjust = -0.5) +
  labs(title = "Top 10 Titles with Largest Defaults",
       x = "Loan Title",
       y = "Percent of Loans Defaulted") +
  theme(axis.text.x = element_text(angle = 90))+
  ylim(0, max(top_10_titles$percent) * 1.2)

# Looking at top 10 loan batches
top_10_batches = loans %>%
  group_by(Batch.Enrolled, Loan.Status) %>%
  summarise(n = n()) %>% 
  ungroup() %>%
  group_by(Batch.Enrolled) %>% 
  summarise(Total = sum(n), Num.Defaults = sum(n[Loan.Status == 1])) %>% 
  ungroup() %>%
  arrange(desc(Num.Defaults)) %>% 
  mutate(percent = Num.Defaults/Total) %>% 
  head(10)

for (batch in top_10_batches$Batch.Enrolled) {
  loans[paste0(batch)] = as.integer(loans$Batch.Enrolled == batch)
}
ggplot(top_10_batches, aes(x = Batch.Enrolled, y = percent)) +
  geom_bar(stat = "identity", fill = "blue") +
  geom_text(aes(label = Num.Defaults), vjust = -0.5) +
  labs(title = "Top 10 Batches with Largest Defaults",
       x = "Batch Enrolled",
       y = "Percent of Loans Defaulted") +
  theme(axis.text.x = element_text(angle = 90, vjust = 1, size = 7, hjust = 1))+
  ylim(0, max(top_10_titles$percent) * 1.2)

loans = cbind(loans, model.matrix(~Grade-1, data=loans))
loans = cbind(loans, model.matrix(~Home.Status-1, data=loans))

# Set Grade A and Mortgage to be base groups, remove Batch.Enrolled and Loan.Title
loans = select(loans, -c("GradeA", "Home.StatusMORTGAGE", "Batch.Enrolled", "Loan.Title"))

# Creating dummy variable for the income verification column
loans$Verification.Status = ifelse(loans$Verification.Status == "Verified", 1, 0)

# Creating a dummy variables for the initial list status column, waitlisted = 1
loans$Initial.List.Status = ifelse(loans$Initial.List.Status == "w", 1, 0)

# Removing these because I created the dummy variables
loans = select(loans, -c("Sub.Grade", "Grade", "Home.Status"))
loans = loans %>% select(-c(Verification.Status, Initial.List.Status, Loan.Status), everything())

# Best Subset Selection using LASSO

## Format Data
features = model.matrix(Loan.Status~., loans)
status = loans$Loan.Status

## Run a LASSO regression (alpha=1) with lambda=1
LASSO = glmnet(features, status, alpha=1, family="binomial")
cv.out = cv.glmnet(features, status, alpha=1, family="binomial", type.measure=c("auc"))
best_lambda = cv.out$lambda.min

coef_LASSO = coef(LASSO, best_lambda)
coef_LASSO
coef_best = rownames(coef_LASSO)[coef_LASSO[,1] != 0]
best_predictors = coef_best[2:length(coef_best)]
best_predictors

# Creating and Testing the Models

# Create dataframe with the best predictors
data.default = loans[, c(best_predictors, "Loan.Status")]

# Creating fold
k = 5 # set the number of folds
cv.errors.knn = rep(0, k)
n = nrow(loans)
fold_size = ceiling(n/k)
cv.fold = rep(1:k, each = fold_size)
cv.fold = sample(cv.fold, n, replace=FALSE)

# Confusion matrix function
confusion_matrix_metrics <- function(conf_matrix, col_name) {
  # calculate true positives, true negatives, false positives, false negatives
  tp <- conf_matrix[2,2]
  tn <- conf_matrix[1,1]
  fp <- conf_matrix[2,1]
  fn <- conf_matrix[1,2]
  
  # calculate sensitivity, specificity, false positive rate, false negative rate, and overall error rate
  sensitivity <- tp / (tp + fn)
  specificity <- tn / (tn + fp)
  false_positive_rate <- fp / (fp + tn)
  false_negative_rate <- fn / (fn + tp)
  overall_error_rate <- (fp + fn) / sum(conf_matrix)
  
  # create table of metrics
  df = data.frame(Measure = c("Sensitivity", "Specificity", "False Positive Rate", "False Negative Rate", "Overall Error Rate"),
                  col_name = round(c(sensitivity, specificity, false_positive_rate, false_negative_rate, overall_error_rate), 4))
  colnames(df) = c("Measure", col_name)
  return(df)
}

## Logistic Regression
table.lg = list()
cv.errors.lg = rep(0, k)
for (i in 1:k) {
  train_data = loans[cv.fold != i, c(best_predictors, "Loan.Status")]
  test_data = loans[cv.fold == i, c(best_predictors)]
  test.y = loans[cv.fold == i, ]$Loan.Status
  
  # Fit logistic regression model
  LR = glm(Loan.Status ~ ., data = train_data, family = "binomial" )
  pred = predict(LR, test_data, type =  "response")
  LR.pred = ifelse(pred > 0.12, 1, 0)
  
  error = mean(LR.pred != test.y)
  cv.errors.lg[i] = error
  table.lg[[i]] = table(LR.pred, test.y) 
}

mean(cv.errors.lg)
lg_cm = Reduce("+", table.lg)
lg_summary = confusion_matrix_metrics(lg_cm, "Logistic Regression")

# Setting the predictors I want to use for the other models
my_predictors = c("Delinquency...two.years", "Last.week.Pay", "Open.Account", "Revolving.Utilities", "Inquires...six.months", "Collection.Recovery.Fee", "Public.Record", "Total.Collection.Amount", "GradeC", "GradeF", "GradeG", "title.home.buying", "title.debt.consolidation", "title.credit.card.refinancing", "Home.StatusOWN", "Home.StatusRENT", "BAT1586599", "BAT1104812", "BAT1780517", "Initial.List.Status")

## Naive Bayes
table.nb = list()
cv.errors.nb = rep(0, k)
for (i in 1:k) {
  train_data = loans[cv.fold != i, c(my_predictors, "Loan.Status")]
  test_data = loans[cv.fold == i, c(my_predictors)]
  test.y = loans[cv.fold == i, ]$Loan.Status
  
  # Fit the naive Bayes model
  nb.fit = naiveBayes(Loan.Status ~ ., data = train_data)
  NB.pred = predict(nb.fit, test_data)
  error = mean(NB.pred != test.y)
  cv.errors.nb[i] = error
  table.nb[[i]] = table(NB.pred,test.y)
}
nb_cm = Reduce("+", table.nb)
mean(cv.errors.nb)
nb_summary = confusion_matrix_metrics(nb_cm, "Naive Bayes")

## KNN
knn_data = loans[, c(my_predictors, "Loan.Status")]
scaled_data = data.frame(scale(knn_data[, 1:8]), knn_data[, c(9:21)])

table.knn = list()
cv.errors.knn = rep(0,k)
for (i in 1:k) {
  
  train.x = scaled_data[cv.fold != i, !(names(scaled_data) %in% "Loan.Status")]
  train.y = scaled_data$Loan.Status[cv.fold != i]
  test.x = scaled_data[cv.fold == i, !(names(scaled_data) %in% "Loan.Status")]
  test.y = scaled_data$Loan.Status[cv.fold == i]
  
  # Fit a KNN model to the training data
  KNN.pred = knn(train=train.x, test=test.x,
                 cl=train.y, k=3)
  
  # Make predictions on the testing set
  errors = mean(KNN.pred != test.y)
  
  # Record the number of misclassified observations on the testing set
  cv.errors.knn[i] = errors
  table.knn[[i]] = table(KNN.pred, test.y)
  
}
knn_cm = Reduce("+", table.knn)
mean(cv.errors.knn)
knn_summary = confusion_matrix_metrics(knn_cm, "KNN")

## LDA and QDA
# LDA
table.LDA = list()
cv.errors.LDA = c()
for (i in 1:k) {
  train_data = loans[cv.fold != i, c(my_predictors, "Loan.Status")]
  test_data = loans[cv.fold == i, c(my_predictors)]
  test.y = loans[cv.fold == i, ]$Loan.Status
  
  # Create LDA model and get errors
  # Predicts the loan to not default every time
  LDA = lda(Loan.Status ~ ., data = train_data)
  Prediction_LDA = predict(LDA, test_data)
  LDA.pred = ifelse(Prediction_LDA$posterior[, "1"] > 0.12, 1, 0)
  LDA_error = mean(LDA.pred != test.y )
  cv.errors.LDA[i] = LDA_error
  table.LDA[[i]] = table(LDA.pred, test.y)
}
lda_cm = Reduce("+", table.LDA)
mean(cv.errors.LDA)
lda_summary = confusion_matrix_metrics(lda_cm, "LDA")

# QDA
table.QDA = list()
cv.errors.QDA = c()
for (i in 1:k) {
  train_data = loans[cv.fold != i, c(my_predictors, "Loan.Status")]
  test_data = loans[cv.fold == i, c(my_predictors)]
  test.y = loans[cv.fold == i, ]$Loan.Status
  
  # Create QDA model and get errors
  QDA = qda(Loan.Status ~ ., data = train_data)
  QDA.pred = predict(QDA, test_data)$class
  QDA_error = mean( QDA.pred != test.y )
  cv.errors.QDA[i] = QDA_error
  table.QDA[[i]] = table(QDA.pred, test.y)
  
}
qda_cm = Reduce("+", table.QDA)
mean(cv.errors.QDA)
qda_summary = confusion_matrix_metrics(qda_cm, "QDA")


# Create one dataframe to look at confusion matrices
summary_df = lg_summary %>%
  left_join(nb_summary, by = "Measure") %>%
  left_join(knn_summary, by = "Measure") %>%
  left_join(lda_summary, by = "Measure") %>%
  left_join(qda_summary, by = "Measure")
summary_df %>%
  kable(col.names = c("Measure", "Logistic Regression", "Naive Bayes", "KNN", "LDA", "QDA")) %>%
  
  # adjust the column width of the "Description" column
  column_spec(1, width = "25em", bold=T) %>%
  column_spec(2, width = "25em") %>% 
  column_spec(3, width = "25em") %>%
  column_spec(4, width = "25em") %>%
  column_spec(5, width = "25em") %>%
  
  # add styling
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  row_spec(0, bold = TRUE)

