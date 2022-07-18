import Foundation

struct Config {
    let repositoryURL: String
    let cloneDestination: String
    let checkoutBranch: String?
    let cloneDepth: String?

    enum EnvKey: String {
        case repositoryURL = "repository_url"
        case cloneDestination = "clone_destination"
        case checkoutBranch = "checkout_branch"
        case cloneDepth = "clone_depth"
    }

    init(
        repositoryURL: String,
        cloneDestination: String,
        checkoutBranch: String? = nil,
        cloneDepth: String? = nil
    ) {
        self.repositoryURL = repositoryURL
        self.cloneDestination = cloneDestination
        self.checkoutBranch = checkoutBranch
        self.cloneDepth = cloneDepth
    }

    init(environment: [String: String] = ProcessInfo.processInfo.environment) throws {
        guard let repositoryURL = environment[EnvKey.repositoryURL.rawValue] else {
            throw ParsingError.repositoryURLNotProvided
        }
        guard let cloneDestination = environment[EnvKey.cloneDestination.rawValue] else {
            throw ParsingError.cloneDestinationNotProvided
        }

        self.repositoryURL = repositoryURL
        self.cloneDestination = cloneDestination
        self.checkoutBranch = environment[EnvKey.checkoutBranch.rawValue]
        self.cloneDepth = environment[EnvKey.cloneDepth.rawValue]
    }

    enum ParsingError: Error {
        case repositoryURLNotProvided
        case cloneDestinationNotProvided
    }
}
