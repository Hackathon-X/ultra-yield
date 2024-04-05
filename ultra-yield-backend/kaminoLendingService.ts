import { Connection, PublicKey } from '@solana/web3.js';
import { KaminoMarket } from '@hubbleprotocol/kamino-lending-sdk';

const connection = new Connection("https://mainnet.helius-rpc.com/?api-key=0bb95586-3d2b-494b-97b6-cf9984a4ff2a");

async function loadKaminoLendingData() {
  // 初始化市场，指定Kamino主市场地址
  const market = await KaminoMarket.load(
    connection,
    new PublicKey("7u3HeHxYDLhnCoErrtycNokbQYbWGzLs6JSDqGAv5PfF")
  );
    //2yDUz8BfiUsBN2eC4TMQduauSfQZxVDc918s2ZT7BKc4
  await market.loadReserves();

  // 刷新储备金信息s
  const reserves = market.getReserves();
  // 遍历并打印每个储备金的totalDepositsWads信息
  reserves.forEach(reserve => {
      // 格式化APY为百分比形式
      const apyPercentage = (reserve.stats.supplyInterestAPY * 100).toFixed(2); // 转换为百分比并保留两位小数
      const reserveAddress = reserve.address.toBase58();
    console.log(`${reserve.symbol}池 Address: ${reserveAddress} SupplyAPY收益率: ${apyPercentage}%`);
  });
  // 可能还需要实现更多的逻辑来处理你的业务需求
}

// 调用函数获取数据
loadKaminoLendingData();
