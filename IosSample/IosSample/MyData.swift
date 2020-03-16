import Foundation
class MyData : Codable {
    // for rpc-json
    var tendermint: String? = "ws://localhost:26657/websocket"
    var name: String? = "a"
    var passphras: String? = ""
    var enckey: String? = ""
    var mnemonics: String? = ""
    // low level
    var mnemonics_lowlevel: String? = ""
}
