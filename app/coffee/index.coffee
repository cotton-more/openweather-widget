app = angular.module 'openweatherApp', []

app.controller 'MainController', [
    '$scope'
    'openweather'
    ($scope, openweather) ->
        $scope.searchByCityName = ->
            $scope.cities = []
            $scope.currentCity = null
            openweather.getCitiesByName($scope.cityName)
                .then (res) ->
                    if res.data.cod is '200' and res.data.count
                        if res.data.count is 1
                            $scope.currentCity = res.data.list[0]
                        else
                            $scope.cities = res.data.list

        $scope.showForecast = (city) ->
            $scope.currentCity = city
]

app.service 'openweather', ['$http', ($http) ->
    url = 'http://api.openweathermap.org/data/2.5/'

    @getCitiesByName = (name) ->
        params =
            q: name
            type: 'accurate'
            callback: 'JSON_CALLBACK'

        if localStorage.getItem 'openweather.appid'
            params.APPID = localStorage.getItem 'openweather.appid'

        $http.jsonp url + 'find',
            params: params

    return
]


app.filter 'temp', ->
    k = 273.15
    (input) ->
        temp = parseFloat input - k
        if not isNaN temp
            temp.toFixed 1
