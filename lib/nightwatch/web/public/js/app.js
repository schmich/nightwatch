var app = angular.module('nightwatch', ['angular.filter'])

app.controller('ReportCtrl', function($scope, $http) {
  $scope.exceptions = [];

  var showDetails = {};

  $http.get('/exceptions')
    .success(function(res) {
      $scope.exceptions = res;
    })
    .error(function(res) {
      console.error(res);
    });

  $scope.toggleDetails = function(exception) {
    var id = exception._id['$oid'];
    showDetails[id] = showDetails[id] || false;
    showDetails[id] = !showDetails[id];
  };

  $scope.details = function(exception) {
    return showDetails[exception._id['$oid']];
  };
});

app.filter('basename', function() {
  return function(input) {
    var match = input.match(/.*\\(.*)/);
    if (!match) {
      match = input.match(/.*\/(.*)/);
    }

    if (match) {
      return match[1];
    } else {
      return match;
    }
  };
});
