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
        var data: [String:(HealthCheckStatus,String)] = [:];

        for healthCheckProcessor in healthCheckProcessors {
            let processorName = String(describing: healthCheckProcessor);

            let healthCheckProcessorResult: HealthCheckProcessorResult = await healthCheckProcessor.run();

            data[processorName] = (healthCheckProcessorResult.getStatus(), healthCheckProcessorResult.getMessage());
        }

        var metrics: [String:String] = [:];

        for healthCheckMetricCollector in healthCheckMetricCollectors {
            let collectorMetrics = await healthCheckMetricCollector.run();

            for (key, value) in collectorMetrics {
                metrics[key] = value;
            }
        }

        return HealthCheck(data: data, metrics: metrics);
    }
}