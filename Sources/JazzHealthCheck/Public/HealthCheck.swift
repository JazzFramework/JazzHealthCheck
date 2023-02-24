public final class HealthCheck {
    private final let processorResults: [String:HealthCheckProcessorResult];
    private final let metrics: [String:String];
    private final let status: HealthCheckStatus;

    internal init(processorResults: [String:HealthCheckProcessorResult], metrics: [String:String]) {
        self.processorResults = processorResults;
        self.metrics = metrics;

        var status: HealthCheckStatus = .healthy;

        for (_, processorResult) in processorResults {
            let processorStatus: HealthCheckStatus = processorResult.getStatus();

            if (processorStatus == .warning && status == .healthy) {
                status = .warning;
            } else if (processorStatus == .unhealthy) {
                status = .unhealthy;
            }
        }

        self.status = status;
    }

    public final func getStatus() -> HealthCheckStatus { status }
    public final func getProcessorResults() -> [String:HealthCheckProcessorResult] { processorResults }
    public final func getMetrics() -> [String:String] { metrics }
}