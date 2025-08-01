angular.module('beamng.apps')
.directive('myApp', [function () {
  return {
    replace: true,
    
    controller: ['$scope', '$timeout', function($scope, $timeout) {
      var counting = false;
      var mytimeout;

      $scope.counter = 0;

      $scope.clicked = function () {
        counting = !counting;
        
        if (counting) {
          startCounter();
        } else {
          if (mytimeout) {
            $timeout.cancel(mytimeout);
          }
        }
      };

      function startCounter() {
        $scope.counter++;
        mytimeout = $timeout(startCounter, 1);
      }
    }],

    template: `
<div id='myApp-window' style="background-color: blue;"> 
    <p>Contatore: {{counter}}</p>
    <button style="background-color: white; color: black;" ng-click="clicked()">Start-Stop</button>
</div>
`
  };
}]);
