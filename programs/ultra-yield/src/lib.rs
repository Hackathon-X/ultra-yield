use anchor_lang::prelude::*;

declare_id!("BVVPPEpsDpo2jjWmb73LZ9knYQgsVCAjGdYswpGi6sjx");

#[program]
pub mod ultra_yield {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize {}
