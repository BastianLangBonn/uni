import simplejson
import urllib
import urllib.request

ELEVATION_BASE_URL = 'https://maps.googleapis.com/maps/api/elevation/json'
CHART_BASE_URL = 'http://chart.apis.google.com/chart'

def getElevation(latitude, longitude):

      url = ELEVATION_BASE_URL + '?' + 'locations=' + str(latitude) + ',' + str(longitude)
      response = simplejson.load(urllib.request.urlopen(url))

      # Create a dictionary for each results[] object
      elevationArray = []
      print(response)

      for resultset in response['results']:
        elevationArray.append(resultset['elevation'])
        return resultset['elevation']

      # Create the chart passing the array of elevation data
      # getChart(chartData=elevationArray)
      #return elevationArray
	  
