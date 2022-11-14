library(data.table)
for (i in 2012:2022) {
    url <- paste0("http://prod2.publicdata.landregistry.gov.uk.s3-website-eu-west-1.",
                  "amazonaws.com/pp-", i, ".txt")
    x <- read.table(url, sep = ",", fill = TRUE)
    setDT(x)
    saveRDS(x, paste0("data/houses_", i))
}
