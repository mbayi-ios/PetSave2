import Foundation

@testable import PetSave

struct APIManagerMock: APIManagerProtocol {
  func perform(_ request: RequestProtocol, authToken: String) async throws -> Data {
    return try Data(contentsOf: URL(fileURLWithPath: request.path), options: .mappedIfSafe)
  }

  func requestToken() async throws -> Data {
    Data(AccessTokenTestHelper.generateValidToken().utf8)
  }
}
