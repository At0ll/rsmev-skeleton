angular.module('rsmev.widgets', [])
  .directive 'adminWidget', [() ->
    widgetKey = 'adminWidget'
    return {
      restrict: "A",
      replace: true,
      templateUrl: widgetKey + ".html",
      scope: {},
      link: (scope) ->
        scope.show = false;
    }
  ]