import OSInfo

internal final class DefaultHealthCheckMetricCollector: HealthCheckMetricCollector {
    public final func run() async -> [String:String] {
        return [
            "OS": OS.current.name,
            "Version": OS.current.displayVersion
        ];
    }
}