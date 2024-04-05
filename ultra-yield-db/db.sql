CREATE TABLE user (
    user_id VARCHAR(255) PRIMARY KEY,
    wallet_address VARCHAR(255) UNIQUE NOT NULL,
    total_assets DECIMAL(20, 2) COMMENT 'Total value of the user''s assets',
    total_earnings DECIMAL(20, 2) COMMENT 'Total earnings from investments',
    date_registered TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Registration date',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Indicates if the user account is active'
) COMMENT 'Stores user information using wallet addresses for anonymous login';

-- 创建更新后的资产组合池表，使用snake_case命名约定
CREATE TABLE portfolio_pool (
    portfolio_id VARCHAR(255) PRIMARY KEY COMMENT 'Primary identifier for the portfolio',
    poolfolio_id VARCHAR(255),
    user_id VARCHAR(255) NOT NULL COMMENT 'References the user',
    name VARCHAR(255) NOT NULL COMMENT 'Name of the portfolio pool',
    description TEXT COMMENT 'Description of the portfolio pool',
    initial_market_cap DECIMAL(20, 2) COMMENT 'Initial market cap of the portfolio',
    current_market_cap DECIMAL(20, 2) COMMENT 'Current market cap of the portfolio',
    initial_price DECIMAL(20, 2) COMMENT 'Initial price of the portfolio pool',
    current_price DECIMAL(20, 2) COMMENT 'Current price of the portfolio pool',
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation date of the portfolio pool',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Indicates if the portfolio pool is active',
    FOREIGN KEY (user_id) REFERENCES user(user_id)
) 
    COMMENT 'Stores portfolio pool information with market cap and price details' ;

-- 更新交易记录表，使用snake_case命名约定
CREATE TABLE transac (
    transac_id VARCHAR(255) PRIMARY KEY,
    user_id VARCHAR(255),
    portfolio_id VARCHAR(255),
    transac_type ENUM('BUY', 'SELL') NOT NULL COMMENT 'Type of transaction',
    amount DECIMAL(20, 2) NOT NULL COMMENT 'Transaction amount',
    transac_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Transaction date'
   
) COMMENT 'Stores user transactions for buying or selling portfolio pools based on portfolio_id' ;


CREATE TABLE pool_folio_list (
    pool_folio_id VARCHAR(50) PRIMARY KEY COMMENT 'Primary key for the pool folio',
    algorithm_strategy_name VARCHAR(100) COMMENT 'Name of the algorithm strategy for the pool folio',
    other_info VARCHAR(255) COMMENT 'Other information related to the pool folio',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp of creation',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Timestamp of last update'
) COMMENT 'Table to store pool folio information';

CREATE TABLE reserve_list (
    reserve_id INT  PRIMARY KEY COMMENT 'Unique identifier for the reserve',
    address VARCHAR(255) NOT NULL COMMENT 'Address of the reserve',
    symbol VARCHAR(10) NOT NULL COMMENT 'Symbol of the reserve',
    token_oracle_id INT COMMENT 'Identifier for the associated token oracle',
    market_price DECIMAL(18, 8) COMMENT 'Current market price of the reserve',
    accumulated_protocol_fees DECIMAL(18, 8) COMMENT 'Total accumulated protocol fees of the reserve',
    accumulated_referrer_fees DECIMAL(18, 8) COMMENT 'Total accumulated referrer fees of the reserve',
    pending_referrer_fees DECIMAL(18, 8) COMMENT 'Total pending referrer fees of the reserve',
    buffer BLOB COMMENT 'Buffer to store temporary or calculated data',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp of creation',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Timestamp of last update'
) COMMENT 'Table to store reserve information';

CREATE TABLE pool_folio_reserve (
    pool_folio_id VARCHAR(50)   PRIMARY KEY COMMENT 'Primary identifier for the portfolio',
    reserve_id INT COMMENT 'Unique identifier for the reserve',
    proportion DECIMAL(18, 8) COMMENT 'Proportion of the reserve in the pool folio'
) COMMENT 'Table to represent the many-to-many relationship between pool folios and reserves';
