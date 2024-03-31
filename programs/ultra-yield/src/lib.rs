use anchor_lang::prelude::*;
use anchor_spl::token::{self, Mint, Token, TokenAccount};

declare_id!("BVVPPEpsDpo2jjWmb73LZ9knYQgsVCAjGdYswpGi6sjx");
#[program]
pub mod ultra_yield {
    use anchor_spl::token::{Burn, MintTo};

    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        let pool_account = &mut ctx.accounts.pool_account;
        pool_account.owner = *ctx.accounts.payer.key;
        Ok(())
    }

    pub fn deposit_sol(ctx: Context<DepositSol>, amount: u64) -> Result<()> {
        // 此处假设已经处理了将 SOL 转移到程序账户的逻辑
        // 铸造 ultrasol 给用户
        let cpi_accounts = MintTo {
            mint: ctx.accounts.ultrasol_mint.to_account_info(),
            to: ctx.accounts.user_ultrasol_account.to_account_info(),
            authority: ctx.accounts.pool_account.to_account_info(),
        };
        let cpi_program = ctx.accounts.token_program.to_account_info();
        let cpi_ctx = CpiContext::new(cpi_program, cpi_accounts);
        token::mint_to(cpi_ctx, amount)?;
        // TODO 记录与 Kamino 交互的逻辑
        Ok(())
    }

    pub fn withdraw_sol(ctx: Context<WithdrawSol>, amount: u64) -> Result<()> {
        // 燃烧用户的 ultrasol
        let cpi_accounts = Burn {
            mint: ctx.accounts.ultrasol_mint.to_account_info(),
            from: ctx.accounts.user_ultrasol_account.to_account_info(),
            authority: ctx.accounts.user_authority.to_account_info(),
        };
        let cpi_program = ctx.accounts.token_program.to_account_info();
        let cpi_ctx = CpiContext::new(cpi_program, cpi_accounts);
        token::burn(cpi_ctx, amount)?;
        // 与 Kamino 交互并处理提取逻辑（示例略）
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize<'info> {
    #[account(init, payer = payer, space = 8 + 40)]
    pub pool_account: Account<'info, PoolAccount>,
    #[account(mut)]
    pub payer: Signer<'info>,
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct DepositSol<'info> {
    #[account(mut)]
    pub pool_account: Account<'info, PoolAccount>,
    pub ultrasol_mint: Account<'info, Mint>,
    #[account(mut)]
    pub user_ultrasol_account: Account<'info, TokenAccount>,
    pub token_program: Program<'info, Token>,
}

#[derive(Accounts)]
pub struct WithdrawSol<'info> {
    pub pool_account: Account<'info, PoolAccount>,
    pub ultrasol_mint: Account<'info, Mint>,
    #[account(mut)]
    pub user_ultrasol_account: Account<'info, TokenAccount>,
    #[account(mut)]
    pub user_authority: Signer<'info>,
    pub token_program: Program<'info, Token>,
}

#[account]
pub struct PoolAccount {
    pub owner: Pubkey,
    // 其他可能需要的字段
}
