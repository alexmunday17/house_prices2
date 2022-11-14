library(data.table)
library(ggplot2)
library(mgcv)

houses <- readRDS("data/houses_london_clean.Rds")
houses <- houses[between(price, quantile(price, 0.025), quantile(price, 0.975))]

ggplot(houses) + geom_density(aes(x = price))

ggplot(houses) + geom_smooth(aes(x = date, y = price))
ggplot(houses) + geom_smooth(aes(x = yday(date), y = price))

houses[, date_num := as.numeric(date)]
houses[, day_of_year := yday(date)]

mod <- gam(price ~ s(date_num) + property_type + new_build + estate_type + district +
               s(day_of_year),
           data = houses)
summary(mod)
plot.gam(mod, scale = 0)
