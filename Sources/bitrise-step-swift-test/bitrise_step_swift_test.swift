import Foundation
import GitKit

@main
public struct bitrise_step_swift_test {
    public static func main() {
        let env = ProcessInfo.processInfo.environment
        let repoURL = env["REPOSITORY_URL"]
        print("HEYO: \(repoURL ?? "NOEN")")
        
        let git = Git(path: "$PWD")
        do {
            let output = try git.run(.cmd(.status))            
            print(output)
        } catch {
            print(error)
        }
    }
}
