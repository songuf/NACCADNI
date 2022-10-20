get_model <- function(){
  o <- load(url("http://www.psychology.mcmaster.ca/bennett/psy710/datasets/mood_data.Rdata"))
  get(o)
}


