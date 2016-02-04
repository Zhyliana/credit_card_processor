var ccProcessor = angular.module('creditCardProcessor');

function buster(){
  return {
      scope: {},
      template: '<h1>Buster Template</h1>',
      link: function (scope, element) {
      }
  }
}

ccProcessor.directive('buster', [buster]);