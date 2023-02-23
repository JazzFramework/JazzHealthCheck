public protocol HealthCheckMetricCollector {
    func run() async -> [String:String];
}