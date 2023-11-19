## PLOTS ##
# Colors for graphs

# Plots theme vars
title_size = 18
caption_zise = 11
legend_size = 16

# Plot colors
num_colors = 9
colorvector = c("#E31A1C", "#FB9A99", "#80b1d3", "#1F78B4", "#B2DF8A", "#33A02C", "#FDBF6F", "#FF7F00", "#984ea3")

# Round up for axis ticks
roundUp <- function(x) 10^ceiling(log10(x))

## DAY PLOT
covid_plot_byDay <- function(dataset = NA, title_caption = NA, title_type = NA, text_data = NA) {

  # axis breaks 
  brk_y = as.numeric(seq(from = 0, to = max(dataset$CPD), by = 1))
  brk_x = as.numeric(seq(from = 0, to = max(dataset$CPD_sum), by = 1))
  
  # axis labels
  brk_label_x = roundUp(c(0, 10^brk_x[-1]))
  # x axis labels transformation for numbers more than 1 million. 
  brk_label_x = ifelse(brk_label_x >= 1e6, paste0(format(round(brk_label_x / 1e6, 1), digits = NULL, scientific = FALSE, trim = TRUE), "M"), format(brk_label_x, digits = NULL, scientific = FALSE, big.mark = ",", trim = TRUE))
  brk_label_y = format(roundUp(c(0, 10^brk_y[-1])),digits = 1, scientific = FALSE, big.mark = ",", trim = TRUE)
  
    pl = ggplot(dataset, aes(x = CPD_sum, y = CPD, color = Country, group = Country)) +
      scale_y_continuous(breaks = brk_y, labels = brk_label_y) +
      scale_x_continuous(breaks = brk_x, labels = brk_label_x) +
      xlab("Total Cases") +
      ylab("Cases per day") +
      labs(title = paste0(title_type, " as of", format(last(dataset$Days), " %B %d %Y")),
           caption = title_caption) +
      theme_classic() +
      theme(legend.position = "none",
            plot.title = element_text(size = title_size, face = "bold"),
            plot.caption = element_text(hjust = 0, face = "italic", size = caption_zise),
            axis.text=element_text(size=12),
            axis.title=element_text(size=14,face="bold"),
            strip.text.x = element_text(size = 14))
    
    #plot colors
    countries = sort(unique(as.character(dataset$Country)))
    if(length(countries) > num_colors || length(countries) == 0) return(pl)
    names(colorvector) = countries
    
    pl = pl + geom_point(size = 0.5, colour = "#d9d9d9") +
      geom_smooth(method = "loess", se = FALSE) +
      scale_color_manual(values = colorvector) +
      facet_wrap(.~Country, ncol = 3, nrow = 3)
    
    text_data <- text_data[text_data$cases_by == "day", ]
    text_data <- text_data[text_data$cases_type == title_type, ]
    text_data <- dplyr::mutate(text_data, label = paste0("Today: ", format(CPD, digits = NULL, scientific = FALSE, big.mark = ",", trim = TRUE), "\n", "Total: ", format(CPD_sum, digits = NULL, scientific = FALSE, big.mark = ",", trim = TRUE)) )
    
    pl = pl + geom_text(data = text_data, mapping = aes(x = -Inf, y = Inf, label = label, group = Country), colour = "black", vjust = 1.5, hjust = -0.1, size = 4)
    
    return(pl) 

}

## WEEK PLOT
covid_plot <- function(dataset = NA, title_caption = NA, title_type = NA, text_data = NA) {
  
  dataset <- dataset[is.finite(dataset$CPD),]
  dataset <- dataset[is.finite(dataset$CPD_sum),]
  # axis breaks 
  brk_y = as.numeric(seq(from = 0, to = max(dataset$CPD), by = 1))
  brk_x = as.numeric(seq(from = 0, to = max(dataset$CPD_sum), by = 1))
  
  # axis labels
  brk_label_x = roundUp(c(0, 10^brk_x[-1]))
  # x axis labels transformation for numbers more than 1 million. 
  brk_label_x = ifelse(brk_label_x >= 1e6, paste0(format(round(brk_label_x / 1e6, 1), digits = NULL, scientific = FALSE, trim = TRUE), "M"), format(brk_label_x, digits = NULL, scientific = FALSE, big.mark = ",", trim = TRUE))
  
  brk_label_y = format(roundUp(c(0, 10^brk_y[-1])),digits = 1, scientific = FALSE, big.mark = ",", trim = TRUE)
  
  pl = ggplot(dataset, aes(x = CPD_sum, y = CPD, color = Country, group = Country)) +
    scale_y_continuous(breaks = brk_y, labels = brk_label_y) +
    scale_x_continuous(breaks = brk_x, labels = brk_label_x) +
    xlab("Total Cases") +
    ylab("Cases per week") +
    labs(title = paste0(title_type, " as of", format(last(dataset$Days), " %B %d %Y")),
         caption = title_caption) +
    theme_classic() +
    theme(legend.text = element_text(size=legend_size),
          #legend.title = element_text(size=legend_size, face="bold"),
          legend.title = element_blank(),
          legend.position = "none",
          plot.title = element_text(size = title_size, face = "bold"),
          plot.caption = element_text(hjust = 0, face = "italic", size = caption_zise),
          axis.text=element_text(size=12),
          axis.title=element_text(size=14,face="bold"),
          strip.text.x = element_text(size = 14))
  
  #plot colors
  countries = sort(unique(as.character(dataset$Country)))
  if(length(countries) > num_colors || length(countries) == 0) return(pl)
  names(colorvector) = countries
  
  pl = pl + geom_point(size = 1.5, shape = 19) +
    geom_line(size = 1) +
    scale_color_manual(values = colorvector) +
    facet_wrap(.~Country, ncol = 3, nrow = 3)
  
  text_data <- text_data[text_data$cases_by == "week", ]
  text_data <- text_data[text_data$cases_type == title_type, ]
  text_data <- dplyr::mutate(text_data, label = paste0("Week av.: ", format(CPD, digits = NULL, scientific = FALSE, big.mark = ",", trim = TRUE), "\n", "Total: ", format(CPD_sum, digits = NULL, scientific = FALSE, big.mark = ",", trim = TRUE)) )
  pl = pl + geom_text(data = text_data, mapping = aes(x = -Inf, y = Inf, label = label, group = Country), colour = "black", vjust = 1.5, hjust = -0.1, size = 4)
  
  return(pl) 
  
}