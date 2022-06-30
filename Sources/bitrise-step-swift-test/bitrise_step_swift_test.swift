import GitKit

@main
public struct bitrise_step_swift_test {
    public static func main() {
        let git = Git(path: "$PWD")
        do {
            let output = try git.run(.cmd(.status))            
            print(output)
        } catch {
            print(error)
        }
    }
}
