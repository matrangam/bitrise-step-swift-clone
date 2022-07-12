import Foundation
import GitKit
import TSCBasic

@main
public struct bitrise_step_swift_test {
    public static func main() {
        guard let config = parseConfig() else {
            print("Unable to parse config")
            exit(1)
        }
        guard let clonePath = createClonePath(config.cloneDest) else {
            print("Unable to create clone path")
            exit(1)
        }

        let git = Git(path: clonePath.pathString)
        let gitCommand = buildGitCommand(config: config)
        
        do {
            let output = try git.run(.raw(gitCommand))
            print(output)
        } catch {
            print(error)
            exit(1)
        }
        exit(0)
    }
}

func buildGitCommand(config: Config) -> String {
    var commands: [String] = ["clone", config.repoURL, "-v"]
    if let checkoutBranch = config.checkoutBranch {
        commands.append("--branch \(checkoutBranch)")
    }
    if let cloneDepth = config.cloneDepth {
        commands.append("--depth \(cloneDepth)")
    }

    return commands.joined(separator: " ")
}

func createClonePath(_ cloneDest: String) -> AbsolutePath? {
    let currentPath = AbsolutePath(FileManager.default.currentDirectoryPath)
    let clonePath = currentPath.appending(component: cloneDest)
    do {
        try localFileSystem.createDirectory(clonePath)
    } catch {
        print("Clone path not created: \(error)")
        return nil
    }
    return clonePath
}

func parseConfig() -> Config? {
    let env = ProcessInfo.processInfo.environment
    guard let repoURL = env["repository_url"] else {
        print("Missing required config repository_url")
        return nil
    }
    guard let cloneDest = env["clone_destination"] else {
        print("Missing required config clone_destination")
        return nil
    }
    let checkoutBranch = env["checkout_branch"]
    let cloneDepth = env["clone_depth"]
    
    return Config(
        repoURL: repoURL,
        cloneDest: cloneDest,
        checkoutBranch: checkoutBranch,
        cloneDepth: cloneDepth
    )
}

struct Config {
    let repoURL: String
    let cloneDest: String
    let checkoutBranch: String?
    let cloneDepth: String?
}
