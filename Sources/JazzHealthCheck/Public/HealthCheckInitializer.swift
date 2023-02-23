import JazzConfiguration;
import JazzServer;

public final class HealthCheckInitializer: ServerInitializer {
    public required init() {}

    public override final func initialize(for app: ServerApp, with configurationBuilder: ConfigurationBuilder) throws {
        _ = configurationBuilder
            .with(file: Constants.CONFIG_FILE, for: HealthCheckConfigV1JsonCodec.supportedMediaType)
            .with(decoder: HealthCheckConfigV1JsonCodec());

        _ = try app
            .wireUp(transcoder: { _ in return HealthCheckV1JsonCodec(); })
            .wireUp(healthCheckProcessor: { _ in return DefaultHealthCheckProcessor(); })
            .wireUp(healthCheckMetricCollector: { _ in return DefaultHealthCheckMetricCollector(); })
            .wireUp(singleton: { sp in
                return HealthCheckServiceImpl(
                    healthCheckProcessors: try await sp.fetchTypes(),
                    healthCheckMetricCollectors: try await sp.fetchTypes()
                ) as HealthCheckService;
            })
            .wireUp(controller: { sp in
                return await HealthCheckController(
                    configuration: try await sp.fetchType(),
                    service: try await sp.fetchType()
                );
            });
    }
}