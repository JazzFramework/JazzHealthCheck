import XCTest;

import JazzCodec;

@testable import JazzHealthCheck


internal final class TestResultStream: ResultStream {
    private var result: String = "";

    public final func write(_ data: [UInt8]) {}

    public final func write(_ data: String) {
        result = result + data;
    }

    public final func write(_ data: InputStream) {}

    public final func write(_ data: UnsafeMutablePointer<UInt8>, maxLength: Int) {}

    public final func get() -> String {
        return result;
    }
}

final class HealthCheckV1JsonCodecTests: XCTestCase {
    func testExample() async {
        let subject: HealthCheckV1JsonCodec = HealthCheckV1JsonCodec();
        let healthCheck: HealthCheck = HealthCheck(
            processorResults: ["asdf":HealthCheckProcessorResult(status: .unhealthy, message: "asdf")],
            metrics: ["asdf":"asdf","qwerty":"qwerty"]
        );
        let writer: JsonObjectWriter = JsonObjectWriter();
        let fakeResultStream: TestResultStream = TestResultStream();

        let result: JsonObject = await subject.encodeJson(data: healthCheck);

        writer.populate(result, into: fakeResultStream);

        XCTAssertEqual("{\"metrics\":{},\"status\":\"healthy\",\"data\":{}}", fakeResultStream.get());
    }
}
