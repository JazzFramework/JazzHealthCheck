public final class HealthCheckProcessorResult {
    private final let status: HealthCheckStatus;
    private final let message: String;

    public init(status: HealthCheckStatus = .healthy, message: String = "") {
        self.status = status;
        self.message = message;
    }

    public final func getStatus() -> HealthCheckStatus { status }
    public final func getMessage() -> String { message }
}