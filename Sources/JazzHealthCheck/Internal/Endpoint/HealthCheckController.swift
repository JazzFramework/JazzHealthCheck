import JazzConfiguration;
import JazzServer;

internal final class HealthCheckController: ApiController {
    private final let service: HealthCheckService;
    private final let route: String;

    internal init(configuration: HealthCheckConfig, service: HealthCheckService) async {
        self.service = service;
        self.route = configuration.getRoute();

        super.init();
    }

    public final override func getRoute() -> String { route }

    public final override func logic(withRequest request: RequestContext) async throws -> ApiControllerResult {
        let healthCheck: HealthCheck = await service.getHealthCheck();

        return ok(body: healthCheck);
    }
}