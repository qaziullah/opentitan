// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class chip_sw_lc_walkthrough_vseq extends chip_sw_base_vseq;
  `uvm_object_utils(chip_sw_lc_walkthrough_vseq)

  `uvm_object_new

  // LC sends two 64-bit msg as input token.
  localparam uint TokenWidthBit  = kmac_pkg::MsgWidth * 2;
  localparam uint TokenWidthByte = TokenWidthBit / 8;

  rand bit [7:0] lc_exit_token[TokenWidthByte];
  rand bit [7:0] lc_unlock_token[TokenWidthByte];
  bit [7:0] otp_exit_token[TokenWidthByte];
  bit [7:0] otp_unlock_token[TokenWidthByte];
  bit [7:0] selected_dest_state[];

  lc_ctrl_state_pkg::dec_lc_state_e dest_dec_state = lc_ctrl_state_pkg::DecLcStProdEnd;

  // Reassign `select_jtag` variable to drive LC JTAG tap and disable mubi assertion errors.
  virtual task pre_start();
    string dest_state_s;
    void'($value$plusargs("dest_dec_state=%0s", dest_state_s));
    `DV_GET_ENUM_PLUSARG(lc_ctrl_state_pkg::dec_lc_state_e, dest_dec_state, dest_state_s)

    select_jtag = SelectLCJtagTap;
    otp_raw_img_mubi_assertion_ctrl(.enable(0));
    super.pre_start();
  endtask

  virtual task body();
    bit [TokenWidthBit-1:0] otp_exit_token_bits, otp_unlock_token_bits;
    bit [7:0] selected_dest_state[];
    super.body();

    otp_exit_token_bits = dec_otp_token_from_lc_csrs(lc_exit_token);
    otp_unlock_token_bits = dec_otp_token_from_lc_csrs(lc_unlock_token);

    otp_unlock_token = {<< 8{otp_unlock_token_bits}};
    otp_exit_token = {<< 8{otp_exit_token_bits}};

    `uvm_info(`gfn, $sformatf("OTP unlock token %0h and OTP exit token %0h",
              otp_unlock_token_bits, otp_exit_token_bits), UVM_LOW)

    // Override the C test tokens with random data.
    sw_symbol_backdoor_overwrite("kLcExitToken", lc_exit_token);
    sw_symbol_backdoor_overwrite("kOtpExitToken", otp_exit_token);
    sw_symbol_backdoor_overwrite("kOtpUnlockToken", otp_unlock_token);

    // Override the C test destination state with the plusarg value.
    selected_dest_state = {dest_dec_state};
    sw_symbol_backdoor_overwrite("kDestState", selected_dest_state);

    wait_lc_ready(1);
    jtag_lc_state_transition(DecLcStRaw, DecLcStTestUnlocked0);
    apply_reset();

    wait (cfg.sw_logger_vif.printed_log == "Written and locked OTP secret0 partition!");
    apply_reset();

    wait (cfg.sw_logger_vif.printed_log == "Waiting for LC transtition done and reboot.");
    wait_lc_status(LcTransitionSuccessful);
    apply_reset();
  endtask

endclass
