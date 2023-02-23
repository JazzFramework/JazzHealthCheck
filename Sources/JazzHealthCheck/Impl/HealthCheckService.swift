internal protocol HealthCheckService {
    func getHealthCheck() async -> HealthCheck;
}