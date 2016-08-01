require 'gruff'
require 'mongo'

coverage_data = [
  [ "2.4", 2187 + 46079, 697 + 31899 ],
  [ "2.5", 2198 + 46186, 297 + 23172 ]
]

# To-Do: Fill in coverage data

require 'gruff'
require 'mongo'
require_relative 'constants'

# Script that generates a chart displaying number of builds per day by branch/PR.

coverage_data = []
keys = []

client = Mongo::Client.new(MONGO_URI)
db = client.database
collection = client[:builds]
collection.find().sort(:start_time => -1).limit(LIMIT).map do |document|
    
    startDateComponents = document['start_time'].to_s.split(' ')[0].split('-')
        
    dateString = startDateComponents[1] + "/" + startDateComponents[2]
    
    if keys.include?(dateString)
        coverage_data.each { |arr|
            if arr[0] == dateString
                if document['pull_request'] != nil
                    arr[1] = arr[1] + 1
                else
                    arr[2] = arr[2] + 1
                end
            end
        }
    else
        keys.push(dateString)
        if document['pull_request'] != nil
            coverage_data.insert(0, [dateString, 1, 0])
        else
            coverage_data.insert(0, [dateString, 0, 1])
        end
    end
end

g = Gruff::StackedBar.new
g.title = "Builds per Day"
g.labels = coverage_data.each_with_index.map {|data, i| [ i, data[0] ]}.to_h
g.theme = {
  :colors => ['#12a702', '#aedaa9'],
  :font_color => 'black',
  :background_colors => 'white'
}
g.font = '/Library/Fonts/Verdana.ttf'
g.data("Pull Request", coverage_data.map {|data| data[1]})
g.data("Other", coverage_data.map {|data| data[2]})
g.write "daily-builds.png"
