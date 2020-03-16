import UIKit

var global_hdwallet:Optional<OpaquePointer> = Optional.none
var global_staking_address = [Optional<OpaquePointer>]()
var global_transfer_address=[Optional<OpaquePointer>]()

class TxViewController: UIViewController {
    
    @IBOutlet weak var staking0: UITextField!
    @IBOutlet weak var staking1: UITextField!
    @IBOutlet weak var transfer0: UITextField!
    @IBOutlet weak var transfer1: UITextField!
    @IBOutlet weak var wallet_mnemonics: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try ViewController.load_data()
            wallet_mnemonics.text = try ViewController.my_data.mnemonics_lowlevel
            do_restore()
        }
        catch {
            print("tx viewcontroller start error")
        }
    }
    
    @IBAction func click_close(_ sender: Any) {
        self.dismiss(animated:true)
    }
    
    func do_restore()
    {
        cro_restore_hdwallet(wallet_mnemonics.text, &global_hdwallet);
        for index in 0...1
        {
            var tmp:Optional<OpaquePointer> = Optional.none
            cro_create_staking_address(global_hdwallet, Devnet, &tmp, UInt32(index))
            global_staking_address.append(tmp)
            tmp=Optional.none
            cro_create_transfer_address(global_hdwallet, Devnet, &tmp, UInt32(index))
            global_transfer_address.append(tmp)
        }
        staking0.text = String(cString: get_address_user(global_staking_address[0]))
        staking1.text = String(cString: get_address_user(global_staking_address[1]))
        transfer0.text = String(cString: get_address_user(global_transfer_address[0]))
        transfer1.text = String(cString: get_address_user(global_transfer_address[1]))
        do {
            ViewController.my_data.mnemonics_lowlevel = wallet_mnemonics.text
            try ViewController.save()
        }
        catch {
            print("restore hdwallet error")
        }
    }
    @IBAction func click_restore_hdwallet(_ sender: Any) {
        do_restore()
    }
}
