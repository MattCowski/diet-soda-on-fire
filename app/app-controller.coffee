'use strict'

angular.module('myapp')
  .constant('FIREBASE_URL', 'https://kts-invoice-app.firebaseio.com/')

  .controller "DemoCtrl", ($scope) ->
    $scope.foo = "hello"
    $scope.rating = 42   
    $scope.minRating = 45
    $scope.maxRating = 55
