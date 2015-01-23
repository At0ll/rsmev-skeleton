angular.module('rsmev.services', [])
  .factory 'sharedService', [() ->
    get = () -> "Hello"
    return {
      get: get
    }
  ]