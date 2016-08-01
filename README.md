# metrics
Finds and displays build metrics in the RealSelf build server. Running `metrics.rb` will generate/update all 6 .png images.

## To-Do
1. After fix for missing coverage metrics, test `gen-lines-chart.rb` and make/test `gen-cov-chart.rb`
2. It looks like warning metrics are only generated in branch builds, not pull request builds. Ideally, update pull-request-build to generate these metrics, then format the warning_count.png output like all the other output.
3. Add a display somewhere on all 6 charts showing most current data. (Does Gruff even support this?)
4. Add a current activity box. (Where is this data?)
5. Update branch-build and pull-request-build to run `metrics.rb` (should just be 1 line in each file).
6. Make and publish a flexgrid layout to display all the images.