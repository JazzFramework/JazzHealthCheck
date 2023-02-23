import JazzCodec;

internal final class HealthCheckConfigV1JsonCodec: JsonCodec<HealthCheckConfig> {
    internal static let supportedMediaType: MediaType =
        MediaType(
            withType: "application",
            withSubtype: "json",
            withParameters: [
                "structure": "jazz.healthcheckconfig",
                "version": "1"
            ]
        );

    public override func getSupportedMediaType() -> MediaType {
        return HealthCheckConfigV1JsonCodec.supportedMediaType;
    }

    public override func encodeJson(data: HealthCheckConfig) async -> JsonObject {
        return JsonObjectBuilder().build();
    }

    public override func decodeJson(data: JsonObject) async -> HealthCheckConfig? {
        let route: JsonProperty = data["route"] as? JsonProperty ?? JsonProperty.Empty;

        if route.getString() != "" {
            return HealthCheckConfig(route: route.getString());
        }

        return nil;
    }
}