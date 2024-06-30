local date_manager = {}

function date_manager:getCurrentDate()
    local currentDate = os.date("*t")
    local monthNames = {
        "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
    }
    local monthName = monthNames[currentDate.month]
    local formattedDate = string.format("%s %d, %d", monthName, currentDate.day, currentDate.year)
    return formattedDate
end

return date_manager