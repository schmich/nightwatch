var app = angular.module('nightwatch', [])

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
