App.directive 'dashboardBar', ['Violation', (Violation) ->
  scope: {}
  templateUrl: '/templates/dashboard'

  link: (scope, element, attributes) ->
    loadData = ->
      console.log Violation.query()
      data = ["string", 1, "test", 2]

    scope.$watch "count", (newValue, oldValue) =>
      scope.countVar = 300

    loadData()
]
