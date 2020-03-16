import UIKit
class UnbondViewController: UIViewController {
    @IBOutlet weak var tendermint_url: UITextField!
    @IBOutlet weak var network_id: UITextField!
    @IBOutlet weak var to_transfer_address: UITextField!
    @IBOutlet weak var nonce: UITextField!
    @IBOutlet weak var coin: UITextField!
    @IBOutlet weak var encoded_tx: UITextView!
    @IBOutlet weak var log: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func click_close(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    @IBAction func click_unbond(_ sender: Any) {
        let user_network_id =  UInt8( network_id.text!, radix: 16)!
        var tx_length: UInt32 = 2000
        let tx = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(tx_length))
        let fetched_nonce = get_nonce_user(tendermint_url.text!, global_staking_address[0])
        nonce.text = String(fetched_nonce)
        cro_unbond(user_network_id,UInt64(nonce.text!)! , global_staking_address[0], to_transfer_address.text, UInt64(coin.text!)!, tx, &tx_length);
        cro_broadcast(tendermint_url.text!, tx, tx_length);
        let data = Data.init(bytes: tx, count: Int(tx_length))
        encoded_tx.text = data.hexEncodedString()
        log.text = String(format: "encoded %d bytes", data.count)
        tx.deallocate()
    }
}
