app = angular.module 'openweatherApp', []

app.controller 'MainController', [
    '$scope',
    'openweather'
    ($scope, openweather) ->
        console.log openweather.getCitiesByName 'Moscow'
]

app.service 'openweather', ['$http', ($http) ->
    url = 'http://api.openweathermap.org/data/2.5/'

    unit = 'metric'

    @getCitiesByName = (name) ->
        params =
            q: name
            units: unit
            type: 'accurate'

        if localStorage.getItem 'openweather.appid'
            params.APPID = localStorage.getItem 'openweather.appid'

        $http.get url + 'find',
            params: params

    return
]


# app.directive
