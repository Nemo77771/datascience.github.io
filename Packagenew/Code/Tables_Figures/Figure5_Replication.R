## ----setup, include=FALSE-------------------------------------------------------------------------
## LOAD PACKAGES 
options("install.lock"=FALSE)

# installing packages for the environment
# (do it only once the first time you run this code)
#install.packages('renv', version='1.0.3') # <-- run this code only if you don't have renv already installed
renv::restore() 

packages <- c('haven','dplyr', 'ggplot2', 'reshape2', 'tidyverse', 'pracma',
              'lubridate', 'scales', 'gt', 'tidymodels', 'sae', 'readxl', 'tidyr', 'foreign', 'grid', 'forcats')  
lapply(packages, require, character.only=TRUE)

##clear the environment
rm(list = ls())



## -------------------------------------------------------------------------------------------------

# Change the working directory here to ./Data/01_base/intervention_data in your computer
setwd("C:/WBG/Rep-checks/20231102-jep-tax-2023-v1.1/Data/01_base/intervention_data")
jep_data<- read_excel("Intervention_Database.xlsx")

## set seed to ensure jitter does not shift with each run
set.seed(5)



## ----pressure, echo=FALSE-------------------------------------------------------------------------


################COMPLIANCE##################
# Filter the data
compliance <- jep_data %>%
  filter(Headline == 1,
         Effect_size_unit_standarised == "pp",
         Statistical_significance_level %in% c("0.05", "0.1", "0.01"))

# Calculate counts for each category
category_counts <- compliance %>%
  group_by(Categorization_for_figure_final) %>%
  summarise(count = n())

# Join the counts back to the compliance dataframe
compliance <- left_join(compliance, category_counts, by = "Categorization_for_figure_final")

# Append counts to the category names in a new column
compliance$Categorization_for_figure_label <- paste(compliance$Categorization_for_figure_final, "(n =", compliance$count, ")")


# Create the plot - more jitter + diff colours!
new_compliance_final <- 
ggplot(compliance, aes(y = Categorization_for_figure_label, x = Effect_size_standardised)) +
  geom_jitter(aes(fill = Categorization_for_figure_final, alpha = Control_mean_standardised), shape = 21, stroke = 1, 
              position = position_jitter(width = 0, height = 0.3)) +
  scale_fill_brewer(palette = "Spectral", guide = FALSE) +
  scale_alpha_continuous(range = c(0.4, 1)) +
  labs(x = "Compliance (pp)", 
       y="",
       alpha = "Control mean (in %)") +
   theme(plot.title = element_text(size = 15), 
        axis.title.x = element_text(size = 10), 
        axis.title.y = element_text(size = 5), 
        axis.text.x = element_text(size = 10), 
        axis.text.y = element_text(size = 8),
        legend.title = element_text(size = 5), 
        legend.text = element_text(size = 5),
        legend.position = "bottom",
        plot.margin = margin(0.5, 1, 1.5, 0.5, "cm")) 

# Display the plot
print(new_compliance_final)

# Save the plot as a PNG file
ggsave("../../../Output/Figure5a_compliance.png", plot = new_compliance_final, width = 8, height = 6, dpi = 300)





## -------------------------------------------------------------------------------------------------
#######################REVENUES################################

# Filter the data
revenues <- jep_data %>%
  filter(Headline == 1,
         Effect_size_unit_standarised == "%",
         Statistical_significance_level %in% c("0.05", "0.1", "0.01"))

# Calculate counts for each category
category_counts <- revenues %>%
  group_by(Categorization_for_figure_final) %>%
  summarise(count = n())

# Join the counts back to the compliance dataframe
revenues <- left_join(revenues, category_counts, by = "Categorization_for_figure_final")

# Append counts to the category names in a new column
revenues$Categorization_for_figure_label <- paste(revenues$Categorization_for_figure_final, "(n =", revenues$count, ")")


# Create bins for Control_mean_standardised
bins_new <- c(0, 10000, 100000, 12495000)
labels <- c("0 - 10k", "10k - 100k", "100k+")

# Create a new variable that contains the bin number for each Control_mean_standardised value
revenues$Control_mean_standardised_bin <- cut(revenues$Control_mean_standardised, breaks = bins_new, labels = labels, include.lowest = TRUE)

# Create the plot - more jitter - different colours!
new_revenues_final <- 
  ggplot(revenues, aes(y = Categorization_for_figure_label, x = Effect_size_standardised)) +
  geom_jitter(aes(fill = Categorization_for_figure_final, alpha = Control_mean_standardised_bin), shape = 21, stroke = 1, 
              position = position_jitter(width = 0, height = 0.3)) +
  scale_fill_brewer(palette = "Spectral", guide = FALSE) +  
  scale_alpha_manual(values = c("0 - 10k" = 0.5, "10k - 100k" = 0.75, "100k+" = 1)) +
  labs(x = "Revenues (%)", 
       y= "",
       fill = "Type of intervention",
       alpha = "Control mean (in USD)") +
  theme(plot.title = element_text(size = 15), 
        axis.title.x = element_text(size = 10), 
        axis.title.y = element_text(size = 5), 
        axis.text.x = element_text(size = 10), 
        axis.text.y = element_text(size = 8),
        legend.title = element_text(size = 5), 
        legend.text = element_text(size = 5),
        legend.position = "bottom",
        plot.margin = margin(0.5, 1, 1.5, 0.5, "cm")) 

# Display the plot
print(new_revenues_final)

# Save the plot as a PNG file
ggsave("../../../Output/Figure5b_revenues.png", plot = new_revenues_final, width = 8, height = 6, dpi = 300)



