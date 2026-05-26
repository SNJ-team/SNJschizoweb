import SwiftJava
import PaperAPI

import Vapor

public func routes(_ app: Application) throws {
    app.get { req async -> Response in
        let html = """
        <!DOCTYPE html>
        <html>
        <body style="background:black;
        color:lime;
        font-family:monospace;
        font-size:44px;
        ">

        <pre id="stats">Loading...</pre>

        <script>
        async function updateStats() {
            const response = await fetch('/stats')
            const text = await response.text()

            document.getElementById('stats').textContent = text
        }

        updateStats()
        setInterval(updateStats, 500)
        </script>

        </body>
        </html>
        """

        return Response(
            status: .ok,
            headers: ["Content-Type": "text/html"],
            body: .init(string: html)
        )
    }
    
    app.get("stats") { req async -> String in
        do {
            let runtimeClass = try JavaClass<Runtime>()
            
            guard let runtime = runtimeClass.getRuntime() else {
                return "Failed to get Runtime instance"
            }
            
            let totalMemory = runtime.totalMemory()
            let freeMemory = runtime.freeMemory()
            let usedMemory = totalMemory - freeMemory
            
            return """
            Server Stats:
            Memory: \(usedMemory / 1_048_576)MB / \(totalMemory / 1_048_576)MB
            """
        } catch {
            return "Failed to get stats: \(error)"
        }
    }
}
