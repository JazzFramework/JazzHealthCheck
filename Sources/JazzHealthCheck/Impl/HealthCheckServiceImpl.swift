internal final class HealthCheckServiceImpl: HealthCheckService {
    private final let healthCheckProcessors: [HealthCheckProcessor];
    private final let healthCheckMetricCollectors: [HealthCheckMetricCollector];

    internal init(
        healthCheckProcessors: [HealthCheckProcessor],
        healthCheckMetricCollectors: [HealthCheckMetricCollector]
    ) {
        self.healthCheckProcessors = healthCheckProcessors;
        self.healthCheckMetricCollectors = healthCheckMetricCollectors;
    }

    public final func getHealthCheck() async -> HealthCheck {
        var processorResults: [String:HealthCheckProcessorResult] = [:];

        for healthCheckProcessor in healthCheckProcessors {
            processorResults[String(describing: healthCheckProcessor)] = await healthCheckProcessor.run();
        }

        var metrics: [String:String] = [:];

        for healthCheckMetricCollector in healthCheckMetricCollectors {
            let collectorMetrics = await healthCheckMetricCollector.run();

            for (key, value) in collectorMetrics {
                metrics[key] = value;
            }
        }

        return HealthCheck(processorResults: processorResults, metrics: metrics);
    }
}