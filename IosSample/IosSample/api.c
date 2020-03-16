#include <stdio.h>
#include "chain-core.h"

#include "chain.h"

const  char* get_address_user(CroAddressPtr addr)
{
    static char tmp[300];
    cro_get_printed_address(addr, tmp, sizeof(tmp));
    return tmp;
}

// tendermint_url: "ws://localhost:26657/websocket"
uint64_t get_nonce_user(const char* tendermint_url, CroAddressPtr staking)
{
    CroStakedState state;
    cro_get_staked_state(staking, tendermint_url, &state);
    return state.nonce;
}
	
void withdraw_by_address(const char* tendermint_url,unsigned char network_id,CroAddressPtr staking, const char* to_addr, const char* viewkey, unsigned char* buf, unsigned int* buf_len)
{
    const char* viewkeys[1]={viewkey};
    char tx[1000];
    uint32_t tx_length=sizeof(tx);
    cro_withdraw(tendermint_url, network_id, staking, to_addr, viewkeys, 1,  buf, buf_len);
}


