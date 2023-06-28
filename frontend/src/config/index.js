import ERC721Abi from './ERC721Abi.json';

// real net, avalanche-c chain
var config = {
    ERC721Abi: ERC721Abi,
    ERC721Address: "0x31DF36303792D2AC3d4b215f3A10b140f9bE90FD", // GreenTextNFT contract address

    //mainNetUrl: "https://mainnet.infura.io/v3/", //Ethereum mainnet RPC
    //chainId: 1, // Ethereum mainnet chain id

    mainNetUrl: "https://data-seed-prebsc-1-s1.binance.org:8545", //bsc testnet RPC
    chainId: 97, // bsc testnet chain id,

    baseTokenURI: "https://95.217.33.149/green-text-nft/",
};

export default config; 
