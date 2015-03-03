App.directive 'violationDashboard', ['Violation', (Violation) ->
  scope: {}
  templateUrl: '/templates/dashboard'

  link: (scope, element, attributes) ->
    scope.maxCount = 1020
    loadData = ->
      violations = Violation.query()
      violations.$promise.then((results) ->
        scope.violations = results
      )

    loadData()
]
