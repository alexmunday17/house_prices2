library(data.table)

houses <- NULL
for (i in 2012:2022) {
    x <- readRDS(paste0("data/houses_", i))
    setDT(x)
    x <- x[V14 == "GREATER LONDON"]
    houses <- rbind(houses, x)
}

names(houses) <- c("id", "price", "date", "postcode", "property_type", "new_build",
                   "estate_type", "house_number", "house_number2", "road", "locality",
                   "town", "district", "county", "v1", "v2")

saveRDS(houses, "data/houses_london.Rds")
