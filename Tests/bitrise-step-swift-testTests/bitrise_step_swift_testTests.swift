import XCTest
@testable import bitrise_step_swift_test

final class CreateClonePathTests: XCTestCase {
    func testCreateClonePathSuccess() {
        let path = createClonePath("_tmp")
        XCTAssertNotNil(path)
    }
}

final class ParseConfigTests: XCTestCase {
    let expectedRepoURL = "http://bitrise.io"
    let expectedCloneDestination = "_tmp"
    let expectedCheckoutBranch = "test_branch"
    let expectedCloneDepth = "1"
    
    override func tearDown() {
        unsetenv("repository_url")
        unsetenv("clone_destination")
        unsetenv("checkout_branch")
        unsetenv("clone_depth")
    }
    

    func testParseConfigSuccess() {
        setenv("repository_url", expectedRepoURL, 1)
        setenv("clone_destination", expectedCloneDestination, 1)
        setenv("checkout_branch", expectedCheckoutBranch, 1)
        setenv("clone_depth", expectedCloneDepth, 1)
        
        let config = parseConfig()
        XCTAssertNotNil(config)
        XCTAssertEqual(config?.repoURL, expectedRepoURL)
        XCTAssertEqual(config?.cloneDest, expectedCloneDestination)
        XCTAssertEqual(config?.checkoutBranch, expectedCheckoutBranch)
        XCTAssertEqual(config?.cloneDepth, expectedCloneDepth)
    }

    func testParseConfigMissingRepoURL() {
        setenv("clone_destination", expectedCloneDestination, 1)
        setenv("checkout_branch", expectedCheckoutBranch, 1)
        setenv("clone_depth", expectedCloneDepth, 1)

        let config = parseConfig()
        XCTAssertNil(config)
    }
    
    func testParseConfigMissingCheckoutDestination() {
        setenv("repository_url", expectedRepoURL, 1)
        setenv("checkout_branch", expectedCheckoutBranch, 1)
        setenv("clone_depth", expectedCloneDepth, 1)

        let config = parseConfig()
        XCTAssertNil(config)
    }
}
