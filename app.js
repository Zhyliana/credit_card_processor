var app = angular.module('creditCardProcessor', ['ui.router']);

app.config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {
  $urlRouterProvider.otherwise('/');

  $stateProvider.state('home', {
    url: '/',
    template: '<home></home>'
  });

  $stateProvider.state('logger', {
    url: '/logger',
    template: '<logger></logger>'
  });

  $stateProvider.state('account', {
    url: '/account?name',
    template: '<account></account>'
  });
}]);

app.service('transactionService', ['$http', function ($http){
  var service = {};
  var allTransactions;

  $http.get('/transactions').then(function (response) {
    debugger
    service.allTransactions = response;
  });


  return service

}]);

app.directive('home', ['transactionService', function (creditCardService){
  return {
    scope: {},
    template: '<h1 class="collar">{{transactions}}</h1>',
    link: function (scope, element) {
      scope.transactions = creditCardService.allTransactions;
    }
  }
}]);