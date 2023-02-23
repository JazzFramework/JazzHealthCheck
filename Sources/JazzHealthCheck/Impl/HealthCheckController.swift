import JazzConfiguration;
import JazzServer;

internal final class HealthCheckController: ApiController {
    private final let service: HealthCheckService;
    private final let route: String;

    internal init(configuration: Configuration, service: HealthCheckService) async {
        self.service = service;

        if let config: HealthCheckConfig = await configuration.fetch() {
            self.route = config.getRoute();
        } else {
            self.route = Constants.DEFAULT_ROUTE;
        }

        super.init();
    }

    public final override func getRoute() -> String { return route; }

    public final override func logic(withRequest request: RequestContext) async throws -> ApiControllerResult {
        let healthCheck: HealthCheck = await service.getHealthCheck();

        return ApiControllerResultBuilder()
            .with(statusCode: 200)
            .with(body: healthCheck)
            .build();
    }
}