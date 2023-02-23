internal final class HealthCheckConfig {
    private final let route: String?;

    internal init(route: String?) {
        self.route = route;
    }

    internal final func getRoute() -> String {
        return route ?? Constants.DEFAULT_ROUTE;
    }
}