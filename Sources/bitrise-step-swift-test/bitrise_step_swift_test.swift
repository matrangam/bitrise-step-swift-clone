import GitKit

@main
public struct bitrise_step_swift_test {
    public private(set) var text = "Hello, World!"

    public static func main() {
        print(bitrise_step_swift_test().text)
        
        let git = Git(path: "$PWD")
        do {
            let output = try git.run(.cmd(.status))            
            print(output)
        } catch {
            print(error)
        }
    }
}
