# NACCADNI

## Overview

Delivering prediction models for NACC and ADNI registered cohort

## Installation

``` r
# Install development version from GitHub
devtools::install_github("lovestat/NACCADNI")
```

</div>

## Usage

##### Download the model

make sure that the end of path was name with `.rds`

``` r
library(NACCADNI)
library(tidyverse)
download_model("model.rds")
```

##### Load the model into the R environment

``` r
mod <- load_model("model.rds")
```

##### Make prediction on the data

``` r
data("tinydat")
pred <- predict_model(mod, tinydat)
```


##### Exctract the survival probability table  

``` r
tab <- survProb_predict(pred)
tab
```

##### Plot the survival curves 

``` r
plot_survProb(tab)
```
