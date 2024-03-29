internal final class HealthCheckConfig {
    private final let route: String?;

    internal init(route: String?) {
        self.route = route;
    }

    internal final func getRoute() -> String { route ?? Constants.DEFAULT_ROUTE }
}