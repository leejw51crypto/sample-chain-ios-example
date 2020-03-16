import UIKit

class TransferViewController: UIViewController {    
    @IBOutlet weak var tendermint_url: UITextField!
    @IBOutlet weak var network_id: UITextField!
    @IBOutlet weak var txid: UITextField!
    @IBOutlet weak var tx_index: UITextField!
    @IBOutlet weak var txin_address: UITextField!
    @IBOutlet weak var txin_amount: UITextField!
    @IBOutlet weak var txout_address: UITextField!
    @IBOutlet weak var txout_coin: UITextField!
    @IBOutlet weak var viewkey0: UITextField!
    @IBOutlet weak var viewkey1: UITextField!
    @IBOutlet weak var encoded: UITextView!
    @IBOutlet weak var log: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func click_transfer(_ sender: Any) {
        var buffer_length: UInt32 = 2000
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(buffer_length))
        var enc_length: UInt32 = 2000
        let enc = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(enc_length))
        let my_network_id =  UInt8( network_id.text!, radix: 16)!
        
        var tx:Optional<OpaquePointer> = Optional.none
        cro_create_tx(&tx, my_network_id)
        cro_tx_add_txin(tx, txid.text!, UInt16(tx_index.text!)!, txin_address.text!,UInt64(txin_amount.text!)!);
        cro_tx_add_txout(tx, txout_address.text!, UInt64(txout_coin.text!)!);
        cro_tx_add_viewkey(tx, viewkey0.text!);
        cro_tx_add_viewkey(tx, viewkey1.text!);
        cro_tx_sign_txin(global_transfer_address[0], tx, 0);
        cro_tx_complete_signing(tx, buffer, &buffer_length);
        cro_encrypt(tendermint_url.text!, buffer, buffer_length, enc, &enc_length);
        cro_broadcast(tendermint_url.text!, enc, enc_length);
        cro_destroy_tx(tx);
        let data = Data.init(bytes: buffer, count: Int(buffer_length))
        encoded.text = data.hexEncodedString()
        log.text = String(format: "encoded %d bytes", data.count)
        buffer.deallocate()
        enc.deallocate()
        cro_destroy_tx(tx!)
        
    }
    @IBAction func click_close(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
}
