var SmartPlacesProtocol = artifacts.require("SmartPlacesProtocol");
//var IterableMapping = artifacts.require("IterableMapping");

async function doDeploy(deployer, network, accounts, _oA, _mA) {
    //await deployer.deploy(IterableMapping);
    //await deployer.link(IterableMapping, Psychodoge);
    await deployer.deploy(SmartPlacesProtocol, _oA, _mA);
}


module.exports = (deployer, network, accounts) => {
    deployer.then(async () => {
        const ownerAddr = "0xC2EbaE7C61cd3E78D8BAf27a2ccab2cE7C7cE422";
        const marketingAddr = "0x75a7ABaD7Da25Be7Ac422CCec606a8773fD2797B";
        await doDeploy(deployer, network, accounts, ownerAddr, marketingAddr);
    })
    .then(() => console.log("SmartPlacesProtocol contract deployed at address: " + SmartPlacesProtocol.address));
};

/*module.exports = function(deployer, network, accounts) {
    //console.log(accounts);
    const presalerAddr = "0x13E52248481ef25657cb21Af36e7Ec8f20fF5A22";
    const presalerContractAddr = "0xec02fD8E36305c41AB1e481706Ab0C321208224f";
    //deployer.deploy(Psychodoge, presalerAddr, presalerContractAddr)
    deployer.deploy(IterableMapping);
    deployer.link(IterableMapping, Contract);
    deployer.deploy(Psychodoge)
    // Console log the address:
    .then(() => console.log("contract deployed at address: " + contract.address));
    //.then(() => console.log(accounts[0]));
};*/
