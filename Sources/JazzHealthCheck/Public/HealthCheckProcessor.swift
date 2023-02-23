public protocol HealthCheckProcessor {
    func run() async -> HealthCheckProcessorResult;
}