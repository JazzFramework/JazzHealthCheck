import JazzConfiguration;
import JazzServer;

public final class HealthCheckInitializer: ServerInitializer {
    public required init() {}

    public override final func initialize(for app: ServerApp, with configurationBuilder: ConfigurationBuilder) throws {
        _ = configurationBuilder
            .with(file: Constants.CONFIG_FILE, for: HealthCheckConfigV1JsonCodec.supportedMediaType)
            .with(decoder: HealthCheckConfigV1JsonCodec());

        _ = try app
            .wireUp(transcoder: { _, _ in HealthCheckV1JsonCodec() })
            .wireUp(healthCheckProcessor: { _, _ in DefaultHealthCheckProcessor() })
            .wireUp(healthCheckMetricCollector: { _, _ in DefaultHealthCheckMetricCollector() })
            .wireUp(singleton: { _, sp in
                HealthCheckServiceImpl(
                    healthCheckProcessors: try await sp.fetchTypes(),
                    healthCheckMetricCollectors: try await sp.fetchTypes()
                ) as HealthCheckService
            })
            .wireUp(controller: { configuration, sp in
                return await HealthCheckController(
                    configuration: await configuration.fetch() ?? HealthCheckConfig(route: nil),
                    service: try await sp.fetchType()
                )
            });
    }
}