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
        HealthCheck(
            processorResults: await getProcessorResults(),
            metrics: await getMetrics()
        )
    }

    private final func getProcessorResults() async -> [String:HealthCheckProcessorResult] {
        var processorResults: [String:HealthCheckProcessorResult] = [:];

        for healthCheckProcessor in healthCheckProcessors {
            let processorName: String = String(describing: healthCheckProcessor);
            let processorResult: HealthCheckProcessorResult = await healthCheckProcessor.run();

            processorResults[processorName] = processorResult;
        }

        return processorResults;
    }

    private final func getMetrics() async -> [String:String] {
        var metrics: [String:String] = [:];

        for healthCheckMetricCollector in healthCheckMetricCollectors {
            let collectorMetrics: [String:String] = await healthCheckMetricCollector.run();

            for (key, value) in collectorMetrics {
                metrics[key] = value;
            }
        }

        return metrics;
    }
}