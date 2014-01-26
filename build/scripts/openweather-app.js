(function() {
  var app;

  app = angular.module('openweatherApp', []);

  app.controller('MainController', [
    '$scope', 'openweather', function($scope, openweather) {
      $scope.searchByCityName = function() {
        $scope.cities = [];
        $scope.currentCity = null;
        return openweather.getCitiesByName($scope.cityName).then(function(res) {
          if (res.data.cod === '200' && res.data.count) {
            if (res.data.count === 1) {
              return $scope.currentCity = res.data.list[0];
            } else {
              return $scope.cities = res.data.list;
            }
          }
        });
      };
      return $scope.showForecast = function(city) {
        return $scope.currentCity = city;
      };
    }
  ]);

  app.service('openweather', [
    '$http', function($http) {
      var url;
      url = 'http://api.openweathermap.org/data/2.5/';
      this.getCitiesByName = function(name) {
        var params;
        params = {
          q: name,
          type: 'accurate',
          callback: 'JSON_CALLBACK'
        };
        if (localStorage.getItem('openweather.appid')) {
          params.APPID = localStorage.getItem('openweather.appid');
        }
        return $http.jsonp(url + 'find', {
          params: params
        });
      };
    }
  ]);

  app.filter('temp', function() {
    var k;
    k = 273.15;
    return function(input) {
      var temp;
      temp = parseFloat(input - k);
      if (!isNaN(temp)) {
        return temp.toFixed(1);
      }
    };
  });

}).call(this);
