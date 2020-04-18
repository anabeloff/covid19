## PLOTS ##
# Colors for graphs

# Plots theme vars
title_size = 18
caption_zise = 11
legend_size = 16

# Plot colors
num_colors = 9
# colorvector = RColorBrewer::brewer.pal(num_colors, "Paired")
colorvector = c("#80b1d3", "#1F78B4", "#B2DF8A", "#33A02C", "#FB9A99", "#E31A1C", "#FDBF6F", "#FF7F00", "#984ea3")

# Round up for axis ticks
roundUp <- function(x) 10^ceiling(log10(x))


## DAY PLOT
covid_plot_byDay <- function(dataset = NA, title_caption = NA, title_type = NA) {

  # axis breaks 
  brk_y = as.numeric(seq(from = 0, to = max(dataset$CPD), by = 3.5))
  brk_x = as.numeric(seq(from = 0, to = max(dataset$CPD_sum), by = 3.5))
  
    pl = ggplot(dataset, aes(x = CPD_sum, y = CPD, color = Country, group = Country)) +
      scale_y_continuous(breaks = brk_y, labels = format(roundUp(c(0, exp(brk_y[-1]))),digits = 0, scientific = FALSE, big.mark = ",", trim = TRUE)) +
      scale_x_continuous(breaks = brk_x, labels = format(roundUp(c(0, exp(brk_x[-1]))), digits = 0, scientific = FALSE, big.mark = ",", trim = TRUE)) +
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
    
    return(pl) 

}

## WEEK PLOT
covid_plot <- function(dataset = NA, title_caption = NA, title_type = NA) {
  
  # axis breaks 
  brk_y = as.numeric(seq(from = 0, to = max(dataset$CPD), by = 3.5))
  brk_x = as.numeric(seq(from = 0, to = max(dataset$CPD_sum), by = 3.5))
  
  pl = ggplot(dataset, aes(x = CPD_sum, y = CPD, color = Country, group = Country)) +
    scale_y_continuous(breaks = brk_y, labels = format(roundUp(c(0, exp(brk_y[-1]))),digits = 0, scientific = FALSE, big.mark = ",", trim = TRUE)) +
    scale_x_continuous(breaks = brk_x, labels = format(roundUp(c(0, exp(brk_x[-1]))), digits = 0, scientific = FALSE, big.mark = ",", trim = TRUE)) +
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
  
  return(pl) 
  
}