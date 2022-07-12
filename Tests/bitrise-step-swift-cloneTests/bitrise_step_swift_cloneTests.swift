import XCTest
@testable import bitrise_step_swift_clone

let expectedRepoURL = "http://bitrise.io"
let expectedCloneDestination = "_tmp"
let expectedCheckoutBranch = "test_branch"
let expectedCloneDepth = "1"

final class BuildGitCommandTests: XCTestCase {
    func testFullyPopulatedConfig() {
        let config = Config(
            repoURL: expectedRepoURL,
            cloneDest: expectedCloneDestination,
            checkoutBranch: expectedCheckoutBranch,
            cloneDepth: expectedCloneDepth
        )
        let gitCommand = buildGitCommand(config: config)
        XCTAssertEqual(gitCommand, "clone \(expectedRepoURL) -v --branch \(expectedCheckoutBranch) --depth \(expectedCloneDepth)")
    }
    
    func testMissingCloneDepth() {
        let config = Config(
            repoURL: expectedRepoURL,
            cloneDest: expectedCloneDestination,
            checkoutBranch: expectedCheckoutBranch,
            cloneDepth: nil
        )
        let gitCommand = buildGitCommand(config: config)
        XCTAssertEqual(gitCommand, "clone \(expectedRepoURL) -v --branch \(expectedCheckoutBranch)")
    }
    
    func testMissingCheckoutBranch() {
        let config = Config(
            repoURL: expectedRepoURL,
            cloneDest: expectedCloneDestination,
            checkoutBranch: nil,
            cloneDepth: expectedCloneDepth
        )
        let gitCommand = buildGitCommand(config: config)
        XCTAssertEqual(gitCommand, "clone \(expectedRepoURL) -v --depth \(expectedCloneDepth)")
    }
    
    func testMissingCheckoutBranchAndCloneDepth() {
        let config = Config(
            repoURL: expectedRepoURL,
            cloneDest: expectedCloneDestination,
            checkoutBranch: nil,
            cloneDepth: nil
        )
        let gitCommand = buildGitCommand(config: config)
        XCTAssertEqual(gitCommand, "clone \(expectedRepoURL) -v")
    }
}

final class CreateClonePathTests: XCTestCase {
    func testCreateClonePathSuccess() {
        let path = createClonePath("_tmp")
        XCTAssertNotNil(path)
    }
}

final class ParseConfigTests: XCTestCase {
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
