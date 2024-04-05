import { Connection, PublicKey } from '@solana/web3.js';
import { Kamino, StrategiesFilters } from '@hubbleprotocol/kamino-sdk';

const connection = new Connection("https://mainnet.helius-rpc.com/?api-key=0bb95586-3d2b-494b-97b6-cf9984a4ff2a");

const solPublicKeyString = "So11111111111111111111111111111111111111112"
const solPublickKey = new PublicKey(solPublicKeyString);

async function loadKaminoLiquidityData() {
  // 初始化市场，指定Kamino主市场地址
  const market = new Kamino('mainnet-beta', connection)
    //2yDUz8BfiUsBN2eC4TMQduauSfQZxVDc918s2ZT7BKc4
    // get all strategies supported by Kamino
    const strategyFilters: StrategiesFilters = { strategyType: "PEGGED" };
    const strategies = await market.getAllStrategiesWithFilters(strategyFilters);
  
  // 遍历并打印每个储备金的totalDepositsWads信息
  strategies.forEach(reserve => {
      // 格式化APY为百分比形式
    //   if (reserve.strategy.tokenAMint.toString() === solPublickKey.toString() || reserve.strategy.tokenBMint.toString() === solPublickKey.toString()) {
    //       console.log('池子Account:',reserve.strategy.pool.toBase58(), '代币A:',reserve.strategy.tokenAMint.toString(), '代币B:',reserve.strategy.tokenBMint.toString());
    //   }

      console.log('池子Account:',reserve.strategy.pool.toBase58(), '代币A:',reserve.strategy.tokenAMint.toString(), '代币B:',reserve.strategy.tokenBMint.toString());
  });
  // 可能还需要实现更多的逻辑来处理你的业务需求
}

// 调用函数获取数据
loadKaminoLiquidityData();
