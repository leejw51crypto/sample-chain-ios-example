import UIKit

class DepositViewController: UIViewController {
    @IBOutlet weak var tendermint_url: UITextField!
    @IBOutlet weak var network_id: UITextField!
    @IBOutlet weak var to_address: UITextField!
    @IBOutlet weak var tx_id: UITextField!
    @IBOutlet weak var tx_index: UITextField!
    @IBOutlet weak var coin: UITextField!
    @IBOutlet weak var encoded: UITextView!
    @IBOutlet weak var log: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func click_deposit(_ sender: Any) {
        print("deposit")
        var buffer_length: UInt32 = 2000
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(buffer_length))
        var enc_length: UInt32 = 2000
        let enc = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(enc_length))
        let my_network_id =  UInt8( network_id.text!, radix: 16)!
        let from_addr = global_transfer_address[0]
        let addr_from_string = get_address_user(from_addr)
        var tx:Optional<OpaquePointer> = Optional.none
        cro_create_tx_deposit(&tx, my_network_id, to_address.text!)
        cro_tx_add_txin_deposit(tx, tx_id.text!,  UInt16(tx_index.text!)!, addr_from_string, UInt64(coin.text!)! )
        cro_tx_sign_txin_deposit(from_addr, tx, 0)
        cro_tx_complete_signing_deposit(tx, buffer, &buffer_length)
        cro_encrypt(tendermint_url.text!, buffer, buffer_length, enc, &enc_length);
        cro_broadcast(tendermint_url.text!, enc, enc_length);
        let data = Data.init(bytes: enc, count: Int(enc_length))
        encoded.text = data.hexEncodedString()
        log.text = String(format: "encoded %d bytes", data.count)
        buffer.deallocate()
        enc.deallocate()
        cro_destroy_tx_deposit(tx)
    }
    
    @IBAction func click_close(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
        
    }
    
}
