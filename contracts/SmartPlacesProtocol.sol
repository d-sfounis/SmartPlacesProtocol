// SPDX-License-Identifier: GPL-3.0-only
// Copyleft: The Smart Places Protocol development team!

pragma solidity ^0.8.7;

/***
 *     _____                      _    ______ _                      ______          _                  _ 
 *    /  ___|                    | |   | ___ \ |                     | ___ \        | |                | |
 *    \ `--. _ __ ___   __ _ _ __| |_  | |_/ / | __ _  ___ ___  ___  | |_/ / __ ___ | |_ ___   ___ ___ | |
 *     `--. \ '_ ` _ \ / _` | '__| __| |  __/| |/ _` |/ __/ _ \/ __| |  __/ '__/ _ \| __/ _ \ / __/ _ \| |
 *    /\__/ / | | | | | (_| | |  | |_  | |   | | (_| | (_|  __/\__ \ | |  | | | (_) | || (_) | (_| (_) | |
 *    \____/|_| |_| |_|\__,_|_|   \__| \_|   |_|\__,_|\___\___||___/ \_|  |_|  \___/ \__\___/ \___\___/|_|
 *                                                                                                        
 *  https://smartplacesprotocol.io
 *  https://t.me //TODO add telegram!
 */
 
/**
 * Our lib imports. 
 * Mostly OpenZeppelin stuff...
 */
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";



interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint256) external view returns (address pair);
    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address owner) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);
    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);

    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint256);
    function price1CumulativeLast() external view returns (uint256);
    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);
    function burn(address to) external returns (uint256 amount0, uint256 amount1);
    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;
    function sync() external;
    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
    function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

/**
  * The main Smart Places Protocol contract! This is where the magic gets defined~
  */ 
contract SmartPlacesProtocol is Context, IERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;
    
    /* Required for calculating reflections per transfer, a-la-FLOKI */
    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;

    mapping(address => bool) private _isExcludedFromFee; //from paying tax when transferring
    mapping(address => bool) private _isExcluded; //from reflections
    address[] private _excluded; //LookUp Table (LUT) for iterating through excluded wallets. Remember, mappings aren't suitable for this.
    
    mapping(address=>bool) private _isExcludedFromTxLimit; //Adding this for the dxsale/unicrypt presale, the router needs to be exempt from max tx amount limit.
   
    string private _name = "Smart Places Protocol";
    string private _symbol = "SMARTEE";
    uint8 private _decimals = 9;

    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal = 1 * 10**9 * 10**_decimals; //1 billion, plus decimals
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;
    
    bool public antiSniping_failsafe = true;    //Acts as an emergency circuit breaker in case we need to abort the anti-sniping mechanism
    uint256 public antiSniping_blocks = 3;
    
    bool public salePenalizationEnabled = false; //Will double reflections (tax) when a user is selling our token

    uint256 public _taxFee = 1;     //Used to calculate reflections
    uint256 private _previousTaxFee = _taxFee;
    bool public shouldReflect = true;

    uint256 public _liquidityFee = 1;
    uint256 private _previousLiquidityFee = _liquidityFee;
    bool public shouldLiquidate = true;
    
    bool inSwapAndLiquify;
    bool public swapAndLiquifyEnabled = true;
    
    /* WORKSPACE 03 SEPT*/
    uint256 public _marketingFee = 1;
    uint256 private _previousMarketingFee = _marketingFee;
    address public _marketingWalletAddress; //Affixed and created dynamically by the smart contract at construction time.
    bool public shouldTakeMarketing = true;
    
    uint256 public _charityFee = 1;
    uint256 private _previousCharityFee = _charityFee;
    address public _charityAddress; //Dynamic, has a setter.
    bool public shouldTakeCharity = true;
    
    uint256 public _burnFee = 1;
    uint256 private _previousBurnFee = _burnFee;
    address public _burnAddress = 0x000000000000000000000000000000000000dEaD;
    bool public shouldBurn = true;
    
    uint256 private launchedAt; //Stores the block.height on which the token received its first pancake liquidity (first transfer towards the pancake pair)
    bool private manualLaunch = false;
    
    IUniswapV2Router02 public immutable uniswapV2Router;    //Pointers to the DEX Router (in our case, Pancake Router v2)
    address public immutable SmartPlacesUniswapV2Pair;      //and to our own DEX pair, for liquidity operations

    uint256 public _maxTxAmount = _tTotal.div(100); //1% of total supply
    uint256 private numTokensSellToAddToLiquidity = _maxTxAmount.div(10);   //0.1%
                                                                            //Should always be at ~1 order of magnitude less than _maxTxAmount.
    /* Feature request by Bjorn: The ability to turn off fees for user transfers and only tax certain kinds of txes. */                          
    bool public noFeesBetweenUsersEnabled = false;
    mapping(address => bool) private _shouldTakeFee;
    
    event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );
    event AntiSnipingFailsafeSetTo(bool toggle);

    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }
    
    /* TODO Checklist after deploying the SPP token, and preparation for a smooth presale.
     * 1. ExcludeFromFee(), ExcludeFromReward() and ExcludeFromTxLimit() on the presaler contract (dxSale or Unicrypt, or the launchpad)
     * 2. ExcludeFromTXLimit on the dev wallet, goddamnit 
     * 3. ExcludeFromReward() on the Dead address or towards whatever you're burning at. WARNING: If re-enabled, you'll need to run sync() on the pair address.
     * 3. Disable SwapAndLiquify, otherwise Liquidity injections (e.g. from the presaler contract to the Pancake pair) fail.
     *      If you want to control that, check the circular-liquidity-avoidance code in SwapAndLiquefy().
     * 4. Re-enable all this as soon as humanly possible, even though the anti-sniping mechanism can buy you some time.
     *      removeAllFee() and restoreAllFee() can help here, but consider keeping them private instead of public/external.
     */
    constructor(address param_addr) {
        _rOwned[_msgSender()] = _rTotal;

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); //PancakeSwap's V2 Router.
                                                                                                              //NOTE: You HAVE to use Pancake's V2 Router, otherwise taxOnTransfer don't work.
        //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3); //Pancakeswap V2 testnet
        //Create a new uniswap pair for this new token and set the local pair pointer
        SmartPlacesUniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());

        //Set the local router pointer
        uniswapV2Router = _uniswapV2Router;

        //Exclude owner and this contract from fee (tax)
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _marketingWalletAddress = param_addr;
        //setMultisigOwnership(opt_multiSig);
        
        _isExcluded[_burnAddress] = true;   //WORKSPACE
        _excluded.push(_burnAddress);

        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }
    
    //Added in SmartPlaces v0.2: This only called once, during the first ever liquidity injection transfer, and marks the block.height in which it happened.
    function launch() internal {
        launchedAt = block.number;
    }
    
    //and a linked getter to check whether SPP is launched or not.
    function launched() internal view returns (bool) {
        return launchedAt != 0;
    }
    
    //Added in SmartPlaces v0.2: This is a manual override for setting the launchedAt variable. Causes the first transfer of tokens to and from anyone to set the launchedAt variable.
    function manualLaunchOverride(bool toggle) public onlyOwner {
        manualLaunch = toggle;
    }
    
    function setAntiSnipeFailsafe(bool failsafe) public {
        antiSniping_failsafe = failsafe;
        emit AntiSnipingFailsafeSetTo(failsafe);
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    function isExcludedFromReward(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }

    function deliver(uint256 tAmount) public {
        address sender = _msgSender();
        require(!_isExcluded[sender], "Excluded addresses cannot call this function");
        (uint256 rAmount, , , , , , , ) = _getValues(tAmount, [false, false]); //Commas mean we don't care about those return values in the tuple.
        
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rTotal = _rTotal.sub(rAmount);
        _tFeeTotal = _tFeeTotal.add(tAmount);
    }

    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256)
    {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        if (!deductTransferFee) {
            (uint256 rAmount, , , , , , , ) = _getValues(tAmount, [false, false]);
            
            return rAmount;
        } else {
            (, uint256 rTransferAmount, , , , , , ) = _getValues(tAmount, [false, false]);
            
            return rTransferAmount;
        }
    }

    function tokenFromReflection(uint256 rAmount) public view returns (uint256)
    {
        require(rAmount <= _rTotal, "TokensFromReflection: Amount must be less than total reflections");
        uint256 currentRate = _getRate();
        return rAmount.div(currentRate);
    }

    function excludeFromReward(address account) public onlyOwner() {
        require(!_isExcluded[account], "ExcludeFromReward: Account already excluded");
        if (_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }

    function includeInReward(address account) external onlyOwner() {
        require(_isExcluded[account], "Account is already included");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _tOwned[account] = 0;
                _isExcluded[account] = false;
                _excluded.pop();
                break;
            }
        }
    }
    
    //Adding this for SmartPlaces v0.2, for use either internally or externally, so the ILO contract can be set to be tx limit exempt.
    function setIsExcludedFromTXLimit(address account, bool isExcluded) public onlyOwner {
        _isExcludedFromTxLimit[account] = isExcluded;
    }
    
    function isExcludedFromTXLimit(address account) public view returns (bool) {
        return _isExcludedFromTxLimit[account];
    }
    
    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }

    function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
        _taxFee = taxFee;
    }

    function setMarketingFeePercent(uint256 marketingFee) external onlyOwner() {
        _marketingFee = marketingFee;
    }
    
    function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
        _liquidityFee = liquidityFee;
    }

    function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
        _maxTxAmount = _tTotal.mul(maxTxPercent).div(100*10**2);
    }

    function setSwapAndLiquifyEnabled(bool toggle) public onlyOwner {
        swapAndLiquifyEnabled = toggle;
        emit SwapAndLiquifyEnabledUpdated(toggle);
    }
    
    function setAntiSnipingBlocks(uint256 blocks) public onlyOwner {
        antiSniping_blocks = blocks;
    }
    
    function setSalePenalizationEnabled(bool toggle) public onlyOwner {
        salePenalizationEnabled = toggle;
    }

    //to recieve ETH from uniswapV2Router when swaping
    receive() external payable {}

    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal.sub(rFee);
        _tFeeTotal = _tFeeTotal.add(tFee);
    }
    
    struct tVector {
        uint256 tTransferAmount;
        uint256 tFee;
        uint256 tLiquidity;
        uint256 tMarketing;
        uint256 tBurn;
    }
    
    struct rVector {
        uint256 rAmount;
        uint256 rTransferAmount;
        uint256 rFee;
    }
    
    //Had to use structs as the stack gets too deep if we leave it like it was. Remember, only around ~16 local variables are ever allowed in the stack, params and return types included.
    //The { }s are there for scoping, and killing unneeded vars.
    function _getValues(uint256 tAmount, bool[2] memory isSale_isSniper) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
        tVector memory my_tVector;
        rVector memory my_rVector;
        {
            //(uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 tBurn) = _getTValues(tAmount, isSale_isSniper);
            (uint256 tTransferAmount, uint256 tFee, uint256[3] memory allFees) = _getTValues(tAmount, isSale_isSniper);
            // The allFees array contains: pos_0: tLiquidity, pos_1: tMarketing, Pos_2: tBurn, Pos_3: tCharity if enabled.
            my_tVector.tTransferAmount = tTransferAmount;
            my_tVector.tFee = tFee;
            my_tVector.tLiquidity = allFees[0];
            my_tVector.tMarketing = allFees[1];
            my_tVector.tBurn = allFees[2];           //WORKSPACE BETA
        }
        {
            (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, my_tVector.tFee, my_tVector.tLiquidity, my_tVector.tMarketing, _getRate());
            my_rVector.rAmount = rAmount;
            my_rVector.rTransferAmount = rTransferAmount;
            my_rVector.rFee = rFee;
        }
        return (my_rVector.rAmount, my_rVector.rTransferAmount, my_rVector.rFee, my_tVector.tTransferAmount, my_tVector.tFee, my_tVector.tLiquidity, my_tVector.tMarketing, my_tVector.tBurn);
    }
    
    function _getTValues(uint256 tAmount, bool[2] memory isSale_isSniper) private view returns (uint256, uint256, uint256[3] memory) { //Contains 3 values!
        uint256 tFee = calculateTaxFee(tAmount, isSale_isSniper[0]);
        uint256 tLiquidity = calculateLiquidityFee(tAmount);
        uint256 tMarketing = calculateMarketingFee(tAmount, isSale_isSniper[1]);
        uint256 tBurn = calculateBurnFee(tAmount);
        uint256 tTransferAmount = tAmount.sub(tFee);
        tTransferAmount = tTransferAmount.sub(tLiquidity);
        tTransferAmount = tTransferAmount.sub(tMarketing);
        tTransferAmount = tTransferAmount.sub(tBurn);
        return (tTransferAmount, tFee, [tLiquidity, tMarketing, tBurn]);
    }
    
    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rTransferAmount;
        uint256 rFee;
        {
            rFee = tFee.mul(currentRate);
            uint256 rLiquidity = tLiquidity.mul(currentRate);
            uint256 rMarketing = tMarketing.mul(currentRate);
            rTransferAmount = rAmount.sub(rFee);
            rTransferAmount = rTransferAmount.sub(rLiquidity);
            rTransferAmount = rTransferAmount.sub(rMarketing);
        }
        return (rAmount, rTransferAmount, rFee);
    }

    function _getRate() private view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns (uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (
                _rOwned[_excluded[i]] > rSupply ||
                _tOwned[_excluded[i]] > tSupply
            ) return (_rTotal, _tTotal);
            rSupply = rSupply.sub(_rOwned[_excluded[i]]);
            tSupply = tSupply.sub(_tOwned[_excluded[i]]);
        }
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function _takeLiquidity(uint256 tLiquidity) private {
        uint256 currentRate = _getRate();
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
        if (_isExcluded[address(this)])
            _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
    }
    
    function _takeMarketing(uint256 tMarketing) private {
        uint256 currentRate =  _getRate();
        uint256 rMarketing = tMarketing.mul(currentRate);
        _rOwned[_marketingWalletAddress] = _rOwned[_marketingWalletAddress].add(rMarketing);
        if(_isExcluded[_marketingWalletAddress])
            _tOwned[_marketingWalletAddress] = _tOwned[_marketingWalletAddress].add(tMarketing);
    }
    
    function _takeBurn(uint256 tBurn) private {
        uint256 currentRate =  _getRate();
        uint256 rBurn = tBurn.mul(currentRate);
        _rOwned[_burnAddress] = _rOwned[_burnAddress].add(rBurn);
        if(_isExcluded[_burnAddress])
            _tOwned[_burnAddress] = _tOwned[_burnAddress].add(tBurn);
    }
    
    function calculateTaxFee(uint256 _amount, bool isSale) private view returns (uint256) {
        uint256 this_taxFee = _taxFee;
        if(isSale){
            this_taxFee = this_taxFee.mul(2);
        }
        return _amount.mul(this_taxFee).div(100);
    }

    function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_liquidityFee).div(100);
    }
    
    function calculateMarketingFee(uint256 _amount, bool isSniper) private view returns (uint256) {
        uint256 this_marketingFee = _marketingFee;
        if(isSniper){
            this_marketingFee = uint256(90).sub(_marketingFee).sub(_taxFee).sub(_liquidityFee);
        }
        return _amount.mul(this_marketingFee).div(100);
    }
    
    function calculateBurnFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_burnFee).div(100);
    }

    function setMarketingAddr(address account) external onlyOwner() {
		_marketingWalletAddress = account;
    }
    
    function getMarketingAddr() public view returns (address) {
		return _marketingWalletAddress;
    }
    
    function removeAllFee() private {
        if(_taxFee == 0 && _liquidityFee == 0) return;
        
        _previousTaxFee = _taxFee;
        _previousMarketingFee = _marketingFee;
        _previousLiquidityFee = _liquidityFee;
        
        _taxFee = 0;
        _marketingFee = 0;
        _liquidityFee = 0;
    }
    
    function restoreAllFee() private {
        _taxFee = _previousTaxFee;
        _marketingFee = _previousMarketingFee;
        _liquidityFee = _previousLiquidityFee;
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    
    //MARKER: This is our bread and butter.
    function _transfer(address from, address to, uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        
        /* Added in SmartPlaces v0.2 - this block is only used once, and marks the launch of the token! */
        if(!launched() && to == SmartPlacesUniswapV2Pair || manualLaunch){ 
            require(balanceOf(from) > 0, "SMARTPLACES: Are you trying to launch without actually having tokens?");
            launch();
        }
        
        // Fixed in SmartPlaces v0.2. This requires a && or XOR condition, otherwise it imposed maxTxLimit on anyone but the owner() address.
        if( (from != owner() && to != owner()) && !(_isExcludedFromTxLimit[from]) ) {
            require(amount <= _maxTxAmount, "SMARTPLACES: Transfer amount exceeds maxTxAmount.");
        }

        // is the token balance of this contract address over the min number of
        // tokens that we need to initiate a swap + liquidity lock?
        // also, don't get caught in a circular liquidity event.
        // also, don't swap & liquify if sender is uniswap pair.
        uint256 contractTokenBalance = balanceOf(address(this));
        //MARKER: The contract is just putting everything to liquidity once it has it. Gotta intercept it somehow.
        if(contractTokenBalance >= _maxTxAmount) {
            contractTokenBalance = _maxTxAmount;
        }
        
        //Should we add liquidity or not? Are we over the minimum amount?
        bool overMinTokenBalance = (contractTokenBalance >= numTokensSellToAddToLiquidity);
        if(swapAndLiquifyEnabled && overMinTokenBalance && !inSwapAndLiquify && from != SmartPlacesUniswapV2Pair) { //Jesus, that's a lot of conditions
            contractTokenBalance = numTokensSellToAddToLiquidity;
            //Add liquidity!
            swapAndLiquify(contractTokenBalance);
        }

        //indicates if fee should be deducted from transfer
        bool takeFees = true;
        //if any account belongs to _isExcludedFromFee account then we don't deduct any
        if (_isExcludedFromFee[from] || _isExcludedFromFee[to] || (noFeesBetweenUsersEnabled && !_shouldTakeFee[from]) ) {
            takeFees = false;
        }
        
        /* Added in SmartPlaces v0.2 - we raise taxation for the first 4 blocks after the launch, to penalize bots+snipers playing gas wars.
         * No human can get to pancakeswap within 9 seconds of the first liquidity being added to the pair.
         * If isSniper equals true, taxation is raised to 99.999%
         */
        bool isSniper = false;
        if(antiSniping_failsafe && launchedAt + antiSniping_blocks >= block.number){
        //Looks like we have a sniper here, boys.
            isSniper = true;
        }
        
        bool isSale = false;
        //TODO: Continue building this and confirm with other devs
        //A sale is when? When the recipient is the router, or the pair address?
        if(to == SmartPlacesUniswapV2Pair && salePenalizationEnabled){ //It's a sell, boys!
            isSale = true;
        }

        //transfer amount, it will take tax, marketing, liquidity fee.
        _tokenTransfer(from, to, amount, takeFees, [isSale, isSniper]);
    }

    //this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee, bool[2] memory isSale_isSniper) private {
        if (!takeFee) removeAllFee(); //Toggle fees off for now

        if (_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferFromExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
            _transferToExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferStandard(sender, recipient, amount, isSale_isSniper);
        } else if (_isExcluded[sender] && _isExcluded[recipient]) {
            _transferBothExcluded(sender, recipient, amount);
        } else {    //Failsafe, just in case
            _transferStandard(sender, recipient, amount, isSale_isSniper);
        }

        if (!takeFee) restoreAllFee(); //Toggle it back
    }

    function _transferStandard(address sender, address recipient, uint256 tAmount, bool[2] memory isSale_isSniper) private {
        (
         uint256 rAmount,
         uint256 rTransferAmount,
         uint256 rFee,
         uint256 tTransferAmount,
         uint256 tFee,
         uint256 tLiquidity,
         uint256 tMarketing,
         uint256 tBurn
        ) = _getValues(tAmount, isSale_isSniper);
        
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _sendToMarketing(tMarketing, sender);
        _sendToBurn(tBurn, sender);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 rFee,
            uint256 tTransferAmount,
            uint256 tFee,
            uint256 tLiquidity,
            uint256 tMarketing,
            uint256 tBurn
        ) = _getValues(tAmount, [false, false]);
        
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _sendToMarketing(tMarketing, sender);
        _sendToBurn(tBurn, sender);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 rFee,
            uint256 tTransferAmount,
            uint256 tFee,
            uint256 tLiquidity,
            uint256 tMarketing,
            uint256 tBurn
        ) = _getValues(tAmount, [false, false]);
    
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _sendToMarketing(tMarketing, sender);
        _sendToBurn(tBurn, sender);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }
    
    function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 rFee,
            uint256 tTransferAmount,
            uint256 tFee,
            uint256 tLiquidity,
            uint256 tMarketing,
            uint256 tBurn
        ) = _getValues(tAmount, [false, false]); //[isSale, isSniper].
        
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _takeMarketing(tMarketing);
        _takeBurn(tBurn);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }
    
    function _sendToMarketing(uint256 tMarketing, address sender) private {
        uint256 currentRate = _getRate();
        uint256 rMarketing = tMarketing.mul(currentRate);
        address currentMarketing = _marketingWalletAddress;
        _rOwned[currentMarketing] = _rOwned[currentMarketing].add(rMarketing);
        _tOwned[currentMarketing] = _tOwned[currentMarketing].add(tMarketing);
        emit Transfer(sender, _marketingWalletAddress, tMarketing);
    }
    
    function _sendToBurn(uint256 tBurn, address sender) private {  //WORKSPACE
        uint256 currentRate = _getRate();
        uint256 rBurn = tBurn.mul(currentRate);
        address currentBurn = _burnAddress;
        _rOwned[currentBurn] = _rOwned[currentBurn].add(rBurn);
        _tOwned[currentBurn] = _tOwned[currentBurn].add(tBurn);
        emit Transfer(sender, _burnAddress, tBurn);
    }
    
    function _sendToCharity(uint256 tCharity, address sender) private {
        uint256 currentRate = _getRate();
        uint256 rCharity = tCharity.mul(currentRate);
        address currentCharity = _charityAddress;
        _rOwned[currentCharity] = _rOwned[currentCharity].add(rCharity);
        _tOwned[currentCharity] = _tOwned[currentCharity].add(tCharity);
        emit Transfer(sender, _charityAddress, tCharity);
    }
    
    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
        // split the contract balance into 2 halves
        uint256 half = contractTokenBalance.div(2);
        uint256 otherHalf = contractTokenBalance.sub(half);

        // capture the contract's current ETH balance.
        // this is so that we can capture exactly the amount of ETH that the
        // swap creates, and not make the liquidity event include any ETH that
        // has been manually sent to the contract
        uint256 initialBalance = address(this).balance;

        // swap tokens for ETH
        swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered

        // how much ETH did we just swap into?
        uint256 newBalance = address(this).balance.sub(initialBalance);

        // add liquidity to uniswap
        addLiquidity(otherHalf, newBalance);
        
        emit SwapAndLiquify(half, newBalance, otherHalf);
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // add the liquidity
        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner(),
            block.timestamp
        );
    }
}
