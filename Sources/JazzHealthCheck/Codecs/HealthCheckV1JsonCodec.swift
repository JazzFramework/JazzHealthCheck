import JazzCodec;

internal final class HealthCheckV1JsonCodec: JsonCodec<HealthCheck> {
    private static let supportedMediaType: MediaType =
        MediaType(
            withType: "application",
            withSubtype: "json",
            withParameters: [
                "structure": "jazz.healthcheck",
                "version": "1"
            ]
        );

    public override func getSupportedMediaType() -> MediaType {
        return HealthCheckV1JsonCodec.supportedMediaType;
    }

    public override func encodeJson(data: HealthCheck) async -> JsonObject {
        return JsonObjectBuilder()
            .with("status", property: JsonProperty(withData: data.getStatus().rawValue))
            .with("data", dictionary: data.getProcessorResults(), logic: { value in
                return JsonObjectBuilder()
                    .with("status", property: JsonProperty(withData: value.getStatus().rawValue))
                    .with("message", property: JsonProperty(withData: value.getMessage()))
                    .build();
            })
            .with("metrics", dictionary: data.getMetrics(), logic: { value in
                JsonProperty(withData: value)
            })
            .build();
    }

    public override func decodeJson(data: JsonObject) async -> HealthCheck? {
        var processorsData: [String:HealthCheckProcessorResult] = [:];

        if let processorsInfo = data["data"] as? JsonObject {
            for key in processorsInfo.getKeys() {
                if let processorInfo = processorsInfo[key] as? JsonObject {
                    let status: JsonProperty = processorInfo["status"] as? JsonProperty ?? JsonProperty.Empty;
                    let message: JsonProperty = processorInfo["message"] as? JsonProperty ?? JsonProperty.Empty;

                    processorsData[key] = HealthCheckProcessorResult(
                        status: HealthCheckStatus(rawValue: status.getString()) ?? .unhealthy,
                        message: message.getString()
                    );
                }
            }
        }

        var metricsData: [String:String] = [:];

        if let metricsInfo = data["metrics"] as? JsonObject {
            for key in metricsInfo.getKeys() {
                let value: JsonProperty = metricsInfo[key] as? JsonProperty ?? JsonProperty.Empty;

                metricsData[key] = value.getString();
            }
        }

        return HealthCheck(processorResults: processorsData, metrics: metricsData);
    }
}