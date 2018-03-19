# WeatheR

Here is a very rough suite of functions to visualise data from our OS Anywhere Weather Kit (home weather stations). More information about this type of weather station can be found [here](http://store.oregonscientific.com/us/anywhere-weather-kit.html)

## Getting Started

The functions read code from csv files, several of which are included as examples.

### Prerequisites

Required packages:

* lubridate
* ggplot2
* scales
* plyr
* dplyr
* reshape2
* lubridate
* grid
* zoo
* RColorBrewer
* extrafont
* [openair](https://github.com/cran/openair/)

This list may be tidied up once the future work (see below) has been completed.

## Authors

* **Clare Lindeque** - Hatchet job - [github](https://github.com/clarelindeque/)

## License

Not sure yet

## Acknowledgments

* Inspiration and guidance drawn from [The Jason & Doug Blog](http://jason-doug-climate.blogspot.com)
* Radar plot code modified from answers to [this Stackoverflow question](https://stackoverflow.com/questions/9614433/creating-radar-chart-a-k-a-star-plot-spider-plot-using-ggplot2-in-r/10820387)

## Future Work

This needs serious tidying up:

* Create a proper R project file
* Write test cases/master script
* Upload example output files (png images)
* Upload full data set for each sensor (temperature, rain, wind, humidity, pressure)
