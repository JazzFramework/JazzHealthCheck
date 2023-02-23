public final class HealthCheck {
    private final let data: [String:(HealthCheckStatus, String)];
    private final let metrics: [String:String];

    private var statusCache: HealthCheckStatus? = nil;

    internal init(data: [String:(HealthCheckStatus, String)], metrics: [String:String]) {
        self.data = data;
        self.metrics = metrics;
    }

    public final func getStatus() -> HealthCheckStatus {
        if let statusCache = statusCache {
            return statusCache;
        }

        var status: HealthCheckStatus = .healthy;

        for (_, processorValue) in data {
            let processorStatus: HealthCheckStatus = processorValue.0;

            if (processorStatus == .warning && status == .healthy) {
                status = .warning;
            } else if (processorStatus == .unhealthy) {
                status = .unhealthy;
            }
        }

        statusCache = status;

        return status;
    }

    public final func getData() -> [String:(HealthCheckStatus, String)] {
        return data;
    }

    public final func getMetrics() -> [String:String] {
        return metrics;
    }
}