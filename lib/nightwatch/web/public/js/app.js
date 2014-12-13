var app = angular.module('nightwatch', ['angular.filter'])

app.controller('ReportCtrl', function($scope, $http) {
  $scope.exceptions = [];
  $scope.exceptionClass = '*';

  $scope.activeException = null;

  $http.get('/exceptions')
    .success(function(res) {
      $scope.exceptions = res;
    })
    .error(function(res) {
      console.error(res);
    });

  $scope.setActive = function(exception) {
    $scope.activeException = exception;
  };

  $scope.isActive = function(exception) {
    return $scope.activeException == exception;
  };
});

app.filter('exceptionFilter', function($filter) {
  return function(input, criteria) {
    if (criteria.class == '*') {
      return input;
    } else {
      return $filter('where')(input, { class: criteria.class });
    }
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

app.filter('timeAgo', function() {
  return function(input) {
    var now = (new Date()).getTime() / 1000;
    var elapsedSec = now - parseInt(input);

    var parts = [];

    var elapsedDay = Math.floor(elapsedSec / (60 * 60 * 24));
    if (elapsedDay > 0) {
      parts.push(elapsedDay + 'd');
      elapsedSec -= elapsedDay * (60 * 60 * 24);
    }

    var elapsedHr = Math.floor(elapsedSec / (60 * 60));
    if (elapsedHr > 0) {
      parts.push(elapsedHr + 'h');
      elapsedSec -= elapsedHr * (60 * 60);
    }

    var elapsedMin = Math.floor(elapsedSec / 60);
    if (elapsedMin > 0) {
      parts.push(elapsedMin + 'm');
    }

    if (parts.length > 0) {
      return parts.slice(0, 2).join(' ');
    } else {
      return 'Just now';
    }
  };
});
