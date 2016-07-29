import simplejson
import urllib
import urllib.request
import numpy as np

ELEVATION_BASE_URL = 'https://maps.googleapis.com/maps/api/elevation/json'
CHART_BASE_URL = 'http://chart.apis.google.com/chart'

def getElevation(path="36.578581,-118.291994|36.23998,-116.83171",samples="100", **elvtn_args):
      elvtn_args.update({
        'path': path,
        'samples': samples
      })

      url = ELEVATION_BASE_URL + '?' + 'locations=50.77954,7.177452'
      response = simplejson.load(urllib.request.urlopen(url))

      # Create a dictionary for each results[] object
      elevationArray = []

      for resultset in response['results']:
        elevationArray.append(resultset['elevation'])

      # Create the chart passing the array of elevation data
      # getChart(chartData=elevationArray)
      print(elevationArray)
	  
if __name__ == '__main__':
    # Mt. Whitney
    startStr = "36.578581,-118.291994"
    # Death Valley
    endStr = "36.23998,-116.83171"

    pathStr = startStr + "|" + endStr

    getElevation(pathStr)
