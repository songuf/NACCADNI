##' Download the model
##'
##'
##' @title Download the model
##' @param path the path to store the model, make sure ended with .rds
##' @param max.time the max time (seconds) for downloading the model file. The default is 9999 seconds.
##' @return No return value
##' @author Shangchen Song
##' @export
##' @examples
##' download_model(paste0(getwd(), "theModel.rds"))
download_model <- function(path, max.time = 9999){

  old.opt <- options(timeout = max.time)

  download.file(
    "https://media.githubusercontent.com/media/lovestat/NACCADNI/main/model/model.rds",
    path,
    method = "libcurl"
  )

  options(old.opt)

}


##' Load the model
##'
##'
##' @title Load the model
##' @param path the path that stores the model, make sure ended with .rds
##' @return the model object
##' @author Shangchen Song
##' @export
##' @examples
##' mod <- load_model(paste0(getwd(), "theModel.rds"))
load_model <- function(path){
  invisible(readRDS(path))
}

##' Make prediction on the new dataset
##'
##'
##' @title Make prediction on the new dataset
##' @param model the loaded model
##' @param newdata data.frame that has six variables
##' @return predicted object
##' @author Shangchen Song
##' @export
##' @examples
##' test.pred <- predict_model(mod, dat)
predict_model <- function(model, newdata){
  predict(model, newdata)
}

##' Extract the survival probability table
##'
##'
##' @title Extract the survival probability table
##' @param predict.out the predicted object
##' @return data.frame
##' @author Shangchen Song
##' @export
##' @examples
##' survProb_predict(test.pred)
survProb_predict <- function(predict.out){

  survProb.df <-
    tibble::rownames_to_column(as.data.frame( predict.out$survival ),
                               var = "subject")

  colnames(survProb.df) <- c("subject", predict.out$time.interest)

  survProb.df <-
    tidyr::pivot_longer(dplyr::select(survProb.df, subject, dplyr::everything()),
                        "5":"192",
                        names_to = "cutTime",
                        values_to = "survProb")

  survProb.df$cutTime <- as.numeric(survProb.df$cutTime)

  survProb.df
}


##' Plot the survival curves
##'
##'
##' @title Plot the survival curves
##' @param survProb.df the survival probability data.frame output by `survProb_predict`
##' @return No return value
##' @author Shangchen Song
##' @export
##' @examples
##' plot_survProb(survProb_predict(test.pred))
plot_survProb <- function(survProb.df){
  survProb.df %>%
    ggplot2::ggplot() +
    ggplot2::geom_step(
      aes(x = cutTime,
          y = 1-survProb,
          group = subject),
      alpha = 0.3
    ) +
    ggplot2::scale_x_continuous(breaks = seq(0, 120, by = 6)) +
    ggplot2::theme_bw() +
    ggplot2::theme(legend.position = "none") +
    ggplot2::geom_vline(ggplot2::aes(xintercept = 48), linetype = "dashed") +
    ggplot2::labs(y = "Predicted Dementia-Onset-due-to-AD Probability",
                  x = "Time (months)",
                  title = "Predicted AD-Dementia-Onset Probability against Time on ADNI") +
    ggplot2::coord_cartesian(ylim = c(-0.01, 1.01),
                             xlim = c(5, 120))
}



















