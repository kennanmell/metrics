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

# Script that generates a chart displaying number of lines of code by Swift/Objective-C.

coverage_data = []
keys = []

client = Mongo::Client.new(MONGO_URI)
db = client.database
collection = client[:builds]
collection.find().sort(:start_time => -1).limit(LIMIT).map do |document|
    pull_number = document['pull_request'].to_i
    if pull_number != 0 && !keys.include?(pull_number) && document['metrics'] != nil && document['metrics']['coverage'] != nil
        keys.push(pull_number)
        coverage_data.insert(0, [pull_number, document['metrics']['coverage']['swift_files']['total_lines'], document['metrics']['coverage']['m_files']['total_lines']])
    end
end

g = Gruff::StackedBar.new
g.title = "Lines of Code"
g.labels = coverage_data.each_with_index.map {|data, i| [ i, data[0] ]}.to_h
g.theme = {
  :colors => ['#12a702', '#aedaa9'],
  :font_color => 'black',
  :background_colors => 'white'
}
g.font = '/Library/Fonts/Verdana.ttf'
g.data("Swift", coverage_data.map {|data| data[1]})
g.data("Objective-C", coverage_data.map {|data| data[2]})
g.write "output/lines_of_code.png"
