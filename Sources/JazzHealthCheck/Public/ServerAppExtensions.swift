import JazzDependencyInjection;
import JazzServer;

public extension ServerApp {
    final func wireUp<THealthCheckProcessor: HealthCheckProcessor>(
        healthCheckProcessor: @escaping (ServiceProvider) async throws -> THealthCheckProcessor
    ) throws -> ServerApp {
        return try wireUp(singleton: { sp in
            return try await healthCheckProcessor(sp) as HealthCheckProcessor;
        });
    }

    final func wireUp<THealthCheckMetricCollector: HealthCheckMetricCollector>(
        healthCheckMetricCollector: @escaping (ServiceProvider) async throws -> THealthCheckMetricCollector
    ) throws -> ServerApp {
        return try wireUp(singleton: { sp in
            return try await healthCheckMetricCollector(sp) as HealthCheckMetricCollector;
        });
    }
}