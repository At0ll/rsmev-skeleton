describe "Admin Application:", ->
  describe "Controllers:", ->
    beforeEach module("rsmev")
    describe "adminController", ->
      scope = undefined
      beforeEach inject(($rootScope, $controller) ->
        scope = $rootScope.$new()
        $controller "adminController",
          $scope: scope
      )
      it "title value", ->
        expect(scope.title).toBe "Hello Admin"