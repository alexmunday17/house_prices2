library(data.table)
library(ggplot2)
library(mgcv)

houses <- readRDS("data/houses_london_clean.Rds")

setkey(houses, date, price)
fake_data <- data.table(date = houses[, seq(min(date), max(date), by = 1)],
                        N = 0)
houses_count <- rbind(fake_data, houses[, .N, by = date])
setkey(houses_count, date, N)
houses_count <- houses_count[!duplicated(date, fromLast = TRUE)]
houses_count[, rolling_n := frollsum(N, 30)]
ggplot(houses_count) + geom_line(aes(x = date, y = rolling_n))

houses[, price_cap := quantile(price, 0.4), by = year(date)]
houses_count <- rbind(fake_data, houses[price < price_cap, .N, by = date])
setkey(houses_count, date, N)
houses_count <- houses_count[date < "2022-07-01"]
houses_count <- houses_count[!duplicated(date, fromLast = TRUE)]
houses_count[, rolling_n := frollsum(N, 30)]
ggplot(houses_count) + geom_line(aes(x = date, y = rolling_n))


# smooth on time of year
# just look at houses < xth quantile

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
