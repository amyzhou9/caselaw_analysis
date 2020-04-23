library(jsonlite)
north_carolina <- stream_in(xzfile("/Users/alyssahuberts/Downloads/data.jsonl.xz")) 
dat <- north_carolina$casebody[1:10]
newdat <- dat$data
newnewdat <- newdat$opinions
x <- newnewdat[1]
y <- t(x)
y[[1]]$text


