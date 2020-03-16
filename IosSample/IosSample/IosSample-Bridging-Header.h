#include "chain-core.h"
#include "chain.h"
// json rpc
void restore_wallet(const char* tendermint_url, const char* storage,  const char* name, const char* passphrase, const char* enckey, const char* mnemonics);
void sync_wallet(const char* tendermint_url, const char* storage,  const char* name, const char* passphrase, const char* enckey, const char* mnemonics);
float get_rate();
void stop_sync();
// lowlevel
uint64_t get_nonce_user(const char* tendermint_url, CroAddressPtr staking);
void test_number(char* buf, int* number);
void withdraw_by_address(const char* tendermint_url,unsigned char network_id,CroAddressPtr staking, const char* to_addr, const char* viewkey, unsigned char* buf, unsigned int* buf_len);
const  char* get_address_user(CroAddressPtr addr);
