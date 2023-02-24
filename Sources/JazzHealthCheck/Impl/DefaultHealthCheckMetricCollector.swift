import OSInfo

internal final class DefaultHealthCheckMetricCollector: HealthCheckMetricCollector {
    public final func run() async -> [String:String] {
        return [
            "OSName": OS.current.name,
            "OSVersion": OS.current.displayVersion
        ];
    }
}