describe "Client Application:", ->
  describe "Controllers:", ->
    beforeEach module("rsmev")
    describe "clientController", ->
      scope = undefined
      beforeEach inject(($rootScope, $controller) ->
        scope = $rootScope.$new()
        $controller "clientController",
          $scope: scope
      )
      it "title value", ->
        expect(scope.title).toBe "Hello Bro"