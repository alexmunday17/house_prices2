library(data.table)

houses <- readRDS("data/houses_london.Rds")
houses[, date := as.Date(date)]
houses[, property_type := fcase(property_type == "F", "Flat",
                                property_type == "T", "Terraced",
                                property_type == "S", "Semi",
                                property_type == "D", "Detached",
                                property_type == "O", "Other")]
houses[, new_build := new_build == "Y"]
houses[, estate_type := fifelse(estate_type == "L", "Leasehold", "Freehold")]
houses <- houses[, .(date, postcode, property_type, new_build, estate_type, district, price)]
saveRDS(houses, "data/houses_london_clean.Rds")
