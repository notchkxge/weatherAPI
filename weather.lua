local api_key= os.getenv("WEATHER_API_KEY") --api set

-- loads the HTTP module and any libraries it requires
local https = require("ssl.https")
local json = require("dkjson")
local ltn12 = require("ltn12")

function cityInputCheck()
    local city
    repeat
        print("Choose a city:")
        city = io.read()
        if city == "" then
            print("You have to choose a city!!!")
        end
    until city ~= ""
    city = string.lower(city)
    return city
end

local q = cityInputCheck()

local url = string.format("https://api.openweathermap.org/data/2.5/weather?q=%s&appid=%s",q, api_key)

local response_body = {}

local info,code,response_header,status = https.request{
    url = url,
    sink = ltn12.sink.table(response_body)
}

local response_body_str = table.concat(response_body)

local debug = false
if debug then
    print("Response: " ..response_body_str)
end
local data = json.decode(response_body_str)

function kelvinToCelsius(temp)
    --[[local celsius
    local temp = data.main.temp
    celsius = temp - 273.15 
    return celsius--]]
    return temp - 273.15
end

if data and data.main then
    print(string.format("Information about: %s -%s", data.name, data.sys.country or 0))
    print(string.format("Temperature is: %.2f°C", kelvinToCelsius(data.main.temp or 0)))
    print(string.format("Feel's like: %.2f°C", kelvinToCelsius(data.main.feels_like or 0)))
    print(string.format("Humidity: %.2f%%", data.main.humidity or 0))
    print(string.format("Wind's speed: %.2fm/s", data.wind.speed or 0))
else
    print("Could not retrieve weather data. Please check the city name.")
end