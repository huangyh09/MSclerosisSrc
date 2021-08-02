#' A dotplot for matrices with variable size and color
#'
#' @param size_mat A matrix of dot sizes with shape (n_row, n_column)
#' @param color_mat A matrix of dot colors with shape (n_row, n_column)
#' @param size_title A string value for the legend title on size
#' @param color_title A string value for the legend title on color
#' @param size_range A range value for size range in display
#' @param color_limits A vector or two floats for color limits in display. If 
#' NULL, c(-1, 1) * max(abs(df_dat$Color)) is used.
#'
#' @return a ggplot object
#'
#' @export
#' @import ggplot2
#'
matrix_dotplot <- function(size_mat, color_mat, 
                           size_title='Size', color_title='Color', 
                           size_range=range(0.1, 4), color_limits=NULL) {
  # Check row and column names
  if (is.null(rownames(size_mat)))
    rownames(size_mat) <- paste0('Row', seq_len(nrow(size_mat)))
  if (is.null(colnames(size_mat)))
    colnames(size_mat) <- paste0('Column', seq_len(ncol(size_mat)))
  
  if (is.null(rownames(color_mat)))
    rownames(color_mat) <- paste0('Row', seq_len(nrow(color_mat)))
  if (is.null(colnames(color_mat)))
    colnames(color_mat) <- paste0('Column', seq_len(ncol(color_mat)))
  
  size_df = reshape2::melt(size_mat)
  color_df = reshape2::melt(color_mat)
  
  colnames(size_df) <- c('Row', 'Column', 'Size')
  colnames(color_df) <- c('Row', 'Column', 'Color')
  
  df_dat <- cbind(size_df, color_df['Color'])
  
  if (is.null(color_limits)) {
    color_limits = c(-1, 1) * max(abs(df_dat$Color))
  }
  
  df_dat$Color[df_dat$Color < color_limits[1]] <- color_limits[1]
  df_dat$Color[df_dat$Color > color_limits[2]] <- color_limits[2]
  
  ggplot(data = df_dat, aes(x = Column, y = Row)) + 
    geom_point(aes(size = Size, colour = Color)) + 
    xlab('') + ylab('') +
    theme_classic(base_line_size=0) + 
    scale_size(range = size_range, name = size_title) +
    scale_color_distiller(palette = "RdBu", limits = color_limits, 
                          name = color_title, 
                          breaks=c(color_limits, color_limits/2, 0),
                          labels=c(paste('<', color_limits[1]), 
                                   paste('>', color_limits[2]),
                                   color_limits/2, 0))
    # scale_color_gradient2(midpoint = 0, low = "blue", mid = "white",
    #                       high = "red", space = "Lab", name = color_title)
}
