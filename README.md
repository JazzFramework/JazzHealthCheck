# JazzHealthCheck

A Jazz Framework module that'll add a healthcheck http endpoint.

## Using

### Importing the HealthCheck Logic

Add the healthcheck initlaizer to your Jazz Server app:

> JazzHealthCheck.HealthCheckInitializer

This will injection all of the healthcheck logic into DI, and spin up the controller that can be accessed by making a get request to */admin/v1/healthcheck*. You'll need to make sure you include the media type *application/json; structure=jazz.healthcheck; version=1* as an accept header in order to recieve the expected json structure.


### Implementing Custom Health Checks

You can then define your services health check logic by implementing healthcheck processors like this:

```
import JazzHealthCheck;

internal final class CustomHealthCheckProcessor: HealthCheckProcessor {
    public final func run() async -> HealthCheckProcessorResult {
        if dependancyServiceOrSystemIsDown {
            return HealthCheckProcessorResult(
                status: .unhealthy,
                message: "The service won't behave as expected because the dependancy service isn't accessible"
            );
        }

        return HealthCheckProcessorResult(status: .healthy);
    }
}
```

Any custom healthcheck providers need to be registred in dependancy injection using an initailizer like this:

```
import JazzConfiguration;
import JazzHealthCheck;
import JazzServer;

internal final class CustomHealthCheckInitializer: ServerInitializer {
    public override final func initialize(for app: ServerApp, with configurationBuilder: ConfigurationBuilder) throws {
        _ = try app
            .wireUp(healthCheckProcessor: { _ in return CustomHealthCheckProcessor(); });
    }
}
```

### Implementing Additional Returned Metrics

In addition to reporting if the service is healthy, the health checks can also return additional metrics that describe the service's current state.

You can add this data to your healthcheck endpoint by implementing custom HealthCheckMetricCollectors.

```
import JazzHealthCheck;

internal final class CustomHealthCheckMetricCollector: HealthCheckMetricCollector {
    public final func run() async -> [String:String] {
        return [
            "ServiceLogLevel": "GetCurrentLogLevel",
            "ServiceHeapMemoryUsage": "CurrentHeapMemoryUsage"
        ];
    }
}
```

These metric collectors can then be included in DI using an initializer so they'll run with the health check logic.

```
import JazzConfiguration;
import JazzHealthCheck;
import JazzServer;

internal final class CustomHealthCheckInitializer: ServerInitializer {
    public override final func initialize(for app: ServerApp, with configurationBuilder: ConfigurationBuilder) throws {
        _ = try app
            .wireUp(healthCheckMetricCollector: { _ in return CustomHealthCheckMetricCollector(); });
    }
}
```