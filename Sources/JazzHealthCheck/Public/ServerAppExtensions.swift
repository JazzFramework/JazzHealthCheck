import JazzConfiguration;
import JazzDependencyInjection;
import JazzServer;

public extension ServerApp {
    final func wireUp<THealthCheckProcessor: HealthCheckProcessor>(
        healthCheckProcessor: @escaping (Configuration, ServiceProvider) async throws -> THealthCheckProcessor
    ) throws -> ServerApp {
        try wireUp(singleton: { config, sp in
            try await healthCheckProcessor(config, sp) as HealthCheckProcessor
        })
    }

    final func wireUp<THealthCheckMetricCollector: HealthCheckMetricCollector>(
        healthCheckMetricCollector: @escaping (Configuration, ServiceProvider) async throws -> THealthCheckMetricCollector
    ) throws -> ServerApp {
        try wireUp(singleton: { config, sp in
            try await healthCheckMetricCollector(config, sp) as HealthCheckMetricCollector
        })
    }
}