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

covid_plot_byDay <- function(dataset = NA, title_caption = NA) {
  

    
    pl = ggplot(dataset, aes(x = CPD_sum, y = CPD, color = Country, group = Country)) +
      xlab("Total Cases") +
      ylab("Cases per day") +
      labs(title = paste0("Confirmed cases as of", format(last(dataset$Days), " %B %d %Y")),
           caption = title_caption) +
      theme_classic() +
      theme(legend.position = "none",
            plot.title = element_text(size = title_size, face = "bold"),
            plot.caption = element_text(hjust = 0, face = "italic", size = caption_zise),
            axis.text=element_text(size=12),
            axis.title=element_text(size=14,face="bold"),
            strip.text.x = element_text(size = 14))
    
    
    countries = unique(dataset$Country)
    if(length(countries) > num_colors || length(countries) == 0) return(pl)
    
    names(colorvector) = countries
    
    pl = pl + geom_point(size = 0.5, colour = "#d9d9d9") +
      geom_smooth(method = "loess", se = FALSE) +
      scale_color_manual(values = colorvector) +
      facet_wrap(.~Country, ncol = 3, nrow = 3)
    
    return(pl) 

}


covid_plot <- function(dataset = NA, title_caption = NA) {
  
  pl = ggplot(dataset, aes(x = CPD_sum, y = CPD, color = Country, group = Country)) +
    xlab("Total Cases") +
    ylab("Cases per day (week average)") +
    labs(title = paste0("Confirmed cases as of", format(last(dataset$Days), " %B %d %Y")),
         caption = title_caption) +
    theme_classic() +
    theme(legend.text = element_text(size=legend_size),
          #legend.title = element_text(size=legend_size, face="bold"),
          legend.title = element_blank(),
          legend.position = c(0.15, 0.85),
          plot.title = element_text(size = title_size, face = "bold"),
          plot.caption = element_text(hjust = 0, face = "italic", size = caption_zise),
          axis.text=element_text(size=12),
          axis.title=element_text(size=14,face="bold"),
          strip.text.x = element_text(size = 14))
  
  countries = unique(dataset$Country)
  if(length(countries) > num_colors || length(countries) == 0) return(pl)
  
  names(colorvector) = countries
  
  pl = pl + geom_point(size = 1.5, shape = 19) +
    geom_line(size = 1) +
    scale_color_manual(values = colorvector)
  
  return(pl) 
  
}