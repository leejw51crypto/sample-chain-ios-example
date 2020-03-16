import UIKit
class WithdrawViewController: UIViewController {
    @IBOutlet weak var tendermint_url: UITextField!
    @IBOutlet weak var network_id: UITextField!
    @IBOutlet weak var to_address: UITextField!
    @IBOutlet weak var viewkey: UITextField!
    @IBOutlet weak var encoded: UITextView!
    @IBOutlet weak var log: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func click_withdraw(_ sender: Any) {
        var tx_length: UInt32 = 2000
        let tx = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(tx_length))
        var enc_length: UInt32 = 2000
        let enc = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(enc_length))
        let my_network_id =  UInt8( network_id.text!, radix: 16)!
        withdraw_by_address(tendermint_url.text!, my_network_id, global_staking_address[0], to_address.text!, viewkey.text!, tx, &tx_length)
        cro_encrypt(tendermint_url.text!, tx, tx_length, enc, &enc_length);
        cro_broadcast(tendermint_url.text!, enc, enc_length);
        let data = Data.init(bytes: enc, count: Int(enc_length))
        encoded.text = data.hexEncodedString()
        log.text = String(format: "encoded %d bytes", data.count)
        tx.deallocate()
        enc.deallocate()
    }
    
    @IBAction func click_close(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
}
