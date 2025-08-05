angular.module('beamng.apps')
.directive('timer', [function() {
    return {
        templateUrl: '/ui/modules/apps/timer/app.html',
        replace: true,
        restrict: 'EA',
        scope: true,

        controller: ['$scope', '$timeout', function($scope, $timeout) {

            var counting = false;
            var mytimeout;
            
            $scope.counter = 0;

            $scope.$on('toggleTimer', function() {
                counting = !counting;
                
                if (counting) {
                    startCounter();
                } else {
                    if (mytimeout) {
                        $timeout.cancel(mytimeout);
                    }
                }
            });

            function startCounter() {
                $scope.counter++;
                mytimeout = $timeout(startCounter, 1000);
            }

        }],
    }
}])