require 'gruff'
require 'mongo'
require_relative 'constants'

# Script that generates a chart displaying warning count information for past pull requests.

coverage_data = []
keys = []

client = Mongo::Client.new(MONGO_URI)
db = client.database
collection = client[:builds]
collection.find().sort(:start_time => -1).limit(LIMIT).map do |document|
    pull_number = document['pull_request'].to_i
    if pull_number == 0
        keys.push(pull_number)
        coverage_data.insert(0, [pull_number, document['metrics']['warning_count']])
    end
end

g = Gruff::Line.new
g.title = 'Warnings'
g.labels = coverage_data.each_with_index.map {|data, i| [ i, data[0] ]}.to_h
g.dot_style = :square
g.data("# warnings", coverage_data.map {|data| data[1]})
g.x_axis_label = ''

g.theme = {
    :colors => ['#c3a00b'],
    :font_color => 'black',
    :background_colors => 'white'
}
g.write('output/warning_count.png')
