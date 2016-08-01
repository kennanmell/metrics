require 'gruff'
require 'mongo'

coverage_data = [
  [ "2.4", 2187 + 46079, 697 + 31899 ],
  [ "2.5", 2198 + 46186, 297 + 23172 ]
]

# To-Do: Fill in coverage data

g = Gruff::StackedBar.new
g.title = "Coverage %"
g.labels = coverage_data.each_with_index.map {|data, i| [ i, data[0] ]}.to_h
g.theme = {
  :colors => ['#12a702', '#aedaa9'],
  :font_color => 'black',
  :background_colors => 'white'
}
g.font = '/Library/Fonts/Verdana.ttf'
g.data("Swift", coverage_data.map {|data| data[1] - data[2]})
g.data("Obj-C", coverage_data.map {|data| data[2]})
g.write "code_coverage.png"
