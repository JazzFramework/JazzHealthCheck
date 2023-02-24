import OSInfo;

internal final class DefaultHealthCheckMetricCollector: HealthCheckMetricCollector {
    public final func run() async -> [String:String] {
        [
            Constants.OS_NAME_METRIC_KEY: OS.current.name,
            Constants.OS_VERSION_METRIC_KEY: OS.current.displayVersion
        ]
    }
}