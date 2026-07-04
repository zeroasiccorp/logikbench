// Compiled by morty-0.9.0 / 2026-06-23 22:55:13.897652804 -04:00

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

package top_pkg;

localparam int TL_AW=32;
localparam int TL_DW=32;    // = TL_DBW * 8; TL_DBW must be a power-of-two
localparam int TL_AIW=8;    // a_source, d_source
localparam int TL_DIW=1;    // d_sink
localparam int TL_AUW=23;   // a_user
localparam int TL_DUW=14;   // d_user
localparam int TL_DBW=(TL_DW>>3);
localparam int TL_SZW=$clog2($clog2(TL_DBW)+1);

// Number of cycles a differential skew is tolerated on the alert signal
localparam int unsigned AlertSkewCycles = 1;

// NOTE THAT THIS IS A FEATURE FOR TEST CHIPS ONLY TO MITIGATE
// THE RISK OF A BROKEN OTP MACRO. THIS WILL BE DISABLED FOR
// PRODUCTION DEVICES.
localparam int SecVolatileRawUnlockEn = 0;

endpackage
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// i2c package
//
package i2c_pkg;
  parameter int unsigned I2C_ACQ_BYTE_ID_WIDTH = 3;

  // TODO(#22028) encode this more efficiently in the ACQ FIFO. Each entry in the
  // ACQ FIFO does not need to contain both an 8 bit data field and a 3 bit
  // identifier. We should have the ACQ FIFO be 9 bits wide where the MSB
  // indicates whether it is a data byte or a control byte. This way we can
  // add more values to this enum without having to widen the ACQ FIFO width.
  typedef enum logic [I2C_ACQ_BYTE_ID_WIDTH-1:0] {
    AcqData      = 3'b000,
    AcqStart     = 3'b001,
    AcqStop      = 3'b010,
    AcqRestart   = 3'b011,
    // AcqNack means one of two things:
    // 1. We received a read request to our address, but had to NACK the
    // address because our ACQ FIFO is full.
    // 2. We received too many bytes in a write request and had to NACK a data
    // byte. The NACK'ed data byte is still in the data field for inspection.
    AcqNack      = 3'b100,
    // AcqNackStart means that we were addressed on this item, but we timed
    // out after stretching.
    AcqNackStart = 3'b101,
    // AcqNackStop means that we were addressed during the transaction, but we
    // timed out after stretching and received the Stop to end the
    // transaction.
    AcqNackStop  = 3'b110
  } i2c_acq_byte_id_e;

  typedef enum logic {
    StretchTimeoutMode = 1'b0,
    BusTimeoutMode     = 1'b1
  } i2c_timeout_mode_e;

  // Width of each entry in the FMT FIFO with enough space for an 8-bit data
  // byte and 5 flags.
  parameter int unsigned FMT_FIFO_WIDTH = 8 + 5;

  // Width of each entry in the RX and TX FIFO: just an 8-bit data byte.
  parameter int unsigned RX_FIFO_WIDTH = 8;
  parameter int unsigned TX_FIFO_WIDTH = 8;

  // Width of each entry in the ACQ FIFO with enough space for an 8-bit data
  // byte and an identifier defined by i2c_acq_byte_id_e.
  parameter int unsigned ACQ_FIFO_WIDTH = I2C_ACQ_BYTE_ID_WIDTH + 8;

  typedef enum bit {
    WRITE = 1'b0,
    READ = 1'b1
  } rw_e;

  typedef enum bit {
    ACK = 1'b0,
    NACK = 1'b1
  } acknack_e;

endpackage : i2c_pkg
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module prim_buf #(
  parameter int Width = 1
) (
  input        [Width-1:0] in_i,
  output logic [Width-1:0] out_o
);

  logic [Width-1:0] inv;
  assign inv = ~in_i;
  assign out_o = ~inv;

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module prim_flop #(
  parameter int               Width      = 1,
  parameter logic [Width-1:0] ResetValue = 0
) (
  input                    clk_i,
  input                    rst_ni,
  input        [Width-1:0] d_i,
  output logic [Width-1:0] q_o
);

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      q_o <= ResetValue;
    end else begin
      q_o <= d_i;
    end
  end

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

package prim_ram_1p_pkg;

  typedef struct packed {
    logic       test;
    logic       cfg_en;
    logic [3:0] cfg;
  } cfg_t;

  typedef struct packed {
    cfg_t ram_cfg;  // configuration for ram
    cfg_t rf_cfg;   // configuration for regfile
  } ram_1p_cfg_t;

  typedef struct packed {
    logic done;
  } ram_1p_cfg_rsp_t;

  parameter ram_1p_cfg_t RAM_1P_CFG_DEFAULT = '0;

endpackage // prim_ram_1p_pkg
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module prim_xnor2 #(
  parameter int Width = 1
) (
  input        [Width-1:0] in0_i,
  input        [Width-1:0] in1_i,
  output logic [Width-1:0] out_o
);

  assign out_o = ~(in0_i ^ in1_i);

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SECDED package generated by
// util/design/secded_gen.py from util/design/data/secded_cfg.hjson

package prim_secded_pkg;

  typedef enum int {
    SecdedHsiao,
    SecdedHamming,
    SecdedInvHsiao,
    SecdedInvHamming
  } prim_secded_type_e;

  typedef enum int {
    SecdedNone,
    Secded_22_16,
    Secded_28_22,
    Secded_39_32,
    Secded_64_57,
    Secded_72_64,
    SecdedHamming_22_16,
    SecdedHamming_39_32,
    SecdedHamming_72_64,
    SecdedHamming_76_68,
    SecdedInv_22_16,
    SecdedInv_28_22,
    SecdedInv_39_32,
    SecdedInv_64_57,
    SecdedInv_72_64,
    SecdedInvHamming_22_16,
    SecdedInvHamming_39_32,
    SecdedInvHamming_72_64,
    SecdedInvHamming_76_68
  } prim_secded_e;

  // This returns 1 iff the width is supported for the given secded type.
  function automatic bit is_width_valid(prim_secded_type_e sd_type, int width);
    unique case (sd_type)
      SecdedHsiao:
        unique case (width)
          16: return 1'b1;
          22: return 1'b1;
          32: return 1'b1;
          57: return 1'b1;
          64: return 1'b1;
          default: return 1'b0;
        endcase
      SecdedHamming:
        unique case (width)
          16: return 1'b1;
          32: return 1'b1;
          64: return 1'b1;
          68: return 1'b1;
          default: return 1'b0;
        endcase
      SecdedInvHsiao:
        unique case (width)
          16: return 1'b1;
          22: return 1'b1;
          32: return 1'b1;
          57: return 1'b1;
          64: return 1'b1;
          default: return 1'b0;
        endcase
      SecdedInvHamming:
        unique case (width)
          16: return 1'b1;
          32: return 1'b1;
          64: return 1'b1;
          68: return 1'b1;
          default: return 1'b0;
        endcase
      default: return 1'b0;
    endcase
  endfunction : is_width_valid

  // This returns the syndrome width for the given width and secded type.
  // Return 0 if the width is not supported.
  function automatic int get_synd_width(prim_secded_type_e sd_type, int width);
    unique case (sd_type)
      SecdedHsiao:
        unique case (width)
          16: return 6;
          22: return 6;
          32: return 7;
          57: return 7;
          64: return 8;
          default: return 0;
        endcase
      SecdedHamming:
        unique case (width)
          16: return 6;
          32: return 7;
          64: return 8;
          68: return 8;
          default: return 0;
        endcase
      SecdedInvHsiao:
        unique case (width)
          16: return 6;
          22: return 6;
          32: return 7;
          57: return 7;
          64: return 8;
          default: return 0;
        endcase
      SecdedInvHamming:
        unique case (width)
          16: return 6;
          32: return 7;
          64: return 8;
          68: return 8;
          default: return 0;
        endcase
      default: return 0;
    endcase
  endfunction : get_synd_width

  function automatic int get_full_width(prim_secded_type_e sd_type, int width);
    return width + get_synd_width(sd_type, width);
  endfunction : get_full_width

  function automatic int get_ecc_data_width(prim_secded_e ecc_type);
    case (ecc_type)
      Secded_22_16: return 16;
      Secded_28_22: return 22;
      Secded_39_32: return 32;
      Secded_64_57: return 57;
      Secded_72_64: return 64;
      SecdedHamming_22_16: return 16;
      SecdedHamming_39_32: return 32;
      SecdedHamming_72_64: return 64;
      SecdedHamming_76_68: return 68;
      SecdedInv_22_16: return 16;
      SecdedInv_28_22: return 22;
      SecdedInv_39_32: return 32;
      SecdedInv_64_57: return 57;
      SecdedInv_72_64: return 64;
      SecdedInvHamming_22_16: return 16;
      SecdedInvHamming_39_32: return 32;
      SecdedInvHamming_72_64: return 64;
      SecdedInvHamming_76_68: return 68;
      // Return a non-zero width to avoid VCS compile issues
      default: return 32;
    endcase
  endfunction

  function automatic int get_ecc_parity_width(prim_secded_e ecc_type);
    case (ecc_type)
      Secded_22_16: return 6;
      Secded_28_22: return 6;
      Secded_39_32: return 7;
      Secded_64_57: return 7;
      Secded_72_64: return 8;
      SecdedHamming_22_16: return 6;
      SecdedHamming_39_32: return 7;
      SecdedHamming_72_64: return 8;
      SecdedHamming_76_68: return 8;
      SecdedInv_22_16: return 6;
      SecdedInv_28_22: return 6;
      SecdedInv_39_32: return 7;
      SecdedInv_64_57: return 7;
      SecdedInv_72_64: return 8;
      SecdedInvHamming_22_16: return 6;
      SecdedInvHamming_39_32: return 7;
      SecdedInvHamming_72_64: return 8;
      SecdedInvHamming_76_68: return 8;
      default: return 0;
    endcase
  endfunction

  parameter logic [5:0] Secded2216ZeroEcc = 6'h0;
  parameter logic [21:0] Secded2216ZeroWord = 22'h0;

  typedef struct packed {
    logic [15:0] data;
    logic [5:0] syndrome;
    logic [1:0]  err;
  } secded_22_16_t;

  parameter logic [5:0] Secded2822ZeroEcc = 6'h0;
  parameter logic [27:0] Secded2822ZeroWord = 28'h0;

  typedef struct packed {
    logic [21:0] data;
    logic [5:0] syndrome;
    logic [1:0]  err;
  } secded_28_22_t;

  parameter logic [6:0] Secded3932ZeroEcc = 7'h0;
  parameter logic [38:0] Secded3932ZeroWord = 39'h0;

  typedef struct packed {
    logic [31:0] data;
    logic [6:0] syndrome;
    logic [1:0]  err;
  } secded_39_32_t;

  parameter logic [6:0] Secded6457ZeroEcc = 7'h0;
  parameter logic [63:0] Secded6457ZeroWord = 64'h0;

  typedef struct packed {
    logic [56:0] data;
    logic [6:0] syndrome;
    logic [1:0]  err;
  } secded_64_57_t;

  parameter logic [7:0] Secded7264ZeroEcc = 8'h0;
  parameter logic [71:0] Secded7264ZeroWord = 72'h0;

  typedef struct packed {
    logic [63:0] data;
    logic [7:0] syndrome;
    logic [1:0]  err;
  } secded_72_64_t;

  parameter logic [5:0] SecdedHamming2216ZeroEcc = 6'h0;
  parameter logic [21:0] SecdedHamming2216ZeroWord = 22'h0;

  typedef struct packed {
    logic [15:0] data;
    logic [5:0] syndrome;
    logic [1:0]  err;
  } secded_hamming_22_16_t;

  parameter logic [6:0] SecdedHamming3932ZeroEcc = 7'h0;
  parameter logic [38:0] SecdedHamming3932ZeroWord = 39'h0;

  typedef struct packed {
    logic [31:0] data;
    logic [6:0] syndrome;
    logic [1:0]  err;
  } secded_hamming_39_32_t;

  parameter logic [7:0] SecdedHamming7264ZeroEcc = 8'h0;
  parameter logic [71:0] SecdedHamming7264ZeroWord = 72'h0;

  typedef struct packed {
    logic [63:0] data;
    logic [7:0] syndrome;
    logic [1:0]  err;
  } secded_hamming_72_64_t;

  parameter logic [7:0] SecdedHamming7668ZeroEcc = 8'h0;
  parameter logic [75:0] SecdedHamming7668ZeroWord = 76'h0;

  typedef struct packed {
    logic [67:0] data;
    logic [7:0] syndrome;
    logic [1:0]  err;
  } secded_hamming_76_68_t;

  parameter logic [5:0] SecdedInv2216ZeroEcc = 6'h2A;
  parameter logic [21:0] SecdedInv2216ZeroWord = 22'h2A0000;

  typedef struct packed {
    logic [15:0] data;
    logic [5:0] syndrome;
    logic [1:0]  err;
  } secded_inv_22_16_t;

  parameter logic [5:0] SecdedInv2822ZeroEcc = 6'h2A;
  parameter logic [27:0] SecdedInv2822ZeroWord = 28'hA800000;

  typedef struct packed {
    logic [21:0] data;
    logic [5:0] syndrome;
    logic [1:0]  err;
  } secded_inv_28_22_t;

  parameter logic [6:0] SecdedInv3932ZeroEcc = 7'h2A;
  parameter logic [38:0] SecdedInv3932ZeroWord = 39'h2A00000000;

  typedef struct packed {
    logic [31:0] data;
    logic [6:0] syndrome;
    logic [1:0]  err;
  } secded_inv_39_32_t;

  parameter logic [6:0] SecdedInv6457ZeroEcc = 7'h2A;
  parameter logic [63:0] SecdedInv6457ZeroWord = 64'h5400000000000000;

  typedef struct packed {
    logic [56:0] data;
    logic [6:0] syndrome;
    logic [1:0]  err;
  } secded_inv_64_57_t;

  parameter logic [7:0] SecdedInv7264ZeroEcc = 8'hAA;
  parameter logic [71:0] SecdedInv7264ZeroWord = 72'hAA0000000000000000;

  typedef struct packed {
    logic [63:0] data;
    logic [7:0] syndrome;
    logic [1:0]  err;
  } secded_inv_72_64_t;

  parameter logic [5:0] SecdedInvHamming2216ZeroEcc = 6'h2A;
  parameter logic [21:0] SecdedInvHamming2216ZeroWord = 22'h2A0000;

  typedef struct packed {
    logic [15:0] data;
    logic [5:0] syndrome;
    logic [1:0]  err;
  } secded_inv_hamming_22_16_t;

  parameter logic [6:0] SecdedInvHamming3932ZeroEcc = 7'h2A;
  parameter logic [38:0] SecdedInvHamming3932ZeroWord = 39'h2A00000000;

  typedef struct packed {
    logic [31:0] data;
    logic [6:0] syndrome;
    logic [1:0]  err;
  } secded_inv_hamming_39_32_t;

  parameter logic [7:0] SecdedInvHamming7264ZeroEcc = 8'hAA;
  parameter logic [71:0] SecdedInvHamming7264ZeroWord = 72'hAA0000000000000000;

  typedef struct packed {
    logic [63:0] data;
    logic [7:0] syndrome;
    logic [1:0]  err;
  } secded_inv_hamming_72_64_t;

  parameter logic [7:0] SecdedInvHamming7668ZeroEcc = 8'hAA;
  parameter logic [75:0] SecdedInvHamming7668ZeroWord = 76'hAA00000000000000000;

  typedef struct packed {
    logic [67:0] data;
    logic [7:0] syndrome;
    logic [1:0]  err;
  } secded_inv_hamming_76_68_t;

  function automatic logic [21:0]
      prim_secded_22_16_enc (logic [15:0] data_i);
    logic [21:0] data_o;
    data_o = 22'(data_i);
    data_o[16] = ^(data_o & 22'h00496E);
    data_o[17] = ^(data_o & 22'h00F20B);
    data_o[18] = ^(data_o & 22'h008ED8);
    data_o[19] = ^(data_o & 22'h007714);
    data_o[20] = ^(data_o & 22'h00ACA5);
    data_o[21] = ^(data_o & 22'h0011F3);
    return data_o;
  endfunction

  function automatic secded_22_16_t
      prim_secded_22_16_dec (logic [21:0] data_i);
    logic [15:0] data_o;
    logic [5:0] syndrome_o;
    logic [1:0]  err_o;

    secded_22_16_t dec;

    // Syndrome calculation
    syndrome_o[0] = ^(data_i & 22'h01496E);
    syndrome_o[1] = ^(data_i & 22'h02F20B);
    syndrome_o[2] = ^(data_i & 22'h048ED8);
    syndrome_o[3] = ^(data_i & 22'h087714);
    syndrome_o[4] = ^(data_i & 22'h10ACA5);
    syndrome_o[5] = ^(data_i & 22'h2011F3);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 6'h32) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'h23) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h19) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h7) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'h2c) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h31) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h25) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h34) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h29) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'he) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'h1c) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h15) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h2a) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h1a) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'hb) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h16) ^ data_i[15];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);

    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;

  endfunction

  function automatic logic [27:0]
      prim_secded_28_22_enc (logic [21:0] data_i);
    logic [27:0] data_o;
    data_o = 28'(data_i);
    data_o[22] = ^(data_o & 28'h03003FF);
    data_o[23] = ^(data_o & 28'h010FC0F);
    data_o[24] = ^(data_o & 28'h0271C71);
    data_o[25] = ^(data_o & 28'h03B6592);
    data_o[26] = ^(data_o & 28'h03DAAA4);
    data_o[27] = ^(data_o & 28'h03ED348);
    return data_o;
  endfunction

  function automatic secded_28_22_t
      prim_secded_28_22_dec (logic [27:0] data_i);
    logic [21:0] data_o;
    logic [5:0] syndrome_o;
    logic [1:0]  err_o;

    secded_28_22_t dec;

    // Syndrome calculation
    syndrome_o[0] = ^(data_i & 28'h07003FF);
    syndrome_o[1] = ^(data_i & 28'h090FC0F);
    syndrome_o[2] = ^(data_i & 28'h1271C71);
    syndrome_o[3] = ^(data_i & 28'h23B6592);
    syndrome_o[4] = ^(data_i & 28'h43DAAA4);
    syndrome_o[5] = ^(data_i & 28'h83ED348);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 6'h7) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'hb) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h13) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h23) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'hd) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h15) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h25) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h19) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h29) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'h31) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'he) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h16) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h26) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h1a) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'h2a) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h32) ^ data_i[15];
    data_o[16] = (syndrome_o == 6'h1c) ^ data_i[16];
    data_o[17] = (syndrome_o == 6'h2c) ^ data_i[17];
    data_o[18] = (syndrome_o == 6'h34) ^ data_i[18];
    data_o[19] = (syndrome_o == 6'h38) ^ data_i[19];
    data_o[20] = (syndrome_o == 6'h3b) ^ data_i[20];
    data_o[21] = (syndrome_o == 6'h3d) ^ data_i[21];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);

    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;

  endfunction

  function automatic logic [38:0]
      prim_secded_39_32_enc (logic [31:0] data_i);
    logic [38:0] data_o;
    data_o = 39'(data_i);
    data_o[32] = ^(data_o & 39'h002606BD25);
    data_o[33] = ^(data_o & 39'h00DEBA8050);
    data_o[34] = ^(data_o & 39'h00413D89AA);
    data_o[35] = ^(data_o & 39'h0031234ED1);
    data_o[36] = ^(data_o & 39'h00C2C1323B);
    data_o[37] = ^(data_o & 39'h002DCC624C);
    data_o[38] = ^(data_o & 39'h0098505586);
    return data_o;
  endfunction

  function automatic secded_39_32_t
      prim_secded_39_32_dec (logic [38:0] data_i);
    logic [31:0] data_o;
    logic [6:0] syndrome_o;
    logic [1:0]  err_o;

    secded_39_32_t dec;

    // Syndrome calculation
    syndrome_o[0] = ^(data_i & 39'h012606BD25);
    syndrome_o[1] = ^(data_i & 39'h02DEBA8050);
    syndrome_o[2] = ^(data_i & 39'h04413D89AA);
    syndrome_o[3] = ^(data_i & 39'h0831234ED1);
    syndrome_o[4] = ^(data_i & 39'h10C2C1323B);
    syndrome_o[5] = ^(data_i & 39'h202DCC624C);
    syndrome_o[6] = ^(data_i & 39'h4098505586);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 7'h19) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'h54) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h61) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h34) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h1a) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'h15) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h2a) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h4c) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h45) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h38) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h49) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'hd) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h51) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h31) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h68) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'h7) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h1c) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'hb) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h25) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h26) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h46) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'he) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h70) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h32) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h2c) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h13) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h23) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h62) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h4a) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h29) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h16) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h52) ^ data_i[31];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);

    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;

  endfunction

  function automatic logic [63:0]
      prim_secded_64_57_enc (logic [56:0] data_i);
    logic [63:0] data_o;
    data_o = 64'(data_i);
    data_o[57] = ^(data_o & 64'h0103FFF800007FFF);
    data_o[58] = ^(data_o & 64'h017C1FF801FF801F);
    data_o[59] = ^(data_o & 64'h01BDE1F87E0781E1);
    data_o[60] = ^(data_o & 64'h01DEEE3B8E388E22);
    data_o[61] = ^(data_o & 64'h01EF76CDB2C93244);
    data_o[62] = ^(data_o & 64'h01F7BB56D5525488);
    data_o[63] = ^(data_o & 64'h01FBDDA769A46910);
    return data_o;
  endfunction

  function automatic secded_64_57_t
      prim_secded_64_57_dec (logic [63:0] data_i);
    logic [56:0] data_o;
    logic [6:0] syndrome_o;
    logic [1:0]  err_o;

    secded_64_57_t dec;

    // Syndrome calculation
    syndrome_o[0] = ^(data_i & 64'h0303FFF800007FFF);
    syndrome_o[1] = ^(data_i & 64'h057C1FF801FF801F);
    syndrome_o[2] = ^(data_i & 64'h09BDE1F87E0781E1);
    syndrome_o[3] = ^(data_i & 64'h11DEEE3B8E388E22);
    syndrome_o[4] = ^(data_i & 64'h21EF76CDB2C93244);
    syndrome_o[5] = ^(data_i & 64'h41F7BB56D5525488);
    syndrome_o[6] = ^(data_i & 64'h81FBDDA769A46910);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 7'h7) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'hb) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h13) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h23) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h43) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'hd) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h15) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h25) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h45) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h19) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h29) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'h49) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h31) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h51) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h61) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'he) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h16) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'h26) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h46) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h1a) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h2a) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'h4a) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h32) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h52) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h62) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h1c) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h2c) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h4c) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h34) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h54) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h64) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h38) ^ data_i[31];
    data_o[32] = (syndrome_o == 7'h58) ^ data_i[32];
    data_o[33] = (syndrome_o == 7'h68) ^ data_i[33];
    data_o[34] = (syndrome_o == 7'h70) ^ data_i[34];
    data_o[35] = (syndrome_o == 7'h1f) ^ data_i[35];
    data_o[36] = (syndrome_o == 7'h2f) ^ data_i[36];
    data_o[37] = (syndrome_o == 7'h4f) ^ data_i[37];
    data_o[38] = (syndrome_o == 7'h37) ^ data_i[38];
    data_o[39] = (syndrome_o == 7'h57) ^ data_i[39];
    data_o[40] = (syndrome_o == 7'h67) ^ data_i[40];
    data_o[41] = (syndrome_o == 7'h3b) ^ data_i[41];
    data_o[42] = (syndrome_o == 7'h5b) ^ data_i[42];
    data_o[43] = (syndrome_o == 7'h6b) ^ data_i[43];
    data_o[44] = (syndrome_o == 7'h73) ^ data_i[44];
    data_o[45] = (syndrome_o == 7'h3d) ^ data_i[45];
    data_o[46] = (syndrome_o == 7'h5d) ^ data_i[46];
    data_o[47] = (syndrome_o == 7'h6d) ^ data_i[47];
    data_o[48] = (syndrome_o == 7'h75) ^ data_i[48];
    data_o[49] = (syndrome_o == 7'h79) ^ data_i[49];
    data_o[50] = (syndrome_o == 7'h3e) ^ data_i[50];
    data_o[51] = (syndrome_o == 7'h5e) ^ data_i[51];
    data_o[52] = (syndrome_o == 7'h6e) ^ data_i[52];
    data_o[53] = (syndrome_o == 7'h76) ^ data_i[53];
    data_o[54] = (syndrome_o == 7'h7a) ^ data_i[54];
    data_o[55] = (syndrome_o == 7'h7c) ^ data_i[55];
    data_o[56] = (syndrome_o == 7'h7f) ^ data_i[56];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);

    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;

  endfunction

  function automatic logic [71:0]
      prim_secded_72_64_enc (logic [63:0] data_i);
    logic [71:0] data_o;
    data_o = 72'(data_i);
    data_o[64] = ^(data_o & 72'h00B9000000001FFFFF);
    data_o[65] = ^(data_o & 72'h005E00000FFFE0003F);
    data_o[66] = ^(data_o & 72'h0067003FF003E007C1);
    data_o[67] = ^(data_o & 72'h00CD0FC0F03C207842);
    data_o[68] = ^(data_o & 72'h00B671C711C4438884);
    data_o[69] = ^(data_o & 72'h00B5B65926488C9108);
    data_o[70] = ^(data_o & 72'h00CBDAAA4A91152210);
    data_o[71] = ^(data_o & 72'h007AED348D221A4420);
    return data_o;
  endfunction

  function automatic secded_72_64_t
      prim_secded_72_64_dec (logic [71:0] data_i);
    logic [63:0] data_o;
    logic [7:0] syndrome_o;
    logic [1:0]  err_o;

    secded_72_64_t dec;

    // Syndrome calculation
    syndrome_o[0] = ^(data_i & 72'h01B9000000001FFFFF);
    syndrome_o[1] = ^(data_i & 72'h025E00000FFFE0003F);
    syndrome_o[2] = ^(data_i & 72'h0467003FF003E007C1);
    syndrome_o[3] = ^(data_i & 72'h08CD0FC0F03C207842);
    syndrome_o[4] = ^(data_i & 72'h10B671C711C4438884);
    syndrome_o[5] = ^(data_i & 72'h20B5B65926488C9108);
    syndrome_o[6] = ^(data_i & 72'h40CBDAAA4A91152210);
    syndrome_o[7] = ^(data_i & 72'h807AED348D221A4420);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 8'h7) ^ data_i[0];
    data_o[1] = (syndrome_o == 8'hb) ^ data_i[1];
    data_o[2] = (syndrome_o == 8'h13) ^ data_i[2];
    data_o[3] = (syndrome_o == 8'h23) ^ data_i[3];
    data_o[4] = (syndrome_o == 8'h43) ^ data_i[4];
    data_o[5] = (syndrome_o == 8'h83) ^ data_i[5];
    data_o[6] = (syndrome_o == 8'hd) ^ data_i[6];
    data_o[7] = (syndrome_o == 8'h15) ^ data_i[7];
    data_o[8] = (syndrome_o == 8'h25) ^ data_i[8];
    data_o[9] = (syndrome_o == 8'h45) ^ data_i[9];
    data_o[10] = (syndrome_o == 8'h85) ^ data_i[10];
    data_o[11] = (syndrome_o == 8'h19) ^ data_i[11];
    data_o[12] = (syndrome_o == 8'h29) ^ data_i[12];
    data_o[13] = (syndrome_o == 8'h49) ^ data_i[13];
    data_o[14] = (syndrome_o == 8'h89) ^ data_i[14];
    data_o[15] = (syndrome_o == 8'h31) ^ data_i[15];
    data_o[16] = (syndrome_o == 8'h51) ^ data_i[16];
    data_o[17] = (syndrome_o == 8'h91) ^ data_i[17];
    data_o[18] = (syndrome_o == 8'h61) ^ data_i[18];
    data_o[19] = (syndrome_o == 8'ha1) ^ data_i[19];
    data_o[20] = (syndrome_o == 8'hc1) ^ data_i[20];
    data_o[21] = (syndrome_o == 8'he) ^ data_i[21];
    data_o[22] = (syndrome_o == 8'h16) ^ data_i[22];
    data_o[23] = (syndrome_o == 8'h26) ^ data_i[23];
    data_o[24] = (syndrome_o == 8'h46) ^ data_i[24];
    data_o[25] = (syndrome_o == 8'h86) ^ data_i[25];
    data_o[26] = (syndrome_o == 8'h1a) ^ data_i[26];
    data_o[27] = (syndrome_o == 8'h2a) ^ data_i[27];
    data_o[28] = (syndrome_o == 8'h4a) ^ data_i[28];
    data_o[29] = (syndrome_o == 8'h8a) ^ data_i[29];
    data_o[30] = (syndrome_o == 8'h32) ^ data_i[30];
    data_o[31] = (syndrome_o == 8'h52) ^ data_i[31];
    data_o[32] = (syndrome_o == 8'h92) ^ data_i[32];
    data_o[33] = (syndrome_o == 8'h62) ^ data_i[33];
    data_o[34] = (syndrome_o == 8'ha2) ^ data_i[34];
    data_o[35] = (syndrome_o == 8'hc2) ^ data_i[35];
    data_o[36] = (syndrome_o == 8'h1c) ^ data_i[36];
    data_o[37] = (syndrome_o == 8'h2c) ^ data_i[37];
    data_o[38] = (syndrome_o == 8'h4c) ^ data_i[38];
    data_o[39] = (syndrome_o == 8'h8c) ^ data_i[39];
    data_o[40] = (syndrome_o == 8'h34) ^ data_i[40];
    data_o[41] = (syndrome_o == 8'h54) ^ data_i[41];
    data_o[42] = (syndrome_o == 8'h94) ^ data_i[42];
    data_o[43] = (syndrome_o == 8'h64) ^ data_i[43];
    data_o[44] = (syndrome_o == 8'ha4) ^ data_i[44];
    data_o[45] = (syndrome_o == 8'hc4) ^ data_i[45];
    data_o[46] = (syndrome_o == 8'h38) ^ data_i[46];
    data_o[47] = (syndrome_o == 8'h58) ^ data_i[47];
    data_o[48] = (syndrome_o == 8'h98) ^ data_i[48];
    data_o[49] = (syndrome_o == 8'h68) ^ data_i[49];
    data_o[50] = (syndrome_o == 8'ha8) ^ data_i[50];
    data_o[51] = (syndrome_o == 8'hc8) ^ data_i[51];
    data_o[52] = (syndrome_o == 8'h70) ^ data_i[52];
    data_o[53] = (syndrome_o == 8'hb0) ^ data_i[53];
    data_o[54] = (syndrome_o == 8'hd0) ^ data_i[54];
    data_o[55] = (syndrome_o == 8'he0) ^ data_i[55];
    data_o[56] = (syndrome_o == 8'h6d) ^ data_i[56];
    data_o[57] = (syndrome_o == 8'hd6) ^ data_i[57];
    data_o[58] = (syndrome_o == 8'h3e) ^ data_i[58];
    data_o[59] = (syndrome_o == 8'hcb) ^ data_i[59];
    data_o[60] = (syndrome_o == 8'hb3) ^ data_i[60];
    data_o[61] = (syndrome_o == 8'hb5) ^ data_i[61];
    data_o[62] = (syndrome_o == 8'hce) ^ data_i[62];
    data_o[63] = (syndrome_o == 8'h79) ^ data_i[63];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);

    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;

  endfunction

  function automatic logic [21:0]
      prim_secded_hamming_22_16_enc (logic [15:0] data_i);
    logic [21:0] data_o;
    data_o = 22'(data_i);
    data_o[16] = ^(data_o & 22'h00AD5B);
    data_o[17] = ^(data_o & 22'h00366D);
    data_o[18] = ^(data_o & 22'h00C78E);
    data_o[19] = ^(data_o & 22'h0007F0);
    data_o[20] = ^(data_o & 22'h00F800);
    data_o[21] = ^(data_o & 22'h1FFFFF);
    return data_o;
  endfunction

  function automatic secded_hamming_22_16_t
      prim_secded_hamming_22_16_dec (logic [21:0] data_i);
    logic [15:0] data_o;
    logic [5:0] syndrome_o;
    logic [1:0]  err_o;

    secded_hamming_22_16_t dec;

    // Syndrome calculation
    syndrome_o[0] = ^(data_i & 22'h01AD5B);
    syndrome_o[1] = ^(data_i & 22'h02366D);
    syndrome_o[2] = ^(data_i & 22'h04C78E);
    syndrome_o[3] = ^(data_i & 22'h0807F0);
    syndrome_o[4] = ^(data_i & 22'h10F800);
    syndrome_o[5] = ^(data_i & 22'h3FFFFF);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 6'h23) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'h25) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h26) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h27) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'h29) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h2a) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h2b) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h2c) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h2d) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'h2e) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'h2f) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h31) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h32) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h33) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'h34) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h35) ^ data_i[15];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = syndrome_o[5];
    err_o[1] = |syndrome_o[4:0] & ~syndrome_o[5];

    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;

  endfunction

  function automatic logic [38:0]
      prim_secded_hamming_39_32_enc (logic [31:0] data_i);
    logic [38:0] data_o;
    data_o = 39'(data_i);
    data_o[32] = ^(data_o & 39'h0056AAAD5B);
    data_o[33] = ^(data_o & 39'h009B33366D);
    data_o[34] = ^(data_o & 39'h00E3C3C78E);
    data_o[35] = ^(data_o & 39'h0003FC07F0);
    data_o[36] = ^(data_o & 39'h0003FFF800);
    data_o[37] = ^(data_o & 39'h00FC000000);
    data_o[38] = ^(data_o & 39'h3FFFFFFFFF);
    return data_o;
  endfunction

  function automatic secded_hamming_39_32_t
      prim_secded_hamming_39_32_dec (logic [38:0] data_i);
    logic [31:0] data_o;
    logic [6:0] syndrome_o;
    logic [1:0]  err_o;

    secded_hamming_39_32_t dec;

    // Syndrome calculation
    syndrome_o[0] = ^(data_i & 39'h0156AAAD5B);
    syndrome_o[1] = ^(data_i & 39'h029B33366D);
    syndrome_o[2] = ^(data_i & 39'h04E3C3C78E);
    syndrome_o[3] = ^(data_i & 39'h0803FC07F0);
    syndrome_o[4] = ^(data_i & 39'h1003FFF800);
    syndrome_o[5] = ^(data_i & 39'h20FC000000);
    syndrome_o[6] = ^(data_i & 39'h7FFFFFFFFF);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 7'h43) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'h45) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h46) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h47) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h49) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'h4a) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h4b) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h4c) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h4d) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h4e) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h4f) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'h51) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h52) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h53) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h54) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'h55) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h56) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'h57) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h58) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h59) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h5a) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'h5b) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h5c) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h5d) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h5e) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h5f) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h61) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h62) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h63) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h64) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h65) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h66) ^ data_i[31];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = syndrome_o[6];
    err_o[1] = |syndrome_o[5:0] & ~syndrome_o[6];

    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;

  endfunction

  function automatic logic [71:0]
      prim_secded_hamming_72_64_enc (logic [63:0] data_i);
    logic [71:0] data_o;
    data_o = 72'(data_i);
    data_o[64] = ^(data_o & 72'h00AB55555556AAAD5B);
    data_o[65] = ^(data_o & 72'h00CD9999999B33366D);
    data_o[66] = ^(data_o & 72'h00F1E1E1E1E3C3C78E);
    data_o[67] = ^(data_o & 72'h0001FE01FE03FC07F0);
    data_o[68] = ^(data_o & 72'h0001FFFE0003FFF800);
    data_o[69] = ^(data_o & 72'h0001FFFFFFFC000000);
    data_o[70] = ^(data_o & 72'h00FE00000000000000);
    data_o[71] = ^(data_o & 72'h7FFFFFFFFFFFFFFFFF);
    return data_o;
  endfunction

  function automatic secded_hamming_72_64_t
      prim_secded_hamming_72_64_dec (logic [71:0] data_i);
    logic [63:0] data_o;
    logic [7:0] syndrome_o;
    logic [1:0]  err_o;

    secded_hamming_72_64_t dec;

    // Syndrome calculation
    syndrome_o[0] = ^(data_i & 72'h01AB55555556AAAD5B);
    syndrome_o[1] = ^(data_i & 72'h02CD9999999B33366D);
    syndrome_o[2] = ^(data_i & 72'h04F1E1E1E1E3C3C78E);
    syndrome_o[3] = ^(data_i & 72'h0801FE01FE03FC07F0);
    syndrome_o[4] = ^(data_i & 72'h1001FFFE0003FFF800);
    syndrome_o[5] = ^(data_i & 72'h2001FFFFFFFC000000);
    syndrome_o[6] = ^(data_i & 72'h40FE00000000000000);
    syndrome_o[7] = ^(data_i & 72'hFFFFFFFFFFFFFFFFFF);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 8'h83) ^ data_i[0];
    data_o[1] = (syndrome_o == 8'h85) ^ data_i[1];
    data_o[2] = (syndrome_o == 8'h86) ^ data_i[2];
    data_o[3] = (syndrome_o == 8'h87) ^ data_i[3];
    data_o[4] = (syndrome_o == 8'h89) ^ data_i[4];
    data_o[5] = (syndrome_o == 8'h8a) ^ data_i[5];
    data_o[6] = (syndrome_o == 8'h8b) ^ data_i[6];
    data_o[7] = (syndrome_o == 8'h8c) ^ data_i[7];
    data_o[8] = (syndrome_o == 8'h8d) ^ data_i[8];
    data_o[9] = (syndrome_o == 8'h8e) ^ data_i[9];
    data_o[10] = (syndrome_o == 8'h8f) ^ data_i[10];
    data_o[11] = (syndrome_o == 8'h91) ^ data_i[11];
    data_o[12] = (syndrome_o == 8'h92) ^ data_i[12];
    data_o[13] = (syndrome_o == 8'h93) ^ data_i[13];
    data_o[14] = (syndrome_o == 8'h94) ^ data_i[14];
    data_o[15] = (syndrome_o == 8'h95) ^ data_i[15];
    data_o[16] = (syndrome_o == 8'h96) ^ data_i[16];
    data_o[17] = (syndrome_o == 8'h97) ^ data_i[17];
    data_o[18] = (syndrome_o == 8'h98) ^ data_i[18];
    data_o[19] = (syndrome_o == 8'h99) ^ data_i[19];
    data_o[20] = (syndrome_o == 8'h9a) ^ data_i[20];
    data_o[21] = (syndrome_o == 8'h9b) ^ data_i[21];
    data_o[22] = (syndrome_o == 8'h9c) ^ data_i[22];
    data_o[23] = (syndrome_o == 8'h9d) ^ data_i[23];
    data_o[24] = (syndrome_o == 8'h9e) ^ data_i[24];
    data_o[25] = (syndrome_o == 8'h9f) ^ data_i[25];
    data_o[26] = (syndrome_o == 8'ha1) ^ data_i[26];
    data_o[27] = (syndrome_o == 8'ha2) ^ data_i[27];
    data_o[28] = (syndrome_o == 8'ha3) ^ data_i[28];
    data_o[29] = (syndrome_o == 8'ha4) ^ data_i[29];
    data_o[30] = (syndrome_o == 8'ha5) ^ data_i[30];
    data_o[31] = (syndrome_o == 8'ha6) ^ data_i[31];
    data_o[32] = (syndrome_o == 8'ha7) ^ data_i[32];
    data_o[33] = (syndrome_o == 8'ha8) ^ data_i[33];
    data_o[34] = (syndrome_o == 8'ha9) ^ data_i[34];
    data_o[35] = (syndrome_o == 8'haa) ^ data_i[35];
    data_o[36] = (syndrome_o == 8'hab) ^ data_i[36];
    data_o[37] = (syndrome_o == 8'hac) ^ data_i[37];
    data_o[38] = (syndrome_o == 8'had) ^ data_i[38];
    data_o[39] = (syndrome_o == 8'hae) ^ data_i[39];
    data_o[40] = (syndrome_o == 8'haf) ^ data_i[40];
    data_o[41] = (syndrome_o == 8'hb0) ^ data_i[41];
    data_o[42] = (syndrome_o == 8'hb1) ^ data_i[42];
    data_o[43] = (syndrome_o == 8'hb2) ^ data_i[43];
    data_o[44] = (syndrome_o == 8'hb3) ^ data_i[44];
    data_o[45] = (syndrome_o == 8'hb4) ^ data_i[45];
    data_o[46] = (syndrome_o == 8'hb5) ^ data_i[46];
    data_o[47] = (syndrome_o == 8'hb6) ^ data_i[47];
    data_o[48] = (syndrome_o == 8'hb7) ^ data_i[48];
    data_o[49] = (syndrome_o == 8'hb8) ^ data_i[49];
    data_o[50] = (syndrome_o == 8'hb9) ^ data_i[50];
    data_o[51] = (syndrome_o == 8'hba) ^ data_i[51];
    data_o[52] = (syndrome_o == 8'hbb) ^ data_i[52];
    data_o[53] = (syndrome_o == 8'hbc) ^ data_i[53];
    data_o[54] = (syndrome_o == 8'hbd) ^ data_i[54];
    data_o[55] = (syndrome_o == 8'hbe) ^ data_i[55];
    data_o[56] = (syndrome_o == 8'hbf) ^ data_i[56];
    data_o[57] = (syndrome_o == 8'hc1) ^ data_i[57];
    data_o[58] = (syndrome_o == 8'hc2) ^ data_i[58];
    data_o[59] = (syndrome_o == 8'hc3) ^ data_i[59];
    data_o[60] = (syndrome_o == 8'hc4) ^ data_i[60];
    data_o[61] = (syndrome_o == 8'hc5) ^ data_i[61];
    data_o[62] = (syndrome_o == 8'hc6) ^ data_i[62];
    data_o[63] = (syndrome_o == 8'hc7) ^ data_i[63];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = syndrome_o[7];
    err_o[1] = |syndrome_o[6:0] & ~syndrome_o[7];

    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;

  endfunction

  function automatic logic [75:0]
      prim_secded_hamming_76_68_enc (logic [67:0] data_i);
    logic [75:0] data_o;
    data_o = 76'(data_i);
    data_o[68] = ^(data_o & 76'h00AAB55555556AAAD5B);
    data_o[69] = ^(data_o & 76'h00CCD9999999B33366D);
    data_o[70] = ^(data_o & 76'h000F1E1E1E1E3C3C78E);
    data_o[71] = ^(data_o & 76'h00F01FE01FE03FC07F0);
    data_o[72] = ^(data_o & 76'h00001FFFE0003FFF800);
    data_o[73] = ^(data_o & 76'h00001FFFFFFFC000000);
    data_o[74] = ^(data_o & 76'h00FFE00000000000000);
    data_o[75] = ^(data_o & 76'h7FFFFFFFFFFFFFFFFFF);
    return data_o;
  endfunction

  function automatic secded_hamming_76_68_t
      prim_secded_hamming_76_68_dec (logic [75:0] data_i);
    logic [67:0] data_o;
    logic [7:0] syndrome_o;
    logic [1:0]  err_o;

    secded_hamming_76_68_t dec;

    // Syndrome calculation
    syndrome_o[0] = ^(data_i & 76'h01AAB55555556AAAD5B);
    syndrome_o[1] = ^(data_i & 76'h02CCD9999999B33366D);
    syndrome_o[2] = ^(data_i & 76'h040F1E1E1E1E3C3C78E);
    syndrome_o[3] = ^(data_i & 76'h08F01FE01FE03FC07F0);
    syndrome_o[4] = ^(data_i & 76'h10001FFFE0003FFF800);
    syndrome_o[5] = ^(data_i & 76'h20001FFFFFFFC000000);
    syndrome_o[6] = ^(data_i & 76'h40FFE00000000000000);
    syndrome_o[7] = ^(data_i & 76'hFFFFFFFFFFFFFFFFFFF);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 8'h83) ^ data_i[0];
    data_o[1] = (syndrome_o == 8'h85) ^ data_i[1];
    data_o[2] = (syndrome_o == 8'h86) ^ data_i[2];
    data_o[3] = (syndrome_o == 8'h87) ^ data_i[3];
    data_o[4] = (syndrome_o == 8'h89) ^ data_i[4];
    data_o[5] = (syndrome_o == 8'h8a) ^ data_i[5];
    data_o[6] = (syndrome_o == 8'h8b) ^ data_i[6];
    data_o[7] = (syndrome_o == 8'h8c) ^ data_i[7];
    data_o[8] = (syndrome_o == 8'h8d) ^ data_i[8];
    data_o[9] = (syndrome_o == 8'h8e) ^ data_i[9];
    data_o[10] = (syndrome_o == 8'h8f) ^ data_i[10];
    data_o[11] = (syndrome_o == 8'h91) ^ data_i[11];
    data_o[12] = (syndrome_o == 8'h92) ^ data_i[12];
    data_o[13] = (syndrome_o == 8'h93) ^ data_i[13];
    data_o[14] = (syndrome_o == 8'h94) ^ data_i[14];
    data_o[15] = (syndrome_o == 8'h95) ^ data_i[15];
    data_o[16] = (syndrome_o == 8'h96) ^ data_i[16];
    data_o[17] = (syndrome_o == 8'h97) ^ data_i[17];
    data_o[18] = (syndrome_o == 8'h98) ^ data_i[18];
    data_o[19] = (syndrome_o == 8'h99) ^ data_i[19];
    data_o[20] = (syndrome_o == 8'h9a) ^ data_i[20];
    data_o[21] = (syndrome_o == 8'h9b) ^ data_i[21];
    data_o[22] = (syndrome_o == 8'h9c) ^ data_i[22];
    data_o[23] = (syndrome_o == 8'h9d) ^ data_i[23];
    data_o[24] = (syndrome_o == 8'h9e) ^ data_i[24];
    data_o[25] = (syndrome_o == 8'h9f) ^ data_i[25];
    data_o[26] = (syndrome_o == 8'ha1) ^ data_i[26];
    data_o[27] = (syndrome_o == 8'ha2) ^ data_i[27];
    data_o[28] = (syndrome_o == 8'ha3) ^ data_i[28];
    data_o[29] = (syndrome_o == 8'ha4) ^ data_i[29];
    data_o[30] = (syndrome_o == 8'ha5) ^ data_i[30];
    data_o[31] = (syndrome_o == 8'ha6) ^ data_i[31];
    data_o[32] = (syndrome_o == 8'ha7) ^ data_i[32];
    data_o[33] = (syndrome_o == 8'ha8) ^ data_i[33];
    data_o[34] = (syndrome_o == 8'ha9) ^ data_i[34];
    data_o[35] = (syndrome_o == 8'haa) ^ data_i[35];
    data_o[36] = (syndrome_o == 8'hab) ^ data_i[36];
    data_o[37] = (syndrome_o == 8'hac) ^ data_i[37];
    data_o[38] = (syndrome_o == 8'had) ^ data_i[38];
    data_o[39] = (syndrome_o == 8'hae) ^ data_i[39];
    data_o[40] = (syndrome_o == 8'haf) ^ data_i[40];
    data_o[41] = (syndrome_o == 8'hb0) ^ data_i[41];
    data_o[42] = (syndrome_o == 8'hb1) ^ data_i[42];
    data_o[43] = (syndrome_o == 8'hb2) ^ data_i[43];
    data_o[44] = (syndrome_o == 8'hb3) ^ data_i[44];
    data_o[45] = (syndrome_o == 8'hb4) ^ data_i[45];
    data_o[46] = (syndrome_o == 8'hb5) ^ data_i[46];
    data_o[47] = (syndrome_o == 8'hb6) ^ data_i[47];
    data_o[48] = (syndrome_o == 8'hb7) ^ data_i[48];
    data_o[49] = (syndrome_o == 8'hb8) ^ data_i[49];
    data_o[50] = (syndrome_o == 8'hb9) ^ data_i[50];
    data_o[51] = (syndrome_o == 8'hba) ^ data_i[51];
    data_o[52] = (syndrome_o == 8'hbb) ^ data_i[52];
    data_o[53] = (syndrome_o == 8'hbc) ^ data_i[53];
    data_o[54] = (syndrome_o == 8'hbd) ^ data_i[54];
    data_o[55] = (syndrome_o == 8'hbe) ^ data_i[55];
    data_o[56] = (syndrome_o == 8'hbf) ^ data_i[56];
    data_o[57] = (syndrome_o == 8'hc1) ^ data_i[57];
    data_o[58] = (syndrome_o == 8'hc2) ^ data_i[58];
    data_o[59] = (syndrome_o == 8'hc3) ^ data_i[59];
    data_o[60] = (syndrome_o == 8'hc4) ^ data_i[60];
    data_o[61] = (syndrome_o == 8'hc5) ^ data_i[61];
    data_o[62] = (syndrome_o == 8'hc6) ^ data_i[62];
    data_o[63] = (syndrome_o == 8'hc7) ^ data_i[63];
    data_o[64] = (syndrome_o == 8'hc8) ^ data_i[64];
    data_o[65] = (syndrome_o == 8'hc9) ^ data_i[65];
    data_o[66] = (syndrome_o == 8'hca) ^ data_i[66];
    data_o[67] = (syndrome_o == 8'hcb) ^ data_i[67];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = syndrome_o[7];
    err_o[1] = |syndrome_o[6:0] & ~syndrome_o[7];

    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;

  endfunction

  function automatic logic [21:0]
      prim_secded_inv_22_16_enc (logic [15:0] data_i);
    logic [21:0] data_o;
    data_o = 22'(data_i);
    data_o[16] = ^(data_o & 22'h00496E);
    data_o[17] = ^(data_o & 22'h00F20B);
    data_o[18] = ^(data_o & 22'h008ED8);
    data_o[19] = ^(data_o & 22'h007714);
    data_o[20] = ^(data_o & 22'h00ACA5);
    data_o[21] = ^(data_o & 22'h0011F3);
    data_o ^= 22'h2A0000;
    return data_o;
  endfunction

  function automatic secded_inv_22_16_t
      prim_secded_inv_22_16_dec (logic [21:0] data_i);
    logic [15:0] data_o;
    logic [5:0] syndrome_o;
    logic [1:0]  err_o;

    secded_inv_22_16_t dec;

    // Syndrome calculation
    syndrome_o[0] = ^((data_i ^ 22'h2A0000) & 22'h01496E);
    syndrome_o[1] = ^((data_i ^ 22'h2A0000) & 22'h02F20B);
    syndrome_o[2] = ^((data_i ^ 22'h2A0000) & 22'h048ED8);
    syndrome_o[3] = ^((data_i ^ 22'h2A0000) & 22'h087714);
    syndrome_o[4] = ^((data_i ^ 22'h2A0000) & 22'h10ACA5);
    syndrome_o[5] = ^((data_i ^ 22'h2A0000) & 22'h2011F3);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 6'h32) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'h23) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h19) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h7) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'h2c) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h31) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h25) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h34) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h29) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'he) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'h1c) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h15) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h2a) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h1a) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'hb) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h16) ^ data_i[15];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);

    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;

  endfunction

  function automatic logic [27:0]
      prim_secded_inv_28_22_enc (logic [21:0] data_i);
    logic [27:0] data_o;
    data_o = 28'(data_i);
    data_o[22] = ^(data_o & 28'h03003FF);
    data_o[23] = ^(data_o & 28'h010FC0F);
    data_o[24] = ^(data_o & 28'h0271C71);
    data_o[25] = ^(data_o & 28'h03B6592);
    data_o[26] = ^(data_o & 28'h03DAAA4);
    data_o[27] = ^(data_o & 28'h03ED348);
    data_o ^= 28'hA800000;
    return data_o;
  endfunction

  function automatic secded_inv_28_22_t
      prim_secded_inv_28_22_dec (logic [27:0] data_i);
    logic [21:0] data_o;
    logic [5:0] syndrome_o;
    logic [1:0]  err_o;

    secded_inv_28_22_t dec;

    // Syndrome calculation
    syndrome_o[0] = ^((data_i ^ 28'hA800000) & 28'h07003FF);
    syndrome_o[1] = ^((data_i ^ 28'hA800000) & 28'h090FC0F);
    syndrome_o[2] = ^((data_i ^ 28'hA800000) & 28'h1271C71);
    syndrome_o[3] = ^((data_i ^ 28'hA800000) & 28'h23B6592);
    syndrome_o[4] = ^((data_i ^ 28'hA800000) & 28'h43DAAA4);
    syndrome_o[5] = ^((data_i ^ 28'hA800000) & 28'h83ED348);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 6'h7) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'hb) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h13) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h23) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'hd) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h15) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h25) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h19) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h29) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'h31) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'he) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h16) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h26) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h1a) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'h2a) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h32) ^ data_i[15];
    data_o[16] = (syndrome_o == 6'h1c) ^ data_i[16];
    data_o[17] = (syndrome_o == 6'h2c) ^ data_i[17];
    data_o[18] = (syndrome_o == 6'h34) ^ data_i[18];
    data_o[19] = (syndrome_o == 6'h38) ^ data_i[19];
    data_o[20] = (syndrome_o == 6'h3b) ^ data_i[20];
    data_o[21] = (syndrome_o == 6'h3d) ^ data_i[21];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);

    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;

  endfunction

  function automatic logic [38:0]
      prim_secded_inv_39_32_enc (logic [31:0] data_i);
    logic [38:0] data_o;
    data_o = 39'(data_i);
    data_o[32] = ^(data_o & 39'h002606BD25);
    data_o[33] = ^(data_o & 39'h00DEBA8050);
    data_o[34] = ^(data_o & 39'h00413D89AA);
    data_o[35] = ^(data_o & 39'h0031234ED1);
    data_o[36] = ^(data_o & 39'h00C2C1323B);
    data_o[37] = ^(data_o & 39'h002DCC624C);
    data_o[38] = ^(data_o & 39'h0098505586);
    data_o ^= 39'h2A00000000;
    return data_o;
  endfunction

  function automatic secded_inv_39_32_t
      prim_secded_inv_39_32_dec (logic [38:0] data_i);
    logic [31:0] data_o;
    logic [6:0] syndrome_o;
    logic [1:0]  err_o;

    secded_inv_39_32_t dec;

    // Syndrome calculation
    syndrome_o[0] = ^((data_i ^ 39'h2A00000000) & 39'h012606BD25);
    syndrome_o[1] = ^((data_i ^ 39'h2A00000000) & 39'h02DEBA8050);
    syndrome_o[2] = ^((data_i ^ 39'h2A00000000) & 39'h04413D89AA);
    syndrome_o[3] = ^((data_i ^ 39'h2A00000000) & 39'h0831234ED1);
    syndrome_o[4] = ^((data_i ^ 39'h2A00000000) & 39'h10C2C1323B);
    syndrome_o[5] = ^((data_i ^ 39'h2A00000000) & 39'h202DCC624C);
    syndrome_o[6] = ^((data_i ^ 39'h2A00000000) & 39'h4098505586);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 7'h19) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'h54) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h61) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h34) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h1a) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'h15) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h2a) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h4c) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h45) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h38) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h49) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'hd) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h51) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h31) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h68) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'h7) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h1c) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'hb) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h25) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h26) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h46) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'he) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h70) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h32) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h2c) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h13) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h23) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h62) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h4a) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h29) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h16) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h52) ^ data_i[31];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);

    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;

  endfunction

  function automatic logic [63:0]
      prim_secded_inv_64_57_enc (logic [56:0] data_i);
    logic [63:0] data_o;
    data_o = 64'(data_i);
    data_o[57] = ^(data_o & 64'h0103FFF800007FFF);
    data_o[58] = ^(data_o & 64'h017C1FF801FF801F);
    data_o[59] = ^(data_o & 64'h01BDE1F87E0781E1);
    data_o[60] = ^(data_o & 64'h01DEEE3B8E388E22);
    data_o[61] = ^(data_o & 64'h01EF76CDB2C93244);
    data_o[62] = ^(data_o & 64'h01F7BB56D5525488);
    data_o[63] = ^(data_o & 64'h01FBDDA769A46910);
    data_o ^= 64'h5400000000000000;
    return data_o;
  endfunction

  function automatic secded_inv_64_57_t
      prim_secded_inv_64_57_dec (logic [63:0] data_i);
    logic [56:0] data_o;
    logic [6:0] syndrome_o;
    logic [1:0]  err_o;

    secded_inv_64_57_t dec;

    // Syndrome calculation
    syndrome_o[0] = ^((data_i ^ 64'h5400000000000000) & 64'h0303FFF800007FFF);
    syndrome_o[1] = ^((data_i ^ 64'h5400000000000000) & 64'h057C1FF801FF801F);
    syndrome_o[2] = ^((data_i ^ 64'h5400000000000000) & 64'h09BDE1F87E0781E1);
    syndrome_o[3] = ^((data_i ^ 64'h5400000000000000) & 64'h11DEEE3B8E388E22);
    syndrome_o[4] = ^((data_i ^ 64'h5400000000000000) & 64'h21EF76CDB2C93244);
    syndrome_o[5] = ^((data_i ^ 64'h5400000000000000) & 64'h41F7BB56D5525488);
    syndrome_o[6] = ^((data_i ^ 64'h5400000000000000) & 64'h81FBDDA769A46910);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 7'h7) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'hb) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h13) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h23) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h43) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'hd) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h15) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h25) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h45) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h19) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h29) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'h49) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h31) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h51) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h61) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'he) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h16) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'h26) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h46) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h1a) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h2a) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'h4a) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h32) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h52) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h62) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h1c) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h2c) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h4c) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h34) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h54) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h64) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h38) ^ data_i[31];
    data_o[32] = (syndrome_o == 7'h58) ^ data_i[32];
    data_o[33] = (syndrome_o == 7'h68) ^ data_i[33];
    data_o[34] = (syndrome_o == 7'h70) ^ data_i[34];
    data_o[35] = (syndrome_o == 7'h1f) ^ data_i[35];
    data_o[36] = (syndrome_o == 7'h2f) ^ data_i[36];
    data_o[37] = (syndrome_o == 7'h4f) ^ data_i[37];
    data_o[38] = (syndrome_o == 7'h37) ^ data_i[38];
    data_o[39] = (syndrome_o == 7'h57) ^ data_i[39];
    data_o[40] = (syndrome_o == 7'h67) ^ data_i[40];
    data_o[41] = (syndrome_o == 7'h3b) ^ data_i[41];
    data_o[42] = (syndrome_o == 7'h5b) ^ data_i[42];
    data_o[43] = (syndrome_o == 7'h6b) ^ data_i[43];
    data_o[44] = (syndrome_o == 7'h73) ^ data_i[44];
    data_o[45] = (syndrome_o == 7'h3d) ^ data_i[45];
    data_o[46] = (syndrome_o == 7'h5d) ^ data_i[46];
    data_o[47] = (syndrome_o == 7'h6d) ^ data_i[47];
    data_o[48] = (syndrome_o == 7'h75) ^ data_i[48];
    data_o[49] = (syndrome_o == 7'h79) ^ data_i[49];
    data_o[50] = (syndrome_o == 7'h3e) ^ data_i[50];
    data_o[51] = (syndrome_o == 7'h5e) ^ data_i[51];
    data_o[52] = (syndrome_o == 7'h6e) ^ data_i[52];
    data_o[53] = (syndrome_o == 7'h76) ^ data_i[53];
    data_o[54] = (syndrome_o == 7'h7a) ^ data_i[54];
    data_o[55] = (syndrome_o == 7'h7c) ^ data_i[55];
    data_o[56] = (syndrome_o == 7'h7f) ^ data_i[56];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);

    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;

  endfunction

  function automatic logic [71:0]
      prim_secded_inv_72_64_enc (logic [63:0] data_i);
    logic [71:0] data_o;
    data_o = 72'(data_i);
    data_o[64] = ^(data_o & 72'h00B9000000001FFFFF);
    data_o[65] = ^(data_o & 72'h005E00000FFFE0003F);
    data_o[66] = ^(data_o & 72'h0067003FF003E007C1);
    data_o[67] = ^(data_o & 72'h00CD0FC0F03C207842);
    data_o[68] = ^(data_o & 72'h00B671C711C4438884);
    data_o[69] = ^(data_o & 72'h00B5B65926488C9108);
    data_o[70] = ^(data_o & 72'h00CBDAAA4A91152210);
    data_o[71] = ^(data_o & 72'h007AED348D221A4420);
    data_o ^= 72'hAA0000000000000000;
    return data_o;
  endfunction

  function automatic secded_inv_72_64_t
      prim_secded_inv_72_64_dec (logic [71:0] data_i);
    logic [63:0] data_o;
    logic [7:0] syndrome_o;
    logic [1:0]  err_o;

    secded_inv_72_64_t dec;

    // Syndrome calculation
    syndrome_o[0] = ^((data_i ^ 72'hAA0000000000000000) & 72'h01B9000000001FFFFF);
    syndrome_o[1] = ^((data_i ^ 72'hAA0000000000000000) & 72'h025E00000FFFE0003F);
    syndrome_o[2] = ^((data_i ^ 72'hAA0000000000000000) & 72'h0467003FF003E007C1);
    syndrome_o[3] = ^((data_i ^ 72'hAA0000000000000000) & 72'h08CD0FC0F03C207842);
    syndrome_o[4] = ^((data_i ^ 72'hAA0000000000000000) & 72'h10B671C711C4438884);
    syndrome_o[5] = ^((data_i ^ 72'hAA0000000000000000) & 72'h20B5B65926488C9108);
    syndrome_o[6] = ^((data_i ^ 72'hAA0000000000000000) & 72'h40CBDAAA4A91152210);
    syndrome_o[7] = ^((data_i ^ 72'hAA0000000000000000) & 72'h807AED348D221A4420);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 8'h7) ^ data_i[0];
    data_o[1] = (syndrome_o == 8'hb) ^ data_i[1];
    data_o[2] = (syndrome_o == 8'h13) ^ data_i[2];
    data_o[3] = (syndrome_o == 8'h23) ^ data_i[3];
    data_o[4] = (syndrome_o == 8'h43) ^ data_i[4];
    data_o[5] = (syndrome_o == 8'h83) ^ data_i[5];
    data_o[6] = (syndrome_o == 8'hd) ^ data_i[6];
    data_o[7] = (syndrome_o == 8'h15) ^ data_i[7];
    data_o[8] = (syndrome_o == 8'h25) ^ data_i[8];
    data_o[9] = (syndrome_o == 8'h45) ^ data_i[9];
    data_o[10] = (syndrome_o == 8'h85) ^ data_i[10];
    data_o[11] = (syndrome_o == 8'h19) ^ data_i[11];
    data_o[12] = (syndrome_o == 8'h29) ^ data_i[12];
    data_o[13] = (syndrome_o == 8'h49) ^ data_i[13];
    data_o[14] = (syndrome_o == 8'h89) ^ data_i[14];
    data_o[15] = (syndrome_o == 8'h31) ^ data_i[15];
    data_o[16] = (syndrome_o == 8'h51) ^ data_i[16];
    data_o[17] = (syndrome_o == 8'h91) ^ data_i[17];
    data_o[18] = (syndrome_o == 8'h61) ^ data_i[18];
    data_o[19] = (syndrome_o == 8'ha1) ^ data_i[19];
    data_o[20] = (syndrome_o == 8'hc1) ^ data_i[20];
    data_o[21] = (syndrome_o == 8'he) ^ data_i[21];
    data_o[22] = (syndrome_o == 8'h16) ^ data_i[22];
    data_o[23] = (syndrome_o == 8'h26) ^ data_i[23];
    data_o[24] = (syndrome_o == 8'h46) ^ data_i[24];
    data_o[25] = (syndrome_o == 8'h86) ^ data_i[25];
    data_o[26] = (syndrome_o == 8'h1a) ^ data_i[26];
    data_o[27] = (syndrome_o == 8'h2a) ^ data_i[27];
    data_o[28] = (syndrome_o == 8'h4a) ^ data_i[28];
    data_o[29] = (syndrome_o == 8'h8a) ^ data_i[29];
    data_o[30] = (syndrome_o == 8'h32) ^ data_i[30];
    data_o[31] = (syndrome_o == 8'h52) ^ data_i[31];
    data_o[32] = (syndrome_o == 8'h92) ^ data_i[32];
    data_o[33] = (syndrome_o == 8'h62) ^ data_i[33];
    data_o[34] = (syndrome_o == 8'ha2) ^ data_i[34];
    data_o[35] = (syndrome_o == 8'hc2) ^ data_i[35];
    data_o[36] = (syndrome_o == 8'h1c) ^ data_i[36];
    data_o[37] = (syndrome_o == 8'h2c) ^ data_i[37];
    data_o[38] = (syndrome_o == 8'h4c) ^ data_i[38];
    data_o[39] = (syndrome_o == 8'h8c) ^ data_i[39];
    data_o[40] = (syndrome_o == 8'h34) ^ data_i[40];
    data_o[41] = (syndrome_o == 8'h54) ^ data_i[41];
    data_o[42] = (syndrome_o == 8'h94) ^ data_i[42];
    data_o[43] = (syndrome_o == 8'h64) ^ data_i[43];
    data_o[44] = (syndrome_o == 8'ha4) ^ data_i[44];
    data_o[45] = (syndrome_o == 8'hc4) ^ data_i[45];
    data_o[46] = (syndrome_o == 8'h38) ^ data_i[46];
    data_o[47] = (syndrome_o == 8'h58) ^ data_i[47];
    data_o[48] = (syndrome_o == 8'h98) ^ data_i[48];
    data_o[49] = (syndrome_o == 8'h68) ^ data_i[49];
    data_o[50] = (syndrome_o == 8'ha8) ^ data_i[50];
    data_o[51] = (syndrome_o == 8'hc8) ^ data_i[51];
    data_o[52] = (syndrome_o == 8'h70) ^ data_i[52];
    data_o[53] = (syndrome_o == 8'hb0) ^ data_i[53];
    data_o[54] = (syndrome_o == 8'hd0) ^ data_i[54];
    data_o[55] = (syndrome_o == 8'he0) ^ data_i[55];
    data_o[56] = (syndrome_o == 8'h6d) ^ data_i[56];
    data_o[57] = (syndrome_o == 8'hd6) ^ data_i[57];
    data_o[58] = (syndrome_o == 8'h3e) ^ data_i[58];
    data_o[59] = (syndrome_o == 8'hcb) ^ data_i[59];
    data_o[60] = (syndrome_o == 8'hb3) ^ data_i[60];
    data_o[61] = (syndrome_o == 8'hb5) ^ data_i[61];
    data_o[62] = (syndrome_o == 8'hce) ^ data_i[62];
    data_o[63] = (syndrome_o == 8'h79) ^ data_i[63];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);

    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;

  endfunction

  function automatic logic [21:0]
      prim_secded_inv_hamming_22_16_enc (logic [15:0] data_i);
    logic [21:0] data_o;
    data_o = 22'(data_i);
    data_o[16] = ^(data_o & 22'h00AD5B);
    data_o[17] = ^(data_o & 22'h00366D);
    data_o[18] = ^(data_o & 22'h00C78E);
    data_o[19] = ^(data_o & 22'h0007F0);
    data_o[20] = ^(data_o & 22'h00F800);
    data_o[21] = ^(data_o & 22'h1FFFFF);
    data_o ^= 22'h2A0000;
    return data_o;
  endfunction

  function automatic secded_inv_hamming_22_16_t
      prim_secded_inv_hamming_22_16_dec (logic [21:0] data_i);
    logic [15:0] data_o;
    logic [5:0] syndrome_o;
    logic [1:0]  err_o;

    secded_inv_hamming_22_16_t dec;

    // Syndrome calculation
    syndrome_o[0] = ^((data_i ^ 22'h2A0000) & 22'h01AD5B);
    syndrome_o[1] = ^((data_i ^ 22'h2A0000) & 22'h02366D);
    syndrome_o[2] = ^((data_i ^ 22'h2A0000) & 22'h04C78E);
    syndrome_o[3] = ^((data_i ^ 22'h2A0000) & 22'h0807F0);
    syndrome_o[4] = ^((data_i ^ 22'h2A0000) & 22'h10F800);
    syndrome_o[5] = ^((data_i ^ 22'h2A0000) & 22'h3FFFFF);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 6'h23) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'h25) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h26) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h27) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'h29) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h2a) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h2b) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h2c) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h2d) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'h2e) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'h2f) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h31) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h32) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h33) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'h34) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h35) ^ data_i[15];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = syndrome_o[5];
    err_o[1] = |syndrome_o[4:0] & ~syndrome_o[5];

    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;

  endfunction

  function automatic logic [38:0]
      prim_secded_inv_hamming_39_32_enc (logic [31:0] data_i);
    logic [38:0] data_o;
    data_o = 39'(data_i);
    data_o[32] = ^(data_o & 39'h0056AAAD5B);
    data_o[33] = ^(data_o & 39'h009B33366D);
    data_o[34] = ^(data_o & 39'h00E3C3C78E);
    data_o[35] = ^(data_o & 39'h0003FC07F0);
    data_o[36] = ^(data_o & 39'h0003FFF800);
    data_o[37] = ^(data_o & 39'h00FC000000);
    data_o[38] = ^(data_o & 39'h3FFFFFFFFF);
    data_o ^= 39'h2A00000000;
    return data_o;
  endfunction

  function automatic secded_inv_hamming_39_32_t
      prim_secded_inv_hamming_39_32_dec (logic [38:0] data_i);
    logic [31:0] data_o;
    logic [6:0] syndrome_o;
    logic [1:0]  err_o;

    secded_inv_hamming_39_32_t dec;

    // Syndrome calculation
    syndrome_o[0] = ^((data_i ^ 39'h2A00000000) & 39'h0156AAAD5B);
    syndrome_o[1] = ^((data_i ^ 39'h2A00000000) & 39'h029B33366D);
    syndrome_o[2] = ^((data_i ^ 39'h2A00000000) & 39'h04E3C3C78E);
    syndrome_o[3] = ^((data_i ^ 39'h2A00000000) & 39'h0803FC07F0);
    syndrome_o[4] = ^((data_i ^ 39'h2A00000000) & 39'h1003FFF800);
    syndrome_o[5] = ^((data_i ^ 39'h2A00000000) & 39'h20FC000000);
    syndrome_o[6] = ^((data_i ^ 39'h2A00000000) & 39'h7FFFFFFFFF);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 7'h43) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'h45) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h46) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h47) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h49) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'h4a) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h4b) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h4c) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h4d) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h4e) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h4f) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'h51) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h52) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h53) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h54) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'h55) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h56) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'h57) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h58) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h59) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h5a) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'h5b) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h5c) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h5d) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h5e) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h5f) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h61) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h62) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h63) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h64) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h65) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h66) ^ data_i[31];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = syndrome_o[6];
    err_o[1] = |syndrome_o[5:0] & ~syndrome_o[6];

    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;

  endfunction

  function automatic logic [71:0]
      prim_secded_inv_hamming_72_64_enc (logic [63:0] data_i);
    logic [71:0] data_o;
    data_o = 72'(data_i);
    data_o[64] = ^(data_o & 72'h00AB55555556AAAD5B);
    data_o[65] = ^(data_o & 72'h00CD9999999B33366D);
    data_o[66] = ^(data_o & 72'h00F1E1E1E1E3C3C78E);
    data_o[67] = ^(data_o & 72'h0001FE01FE03FC07F0);
    data_o[68] = ^(data_o & 72'h0001FFFE0003FFF800);
    data_o[69] = ^(data_o & 72'h0001FFFFFFFC000000);
    data_o[70] = ^(data_o & 72'h00FE00000000000000);
    data_o[71] = ^(data_o & 72'h7FFFFFFFFFFFFFFFFF);
    data_o ^= 72'hAA0000000000000000;
    return data_o;
  endfunction

  function automatic secded_inv_hamming_72_64_t
      prim_secded_inv_hamming_72_64_dec (logic [71:0] data_i);
    logic [63:0] data_o;
    logic [7:0] syndrome_o;
    logic [1:0]  err_o;

    secded_inv_hamming_72_64_t dec;

    // Syndrome calculation
    syndrome_o[0] = ^((data_i ^ 72'hAA0000000000000000) & 72'h01AB55555556AAAD5B);
    syndrome_o[1] = ^((data_i ^ 72'hAA0000000000000000) & 72'h02CD9999999B33366D);
    syndrome_o[2] = ^((data_i ^ 72'hAA0000000000000000) & 72'h04F1E1E1E1E3C3C78E);
    syndrome_o[3] = ^((data_i ^ 72'hAA0000000000000000) & 72'h0801FE01FE03FC07F0);
    syndrome_o[4] = ^((data_i ^ 72'hAA0000000000000000) & 72'h1001FFFE0003FFF800);
    syndrome_o[5] = ^((data_i ^ 72'hAA0000000000000000) & 72'h2001FFFFFFFC000000);
    syndrome_o[6] = ^((data_i ^ 72'hAA0000000000000000) & 72'h40FE00000000000000);
    syndrome_o[7] = ^((data_i ^ 72'hAA0000000000000000) & 72'hFFFFFFFFFFFFFFFFFF);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 8'h83) ^ data_i[0];
    data_o[1] = (syndrome_o == 8'h85) ^ data_i[1];
    data_o[2] = (syndrome_o == 8'h86) ^ data_i[2];
    data_o[3] = (syndrome_o == 8'h87) ^ data_i[3];
    data_o[4] = (syndrome_o == 8'h89) ^ data_i[4];
    data_o[5] = (syndrome_o == 8'h8a) ^ data_i[5];
    data_o[6] = (syndrome_o == 8'h8b) ^ data_i[6];
    data_o[7] = (syndrome_o == 8'h8c) ^ data_i[7];
    data_o[8] = (syndrome_o == 8'h8d) ^ data_i[8];
    data_o[9] = (syndrome_o == 8'h8e) ^ data_i[9];
    data_o[10] = (syndrome_o == 8'h8f) ^ data_i[10];
    data_o[11] = (syndrome_o == 8'h91) ^ data_i[11];
    data_o[12] = (syndrome_o == 8'h92) ^ data_i[12];
    data_o[13] = (syndrome_o == 8'h93) ^ data_i[13];
    data_o[14] = (syndrome_o == 8'h94) ^ data_i[14];
    data_o[15] = (syndrome_o == 8'h95) ^ data_i[15];
    data_o[16] = (syndrome_o == 8'h96) ^ data_i[16];
    data_o[17] = (syndrome_o == 8'h97) ^ data_i[17];
    data_o[18] = (syndrome_o == 8'h98) ^ data_i[18];
    data_o[19] = (syndrome_o == 8'h99) ^ data_i[19];
    data_o[20] = (syndrome_o == 8'h9a) ^ data_i[20];
    data_o[21] = (syndrome_o == 8'h9b) ^ data_i[21];
    data_o[22] = (syndrome_o == 8'h9c) ^ data_i[22];
    data_o[23] = (syndrome_o == 8'h9d) ^ data_i[23];
    data_o[24] = (syndrome_o == 8'h9e) ^ data_i[24];
    data_o[25] = (syndrome_o == 8'h9f) ^ data_i[25];
    data_o[26] = (syndrome_o == 8'ha1) ^ data_i[26];
    data_o[27] = (syndrome_o == 8'ha2) ^ data_i[27];
    data_o[28] = (syndrome_o == 8'ha3) ^ data_i[28];
    data_o[29] = (syndrome_o == 8'ha4) ^ data_i[29];
    data_o[30] = (syndrome_o == 8'ha5) ^ data_i[30];
    data_o[31] = (syndrome_o == 8'ha6) ^ data_i[31];
    data_o[32] = (syndrome_o == 8'ha7) ^ data_i[32];
    data_o[33] = (syndrome_o == 8'ha8) ^ data_i[33];
    data_o[34] = (syndrome_o == 8'ha9) ^ data_i[34];
    data_o[35] = (syndrome_o == 8'haa) ^ data_i[35];
    data_o[36] = (syndrome_o == 8'hab) ^ data_i[36];
    data_o[37] = (syndrome_o == 8'hac) ^ data_i[37];
    data_o[38] = (syndrome_o == 8'had) ^ data_i[38];
    data_o[39] = (syndrome_o == 8'hae) ^ data_i[39];
    data_o[40] = (syndrome_o == 8'haf) ^ data_i[40];
    data_o[41] = (syndrome_o == 8'hb0) ^ data_i[41];
    data_o[42] = (syndrome_o == 8'hb1) ^ data_i[42];
    data_o[43] = (syndrome_o == 8'hb2) ^ data_i[43];
    data_o[44] = (syndrome_o == 8'hb3) ^ data_i[44];
    data_o[45] = (syndrome_o == 8'hb4) ^ data_i[45];
    data_o[46] = (syndrome_o == 8'hb5) ^ data_i[46];
    data_o[47] = (syndrome_o == 8'hb6) ^ data_i[47];
    data_o[48] = (syndrome_o == 8'hb7) ^ data_i[48];
    data_o[49] = (syndrome_o == 8'hb8) ^ data_i[49];
    data_o[50] = (syndrome_o == 8'hb9) ^ data_i[50];
    data_o[51] = (syndrome_o == 8'hba) ^ data_i[51];
    data_o[52] = (syndrome_o == 8'hbb) ^ data_i[52];
    data_o[53] = (syndrome_o == 8'hbc) ^ data_i[53];
    data_o[54] = (syndrome_o == 8'hbd) ^ data_i[54];
    data_o[55] = (syndrome_o == 8'hbe) ^ data_i[55];
    data_o[56] = (syndrome_o == 8'hbf) ^ data_i[56];
    data_o[57] = (syndrome_o == 8'hc1) ^ data_i[57];
    data_o[58] = (syndrome_o == 8'hc2) ^ data_i[58];
    data_o[59] = (syndrome_o == 8'hc3) ^ data_i[59];
    data_o[60] = (syndrome_o == 8'hc4) ^ data_i[60];
    data_o[61] = (syndrome_o == 8'hc5) ^ data_i[61];
    data_o[62] = (syndrome_o == 8'hc6) ^ data_i[62];
    data_o[63] = (syndrome_o == 8'hc7) ^ data_i[63];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = syndrome_o[7];
    err_o[1] = |syndrome_o[6:0] & ~syndrome_o[7];

    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;

  endfunction

  function automatic logic [75:0]
      prim_secded_inv_hamming_76_68_enc (logic [67:0] data_i);
    logic [75:0] data_o;
    data_o = 76'(data_i);
    data_o[68] = ^(data_o & 76'h00AAB55555556AAAD5B);
    data_o[69] = ^(data_o & 76'h00CCD9999999B33366D);
    data_o[70] = ^(data_o & 76'h000F1E1E1E1E3C3C78E);
    data_o[71] = ^(data_o & 76'h00F01FE01FE03FC07F0);
    data_o[72] = ^(data_o & 76'h00001FFFE0003FFF800);
    data_o[73] = ^(data_o & 76'h00001FFFFFFFC000000);
    data_o[74] = ^(data_o & 76'h00FFE00000000000000);
    data_o[75] = ^(data_o & 76'h7FFFFFFFFFFFFFFFFFF);
    data_o ^= 76'hAA00000000000000000;
    return data_o;
  endfunction

  function automatic secded_inv_hamming_76_68_t
      prim_secded_inv_hamming_76_68_dec (logic [75:0] data_i);
    logic [67:0] data_o;
    logic [7:0] syndrome_o;
    logic [1:0]  err_o;

    secded_inv_hamming_76_68_t dec;

    // Syndrome calculation
    syndrome_o[0] = ^((data_i ^ 76'hAA00000000000000000) & 76'h01AAB55555556AAAD5B);
    syndrome_o[1] = ^((data_i ^ 76'hAA00000000000000000) & 76'h02CCD9999999B33366D);
    syndrome_o[2] = ^((data_i ^ 76'hAA00000000000000000) & 76'h040F1E1E1E1E3C3C78E);
    syndrome_o[3] = ^((data_i ^ 76'hAA00000000000000000) & 76'h08F01FE01FE03FC07F0);
    syndrome_o[4] = ^((data_i ^ 76'hAA00000000000000000) & 76'h10001FFFE0003FFF800);
    syndrome_o[5] = ^((data_i ^ 76'hAA00000000000000000) & 76'h20001FFFFFFFC000000);
    syndrome_o[6] = ^((data_i ^ 76'hAA00000000000000000) & 76'h40FFE00000000000000);
    syndrome_o[7] = ^((data_i ^ 76'hAA00000000000000000) & 76'hFFFFFFFFFFFFFFFFFFF);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 8'h83) ^ data_i[0];
    data_o[1] = (syndrome_o == 8'h85) ^ data_i[1];
    data_o[2] = (syndrome_o == 8'h86) ^ data_i[2];
    data_o[3] = (syndrome_o == 8'h87) ^ data_i[3];
    data_o[4] = (syndrome_o == 8'h89) ^ data_i[4];
    data_o[5] = (syndrome_o == 8'h8a) ^ data_i[5];
    data_o[6] = (syndrome_o == 8'h8b) ^ data_i[6];
    data_o[7] = (syndrome_o == 8'h8c) ^ data_i[7];
    data_o[8] = (syndrome_o == 8'h8d) ^ data_i[8];
    data_o[9] = (syndrome_o == 8'h8e) ^ data_i[9];
    data_o[10] = (syndrome_o == 8'h8f) ^ data_i[10];
    data_o[11] = (syndrome_o == 8'h91) ^ data_i[11];
    data_o[12] = (syndrome_o == 8'h92) ^ data_i[12];
    data_o[13] = (syndrome_o == 8'h93) ^ data_i[13];
    data_o[14] = (syndrome_o == 8'h94) ^ data_i[14];
    data_o[15] = (syndrome_o == 8'h95) ^ data_i[15];
    data_o[16] = (syndrome_o == 8'h96) ^ data_i[16];
    data_o[17] = (syndrome_o == 8'h97) ^ data_i[17];
    data_o[18] = (syndrome_o == 8'h98) ^ data_i[18];
    data_o[19] = (syndrome_o == 8'h99) ^ data_i[19];
    data_o[20] = (syndrome_o == 8'h9a) ^ data_i[20];
    data_o[21] = (syndrome_o == 8'h9b) ^ data_i[21];
    data_o[22] = (syndrome_o == 8'h9c) ^ data_i[22];
    data_o[23] = (syndrome_o == 8'h9d) ^ data_i[23];
    data_o[24] = (syndrome_o == 8'h9e) ^ data_i[24];
    data_o[25] = (syndrome_o == 8'h9f) ^ data_i[25];
    data_o[26] = (syndrome_o == 8'ha1) ^ data_i[26];
    data_o[27] = (syndrome_o == 8'ha2) ^ data_i[27];
    data_o[28] = (syndrome_o == 8'ha3) ^ data_i[28];
    data_o[29] = (syndrome_o == 8'ha4) ^ data_i[29];
    data_o[30] = (syndrome_o == 8'ha5) ^ data_i[30];
    data_o[31] = (syndrome_o == 8'ha6) ^ data_i[31];
    data_o[32] = (syndrome_o == 8'ha7) ^ data_i[32];
    data_o[33] = (syndrome_o == 8'ha8) ^ data_i[33];
    data_o[34] = (syndrome_o == 8'ha9) ^ data_i[34];
    data_o[35] = (syndrome_o == 8'haa) ^ data_i[35];
    data_o[36] = (syndrome_o == 8'hab) ^ data_i[36];
    data_o[37] = (syndrome_o == 8'hac) ^ data_i[37];
    data_o[38] = (syndrome_o == 8'had) ^ data_i[38];
    data_o[39] = (syndrome_o == 8'hae) ^ data_i[39];
    data_o[40] = (syndrome_o == 8'haf) ^ data_i[40];
    data_o[41] = (syndrome_o == 8'hb0) ^ data_i[41];
    data_o[42] = (syndrome_o == 8'hb1) ^ data_i[42];
    data_o[43] = (syndrome_o == 8'hb2) ^ data_i[43];
    data_o[44] = (syndrome_o == 8'hb3) ^ data_i[44];
    data_o[45] = (syndrome_o == 8'hb4) ^ data_i[45];
    data_o[46] = (syndrome_o == 8'hb5) ^ data_i[46];
    data_o[47] = (syndrome_o == 8'hb6) ^ data_i[47];
    data_o[48] = (syndrome_o == 8'hb7) ^ data_i[48];
    data_o[49] = (syndrome_o == 8'hb8) ^ data_i[49];
    data_o[50] = (syndrome_o == 8'hb9) ^ data_i[50];
    data_o[51] = (syndrome_o == 8'hba) ^ data_i[51];
    data_o[52] = (syndrome_o == 8'hbb) ^ data_i[52];
    data_o[53] = (syndrome_o == 8'hbc) ^ data_i[53];
    data_o[54] = (syndrome_o == 8'hbd) ^ data_i[54];
    data_o[55] = (syndrome_o == 8'hbe) ^ data_i[55];
    data_o[56] = (syndrome_o == 8'hbf) ^ data_i[56];
    data_o[57] = (syndrome_o == 8'hc1) ^ data_i[57];
    data_o[58] = (syndrome_o == 8'hc2) ^ data_i[58];
    data_o[59] = (syndrome_o == 8'hc3) ^ data_i[59];
    data_o[60] = (syndrome_o == 8'hc4) ^ data_i[60];
    data_o[61] = (syndrome_o == 8'hc5) ^ data_i[61];
    data_o[62] = (syndrome_o == 8'hc6) ^ data_i[62];
    data_o[63] = (syndrome_o == 8'hc7) ^ data_i[63];
    data_o[64] = (syndrome_o == 8'hc8) ^ data_i[64];
    data_o[65] = (syndrome_o == 8'hc9) ^ data_i[65];
    data_o[66] = (syndrome_o == 8'hca) ^ data_i[66];
    data_o[67] = (syndrome_o == 8'hcb) ^ data_i[67];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = syndrome_o[7];
    err_o[1] = |syndrome_o[6:0] & ~syndrome_o[7];

    dec.data      = data_o;
    dec.syndrome  = syndrome_o;
    dec.err       = err_o;
    return dec;

  endfunction


endpackage
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SECDED decoder generated by util/design/secded_gen.py

module prim_secded_inv_22_16_dec (
  input        [21:0] data_i,
  output logic [15:0] data_o,
  output logic [5:0] syndrome_o,
  output logic [1:0] err_o
);

  always_comb begin : p_encode
    // Syndrome calculation
    syndrome_o[0] = ^((data_i ^ 22'h2A0000) & 22'h01496E);
    syndrome_o[1] = ^((data_i ^ 22'h2A0000) & 22'h02F20B);
    syndrome_o[2] = ^((data_i ^ 22'h2A0000) & 22'h048ED8);
    syndrome_o[3] = ^((data_i ^ 22'h2A0000) & 22'h087714);
    syndrome_o[4] = ^((data_i ^ 22'h2A0000) & 22'h10ACA5);
    syndrome_o[5] = ^((data_i ^ 22'h2A0000) & 22'h2011F3);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 6'h32) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'h23) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h19) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h7) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'h2c) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h31) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h25) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h34) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h29) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'he) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'h1c) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h15) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h2a) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h1a) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'hb) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h16) ^ data_i[15];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
  end
endmodule : prim_secded_inv_22_16_dec
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SECDED encoder generated by util/design/secded_gen.py

module prim_secded_inv_22_16_enc (
  input        [15:0] data_i,
  output logic [21:0] data_o
);

  always_comb begin : p_encode
    data_o = 22'(data_i);
    data_o[16] = ^(data_o & 22'h00496E);
    data_o[17] = ^(data_o & 22'h00F20B);
    data_o[18] = ^(data_o & 22'h008ED8);
    data_o[19] = ^(data_o & 22'h007714);
    data_o[20] = ^(data_o & 22'h00ACA5);
    data_o[21] = ^(data_o & 22'h0011F3);
    data_o ^= 22'h2A0000;
  end

endmodule : prim_secded_inv_22_16_enc
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SECDED decoder generated by util/design/secded_gen.py

module prim_secded_inv_39_32_dec (
  input        [38:0] data_i,
  output logic [31:0] data_o,
  output logic [6:0] syndrome_o,
  output logic [1:0] err_o
);

  always_comb begin : p_encode
    // Syndrome calculation
    syndrome_o[0] = ^((data_i ^ 39'h2A00000000) & 39'h012606BD25);
    syndrome_o[1] = ^((data_i ^ 39'h2A00000000) & 39'h02DEBA8050);
    syndrome_o[2] = ^((data_i ^ 39'h2A00000000) & 39'h04413D89AA);
    syndrome_o[3] = ^((data_i ^ 39'h2A00000000) & 39'h0831234ED1);
    syndrome_o[4] = ^((data_i ^ 39'h2A00000000) & 39'h10C2C1323B);
    syndrome_o[5] = ^((data_i ^ 39'h2A00000000) & 39'h202DCC624C);
    syndrome_o[6] = ^((data_i ^ 39'h2A00000000) & 39'h4098505586);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 7'h19) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'h54) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h61) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h34) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h1a) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'h15) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h2a) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h4c) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h45) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h38) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h49) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'hd) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h51) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h31) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h68) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'h7) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h1c) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'hb) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h25) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h26) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h46) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'he) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h70) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h32) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h2c) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h13) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h23) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h62) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h4a) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h29) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h16) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h52) ^ data_i[31];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
  end
endmodule : prim_secded_inv_39_32_dec
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SECDED encoder generated by util/design/secded_gen.py

module prim_secded_inv_39_32_enc (
  input        [31:0] data_i,
  output logic [38:0] data_o
);

  always_comb begin : p_encode
    data_o = 39'(data_i);
    data_o[32] = ^(data_o & 39'h002606BD25);
    data_o[33] = ^(data_o & 39'h00DEBA8050);
    data_o[34] = ^(data_o & 39'h00413D89AA);
    data_o[35] = ^(data_o & 39'h0031234ED1);
    data_o[36] = ^(data_o & 39'h00C2C1323B);
    data_o[37] = ^(data_o & 39'h002DCC624C);
    data_o[38] = ^(data_o & 39'h0098505586);
    data_o ^= 39'h2A00000000;
  end

endmodule : prim_secded_inv_39_32_enc
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SECDED decoder generated by util/design/secded_gen.py

module prim_secded_inv_64_57_dec (
  input        [63:0] data_i,
  output logic [56:0] data_o,
  output logic [6:0] syndrome_o,
  output logic [1:0] err_o
);

  always_comb begin : p_encode
    // Syndrome calculation
    syndrome_o[0] = ^((data_i ^ 64'h5400000000000000) & 64'h0303FFF800007FFF);
    syndrome_o[1] = ^((data_i ^ 64'h5400000000000000) & 64'h057C1FF801FF801F);
    syndrome_o[2] = ^((data_i ^ 64'h5400000000000000) & 64'h09BDE1F87E0781E1);
    syndrome_o[3] = ^((data_i ^ 64'h5400000000000000) & 64'h11DEEE3B8E388E22);
    syndrome_o[4] = ^((data_i ^ 64'h5400000000000000) & 64'h21EF76CDB2C93244);
    syndrome_o[5] = ^((data_i ^ 64'h5400000000000000) & 64'h41F7BB56D5525488);
    syndrome_o[6] = ^((data_i ^ 64'h5400000000000000) & 64'h81FBDDA769A46910);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 7'h7) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'hb) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h13) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h23) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h43) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'hd) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h15) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h25) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h45) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h19) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h29) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'h49) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h31) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h51) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h61) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'he) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h16) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'h26) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h46) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h1a) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h2a) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'h4a) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h32) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h52) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h62) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h1c) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h2c) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h4c) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h34) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h54) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h64) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h38) ^ data_i[31];
    data_o[32] = (syndrome_o == 7'h58) ^ data_i[32];
    data_o[33] = (syndrome_o == 7'h68) ^ data_i[33];
    data_o[34] = (syndrome_o == 7'h70) ^ data_i[34];
    data_o[35] = (syndrome_o == 7'h1f) ^ data_i[35];
    data_o[36] = (syndrome_o == 7'h2f) ^ data_i[36];
    data_o[37] = (syndrome_o == 7'h4f) ^ data_i[37];
    data_o[38] = (syndrome_o == 7'h37) ^ data_i[38];
    data_o[39] = (syndrome_o == 7'h57) ^ data_i[39];
    data_o[40] = (syndrome_o == 7'h67) ^ data_i[40];
    data_o[41] = (syndrome_o == 7'h3b) ^ data_i[41];
    data_o[42] = (syndrome_o == 7'h5b) ^ data_i[42];
    data_o[43] = (syndrome_o == 7'h6b) ^ data_i[43];
    data_o[44] = (syndrome_o == 7'h73) ^ data_i[44];
    data_o[45] = (syndrome_o == 7'h3d) ^ data_i[45];
    data_o[46] = (syndrome_o == 7'h5d) ^ data_i[46];
    data_o[47] = (syndrome_o == 7'h6d) ^ data_i[47];
    data_o[48] = (syndrome_o == 7'h75) ^ data_i[48];
    data_o[49] = (syndrome_o == 7'h79) ^ data_i[49];
    data_o[50] = (syndrome_o == 7'h3e) ^ data_i[50];
    data_o[51] = (syndrome_o == 7'h5e) ^ data_i[51];
    data_o[52] = (syndrome_o == 7'h6e) ^ data_i[52];
    data_o[53] = (syndrome_o == 7'h76) ^ data_i[53];
    data_o[54] = (syndrome_o == 7'h7a) ^ data_i[54];
    data_o[55] = (syndrome_o == 7'h7c) ^ data_i[55];
    data_o[56] = (syndrome_o == 7'h7f) ^ data_i[56];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = ^syndrome_o;
    err_o[1] = ~err_o[0] & (|syndrome_o);
  end
endmodule : prim_secded_inv_64_57_dec
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SECDED encoder generated by util/design/secded_gen.py

module prim_secded_inv_64_57_enc (
  input        [56:0] data_i,
  output logic [63:0] data_o
);

  always_comb begin : p_encode
    data_o = 64'(data_i);
    data_o[57] = ^(data_o & 64'h0103FFF800007FFF);
    data_o[58] = ^(data_o & 64'h017C1FF801FF801F);
    data_o[59] = ^(data_o & 64'h01BDE1F87E0781E1);
    data_o[60] = ^(data_o & 64'h01DEEE3B8E388E22);
    data_o[61] = ^(data_o & 64'h01EF76CDB2C93244);
    data_o[62] = ^(data_o & 64'h01F7BB56D5525488);
    data_o[63] = ^(data_o & 64'h01FBDDA769A46910);
    data_o ^= 64'h5400000000000000;
  end

endmodule : prim_secded_inv_64_57_enc
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SECDED decoder generated by util/design/secded_gen.py

module prim_secded_inv_hamming_22_16_dec (
  input        [21:0] data_i,
  output logic [15:0] data_o,
  output logic [5:0] syndrome_o,
  output logic [1:0] err_o
);

  always_comb begin : p_encode
    // Syndrome calculation
    syndrome_o[0] = ^((data_i ^ 22'h2A0000) & 22'h01AD5B);
    syndrome_o[1] = ^((data_i ^ 22'h2A0000) & 22'h02366D);
    syndrome_o[2] = ^((data_i ^ 22'h2A0000) & 22'h04C78E);
    syndrome_o[3] = ^((data_i ^ 22'h2A0000) & 22'h0807F0);
    syndrome_o[4] = ^((data_i ^ 22'h2A0000) & 22'h10F800);
    syndrome_o[5] = ^((data_i ^ 22'h2A0000) & 22'h3FFFFF);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 6'h23) ^ data_i[0];
    data_o[1] = (syndrome_o == 6'h25) ^ data_i[1];
    data_o[2] = (syndrome_o == 6'h26) ^ data_i[2];
    data_o[3] = (syndrome_o == 6'h27) ^ data_i[3];
    data_o[4] = (syndrome_o == 6'h29) ^ data_i[4];
    data_o[5] = (syndrome_o == 6'h2a) ^ data_i[5];
    data_o[6] = (syndrome_o == 6'h2b) ^ data_i[6];
    data_o[7] = (syndrome_o == 6'h2c) ^ data_i[7];
    data_o[8] = (syndrome_o == 6'h2d) ^ data_i[8];
    data_o[9] = (syndrome_o == 6'h2e) ^ data_i[9];
    data_o[10] = (syndrome_o == 6'h2f) ^ data_i[10];
    data_o[11] = (syndrome_o == 6'h31) ^ data_i[11];
    data_o[12] = (syndrome_o == 6'h32) ^ data_i[12];
    data_o[13] = (syndrome_o == 6'h33) ^ data_i[13];
    data_o[14] = (syndrome_o == 6'h34) ^ data_i[14];
    data_o[15] = (syndrome_o == 6'h35) ^ data_i[15];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = syndrome_o[5];
    err_o[1] = |syndrome_o[4:0] & ~syndrome_o[5];
  end
endmodule : prim_secded_inv_hamming_22_16_dec
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SECDED encoder generated by util/design/secded_gen.py

module prim_secded_inv_hamming_22_16_enc (
  input        [15:0] data_i,
  output logic [21:0] data_o
);

  always_comb begin : p_encode
    data_o = 22'(data_i);
    data_o[16] = ^(data_o & 22'h00AD5B);
    data_o[17] = ^(data_o & 22'h00366D);
    data_o[18] = ^(data_o & 22'h00C78E);
    data_o[19] = ^(data_o & 22'h0007F0);
    data_o[20] = ^(data_o & 22'h00F800);
    data_o[21] = ^(data_o & 22'h1FFFFF);
    data_o ^= 22'h2A0000;
  end

endmodule : prim_secded_inv_hamming_22_16_enc
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SECDED decoder generated by util/design/secded_gen.py

module prim_secded_inv_hamming_39_32_dec (
  input        [38:0] data_i,
  output logic [31:0] data_o,
  output logic [6:0] syndrome_o,
  output logic [1:0] err_o
);

  always_comb begin : p_encode
    // Syndrome calculation
    syndrome_o[0] = ^((data_i ^ 39'h2A00000000) & 39'h0156AAAD5B);
    syndrome_o[1] = ^((data_i ^ 39'h2A00000000) & 39'h029B33366D);
    syndrome_o[2] = ^((data_i ^ 39'h2A00000000) & 39'h04E3C3C78E);
    syndrome_o[3] = ^((data_i ^ 39'h2A00000000) & 39'h0803FC07F0);
    syndrome_o[4] = ^((data_i ^ 39'h2A00000000) & 39'h1003FFF800);
    syndrome_o[5] = ^((data_i ^ 39'h2A00000000) & 39'h20FC000000);
    syndrome_o[6] = ^((data_i ^ 39'h2A00000000) & 39'h7FFFFFFFFF);

    // Corrected output calculation
    data_o[0] = (syndrome_o == 7'h43) ^ data_i[0];
    data_o[1] = (syndrome_o == 7'h45) ^ data_i[1];
    data_o[2] = (syndrome_o == 7'h46) ^ data_i[2];
    data_o[3] = (syndrome_o == 7'h47) ^ data_i[3];
    data_o[4] = (syndrome_o == 7'h49) ^ data_i[4];
    data_o[5] = (syndrome_o == 7'h4a) ^ data_i[5];
    data_o[6] = (syndrome_o == 7'h4b) ^ data_i[6];
    data_o[7] = (syndrome_o == 7'h4c) ^ data_i[7];
    data_o[8] = (syndrome_o == 7'h4d) ^ data_i[8];
    data_o[9] = (syndrome_o == 7'h4e) ^ data_i[9];
    data_o[10] = (syndrome_o == 7'h4f) ^ data_i[10];
    data_o[11] = (syndrome_o == 7'h51) ^ data_i[11];
    data_o[12] = (syndrome_o == 7'h52) ^ data_i[12];
    data_o[13] = (syndrome_o == 7'h53) ^ data_i[13];
    data_o[14] = (syndrome_o == 7'h54) ^ data_i[14];
    data_o[15] = (syndrome_o == 7'h55) ^ data_i[15];
    data_o[16] = (syndrome_o == 7'h56) ^ data_i[16];
    data_o[17] = (syndrome_o == 7'h57) ^ data_i[17];
    data_o[18] = (syndrome_o == 7'h58) ^ data_i[18];
    data_o[19] = (syndrome_o == 7'h59) ^ data_i[19];
    data_o[20] = (syndrome_o == 7'h5a) ^ data_i[20];
    data_o[21] = (syndrome_o == 7'h5b) ^ data_i[21];
    data_o[22] = (syndrome_o == 7'h5c) ^ data_i[22];
    data_o[23] = (syndrome_o == 7'h5d) ^ data_i[23];
    data_o[24] = (syndrome_o == 7'h5e) ^ data_i[24];
    data_o[25] = (syndrome_o == 7'h5f) ^ data_i[25];
    data_o[26] = (syndrome_o == 7'h61) ^ data_i[26];
    data_o[27] = (syndrome_o == 7'h62) ^ data_i[27];
    data_o[28] = (syndrome_o == 7'h63) ^ data_i[28];
    data_o[29] = (syndrome_o == 7'h64) ^ data_i[29];
    data_o[30] = (syndrome_o == 7'h65) ^ data_i[30];
    data_o[31] = (syndrome_o == 7'h66) ^ data_i[31];

    // err_o calc. bit0: single error, bit1: double error
    err_o[0] = syndrome_o[6];
    err_o[1] = |syndrome_o[5:0] & ~syndrome_o[6];
  end
endmodule : prim_secded_inv_hamming_39_32_dec
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SECDED encoder generated by util/design/secded_gen.py

module prim_secded_inv_hamming_39_32_enc (
  input        [31:0] data_i,
  output logic [38:0] data_o
);

  always_comb begin : p_encode
    data_o = 39'(data_i);
    data_o[32] = ^(data_o & 39'h0056AAAD5B);
    data_o[33] = ^(data_o & 39'h009B33366D);
    data_o[34] = ^(data_o & 39'h00E3C3C78E);
    data_o[35] = ^(data_o & 39'h0003FC07F0);
    data_o[36] = ^(data_o & 39'h0003FFF800);
    data_o[37] = ^(data_o & 39'h00FC000000);
    data_o[38] = ^(data_o & 39'h3FFFFFFFFF);
    data_o ^= 39'h2A00000000;
  end

endmodule : prim_secded_inv_hamming_39_32_enc
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

package prim_count_pkg;

  // An enum that names the possible actions that the inputs might ask for. See the PossibleActions
  // parameter in prim_count for how this is used.
  typedef logic [3:0] action_mask_t;
  typedef enum action_mask_t {Clr  = 4'h1,
                              Set  = 4'h2,
                              Incr = 4'h4,
                              Decr = 4'h8} action_e;

endpackage : prim_count_pkg
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Hardened counter primitive:
//
// This internally uses a cross counter scheme with primary and a secondary counter, where the
// secondary counter counts in reverse direction. The sum of both counters must remain constant and
// equal to 2**Width-1 or otherwise an err_o will be asserted.
//
// This counter supports a generic clear / set / increment / decrement interface:
//
// clr_i: This clears the primary counter to ResetValue and adjusts the secondary counter to match
//        (i.e. 2**Width-1-ResetValue). Clear has priority over set, increment and decrement.
// set_i: This sets the primary counter to set_cnt_i and adjusts the secondary counter to match
//        (i.e. 2**Width-1-set_cnt_i). Set has priority over increment and decrement.
// incr_en_i: Increments the primary counter by step_i, and decrements the secondary by step_i.
// decr_en_i: Decrements the primary counter by step_i, and increments the secondary by step_i.
// commit_i: Counter changes only take effect when `commit_i` is set. This does not effect the
//           `cnt_after_commit_o` output which gives the next counter state if the change is
//           committed.
//
// Note that if both incr_en_i and decr_en_i are asserted at the same time, the counter remains
// unchanged. The counter is also protected against under- and overflows.

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module prim_count
  import prim_count_pkg::*;
#(
  parameter int               Width = 2,
  // Can be used to reset the counter to a different value than 0, for example when
  // the counter is used as a down-counter.
  parameter logic [Width-1:0] ResetValue = '0,
  // This should only be disabled in special circumstances, for example
  // in non-comportable IPs where an error does not trigger an alert.
  parameter bit               EnableAlertTriggerSVA = 1,

  // We have some assertions below with preconditions that depend on particular input actions
  // (clear, set, incr, decr). If the design has instantiated prim_count with one of these actions
  // tied to zero, the preconditions for the associated assertions will not be satisfiable. The
  // result is an unreachable item, which we treat as a failed assertion in the report.
  //
  // To avoid this, we the instantiation to specify the actions which might happen. If this is not
  // '1, we will have an assertion which assert the corresponding action is never triggered. We can
  // then use this to avoid the unreachable assertions.
  parameter action_mask_t     PossibleActions = {$bits(action_mask_t){1'b1}}
) (
  input clk_i,
  input rst_ni,
  input clr_i,
  input set_i,
  input [Width-1:0] set_cnt_i,                 // Set value for the counter.
  input incr_en_i,
  input decr_en_i,
  input [Width-1:0] step_i,                    // Increment/decrement step when enabled.
  input commit_i,
  output logic [Width-1:0] cnt_o,              // Current counter state
  output logic [Width-1:0] cnt_after_commit_o, // Next counter state if committed
  output logic err_o
);

  ///////////////////
  // Counter logic //
  ///////////////////

  // Reset Values for primary and secondary counters.
  localparam int NumCnt = 2;
  localparam logic [NumCnt-1:0][Width-1:0] ResetValues = {{Width{1'b1}} - ResetValue, // secondary
                                                          ResetValue};                // primary

  logic [NumCnt-1:0][Width-1:0] cnt_d, cnt_d_committed, cnt_q;

  // The fpv_force signal can be used in FPV runs to make the internal counters (cnt_q) jump
  // unexpectedly. We only want to use this mechanism when we're doing FPV on prim_count itself. In
  // that situation, we will have the PrimCountFpv define and wish to leave fpv_force undriven so
  // that it becomes a free variable in FPV. In any other situation, we drive the signal with zero.
  logic [NumCnt-1:0][Width-1:0] fpv_force;
assign fpv_force = '0;


  for (genvar k = 0; k < NumCnt; k++) begin : gen_cnts
    // Note that increments / decrements are reversed for the secondary counter.
    logic incr_en, decr_en;
    logic [Width-1:0] set_val;
    if (k == 0) begin : gen_up_cnt
      assign incr_en = incr_en_i;
      assign decr_en = decr_en_i;
      assign set_val = set_cnt_i;
    end else begin : gen_dn_cnt
      assign incr_en = decr_en_i;
      assign decr_en = incr_en_i;
      // The secondary value needs to be adjusted accordingly.
      assign set_val = {Width{1'b1}} - set_cnt_i;
    end

    // Main counter logic
    logic [Width:0] ext_cnt;
    assign ext_cnt = (decr_en) ? {1'b0, cnt_q[k]} - {1'b0, step_i} :
                     (incr_en) ? {1'b0, cnt_q[k]} + {1'b0, step_i} : {1'b0, cnt_q[k]};

    // Saturation logic
    logic uflow, oflow;
    assign oflow = incr_en && ext_cnt[Width];
    assign uflow = decr_en && ext_cnt[Width];
    logic [Width-1:0] cnt_sat;
    assign cnt_sat = (uflow) ? '0            :
                     (oflow) ? {Width{1'b1}} : ext_cnt[Width-1:0];

    // Clock gate flops when in saturation, and do not
    // count if both incr_en and decr_en are asserted.
    logic cnt_en;
    assign cnt_en = (incr_en ^ decr_en) &&
                    ((incr_en && !(&cnt_q[k])) ||
                    (decr_en && !(cnt_q[k] == '0)));

    // Counter muxes
    assign cnt_d[k] = (clr_i)  ? ResetValues[k] :
                      (set_i)  ? set_val        :
                      (cnt_en) ? cnt_sat        : cnt_q[k];

    assign cnt_d_committed[k] = commit_i ? cnt_d[k] : cnt_q[k];

    logic [Width-1:0] cnt_unforced_q;
    prim_flop #(
      .Width(Width),
      .ResetValue(ResetValues[k])
    ) u_cnt_flop (
      .clk_i,
      .rst_ni,
      .d_i(cnt_d_committed[k]),
      .q_o(cnt_unforced_q)
    );

    // fpv_force is only used during FPV.
    assign cnt_q[k] = fpv_force[k] + cnt_unforced_q;
  end

  // The sum of both counters must always equal the counter maximum.
  logic [Width:0] sum;
  assign sum = (cnt_q[0] + cnt_q[1]);

  // Register the error signal to avoid potential CDC issues downstream.
  logic err_d, err_q;
  assign err_d = (sum != {1'b0, {Width{1'b1}}});
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      err_q <= 1'b0;
    end else begin
      err_q <= err_d;
    end
  end
  assign err_o = err_q;

  // Output count values
  assign cnt_o              = cnt_q[0];
  assign cnt_after_commit_o = cnt_d[0];

  ////////////////
  // Assertions //
  ////////////////


endmodule // prim_count
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Synchronous single-port SRAM model

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module prim_ram_1p import prim_ram_1p_pkg::*; #(
  parameter  int Width           = 32, // bit
  parameter  int Depth           = 128,
  parameter  int DataBitsPerMask = 1, // Number of data bits per bit of write mask
  parameter      MemInitFile     = "", // VMEM file to initialize the memory with

  localparam int Aw              = $clog2(Depth)  // derived parameter
) (
  input  logic             clk_i,
  input  logic             rst_ni,

  input  logic             req_i,
  input  logic             write_i,
  input  logic [Aw-1:0]    addr_i,
  input  logic [Width-1:0] wdata_i,
  input  logic [Width-1:0] wmask_i,
  output logic [Width-1:0] rdata_o, // Read data. Data is returned one cycle after req_i is high.
  input  ram_1p_cfg_t      cfg_i,
  output ram_1p_cfg_rsp_t  cfg_rsp_o
);

// For certain synthesis experiments we compile the design with generic models to get an unmapped
// netlist (GTECH). In these synthesis experiments, we typically black-box the memory models since
// these are going to be simulated using plain RTL models in netlist simulations. This can be done
// by analyzing and elaborating the design, and then removing the memory submodules before writing
// out the verilog netlist. However, memory arrays can take a long time to elaborate, and in case
// of dual port rams they can even trigger elab errors due to multiple processes writing to the
// same memory variable concurrently. To this end, we exclude the entire logic in this module in
// these runs with the following macro.
// Width must be fully divisible by DataBitsPerMask
  

  logic unused_signals;
  assign unused_signals = ^{cfg_i, rst_ni};
  assign cfg_rsp_o      = '0;

  // Width of internal write mask. Note wmask_i input into the module is always assumed
  // to be the full bit mask
  localparam int MaskWidth = Width / DataBitsPerMask;

  logic [Width-1:0]     mem [Depth];
  logic [MaskWidth-1:0] wmask;

  for (genvar k = 0; k < MaskWidth; k++) begin : gen_wmask
    assign wmask[k] = &wmask_i[k*DataBitsPerMask +: DataBitsPerMask];

    // Ensure that all mask bits within a group have the same value for a write
    
  end

  // using always instead of always_ff to avoid 'ICPD  - illegal combination of drivers' error
  // thrown when using $readmemh system task to backdoor load an image
  always @(posedge clk_i) begin
    if (req_i) begin
      if (write_i) begin
        for (int i=0; i < MaskWidth; i = i + 1) begin
          if (wmask[i]) begin
            mem[addr_i][i*DataBitsPerMask +: DataBitsPerMask] <=
              wdata_i[i*DataBitsPerMask +: DataBitsPerMask];
          end
        end
      end else begin
        rdata_o <= mem[addr_i];
      end
    end
  end

  // Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

/**
 * Memory loader for simulation
 *
 * Include this file in a memory primitive to load a memory array from
 * simulation.
 *
 * Requirements:
 * - A memory array named `mem`.
 * - A parameter `Width` giving the memory width (word size) in bit.
 * - A parameter `Depth` giving the memory depth in words.
 * - A parameter `MemInitFile` with a file path of a VMEM file to be loaded into
 *   the memory if not empty.
 *
 * Note this works with memories up to a maximum width of 312 bits. Should this maximum width be
 * increased all of the `simutil_set_mem` and `simutil_get_mem` call sites must be found (e.g. using
 * git grep) and adjusted appropriately.
 */



initial begin


  if (MemInitFile != "") begin : gen_meminit
      $display("Initializing memory %m from file '%s'.", MemInitFile);
      $readmemh(MemInitFile, mem);
  end
end


endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
//
//    util/design/gen-mubi.py
//
// This package defines common multibit signal types, active high and active low values and
// the corresponding functions to test whether the values are set or not.

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


package prim_mubi_pkg;

  //////////////////////////////////////////////
  // 4 Bit Multibit Type and Functions //
  //////////////////////////////////////////////

  parameter int MuBi4Width = 4;
  typedef enum logic [MuBi4Width-1:0] {
    MuBi4True = 4'h6, // enabled
    MuBi4False = 4'h9  // disabled
  } mubi4_t;

  // This is a prerequisite for the multibit functions below to work.
    function automatic bit assert_static_in_package_CheckMuBi4ValsComplementary_A(); 
    bit unused_bit [((MuBi4True == ~MuBi4False) ? 1 : -1)];                     
    unused_bit = '{default: 1'b0};                            
    return unused_bit[0];                                     
  endfunction

  // Test whether the multibit value is one of the valid enumerations
  function automatic logic mubi4_test_invalid(mubi4_t val);
    return ~(val inside {MuBi4True, MuBi4False});
  endfunction : mubi4_test_invalid

  // Convert a 1 input value to a mubi output
  function automatic mubi4_t mubi4_bool_to_mubi(logic val);
    return (val ? MuBi4True : MuBi4False);
  endfunction : mubi4_bool_to_mubi

  // Test whether the multibit value of type "mubi4_t" signals an "enabled" condition.
  // The strict version of this function requires
  // the multibit value to equal True.
  function automatic logic mubi4_test_true_strict(mubi4_t val);
    return MuBi4True == val;
  endfunction : mubi4_test_true_strict

  // Test whether the multibit value of type "logic vector" signals an "enabled" condition.
  // The strict version of this function requires
  // the multibit value to equal True.
  function automatic logic mubi4_logic_test_true_strict(logic [3:0] val);
    return MuBi4True == val;
  endfunction : mubi4_logic_test_true_strict

  // Test whether the multibit value signals a "disabled" condition.
  // The strict version of this function requires
  // the multibit value to equal False.
  function automatic logic mubi4_test_false_strict(mubi4_t val);
    return MuBi4False == val;
  endfunction : mubi4_test_false_strict

  // Test whether the multibit value signals an "enabled" condition.
  // The loose version of this function interprets all
  // values other than False as "enabled".
  function automatic logic mubi4_test_true_loose(mubi4_t val);
    return MuBi4False != val;
  endfunction : mubi4_test_true_loose

  // Test whether the multibit value signals a "disabled" condition.
  // The loose version of this function interprets all
  // values other than True as "disabled".
  function automatic logic mubi4_test_false_loose(mubi4_t val);
    return MuBi4True != val;
  endfunction : mubi4_test_false_loose


  // Performs a logical OR operation between two multibit values.
  // This treats "act" as logical 1, and all other values are
  // treated as 0. Truth table:
  //
  // A    | B    | OUT
  //------+------+-----
  // !act | !act | !act
  // act  | !act | act
  // !act | act  | act
  // act  | act  | act
  //
  function automatic mubi4_t mubi4_or(mubi4_t a, mubi4_t b, mubi4_t act);
    logic [MuBi4Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi4Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] || b_in[k];
      end else begin
        out[k] = a_in[k] && b_in[k];
      end
    end
    return mubi4_t'(out);
  endfunction : mubi4_or

  // Performs a logical AND operation between two multibit values.
  // This treats "act" as logical 1, and all other values are
  // treated as 0. Truth table:
  //
  // A    | B    | OUT
  //------+------+-----
  // !act | !act | !act
  // act  | !act | !act
  // !act | act  | !act
  // act  | act  | act
  //
  function automatic mubi4_t mubi4_and(mubi4_t a, mubi4_t b, mubi4_t act);
    logic [MuBi4Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi4Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] && b_in[k];
      end else begin
        out[k] = a_in[k] || b_in[k];
      end
    end
    return mubi4_t'(out);
  endfunction : mubi4_and

  // Performs a logical OR operation between two multibit values.
  // This treats "True" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi4_t mubi4_or_hi(mubi4_t a, mubi4_t b);
    return mubi4_or(a, b, MuBi4True);
  endfunction : mubi4_or_hi

  // Performs a logical AND operation between two multibit values.
  // This treats "True" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi4_t mubi4_and_hi(mubi4_t a, mubi4_t b);
    return mubi4_and(a, b, MuBi4True);
  endfunction : mubi4_and_hi

  // Performs a logical OR operation between two multibit values.
  // This treats "False" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi4_t mubi4_or_lo(mubi4_t a, mubi4_t b);
    return mubi4_or(a, b, MuBi4False);
  endfunction : mubi4_or_lo

  // Performs a logical AND operation between two multibit values.
  // This treats "False" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi4_t mubi4_and_lo(mubi4_t a, mubi4_t b);
    return mubi4_and(a, b, MuBi4False);
  endfunction : mubi4_and_lo

  //////////////////////////////////////////////
  // 8 Bit Multibit Type and Functions //
  //////////////////////////////////////////////

  parameter int MuBi8Width = 8;
  typedef enum logic [MuBi8Width-1:0] {
    MuBi8True = 8'h96, // enabled
    MuBi8False = 8'h69  // disabled
  } mubi8_t;

  // This is a prerequisite for the multibit functions below to work.
    function automatic bit assert_static_in_package_CheckMuBi8ValsComplementary_A(); 
    bit unused_bit [((MuBi8True == ~MuBi8False) ? 1 : -1)];                     
    unused_bit = '{default: 1'b0};                            
    return unused_bit[0];                                     
  endfunction

  // Test whether the multibit value is one of the valid enumerations
  function automatic logic mubi8_test_invalid(mubi8_t val);
    return ~(val inside {MuBi8True, MuBi8False});
  endfunction : mubi8_test_invalid

  // Convert a 1 input value to a mubi output
  function automatic mubi8_t mubi8_bool_to_mubi(logic val);
    return (val ? MuBi8True : MuBi8False);
  endfunction : mubi8_bool_to_mubi

  // Test whether the multibit value of type "mubi8_t" signals an "enabled" condition.
  // The strict version of this function requires
  // the multibit value to equal True.
  function automatic logic mubi8_test_true_strict(mubi8_t val);
    return MuBi8True == val;
  endfunction : mubi8_test_true_strict

  // Test whether the multibit value of type "logic vector" signals an "enabled" condition.
  // The strict version of this function requires
  // the multibit value to equal True.
  function automatic logic mubi8_logic_test_true_strict(logic [7:0] val);
    return MuBi8True == val;
  endfunction : mubi8_logic_test_true_strict

  // Test whether the multibit value signals a "disabled" condition.
  // The strict version of this function requires
  // the multibit value to equal False.
  function automatic logic mubi8_test_false_strict(mubi8_t val);
    return MuBi8False == val;
  endfunction : mubi8_test_false_strict

  // Test whether the multibit value signals an "enabled" condition.
  // The loose version of this function interprets all
  // values other than False as "enabled".
  function automatic logic mubi8_test_true_loose(mubi8_t val);
    return MuBi8False != val;
  endfunction : mubi8_test_true_loose

  // Test whether the multibit value signals a "disabled" condition.
  // The loose version of this function interprets all
  // values other than True as "disabled".
  function automatic logic mubi8_test_false_loose(mubi8_t val);
    return MuBi8True != val;
  endfunction : mubi8_test_false_loose


  // Performs a logical OR operation between two multibit values.
  // This treats "act" as logical 1, and all other values are
  // treated as 0. Truth table:
  //
  // A    | B    | OUT
  //------+------+-----
  // !act | !act | !act
  // act  | !act | act
  // !act | act  | act
  // act  | act  | act
  //
  function automatic mubi8_t mubi8_or(mubi8_t a, mubi8_t b, mubi8_t act);
    logic [MuBi8Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi8Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] || b_in[k];
      end else begin
        out[k] = a_in[k] && b_in[k];
      end
    end
    return mubi8_t'(out);
  endfunction : mubi8_or

  // Performs a logical AND operation between two multibit values.
  // This treats "act" as logical 1, and all other values are
  // treated as 0. Truth table:
  //
  // A    | B    | OUT
  //------+------+-----
  // !act | !act | !act
  // act  | !act | !act
  // !act | act  | !act
  // act  | act  | act
  //
  function automatic mubi8_t mubi8_and(mubi8_t a, mubi8_t b, mubi8_t act);
    logic [MuBi8Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi8Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] && b_in[k];
      end else begin
        out[k] = a_in[k] || b_in[k];
      end
    end
    return mubi8_t'(out);
  endfunction : mubi8_and

  // Performs a logical OR operation between two multibit values.
  // This treats "True" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi8_t mubi8_or_hi(mubi8_t a, mubi8_t b);
    return mubi8_or(a, b, MuBi8True);
  endfunction : mubi8_or_hi

  // Performs a logical AND operation between two multibit values.
  // This treats "True" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi8_t mubi8_and_hi(mubi8_t a, mubi8_t b);
    return mubi8_and(a, b, MuBi8True);
  endfunction : mubi8_and_hi

  // Performs a logical OR operation between two multibit values.
  // This treats "False" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi8_t mubi8_or_lo(mubi8_t a, mubi8_t b);
    return mubi8_or(a, b, MuBi8False);
  endfunction : mubi8_or_lo

  // Performs a logical AND operation between two multibit values.
  // This treats "False" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi8_t mubi8_and_lo(mubi8_t a, mubi8_t b);
    return mubi8_and(a, b, MuBi8False);
  endfunction : mubi8_and_lo

  //////////////////////////////////////////////
  // 12 Bit Multibit Type and Functions //
  //////////////////////////////////////////////

  parameter int MuBi12Width = 12;
  typedef enum logic [MuBi12Width-1:0] {
    MuBi12True = 12'h696, // enabled
    MuBi12False = 12'h969  // disabled
  } mubi12_t;

  // This is a prerequisite for the multibit functions below to work.
    function automatic bit assert_static_in_package_CheckMuBi12ValsComplementary_A(); 
    bit unused_bit [((MuBi12True == ~MuBi12False) ? 1 : -1)];                     
    unused_bit = '{default: 1'b0};                            
    return unused_bit[0];                                     
  endfunction

  // Test whether the multibit value is one of the valid enumerations
  function automatic logic mubi12_test_invalid(mubi12_t val);
    return ~(val inside {MuBi12True, MuBi12False});
  endfunction : mubi12_test_invalid

  // Convert a 1 input value to a mubi output
  function automatic mubi12_t mubi12_bool_to_mubi(logic val);
    return (val ? MuBi12True : MuBi12False);
  endfunction : mubi12_bool_to_mubi

  // Test whether the multibit value of type "mubi12_t" signals an "enabled" condition.
  // The strict version of this function requires
  // the multibit value to equal True.
  function automatic logic mubi12_test_true_strict(mubi12_t val);
    return MuBi12True == val;
  endfunction : mubi12_test_true_strict

  // Test whether the multibit value of type "logic vector" signals an "enabled" condition.
  // The strict version of this function requires
  // the multibit value to equal True.
  function automatic logic mubi12_logic_test_true_strict(logic [11:0] val);
    return MuBi12True == val;
  endfunction : mubi12_logic_test_true_strict

  // Test whether the multibit value signals a "disabled" condition.
  // The strict version of this function requires
  // the multibit value to equal False.
  function automatic logic mubi12_test_false_strict(mubi12_t val);
    return MuBi12False == val;
  endfunction : mubi12_test_false_strict

  // Test whether the multibit value signals an "enabled" condition.
  // The loose version of this function interprets all
  // values other than False as "enabled".
  function automatic logic mubi12_test_true_loose(mubi12_t val);
    return MuBi12False != val;
  endfunction : mubi12_test_true_loose

  // Test whether the multibit value signals a "disabled" condition.
  // The loose version of this function interprets all
  // values other than True as "disabled".
  function automatic logic mubi12_test_false_loose(mubi12_t val);
    return MuBi12True != val;
  endfunction : mubi12_test_false_loose


  // Performs a logical OR operation between two multibit values.
  // This treats "act" as logical 1, and all other values are
  // treated as 0. Truth table:
  //
  // A    | B    | OUT
  //------+------+-----
  // !act | !act | !act
  // act  | !act | act
  // !act | act  | act
  // act  | act  | act
  //
  function automatic mubi12_t mubi12_or(mubi12_t a, mubi12_t b, mubi12_t act);
    logic [MuBi12Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi12Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] || b_in[k];
      end else begin
        out[k] = a_in[k] && b_in[k];
      end
    end
    return mubi12_t'(out);
  endfunction : mubi12_or

  // Performs a logical AND operation between two multibit values.
  // This treats "act" as logical 1, and all other values are
  // treated as 0. Truth table:
  //
  // A    | B    | OUT
  //------+------+-----
  // !act | !act | !act
  // act  | !act | !act
  // !act | act  | !act
  // act  | act  | act
  //
  function automatic mubi12_t mubi12_and(mubi12_t a, mubi12_t b, mubi12_t act);
    logic [MuBi12Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi12Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] && b_in[k];
      end else begin
        out[k] = a_in[k] || b_in[k];
      end
    end
    return mubi12_t'(out);
  endfunction : mubi12_and

  // Performs a logical OR operation between two multibit values.
  // This treats "True" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi12_t mubi12_or_hi(mubi12_t a, mubi12_t b);
    return mubi12_or(a, b, MuBi12True);
  endfunction : mubi12_or_hi

  // Performs a logical AND operation between two multibit values.
  // This treats "True" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi12_t mubi12_and_hi(mubi12_t a, mubi12_t b);
    return mubi12_and(a, b, MuBi12True);
  endfunction : mubi12_and_hi

  // Performs a logical OR operation between two multibit values.
  // This treats "False" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi12_t mubi12_or_lo(mubi12_t a, mubi12_t b);
    return mubi12_or(a, b, MuBi12False);
  endfunction : mubi12_or_lo

  // Performs a logical AND operation between two multibit values.
  // This treats "False" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi12_t mubi12_and_lo(mubi12_t a, mubi12_t b);
    return mubi12_and(a, b, MuBi12False);
  endfunction : mubi12_and_lo

  //////////////////////////////////////////////
  // 16 Bit Multibit Type and Functions //
  //////////////////////////////////////////////

  parameter int MuBi16Width = 16;
  typedef enum logic [MuBi16Width-1:0] {
    MuBi16True = 16'h9696, // enabled
    MuBi16False = 16'h6969  // disabled
  } mubi16_t;

  // This is a prerequisite for the multibit functions below to work.
    function automatic bit assert_static_in_package_CheckMuBi16ValsComplementary_A(); 
    bit unused_bit [((MuBi16True == ~MuBi16False) ? 1 : -1)];                     
    unused_bit = '{default: 1'b0};                            
    return unused_bit[0];                                     
  endfunction

  // Test whether the multibit value is one of the valid enumerations
  function automatic logic mubi16_test_invalid(mubi16_t val);
    return ~(val inside {MuBi16True, MuBi16False});
  endfunction : mubi16_test_invalid

  // Convert a 1 input value to a mubi output
  function automatic mubi16_t mubi16_bool_to_mubi(logic val);
    return (val ? MuBi16True : MuBi16False);
  endfunction : mubi16_bool_to_mubi

  // Test whether the multibit value of type "mubi16_t" signals an "enabled" condition.
  // The strict version of this function requires
  // the multibit value to equal True.
  function automatic logic mubi16_test_true_strict(mubi16_t val);
    return MuBi16True == val;
  endfunction : mubi16_test_true_strict

  // Test whether the multibit value of type "logic vector" signals an "enabled" condition.
  // The strict version of this function requires
  // the multibit value to equal True.
  function automatic logic mubi16_logic_test_true_strict(logic [15:0] val);
    return MuBi16True == val;
  endfunction : mubi16_logic_test_true_strict

  // Test whether the multibit value signals a "disabled" condition.
  // The strict version of this function requires
  // the multibit value to equal False.
  function automatic logic mubi16_test_false_strict(mubi16_t val);
    return MuBi16False == val;
  endfunction : mubi16_test_false_strict

  // Test whether the multibit value signals an "enabled" condition.
  // The loose version of this function interprets all
  // values other than False as "enabled".
  function automatic logic mubi16_test_true_loose(mubi16_t val);
    return MuBi16False != val;
  endfunction : mubi16_test_true_loose

  // Test whether the multibit value signals a "disabled" condition.
  // The loose version of this function interprets all
  // values other than True as "disabled".
  function automatic logic mubi16_test_false_loose(mubi16_t val);
    return MuBi16True != val;
  endfunction : mubi16_test_false_loose


  // Performs a logical OR operation between two multibit values.
  // This treats "act" as logical 1, and all other values are
  // treated as 0. Truth table:
  //
  // A    | B    | OUT
  //------+------+-----
  // !act | !act | !act
  // act  | !act | act
  // !act | act  | act
  // act  | act  | act
  //
  function automatic mubi16_t mubi16_or(mubi16_t a, mubi16_t b, mubi16_t act);
    logic [MuBi16Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi16Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] || b_in[k];
      end else begin
        out[k] = a_in[k] && b_in[k];
      end
    end
    return mubi16_t'(out);
  endfunction : mubi16_or

  // Performs a logical AND operation between two multibit values.
  // This treats "act" as logical 1, and all other values are
  // treated as 0. Truth table:
  //
  // A    | B    | OUT
  //------+------+-----
  // !act | !act | !act
  // act  | !act | !act
  // !act | act  | !act
  // act  | act  | act
  //
  function automatic mubi16_t mubi16_and(mubi16_t a, mubi16_t b, mubi16_t act);
    logic [MuBi16Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi16Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] && b_in[k];
      end else begin
        out[k] = a_in[k] || b_in[k];
      end
    end
    return mubi16_t'(out);
  endfunction : mubi16_and

  // Performs a logical OR operation between two multibit values.
  // This treats "True" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi16_t mubi16_or_hi(mubi16_t a, mubi16_t b);
    return mubi16_or(a, b, MuBi16True);
  endfunction : mubi16_or_hi

  // Performs a logical AND operation between two multibit values.
  // This treats "True" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi16_t mubi16_and_hi(mubi16_t a, mubi16_t b);
    return mubi16_and(a, b, MuBi16True);
  endfunction : mubi16_and_hi

  // Performs a logical OR operation between two multibit values.
  // This treats "False" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi16_t mubi16_or_lo(mubi16_t a, mubi16_t b);
    return mubi16_or(a, b, MuBi16False);
  endfunction : mubi16_or_lo

  // Performs a logical AND operation between two multibit values.
  // This treats "False" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi16_t mubi16_and_lo(mubi16_t a, mubi16_t b);
    return mubi16_and(a, b, MuBi16False);
  endfunction : mubi16_and_lo

  //////////////////////////////////////////////
  // 20 Bit Multibit Type and Functions //
  //////////////////////////////////////////////

  parameter int MuBi20Width = 20;
  typedef enum logic [MuBi20Width-1:0] {
    MuBi20True = 20'h69696, // enabled
    MuBi20False = 20'h96969  // disabled
  } mubi20_t;

  // This is a prerequisite for the multibit functions below to work.
    function automatic bit assert_static_in_package_CheckMuBi20ValsComplementary_A(); 
    bit unused_bit [((MuBi20True == ~MuBi20False) ? 1 : -1)];                     
    unused_bit = '{default: 1'b0};                            
    return unused_bit[0];                                     
  endfunction

  // Test whether the multibit value is one of the valid enumerations
  function automatic logic mubi20_test_invalid(mubi20_t val);
    return ~(val inside {MuBi20True, MuBi20False});
  endfunction : mubi20_test_invalid

  // Convert a 1 input value to a mubi output
  function automatic mubi20_t mubi20_bool_to_mubi(logic val);
    return (val ? MuBi20True : MuBi20False);
  endfunction : mubi20_bool_to_mubi

  // Test whether the multibit value of type "mubi20_t" signals an "enabled" condition.
  // The strict version of this function requires
  // the multibit value to equal True.
  function automatic logic mubi20_test_true_strict(mubi20_t val);
    return MuBi20True == val;
  endfunction : mubi20_test_true_strict

  // Test whether the multibit value of type "logic vector" signals an "enabled" condition.
  // The strict version of this function requires
  // the multibit value to equal True.
  function automatic logic mubi20_logic_test_true_strict(logic [19:0] val);
    return MuBi20True == val;
  endfunction : mubi20_logic_test_true_strict

  // Test whether the multibit value signals a "disabled" condition.
  // The strict version of this function requires
  // the multibit value to equal False.
  function automatic logic mubi20_test_false_strict(mubi20_t val);
    return MuBi20False == val;
  endfunction : mubi20_test_false_strict

  // Test whether the multibit value signals an "enabled" condition.
  // The loose version of this function interprets all
  // values other than False as "enabled".
  function automatic logic mubi20_test_true_loose(mubi20_t val);
    return MuBi20False != val;
  endfunction : mubi20_test_true_loose

  // Test whether the multibit value signals a "disabled" condition.
  // The loose version of this function interprets all
  // values other than True as "disabled".
  function automatic logic mubi20_test_false_loose(mubi20_t val);
    return MuBi20True != val;
  endfunction : mubi20_test_false_loose


  // Performs a logical OR operation between two multibit values.
  // This treats "act" as logical 1, and all other values are
  // treated as 0. Truth table:
  //
  // A    | B    | OUT
  //------+------+-----
  // !act | !act | !act
  // act  | !act | act
  // !act | act  | act
  // act  | act  | act
  //
  function automatic mubi20_t mubi20_or(mubi20_t a, mubi20_t b, mubi20_t act);
    logic [MuBi20Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi20Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] || b_in[k];
      end else begin
        out[k] = a_in[k] && b_in[k];
      end
    end
    return mubi20_t'(out);
  endfunction : mubi20_or

  // Performs a logical AND operation between two multibit values.
  // This treats "act" as logical 1, and all other values are
  // treated as 0. Truth table:
  //
  // A    | B    | OUT
  //------+------+-----
  // !act | !act | !act
  // act  | !act | !act
  // !act | act  | !act
  // act  | act  | act
  //
  function automatic mubi20_t mubi20_and(mubi20_t a, mubi20_t b, mubi20_t act);
    logic [MuBi20Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi20Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] && b_in[k];
      end else begin
        out[k] = a_in[k] || b_in[k];
      end
    end
    return mubi20_t'(out);
  endfunction : mubi20_and

  // Performs a logical OR operation between two multibit values.
  // This treats "True" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi20_t mubi20_or_hi(mubi20_t a, mubi20_t b);
    return mubi20_or(a, b, MuBi20True);
  endfunction : mubi20_or_hi

  // Performs a logical AND operation between two multibit values.
  // This treats "True" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi20_t mubi20_and_hi(mubi20_t a, mubi20_t b);
    return mubi20_and(a, b, MuBi20True);
  endfunction : mubi20_and_hi

  // Performs a logical OR operation between two multibit values.
  // This treats "False" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi20_t mubi20_or_lo(mubi20_t a, mubi20_t b);
    return mubi20_or(a, b, MuBi20False);
  endfunction : mubi20_or_lo

  // Performs a logical AND operation between two multibit values.
  // This treats "False" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi20_t mubi20_and_lo(mubi20_t a, mubi20_t b);
    return mubi20_and(a, b, MuBi20False);
  endfunction : mubi20_and_lo

  //////////////////////////////////////////////
  // 24 Bit Multibit Type and Functions //
  //////////////////////////////////////////////

  parameter int MuBi24Width = 24;
  typedef enum logic [MuBi24Width-1:0] {
    MuBi24True = 24'h969696, // enabled
    MuBi24False = 24'h696969  // disabled
  } mubi24_t;

  // This is a prerequisite for the multibit functions below to work.
    function automatic bit assert_static_in_package_CheckMuBi24ValsComplementary_A(); 
    bit unused_bit [((MuBi24True == ~MuBi24False) ? 1 : -1)];                     
    unused_bit = '{default: 1'b0};                            
    return unused_bit[0];                                     
  endfunction

  // Test whether the multibit value is one of the valid enumerations
  function automatic logic mubi24_test_invalid(mubi24_t val);
    return ~(val inside {MuBi24True, MuBi24False});
  endfunction : mubi24_test_invalid

  // Convert a 1 input value to a mubi output
  function automatic mubi24_t mubi24_bool_to_mubi(logic val);
    return (val ? MuBi24True : MuBi24False);
  endfunction : mubi24_bool_to_mubi

  // Test whether the multibit value of type "mubi24_t" signals an "enabled" condition.
  // The strict version of this function requires
  // the multibit value to equal True.
  function automatic logic mubi24_test_true_strict(mubi24_t val);
    return MuBi24True == val;
  endfunction : mubi24_test_true_strict

  // Test whether the multibit value of type "logic vector" signals an "enabled" condition.
  // The strict version of this function requires
  // the multibit value to equal True.
  function automatic logic mubi24_logic_test_true_strict(logic [23:0] val);
    return MuBi24True == val;
  endfunction : mubi24_logic_test_true_strict

  // Test whether the multibit value signals a "disabled" condition.
  // The strict version of this function requires
  // the multibit value to equal False.
  function automatic logic mubi24_test_false_strict(mubi24_t val);
    return MuBi24False == val;
  endfunction : mubi24_test_false_strict

  // Test whether the multibit value signals an "enabled" condition.
  // The loose version of this function interprets all
  // values other than False as "enabled".
  function automatic logic mubi24_test_true_loose(mubi24_t val);
    return MuBi24False != val;
  endfunction : mubi24_test_true_loose

  // Test whether the multibit value signals a "disabled" condition.
  // The loose version of this function interprets all
  // values other than True as "disabled".
  function automatic logic mubi24_test_false_loose(mubi24_t val);
    return MuBi24True != val;
  endfunction : mubi24_test_false_loose


  // Performs a logical OR operation between two multibit values.
  // This treats "act" as logical 1, and all other values are
  // treated as 0. Truth table:
  //
  // A    | B    | OUT
  //------+------+-----
  // !act | !act | !act
  // act  | !act | act
  // !act | act  | act
  // act  | act  | act
  //
  function automatic mubi24_t mubi24_or(mubi24_t a, mubi24_t b, mubi24_t act);
    logic [MuBi24Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi24Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] || b_in[k];
      end else begin
        out[k] = a_in[k] && b_in[k];
      end
    end
    return mubi24_t'(out);
  endfunction : mubi24_or

  // Performs a logical AND operation between two multibit values.
  // This treats "act" as logical 1, and all other values are
  // treated as 0. Truth table:
  //
  // A    | B    | OUT
  //------+------+-----
  // !act | !act | !act
  // act  | !act | !act
  // !act | act  | !act
  // act  | act  | act
  //
  function automatic mubi24_t mubi24_and(mubi24_t a, mubi24_t b, mubi24_t act);
    logic [MuBi24Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi24Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] && b_in[k];
      end else begin
        out[k] = a_in[k] || b_in[k];
      end
    end
    return mubi24_t'(out);
  endfunction : mubi24_and

  // Performs a logical OR operation between two multibit values.
  // This treats "True" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi24_t mubi24_or_hi(mubi24_t a, mubi24_t b);
    return mubi24_or(a, b, MuBi24True);
  endfunction : mubi24_or_hi

  // Performs a logical AND operation between two multibit values.
  // This treats "True" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi24_t mubi24_and_hi(mubi24_t a, mubi24_t b);
    return mubi24_and(a, b, MuBi24True);
  endfunction : mubi24_and_hi

  // Performs a logical OR operation between two multibit values.
  // This treats "False" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi24_t mubi24_or_lo(mubi24_t a, mubi24_t b);
    return mubi24_or(a, b, MuBi24False);
  endfunction : mubi24_or_lo

  // Performs a logical AND operation between two multibit values.
  // This treats "False" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi24_t mubi24_and_lo(mubi24_t a, mubi24_t b);
    return mubi24_and(a, b, MuBi24False);
  endfunction : mubi24_and_lo

  //////////////////////////////////////////////
  // 28 Bit Multibit Type and Functions //
  //////////////////////////////////////////////

  parameter int MuBi28Width = 28;
  typedef enum logic [MuBi28Width-1:0] {
    MuBi28True = 28'h6969696, // enabled
    MuBi28False = 28'h9696969  // disabled
  } mubi28_t;

  // This is a prerequisite for the multibit functions below to work.
    function automatic bit assert_static_in_package_CheckMuBi28ValsComplementary_A(); 
    bit unused_bit [((MuBi28True == ~MuBi28False) ? 1 : -1)];                     
    unused_bit = '{default: 1'b0};                            
    return unused_bit[0];                                     
  endfunction

  // Test whether the multibit value is one of the valid enumerations
  function automatic logic mubi28_test_invalid(mubi28_t val);
    return ~(val inside {MuBi28True, MuBi28False});
  endfunction : mubi28_test_invalid

  // Convert a 1 input value to a mubi output
  function automatic mubi28_t mubi28_bool_to_mubi(logic val);
    return (val ? MuBi28True : MuBi28False);
  endfunction : mubi28_bool_to_mubi

  // Test whether the multibit value of type "mubi28_t" signals an "enabled" condition.
  // The strict version of this function requires
  // the multibit value to equal True.
  function automatic logic mubi28_test_true_strict(mubi28_t val);
    return MuBi28True == val;
  endfunction : mubi28_test_true_strict

  // Test whether the multibit value of type "logic vector" signals an "enabled" condition.
  // The strict version of this function requires
  // the multibit value to equal True.
  function automatic logic mubi28_logic_test_true_strict(logic [27:0] val);
    return MuBi28True == val;
  endfunction : mubi28_logic_test_true_strict

  // Test whether the multibit value signals a "disabled" condition.
  // The strict version of this function requires
  // the multibit value to equal False.
  function automatic logic mubi28_test_false_strict(mubi28_t val);
    return MuBi28False == val;
  endfunction : mubi28_test_false_strict

  // Test whether the multibit value signals an "enabled" condition.
  // The loose version of this function interprets all
  // values other than False as "enabled".
  function automatic logic mubi28_test_true_loose(mubi28_t val);
    return MuBi28False != val;
  endfunction : mubi28_test_true_loose

  // Test whether the multibit value signals a "disabled" condition.
  // The loose version of this function interprets all
  // values other than True as "disabled".
  function automatic logic mubi28_test_false_loose(mubi28_t val);
    return MuBi28True != val;
  endfunction : mubi28_test_false_loose


  // Performs a logical OR operation between two multibit values.
  // This treats "act" as logical 1, and all other values are
  // treated as 0. Truth table:
  //
  // A    | B    | OUT
  //------+------+-----
  // !act | !act | !act
  // act  | !act | act
  // !act | act  | act
  // act  | act  | act
  //
  function automatic mubi28_t mubi28_or(mubi28_t a, mubi28_t b, mubi28_t act);
    logic [MuBi28Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi28Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] || b_in[k];
      end else begin
        out[k] = a_in[k] && b_in[k];
      end
    end
    return mubi28_t'(out);
  endfunction : mubi28_or

  // Performs a logical AND operation between two multibit values.
  // This treats "act" as logical 1, and all other values are
  // treated as 0. Truth table:
  //
  // A    | B    | OUT
  //------+------+-----
  // !act | !act | !act
  // act  | !act | !act
  // !act | act  | !act
  // act  | act  | act
  //
  function automatic mubi28_t mubi28_and(mubi28_t a, mubi28_t b, mubi28_t act);
    logic [MuBi28Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi28Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] && b_in[k];
      end else begin
        out[k] = a_in[k] || b_in[k];
      end
    end
    return mubi28_t'(out);
  endfunction : mubi28_and

  // Performs a logical OR operation between two multibit values.
  // This treats "True" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi28_t mubi28_or_hi(mubi28_t a, mubi28_t b);
    return mubi28_or(a, b, MuBi28True);
  endfunction : mubi28_or_hi

  // Performs a logical AND operation between two multibit values.
  // This treats "True" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi28_t mubi28_and_hi(mubi28_t a, mubi28_t b);
    return mubi28_and(a, b, MuBi28True);
  endfunction : mubi28_and_hi

  // Performs a logical OR operation between two multibit values.
  // This treats "False" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi28_t mubi28_or_lo(mubi28_t a, mubi28_t b);
    return mubi28_or(a, b, MuBi28False);
  endfunction : mubi28_or_lo

  // Performs a logical AND operation between two multibit values.
  // This treats "False" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi28_t mubi28_and_lo(mubi28_t a, mubi28_t b);
    return mubi28_and(a, b, MuBi28False);
  endfunction : mubi28_and_lo

  //////////////////////////////////////////////
  // 32 Bit Multibit Type and Functions //
  //////////////////////////////////////////////

  parameter int MuBi32Width = 32;
  typedef enum logic [MuBi32Width-1:0] {
    MuBi32True = 32'h96969696, // enabled
    MuBi32False = 32'h69696969  // disabled
  } mubi32_t;

  // This is a prerequisite for the multibit functions below to work.
    function automatic bit assert_static_in_package_CheckMuBi32ValsComplementary_A(); 
    bit unused_bit [((MuBi32True == ~MuBi32False) ? 1 : -1)];                     
    unused_bit = '{default: 1'b0};                            
    return unused_bit[0];                                     
  endfunction

  // Test whether the multibit value is one of the valid enumerations
  function automatic logic mubi32_test_invalid(mubi32_t val);
    return ~(val inside {MuBi32True, MuBi32False});
  endfunction : mubi32_test_invalid

  // Convert a 1 input value to a mubi output
  function automatic mubi32_t mubi32_bool_to_mubi(logic val);
    return (val ? MuBi32True : MuBi32False);
  endfunction : mubi32_bool_to_mubi

  // Test whether the multibit value of type "mubi32_t" signals an "enabled" condition.
  // The strict version of this function requires
  // the multibit value to equal True.
  function automatic logic mubi32_test_true_strict(mubi32_t val);
    return MuBi32True == val;
  endfunction : mubi32_test_true_strict

  // Test whether the multibit value of type "logic vector" signals an "enabled" condition.
  // The strict version of this function requires
  // the multibit value to equal True.
  function automatic logic mubi32_logic_test_true_strict(logic [31:0] val);
    return MuBi32True == val;
  endfunction : mubi32_logic_test_true_strict

  // Test whether the multibit value signals a "disabled" condition.
  // The strict version of this function requires
  // the multibit value to equal False.
  function automatic logic mubi32_test_false_strict(mubi32_t val);
    return MuBi32False == val;
  endfunction : mubi32_test_false_strict

  // Test whether the multibit value signals an "enabled" condition.
  // The loose version of this function interprets all
  // values other than False as "enabled".
  function automatic logic mubi32_test_true_loose(mubi32_t val);
    return MuBi32False != val;
  endfunction : mubi32_test_true_loose

  // Test whether the multibit value signals a "disabled" condition.
  // The loose version of this function interprets all
  // values other than True as "disabled".
  function automatic logic mubi32_test_false_loose(mubi32_t val);
    return MuBi32True != val;
  endfunction : mubi32_test_false_loose


  // Performs a logical OR operation between two multibit values.
  // This treats "act" as logical 1, and all other values are
  // treated as 0. Truth table:
  //
  // A    | B    | OUT
  //------+------+-----
  // !act | !act | !act
  // act  | !act | act
  // !act | act  | act
  // act  | act  | act
  //
  function automatic mubi32_t mubi32_or(mubi32_t a, mubi32_t b, mubi32_t act);
    logic [MuBi32Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi32Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] || b_in[k];
      end else begin
        out[k] = a_in[k] && b_in[k];
      end
    end
    return mubi32_t'(out);
  endfunction : mubi32_or

  // Performs a logical AND operation between two multibit values.
  // This treats "act" as logical 1, and all other values are
  // treated as 0. Truth table:
  //
  // A    | B    | OUT
  //------+------+-----
  // !act | !act | !act
  // act  | !act | !act
  // !act | act  | !act
  // act  | act  | act
  //
  function automatic mubi32_t mubi32_and(mubi32_t a, mubi32_t b, mubi32_t act);
    logic [MuBi32Width-1:0] a_in, b_in, act_in, out;
    a_in = a;
    b_in = b;
    act_in = act;
    for (int k = 0; k < MuBi32Width; k++) begin
      if (act_in[k]) begin
        out[k] = a_in[k] && b_in[k];
      end else begin
        out[k] = a_in[k] || b_in[k];
      end
    end
    return mubi32_t'(out);
  endfunction : mubi32_and

  // Performs a logical OR operation between two multibit values.
  // This treats "True" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi32_t mubi32_or_hi(mubi32_t a, mubi32_t b);
    return mubi32_or(a, b, MuBi32True);
  endfunction : mubi32_or_hi

  // Performs a logical AND operation between two multibit values.
  // This treats "True" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi32_t mubi32_and_hi(mubi32_t a, mubi32_t b);
    return mubi32_and(a, b, MuBi32True);
  endfunction : mubi32_and_hi

  // Performs a logical OR operation between two multibit values.
  // This treats "False" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi32_t mubi32_or_lo(mubi32_t a, mubi32_t b);
    return mubi32_or(a, b, MuBi32False);
  endfunction : mubi32_or_lo

  // Performs a logical AND operation between two multibit values.
  // This treats "False" as logical 1, and all other values are
  // treated as 0.
  function automatic mubi32_t mubi32_and_lo(mubi32_t a, mubi32_t b);
    return mubi32_and(a, b, MuBi32False);
  endfunction : mubi32_and_lo

endpackage : prim_mubi_pkg
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module prim_sec_anchor_buf #(
  parameter int Width = 1
) (
  input        [Width-1:0] in_i,
  output logic [Width-1:0] out_o
);

  prim_buf #(
    .Width(Width)
  ) u_secure_anchor_buf (
    .in_i,
    .out_o
  );

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module prim_sec_anchor_flop #(
  parameter int               Width      = 1,
  parameter logic [Width-1:0] ResetValue = 0
) (
  input                    clk_i,
  input                    rst_ni,
  input        [Width-1:0] d_i,
  output logic [Width-1:0] q_o
);

  prim_flop #(
    .Width(Width),
    .ResetValue(ResetValue)
  ) u_secure_anchor_flop (
    .clk_i,
    .rst_ni,
    .d_i,
    .q_o
  );

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0


/**
 * Utility functions
 */
package prim_util_pkg;
  /**
   * Math function: Number of bits needed to address |value| items.
   *
   *                  0        for value == 0
   * vbits =          1        for value == 1
   *         ceil(log2(value)) for value > 1
   *
   *
   * The primary use case for this function is the definition of registers/arrays
   * which are wide enough to contain |value| items.
   *
   * This function identical to $clog2() for all input values except the value 1;
   * it could be considered an "enhanced" $clog2() function.
   *
   *
   * Example 1:
   *   parameter Items = 1;
   *   localparam ItemsWidth = vbits(Items); // 1
   *   logic [ItemsWidth-1:0] item_register; // items_register is now [0:0]
   *
   * Example 2:
   *   parameter Items = 64;
   *   localparam ItemsWidth = vbits(Items); // 6
   *   logic [ItemsWidth-1:0] item_register; // items_register is now [5:0]
   *
   * Note: If you want to store the number "value" inside a register, you need
   * a register with size vbits(value + 1), since you also need to store
   * the number 0.
   *
   * Example 3:
   *   logic [vbits(64)-1:0]     store_64_logic_values; // width is [5:0]
   *   logic [vbits(64 + 1)-1:0] store_number_64;       // width is [6:0]
   */
  function automatic integer vbits(integer value);
    return (value == 1) ? 1 : $clog2(value);
  endfunction

  /**
   * Computes the ceiling division of two integer values.
   *
   * This function performs integer division and rounds the result up to the nearest integer.
   * It effectively computes the smallest integer greater than or equal to dividend / divisor.
   *
   * @param dividend The integer dividend.
   * @param divisor The integer divisor.
   * @return The ceiling division result (dividend / divisor, rounded up).
   *
   * Example:
   * ceil_div(10, 3) returns 4
   * ceil_div(12, 4) returns 3
   * ceil_div(15, 6) returns 3
   */
  function automatic integer ceil_div(input integer dividend, input integer divisor);
    ceil_div = ((dividend % divisor) != 0) ? (dividend / divisor) + 1 : (dividend / divisor);
  endfunction



endpackage
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Double-flop-based synchronizer

module prim_flop_2sync #(
  parameter int               Width      = 16,
  parameter logic [Width-1:0] ResetValue = '0,
  parameter bit               EnablePrimCdcRand = 1
) (
  input                    clk_i,
  input                    rst_ni,
  input        [Width-1:0] d_i,
  output logic [Width-1:0] q_o
);

  logic [Width-1:0] d_o;
  logic [Width-1:0] intq;

// !`ifdef SIMULATION
  logic unused_sig;
  assign unused_sig = EnablePrimCdcRand;
  always_comb d_o = d_i;
 // !`ifdef SIMULATION

  prim_flop #(
    .Width(Width),
    .ResetValue(ResetValue)
  ) u_sync_1 (
    .clk_i,
    .rst_ni,
    .d_i(d_o),
    .q_o(intq)
  );

  prim_flop #(
    .Width(Width),
    .ResetValue(ResetValue)
  ) u_sync_2 (
    .clk_i,
    .rst_ni,
    .d_i(intq),
    .q_o
  );

endmodule : prim_flop_2sync
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Onehot checker.
//
// This module checks whether the input vector oh_i is onehot0 and generates an error if not.
//
// Optionally, two additional checks can be activated:
//
// 1) EnableCheck: this check performs an OR reduction of the onehot vector, and compares
//    the result with en_i. If there is a mismatch, an error is generated.
// 2) AddrCheck: this checks whether the onehot bit is in the correct position.
//    It requires an additional address addr_i to be supplied to the module.
//
// All checks make use of an explicit binary tree implementation in order to minimize the delay.
//

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module prim_onehot_check #(
  parameter int unsigned AddrWidth   = 5,
  // The onehot width can be <= 2**AddrWidth and does not have to be a power of two.
  parameter int unsigned OneHotWidth = 2**AddrWidth,
  // If set to 0, the addr_i input will not be used for the check and can be tied off.
  parameter bit          AddrCheck   = 1,
  // If set to 0, the en_i value will not be used for the check and can be tied off.
  parameter bit          EnableCheck = 1,
  // If set to 1, the oh_i vector must always be one hot if en_i is set to 1.
  // If set to 0, the oh_i vector may be 0 if en_i is set to 1 (useful when oh_i can be masked).
  parameter bit          StrictCheck = 1,
  // This should only be disabled in special circumstances, for example
  // in non-comportable IPs where an error does not trigger an alert.
  parameter bit EnableAlertTriggerSVA = 1
) (
  // The module is combinational - the clock and reset are only used for assertions.
  input                          clk_i,
  input                          rst_ni,

  input  logic [OneHotWidth-1:0] oh_i,
  input  logic [AddrWidth-1:0]   addr_i,
  input  logic                   en_i,

  output logic                   err_o
);

  ///////////////////////
  // Binary tree logic //
  ///////////////////////

  
  
  
  

  // Align to powers of 2 for simplicity.
  // A full binary tree with N levels has 2**N + 2**N-1 nodes.
  localparam int NumLevels = AddrWidth;
  logic [2**(NumLevels+1)-2:0] or_tree;
  logic [2**(NumLevels+1)-2:0] and_tree; // Used for the address check
  logic [2**(NumLevels+1)-2:0] err_tree; // Used for the enable check

  for (genvar level = 0; level < NumLevels+1; level++) begin : gen_tree
    //
    // level+1   C0   C1   <- "Base1" points to the first node on "level+1",
    //            \  /         these nodes are the children of the nodes one level below
    // level       Pa      <- "Base0", points to the first node on "level",
    //                         these nodes are the parents of the nodes one level above
    //
    // hence we have the following indices for the paPa, C0, C1 nodes:
    // Pa = 2**level     - 1 + offset       = Base0 + offset
    // C0 = 2**(level+1) - 1 + 2*offset     = Base1 + 2*offset
    // C1 = 2**(level+1) - 1 + 2*offset + 1 = Base1 + 2*offset + 1
    //
    localparam int Base0 = (2**level)-1;
    localparam int Base1 = (2**(level+1))-1;

    for (genvar offset = 0; offset < 2**level; offset++) begin : gen_level
      localparam int Pa = Base0 + offset;
      localparam int C0 = Base1 + 2*offset;
      localparam int C1 = Base1 + 2*offset + 1;

      // This assigns the input values, their corresponding IDs and valid signals to the tree leafs.
      if (level == NumLevels) begin : gen_leafs
        if (offset < OneHotWidth) begin : gen_assign
          assign or_tree[Pa]  = oh_i[offset];
          assign and_tree[Pa] = oh_i[offset];
        end else begin : gen_tie_off
          assign or_tree[Pa]  = 1'b0;
          assign and_tree[Pa] = 1'b0;
        end
        assign err_tree[Pa] = 1'b0;
      // This creates the node assignments.
      end else begin : gen_nodes
        assign or_tree[Pa]  = or_tree[C0] || or_tree[C1];
        assign and_tree[Pa] = (!addr_i[AddrWidth-1-level] && and_tree[C0]) ||
                              (addr_i[AddrWidth-1-level] && and_tree[C1]);
        assign err_tree[Pa] = (or_tree[C0] && or_tree[C1]) || err_tree[C0] || err_tree[C1];
      end
    end : gen_level
  end : gen_tree

  ///////////////////
  // Onehot Checks //
  ///////////////////

  logic enable_err, addr_err, oh0_err;
  assign err_o = oh0_err || enable_err || addr_err;

  // Check that no more than 1 bit is set in the vector.
  assign oh0_err = err_tree[0];
  

  // Check that en_i agrees with (|oh_i).
  // Note: if StrictCheck 0, the oh_i vector may be all-zero if en_i == 1 (but not vice versa).
  if (EnableCheck) begin : gen_enable_check
    if (StrictCheck) begin : gen_strict
      assign enable_err = or_tree[0] ^ en_i;
      
    end else begin : gen_not_strict
      assign enable_err = !en_i && or_tree[0];
      
    end
  end else begin : gen_no_enable_check
    logic unused_or_tree;
    assign unused_or_tree = ^or_tree;
    assign enable_err = 1'b0;
  end

  // Check that the set bit is actually in the correct position.
  if (AddrCheck) begin : gen_addr_check_strict
    assign addr_err = or_tree[0] ^ and_tree[0];
    
  end else begin : gen_no_addr_check_strict
    logic unused_and_tree;
    assign unused_and_tree = ^and_tree;
    assign addr_err = 1'b0;
  end

  // We want to know that a block that instantiates prim_onehot_check will raise an alert if we set
  // our err_o output.
  //
  // For confidence that this is true, we use the scheme described in "Security Countermeasure
  // Verification Framework". We expect a user of prim_onehot_check to use the
  // ASSERT_PRIM_COUNT_ERROR_TRIGGER_ALERT macro to check that they will indeed raise an alert if we
  // set err_o.
  //
  // That macro is also designed to drive our local unused_assert_connected variable to true. We add
  // an assertion locally that checks (just after the start of time) that it is indeed true. This
  // gives us confidence that the user has bound up the alert correctly.


endmodule : prim_onehot_check
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Single-Port SRAM Wrapper
//
// Supported configurations:
// - ECC for 32b and 64b wide memories with no write mask
//   (Width == 32 or Width == 64, DataBitsPerMask is ignored).
// - Byte parity if Width is a multiple of 8 bit and write masks have Byte
//   granularity (DataBitsPerMask == 8).
//
// Note that the write mask needs to be per Byte if parity is enabled. If ECC is enabled, the write
// mask cannot be used and has to be tied to {Width{1'b1}}.

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module prim_ram_1p_adv import prim_ram_1p_pkg::*; #(
  parameter  int Depth                = 512,
  // Setting InstDepth to a smaller value than Depth enables RAM tiling. RAM is tiled to
  // ceil(Depth/InstDepth) prim_ram_1p instances, each InstDepth deep.
  parameter  int InstDepth            = Depth,
  parameter  int Width                = 32,
  parameter  int DataBitsPerMask      = 1,  // Number of data bits per bit of write mask
  parameter      MemInitFile          = "", // VMEM file to initialize the memory with

  // Configurations
  parameter  bit EnableECC            = 0, // Enables per-word ECC
  parameter  bit EnableParity         = 0, // Enables per-Byte Parity
  parameter  bit EnableInputPipeline  = 0, // Adds an input register (read latency +1)
  parameter  bit EnableOutputPipeline = 0, // Adds an output register (read latency +1)

  // This switch allows to switch to standard Hamming ECC instead of the HSIAO ECC.
  // It is recommended to leave this parameter at its default setting (HSIAO),
  // since this results in a more compact and faster implementation.
  parameter bit HammingECC            = 0,

  localparam int Aw                   = prim_util_pkg::vbits(Depth),
  // Compute RAM tiling
  localparam int NumRamInst           = prim_util_pkg::ceil_div(Depth, InstDepth),
  localparam int InstAw               = prim_util_pkg::vbits(InstDepth)
) (
  input clk_i,
  input rst_ni,

  input                               req_i,
  input                               write_i,
  input        [Aw-1:0]               addr_i,
  input        [Width-1:0]            wdata_i,
  input        [Width-1:0]            wmask_i,
  output logic [Width-1:0]            rdata_o,
  output logic                        rvalid_o, // read response (rdata_o) is valid
  output logic [1:0]                  rerror_o, // Bit1: Uncorrectable, Bit0: Correctable

  // config
  input  ram_1p_cfg_t     [NumRamInst-1:0] cfg_i,
  output ram_1p_cfg_rsp_t [NumRamInst-1:0] cfg_rsp_o,

  // When detecting multi-bit encoding errors, raise alert.
  output logic                             alert_o
);

  import prim_mubi_pkg::mubi4_t;
  import prim_mubi_pkg::mubi4_and_hi;
  import prim_mubi_pkg::mubi4_bool_to_mubi;
  import prim_mubi_pkg::mubi4_test_invalid;
  import prim_mubi_pkg::mubi4_test_true_loose;
  import prim_mubi_pkg::mubi4_test_true_strict;
  import prim_mubi_pkg::MuBi4True;
  import prim_mubi_pkg::MuBi4False;
  import prim_mubi_pkg::MuBi4Width;

  

  // Calculate ECC width
  localparam int ParWidth  = (EnableParity) ? Width/8 :
                             (!EnableECC)   ? 0 :
                             (Width <=   4) ? 4 :
                             (Width <=  11) ? 5 :
                             (Width <=  26) ? 6 :
                             (Width <=  57) ? 7 :
                             (Width <= 120) ? 8 : 8 ;
  localparam int TotalWidth = Width + ParWidth;

  // If byte parity is enabled, the write enable bits are used to write memory columns
  // with 8 + 1 = 9 bit width (data plus corresponding parity bit).
  // If ECC is enabled, the DataBitsPerMask is ignored.
  localparam int LocalDataBitsPerMask = (EnableParity) ? 9          :
                                        (EnableECC)    ? TotalWidth :
                                                         DataBitsPerMask;

  ////////////////////////////
  // RAM Primitive Instance //
  ////////////////////////////

  mubi4_t                  req_q,     req_d,    req_buf_d ;
  logic [MuBi4Width-1:0]   req_buf_b_d;
  logic                    req_q_b ;
  mubi4_t                  write_q,   write_d,  write_buf_d ;
  logic [MuBi4Width-1:0]   write_buf_b_d;
  logic                    write_q_b ;
  logic [Aw-1:0]           addr_q,    addr_d ;
  logic [TotalWidth-1:0]   wdata_q,   wdata_d ;
  logic [TotalWidth-1:0]   wmask_q,   wmask_d ;
  mubi4_t                  rvalid_q,  rvalid_d, rvalid_sram_q, rvalid_sram_d ;
  logic [Width-1:0]        rdata_q,   rdata_d ;
  logic [TotalWidth-1:0]   rdata_sram ;
  logic [1:0]              rerror_q,  rerror_d ;

  assign req_q_b = mubi4_test_true_loose(req_q);
  assign write_q_b = mubi4_test_true_loose(write_q);

  logic [NumRamInst-1:0] inst_req_d, inst_req_q, rvalid_inst;
  logic [InstAw-1:0] inst_addr;
  logic [NumRamInst-1:0] [Width-1:0] inst_rdata;

  // The lower InstAw bits of the address are used to address within one RAM primitive
  assign inst_addr = addr_q[InstAw-1:0];

  // The upper bits Aw-1:InstAw of the address select which RAM instance is selected. A special case
  // is needed when no tiling is performed and only a single RAM macro is instantiated. Here, we
  // can directly use the request signal and no demuxing is needed.
  if (NumRamInst == 1) begin : gen_single_inst_req
    assign inst_req_d[0] = req_q_b;
  end else begin : gen_multi_inst_req
    always_comb begin
      inst_req_d = '0;

      for (int i = 0; i < NumRamInst; i++) begin
        if (req_q_b && (i == addr_q[Aw-1:InstAw])) begin
          inst_req_d[i] = 1'b1;
        end
      end
    end
  end

  // Flop the instance request signal to know to know which
  // tile to select for read data on the next cycle
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      inst_req_q <= '0;
    end else begin
      inst_req_q <= inst_req_d;
    end
  end

  // Ensure that only one RAM instance gets activated
  

  for (genvar i = 0; i < NumRamInst; i++) begin : gen_ram_inst
    prim_ram_1p #(
      .MemInitFile     (MemInitFile),

      .Width           (TotalWidth),
      .Depth           (InstDepth),
      .DataBitsPerMask (LocalDataBitsPerMask)
    ) u_mem (
      .clk_i,
      .rst_ni,

      .req_i     (inst_req_d[i]),
      .write_i   (write_q_b),
      .addr_i    (inst_addr),
      .wdata_i   (wdata_q),
      .wmask_i   (wmask_q),
      .rdata_o   (inst_rdata[i]),
      .cfg_i     (cfg_i[i]),
      .cfg_rsp_o (cfg_rsp_o[i])
    );
  end

  // Mux output data
  always_comb begin
    rdata_sram = '0;

    for (int i = 0; i < NumRamInst; i++) begin
      // Determine which RAM tile we accessed based on the floped inst_req signal and we really
      // got an rvalid. This determines if we mux the output data of that particular RAM tile.
      rvalid_inst[i] = mubi4_test_true_strict(
        mubi4_and_hi(mubi4_bool_to_mubi(inst_req_q[i]), rvalid_sram_q));

      if(rvalid_inst[i]) begin
        rdata_sram = inst_rdata[i];
      end
    end
  end

  assign rvalid_sram_d = mubi4_and_hi(req_q, mubi4_t'(~write_q));

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rvalid_sram_q <= MuBi4False;
    end else begin
      rvalid_sram_q <= rvalid_sram_d;
    end
  end

  assign req_d              = mubi4_bool_to_mubi(req_i);
  assign write_d            = mubi4_bool_to_mubi(write_i);
  assign addr_d             = addr_i;
  assign rvalid_o           = mubi4_test_true_loose(rvalid_q);
  assign rdata_o            = rdata_q;
  assign rerror_o           = rerror_q;

  prim_buf #(
    .Width(MuBi4Width)
  ) u_req_d_buf (
    .in_i (req_d),
    .out_o(req_buf_b_d)
  );

  assign req_buf_d = mubi4_t'(req_buf_b_d);

  prim_buf #(
    .Width(MuBi4Width)
  ) u_write_d_buf (
    .in_i (write_d),
    .out_o(write_buf_b_d)
  );

  assign write_buf_d = mubi4_t'(write_buf_b_d);

  /////////////////////////////
  // ECC / Parity Generation //
  /////////////////////////////

  if (EnableParity == 0 && EnableECC) begin : gen_secded
    logic unused_wmask;
    assign unused_wmask = ^wmask_i;

    // check supported widths
    

    // the wmask is constantly set to 1 in this case
    

    assign wmask_d = {TotalWidth{1'b1}};

    if (Width == 16) begin : gen_secded_22_16
      if (HammingECC) begin : gen_hamming
        prim_secded_inv_hamming_22_16_enc u_enc (
          .data_i(wdata_i),
          .data_o(wdata_d)
        );
        prim_secded_inv_hamming_22_16_dec u_dec (
          .data_i     (rdata_sram),
          .data_o     (rdata_d[0+:Width]),
          .syndrome_o ( ),
          .err_o      (rerror_d)
        );
      end else begin : gen_hsiao
        prim_secded_inv_22_16_enc u_enc (
          .data_i(wdata_i),
          .data_o(wdata_d)
        );
        prim_secded_inv_22_16_dec u_dec (
          .data_i     (rdata_sram),
          .data_o     (rdata_d[0+:Width]),
          .syndrome_o ( ),
          .err_o      (rerror_d)
        );
      end
    end else if (Width == 32) begin : gen_secded_39_32
      if (HammingECC) begin : gen_hamming
        prim_secded_inv_hamming_39_32_enc u_enc (
          .data_i(wdata_i),
          .data_o(wdata_d)
        );
        prim_secded_inv_hamming_39_32_dec u_dec (
          .data_i     (rdata_sram),
          .data_o     (rdata_d[0+:Width]),
          .syndrome_o ( ),
          .err_o      (rerror_d)
        );
      end else begin : gen_hsiao
        prim_secded_inv_39_32_enc u_enc (
          .data_i(wdata_i),
          .data_o(wdata_d)
        );
        prim_secded_inv_39_32_dec u_dec (
          .data_i     (rdata_sram),
          .data_o     (rdata_d[0+:Width]),
          .syndrome_o ( ),
          .err_o      (rerror_d)
        );
      end
    end

  end else if (EnableParity) begin : gen_byte_parity

    
    

    always_comb begin : p_parity
      rerror_d = '0;
      for (int i = 0; i < Width/8; i ++) begin
        // Data mapping. We have to make 8+1 = 9 bit groups
        // that have the same write enable such that FPGA tools
        // can map this correctly to BRAM resources.
        wmask_d[i*9 +: 8] = wmask_i[i*8 +: 8];
        wdata_d[i*9 +: 8] = wdata_i[i*8 +: 8];
        rdata_d[i*8 +: 8] = rdata_sram[i*9 +: 8];

        // parity generation (odd parity)
        wdata_d[i*9 + 8] = ~(^wdata_i[i*8 +: 8]);
        wmask_d[i*9 + 8] = &wmask_i[i*8 +: 8];
        // parity decoding (errors are always uncorrectable)
        rerror_d[1] |= ~(^{rdata_sram[i*9 +: 8], rdata_sram[i*9 + 8]});
      end
    end
  end else begin : gen_nosecded_noparity
    assign wmask_d = wmask_i;
    assign wdata_d = wdata_i;

    assign rdata_d  = rdata_sram[0+:Width];
    assign rerror_d = '0;
  end

  assign rvalid_d = rvalid_sram_q;

  /////////////////////////////////////
  // Input/Output Pipeline Registers //
  /////////////////////////////////////

  if (EnableInputPipeline) begin : gen_regslice_input
    // Put the register slices between ECC encoding to SRAM port

    // If no ECC or parity is used, do not use prim_flop to allow synthesis
    // tool to optimize the registers.
    if (EnableECC || EnableParity) begin : gen_prim_flop
      prim_flop #(
        .Width(MuBi4Width),
        .ResetValue(MuBi4Width'(MuBi4False))
      ) u_write_flop (
        .clk_i,
        .rst_ni,
        .d_i(MuBi4Width'(write_buf_d)),
        .q_o({write_q})
      );

      prim_flop #(
        .Width(MuBi4Width),
        .ResetValue(MuBi4Width'(MuBi4False))
      ) u_req_flop (
        .clk_i,
        .rst_ni,
        .d_i(MuBi4Width'(req_buf_d)),
        .q_o({req_q})
      );
    end else begin: gen_no_prim_flop
      always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
          write_q <= MuBi4False;
          req_q   <= MuBi4False;
        end else begin
          write_q <= write_buf_d;
          req_q   <= req_buf_d;
        end
      end
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        addr_q  <= '0;
        wdata_q <= '0;
        wmask_q <= '0;
      end else begin
        addr_q  <= addr_d;
        wdata_q <= wdata_d;
        wmask_q <= wmask_d;
      end
    end
  end else begin : gen_dirconnect_input
    assign req_q   = req_buf_d;
    assign write_q = write_buf_d;
    assign addr_q  = addr_d;
    assign wdata_q = wdata_d;
    assign wmask_q = wmask_d;
  end

  if (EnableOutputPipeline) begin : gen_regslice_output
    // Put the register slices between ECC decoding to output

    // If no ECC or parity is used, do not use prim_flop to allow synthesis
    // tool to optimize the registers.
    if (EnableECC || EnableParity) begin : gen_prim_rvalid_flop
      prim_flop #(
        .Width(MuBi4Width),
        .ResetValue(MuBi4Width'(MuBi4False))
      ) u_rvalid_flop (
        .clk_i,
        .rst_ni,
        .d_i(MuBi4Width'(rvalid_d)),
        .q_o({rvalid_q})
      );
    end else begin: gen_no_prim_rvalid_flop
      always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
          rvalid_q <= MuBi4False;
        end else begin
          rvalid_q <= rvalid_d;
        end
      end
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        rdata_q  <= '0;
        rerror_q <= '0;
      end else begin
        rdata_q  <= rdata_d;
        // tie to zero if the read data is not valid
        rerror_q <= rerror_d & {2{mubi4_test_true_loose(rvalid_d)}};
      end
    end
  end else begin : gen_dirconnect_output
    assign rvalid_q = rvalid_d;
    assign rdata_q  = rdata_d;
    // tie to zero if the read data is not valid
    assign rerror_q = rerror_d & {2{mubi4_test_true_loose(rvalid_d)}};
  end

  assign alert_o = mubi4_test_invalid(req_q) | mubi4_test_invalid(write_q) |
                   mubi4_test_invalid(rvalid_q) | mubi4_test_invalid(rvalid_sram_q);

endmodule : prim_ram_1p_adv
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

package tlul_pkg;

  // this can be either PPC or BINTREE
  // there is no functional difference, but timing and area behavior is different
  // between the two instances. PPC can result in smaller implementations when timing
  // is not critical, whereas BINTREE is favorable when timing pressure is high (but this
  // may also result in a larger implementation). on FPGA targets, BINTREE is favorable
  // both in terms of area and timing.
  parameter ArbiterImpl = "PPC";

  typedef enum logic [2:0] {
    PutFullData    = 3'h 0,
    PutPartialData = 3'h 1,
    Get            = 3'h 4
  } tl_a_op_e;

  typedef enum logic [2:0] {
    AccessAck     = 3'h 0,
    AccessAckData = 3'h 1
  } tl_d_op_e;

  parameter int H2DCmdMaxWidth  = 57;
  parameter int H2DCmdIntgWidth = 7;
  parameter int H2DCmdFullWidth = H2DCmdMaxWidth + H2DCmdIntgWidth;
  parameter int D2HRspMaxWidth  = 57;
  parameter int D2HRspIntgWidth = 7;
  parameter int D2HRspFullWidth = D2HRspMaxWidth + D2HRspIntgWidth;
  parameter int DataMaxWidth    = 32;
  parameter int DataIntgWidth   = 7;
  parameter int DataFullWidth   = DataMaxWidth + DataIntgWidth;
  parameter int RsvdWidth       = top_pkg::TL_AUW - prim_mubi_pkg::MuBi4Width -
                                  H2DCmdIntgWidth - DataIntgWidth;

  // Data that is returned upon an a TL-UL error belonging to an instruction fetch.
  // Note that this data will be returned with the correct bus integrity value.
  parameter logic [top_pkg::TL_DW-1:0] DataWhenInstrError = '0;
  // Data that is returned upon an a TL-UL error not belonging to an instruction fetch.
  // Note that this data will be returned with the correct bus integrity value.
  parameter logic [top_pkg::TL_DW-1:0] DataWhenError      = {top_pkg::TL_DW{1'b1}};

  typedef struct packed {
    logic [RsvdWidth-1:0]       rsvd;
    prim_mubi_pkg::mubi4_t      instr_type;
    logic [H2DCmdIntgWidth-1:0] cmd_intg;
    logic [DataIntgWidth-1:0]   data_intg;
  } tl_a_user_t;

  parameter tl_a_user_t TL_A_USER_DEFAULT = '{
    rsvd: '0,
    instr_type: prim_mubi_pkg::MuBi4False,
    cmd_intg:  {H2DCmdIntgWidth{1'b1}},
    data_intg: {DataIntgWidth{1'b1}}
  };

  typedef struct packed {
    prim_mubi_pkg::mubi4_t        instr_type;
    logic   [top_pkg::TL_AW-1:0]  addr;
    tl_a_op_e                     opcode;
    logic  [top_pkg::TL_DBW-1:0]  mask;
  } tl_h2d_cmd_intg_t;

  typedef struct packed {
    logic                         a_valid;
    tl_a_op_e                     a_opcode;
    logic                  [2:0]  a_param;
    logic  [top_pkg::TL_SZW-1:0]  a_size;
    logic  [top_pkg::TL_AIW-1:0]  a_source;
    logic   [top_pkg::TL_AW-1:0]  a_address;
    logic  [top_pkg::TL_DBW-1:0]  a_mask;
    logic   [top_pkg::TL_DW-1:0]  a_data;
    tl_a_user_t                   a_user;

    logic                         d_ready;
  } tl_h2d_t;

  // The choice of all 1's as the blanked value is deliberate.
  // It is assumed that most security features of the design are opt-in instead
  // of opt-out.
  // Given the opt-in nature, if a 0 were to propagate, the feature would be turned
  // off.  Whereas if a 1 were to propagate, it would either stay on or be turned on.
  // There is however no perfect value for this purpose.
  localparam logic [top_pkg::TL_DW-1:0] BlankedAData = {top_pkg::TL_DW{1'b1}};

  localparam tl_h2d_t TL_H2D_DEFAULT = '{
    d_ready:  1'b1,
    a_opcode: tl_a_op_e'('0),
    a_user:   TL_A_USER_DEFAULT,
    a_data:   BlankedAData,
    default:  '0
  };

  typedef struct packed {
    logic [D2HRspIntgWidth-1:0]    rsp_intg;
    logic [DataIntgWidth-1:0]      data_intg;
  } tl_d_user_t;

  parameter tl_d_user_t TL_D_USER_DEFAULT = '{
    rsp_intg: {D2HRspIntgWidth{1'b1}},
    data_intg: {DataIntgWidth{1'b1}}
  };

  typedef struct packed {
    logic                         d_valid;
    tl_d_op_e                     d_opcode;
    logic                  [2:0]  d_param;
    logic  [top_pkg::TL_SZW-1:0]  d_size;   // Bouncing back a_size
    logic  [top_pkg::TL_AIW-1:0]  d_source;
    logic  [top_pkg::TL_DIW-1:0]  d_sink;
    logic   [top_pkg::TL_DW-1:0]  d_data;
    tl_d_user_t                   d_user;
    logic                         d_error;

    logic                         a_ready;

  } tl_d2h_t;

  typedef struct packed {
    tl_d_op_e                     opcode;
    logic  [top_pkg::TL_SZW-1:0]  size;
    // Temporarily removed because source changes throughout the fabric
    // and thus cannot be used for end-to-end checking.
    // A different PR will propose a work-around (a hoaky one) to see if
    // it gets the job done.
    //logic  [top_pkg::TL_AIW-1:0]  source;
    logic                         error;
  } tl_d2h_rsp_intg_t;

  localparam tl_d2h_t TL_D2H_DEFAULT = '{
    a_ready:  1'b1,
    d_opcode: tl_d_op_e'('0),
    d_user:   TL_D_USER_DEFAULT,
    default:  '0
  };

  // Check user for unsupported values
  function automatic logic tl_a_user_chk(tl_a_user_t user);
    logic malformed_err;
    logic unused_user;
    unused_user = |user;
    malformed_err = prim_mubi_pkg::mubi4_test_invalid(user.instr_type);
    return malformed_err;
  endfunction // tl_a_user_chk

  // extract variables used for command checking
  function automatic tl_h2d_cmd_intg_t extract_h2d_cmd_intg(tl_h2d_t tl);
    tl_h2d_cmd_intg_t payload;
    logic unused_tlul;
    unused_tlul = ^tl;
    payload.addr = tl.a_address;
    payload.opcode = tl.a_opcode;
    payload.mask = tl.a_mask;
    payload.instr_type = tl.a_user.instr_type;
    return payload;
  endfunction // extract_h2d_payload

  // extract variables used for response checking
  function automatic tl_d2h_rsp_intg_t extract_d2h_rsp_intg(tl_d2h_t tl);
    tl_d2h_rsp_intg_t payload;
    logic unused_tlul;
    unused_tlul = ^tl;
    payload.opcode = tl.d_opcode;
    payload.size   = tl.d_size;
    //payload.source = tl.d_source;
    payload.error  = tl.d_error;
    return payload;
  endfunction // extract_d2h_rsp_intg

  // calculate ecc for command checking
  function automatic logic [H2DCmdIntgWidth-1:0] get_cmd_intg(tl_h2d_t tl);
    logic [H2DCmdIntgWidth-1:0] cmd_intg;
    logic [H2DCmdMaxWidth-1:0] unused_cmd_payload;
    tl_h2d_cmd_intg_t cmd;
    cmd = extract_h2d_cmd_intg(tl);
    {cmd_intg, unused_cmd_payload} =
        prim_secded_pkg::prim_secded_inv_64_57_enc(H2DCmdMaxWidth'(cmd));
   return cmd_intg;
  endfunction  // get_cmd_intg

  // calculate ecc for data checking
  function automatic logic [DataIntgWidth-1:0] get_data_intg(logic [top_pkg::TL_DW-1:0] data);
    logic [DataIntgWidth-1:0] data_intg;
    logic [top_pkg::TL_DW-1:0] unused_data;
    logic [DataIntgWidth + top_pkg::TL_DW - 1 : 0] enc_data;
    enc_data = prim_secded_pkg::prim_secded_inv_39_32_enc(data);
    data_intg = enc_data[DataIntgWidth + top_pkg::TL_DW - 1 : top_pkg::TL_DW];
    unused_data = enc_data[top_pkg::TL_DW - 1 : 0];
    return data_intg;
  endfunction  // get_data_intg

  // return inverted integrity for command payload
  function automatic logic [H2DCmdIntgWidth-1:0] get_bad_cmd_intg(tl_h2d_t tl);
    logic [H2DCmdIntgWidth-1:0] cmd_intg;
    cmd_intg = get_cmd_intg(tl);
    return ~cmd_intg;
  endfunction // get_bad_cmd_intg

  // return inverted integrity for data payload
  function automatic logic [H2DCmdIntgWidth-1:0] get_bad_data_intg(logic [top_pkg::TL_DW-1:0] data);
    logic [H2DCmdIntgWidth-1:0] data_intg;
    data_intg = get_data_intg(data);
    return ~data_intg;
  endfunction // get_bad_data_intg

endpackage
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
//
// util/topgen.py -t hw/top_earlgrey/data/top_earlgrey.hjson
//                -o hw/top_earlgrey/


package top_racl_pkg;
  // Number of RACL policies used
  parameter int unsigned NrRaclPolicies = 1;

  // RACL Policy selector bits
  parameter int unsigned RaclPolicySelLen = prim_util_pkg::vbits(NrRaclPolicies);

  // RACL Policy selector type
  typedef logic [RaclPolicySelLen-1:0] racl_policy_sel_t;

  // Enable TLUL error response on RACL denied accesses
  parameter bit ErrorRsp = 0;

  // Number of RACL bits transferred
  parameter int unsigned NrRaclBits = 1;

  // Number of CTN UID bits transferred
  parameter int unsigned NrCtnUidBits = 1;

  // RACL role type binary encoded
  typedef logic [NrRaclBits-1:0] racl_role_t;

  // CTN UID assigned the bus originator
  typedef logic [NrCtnUidBits-1:0] ctn_uid_t;

  // RACL permission: A one-hot encoded role vector
  typedef logic [(2**NrRaclBits)-1:0] racl_role_vec_t;

  // RACL policy containing a read and write permission
  typedef struct packed {
    racl_role_vec_t write_perm;    // Write permission (upper bits)
    racl_role_vec_t read_perm;     // Read permission (lower bits)
  } racl_policy_t;

  // RACL range used to protect a range of addresses with a RACL policy (e.g., for sram).
  typedef struct packed {
    logic [top_pkg::TL_AW-1:0] base;       // Start address of range
    logic [top_pkg::TL_AW-1:0] limit;      // End address of range (inclusive)
    racl_policy_sel_t          policy_sel; // Policy selector
    logic                      enable;     // 0: Range is disabled, 1: Range is enabled
  } racl_range_t;

  // RACL policy vector for distributing RACL policies from the RACL widget to the subscribing IP
  typedef racl_policy_t [NrRaclPolicies-1:0] racl_policy_vec_t;

  // Default policy vector for unconnected RACL IPs
  parameter racl_policy_vec_t RACL_POLICY_VEC_DEFAULT = '0;

  // Default policy selection range for unconnected RACL IPs
  parameter racl_range_t RACL_RANGE_T_DEFAULT = '0;

  // Default ROT Private read policy value
  parameter racl_role_vec_t RACL_POLICY_ROT_PRIVATE_RD = 2'h0;

  // Default ROT Private write policy value
  parameter racl_role_vec_t RACL_POLICY_ROT_PRIVATE_WR = 2'h0;

  // RACL information logged in case of a denial
  typedef struct packed {
    logic                      valid;        // Error information is valid
    logic                      overflow;     // Error overflow, More than 1 RACL error at a time
    racl_role_t                racl_role;
    ctn_uid_t                  ctn_uid;
    logic                      read_access;  // 0: Write access, 1: Read access
    logic [top_pkg::TL_AW-1:0] request_address;
  } racl_error_log_t;

  // Extract RACL role bits from the TLUL reserved user bits
  function automatic racl_role_t tlul_extract_racl_role_bits(logic [tlul_pkg::RsvdWidth-1:0] rsvd);
    // Waive unused bits
    logic unused_rsvd_bits;
    unused_rsvd_bits = ^{rsvd};

    return racl_role_t'(rsvd[0:0]);
  endfunction

  // Extract CTN UID bits from the TLUL reserved user bits
  function automatic ctn_uid_t tlul_extract_ctn_uid_bits(logic [tlul_pkg::RsvdWidth-1:0] rsvd);
    // Waive unused bits
    logic unused_rsvd_bits;
    unused_rsvd_bits = ^{rsvd};

    return ctn_uid_t'(rsvd[0:0]);
  endfunction


endpackage
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// N:1 arbiter module
//
// Verilog parameter
//   N:           Number of request ports
//   DW:          Data width
//   DataPort:    Set to 1 to enable the data port. Otherwise that port will be ignored.
//
// This is a tree implementation of a round robin arbiter. It has the same behavior as the PPC
// implementation in prim_arbiter_ppc, and also uses a prefix summing approach to determine the next
// request to be granted. The main difference with respect to the PPC arbiter is that the leading 1
// detection and the prefix summation are performed with a binary tree instead of a sequential loop.
// Also, if the data port is enabled, the data is muxed based on the local arbitration decisions  at
// each node of the arbiter tree. This means that the data can propagate through the tree
// simultaneously with the requests, instead of waiting for the arbitration to determine the winner
// index first. As a result, this design has a shorter critical path than other implementations,
// leading to better overall timing.
//
// Note that the currently winning request is held if the data sink is not ready. This behavior is
// required by some interconnect protocols (AXI, TL). The module contains an assertion that checks
// this behavior.
//
// Also, this module contains a request stability assertion that checks that requests stay asserted
// until they have been served. This assertion can be gated by driving the req_chk_i low. This is
// a non-functional input and does not affect the designs behavior.
//
// See also: prim_arbiter_ppc

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module prim_arbiter_tree #(
  parameter int N   = 8,
  parameter int DW  = 32,

  // Configurations
  // EnDataPort: {0, 1}, if 0, input data will be ignored
  parameter bit EnDataPort = 1,

  // Derived parameters
  localparam int IdxW = $clog2(N)
) (
  input clk_i,
  input rst_ni,

  input                    req_chk_i, // Used for gating assertions. Drive to 1 during normal
                                      // operation.
  input        [ N-1:0]    req_i,
  input        [DW-1:0]    data_i [N],
  output logic [ N-1:0]    gnt_o,
  output logic [IdxW-1:0]  idx_o,

  output logic             valid_o,
  output logic [DW-1:0]    data_o,
  input                    ready_i
);

  // req_chk_i is used for gating assertions only.
  logic unused_req_chk;
  assign unused_req_chk = req_chk_i;

  

  // this case is basically just a bypass
  if (N == 1) begin : gen_degenerate_case

    assign valid_o  = req_i[0];
    assign data_o   = data_i[0];
    assign gnt_o[0] = valid_o & ready_i;
    assign idx_o    = '0;

  end else begin : gen_normal_case

    // align to powers of 2 for simplicity
    // a full binary tree with N levels has 2**N + 2**N-1 nodes
    logic [2**(IdxW+1)-2:0]           req_tree;
    logic [2**(IdxW+1)-2:0]           prio_tree;
    logic [2**(IdxW+1)-2:0]           sel_tree;
    logic [2**(IdxW+1)-2:0]           mask_tree;
    logic [2**(IdxW+1)-2:0][IdxW-1:0] idx_tree;
    logic [2**(IdxW+1)-2:0][DW-1:0]   data_tree;
    logic [N-1:0]                     prio_mask_d, prio_mask_q;

    for (genvar level = 0; level < IdxW+1; level++) begin : gen_tree
      //
      // level+1   C0   C1   <- "Base1" points to the first node on "level+1",
      //            \  /         these nodes are the children of the nodes one level below
      // level       Pa      <- "Base0", points to the first node on "level",
      //                         these nodes are the parents of the nodes one level above
      //
      // hence we have the following indices for the Pa, C0, C1 nodes:
      // Pa = 2**level     - 1 + offset       = Base0 + offset
      // C0 = 2**(level+1) - 1 + 2*offset     = Base1 + 2*offset
      // C1 = 2**(level+1) - 1 + 2*offset + 1 = Base1 + 2*offset + 1
      //
      localparam int Base0 = (2**level)-1;
      localparam int Base1 = (2**(level+1))-1;

      for (genvar offset = 0; offset < 2**level; offset++) begin : gen_level
        localparam int Pa = Base0 + offset;
        localparam int C0 = Base1 + 2*offset;
        localparam int C1 = Base1 + 2*offset + 1;

        // this assigns the gated interrupt source signals, their
        // corresponding IDs and priorities to the tree leafs
        if (level == IdxW) begin : gen_leafs
          if (offset < N) begin : gen_assign
            // forward path (requests and data)
            // all requests inputs are assigned to the request tree
            assign req_tree[Pa]      = req_i[offset];
            // we basically split the incoming request vector into two halves with the following
            // priority assignment. the prio_mask_q register contains a prefix sum that has been
            // computed using the last winning index, and hence masks out all requests at offsets
            // lower or equal the previously granted index. hence, all higher indices are considered
            // first in the arbitration tree nodes below, before considering the lower indices.
            assign prio_tree[Pa]     = req_i[offset] & prio_mask_q[offset];
            // input for the index muxes (used to compute the winner index)
            assign idx_tree[Pa]      = offset;
            // input for the data muxes
            assign data_tree[Pa]     = data_i[offset];

            // backward path (grants and prefix sum)
            // grant if selected, ready and request asserted
            assign gnt_o[offset]       = req_i[offset] & sel_tree[Pa] & ready_i;
            // only update mask if there is a valid request
            assign prio_mask_d[offset] = (|req_i) ?
                                         mask_tree[Pa] | sel_tree[Pa] & ~ready_i :
                                         prio_mask_q[offset];
          end else begin : gen_tie_off
            // forward path
            assign req_tree[Pa]  = '0;
            assign prio_tree[Pa] = '0;
            assign idx_tree[Pa]  = '0;
            assign data_tree[Pa] = '0;
            logic unused_sigs;
            assign unused_sigs = ^{mask_tree[Pa],
                                   sel_tree[Pa]};
          end
        // this creates the node assignments
        end else begin : gen_nodes
          // local helper variable
          logic sel;

          // forward path (requests and data)
          // each node looks at its two children, and selects the one with higher priority
          assign sel = ~req_tree[C0] | ~prio_tree[C0] & prio_tree[C1];
          // propagate requests
          assign req_tree[Pa]  = req_tree[C0] | req_tree[C1];
          assign prio_tree[Pa] = prio_tree[C1] | prio_tree[C0];
          // data and index muxes
          // Note: these ternaries have triggered a synthesis bug in Vivado versions older
          // than 2020.2. If the problem resurfaces again, have a look at issue #1408.
          assign idx_tree[Pa]  = (sel) ? idx_tree[C1]  : idx_tree[C0];
          assign data_tree[Pa] = (sel) ? data_tree[C1] : data_tree[C0];

          // backward path (grants and prefix sum)
          // this propagates the selection index back and computes a hot one mask
          assign sel_tree[C0] = sel_tree[Pa] & ~sel;
          assign sel_tree[C1] = sel_tree[Pa] &  sel;
          // this performs a prefix sum for masking the input requests in the next cycle
          assign mask_tree[C0] = mask_tree[Pa];
          assign mask_tree[C1] = mask_tree[Pa] | sel_tree[C0];
        end
      end : gen_level
    end : gen_tree

    // the results can be found at the tree root
    if (EnDataPort) begin : gen_data_port
      assign data_o      = data_tree[0];
    end else begin : gen_no_dataport
      logic [DW-1:0] unused_data;
      assign unused_data = data_tree[0];
      assign data_o = '1;
    end

    // This index is unused.
    logic unused_prio_tree;
    assign unused_prio_tree = prio_tree[0];

    assign idx_o       = idx_tree[0];
    assign valid_o     = req_tree[0];

    // the select tree computes a hot one signal that indicates which request is currently selected
    assign sel_tree[0] = 1'b1;
    // the mask tree is basically a prefix sum of the hot one select signal computed above
    assign mask_tree[0] = 1'b0;

    always_ff @(posedge clk_i or negedge rst_ni) begin : p_mask_reg
      if (!rst_ni) begin
        prio_mask_q <= '0;
      end else begin
        prio_mask_q <= prio_mask_d;
      end
    end
  end

  ////////////////
  // assertions //
  ////////////////

  // KNOWN assertions on outputs, except for data as that may be partially X in simulation
  // e.g. when used on a BUS
  
  
  

  // grant index shall be higher index than previous index, unless no higher requests exist.
  
  // we can only grant one requester at a time
  
  // A grant implies that the sink is ready
  
  // A grant implies that the arbiter asserts valid as well
  
  // A request and a sink that is ready imply a grant
  
  // A request and a sink that is ready imply a grant
  
  // Both conditions above combined and reversed
  
  // Both conditions above combined and reversed
  
  // check index / grant correspond
  

if (EnDataPort) begin: gen_data_port_assertion
  // data flow
  
end

  // requests must stay asserted until they have been granted
  
  // check that the arbitration decision is held if the sink is not ready
  

// FPV-only assertions with symbolic variables


endmodule : prim_arbiter_tree
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// This module decodes a differentially encoded signal and detects
// incorrectly encoded differential states.
//
// In case the differential pair crosses an asynchronous boundary, it has
// to be re-synchronized to the local clock. This can be achieved by
// setting the AsyncOn parameter to 1'b1. In that case, two additional
// input registers are added (to counteract metastability), and
// a pattern detector is instantiated that detects skewed level changes on
// the differential pair (i.e., when level changes on the diff pair are
// sampled one cycle apart due to a timing skew between the two wires).
//
// See also: prim_alert_sender, prim_alert_receiver, alert_handler

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module prim_diff_decode #(
  // enables additional synchronization logic
  parameter bit AsyncOn = 1'b0,
  // Number of cycles a differential skew is tolerated before a signal integrity issue is flagged.
  // Only has an effect if AsyncOn = 1
  // 0 means no skew is tolerated (any mismatch is an immediate signal integrity error).
  // 1 means a one-cycle skew is tolerated.
  // Values larger than 1 are also supported.
  parameter int unsigned SkewCycles = 1
) (
  input        clk_i,
  input        rst_ni,
  // input diff pair
  input        diff_pi,
  input        diff_ni,
  // logical level and
  // detected edges
  output logic level_o,
  output logic rise_o,
  output logic fall_o,
  // either rise or fall
  output logic event_o,
  //signal integrity issue detected
  output logic sigint_o
);

  logic level_d, level_q;

  ///////////////////////////////////////////////////////////////
  // synchronization regs for incoming diff pair (if required) //
  ///////////////////////////////////////////////////////////////
  if (AsyncOn) begin : gen_async

    typedef enum logic [1:0] {IsStd, IsSkewing, SigInt} state_e;
    state_e state_d, state_q;
    logic diff_p_edge, diff_n_edge, diff_check_ok, level;

    // 2 sync regs, one reg for edge detection
    logic diff_pq, diff_nq, diff_pd, diff_nd;

    // Counter for skew cycles tolerated before flagging an issue
    // The width needs to accommodate SkewCycles + 1 to count up to SkewCycles.
    logic [prim_util_pkg::vbits(SkewCycles + 1)-1:0] skew_cnt_d, skew_cnt_q;

    prim_flop_2sync #(
      .Width(1),
      .ResetValue('0)
    ) i_sync_p (
      .clk_i,
      .rst_ni,
      .d_i(diff_pi),
      .q_o(diff_pd)
    );

    prim_flop_2sync #(
      .Width(1),
      .ResetValue(1'b1)
    ) i_sync_n (
      .clk_i,
      .rst_ni,
      .d_i(diff_ni),
      .q_o(diff_nd)
    );

    // detect level transitions
    assign diff_p_edge   = diff_pq ^ diff_pd;
    assign diff_n_edge   = diff_nq ^ diff_nd;

    // detect sigint issue
    assign diff_check_ok = diff_pd ^ diff_nd;

    // this is the current logical level
    assign level         = diff_pd;

    // outputs
    assign level_o  = level_d;
    assign event_o = rise_o | fall_o;

    // sigint detection is a bit more involved in async case since
    // we might have skew on the diff pair, which can result in a
    // N cycle sampling delay between the two wires
    // so we need a simple pattern matcher
    // the following waves are legal
    // clk    |   |   |   |   |   |   |   |
    //           _______     _______
    // p _______/        ...        \________
    //   _______                     ________
    // n        \_______ ... _______/
    //              ____     ___
    // p __________/     ...    \________
    //   _______                     ________
    // n        \_______ ... _______/
    //
    // i.e., level changes may be off by N cycle - which is permissible
    // as long as this condition is only N cycle long.


    always_comb begin : p_diff_fsm
      // default
      state_d    = state_q;
      level_d    = level_q;
      skew_cnt_d = skew_cnt_q;
      rise_o     = 1'b0;
      fall_o     = 1'b0;
      sigint_o   = 1'b0;

      unique case (state_q)
        // we remain here as long as
        // the diff pair is correctly encoded
        IsStd: begin
          if (diff_check_ok) begin
            level_d = level;
            if (diff_p_edge && diff_n_edge) begin
              if (level) begin
                rise_o = 1'b1;
              end else begin
                fall_o = 1'b1;
              end
            end
          end else begin
            if (SkewCycles == 0) begin
              // If no skew is tolerated, immediate signal integrity error
              state_d  = SigInt;
              sigint_o = 1'b1;
            end else begin
              // Mismatch with an edge: likely start of a tolerated skew
              state_d    = IsSkewing;
              skew_cnt_d = 1;
            end
          end
        end
        // diff pair must be correctly encoded, otherwise we got a sigint
        IsSkewing: begin
          if (diff_check_ok) begin
            state_d    = IsStd;
            level_d    = level;
            // Reset the skew counter
            skew_cnt_d = '0;
            // Assert event that was delayed due to skew resolution
            if (level) rise_o = 1'b1;
            else       fall_o = 1'b1;
          end else begin
            if (skew_cnt_q < SkewCycles) begin
              // Still within tolerated skew cycles
              skew_cnt_d = skew_cnt_q + 1;
            end else begin
              // Maximum skew cycles exceeded, raise an integrity issue
              state_d    = SigInt;
              sigint_o   = 1'b1;
              skew_cnt_d = '0;
            end
          end
        end
        // Signal integrity issue detected, remain here until resolved
        SigInt: begin
          sigint_o = 1'b1;
          if (diff_check_ok) begin
            state_d  = IsStd;
            sigint_o = 1'b0;
            level_d  = level;
            // Assert any event that was pending while in SigInt
            if (level) rise_o = 1'b1;
            else       fall_o = 1'b1;
          end
        end
        default : ;
      endcase
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin : p_sync_reg
      if (!rst_ni) begin
        state_q    <= IsStd;
        diff_pq    <= 1'b0;
        diff_nq    <= 1'b1;
        level_q    <= 1'b0;
        skew_cnt_q <= '0;
      end else begin
        state_q    <= state_d;
        diff_pq    <= diff_pd;
        diff_nq    <= diff_nd;
        level_q    <= level_d;
        skew_cnt_q <= skew_cnt_d;
      end
    end

  //////////////////////////////////////////////////////////
  // fully synchronous case, no skew present in this case //
  //////////////////////////////////////////////////////////
  end else begin : gen_no_async
    logic diff_pq, diff_pd;

    // one reg for edge detection
    assign diff_pd = diff_pi;

    // Raise a signal integrity error when the differential signals have equal values.  This is
    // implemented with a `prim_xnor2` instead of behavioral code to prevent the synthesis tool from
    // optimizing away combinational logic on the complementary differential signals.
    prim_xnor2 #(
      .Width (1)
    ) u_xnor2_sigint (
      .in0_i (diff_pi),
      .in1_i (diff_ni),
      .out_o (sigint_o)
    );

    assign level_o = (sigint_o) ? level_q : diff_pi;
    assign level_d = level_o;

    // detect level transitions
    assign rise_o  = (~diff_pq &  diff_pi) & ~sigint_o;
    assign fall_o  = ( diff_pq & ~diff_pi) & ~sigint_o;
    assign event_o = rise_o | fall_o;

    always_ff @(posedge clk_i or negedge rst_ni) begin : p_edge_reg
      if (!rst_ni) begin
        diff_pq  <= 1'b0;
        level_q  <= 1'b0;
      end else begin
        diff_pq  <= diff_pd;
        level_q  <= level_d;
      end
    end
  end

  ////////////////
  // assertions //
  ////////////////

  // shared assertions
  // sigint -> level stays the same during sigint
  // $isunknown is needed to avoid false assertion in first clock cycle
  
  // sigint -> no additional events asserted at output
  
  
  

  if (AsyncOn) begin : gen_async_assert
    // assertions for asynchronous case

  end else begin : gen_sync_assert
    // assertions for synchronous case

  // correctly detect sigint issue
    
  

    // correctly detect edges
    
    
    
    // correctly detect level
    
  end

endmodule : prim_diff_decode
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Generic synchronous fifo for use in a variety of devices.

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


// This include isn't really needed by code in prim_fifo_sync.sv! But it ensures that we always
// evaluate the contents of prim_fifo_assert.svh if we happen to include this file, avoiding a
// problem where we might include a FIFO but not use any of the assertions that this file defines.
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Macros that define assertions that relate to FIFO implementations



// Use PRIM_COUNT_ERROR_TRIGGER_ALERT appropriately to check that the three prim_counts generated by
// a prim_fifo_sync with depth at least two do indeed generate an alert if they detect an error.
//
// - NAME_ is used as the root of the names of the generated assertions.
// - HIER_ is a hierarchical path to the prim_fifo_sync in question.
// - ALERT_ is the name of the alert that should be generated.
// - GATE_ is a signal that, if true, will cause an error to be ignored.
// - MAX_CYCLES_ is the number of cycles allowed until the alert must be generated.


// An analagous assertion to PRIM_COUNT_ERROR_TRIGGER_ALERT, but specialised for the case where the
// fifo has depth 1, which means there aren't actually three prim_count instances but instead there
// is just a single error signal.
//
// - NAME_ is used as a root for the name of the generated assertion.
// - HIER_ is a hierarchical path to the prim_fifo_sync in question.
// - ALERT_ is the name of the alert that should be generated.
// - GATE_ is a signal that, if true, will cause an error to be ignored.
// - MAX_CYCLES_ is the number of cycles allowed until the alert must be generated.


// A version of ASSERT_PRIM_FIFO_SYNC_ERROR_TRIGGERS_ALERT1, except that it uses
// ASSERT_ERROR_TRIGGER_ALERT_IN instead of ASSERT_ERROR_TRIGGER_ALERT. See description in
// prim_assert_se_cm.svh.


 // PRIM_FIFO_ASSERT_SVH


module prim_fifo_sync #(
  parameter int unsigned Width       = 16,
  parameter bit Pass                 = 1'b1, // if == 1 allow requests to pass through empty FIFO
  parameter int unsigned Depth       = 4,
  parameter bit OutputZeroIfEmpty    = 1'b1, // if == 1 always output 0 when FIFO is empty
  parameter bit NeverClears          = 1'b0, // if set, the clr_i port is never high
  parameter bit Secure               = 1'b0, // use prim count for pointers
  // derived parameter
  localparam int          DepthW     = prim_util_pkg::vbits(Depth+1)
) (
  input                   clk_i,
  input                   rst_ni,
  // synchronous clear / flush port
  input                   clr_i,
  // write port
  input                   wvalid_i,
  output                  wready_o,
  input   [Width-1:0]     wdata_i,
  // read port
  output                  rvalid_o,
  input                   rready_i,
  output  [Width-1:0]     rdata_o,
  // occupancy
  output                  full_o,
  output  [DepthW-1:0]    depth_o,
  output                  err_o
);


  // FIFO is in complete passthrough mode
  if (Depth == 0) begin : gen_passthru_fifo
    

    assign depth_o = 1'b0; //output is meaningless

    // device facing
    assign rvalid_o = wvalid_i;
    assign rdata_o = wdata_i;

    // host facing
    assign wready_o = rready_i;
    assign full_o = 1'b1;

    // this avoids lint warnings
    logic unused_clr;
    assign unused_clr = clr_i;

    // No error
    assign err_o = 1'b 0;

  // FIFO has space for a single element (and doesn't need proper counters)
  end else if (Depth == 1) begin : gen_singleton_fifo

    // full_q is true if the (singleton) queue has data
    logic full_d, full_q;

    assign full_o = full_q;
    assign depth_o = full_q;
    assign wready_o = ~full_q;

    // We can always read from the storage if it contains something, so rvalid_o is true if full_q
    // is true. Enabling pass-through mode also allows data to flow through if wvalid_i is true.
    assign rvalid_o = full_q || (Pass && wvalid_i);

    // For there to be data on the next cycle, there must either be new data coming in (so !rvalid_o
    // && wvalid_i) or we must be keeping the current data (so rvalid_o && !rready_i). Using
    // rvalid_o instead of full_q ensures we get the right behaviour with pass-through.
    //
    // In either case, any stored data will be forgotten if clr_i is true.
    assign full_d = (rvalid_o ? !rready_i : wvalid_i) && !clr_i;

    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        full_q <= 1'b0;
      end else begin
        full_q <= full_d;
      end
    end

    logic [Width-1:0] storage;
    always_ff @(posedge clk_i) begin
      if (wvalid_i && wready_o) storage <= wdata_i;
    end

    logic [Width-1:0] rdata_int;
    assign rdata_int = (full_q || Pass == 1'b0) ? storage : wdata_i;

    assign rdata_o = (OutputZeroIfEmpty && !rvalid_o) ? Width'(0) : rdata_int;

    // The larger FIFO implementation uses prim_count for read and write pointers. If Secure is
    // true, prim_count duplicates and checks these pointers to guard against fault injection. We do
    // something similar here, duplicating and checking a "1 bit counter".
    //
    // The duplication is inverted, which means we expect full_q ^ inv_full to be true and generate
    // an error signal if it is not. This error signal gets registered to avoid potential CDC issues
    // downstream.
    if (!Secure) begin : gen_not_secure
      assign err_o = 1'b0;
    end else begin : gen_secure
      logic inv_full;

      prim_flop #(
        .Width(1),
        .ResetValue(1'b1)
      ) u_inv_full (
        .clk_i,
        .rst_ni,
        .d_i (~full_d),
        .q_o (inv_full)
      );

      logic err_d, err_q;
      assign err_d = ~(full_q ^ inv_full);

      always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
          err_q <= 1'b0;
        end else begin
          err_q <= err_d;
        end
      end

      assign err_o = err_q;
    end

  // Normal FIFO construction
  end else begin : gen_normal_fifo

    localparam int unsigned PtrW = prim_util_pkg::vbits(Depth);

    logic [PtrW-1:0] fifo_wptr, fifo_rptr;
    logic            fifo_incr_wptr, fifo_incr_rptr, fifo_empty;

    // module under reset flag
    logic under_rst;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        under_rst <= 1'b1;
      end else if (under_rst) begin
        under_rst <= ~under_rst;
      end
    end

    logic empty;

    // full and not ready for write are two different concepts.
    // The latter can be '0' when under reset, while the former is an indication that no more
    // entries can be written.
    assign wready_o = ~full_o & ~under_rst;

    prim_fifo_sync_cnt #(
      .Depth(Depth),
      .Secure(Secure),
      .NeverClears(NeverClears)
    ) u_fifo_cnt (
      .clk_i,
      .rst_ni,
      .clr_i,
      .incr_wptr_i(fifo_incr_wptr),
      .incr_rptr_i(fifo_incr_rptr),
      .wptr_o(fifo_wptr),
      .rptr_o(fifo_rptr),
      .full_o,
      .empty_o(fifo_empty),
      .depth_o,
      .err_o
    );
    assign fifo_incr_wptr = wvalid_i & wready_o;
    assign fifo_incr_rptr = rvalid_o & rready_i & ~under_rst;

    logic [Depth-1:0][Width-1:0] storage;
    logic [Width-1:0] storage_rdata;

    assign storage_rdata = storage[fifo_rptr];

    always_ff @(posedge clk_i)
      if (fifo_incr_wptr) begin
        storage[fifo_wptr] <= wdata_i;
      end

    logic [Width-1:0] rdata_int;
    if (Pass == 1'b1) begin : gen_pass
      assign rdata_int = (fifo_empty && wvalid_i) ? wdata_i : storage_rdata;
      assign empty = fifo_empty & ~wvalid_i;
      assign rvalid_o = ~empty & ~under_rst;
    end else begin : gen_nopass
      assign rdata_int = storage_rdata;
      assign empty = fifo_empty;
      assign rvalid_o = ~empty;
    end

    if (OutputZeroIfEmpty == 1'b1) begin : gen_output_zero
      assign rdata_o = empty ? Width'(0) : rdata_int;
    end else begin : gen_no_output_zero
      assign rdata_o = rdata_int;
    end

    
    
  end // block: gen_normal_fifo


  if (NeverClears) begin : gen_never_clears
    
  end

  //////////////////////
  // Known Assertions //
  //////////////////////

                                                 
                                               

  
  
  


endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Read and write pointer logic for synchronous FIFOs

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module prim_fifo_sync_cnt #(
  // Depth of the FIFO, i.e., maximum number of entries the FIFO can contain
  parameter int unsigned Depth = 4,
  // Whether to instantiate hardened counters
  parameter bit Secure = 1'b0,
  // If this is set, the clr_i port will always be false
  parameter bit NeverClears = 1'b0,
  // Width of the read and write pointers for the FIFO
  localparam int unsigned PtrW = prim_util_pkg::vbits(Depth),
  // Width of the 'current depth' output
  localparam int unsigned DepthW = prim_util_pkg::vbits(Depth+1)
) (
  input clk_i,
  input rst_ni,
  input clr_i,
  input incr_wptr_i,
  input incr_rptr_i,
  // Write and read pointers.  Value range: [0, Depth-1]
  output logic [PtrW-1:0] wptr_o,
  output logic [PtrW-1:0] rptr_o,
  output logic full_o,
  output logic empty_o,
  // Current depth of the FIFO, i.e., number of entries the FIFO currently contains.
  // Value range: [0, Depth]
  output logic [DepthW-1:0] depth_o,
  output logic err_o
);

  // Internal 'wrap' pointers that have an extra leading bit to account for wraparounds.
  localparam int unsigned WrapPtrW = PtrW + 1;
  logic [WrapPtrW-1:0] wptr_wrap_cnt_q, wptr_wrap_set_cnt,
                       rptr_wrap_cnt_q, rptr_wrap_set_cnt;

  // Derive real read and write pointers by truncating the internal 'wrap' pointers.
  assign wptr_o = wptr_wrap_cnt_q[PtrW-1:0];
  assign rptr_o = rptr_wrap_cnt_q[PtrW-1:0];

  // Extract the MSB of the 'wrap' pointers.
  logic wptr_wrap_msb, rptr_wrap_msb;
  assign wptr_wrap_msb = wptr_wrap_cnt_q[WrapPtrW-1];
  assign rptr_wrap_msb = rptr_wrap_cnt_q[WrapPtrW-1];

  // Wrap pointers when they have reached the maximum value and are about to get incremented.
  logic wptr_wrap_set, rptr_wrap_set;
  assign wptr_wrap_set = incr_wptr_i & (wptr_o == PtrW'(Depth-1));
  assign rptr_wrap_set = incr_rptr_i & (rptr_o == PtrW'(Depth-1));

  // When wrapping, invert the MSB and reset all lower bits to zero.
  assign wptr_wrap_set_cnt = {~wptr_wrap_msb, {(WrapPtrW-1){1'b0}}};
  assign rptr_wrap_set_cnt = {~rptr_wrap_msb, {(WrapPtrW-1){1'b0}}};

  // Full when both 'wrap' counters have a different MSB but all lower bits are equal.
  assign full_o = wptr_wrap_cnt_q == (rptr_wrap_cnt_q ^ {1'b1, {(WrapPtrW-1){1'b0}}});
  // Empty when both 'wrap' counters are equal in all bits including the MSB.
  assign empty_o = wptr_wrap_cnt_q == rptr_wrap_cnt_q;

  // The current depth is equal to:
  // - when full: the maximum depth;
  // - when both or none of the 'wrap' pointers are wrapped: the difference of the real pointers;
  // - when only one of the two 'wrap' pointers is wrapped: the maximum depth minus the difference
  //   of the real pointers.
  assign depth_o = full_o                         ? DepthW'(Depth) :
                   wptr_wrap_msb == rptr_wrap_msb ? DepthW'(wptr_o) - DepthW'(rptr_o) :
                   DepthW'(Depth) - DepthW'(rptr_o) + DepthW'(wptr_o);

  if (Secure) begin : gen_secure_ptrs
    logic wptr_err;
    prim_count #(
      .Width(WrapPtrW),
      .PossibleActions((NeverClears ? prim_count_pkg::action_mask_t'(0) : prim_count_pkg::Clr) |
                       prim_count_pkg::Set | prim_count_pkg::Incr)
    ) u_wptr (
      .clk_i,
      .rst_ni,
      .clr_i,
      .set_i(wptr_wrap_set),
      .set_cnt_i(wptr_wrap_set_cnt),
      .incr_en_i(incr_wptr_i),
      .decr_en_i(1'b0),
      .step_i(WrapPtrW'(1'b1)),
      .commit_i(1'b1),
      .cnt_o(wptr_wrap_cnt_q),
      .cnt_after_commit_o(),
      .err_o(wptr_err)
    );

    logic rptr_err;
    prim_count #(
      .Width(WrapPtrW),
      .PossibleActions((NeverClears ? prim_count_pkg::action_mask_t'(0) : prim_count_pkg::Clr) |
                       prim_count_pkg::Set | prim_count_pkg::Incr)
    ) u_rptr (
      .clk_i,
      .rst_ni,
      .clr_i,
      .set_i(rptr_wrap_set),
      .set_cnt_i(rptr_wrap_set_cnt),
      .incr_en_i(incr_rptr_i),
      .decr_en_i(1'b0),
      .step_i(WrapPtrW'(1'b1)),
      .commit_i(1'b1),
      .cnt_o(rptr_wrap_cnt_q),
      .cnt_after_commit_o(),
      .err_o(rptr_err)
    );

    assign err_o = wptr_err | rptr_err;

  end else begin : gen_normal_ptrs
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        wptr_wrap_cnt_q <= {WrapPtrW{1'b0}};
      end else if (clr_i) begin
        wptr_wrap_cnt_q <= {WrapPtrW{1'b0}};
      end else if (wptr_wrap_set) begin
        wptr_wrap_cnt_q <= wptr_wrap_set_cnt;
      end else if (incr_wptr_i) begin
        wptr_wrap_cnt_q <= wptr_wrap_cnt_q + {{(WrapPtrW-1){1'b0}}, 1'b1};
      end
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        rptr_wrap_cnt_q <= {WrapPtrW{1'b0}};
      end else if (clr_i) begin
        rptr_wrap_cnt_q <= {WrapPtrW{1'b0}};
      end else if (rptr_wrap_set) begin
        rptr_wrap_cnt_q <= rptr_wrap_set_cnt;
      end else if (incr_rptr_i) begin
        rptr_wrap_cnt_q <= rptr_wrap_cnt_q + {{(WrapPtrW-1){1'b0}}, 1'b1};
      end
    end

    assign err_o = '0;
  end

  if (NeverClears) begin : gen_never_clears
    
  end

endmodule // prim_fifo_sync_cnt
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Spurious write-enable checker for autogenerated CSR node.
// This module has additional simulation features for error injection testing.

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module prim_reg_we_check #(
  parameter int unsigned OneHotWidth  = 32
) (
  // The module is combinational - the clock and reset are only used for assertions.
  input                          clk_i,
  input                          rst_ni,

  input  logic [OneHotWidth-1:0] oh_i,
  input  logic                   en_i,

  output logic                   err_o
);

  // Prevent optimization of the onehot input buffer.
  logic [OneHotWidth-1:0] oh_buf;
  prim_buf #(
    .Width(OneHotWidth)
  ) u_prim_buf (
    .in_i(oh_i),
    .out_o(oh_buf)
  );

  prim_onehot_check #(
    .OneHotWidth(OneHotWidth),
    .AddrWidth  (prim_util_pkg::vbits(OneHotWidth)),
    .EnableCheck(1),
    // Since certain peripherals may have a very large address space
    // (e.g. > 20bit), the inverse address decoding check (which is
    // essentially an indexing operation) does not scale well and is
    // hence omitted.
    .AddrCheck(0),
    // Due to REGWEN masking of write enable strobes,
    // we do not perform strict checks. I.e., we allow cases
    // where en_i is set to 1, but the oh_i vector is all-zeroes.
    .StrictCheck(0)
  ) u_prim_onehot_check (
    .clk_i,
    .rst_ni,
    .oh_i(oh_buf),
    .addr_i('0),
    .en_i,
    .err_o
  );

endmodule : prim_reg_we_check
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

package prim_subreg_pkg;

  // Register access specifier
  typedef enum logic [2:0] {
    SwAccessRW  = 3'd0, // Read-write
    SwAccessRO  = 3'd1, // Read-only
    SwAccessWO  = 3'd2, // Write-only
    SwAccessW1C = 3'd3, // Write 1 to clear
    SwAccessW1S = 3'd4, // Write 1 to set
    SwAccessW0C = 3'd5, // Write 0 to clear
    SwAccessRC  = 3'd6  // Read to clear. Do not use, only exists for compatibility.
  } sw_access_e;
endpackage
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register slice conforming to Comportability guide.

module prim_subreg
  import prim_subreg_pkg::*;
#(
  parameter int            DW       = 32,
  parameter sw_access_e    SwAccess = SwAccessRW,
  parameter logic [DW-1:0] RESVAL   = '0 ,   // reset value
  parameter bit            Mubi     = 1'b0
) (
  input clk_i,
  input rst_ni,

  // From SW: valid for RW, WO, W1C, W1S, W0C, RC
  // In case of RC, Top connects Read Pulse to we
  input          we,
  input [DW-1:0] wd,

  // From HW: valid for HRW, HWO
  input          de,
  input [DW-1:0] d,

  // output to HW and Reg Read
  output logic          qe,
  output logic [DW-1:0] q,

  // ds and qs have slightly different timing.
  // ds is the data that will be written into the flop,
  // while qs is the current flop value exposed to software.
  output logic [DW-1:0] ds,
  output logic [DW-1:0] qs
);

  logic          wr_en;
  logic [DW-1:0] wr_data;

  prim_subreg_arb #(
    .DW       ( DW       ),
    .SwAccess ( SwAccess ),
    .Mubi     ( Mubi     )
  ) wr_en_data_arb (
    .we,
    .wd,
    .de,
    .d,
    .q,
    .wr_en,
    .wr_data
  );

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      q <= RESVAL;
    end else if (wr_en) begin
      q <= wr_data;
    end
  end

  // feed back out for consolidation
  assign ds = wr_en ? wr_data : qs;
  assign qe = we;

  if (SwAccess == SwAccessRC) begin : gen_rc
    // In case of a SW RC colliding with a HW write, SW gets the value written by HW
    // but the register is cleared to 0. See #5416 for a discussion.
    assign qs = de && we ? d : q;
  end else begin : gen_no_rc
    assign qs = q;
  end

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Write enable and data arbitration logic for register slice conforming to Comportability guide.

module prim_subreg_arb
  import prim_subreg_pkg::*;
#(
  parameter int         DW       = 32,
  parameter sw_access_e SwAccess = SwAccessRW,
  parameter bit         Mubi     = 1'b0
) (
  // From SW: valid for RW, WO, W1C, W1S, W0C, RC.
  // In case of RC, top connects read pulse to we.
  input          we,
  input [DW-1:0] wd,

  // From HW: valid for HRW, HWO.
  input          de,
  input [DW-1:0] d,

  // From register: actual reg value.
  input [DW-1:0] q,

  // To register: actual write enable and write data.
  output logic          wr_en,
  output logic [DW-1:0] wr_data
);
  import prim_mubi_pkg::*;

  if ((SwAccess == SwAccessRW) || (SwAccess == SwAccessWO)) begin : gen_w
    assign wr_en   = we | de;
    assign wr_data = (we == 1'b1) ? wd : d; // SW higher priority
    // Unused q - Prevent lint errors.
    logic [DW-1:0] unused_q;
    //VCS coverage off
    // pragma coverage off
    assign unused_q = q;
    //VCS coverage on
    // pragma coverage on
  end else if (SwAccess == SwAccessRO) begin : gen_ro
    assign wr_en   = de;
    assign wr_data = d;
    // Unused we, wd, q - Prevent lint errors.
    logic          unused_we;
    logic [DW-1:0] unused_wd;
    logic [DW-1:0] unused_q;
    //VCS coverage off
    // pragma coverage off
    assign unused_we = we;
    assign unused_wd = wd;
    assign unused_q  = q;
    //VCS coverage on
    // pragma coverage on
  end else if (SwAccess == SwAccessW1S) begin : gen_w1s
    // If SwAccess is W1S, then assume hw tries to clear.
    // So, give a chance HW to clear when SW tries to set.
    // If both try to set/clr at the same bit pos, SW wins.
    assign wr_en   = we | de;
    if (Mubi) begin : gen_mubi
      if (DW == 4) begin : gen_mubi4
        assign wr_data = prim_mubi_pkg::mubi4_or_hi(prim_mubi_pkg::mubi4_t'(de ? d : q),
                                                    (we ? prim_mubi_pkg::mubi4_t'(wd) :
                                                          prim_mubi_pkg::MuBi4False));
      end else if (DW == 8) begin : gen_mubi8
        assign wr_data = prim_mubi_pkg::mubi8_or_hi(prim_mubi_pkg::mubi8_t'(de ? d : q),
                                                    (we ? prim_mubi_pkg::mubi8_t'(wd) :
                                                          prim_mubi_pkg::MuBi8False));
      end else if (DW == 12) begin : gen_mubi12
        assign wr_data = prim_mubi_pkg::mubi12_or_hi(prim_mubi_pkg::mubi12_t'(de ? d : q),
                                                     (we ? prim_mubi_pkg::mubi12_t'(wd) :
                                                           prim_mubi_pkg::MuBi12False));
      end else if (DW == 16) begin : gen_mubi16
        assign wr_data = prim_mubi_pkg::mubi16_or_hi(prim_mubi_pkg::mubi16_t'(de ? d : q),
                                                     (we ? prim_mubi_pkg::mubi16_t'(wd) :
                                                           prim_mubi_pkg::MuBi16False));
      end else begin : gen_invalid_mubi
        $error("%m: Invalid width for MuBi");
      end
    end else begin : gen_non_mubi
      assign wr_data = (de ? d : q) | (we ? wd : '0);
    end
  end else if (SwAccess == SwAccessW1C) begin : gen_w1c
    // If SwAccess is W1C, then assume hw tries to set.
    // So, give a chance HW to set when SW tries to clear.
    // If both try to set/clr at the same bit pos, SW wins.
    assign wr_en   = we | de;
    if (Mubi) begin : gen_mubi
      if (DW == 4) begin : gen_mubi4
        assign wr_data = prim_mubi_pkg::mubi4_and_hi(prim_mubi_pkg::mubi4_t'(de ? d : q),
                                                     (we ? prim_mubi_pkg::mubi4_t'(~wd) :
                                                           prim_mubi_pkg::MuBi4True));
      end else if (DW == 8) begin : gen_mubi8
        assign wr_data = prim_mubi_pkg::mubi8_and_hi(prim_mubi_pkg::mubi8_t'(de ? d : q),
                                                     (we ? prim_mubi_pkg::mubi8_t'(~wd) :
                                                           prim_mubi_pkg::MuBi8True));
      end else if (DW == 12) begin : gen_mubi12
        assign wr_data = prim_mubi_pkg::mubi12_and_hi(prim_mubi_pkg::mubi12_t'(de ? d : q),
                                                      (we ? prim_mubi_pkg::mubi12_t'(~wd) :
                                                            prim_mubi_pkg::MuBi12True));
      end else if (DW == 16) begin : gen_mubi16
        assign wr_data = prim_mubi_pkg::mubi16_and_hi(prim_mubi_pkg::mubi16_t'(de ? d : q),
                                                      (we ? prim_mubi_pkg::mubi16_t'(~wd) :
                                                            prim_mubi_pkg::MuBi16True));
      end else begin : gen_invalid_mubi
        $error("%m: Invalid width for MuBi");
      end
    end else begin : gen_non_mubi
      assign wr_data = (de ? d : q) & (we ? ~wd : '1);
    end
  end else if (SwAccess == SwAccessW0C) begin : gen_w0c
    assign wr_en   = we | de;
    if (Mubi) begin : gen_mubi
      if (DW == 4) begin : gen_mubi4
        assign wr_data = prim_mubi_pkg::mubi4_and_hi(prim_mubi_pkg::mubi4_t'(de ? d : q),
                                                     (we ? prim_mubi_pkg::mubi4_t'(wd) :
                                                           prim_mubi_pkg::MuBi4True));
      end else if (DW == 8) begin : gen_mubi8
        assign wr_data = prim_mubi_pkg::mubi8_and_hi(prim_mubi_pkg::mubi8_t'(de ? d : q),
                                                     (we ? prim_mubi_pkg::mubi8_t'(wd) :
                                                           prim_mubi_pkg::MuBi8True));
      end else if (DW == 12) begin : gen_mubi12
        assign wr_data = prim_mubi_pkg::mubi12_and_hi(prim_mubi_pkg::mubi12_t'(de ? d : q),
                                                      (we ? prim_mubi_pkg::mubi12_t'(wd) :
                                                            prim_mubi_pkg::MuBi12True));
      end else if (DW == 16) begin : gen_mubi16
        assign wr_data = prim_mubi_pkg::mubi16_and_hi(prim_mubi_pkg::mubi16_t'(de ? d : q),
                                                      (we ? prim_mubi_pkg::mubi16_t'(wd) :
                                                            prim_mubi_pkg::MuBi16True));
      end else begin : gen_invalid_mubi
        $error("%m: Invalid width for MuBi");
      end
    end else begin : gen_non_mubi
      assign wr_data = (de ? d : q) & (we ? wd : '1);
    end
  end else if (SwAccess == SwAccessRC) begin : gen_rc
    // This swtype is not recommended but exists for compatibility.
    // WARN: we signal is actually read signal not write enable.
    assign wr_en  = we | de;
    if (Mubi) begin : gen_mubi
      if (DW == 4) begin : gen_mubi4
        assign wr_data = prim_mubi_pkg::mubi4_and_hi(prim_mubi_pkg::mubi4_t'(de ? d : q),
                                                     (we ? prim_mubi_pkg::MuBi4False :
                                                           prim_mubi_pkg::MuBi4True));
      end else if (DW == 8) begin : gen_mubi8
        assign wr_data = prim_mubi_pkg::mubi8_and_hi(prim_mubi_pkg::mubi8_t'(de ? d : q),
                                                     (we ? prim_mubi_pkg::MuBi8False :
                                                           prim_mubi_pkg::MuBi8True));
      end else if (DW == 12) begin : gen_mubi12
        assign wr_data = prim_mubi_pkg::mubi12_and_hi(prim_mubi_pkg::mubi12_t'(de ? d : q),
                                                      (we ? prim_mubi_pkg::MuBi12False :
                                                            prim_mubi_pkg::MuBi12True));
      end else if (DW == 16) begin : gen_mubi16
        assign wr_data = prim_mubi_pkg::mubi16_and_hi(prim_mubi_pkg::mubi16_t'(de ? d : q),
                                                      (we ? prim_mubi_pkg::mubi16_t'(wd) :
                                                            prim_mubi_pkg::MuBi16True));
      end else begin : gen_invalid_mubi
        $error("%m: Invalid width for MuBi");
      end
    end else begin : gen_non_mubi
      assign wr_data = (de ? d : q) & (we ? '0 : '1);
    end
    // Unused wd - Prevent lint errors.
    logic [DW-1:0] unused_wd;
    //VCS coverage off
    // pragma coverage off
    assign unused_wd = wd;
    //VCS coverage on
    // pragma coverage on
  end else begin : gen_hw
    assign wr_en   = de;
    assign wr_data = d;
    // Unused we, wd, q - Prevent lint errors.
    logic          unused_we;
    logic [DW-1:0] unused_wd;
    logic [DW-1:0] unused_q;
    //VCS coverage off
    // pragma coverage off
    assign unused_we = we;
    assign unused_wd = wd;
    assign unused_q  = q;
    //VCS coverage on
    // pragma coverage on
  end

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register slice conforming to Comportability guide.

module prim_subreg_ext #(
  parameter int unsigned DW = 32
) (
  input          re,
  input          we,
  input [DW-1:0] wd,

  input [DW-1:0] d,

  // output to HW and Reg Read
  output logic          qe,
  output logic          qre,
  output logic [DW-1:0] q,
  output logic [DW-1:0] ds,
  output logic [DW-1:0] qs
);

  // for external registers, there is no difference
  // between qs and ds
  assign ds = d;
  assign qs = d;
  assign q = wd;
  assign qe = we;
  assign qre = re;

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


/**
 * Data integrity encoder for bus integrity scheme
 */

module tlul_data_integ_enc import tlul_pkg::*; (
  // TL-UL interface
  input        [DataMaxWidth-1:0]               data_i,
  output logic [DataMaxWidth+DataIntgWidth-1:0] data_intg_o
);

  prim_secded_inv_39_32_enc u_data_gen (
    .data_i,
    .data_o(data_intg_o)
  );

endmodule : tlul_data_integ_enc
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


/**
 * Data integrity decoder for bus integrity scheme
 */

module tlul_data_integ_dec import tlul_pkg::*; (
  // TL-UL interface
  input        [DataMaxWidth+DataIntgWidth-1:0] data_intg_i,
  output logic                                  data_err_o
);

  logic [1:0] data_err;
  prim_secded_inv_39_32_dec u_data_chk (
    .data_i(data_intg_i),
    .data_o(),
    .syndrome_o(),
    .err_o(data_err)
  );

  assign data_err_o = |data_err;

endmodule : tlul_data_integ_dec
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


/**
 * Tile-Link UL command integrity check
 */

module tlul_cmd_intg_chk import tlul_pkg::*; (
  // TL-UL interface
  input  tl_h2d_t tl_i,

  // error output
  output logic err_o
);

  logic [1:0] err;
  logic data_err;
  tl_h2d_cmd_intg_t cmd;
  assign cmd = extract_h2d_cmd_intg(tl_i);

  prim_secded_inv_64_57_dec u_chk (
    .data_i({tl_i.a_user.cmd_intg, H2DCmdMaxWidth'(cmd)}),
    .data_o(),
    .syndrome_o(),
    .err_o(err)
  );

  tlul_data_integ_dec u_tlul_data_integ_dec (
    .data_intg_i({tl_i.a_user.data_intg, DataMaxWidth'(tl_i.a_data)}),
    .data_err_o(data_err)
  );

  // error output is transactional, it is up to the instantiating module
  // to determine if a permanent latch is feasible
  // [LOWRISC] err and data_err is unknown when a_valid is low, so we can't cover
  // the condition coverage - (|err | (|data_err)) == 0/1, when a_valid = 0, which is
  // fine as driving unknown is better. `err_o` is used as a condition in other places,
  // which needs to be covered with 0 and 1, so it's OK to disable the entire coverage.
  //VCS coverage off
  // pragma coverage off
  assign err_o = tl_i.a_valid & (|err | (|data_err));
  //VCS coverage on
  // pragma coverage on

  logic unused_tl;
  assign unused_tl = |tl_i;

  

endmodule // tlul_payload_chk
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


/*

 Tile-Link UL response integrity generator

 This generates integrity bits that get stored in the rsp_intg and data_intg fields of tl_o.d_user.

 If EnableRspIntgGen is true then the rsp_intg field is generated from the opcode, d_size and
 d_error fields of the response (extracted with tlul_pkg::extract_d2h_rsp_intg). If it is false then
 the rsp_intg field either comes from the same field in the tl_i input (if UserInIsZero is false) or
 is wired to zero (if UserInIsZero is true).

 If EnableDataIntgGen is true then the data_intg field is generated from the d_data field of the
 response. If it is false then the rsp_intg field either comes from the same field in the tl_i input
 (if UserInIsZero is false) or is wired to zero (if UserInIsZero is true).

*/

module tlul_rsp_intg_gen import tlul_pkg::*; #(
  parameter bit EnableRspIntgGen = 1'b1,
  parameter bit EnableDataIntgGen = 1'b1,
  parameter bit UserInIsZero = 1'b0,
  parameter bit RspIntgInIsZero = UserInIsZero
) (
  // TL-UL interface
  input  tl_d2h_t tl_i,
  output tl_d2h_t tl_o
);

  logic [D2HRspIntgWidth-1:0] rsp_intg;
  if (EnableRspIntgGen) begin : gen_rsp_intg
    tl_d2h_rsp_intg_t rsp;
    logic [D2HRspMaxWidth-1:0] unused_payload;

    assign rsp = extract_d2h_rsp_intg(tl_i);

    prim_secded_inv_64_57_enc u_rsp_gen (
      .data_i(D2HRspMaxWidth'(rsp)),
      .data_o({rsp_intg, unused_payload})
    );
  end else if (RspIntgInIsZero) begin : gen_zero_rsp_intg
    assign rsp_intg = 0;
  end else begin : gen_passthrough_rsp_intg
    assign rsp_intg = tl_i.d_user.rsp_intg;
  end

  logic [DataIntgWidth-1:0] data_intg;
  if (EnableDataIntgGen) begin : gen_data_intg
    logic [DataMaxWidth-1:0] unused_data;
    tlul_data_integ_enc u_tlul_data_integ_enc (
      .data_i(DataMaxWidth'(tl_i.d_data)),
      .data_intg_o({data_intg, unused_data})
    );
  end else if (UserInIsZero) begin : gen_zero_data_intg
    assign data_intg = 0;
  end else begin : gen_passthrough_data_intg
    assign data_intg = tl_i.d_user.data_intg;
  end

  always_comb begin
    tl_o = tl_i;
    tl_o.d_user.rsp_intg = rsp_intg;
    tl_o.d_user.data_intg = data_intg;
  end

  logic unused_tl;
  assign unused_tl = ^tl_i;


  
  

// the code below is not meant to be synthesized,
// but it is intended to be used in simulation and FPV


endmodule // tlul_rsp_intg_gen
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

package prim_alert_pkg;

  typedef struct packed {
    logic alert_p;
    logic alert_n;
  } alert_tx_t;

  typedef struct packed {
    logic ping_p;
    logic ping_n;
    logic ack_p;
    logic ack_n;
  } alert_rx_t;

  parameter alert_tx_t ALERT_TX_DEFAULT = '{alert_p:  1'b0,
                                            alert_n:  1'b1};

  parameter alert_rx_t ALERT_RX_DEFAULT = '{ping_p: 1'b0,
                                            ping_n: 1'b1,
                                            ack_p: 1'b0,
                                            ack_n: 1'b1};

endpackage : prim_alert_pkg
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// The alert sender primitive module differentially encodes and transmits an
// alert signal to the prim_alert_receiver module. An alert will be signalled
// by a full handshake on alert_p/n and ack_p/n. The alert_req_i signal may
// be continuously asserted, in which case the alert signalling handshake
// will be repeatedly initiated.
//
// The alert_req_i signal may also be used as part of req/ack. The parent module
// can keep alert_req_i asserted until it has been ack'd (transferred to the alert
// receiver).  The parent module is not required to use this.
//
// In case the alert sender parameter IsFatal is set to 1, an incoming alert
// alert_req_i is latched in a local register until the next reset, causing the
// alert sender to behave as if alert_req_i were continuously asserted.
// The alert_state_o output reflects the state of this internal latching register.
//
// The alert sender also exposes an alert test input, which can be used to trigger
// single alert handshakes. This input behaves exactly the same way as the
// alert_req_i input with IsFatal set to 0. Test alerts do not cause alert_ack_o
// to be asserted, nor are they latched until reset (regardless of the value of the
// IsFatal parameter).
//
// Further, this module supports in-band ping testing, which means that a level
// change on the ping_p/n diff pair will result in a full-handshake response
// on alert_p/n and ack_p/n.
//
// The protocol works in both asynchronous and synchronous cases. In the
// asynchronous case, the parameter AsyncOn must be set to 1'b1 in order to
// instantiate additional synchronization logic. Further, it must be ensured
// that the timing skew between all diff pairs is smaller than the shortest
// clock period of the involved clocks.
//
// Incorrectly encoded diff inputs can be detected and will be signalled
// to the receiver by placing an inconsistent diff value on the differential
// output (and continuously toggling it).
//
// See also: prim_alert_receiver, prim_diff_decode, alert_handler

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module prim_alert_sender
  import prim_alert_pkg::*;
#(
  // enables additional synchronization logic
  parameter bit AsyncOn = 1'b1,
  // Number of cycles a differential skew is tolerated on the differential ack/ping signal.
  parameter int unsigned SkewCycles = 1,
  // alert sender will latch the incoming alert event permanently and
  // keep on sending alert events until the next reset.
  parameter bit IsFatal = 1'b0
) (
  input             clk_i,
  input             rst_ni,
  // alert test trigger (this will never be latched, even if IsFatal == 1)
  input             alert_test_i,
  // native alert from the peripheral
  input             alert_req_i,
  output logic      alert_ack_o,
  // state of the alert latching register
  output logic      alert_state_o,
  // ping input diff pair and ack diff pair
  input alert_rx_t  alert_rx_i,
  // alert output diff pair
  output alert_tx_t alert_tx_o
);


  /////////////////////////////////
  // decode differential signals //
  /////////////////////////////////
  logic ping_sigint, ping_event, ping_n, ping_p;

  // This prevents further tool optimizations of the differential signal.
  prim_sec_anchor_buf #(
    .Width(2)
  ) u_prim_buf_ping (
    .in_i({alert_rx_i.ping_n,
           alert_rx_i.ping_p}),
    .out_o({ping_n,
            ping_p})
  );

  prim_diff_decode #(
    .AsyncOn(AsyncOn),
    .SkewCycles(SkewCycles)
  ) u_decode_ping (
    .clk_i,
    .rst_ni,
    .diff_pi  ( ping_p      ),
    .diff_ni  ( ping_n      ),
    .level_o  (             ),
    .rise_o   (             ),
    .fall_o   (             ),
    .event_o  ( ping_event  ),
    .sigint_o ( ping_sigint )
  );

  logic ack_sigint, ack_level, ack_n, ack_p;

  // This prevents further tool optimizations of the differential signal.
  prim_sec_anchor_buf #(
    .Width(2)
  ) u_prim_buf_ack (
    .in_i({alert_rx_i.ack_n,
           alert_rx_i.ack_p}),
    .out_o({ack_n,
            ack_p})
  );

  prim_diff_decode #(
    .AsyncOn(AsyncOn),
    .SkewCycles(SkewCycles)
  ) u_decode_ack (
    .clk_i,
    .rst_ni,
    .diff_pi  ( ack_p      ),
    .diff_ni  ( ack_n      ),
    .level_o  ( ack_level  ),
    .rise_o   (            ),
    .fall_o   (            ),
    .event_o  (            ),
    .sigint_o ( ack_sigint )
  );


  ///////////////////////////////////////////////////
  // main protocol FSM that drives the diff output //
  ///////////////////////////////////////////////////
  typedef enum logic [2:0] {
    Idle,
    AlertHsPhase1,
    AlertHsPhase2,
    PingHsPhase1,
    PingHsPhase2,
    Pause0,
    Pause1
    } state_e;
  state_e state_d, state_q;
  logic alert_pq, alert_nq, alert_pd, alert_nd;
  logic sigint_detected;

  assign sigint_detected = ack_sigint | ping_sigint;


  // diff pair output
  assign alert_tx_o.alert_p = alert_pq;
  assign alert_tx_o.alert_n = alert_nq;

  // alert and ping set regs
  logic alert_set_d, alert_set_q, alert_clr;
  logic alert_test_set_d, alert_test_set_q;
  logic ping_set_d, ping_set_q, ping_clr;
  logic alert_req_trigger, alert_test_trigger, ping_trigger;

  // if handshake is ongoing, capture additional alert requests.
  logic alert_req;
  prim_sec_anchor_buf #(
    .Width(1)
  ) u_prim_buf_in_req (
    .in_i(alert_req_i),
    .out_o(alert_req)
  );

  assign alert_req_trigger = alert_req | alert_set_q;
  if (IsFatal) begin : gen_fatal
    assign alert_set_d = alert_req_trigger;
  end else begin : gen_recov
    assign alert_set_d = (alert_clr) ? 1'b0 : alert_req_trigger;
  end

  // the alert test request is always cleared.
  assign alert_test_trigger = alert_test_i | alert_test_set_q;
  assign alert_test_set_d = (alert_clr) ? 1'b0 : alert_test_trigger;

  logic alert_trigger;
  assign alert_trigger = alert_req_trigger | alert_test_trigger;

  assign ping_trigger = ping_set_q | ping_event;
  assign ping_set_d  = (ping_clr) ? 1'b0 : ping_trigger;


  // alert event acknowledge and state (not affected by alert_test_i)
  assign alert_ack_o = alert_clr & alert_set_q;
  assign alert_state_o = alert_set_q;

  // this FSM performs a full four phase handshake upon a ping or alert trigger.
  // note that the latency of the alert_p/n diff pair is at least one cycle
  // until it enters the receiver FSM. the same holds for the ack_* diff pair
  // input. in case a signal integrity issue is detected, the FSM bails out,
  // sets the alert_p/n diff pair to the same value and toggles it in order to
  // signal that condition over to the receiver.
  always_comb begin : p_fsm
    // default
    state_d   = state_q;
    alert_pd  = 1'b0;
    alert_nd  = 1'b1;
    ping_clr  = 1'b0;
    alert_clr = 1'b0;

    unique case (state_q)
      Idle: begin
        // alert always takes precedence
        if (alert_trigger || ping_trigger) begin
          state_d = (alert_trigger) ? AlertHsPhase1 : PingHsPhase1;
          alert_pd = 1'b1;
          alert_nd = 1'b0;
        end
      end
      // waiting for ack from receiver
      AlertHsPhase1: begin
        if (ack_level) begin
          state_d  = AlertHsPhase2;
        end else begin
          alert_pd = 1'b1;
          alert_nd = 1'b0;
        end
      end
      // wait for deassertion of ack
      AlertHsPhase2: begin
        if (!ack_level) begin
          state_d = Pause0;
          alert_clr = 1'b1;
        end
      end
      // waiting for ack from receiver
      PingHsPhase1: begin
        if (ack_level) begin
          state_d  = PingHsPhase2;
        end else begin
          alert_pd = 1'b1;
          alert_nd = 1'b0;
        end
      end
      // wait for deassertion of ack
      PingHsPhase2: begin
        if (!ack_level) begin
          ping_clr = 1'b1;
          state_d = Pause0;
        end
      end
      // pause cycles between back-to-back handshakes
      Pause0: begin
        state_d = Pause1;
      end
      // clear and ack alert request if it was set
      Pause1: begin
        state_d = Idle;
      end
      // catch parasitic states
      default : state_d = Idle;
    endcase

    // we have a signal integrity issue at one of the incoming diff pairs. this condition is
    // signalled by setting the output diffpair to zero. If the sigint has disappeared, we clear
    // the ping request state of this sender and go back to idle.
    if (sigint_detected) begin
      state_d   = Idle;
      alert_pd  = 1'b0;
      alert_nd  = 1'b0;
      ping_clr  = 1'b1;
      alert_clr = 1'b0;
    end
  end

  // This prevents further tool optimizations of the differential signal.
  prim_sec_anchor_flop #(
    .Width     (2),
    .ResetValue(2'b10)
  ) u_prim_flop_alert (
    .clk_i,
    .rst_ni,
    .d_i({alert_nd, alert_pd}),
    .q_o({alert_nq, alert_pq})
  );

  always_ff @(posedge clk_i or negedge rst_ni) begin : p_reg
    if (!rst_ni) begin
      state_q          <= Idle;
      alert_set_q      <= 1'b0;
      alert_test_set_q <= 1'b0;
      ping_set_q       <= 1'b0;
    end else begin
      state_q          <= state_d;
      alert_set_q      <= alert_set_d;
      alert_test_set_q <= alert_test_set_d;
      ping_set_q       <= ping_set_d;
    end
  end


  ////////////////
  // assertions //
  ////////////////

// however, since we use sequence constructs below, we need to wrap the entire block again.
// typically, the ASSERT macros already contain this INC_ASSERT macro.



endmodule : prim_alert_sender
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module tlul_err import tlul_pkg::*; (
  input clk_i,
  input rst_ni,

  input tl_h2d_t tl_i,

  output logic err_o
);

  localparam int IW  = $bits(tl_i.a_source);
  localparam int SZW = $bits(tl_i.a_size);
  localparam int DW  = $bits(tl_i.a_data);
  localparam int MW  = $bits(tl_i.a_mask);
  localparam int SubAW = $clog2(DW/8);

  logic opcode_allowed, a_config_allowed;

  logic op_full, op_partial, op_get;
  assign op_full    = (tl_i.a_opcode == PutFullData);
  assign op_partial = (tl_i.a_opcode == PutPartialData);
  assign op_get     = (tl_i.a_opcode == Get);

  // An instruction type transaction cannot be write
  logic instr_wr_err;
  assign instr_wr_err = prim_mubi_pkg::mubi4_test_true_strict(tl_i.a_user.instr_type) &
                        (op_full | op_partial);

  logic instr_type_err;
  assign instr_type_err = prim_mubi_pkg::mubi4_test_invalid(tl_i.a_user.instr_type);

  // Anything that doesn't fall into the permitted category, it raises an error
  assign err_o = ~(opcode_allowed & a_config_allowed) | instr_wr_err | instr_type_err;

  // opcode check
  assign opcode_allowed = (tl_i.a_opcode == PutFullData)
                        | (tl_i.a_opcode == PutPartialData)
                        | (tl_i.a_opcode == Get);

  // a channel configuration check
  logic addr_sz_chk;    // address and size alignment check
  logic mask_chk;       // inactive lane a_mask check
  logic fulldata_chk;   // PutFullData should have size match to mask

  localparam bit [MW-1:0] MaskOne = 1;
  logic [MW-1:0] mask;

  assign mask = MaskOne << tl_i.a_address[SubAW-1:0];

  always_comb begin
    addr_sz_chk  = 1'b0;
    mask_chk     = 1'b0;
    fulldata_chk = 1'b0; // Only valid when opcode is PutFullData

    if (tl_i.a_valid) begin
      unique case (tl_i.a_size)
        'h0: begin // 1 Byte
          addr_sz_chk  = 1'b1;
          mask_chk     = ~|(tl_i.a_mask & ~mask);
          fulldata_chk = |(tl_i.a_mask & mask);
        end

        'h1: begin // 2 Byte
          addr_sz_chk  = ~tl_i.a_address[0];
          // check inactive lanes if lower 2B, check a_mask[3:2], if uppwer 2B, a_mask[1:0]
          mask_chk     = (tl_i.a_address[1]) ? ~|(tl_i.a_mask & 4'b0011)
                       : ~|(tl_i.a_mask & 4'b1100);
          fulldata_chk = (tl_i.a_address[1]) ? &tl_i.a_mask[3:2] : &tl_i.a_mask[1:0] ;
        end

        'h2: begin // 4 Byte
          addr_sz_chk  = ~|tl_i.a_address[SubAW-1:0];
          mask_chk     = 1'b1;
          fulldata_chk = &tl_i.a_mask[3:0];
        end

        default: begin // else
          addr_sz_chk  = 1'b0;
          mask_chk     = 1'b0;
          fulldata_chk = 1'b0;
        end
      endcase
    end
  end

  assign a_config_allowed = addr_sz_chk
                          & mask_chk
                          & (op_get | op_partial | fulldata_chk) ;

  // Only 32 bit data width for current tlul_err
  

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Primitive block for generating CIP interrupts in peripherals.
//
// This block generates both the level-triggered wired interrupt signal intr_o and also updates
// the value of the INTR_STATE register. Together, the signal and register make up the two
// externally-visible indications of of the interrupt state.
//
// This assumes the existence of three external controller registers, which
// interface with this module via the standard reggen reg2hw/hw2reg signals. The 3 registers are:
// - INTR_ENABLE : enables/masks the output of INTR_STATE as the intr_o signal
// - INTR_STATE  : the current state of the interrupt (may be RO or W1C depending on "IntrT")
// - INTR_TEST   : sw-access-only register which asserts the interrupt for testing purposes

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module prim_intr_hw # (
  // This module can be instantiated once per interrupt field (Width == 1), or
  // "bussified" with all fields of the interrupt vector (Width == $width(vec)).
  parameter int unsigned Width = 1,
  parameter bit          FlopOutput = 1,

  // As the wired interrupt signal intr_o is a level-triggered interrupt, the upstream consumer sw
  // has two options to make forward progress when this signal is asserted:
  // - Mask the interrupt, by setting INTR_ENABLE = 1'b0 or masking/enabling at an upstream
  //   consumer.
  // - Interact with the peripheral in some user-defined way that clears the signal.
  // To make this user-defined interaction ergonomic from a SW-perspective, we have defined
  // two common patterns for typical interrupt-triggering events, *Status* and *Event*.
  // - *Event* is useful for capturing a momentary assertion of the input signal.
  //   - INTR_STATE/intr_o is set to '1 upon the event occurring.
  //   - INTR_STATE/intr_o remain set until software writes-1-to-clear to INTR_STATE.
  // - *Status* captures a persistent conditional assertion that requires intervention to de-assert.
  //   - Until the root cause is alleviated, the interrupt output (while enabled) is continuously
  //     asserted.
  //   - INTR_STATE for *status* interrupts is RO (it simply presents the raw HW input signal).
  //   - If the root_cause is cleared, INTR_STATE/intr_o also clears automatically.
  // More details about the interrupt type distinctions can be found in the comportability docs.
  parameter              IntrT = "Event" // Event or Status
 // Event or Status
) (
  // event
  input  clk_i,
  input  rst_ni,
  input  [Width-1:0]  event_intr_i,

  // register interface
  input  [Width-1:0]  reg2hw_intr_enable_q_i,
  input  [Width-1:0]  reg2hw_intr_test_q_i,
  input               reg2hw_intr_test_qe_i,
  input  [Width-1:0]  reg2hw_intr_state_q_i,
  output              hw2reg_intr_state_de_o,
  output [Width-1:0]  hw2reg_intr_state_d_o,

  // outgoing interrupt
  output logic [Width-1:0]  intr_o
);

  logic [Width-1:0] status; // incl. test

  if (IntrT == "Event") begin : g_intr_event
    logic  [Width-1:0]    new_event;
    assign new_event =
               (({Width{reg2hw_intr_test_qe_i}} & reg2hw_intr_test_q_i) | event_intr_i);
    assign hw2reg_intr_state_de_o = |new_event;
    // for scalar interrupts, this resolves to '1' with new event
    // for vector interrupts, new events are OR'd in to existing interrupt state
    assign hw2reg_intr_state_d_o  =  new_event | reg2hw_intr_state_q_i;

    assign status = reg2hw_intr_state_q_i ;
  end : g_intr_event
  else if (IntrT == "Status") begin : g_intr_status
    logic [Width-1:0] test_q; // Storing test. Cleared by SW

    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) test_q <= '0;
      else if (reg2hw_intr_test_qe_i) test_q <= reg2hw_intr_test_q_i;
    end

    // TODO: In Status type, INTR_STATE is better to be external type and RO.
    assign hw2reg_intr_state_de_o = 1'b 1; // always represent the status
    assign hw2reg_intr_state_d_o  = event_intr_i | test_q;

    assign status = event_intr_i | test_q;

    // To make the timing same to event type, status signal does not use CSR.q,
    // rather the input of the CSR.
    logic unused_reg2hw;
    assign unused_reg2hw = ^reg2hw_intr_state_q_i;
  end : g_intr_status


  if (FlopOutput == 1) begin : gen_flop_intr_output
    // flop the interrupt output
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        intr_o <= '0;
      end else begin
        intr_o <= status & reg2hw_intr_enable_q_i;
      end
    end

  end else begin : gen_intr_passthrough_output
    logic unused_clk;
    logic unused_rst_n;
    assign unused_clk = clk_i;
    assign unused_rst_n = rst_ni;
    assign intr_o = reg2hw_intr_state_q_i & reg2hw_intr_enable_q_i;
  end

  

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


// Tile-Link UL to register interface adapter
//
// This module acts as a device, addressed through the TL-UL bus. It receives Get, PutPartialData
// and PutFullData messages on the A channel. These are read or write requests, which are passed to
// the register interface on the same cycle. The response from the register interface is sent back
// to the host as a message on the D channel on the next cycle.
//
// A module instance performs several checks on A-channel messages and only forwards a request to
// the register interface if they all pass. These checks are:
//
//  - A_OPCODE must be Get, PutPartialData or PutFullData.
//
//  - A_SIZE must be 0, 1 or 2 (giving a 1-, 2- or 4-byte operation, respectively).
//
//  - A_ADDRESS must be naturally aligned for the operation byte width signaled in A_SIZE.
//
//  - A_MASK must only be true for active byte-lanes. The position of the first of these active
//    lanes is calculated from the address, modulo the width of the TL-UL data bus.
//
//  - If the A_USER.INSTR_TYPE value is MuBi4True, A_OPCODE must be Get.
//
//  - Either the A_USER.INSTR_TYPE value must be a value other than MuBi4True or the en_ifetch_i
//    port must be MuBi4True.
//
//  - If the CmdIntgCheck parameter is true then the command integrity check must pass.
//
//
// ** Parameters
//
// CmdIntgCheck: If this parameter is true then there is a "command integrity check". This uses a
//               tlul_cmd_intg_chk instance to compare integrity checksums from requests on the A
//               channel. If the integrity checksums don't match, the adapter doesn't pass the
//               request to the register interface through re_o/we_o and the response on the D
//               channel will then have its D_ERROR flag set.
//
// EnableRspIntgGen: OpenTitan sends response integrity with messages on the TL-UL bus. If this
//                   parameter is true, the module will perform calculations to send a correct
//                   integrity value in the response's A_USER.RSP_INTG field.
//
// EnableDataIntgGen: This parameter is analogous to EnableRspIntgGen but controls whether the
//                    module performs calculations to send a correct integrity value in the
//                    response's A_USER.DATA_INTG field.
//
// RegAw: The number of bits used for addresses in the register interface. Higher bits of the
//        A_ADDRESS field in an A channel message are ignored.
//
// RegDw: The number of bits used for data words in the register interface. This is assumed to match
//        the data width of the TL-UL bus (see the MatchedWidth_A assertion).
//
// AccessLatency: This adapter always returns TileLink responses after one cycle, but this parameter
//                allows it to handle different timings on the register interface. If AccessLatency
//                is zero then the adapter expects a combinatorial response on the register
//                interface and flops the result to break paths and add a cycle delay. If
//                AccessLatency is one then the adapter expects a response on the register interface
//                in the cycle after the re_o/we_o signal goes high, but then forwards it
//                combinatorially to the TileLink interface. Only values 0 and 1 are allowed for
//                this parameter.
//
//
// ** Ports
//
// clk_i/rst_ni: Clock and reset.
// tl_i/tl_o:    Connections to the TL-UL bus.
// en_ifetch_i:  This mubi4_t port controls whether to allow read requests from Get messages whose
//               A_USER.INSTR_TYPE is MuBi4True (considered to be processor "fetch" requests).
// intg_error_o: This port is high when the adapter has detected a command integrity error. That can
//               only happen if the CmdIntgCheck parameter is set.
// re_o/we_o:    The read-enable and write-enable ports in the register interface.
// addr_o:       The address to read or write through the register interface.
// wdata_o:      The value to write through the register interface if we_o is true.
// be_o:         A byte-enable signal, which is true for each byte-lane where the TL-UL operation's
//               mask is true.
// busy_i:       If this input is high then the A channel interface is stalled (by dropping
//               A_READY), which means that the adapter will not accept any new operations.
// rdata_i:      Read data being returned for a read request through the register interface.
// error_i:      An error flag in the register interface. This signals that an error has been seen,
//               which can be seen in the D channel response by D_ERROR being high. The D_DATA
//               response is also set to '1, squashing any data that might have been returned
//               through rdata_i.
//
// ICEBOX(#15822): Note that due to some modules with special needs (like the vendored-in RV_DM),
//                 this module has been extended so that it supports use cases outside of the
//                 generated reg_top module. This makes this adapter and its parameterization
//                 options a bit heavy.
//
//                 We should in the future come back to this and refactor / align the module and its
//                 parameterization needs.

module tlul_adapter_reg
  import tlul_pkg::*;
  import prim_mubi_pkg::mubi4_t;
#(
  parameter  bit CmdIntgCheck      = 0,  // 1: Enable command integrity check
  parameter  bit EnableRspIntgGen  = 0,  // 1: Generate response integrity
  parameter  bit EnableDataIntgGen = 0,  // 1: Generate response data integrity
  parameter  int RegAw             = 8,  // Width of register address
  parameter  int RegDw             = 32, // Shall be matched with TL_DW
  parameter  int AccessLatency     = 0,  // 0: same cycle, 1: next cycle
  localparam int RegBw             = RegDw/8
) (
  input clk_i,
  input rst_ni,

  // TL-UL interface
  input  tl_h2d_t tl_i,
  output tl_d2h_t tl_o,

  // control interface
  input  mubi4_t  en_ifetch_i,
  output logic    intg_error_o,

  // Register interface
  output logic             re_o,
  output logic             we_o,
  output logic [RegAw-1:0] addr_o,
  output logic [RegDw-1:0] wdata_o,
  output logic [RegBw-1:0] be_o,
  input                    busy_i,
  // The following two signals are expected
  // to be returned in AccessLatency cycles.
  input        [RegDw-1:0] rdata_i,
  // This can be a write or read error.
  input                    error_i
);

  

  localparam int IW  = $bits(tl_i.a_source);
  localparam int SZW = $bits(tl_i.a_size);

  logic outstanding_q;    // Indicates current request is pending
  logic a_ack, d_ack;

  logic [RegDw-1:0] rdata, rdata_q;
  logic             error_q, error, err_internal, instr_error, intg_error;

  logic addr_align_err;     // Size and alignment
  logic tl_err;             // Common TL-UL error checker

  logic [IW-1:0]  reqid_q;
  logic [SZW-1:0] reqsz_q;
  tl_d_op_e       rspop_q;

  logic rd_req, wr_req;

  assign a_ack   = tl_i.a_valid & tl_o.a_ready;
  assign d_ack   = tl_o.d_valid & tl_i.d_ready;
  // Request signal
  assign wr_req  = a_ack & ((tl_i.a_opcode == PutFullData) | (tl_i.a_opcode == PutPartialData));
  assign rd_req  = a_ack & (tl_i.a_opcode == Get);

  assign we_o    = wr_req & ~err_internal;
  assign re_o    = rd_req & ~err_internal;
  assign wdata_o = tl_i.a_data;
  assign be_o    = tl_i.a_mask;

  if (RegAw <= 2) begin : gen_only_one_reg
    assign addr_o  = '0;
  end else begin : gen_more_regs
    assign addr_o  = {tl_i.a_address[RegAw-1:2], 2'b00}; // generate always word-align
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni)    outstanding_q <= 1'b0;
    else if (a_ack) outstanding_q <= 1'b1;
    else if (d_ack) outstanding_q <= 1'b0;
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      reqid_q <= '0;
      reqsz_q <= '0;
      rspop_q <= AccessAck;
    end else if (a_ack) begin
      reqid_q <= tl_i.a_source;
      reqsz_q <= tl_i.a_size;
      // Return AccessAckData regardless of error
      rspop_q <= (rd_req) ? AccessAckData : AccessAck ;
    end
  end

  if (AccessLatency == 1) begin : gen_access_latency1
    logic a_ack_q, err_internal_q, wr_req_q;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        a_ack_q <= 1'b0;
        err_internal_q <= 1'b0;
        wr_req_q <= 1'b0;
        rdata_q  <= '0;
        error_q  <= 1'b0;
      end else begin
        a_ack_q <= a_ack;
        err_internal_q <= err_internal;
        wr_req_q <= wr_req;

        rdata_q  <= rdata;
        error_q  <= error;
      end
    end
    always_comb begin
      if (a_ack_q) begin
        rdata = (error_i || err_internal_q || wr_req_q) ? '1 : rdata_i;
        error = error_i || err_internal_q;
      end else begin
        rdata = rdata_q;
        error = error_q;
      end
    end
  end else begin : gen_access_latency0
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        rdata_q <= '0;
        error_q <= 1'b0;
      end else if (a_ack) begin
        rdata_q <= (error_i || err_internal || wr_req) ? '1 : rdata_i;
        error_q <= error_i || err_internal;
      end
    end
    assign rdata = rdata_q;
    assign error = error_q;
  end

  tlul_pkg::tl_d2h_t tl_o_pre;
  assign tl_o_pre = '{
    a_ready:  ~(outstanding_q | busy_i),
    d_valid:  outstanding_q,
    d_opcode: rspop_q,
    d_param:  '0,
    d_size:   reqsz_q,
    d_source: reqid_q,
    d_sink:   '0,
    d_data:   rdata,
    d_user:   '0,
    d_error:  error
  };

  // outgoing integrity generation
  tlul_rsp_intg_gen #(
    .EnableRspIntgGen(EnableRspIntgGen),
    .EnableDataIntgGen(EnableDataIntgGen),
    .UserInIsZero(1'b1)
  ) u_rsp_intg_gen (
    .tl_i(tl_o_pre),
    .tl_o(tl_o)
  );

  if (CmdIntgCheck) begin : gen_cmd_intg_check
    logic intg_error_q;
    tlul_cmd_intg_chk u_cmd_intg_chk (
      .tl_i(tl_i),
      .err_o(intg_error)
    );
    // permanently latch integrity error until reset
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        intg_error_q <= 1'b0;
      end else if (intg_error) begin
        intg_error_q <= 1'b1;
      end
    end
    assign intg_error_o = intg_error_q;
  end else begin : gen_no_cmd_intg_check
    assign intg_error = 1'b0;
    assign intg_error_o = 1'b0;
  end

  ////////////////////
  // Error Handling //
  ////////////////////

  // An instruction type transaction is only valid if en_ifetch is enabled
  assign instr_error = prim_mubi_pkg::mubi4_test_true_strict(tl_i.a_user.instr_type) &
                       prim_mubi_pkg::mubi4_test_false_loose(en_ifetch_i);

  assign err_internal = addr_align_err | tl_err | instr_error | intg_error;

  // addr_align_err
  //    Raised if addr isn't aligned with the size
  //    Read size error is checked in tlul_assert.sv
  //    Here is it added due to the limitation of register interface.
  always_comb begin
    if (wr_req) begin
      // Only word-align is accepted based on comportability spec
      addr_align_err = |tl_i.a_address[1:0];
    end else begin
      // No request
      addr_align_err = 1'b0;
    end
  end

  // tl_err : separate checker
  tlul_err u_err (
    .clk_i,
    .rst_ni,
    .tl_i,
    .err_o (tl_err)
  );

  

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package i2c_reg_pkg;

  // Param list
  parameter int FifoDepth = 64;
  parameter int AcqFifoDepth = 268;
  parameter int NumAlerts = 1;

  // Address widths within the block
  parameter int BlockAw = 7;

  // Number of registers for every interface
  parameter int NumRegs = 32;

  // Alert indices
  typedef enum int {
    AlertFatalFaultIdx = 0
  } i2c_alert_idx_t;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    struct packed {
      logic        q;
    } host_timeout;
    struct packed {
      logic        q;
    } unexp_stop;
    struct packed {
      logic        q;
    } acq_stretch;
    struct packed {
      logic        q;
    } tx_threshold;
    struct packed {
      logic        q;
    } tx_stretch;
    struct packed {
      logic        q;
    } cmd_complete;
    struct packed {
      logic        q;
    } sda_unstable;
    struct packed {
      logic        q;
    } stretch_timeout;
    struct packed {
      logic        q;
    } sda_interference;
    struct packed {
      logic        q;
    } scl_interference;
    struct packed {
      logic        q;
    } controller_halt;
    struct packed {
      logic        q;
    } rx_overflow;
    struct packed {
      logic        q;
    } acq_threshold;
    struct packed {
      logic        q;
    } rx_threshold;
    struct packed {
      logic        q;
    } fmt_threshold;
  } i2c_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } host_timeout;
    struct packed {
      logic        q;
    } unexp_stop;
    struct packed {
      logic        q;
    } acq_stretch;
    struct packed {
      logic        q;
    } tx_threshold;
    struct packed {
      logic        q;
    } tx_stretch;
    struct packed {
      logic        q;
    } cmd_complete;
    struct packed {
      logic        q;
    } sda_unstable;
    struct packed {
      logic        q;
    } stretch_timeout;
    struct packed {
      logic        q;
    } sda_interference;
    struct packed {
      logic        q;
    } scl_interference;
    struct packed {
      logic        q;
    } controller_halt;
    struct packed {
      logic        q;
    } rx_overflow;
    struct packed {
      logic        q;
    } acq_threshold;
    struct packed {
      logic        q;
    } rx_threshold;
    struct packed {
      logic        q;
    } fmt_threshold;
  } i2c_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } host_timeout;
    struct packed {
      logic        q;
      logic        qe;
    } unexp_stop;
    struct packed {
      logic        q;
      logic        qe;
    } acq_stretch;
    struct packed {
      logic        q;
      logic        qe;
    } tx_threshold;
    struct packed {
      logic        q;
      logic        qe;
    } tx_stretch;
    struct packed {
      logic        q;
      logic        qe;
    } cmd_complete;
    struct packed {
      logic        q;
      logic        qe;
    } sda_unstable;
    struct packed {
      logic        q;
      logic        qe;
    } stretch_timeout;
    struct packed {
      logic        q;
      logic        qe;
    } sda_interference;
    struct packed {
      logic        q;
      logic        qe;
    } scl_interference;
    struct packed {
      logic        q;
      logic        qe;
    } controller_halt;
    struct packed {
      logic        q;
      logic        qe;
    } rx_overflow;
    struct packed {
      logic        q;
      logic        qe;
    } acq_threshold;
    struct packed {
      logic        q;
      logic        qe;
    } rx_threshold;
    struct packed {
      logic        q;
      logic        qe;
    } fmt_threshold;
  } i2c_reg2hw_intr_test_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } i2c_reg2hw_alert_test_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } tx_stretch_ctrl_en;
    struct packed {
      logic        q;
    } multi_controller_monitor_en;
    struct packed {
      logic        q;
    } ack_ctrl_en;
    struct packed {
      logic        q;
    } nack_addr_after_timeout;
    struct packed {
      logic        q;
    } llpbk;
    struct packed {
      logic        q;
    } enabletarget;
    struct packed {
      logic        q;
    } enablehost;
  } i2c_reg2hw_ctrl_reg_t;

  typedef struct packed {
    logic [7:0]  q;
    logic        re;
  } i2c_reg2hw_rdata_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } nakok;
    struct packed {
      logic        q;
      logic        qe;
    } rcont;
    struct packed {
      logic        q;
      logic        qe;
    } readb;
    struct packed {
      logic        q;
      logic        qe;
    } stop;
    struct packed {
      logic        q;
      logic        qe;
    } start;
    struct packed {
      logic [7:0]  q;
      logic        qe;
    } fbyte;
  } i2c_reg2hw_fdata_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } txrst;
    struct packed {
      logic        q;
      logic        qe;
    } acqrst;
    struct packed {
      logic        q;
      logic        qe;
    } fmtrst;
    struct packed {
      logic        q;
      logic        qe;
    } rxrst;
  } i2c_reg2hw_fifo_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic [11:0] q;
      logic        qe;
    } fmt_thresh;
    struct packed {
      logic [11:0] q;
      logic        qe;
    } rx_thresh;
  } i2c_reg2hw_host_fifo_config_reg_t;

  typedef struct packed {
    struct packed {
      logic [11:0] q;
      logic        qe;
    } acq_thresh;
    struct packed {
      logic [11:0] q;
      logic        qe;
    } tx_thresh;
  } i2c_reg2hw_target_fifo_config_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } sdaval;
    struct packed {
      logic        q;
    } sclval;
    struct packed {
      logic        q;
    } txovrden;
  } i2c_reg2hw_ovrd_reg_t;

  typedef struct packed {
    struct packed {
      logic [12:0] q;
    } tlow;
    struct packed {
      logic [12:0] q;
    } thigh;
  } i2c_reg2hw_timing0_reg_t;

  typedef struct packed {
    struct packed {
      logic [8:0]  q;
    } t_f;
    struct packed {
      logic [9:0] q;
    } t_r;
  } i2c_reg2hw_timing1_reg_t;

  typedef struct packed {
    struct packed {
      logic [12:0] q;
    } thd_sta;
    struct packed {
      logic [12:0] q;
    } tsu_sta;
  } i2c_reg2hw_timing2_reg_t;

  typedef struct packed {
    struct packed {
      logic [12:0] q;
    } thd_dat;
    struct packed {
      logic [8:0]  q;
    } tsu_dat;
  } i2c_reg2hw_timing3_reg_t;

  typedef struct packed {
    struct packed {
      logic [12:0] q;
    } t_buf;
    struct packed {
      logic [12:0] q;
    } tsu_sto;
  } i2c_reg2hw_timing4_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic        q;
    } mode;
    struct packed {
      logic [29:0] q;
    } val;
  } i2c_reg2hw_timeout_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic [6:0]  q;
    } mask1;
    struct packed {
      logic [6:0]  q;
    } address1;
    struct packed {
      logic [6:0]  q;
    } mask0;
    struct packed {
      logic [6:0]  q;
    } address0;
  } i2c_reg2hw_target_id_reg_t;

  typedef struct packed {
    struct packed {
      logic [2:0]  q;
      logic        re;
    } signal;
    struct packed {
      logic [7:0]  q;
      logic        re;
    } abyte;
  } i2c_reg2hw_acqdata_reg_t;

  typedef struct packed {
    logic [7:0]  q;
    logic        qe;
  } i2c_reg2hw_txdata_reg_t;

  typedef struct packed {
    logic [19:0] q;
  } i2c_reg2hw_host_timeout_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic [30:0] q;
    } val;
  } i2c_reg2hw_target_timeout_ctrl_reg_t;

  typedef struct packed {
    logic [7:0]  q;
  } i2c_reg2hw_target_nack_count_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } nack;
    struct packed {
      logic [8:0]  q;
      logic        qe;
    } nbytes;
  } i2c_reg2hw_target_ack_ctrl_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } en;
    struct packed {
      logic [30:0] q;
    } val;
  } i2c_reg2hw_host_nack_handler_timeout_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } arbitration_lost;
    struct packed {
      logic        q;
    } bus_timeout;
    struct packed {
      logic        q;
    } unhandled_nack_timeout;
    struct packed {
      logic        q;
    } nack;
  } i2c_reg2hw_controller_events_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } arbitration_lost;
    struct packed {
      logic        q;
    } bus_timeout;
    struct packed {
      logic        q;
    } tx_pending;
  } i2c_reg2hw_target_events_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } host_timeout;
    struct packed {
      logic        d;
      logic        de;
    } unexp_stop;
    struct packed {
      logic        d;
      logic        de;
    } acq_stretch;
    struct packed {
      logic        d;
      logic        de;
    } tx_threshold;
    struct packed {
      logic        d;
      logic        de;
    } tx_stretch;
    struct packed {
      logic        d;
      logic        de;
    } cmd_complete;
    struct packed {
      logic        d;
      logic        de;
    } sda_unstable;
    struct packed {
      logic        d;
      logic        de;
    } stretch_timeout;
    struct packed {
      logic        d;
      logic        de;
    } sda_interference;
    struct packed {
      logic        d;
      logic        de;
    } scl_interference;
    struct packed {
      logic        d;
      logic        de;
    } controller_halt;
    struct packed {
      logic        d;
      logic        de;
    } rx_overflow;
    struct packed {
      logic        d;
      logic        de;
    } acq_threshold;
    struct packed {
      logic        d;
      logic        de;
    } rx_threshold;
    struct packed {
      logic        d;
      logic        de;
    } fmt_threshold;
  } i2c_hw2reg_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
    } ack_ctrl_stretch;
    struct packed {
      logic        d;
    } acqempty;
    struct packed {
      logic        d;
    } txempty;
    struct packed {
      logic        d;
    } acqfull;
    struct packed {
      logic        d;
    } txfull;
    struct packed {
      logic        d;
    } rxempty;
    struct packed {
      logic        d;
    } targetidle;
    struct packed {
      logic        d;
    } hostidle;
    struct packed {
      logic        d;
    } fmtempty;
    struct packed {
      logic        d;
    } rxfull;
    struct packed {
      logic        d;
    } fmtfull;
  } i2c_hw2reg_status_reg_t;

  typedef struct packed {
    logic [7:0]  d;
  } i2c_hw2reg_rdata_reg_t;

  typedef struct packed {
    struct packed {
      logic [11:0] d;
    } rxlvl;
    struct packed {
      logic [11:0] d;
    } fmtlvl;
  } i2c_hw2reg_host_fifo_status_reg_t;

  typedef struct packed {
    struct packed {
      logic [11:0] d;
    } acqlvl;
    struct packed {
      logic [11:0] d;
    } txlvl;
  } i2c_hw2reg_target_fifo_status_reg_t;

  typedef struct packed {
    struct packed {
      logic [15:0] d;
    } sda_rx;
    struct packed {
      logic [15:0] d;
    } scl_rx;
  } i2c_hw2reg_val_reg_t;

  typedef struct packed {
    struct packed {
      logic [2:0]  d;
    } signal;
    struct packed {
      logic [7:0]  d;
    } abyte;
  } i2c_hw2reg_acqdata_reg_t;

  typedef struct packed {
    logic [7:0]  d;
    logic        de;
  } i2c_hw2reg_target_nack_count_reg_t;

  typedef struct packed {
    struct packed {
      logic [8:0]  d;
    } nbytes;
  } i2c_hw2reg_target_ack_ctrl_reg_t;

  typedef struct packed {
    logic [7:0]  d;
  } i2c_hw2reg_acq_fifo_next_data_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } arbitration_lost;
    struct packed {
      logic        d;
      logic        de;
    } bus_timeout;
    struct packed {
      logic        d;
      logic        de;
    } unhandled_nack_timeout;
    struct packed {
      logic        d;
      logic        de;
    } nack;
  } i2c_hw2reg_controller_events_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } arbitration_lost;
    struct packed {
      logic        d;
      logic        de;
    } bus_timeout;
    struct packed {
      logic        d;
      logic        de;
    } tx_pending;
  } i2c_hw2reg_target_events_reg_t;

  // Register -> HW type
  typedef struct packed {
    i2c_reg2hw_intr_state_reg_t intr_state; // [471:457]
    i2c_reg2hw_intr_enable_reg_t intr_enable; // [456:442]
    i2c_reg2hw_intr_test_reg_t intr_test; // [441:412]
    i2c_reg2hw_alert_test_reg_t alert_test; // [411:410]
    i2c_reg2hw_ctrl_reg_t ctrl; // [409:403]
    i2c_reg2hw_rdata_reg_t rdata; // [402:394]
    i2c_reg2hw_fdata_reg_t fdata; // [393:375]
    i2c_reg2hw_fifo_ctrl_reg_t fifo_ctrl; // [374:367]
    i2c_reg2hw_host_fifo_config_reg_t host_fifo_config; // [366:341]
    i2c_reg2hw_target_fifo_config_reg_t target_fifo_config; // [340:315]
    i2c_reg2hw_ovrd_reg_t ovrd; // [314:312]
    i2c_reg2hw_timing0_reg_t timing0; // [311:286]
    i2c_reg2hw_timing1_reg_t timing1; // [285:267]
    i2c_reg2hw_timing2_reg_t timing2; // [266:241]
    i2c_reg2hw_timing3_reg_t timing3; // [240:219]
    i2c_reg2hw_timing4_reg_t timing4; // [218:193]
    i2c_reg2hw_timeout_ctrl_reg_t timeout_ctrl; // [192:161]
    i2c_reg2hw_target_id_reg_t target_id; // [160:133]
    i2c_reg2hw_acqdata_reg_t acqdata; // [132:120]
    i2c_reg2hw_txdata_reg_t txdata; // [119:111]
    i2c_reg2hw_host_timeout_ctrl_reg_t host_timeout_ctrl; // [110:91]
    i2c_reg2hw_target_timeout_ctrl_reg_t target_timeout_ctrl; // [90:59]
    i2c_reg2hw_target_nack_count_reg_t target_nack_count; // [58:51]
    i2c_reg2hw_target_ack_ctrl_reg_t target_ack_ctrl; // [50:39]
    i2c_reg2hw_host_nack_handler_timeout_reg_t host_nack_handler_timeout; // [38:7]
    i2c_reg2hw_controller_events_reg_t controller_events; // [6:3]
    i2c_reg2hw_target_events_reg_t target_events; // [2:0]
  } i2c_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    i2c_hw2reg_intr_state_reg_t intr_state; // [179:150]
    i2c_hw2reg_status_reg_t status; // [149:139]
    i2c_hw2reg_rdata_reg_t rdata; // [138:131]
    i2c_hw2reg_host_fifo_status_reg_t host_fifo_status; // [130:107]
    i2c_hw2reg_target_fifo_status_reg_t target_fifo_status; // [106:83]
    i2c_hw2reg_val_reg_t val; // [82:51]
    i2c_hw2reg_acqdata_reg_t acqdata; // [50:40]
    i2c_hw2reg_target_nack_count_reg_t target_nack_count; // [39:31]
    i2c_hw2reg_target_ack_ctrl_reg_t target_ack_ctrl; // [30:22]
    i2c_hw2reg_acq_fifo_next_data_reg_t acq_fifo_next_data; // [21:14]
    i2c_hw2reg_controller_events_reg_t controller_events; // [13:6]
    i2c_hw2reg_target_events_reg_t target_events; // [5:0]
  } i2c_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] I2C_INTR_STATE_OFFSET = 7'h 0;
  parameter logic [BlockAw-1:0] I2C_INTR_ENABLE_OFFSET = 7'h 4;
  parameter logic [BlockAw-1:0] I2C_INTR_TEST_OFFSET = 7'h 8;
  parameter logic [BlockAw-1:0] I2C_ALERT_TEST_OFFSET = 7'h c;
  parameter logic [BlockAw-1:0] I2C_CTRL_OFFSET = 7'h 10;
  parameter logic [BlockAw-1:0] I2C_STATUS_OFFSET = 7'h 14;
  parameter logic [BlockAw-1:0] I2C_RDATA_OFFSET = 7'h 18;
  parameter logic [BlockAw-1:0] I2C_FDATA_OFFSET = 7'h 1c;
  parameter logic [BlockAw-1:0] I2C_FIFO_CTRL_OFFSET = 7'h 20;
  parameter logic [BlockAw-1:0] I2C_HOST_FIFO_CONFIG_OFFSET = 7'h 24;
  parameter logic [BlockAw-1:0] I2C_TARGET_FIFO_CONFIG_OFFSET = 7'h 28;
  parameter logic [BlockAw-1:0] I2C_HOST_FIFO_STATUS_OFFSET = 7'h 2c;
  parameter logic [BlockAw-1:0] I2C_TARGET_FIFO_STATUS_OFFSET = 7'h 30;
  parameter logic [BlockAw-1:0] I2C_OVRD_OFFSET = 7'h 34;
  parameter logic [BlockAw-1:0] I2C_VAL_OFFSET = 7'h 38;
  parameter logic [BlockAw-1:0] I2C_TIMING0_OFFSET = 7'h 3c;
  parameter logic [BlockAw-1:0] I2C_TIMING1_OFFSET = 7'h 40;
  parameter logic [BlockAw-1:0] I2C_TIMING2_OFFSET = 7'h 44;
  parameter logic [BlockAw-1:0] I2C_TIMING3_OFFSET = 7'h 48;
  parameter logic [BlockAw-1:0] I2C_TIMING4_OFFSET = 7'h 4c;
  parameter logic [BlockAw-1:0] I2C_TIMEOUT_CTRL_OFFSET = 7'h 50;
  parameter logic [BlockAw-1:0] I2C_TARGET_ID_OFFSET = 7'h 54;
  parameter logic [BlockAw-1:0] I2C_ACQDATA_OFFSET = 7'h 58;
  parameter logic [BlockAw-1:0] I2C_TXDATA_OFFSET = 7'h 5c;
  parameter logic [BlockAw-1:0] I2C_HOST_TIMEOUT_CTRL_OFFSET = 7'h 60;
  parameter logic [BlockAw-1:0] I2C_TARGET_TIMEOUT_CTRL_OFFSET = 7'h 64;
  parameter logic [BlockAw-1:0] I2C_TARGET_NACK_COUNT_OFFSET = 7'h 68;
  parameter logic [BlockAw-1:0] I2C_TARGET_ACK_CTRL_OFFSET = 7'h 6c;
  parameter logic [BlockAw-1:0] I2C_ACQ_FIFO_NEXT_DATA_OFFSET = 7'h 70;
  parameter logic [BlockAw-1:0] I2C_HOST_NACK_HANDLER_TIMEOUT_OFFSET = 7'h 74;
  parameter logic [BlockAw-1:0] I2C_CONTROLLER_EVENTS_OFFSET = 7'h 78;
  parameter logic [BlockAw-1:0] I2C_TARGET_EVENTS_OFFSET = 7'h 7c;

  // Reset values for hwext registers and their fields
  parameter logic [14:0] I2C_INTR_TEST_RESVAL = 15'h 0;
  parameter logic [0:0] I2C_INTR_TEST_FMT_THRESHOLD_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_RX_THRESHOLD_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_ACQ_THRESHOLD_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_RX_OVERFLOW_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_CONTROLLER_HALT_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_SCL_INTERFERENCE_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_SDA_INTERFERENCE_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_STRETCH_TIMEOUT_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_SDA_UNSTABLE_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_CMD_COMPLETE_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_TX_STRETCH_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_TX_THRESHOLD_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_ACQ_STRETCH_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_UNEXP_STOP_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_INTR_TEST_HOST_TIMEOUT_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_ALERT_TEST_RESVAL = 1'h 0;
  parameter logic [0:0] I2C_ALERT_TEST_FATAL_FAULT_RESVAL = 1'h 0;
  parameter logic [10:0] I2C_STATUS_RESVAL = 11'h 33c;
  parameter logic [0:0] I2C_STATUS_FMTEMPTY_RESVAL = 1'h 1;
  parameter logic [0:0] I2C_STATUS_HOSTIDLE_RESVAL = 1'h 1;
  parameter logic [0:0] I2C_STATUS_TARGETIDLE_RESVAL = 1'h 1;
  parameter logic [0:0] I2C_STATUS_RXEMPTY_RESVAL = 1'h 1;
  parameter logic [0:0] I2C_STATUS_TXEMPTY_RESVAL = 1'h 1;
  parameter logic [0:0] I2C_STATUS_ACQEMPTY_RESVAL = 1'h 1;
  parameter logic [7:0] I2C_RDATA_RESVAL = 8'h 0;
  parameter logic [27:0] I2C_HOST_FIFO_STATUS_RESVAL = 28'h 0;
  parameter logic [27:0] I2C_TARGET_FIFO_STATUS_RESVAL = 28'h 0;
  parameter logic [31:0] I2C_VAL_RESVAL = 32'h 0;
  parameter logic [10:0] I2C_ACQDATA_RESVAL = 11'h 0;
  parameter logic [31:0] I2C_TARGET_ACK_CTRL_RESVAL = 32'h 0;
  parameter logic [7:0] I2C_ACQ_FIFO_NEXT_DATA_RESVAL = 8'h 0;

  // Register index
  typedef enum int {
    I2C_INTR_STATE,
    I2C_INTR_ENABLE,
    I2C_INTR_TEST,
    I2C_ALERT_TEST,
    I2C_CTRL,
    I2C_STATUS,
    I2C_RDATA,
    I2C_FDATA,
    I2C_FIFO_CTRL,
    I2C_HOST_FIFO_CONFIG,
    I2C_TARGET_FIFO_CONFIG,
    I2C_HOST_FIFO_STATUS,
    I2C_TARGET_FIFO_STATUS,
    I2C_OVRD,
    I2C_VAL,
    I2C_TIMING0,
    I2C_TIMING1,
    I2C_TIMING2,
    I2C_TIMING3,
    I2C_TIMING4,
    I2C_TIMEOUT_CTRL,
    I2C_TARGET_ID,
    I2C_ACQDATA,
    I2C_TXDATA,
    I2C_HOST_TIMEOUT_CTRL,
    I2C_TARGET_TIMEOUT_CTRL,
    I2C_TARGET_NACK_COUNT,
    I2C_TARGET_ACK_CTRL,
    I2C_ACQ_FIFO_NEXT_DATA,
    I2C_HOST_NACK_HANDLER_TIMEOUT,
    I2C_CONTROLLER_EVENTS,
    I2C_TARGET_EVENTS
  } i2c_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] I2C_PERMIT [32] = '{
    4'b 0011, // index[ 0] I2C_INTR_STATE
    4'b 0011, // index[ 1] I2C_INTR_ENABLE
    4'b 0011, // index[ 2] I2C_INTR_TEST
    4'b 0001, // index[ 3] I2C_ALERT_TEST
    4'b 0001, // index[ 4] I2C_CTRL
    4'b 0011, // index[ 5] I2C_STATUS
    4'b 0001, // index[ 6] I2C_RDATA
    4'b 0011, // index[ 7] I2C_FDATA
    4'b 0011, // index[ 8] I2C_FIFO_CTRL
    4'b 1111, // index[ 9] I2C_HOST_FIFO_CONFIG
    4'b 1111, // index[10] I2C_TARGET_FIFO_CONFIG
    4'b 1111, // index[11] I2C_HOST_FIFO_STATUS
    4'b 1111, // index[12] I2C_TARGET_FIFO_STATUS
    4'b 0001, // index[13] I2C_OVRD
    4'b 1111, // index[14] I2C_VAL
    4'b 1111, // index[15] I2C_TIMING0
    4'b 1111, // index[16] I2C_TIMING1
    4'b 1111, // index[17] I2C_TIMING2
    4'b 1111, // index[18] I2C_TIMING3
    4'b 1111, // index[19] I2C_TIMING4
    4'b 1111, // index[20] I2C_TIMEOUT_CTRL
    4'b 1111, // index[21] I2C_TARGET_ID
    4'b 0011, // index[22] I2C_ACQDATA
    4'b 0001, // index[23] I2C_TXDATA
    4'b 0111, // index[24] I2C_HOST_TIMEOUT_CTRL
    4'b 1111, // index[25] I2C_TARGET_TIMEOUT_CTRL
    4'b 0001, // index[26] I2C_TARGET_NACK_COUNT
    4'b 1111, // index[27] I2C_TARGET_ACK_CTRL
    4'b 0001, // index[28] I2C_ACQ_FIFO_NEXT_DATA
    4'b 1111, // index[29] I2C_HOST_NACK_HANDLER_TIMEOUT
    4'b 0001, // index[30] I2C_CONTROLLER_EVENTS
    4'b 0001  // index[31] I2C_TARGET_EVENTS
  };

endpackage
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module i2c_reg_top
  # (
    parameter bit          EnableRacl           = 1'b0,
    parameter bit          RaclErrorRsp         = 1'b1,
    parameter top_racl_pkg::racl_policy_sel_t RaclPolicySelVec[i2c_reg_pkg::NumRegs] =
      '{i2c_reg_pkg::NumRegs{0}}
  ) (
  input clk_i,
  input rst_ni,
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output i2c_reg_pkg::i2c_reg2hw_t reg2hw, // Write
  input  i2c_reg_pkg::i2c_hw2reg_t hw2reg, // Read

  // RACL interface
  input  top_racl_pkg::racl_policy_vec_t racl_policies_i,
  output top_racl_pkg::racl_error_log_t  racl_error_o,

  // Integrity check errors
  output logic intg_err_o
);

  import i2c_reg_pkg::* ;

  localparam int AW = 7;
  localparam int DW = 32;
  localparam int DBW = DW/8;                    // Byte Width

  // register signals
  logic           reg_we;
  logic           reg_re;
  logic [AW-1:0]  reg_addr;
  logic [DW-1:0]  reg_wdata;
  logic [DBW-1:0] reg_be;
  logic [DW-1:0]  reg_rdata;
  logic           reg_error;

  logic          addrmiss, wr_err;

  logic [DW-1:0] reg_rdata_next;
  logic reg_busy;

  tlul_pkg::tl_h2d_t tl_reg_h2d;
  tlul_pkg::tl_d2h_t tl_reg_d2h;


  // incoming payload check
  logic intg_err;
  tlul_cmd_intg_chk u_chk (
    .tl_i(tl_i),
    .err_o(intg_err)
  );

  // also check for spurious write enables
  logic reg_we_err;
  logic [31:0] reg_we_check;
  prim_reg_we_check #(
    .OneHotWidth(32)
  ) u_prim_reg_we_check (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .oh_i  (reg_we_check),
    .en_i  (reg_we && !addrmiss),
    .err_o (reg_we_err)
  );

  logic err_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      err_q <= '0;
    end else if (intg_err || reg_we_err) begin
      err_q <= 1'b1;
    end
  end

  // integrity error output is permanent and should be used for alert generation
  // register errors are transactional
  assign intg_err_o = err_q | intg_err | reg_we_err;

  // outgoing integrity generation
  tlul_pkg::tl_d2h_t tl_o_pre;
  tlul_rsp_intg_gen #(
    .EnableRspIntgGen(1),
    .EnableDataIntgGen(1)
  ) u_rsp_intg_gen (
    .tl_i(tl_o_pre),
    .tl_o(tl_o)
  );

  assign tl_reg_h2d = tl_i;
  assign tl_o_pre   = tl_reg_d2h;

  tlul_adapter_reg #(
    .RegAw(AW),
    .RegDw(DW),
    .EnableDataIntgGen(0)
  ) u_reg_if (
    .clk_i  (clk_i),
    .rst_ni (rst_ni),

    .tl_i (tl_reg_h2d),
    .tl_o (tl_reg_d2h),

    .en_ifetch_i(prim_mubi_pkg::MuBi4False),
    .intg_error_o(),

    .we_o    (reg_we),
    .re_o    (reg_re),
    .addr_o  (reg_addr),
    .wdata_o (reg_wdata),
    .be_o    (reg_be),
    .busy_i  (reg_busy),
    .rdata_i (reg_rdata),
    // Translate RACL error to TLUL error if enabled
    .error_i (reg_error | (RaclErrorRsp & racl_error_o.valid))
  );

  // cdc oversampling signals

  assign reg_rdata = reg_rdata_next ;
  assign reg_error = addrmiss | wr_err | intg_err;

  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  logic intr_state_we;
  logic intr_state_fmt_threshold_qs;
  logic intr_state_rx_threshold_qs;
  logic intr_state_acq_threshold_qs;
  logic intr_state_rx_overflow_qs;
  logic intr_state_rx_overflow_wd;
  logic intr_state_controller_halt_qs;
  logic intr_state_scl_interference_qs;
  logic intr_state_scl_interference_wd;
  logic intr_state_sda_interference_qs;
  logic intr_state_sda_interference_wd;
  logic intr_state_stretch_timeout_qs;
  logic intr_state_stretch_timeout_wd;
  logic intr_state_sda_unstable_qs;
  logic intr_state_sda_unstable_wd;
  logic intr_state_cmd_complete_qs;
  logic intr_state_cmd_complete_wd;
  logic intr_state_tx_stretch_qs;
  logic intr_state_tx_threshold_qs;
  logic intr_state_acq_stretch_qs;
  logic intr_state_unexp_stop_qs;
  logic intr_state_unexp_stop_wd;
  logic intr_state_host_timeout_qs;
  logic intr_state_host_timeout_wd;
  logic intr_enable_we;
  logic intr_enable_fmt_threshold_qs;
  logic intr_enable_fmt_threshold_wd;
  logic intr_enable_rx_threshold_qs;
  logic intr_enable_rx_threshold_wd;
  logic intr_enable_acq_threshold_qs;
  logic intr_enable_acq_threshold_wd;
  logic intr_enable_rx_overflow_qs;
  logic intr_enable_rx_overflow_wd;
  logic intr_enable_controller_halt_qs;
  logic intr_enable_controller_halt_wd;
  logic intr_enable_scl_interference_qs;
  logic intr_enable_scl_interference_wd;
  logic intr_enable_sda_interference_qs;
  logic intr_enable_sda_interference_wd;
  logic intr_enable_stretch_timeout_qs;
  logic intr_enable_stretch_timeout_wd;
  logic intr_enable_sda_unstable_qs;
  logic intr_enable_sda_unstable_wd;
  logic intr_enable_cmd_complete_qs;
  logic intr_enable_cmd_complete_wd;
  logic intr_enable_tx_stretch_qs;
  logic intr_enable_tx_stretch_wd;
  logic intr_enable_tx_threshold_qs;
  logic intr_enable_tx_threshold_wd;
  logic intr_enable_acq_stretch_qs;
  logic intr_enable_acq_stretch_wd;
  logic intr_enable_unexp_stop_qs;
  logic intr_enable_unexp_stop_wd;
  logic intr_enable_host_timeout_qs;
  logic intr_enable_host_timeout_wd;
  logic intr_test_we;
  logic intr_test_fmt_threshold_wd;
  logic intr_test_rx_threshold_wd;
  logic intr_test_acq_threshold_wd;
  logic intr_test_rx_overflow_wd;
  logic intr_test_controller_halt_wd;
  logic intr_test_scl_interference_wd;
  logic intr_test_sda_interference_wd;
  logic intr_test_stretch_timeout_wd;
  logic intr_test_sda_unstable_wd;
  logic intr_test_cmd_complete_wd;
  logic intr_test_tx_stretch_wd;
  logic intr_test_tx_threshold_wd;
  logic intr_test_acq_stretch_wd;
  logic intr_test_unexp_stop_wd;
  logic intr_test_host_timeout_wd;
  logic alert_test_we;
  logic alert_test_wd;
  logic ctrl_we;
  logic ctrl_enablehost_qs;
  logic ctrl_enablehost_wd;
  logic ctrl_enabletarget_qs;
  logic ctrl_enabletarget_wd;
  logic ctrl_llpbk_qs;
  logic ctrl_llpbk_wd;
  logic ctrl_nack_addr_after_timeout_qs;
  logic ctrl_nack_addr_after_timeout_wd;
  logic ctrl_ack_ctrl_en_qs;
  logic ctrl_ack_ctrl_en_wd;
  logic ctrl_multi_controller_monitor_en_qs;
  logic ctrl_multi_controller_monitor_en_wd;
  logic ctrl_tx_stretch_ctrl_en_qs;
  logic ctrl_tx_stretch_ctrl_en_wd;
  logic status_re;
  logic status_fmtfull_qs;
  logic status_rxfull_qs;
  logic status_fmtempty_qs;
  logic status_hostidle_qs;
  logic status_targetidle_qs;
  logic status_rxempty_qs;
  logic status_txfull_qs;
  logic status_acqfull_qs;
  logic status_txempty_qs;
  logic status_acqempty_qs;
  logic status_ack_ctrl_stretch_qs;
  logic rdata_re;
  logic [7:0] rdata_qs;
  logic fdata_we;
  logic [7:0] fdata_fbyte_wd;
  logic fdata_start_wd;
  logic fdata_stop_wd;
  logic fdata_readb_wd;
  logic fdata_rcont_wd;
  logic fdata_nakok_wd;
  logic fifo_ctrl_we;
  logic fifo_ctrl_rxrst_wd;
  logic fifo_ctrl_fmtrst_wd;
  logic fifo_ctrl_acqrst_wd;
  logic fifo_ctrl_txrst_wd;
  logic host_fifo_config_we;
  logic [11:0] host_fifo_config_rx_thresh_qs;
  logic [11:0] host_fifo_config_rx_thresh_wd;
  logic [11:0] host_fifo_config_fmt_thresh_qs;
  logic [11:0] host_fifo_config_fmt_thresh_wd;
  logic target_fifo_config_we;
  logic [11:0] target_fifo_config_tx_thresh_qs;
  logic [11:0] target_fifo_config_tx_thresh_wd;
  logic [11:0] target_fifo_config_acq_thresh_qs;
  logic [11:0] target_fifo_config_acq_thresh_wd;
  logic host_fifo_status_re;
  logic [11:0] host_fifo_status_fmtlvl_qs;
  logic [11:0] host_fifo_status_rxlvl_qs;
  logic target_fifo_status_re;
  logic [11:0] target_fifo_status_txlvl_qs;
  logic [11:0] target_fifo_status_acqlvl_qs;
  logic ovrd_we;
  logic ovrd_txovrden_qs;
  logic ovrd_txovrden_wd;
  logic ovrd_sclval_qs;
  logic ovrd_sclval_wd;
  logic ovrd_sdaval_qs;
  logic ovrd_sdaval_wd;
  logic val_re;
  logic [15:0] val_scl_rx_qs;
  logic [15:0] val_sda_rx_qs;
  logic timing0_we;
  logic [12:0] timing0_thigh_qs;
  logic [12:0] timing0_thigh_wd;
  logic [12:0] timing0_tlow_qs;
  logic [12:0] timing0_tlow_wd;
  logic timing1_we;
  logic [9:0] timing1_t_r_qs;
  logic [9:0] timing1_t_r_wd;
  logic [8:0] timing1_t_f_qs;
  logic [8:0] timing1_t_f_wd;
  logic timing2_we;
  logic [12:0] timing2_tsu_sta_qs;
  logic [12:0] timing2_tsu_sta_wd;
  logic [12:0] timing2_thd_sta_qs;
  logic [12:0] timing2_thd_sta_wd;
  logic timing3_we;
  logic [8:0] timing3_tsu_dat_qs;
  logic [8:0] timing3_tsu_dat_wd;
  logic [12:0] timing3_thd_dat_qs;
  logic [12:0] timing3_thd_dat_wd;
  logic timing4_we;
  logic [12:0] timing4_tsu_sto_qs;
  logic [12:0] timing4_tsu_sto_wd;
  logic [12:0] timing4_t_buf_qs;
  logic [12:0] timing4_t_buf_wd;
  logic timeout_ctrl_we;
  logic [29:0] timeout_ctrl_val_qs;
  logic [29:0] timeout_ctrl_val_wd;
  logic timeout_ctrl_mode_qs;
  logic timeout_ctrl_mode_wd;
  logic timeout_ctrl_en_qs;
  logic timeout_ctrl_en_wd;
  logic target_id_we;
  logic [6:0] target_id_address0_qs;
  logic [6:0] target_id_address0_wd;
  logic [6:0] target_id_mask0_qs;
  logic [6:0] target_id_mask0_wd;
  logic [6:0] target_id_address1_qs;
  logic [6:0] target_id_address1_wd;
  logic [6:0] target_id_mask1_qs;
  logic [6:0] target_id_mask1_wd;
  logic acqdata_re;
  logic [7:0] acqdata_abyte_qs;
  logic [2:0] acqdata_signal_qs;
  logic txdata_we;
  logic [7:0] txdata_wd;
  logic host_timeout_ctrl_we;
  logic [19:0] host_timeout_ctrl_qs;
  logic [19:0] host_timeout_ctrl_wd;
  logic target_timeout_ctrl_we;
  logic [30:0] target_timeout_ctrl_val_qs;
  logic [30:0] target_timeout_ctrl_val_wd;
  logic target_timeout_ctrl_en_qs;
  logic target_timeout_ctrl_en_wd;
  logic target_nack_count_re;
  logic [7:0] target_nack_count_qs;
  logic [7:0] target_nack_count_wd;
  logic target_ack_ctrl_re;
  logic target_ack_ctrl_we;
  logic [8:0] target_ack_ctrl_nbytes_qs;
  logic [8:0] target_ack_ctrl_nbytes_wd;
  logic target_ack_ctrl_nack_wd;
  logic acq_fifo_next_data_re;
  logic [7:0] acq_fifo_next_data_qs;
  logic host_nack_handler_timeout_we;
  logic [30:0] host_nack_handler_timeout_val_qs;
  logic [30:0] host_nack_handler_timeout_val_wd;
  logic host_nack_handler_timeout_en_qs;
  logic host_nack_handler_timeout_en_wd;
  logic controller_events_we;
  logic controller_events_nack_qs;
  logic controller_events_nack_wd;
  logic controller_events_unhandled_nack_timeout_qs;
  logic controller_events_unhandled_nack_timeout_wd;
  logic controller_events_bus_timeout_qs;
  logic controller_events_bus_timeout_wd;
  logic controller_events_arbitration_lost_qs;
  logic controller_events_arbitration_lost_wd;
  logic target_events_we;
  logic target_events_tx_pending_qs;
  logic target_events_tx_pending_wd;
  logic target_events_bus_timeout_qs;
  logic target_events_bus_timeout_wd;
  logic target_events_arbitration_lost_qs;
  logic target_events_arbitration_lost_wd;

  // Register instances
  // R[intr_state]: V(False)
  //   F[fmt_threshold]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_fmt_threshold (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.intr_state.fmt_threshold.de),
    .d      (hw2reg.intr_state.fmt_threshold.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.fmt_threshold.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_fmt_threshold_qs)
  );

  //   F[rx_threshold]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_rx_threshold (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.intr_state.rx_threshold.de),
    .d      (hw2reg.intr_state.rx_threshold.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.rx_threshold.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_rx_threshold_qs)
  );

  //   F[acq_threshold]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_acq_threshold (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.intr_state.acq_threshold.de),
    .d      (hw2reg.intr_state.acq_threshold.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.acq_threshold.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_acq_threshold_qs)
  );

  //   F[rx_overflow]: 3:3
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_rx_overflow (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_rx_overflow_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.rx_overflow.de),
    .d      (hw2reg.intr_state.rx_overflow.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.rx_overflow.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_rx_overflow_qs)
  );

  //   F[controller_halt]: 4:4
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_controller_halt (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.intr_state.controller_halt.de),
    .d      (hw2reg.intr_state.controller_halt.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.controller_halt.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_controller_halt_qs)
  );

  //   F[scl_interference]: 5:5
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_scl_interference (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_scl_interference_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.scl_interference.de),
    .d      (hw2reg.intr_state.scl_interference.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.scl_interference.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_scl_interference_qs)
  );

  //   F[sda_interference]: 6:6
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_sda_interference (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_sda_interference_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.sda_interference.de),
    .d      (hw2reg.intr_state.sda_interference.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.sda_interference.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_sda_interference_qs)
  );

  //   F[stretch_timeout]: 7:7
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_stretch_timeout (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_stretch_timeout_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.stretch_timeout.de),
    .d      (hw2reg.intr_state.stretch_timeout.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.stretch_timeout.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_stretch_timeout_qs)
  );

  //   F[sda_unstable]: 8:8
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_sda_unstable (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_sda_unstable_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.sda_unstable.de),
    .d      (hw2reg.intr_state.sda_unstable.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.sda_unstable.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_sda_unstable_qs)
  );

  //   F[cmd_complete]: 9:9
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_cmd_complete (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_cmd_complete_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.cmd_complete.de),
    .d      (hw2reg.intr_state.cmd_complete.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.cmd_complete.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_cmd_complete_qs)
  );

  //   F[tx_stretch]: 10:10
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_tx_stretch (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.intr_state.tx_stretch.de),
    .d      (hw2reg.intr_state.tx_stretch.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.tx_stretch.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_tx_stretch_qs)
  );

  //   F[tx_threshold]: 11:11
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_tx_threshold (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.intr_state.tx_threshold.de),
    .d      (hw2reg.intr_state.tx_threshold.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.tx_threshold.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_tx_threshold_qs)
  );

  //   F[acq_stretch]: 12:12
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_acq_stretch (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.intr_state.acq_stretch.de),
    .d      (hw2reg.intr_state.acq_stretch.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.acq_stretch.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_acq_stretch_qs)
  );

  //   F[unexp_stop]: 13:13
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_unexp_stop (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_unexp_stop_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.unexp_stop.de),
    .d      (hw2reg.intr_state.unexp_stop.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.unexp_stop.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_unexp_stop_qs)
  );

  //   F[host_timeout]: 14:14
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_host_timeout (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_host_timeout_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.host_timeout.de),
    .d      (hw2reg.intr_state.host_timeout.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.host_timeout.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_host_timeout_qs)
  );


  // R[intr_enable]: V(False)
  //   F[fmt_threshold]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_fmt_threshold (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_fmt_threshold_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.fmt_threshold.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_fmt_threshold_qs)
  );

  //   F[rx_threshold]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_rx_threshold (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_rx_threshold_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.rx_threshold.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_rx_threshold_qs)
  );

  //   F[acq_threshold]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_acq_threshold (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_acq_threshold_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.acq_threshold.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_acq_threshold_qs)
  );

  //   F[rx_overflow]: 3:3
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_rx_overflow (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_rx_overflow_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.rx_overflow.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_rx_overflow_qs)
  );

  //   F[controller_halt]: 4:4
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_controller_halt (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_controller_halt_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.controller_halt.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_controller_halt_qs)
  );

  //   F[scl_interference]: 5:5
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_scl_interference (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_scl_interference_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.scl_interference.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_scl_interference_qs)
  );

  //   F[sda_interference]: 6:6
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_sda_interference (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_sda_interference_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.sda_interference.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_sda_interference_qs)
  );

  //   F[stretch_timeout]: 7:7
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_stretch_timeout (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_stretch_timeout_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.stretch_timeout.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_stretch_timeout_qs)
  );

  //   F[sda_unstable]: 8:8
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_sda_unstable (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_sda_unstable_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.sda_unstable.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_sda_unstable_qs)
  );

  //   F[cmd_complete]: 9:9
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_cmd_complete (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_cmd_complete_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.cmd_complete.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_cmd_complete_qs)
  );

  //   F[tx_stretch]: 10:10
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_tx_stretch (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_tx_stretch_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.tx_stretch.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_tx_stretch_qs)
  );

  //   F[tx_threshold]: 11:11
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_tx_threshold (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_tx_threshold_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.tx_threshold.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_tx_threshold_qs)
  );

  //   F[acq_stretch]: 12:12
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_acq_stretch (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_acq_stretch_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.acq_stretch.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_acq_stretch_qs)
  );

  //   F[unexp_stop]: 13:13
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_unexp_stop (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_unexp_stop_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.unexp_stop.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_unexp_stop_qs)
  );

  //   F[host_timeout]: 14:14
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_host_timeout (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_host_timeout_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.host_timeout.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_host_timeout_qs)
  );


  // R[intr_test]: V(True)
  logic intr_test_qe;
  logic [14:0] intr_test_flds_we;
  assign intr_test_qe = &intr_test_flds_we;
  //   F[fmt_threshold]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_fmt_threshold (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_fmt_threshold_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[0]),
    .q      (reg2hw.intr_test.fmt_threshold.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.fmt_threshold.qe = intr_test_qe;

  //   F[rx_threshold]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_rx_threshold (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_rx_threshold_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[1]),
    .q      (reg2hw.intr_test.rx_threshold.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.rx_threshold.qe = intr_test_qe;

  //   F[acq_threshold]: 2:2
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_acq_threshold (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_acq_threshold_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[2]),
    .q      (reg2hw.intr_test.acq_threshold.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.acq_threshold.qe = intr_test_qe;

  //   F[rx_overflow]: 3:3
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_rx_overflow (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_rx_overflow_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[3]),
    .q      (reg2hw.intr_test.rx_overflow.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.rx_overflow.qe = intr_test_qe;

  //   F[controller_halt]: 4:4
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_controller_halt (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_controller_halt_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[4]),
    .q      (reg2hw.intr_test.controller_halt.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.controller_halt.qe = intr_test_qe;

  //   F[scl_interference]: 5:5
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_scl_interference (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_scl_interference_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[5]),
    .q      (reg2hw.intr_test.scl_interference.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.scl_interference.qe = intr_test_qe;

  //   F[sda_interference]: 6:6
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_sda_interference (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_sda_interference_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[6]),
    .q      (reg2hw.intr_test.sda_interference.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.sda_interference.qe = intr_test_qe;

  //   F[stretch_timeout]: 7:7
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_stretch_timeout (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_stretch_timeout_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[7]),
    .q      (reg2hw.intr_test.stretch_timeout.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.stretch_timeout.qe = intr_test_qe;

  //   F[sda_unstable]: 8:8
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_sda_unstable (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_sda_unstable_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[8]),
    .q      (reg2hw.intr_test.sda_unstable.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.sda_unstable.qe = intr_test_qe;

  //   F[cmd_complete]: 9:9
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_cmd_complete (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_cmd_complete_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[9]),
    .q      (reg2hw.intr_test.cmd_complete.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.cmd_complete.qe = intr_test_qe;

  //   F[tx_stretch]: 10:10
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_tx_stretch (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_tx_stretch_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[10]),
    .q      (reg2hw.intr_test.tx_stretch.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.tx_stretch.qe = intr_test_qe;

  //   F[tx_threshold]: 11:11
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_tx_threshold (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_tx_threshold_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[11]),
    .q      (reg2hw.intr_test.tx_threshold.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.tx_threshold.qe = intr_test_qe;

  //   F[acq_stretch]: 12:12
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_acq_stretch (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_acq_stretch_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[12]),
    .q      (reg2hw.intr_test.acq_stretch.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.acq_stretch.qe = intr_test_qe;

  //   F[unexp_stop]: 13:13
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_unexp_stop (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_unexp_stop_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[13]),
    .q      (reg2hw.intr_test.unexp_stop.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.unexp_stop.qe = intr_test_qe;

  //   F[host_timeout]: 14:14
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_host_timeout (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_host_timeout_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[14]),
    .q      (reg2hw.intr_test.host_timeout.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.host_timeout.qe = intr_test_qe;


  // R[alert_test]: V(True)
  logic alert_test_qe;
  logic [0:0] alert_test_flds_we;
  assign alert_test_qe = &alert_test_flds_we;
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_wd),
    .d      ('0),
    .qre    (),
    .qe     (alert_test_flds_we[0]),
    .q      (reg2hw.alert_test.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.alert_test.qe = alert_test_qe;


  // R[ctrl]: V(False)
  //   F[enablehost]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_ctrl_enablehost (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_enablehost_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.enablehost.q),
    .ds     (),

    // to register interface (read)
    .qs     (ctrl_enablehost_qs)
  );

  //   F[enabletarget]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_ctrl_enabletarget (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_enabletarget_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.enabletarget.q),
    .ds     (),

    // to register interface (read)
    .qs     (ctrl_enabletarget_qs)
  );

  //   F[llpbk]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_ctrl_llpbk (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_llpbk_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.llpbk.q),
    .ds     (),

    // to register interface (read)
    .qs     (ctrl_llpbk_qs)
  );

  //   F[nack_addr_after_timeout]: 3:3
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_ctrl_nack_addr_after_timeout (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_nack_addr_after_timeout_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.nack_addr_after_timeout.q),
    .ds     (),

    // to register interface (read)
    .qs     (ctrl_nack_addr_after_timeout_qs)
  );

  //   F[ack_ctrl_en]: 4:4
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_ctrl_ack_ctrl_en (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_ack_ctrl_en_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.ack_ctrl_en.q),
    .ds     (),

    // to register interface (read)
    .qs     (ctrl_ack_ctrl_en_qs)
  );

  //   F[multi_controller_monitor_en]: 5:5
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_ctrl_multi_controller_monitor_en (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_multi_controller_monitor_en_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.multi_controller_monitor_en.q),
    .ds     (),

    // to register interface (read)
    .qs     (ctrl_multi_controller_monitor_en_qs)
  );

  //   F[tx_stretch_ctrl_en]: 6:6
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_ctrl_tx_stretch_ctrl_en (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_we),
    .wd     (ctrl_tx_stretch_ctrl_en_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ctrl.tx_stretch_ctrl_en.q),
    .ds     (),

    // to register interface (read)
    .qs     (ctrl_tx_stretch_ctrl_en_qs)
  );


  // R[status]: V(True)
  //   F[fmtfull]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_fmtfull (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.fmtfull.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_fmtfull_qs)
  );

  //   F[rxfull]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_rxfull (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.rxfull.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_rxfull_qs)
  );

  //   F[fmtempty]: 2:2
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_fmtempty (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.fmtempty.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_fmtempty_qs)
  );

  //   F[hostidle]: 3:3
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_hostidle (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.hostidle.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_hostidle_qs)
  );

  //   F[targetidle]: 4:4
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_targetidle (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.targetidle.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_targetidle_qs)
  );

  //   F[rxempty]: 5:5
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_rxempty (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.rxempty.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_rxempty_qs)
  );

  //   F[txfull]: 6:6
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_txfull (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.txfull.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_txfull_qs)
  );

  //   F[acqfull]: 7:7
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_acqfull (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.acqfull.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_acqfull_qs)
  );

  //   F[txempty]: 8:8
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_txempty (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.txempty.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_txempty_qs)
  );

  //   F[acqempty]: 9:9
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_acqempty (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.acqempty.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_acqempty_qs)
  );

  //   F[ack_ctrl_stretch]: 10:10
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_ack_ctrl_stretch (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.ack_ctrl_stretch.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_ack_ctrl_stretch_qs)
  );


  // R[rdata]: V(True)
  prim_subreg_ext #(
    .DW    (8)
  ) u_rdata (
    .re     (rdata_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.rdata.d),
    .qre    (reg2hw.rdata.re),
    .qe     (),
    .q      (reg2hw.rdata.q),
    .ds     (),
    .qs     (rdata_qs)
  );


  // R[fdata]: V(False)
  logic fdata_qe;
  logic [5:0] fdata_flds_we;
  prim_flop #(
    .Width(1),
    .ResetValue(0)
  ) u_fdata0_qe (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .d_i(&fdata_flds_we),
    .q_o(fdata_qe)
  );
  //   F[fbyte]: 7:0
  prim_subreg #(
    .DW      (8),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (8'h0),
    .Mubi    (1'b0)
  ) u_fdata_fbyte (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (fdata_we),
    .wd     (fdata_fbyte_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (fdata_flds_we[0]),
    .q      (reg2hw.fdata.fbyte.q),
    .ds     (),

    // to register interface (read)
    .qs     ()
  );
  assign reg2hw.fdata.fbyte.qe = fdata_qe;

  //   F[start]: 8:8
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_fdata_start (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (fdata_we),
    .wd     (fdata_start_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (fdata_flds_we[1]),
    .q      (reg2hw.fdata.start.q),
    .ds     (),

    // to register interface (read)
    .qs     ()
  );
  assign reg2hw.fdata.start.qe = fdata_qe;

  //   F[stop]: 9:9
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_fdata_stop (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (fdata_we),
    .wd     (fdata_stop_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (fdata_flds_we[2]),
    .q      (reg2hw.fdata.stop.q),
    .ds     (),

    // to register interface (read)
    .qs     ()
  );
  assign reg2hw.fdata.stop.qe = fdata_qe;

  //   F[readb]: 10:10
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_fdata_readb (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (fdata_we),
    .wd     (fdata_readb_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (fdata_flds_we[3]),
    .q      (reg2hw.fdata.readb.q),
    .ds     (),

    // to register interface (read)
    .qs     ()
  );
  assign reg2hw.fdata.readb.qe = fdata_qe;

  //   F[rcont]: 11:11
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_fdata_rcont (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (fdata_we),
    .wd     (fdata_rcont_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (fdata_flds_we[4]),
    .q      (reg2hw.fdata.rcont.q),
    .ds     (),

    // to register interface (read)
    .qs     ()
  );
  assign reg2hw.fdata.rcont.qe = fdata_qe;

  //   F[nakok]: 12:12
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_fdata_nakok (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (fdata_we),
    .wd     (fdata_nakok_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (fdata_flds_we[5]),
    .q      (reg2hw.fdata.nakok.q),
    .ds     (),

    // to register interface (read)
    .qs     ()
  );
  assign reg2hw.fdata.nakok.qe = fdata_qe;


  // R[fifo_ctrl]: V(False)
  logic fifo_ctrl_qe;
  logic [3:0] fifo_ctrl_flds_we;
  prim_flop #(
    .Width(1),
    .ResetValue(0)
  ) u_fifo_ctrl0_qe (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .d_i(&fifo_ctrl_flds_we),
    .q_o(fifo_ctrl_qe)
  );
  //   F[rxrst]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_fifo_ctrl_rxrst (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (fifo_ctrl_we),
    .wd     (fifo_ctrl_rxrst_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (fifo_ctrl_flds_we[0]),
    .q      (reg2hw.fifo_ctrl.rxrst.q),
    .ds     (),

    // to register interface (read)
    .qs     ()
  );
  assign reg2hw.fifo_ctrl.rxrst.qe = fifo_ctrl_qe;

  //   F[fmtrst]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_fifo_ctrl_fmtrst (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (fifo_ctrl_we),
    .wd     (fifo_ctrl_fmtrst_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (fifo_ctrl_flds_we[1]),
    .q      (reg2hw.fifo_ctrl.fmtrst.q),
    .ds     (),

    // to register interface (read)
    .qs     ()
  );
  assign reg2hw.fifo_ctrl.fmtrst.qe = fifo_ctrl_qe;

  //   F[acqrst]: 7:7
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_fifo_ctrl_acqrst (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (fifo_ctrl_we),
    .wd     (fifo_ctrl_acqrst_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (fifo_ctrl_flds_we[2]),
    .q      (reg2hw.fifo_ctrl.acqrst.q),
    .ds     (),

    // to register interface (read)
    .qs     ()
  );
  assign reg2hw.fifo_ctrl.acqrst.qe = fifo_ctrl_qe;

  //   F[txrst]: 8:8
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_fifo_ctrl_txrst (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (fifo_ctrl_we),
    .wd     (fifo_ctrl_txrst_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (fifo_ctrl_flds_we[3]),
    .q      (reg2hw.fifo_ctrl.txrst.q),
    .ds     (),

    // to register interface (read)
    .qs     ()
  );
  assign reg2hw.fifo_ctrl.txrst.qe = fifo_ctrl_qe;


  // R[host_fifo_config]: V(False)
  logic host_fifo_config_qe;
  logic [1:0] host_fifo_config_flds_we;
  prim_flop #(
    .Width(1),
    .ResetValue(0)
  ) u_host_fifo_config0_qe (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .d_i(&host_fifo_config_flds_we),
    .q_o(host_fifo_config_qe)
  );
  //   F[rx_thresh]: 11:0
  prim_subreg #(
    .DW      (12),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (12'h0),
    .Mubi    (1'b0)
  ) u_host_fifo_config_rx_thresh (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (host_fifo_config_we),
    .wd     (host_fifo_config_rx_thresh_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (host_fifo_config_flds_we[0]),
    .q      (reg2hw.host_fifo_config.rx_thresh.q),
    .ds     (),

    // to register interface (read)
    .qs     (host_fifo_config_rx_thresh_qs)
  );
  assign reg2hw.host_fifo_config.rx_thresh.qe = host_fifo_config_qe;

  //   F[fmt_thresh]: 27:16
  prim_subreg #(
    .DW      (12),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (12'h0),
    .Mubi    (1'b0)
  ) u_host_fifo_config_fmt_thresh (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (host_fifo_config_we),
    .wd     (host_fifo_config_fmt_thresh_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (host_fifo_config_flds_we[1]),
    .q      (reg2hw.host_fifo_config.fmt_thresh.q),
    .ds     (),

    // to register interface (read)
    .qs     (host_fifo_config_fmt_thresh_qs)
  );
  assign reg2hw.host_fifo_config.fmt_thresh.qe = host_fifo_config_qe;


  // R[target_fifo_config]: V(False)
  logic target_fifo_config_qe;
  logic [1:0] target_fifo_config_flds_we;
  prim_flop #(
    .Width(1),
    .ResetValue(0)
  ) u_target_fifo_config0_qe (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .d_i(&target_fifo_config_flds_we),
    .q_o(target_fifo_config_qe)
  );
  //   F[tx_thresh]: 11:0
  prim_subreg #(
    .DW      (12),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (12'h0),
    .Mubi    (1'b0)
  ) u_target_fifo_config_tx_thresh (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (target_fifo_config_we),
    .wd     (target_fifo_config_tx_thresh_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (target_fifo_config_flds_we[0]),
    .q      (reg2hw.target_fifo_config.tx_thresh.q),
    .ds     (),

    // to register interface (read)
    .qs     (target_fifo_config_tx_thresh_qs)
  );
  assign reg2hw.target_fifo_config.tx_thresh.qe = target_fifo_config_qe;

  //   F[acq_thresh]: 27:16
  prim_subreg #(
    .DW      (12),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (12'h0),
    .Mubi    (1'b0)
  ) u_target_fifo_config_acq_thresh (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (target_fifo_config_we),
    .wd     (target_fifo_config_acq_thresh_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (target_fifo_config_flds_we[1]),
    .q      (reg2hw.target_fifo_config.acq_thresh.q),
    .ds     (),

    // to register interface (read)
    .qs     (target_fifo_config_acq_thresh_qs)
  );
  assign reg2hw.target_fifo_config.acq_thresh.qe = target_fifo_config_qe;


  // R[host_fifo_status]: V(True)
  //   F[fmtlvl]: 11:0
  prim_subreg_ext #(
    .DW    (12)
  ) u_host_fifo_status_fmtlvl (
    .re     (host_fifo_status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.host_fifo_status.fmtlvl.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (host_fifo_status_fmtlvl_qs)
  );

  //   F[rxlvl]: 27:16
  prim_subreg_ext #(
    .DW    (12)
  ) u_host_fifo_status_rxlvl (
    .re     (host_fifo_status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.host_fifo_status.rxlvl.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (host_fifo_status_rxlvl_qs)
  );


  // R[target_fifo_status]: V(True)
  //   F[txlvl]: 11:0
  prim_subreg_ext #(
    .DW    (12)
  ) u_target_fifo_status_txlvl (
    .re     (target_fifo_status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.target_fifo_status.txlvl.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (target_fifo_status_txlvl_qs)
  );

  //   F[acqlvl]: 27:16
  prim_subreg_ext #(
    .DW    (12)
  ) u_target_fifo_status_acqlvl (
    .re     (target_fifo_status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.target_fifo_status.acqlvl.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (target_fifo_status_acqlvl_qs)
  );


  // R[ovrd]: V(False)
  //   F[txovrden]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_ovrd_txovrden (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ovrd_we),
    .wd     (ovrd_txovrden_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ovrd.txovrden.q),
    .ds     (),

    // to register interface (read)
    .qs     (ovrd_txovrden_qs)
  );

  //   F[sclval]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_ovrd_sclval (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ovrd_we),
    .wd     (ovrd_sclval_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ovrd.sclval.q),
    .ds     (),

    // to register interface (read)
    .qs     (ovrd_sclval_qs)
  );

  //   F[sdaval]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_ovrd_sdaval (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ovrd_we),
    .wd     (ovrd_sdaval_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ovrd.sdaval.q),
    .ds     (),

    // to register interface (read)
    .qs     (ovrd_sdaval_qs)
  );


  // R[val]: V(True)
  //   F[scl_rx]: 15:0
  prim_subreg_ext #(
    .DW    (16)
  ) u_val_scl_rx (
    .re     (val_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.val.scl_rx.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (val_scl_rx_qs)
  );

  //   F[sda_rx]: 31:16
  prim_subreg_ext #(
    .DW    (16)
  ) u_val_sda_rx (
    .re     (val_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.val.sda_rx.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (val_sda_rx_qs)
  );


  // R[timing0]: V(False)
  //   F[thigh]: 12:0
  prim_subreg #(
    .DW      (13),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (13'h0),
    .Mubi    (1'b0)
  ) u_timing0_thigh (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (timing0_we),
    .wd     (timing0_thigh_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.timing0.thigh.q),
    .ds     (),

    // to register interface (read)
    .qs     (timing0_thigh_qs)
  );

  //   F[tlow]: 28:16
  prim_subreg #(
    .DW      (13),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (13'h0),
    .Mubi    (1'b0)
  ) u_timing0_tlow (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (timing0_we),
    .wd     (timing0_tlow_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.timing0.tlow.q),
    .ds     (),

    // to register interface (read)
    .qs     (timing0_tlow_qs)
  );


  // R[timing1]: V(False)
  //   F[t_r]: 9:0
  prim_subreg #(
    .DW      (10),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (10'h0),
    .Mubi    (1'b0)
  ) u_timing1_t_r (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (timing1_we),
    .wd     (timing1_t_r_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.timing1.t_r.q),
    .ds     (),

    // to register interface (read)
    .qs     (timing1_t_r_qs)
  );

  //   F[t_f]: 24:16
  prim_subreg #(
    .DW      (9),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (9'h0),
    .Mubi    (1'b0)
  ) u_timing1_t_f (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (timing1_we),
    .wd     (timing1_t_f_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.timing1.t_f.q),
    .ds     (),

    // to register interface (read)
    .qs     (timing1_t_f_qs)
  );


  // R[timing2]: V(False)
  //   F[tsu_sta]: 12:0
  prim_subreg #(
    .DW      (13),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (13'h0),
    .Mubi    (1'b0)
  ) u_timing2_tsu_sta (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (timing2_we),
    .wd     (timing2_tsu_sta_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.timing2.tsu_sta.q),
    .ds     (),

    // to register interface (read)
    .qs     (timing2_tsu_sta_qs)
  );

  //   F[thd_sta]: 28:16
  prim_subreg #(
    .DW      (13),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (13'h0),
    .Mubi    (1'b0)
  ) u_timing2_thd_sta (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (timing2_we),
    .wd     (timing2_thd_sta_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.timing2.thd_sta.q),
    .ds     (),

    // to register interface (read)
    .qs     (timing2_thd_sta_qs)
  );


  // R[timing3]: V(False)
  //   F[tsu_dat]: 8:0
  prim_subreg #(
    .DW      (9),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (9'h0),
    .Mubi    (1'b0)
  ) u_timing3_tsu_dat (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (timing3_we),
    .wd     (timing3_tsu_dat_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.timing3.tsu_dat.q),
    .ds     (),

    // to register interface (read)
    .qs     (timing3_tsu_dat_qs)
  );

  //   F[thd_dat]: 28:16
  prim_subreg #(
    .DW      (13),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (13'h0),
    .Mubi    (1'b0)
  ) u_timing3_thd_dat (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (timing3_we),
    .wd     (timing3_thd_dat_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.timing3.thd_dat.q),
    .ds     (),

    // to register interface (read)
    .qs     (timing3_thd_dat_qs)
  );


  // R[timing4]: V(False)
  //   F[tsu_sto]: 12:0
  prim_subreg #(
    .DW      (13),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (13'h0),
    .Mubi    (1'b0)
  ) u_timing4_tsu_sto (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (timing4_we),
    .wd     (timing4_tsu_sto_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.timing4.tsu_sto.q),
    .ds     (),

    // to register interface (read)
    .qs     (timing4_tsu_sto_qs)
  );

  //   F[t_buf]: 28:16
  prim_subreg #(
    .DW      (13),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (13'h0),
    .Mubi    (1'b0)
  ) u_timing4_t_buf (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (timing4_we),
    .wd     (timing4_t_buf_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.timing4.t_buf.q),
    .ds     (),

    // to register interface (read)
    .qs     (timing4_t_buf_qs)
  );


  // R[timeout_ctrl]: V(False)
  //   F[val]: 29:0
  prim_subreg #(
    .DW      (30),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (30'h0),
    .Mubi    (1'b0)
  ) u_timeout_ctrl_val (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (timeout_ctrl_we),
    .wd     (timeout_ctrl_val_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.timeout_ctrl.val.q),
    .ds     (),

    // to register interface (read)
    .qs     (timeout_ctrl_val_qs)
  );

  //   F[mode]: 30:30
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_timeout_ctrl_mode (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (timeout_ctrl_we),
    .wd     (timeout_ctrl_mode_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.timeout_ctrl.mode.q),
    .ds     (),

    // to register interface (read)
    .qs     (timeout_ctrl_mode_qs)
  );

  //   F[en]: 31:31
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_timeout_ctrl_en (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (timeout_ctrl_we),
    .wd     (timeout_ctrl_en_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.timeout_ctrl.en.q),
    .ds     (),

    // to register interface (read)
    .qs     (timeout_ctrl_en_qs)
  );


  // R[target_id]: V(False)
  //   F[address0]: 6:0
  prim_subreg #(
    .DW      (7),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (7'h0),
    .Mubi    (1'b0)
  ) u_target_id_address0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (target_id_we),
    .wd     (target_id_address0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.target_id.address0.q),
    .ds     (),

    // to register interface (read)
    .qs     (target_id_address0_qs)
  );

  //   F[mask0]: 13:7
  prim_subreg #(
    .DW      (7),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (7'h0),
    .Mubi    (1'b0)
  ) u_target_id_mask0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (target_id_we),
    .wd     (target_id_mask0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.target_id.mask0.q),
    .ds     (),

    // to register interface (read)
    .qs     (target_id_mask0_qs)
  );

  //   F[address1]: 20:14
  prim_subreg #(
    .DW      (7),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (7'h0),
    .Mubi    (1'b0)
  ) u_target_id_address1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (target_id_we),
    .wd     (target_id_address1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.target_id.address1.q),
    .ds     (),

    // to register interface (read)
    .qs     (target_id_address1_qs)
  );

  //   F[mask1]: 27:21
  prim_subreg #(
    .DW      (7),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (7'h0),
    .Mubi    (1'b0)
  ) u_target_id_mask1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (target_id_we),
    .wd     (target_id_mask1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.target_id.mask1.q),
    .ds     (),

    // to register interface (read)
    .qs     (target_id_mask1_qs)
  );


  // R[acqdata]: V(True)
  //   F[abyte]: 7:0
  prim_subreg_ext #(
    .DW    (8)
  ) u_acqdata_abyte (
    .re     (acqdata_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.acqdata.abyte.d),
    .qre    (reg2hw.acqdata.abyte.re),
    .qe     (),
    .q      (reg2hw.acqdata.abyte.q),
    .ds     (),
    .qs     (acqdata_abyte_qs)
  );

  //   F[signal]: 10:8
  prim_subreg_ext #(
    .DW    (3)
  ) u_acqdata_signal (
    .re     (acqdata_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.acqdata.signal.d),
    .qre    (reg2hw.acqdata.signal.re),
    .qe     (),
    .q      (reg2hw.acqdata.signal.q),
    .ds     (),
    .qs     (acqdata_signal_qs)
  );


  // R[txdata]: V(False)
  logic txdata_qe;
  logic [0:0] txdata_flds_we;
  prim_flop #(
    .Width(1),
    .ResetValue(0)
  ) u_txdata0_qe (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .d_i(&txdata_flds_we),
    .q_o(txdata_qe)
  );
  prim_subreg #(
    .DW      (8),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (8'h0),
    .Mubi    (1'b0)
  ) u_txdata (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (txdata_we),
    .wd     (txdata_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (txdata_flds_we[0]),
    .q      (reg2hw.txdata.q),
    .ds     (),

    // to register interface (read)
    .qs     ()
  );
  assign reg2hw.txdata.qe = txdata_qe;


  // R[host_timeout_ctrl]: V(False)
  prim_subreg #(
    .DW      (20),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (20'h0),
    .Mubi    (1'b0)
  ) u_host_timeout_ctrl (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (host_timeout_ctrl_we),
    .wd     (host_timeout_ctrl_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.host_timeout_ctrl.q),
    .ds     (),

    // to register interface (read)
    .qs     (host_timeout_ctrl_qs)
  );


  // R[target_timeout_ctrl]: V(False)
  //   F[val]: 30:0
  prim_subreg #(
    .DW      (31),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (31'h0),
    .Mubi    (1'b0)
  ) u_target_timeout_ctrl_val (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (target_timeout_ctrl_we),
    .wd     (target_timeout_ctrl_val_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.target_timeout_ctrl.val.q),
    .ds     (),

    // to register interface (read)
    .qs     (target_timeout_ctrl_val_qs)
  );

  //   F[en]: 31:31
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_target_timeout_ctrl_en (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (target_timeout_ctrl_we),
    .wd     (target_timeout_ctrl_en_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.target_timeout_ctrl.en.q),
    .ds     (),

    // to register interface (read)
    .qs     (target_timeout_ctrl_en_qs)
  );


  // R[target_nack_count]: V(False)
  prim_subreg #(
    .DW      (8),
    .SwAccess(prim_subreg_pkg::SwAccessRC),
    .RESVAL  (8'h0),
    .Mubi    (1'b0)
  ) u_target_nack_count (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (target_nack_count_re),
    .wd     (target_nack_count_wd),

    // from internal hardware
    .de     (hw2reg.target_nack_count.de),
    .d      (hw2reg.target_nack_count.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.target_nack_count.q),
    .ds     (),

    // to register interface (read)
    .qs     (target_nack_count_qs)
  );


  // R[target_ack_ctrl]: V(True)
  logic target_ack_ctrl_qe;
  logic [1:0] target_ack_ctrl_flds_we;
  assign target_ack_ctrl_qe = &target_ack_ctrl_flds_we;
  //   F[nbytes]: 8:0
  prim_subreg_ext #(
    .DW    (9)
  ) u_target_ack_ctrl_nbytes (
    .re     (target_ack_ctrl_re),
    .we     (target_ack_ctrl_we),
    .wd     (target_ack_ctrl_nbytes_wd),
    .d      (hw2reg.target_ack_ctrl.nbytes.d),
    .qre    (),
    .qe     (target_ack_ctrl_flds_we[0]),
    .q      (reg2hw.target_ack_ctrl.nbytes.q),
    .ds     (),
    .qs     (target_ack_ctrl_nbytes_qs)
  );
  assign reg2hw.target_ack_ctrl.nbytes.qe = target_ack_ctrl_qe;

  //   F[nack]: 31:31
  prim_subreg_ext #(
    .DW    (1)
  ) u_target_ack_ctrl_nack (
    .re     (1'b0),
    .we     (target_ack_ctrl_we),
    .wd     (target_ack_ctrl_nack_wd),
    .d      ('0),
    .qre    (),
    .qe     (target_ack_ctrl_flds_we[1]),
    .q      (reg2hw.target_ack_ctrl.nack.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.target_ack_ctrl.nack.qe = target_ack_ctrl_qe;


  // R[acq_fifo_next_data]: V(True)
  prim_subreg_ext #(
    .DW    (8)
  ) u_acq_fifo_next_data (
    .re     (acq_fifo_next_data_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.acq_fifo_next_data.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (acq_fifo_next_data_qs)
  );


  // R[host_nack_handler_timeout]: V(False)
  //   F[val]: 30:0
  prim_subreg #(
    .DW      (31),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (31'h0),
    .Mubi    (1'b0)
  ) u_host_nack_handler_timeout_val (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (host_nack_handler_timeout_we),
    .wd     (host_nack_handler_timeout_val_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.host_nack_handler_timeout.val.q),
    .ds     (),

    // to register interface (read)
    .qs     (host_nack_handler_timeout_val_qs)
  );

  //   F[en]: 31:31
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_host_nack_handler_timeout_en (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (host_nack_handler_timeout_we),
    .wd     (host_nack_handler_timeout_en_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.host_nack_handler_timeout.en.q),
    .ds     (),

    // to register interface (read)
    .qs     (host_nack_handler_timeout_en_qs)
  );


  // R[controller_events]: V(False)
  //   F[nack]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_controller_events_nack (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (controller_events_we),
    .wd     (controller_events_nack_wd),

    // from internal hardware
    .de     (hw2reg.controller_events.nack.de),
    .d      (hw2reg.controller_events.nack.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.controller_events.nack.q),
    .ds     (),

    // to register interface (read)
    .qs     (controller_events_nack_qs)
  );

  //   F[unhandled_nack_timeout]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_controller_events_unhandled_nack_timeout (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (controller_events_we),
    .wd     (controller_events_unhandled_nack_timeout_wd),

    // from internal hardware
    .de     (hw2reg.controller_events.unhandled_nack_timeout.de),
    .d      (hw2reg.controller_events.unhandled_nack_timeout.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.controller_events.unhandled_nack_timeout.q),
    .ds     (),

    // to register interface (read)
    .qs     (controller_events_unhandled_nack_timeout_qs)
  );

  //   F[bus_timeout]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_controller_events_bus_timeout (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (controller_events_we),
    .wd     (controller_events_bus_timeout_wd),

    // from internal hardware
    .de     (hw2reg.controller_events.bus_timeout.de),
    .d      (hw2reg.controller_events.bus_timeout.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.controller_events.bus_timeout.q),
    .ds     (),

    // to register interface (read)
    .qs     (controller_events_bus_timeout_qs)
  );

  //   F[arbitration_lost]: 3:3
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_controller_events_arbitration_lost (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (controller_events_we),
    .wd     (controller_events_arbitration_lost_wd),

    // from internal hardware
    .de     (hw2reg.controller_events.arbitration_lost.de),
    .d      (hw2reg.controller_events.arbitration_lost.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.controller_events.arbitration_lost.q),
    .ds     (),

    // to register interface (read)
    .qs     (controller_events_arbitration_lost_qs)
  );


  // R[target_events]: V(False)
  //   F[tx_pending]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_target_events_tx_pending (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (target_events_we),
    .wd     (target_events_tx_pending_wd),

    // from internal hardware
    .de     (hw2reg.target_events.tx_pending.de),
    .d      (hw2reg.target_events.tx_pending.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.target_events.tx_pending.q),
    .ds     (),

    // to register interface (read)
    .qs     (target_events_tx_pending_qs)
  );

  //   F[bus_timeout]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_target_events_bus_timeout (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (target_events_we),
    .wd     (target_events_bus_timeout_wd),

    // from internal hardware
    .de     (hw2reg.target_events.bus_timeout.de),
    .d      (hw2reg.target_events.bus_timeout.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.target_events.bus_timeout.q),
    .ds     (),

    // to register interface (read)
    .qs     (target_events_bus_timeout_qs)
  );

  //   F[arbitration_lost]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_target_events_arbitration_lost (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (target_events_we),
    .wd     (target_events_arbitration_lost_wd),

    // from internal hardware
    .de     (hw2reg.target_events.arbitration_lost.de),
    .d      (hw2reg.target_events.arbitration_lost.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.target_events.arbitration_lost.q),
    .ds     (),

    // to register interface (read)
    .qs     (target_events_arbitration_lost_qs)
  );



  logic [31:0] addr_hit;
  top_racl_pkg::racl_role_vec_t racl_role_vec;
  top_racl_pkg::racl_role_t racl_role;

  logic [31:0] racl_addr_hit_read;
  logic [31:0] racl_addr_hit_write;

  if (EnableRacl) begin : gen_racl_role_logic
    // Retrieve RACL role from user bits and one-hot encode that for the comparison bitmap
    assign racl_role = top_racl_pkg::tlul_extract_racl_role_bits(tl_i.a_user.rsvd);

    prim_onehot_enc #(
      .OneHotWidth( $bits(top_racl_pkg::racl_role_vec_t) )
    ) u_racl_role_encode (
      .in_i ( racl_role     ),
      .en_i ( 1'b1          ),
      .out_o( racl_role_vec )
    );
  end else begin : gen_no_racl_role_logic
    assign racl_role     = '0;
    assign racl_role_vec = '0;
  end

  always_comb begin
    racl_addr_hit_read  = '0;
    racl_addr_hit_write = '0;
    addr_hit[ 0] = (reg_addr == I2C_INTR_STATE_OFFSET);
    addr_hit[ 1] = (reg_addr == I2C_INTR_ENABLE_OFFSET);
    addr_hit[ 2] = (reg_addr == I2C_INTR_TEST_OFFSET);
    addr_hit[ 3] = (reg_addr == I2C_ALERT_TEST_OFFSET);
    addr_hit[ 4] = (reg_addr == I2C_CTRL_OFFSET);
    addr_hit[ 5] = (reg_addr == I2C_STATUS_OFFSET);
    addr_hit[ 6] = (reg_addr == I2C_RDATA_OFFSET);
    addr_hit[ 7] = (reg_addr == I2C_FDATA_OFFSET);
    addr_hit[ 8] = (reg_addr == I2C_FIFO_CTRL_OFFSET);
    addr_hit[ 9] = (reg_addr == I2C_HOST_FIFO_CONFIG_OFFSET);
    addr_hit[10] = (reg_addr == I2C_TARGET_FIFO_CONFIG_OFFSET);
    addr_hit[11] = (reg_addr == I2C_HOST_FIFO_STATUS_OFFSET);
    addr_hit[12] = (reg_addr == I2C_TARGET_FIFO_STATUS_OFFSET);
    addr_hit[13] = (reg_addr == I2C_OVRD_OFFSET);
    addr_hit[14] = (reg_addr == I2C_VAL_OFFSET);
    addr_hit[15] = (reg_addr == I2C_TIMING0_OFFSET);
    addr_hit[16] = (reg_addr == I2C_TIMING1_OFFSET);
    addr_hit[17] = (reg_addr == I2C_TIMING2_OFFSET);
    addr_hit[18] = (reg_addr == I2C_TIMING3_OFFSET);
    addr_hit[19] = (reg_addr == I2C_TIMING4_OFFSET);
    addr_hit[20] = (reg_addr == I2C_TIMEOUT_CTRL_OFFSET);
    addr_hit[21] = (reg_addr == I2C_TARGET_ID_OFFSET);
    addr_hit[22] = (reg_addr == I2C_ACQDATA_OFFSET);
    addr_hit[23] = (reg_addr == I2C_TXDATA_OFFSET);
    addr_hit[24] = (reg_addr == I2C_HOST_TIMEOUT_CTRL_OFFSET);
    addr_hit[25] = (reg_addr == I2C_TARGET_TIMEOUT_CTRL_OFFSET);
    addr_hit[26] = (reg_addr == I2C_TARGET_NACK_COUNT_OFFSET);
    addr_hit[27] = (reg_addr == I2C_TARGET_ACK_CTRL_OFFSET);
    addr_hit[28] = (reg_addr == I2C_ACQ_FIFO_NEXT_DATA_OFFSET);
    addr_hit[29] = (reg_addr == I2C_HOST_NACK_HANDLER_TIMEOUT_OFFSET);
    addr_hit[30] = (reg_addr == I2C_CONTROLLER_EVENTS_OFFSET);
    addr_hit[31] = (reg_addr == I2C_TARGET_EVENTS_OFFSET);

    if (EnableRacl) begin : gen_racl_hit
      for (int unsigned slice_idx = 0; slice_idx < 32; slice_idx++) begin
        racl_addr_hit_read[slice_idx] =
            addr_hit[slice_idx] & (|(racl_policies_i[RaclPolicySelVec[slice_idx]].read_perm
                                      & racl_role_vec));
        racl_addr_hit_write[slice_idx] =
            addr_hit[slice_idx] & (|(racl_policies_i[RaclPolicySelVec[slice_idx]].write_perm
                                      & racl_role_vec));
      end
    end else begin : gen_no_racl
      racl_addr_hit_read  = addr_hit;
      racl_addr_hit_write = addr_hit;
    end
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;
  // A valid address hit, access, but failed the RACL check
  assign racl_error_o.valid = |addr_hit & ((reg_re & ~|racl_addr_hit_read) |
                                           (reg_we & ~|racl_addr_hit_write));
  assign racl_error_o.request_address = top_pkg::TL_AW'(reg_addr);
  assign racl_error_o.racl_role       = racl_role;
  assign racl_error_o.overflow        = 1'b0;

  if (EnableRacl) begin : gen_racl_log
    assign racl_error_o.ctn_uid     = top_racl_pkg::tlul_extract_ctn_uid_bits(tl_i.a_user.rsvd);
    assign racl_error_o.read_access = tl_i.a_opcode == tlul_pkg::Get;
  end else begin : gen_no_racl_log
    assign racl_error_o.ctn_uid     = '0;
    assign racl_error_o.read_access = 1'b0;
  end

  // Check sub-word write is permitted
  always_comb begin
    wr_err = (reg_we &
              ((racl_addr_hit_write[ 0] & (|(I2C_PERMIT[ 0] & ~reg_be))) |
               (racl_addr_hit_write[ 1] & (|(I2C_PERMIT[ 1] & ~reg_be))) |
               (racl_addr_hit_write[ 2] & (|(I2C_PERMIT[ 2] & ~reg_be))) |
               (racl_addr_hit_write[ 3] & (|(I2C_PERMIT[ 3] & ~reg_be))) |
               (racl_addr_hit_write[ 4] & (|(I2C_PERMIT[ 4] & ~reg_be))) |
               (racl_addr_hit_write[ 5] & (|(I2C_PERMIT[ 5] & ~reg_be))) |
               (racl_addr_hit_write[ 6] & (|(I2C_PERMIT[ 6] & ~reg_be))) |
               (racl_addr_hit_write[ 7] & (|(I2C_PERMIT[ 7] & ~reg_be))) |
               (racl_addr_hit_write[ 8] & (|(I2C_PERMIT[ 8] & ~reg_be))) |
               (racl_addr_hit_write[ 9] & (|(I2C_PERMIT[ 9] & ~reg_be))) |
               (racl_addr_hit_write[10] & (|(I2C_PERMIT[10] & ~reg_be))) |
               (racl_addr_hit_write[11] & (|(I2C_PERMIT[11] & ~reg_be))) |
               (racl_addr_hit_write[12] & (|(I2C_PERMIT[12] & ~reg_be))) |
               (racl_addr_hit_write[13] & (|(I2C_PERMIT[13] & ~reg_be))) |
               (racl_addr_hit_write[14] & (|(I2C_PERMIT[14] & ~reg_be))) |
               (racl_addr_hit_write[15] & (|(I2C_PERMIT[15] & ~reg_be))) |
               (racl_addr_hit_write[16] & (|(I2C_PERMIT[16] & ~reg_be))) |
               (racl_addr_hit_write[17] & (|(I2C_PERMIT[17] & ~reg_be))) |
               (racl_addr_hit_write[18] & (|(I2C_PERMIT[18] & ~reg_be))) |
               (racl_addr_hit_write[19] & (|(I2C_PERMIT[19] & ~reg_be))) |
               (racl_addr_hit_write[20] & (|(I2C_PERMIT[20] & ~reg_be))) |
               (racl_addr_hit_write[21] & (|(I2C_PERMIT[21] & ~reg_be))) |
               (racl_addr_hit_write[22] & (|(I2C_PERMIT[22] & ~reg_be))) |
               (racl_addr_hit_write[23] & (|(I2C_PERMIT[23] & ~reg_be))) |
               (racl_addr_hit_write[24] & (|(I2C_PERMIT[24] & ~reg_be))) |
               (racl_addr_hit_write[25] & (|(I2C_PERMIT[25] & ~reg_be))) |
               (racl_addr_hit_write[26] & (|(I2C_PERMIT[26] & ~reg_be))) |
               (racl_addr_hit_write[27] & (|(I2C_PERMIT[27] & ~reg_be))) |
               (racl_addr_hit_write[28] & (|(I2C_PERMIT[28] & ~reg_be))) |
               (racl_addr_hit_write[29] & (|(I2C_PERMIT[29] & ~reg_be))) |
               (racl_addr_hit_write[30] & (|(I2C_PERMIT[30] & ~reg_be))) |
               (racl_addr_hit_write[31] & (|(I2C_PERMIT[31] & ~reg_be)))));
  end

  // Generate write-enables
  assign intr_state_we = racl_addr_hit_write[0] & reg_we & !reg_error;

  assign intr_state_rx_overflow_wd = reg_wdata[3];

  assign intr_state_scl_interference_wd = reg_wdata[5];

  assign intr_state_sda_interference_wd = reg_wdata[6];

  assign intr_state_stretch_timeout_wd = reg_wdata[7];

  assign intr_state_sda_unstable_wd = reg_wdata[8];

  assign intr_state_cmd_complete_wd = reg_wdata[9];

  assign intr_state_unexp_stop_wd = reg_wdata[13];

  assign intr_state_host_timeout_wd = reg_wdata[14];
  assign intr_enable_we = racl_addr_hit_write[1] & reg_we & !reg_error;

  assign intr_enable_fmt_threshold_wd = reg_wdata[0];

  assign intr_enable_rx_threshold_wd = reg_wdata[1];

  assign intr_enable_acq_threshold_wd = reg_wdata[2];

  assign intr_enable_rx_overflow_wd = reg_wdata[3];

  assign intr_enable_controller_halt_wd = reg_wdata[4];

  assign intr_enable_scl_interference_wd = reg_wdata[5];

  assign intr_enable_sda_interference_wd = reg_wdata[6];

  assign intr_enable_stretch_timeout_wd = reg_wdata[7];

  assign intr_enable_sda_unstable_wd = reg_wdata[8];

  assign intr_enable_cmd_complete_wd = reg_wdata[9];

  assign intr_enable_tx_stretch_wd = reg_wdata[10];

  assign intr_enable_tx_threshold_wd = reg_wdata[11];

  assign intr_enable_acq_stretch_wd = reg_wdata[12];

  assign intr_enable_unexp_stop_wd = reg_wdata[13];

  assign intr_enable_host_timeout_wd = reg_wdata[14];
  assign intr_test_we = racl_addr_hit_write[2] & reg_we & !reg_error;

  assign intr_test_fmt_threshold_wd = reg_wdata[0];

  assign intr_test_rx_threshold_wd = reg_wdata[1];

  assign intr_test_acq_threshold_wd = reg_wdata[2];

  assign intr_test_rx_overflow_wd = reg_wdata[3];

  assign intr_test_controller_halt_wd = reg_wdata[4];

  assign intr_test_scl_interference_wd = reg_wdata[5];

  assign intr_test_sda_interference_wd = reg_wdata[6];

  assign intr_test_stretch_timeout_wd = reg_wdata[7];

  assign intr_test_sda_unstable_wd = reg_wdata[8];

  assign intr_test_cmd_complete_wd = reg_wdata[9];

  assign intr_test_tx_stretch_wd = reg_wdata[10];

  assign intr_test_tx_threshold_wd = reg_wdata[11];

  assign intr_test_acq_stretch_wd = reg_wdata[12];

  assign intr_test_unexp_stop_wd = reg_wdata[13];

  assign intr_test_host_timeout_wd = reg_wdata[14];
  assign alert_test_we = racl_addr_hit_write[3] & reg_we & !reg_error;

  assign alert_test_wd = reg_wdata[0];
  assign ctrl_we = racl_addr_hit_write[4] & reg_we & !reg_error;

  assign ctrl_enablehost_wd = reg_wdata[0];

  assign ctrl_enabletarget_wd = reg_wdata[1];

  assign ctrl_llpbk_wd = reg_wdata[2];

  assign ctrl_nack_addr_after_timeout_wd = reg_wdata[3];

  assign ctrl_ack_ctrl_en_wd = reg_wdata[4];

  assign ctrl_multi_controller_monitor_en_wd = reg_wdata[5];

  assign ctrl_tx_stretch_ctrl_en_wd = reg_wdata[6];
  assign status_re = racl_addr_hit_read[5] & reg_re & !reg_error;
  assign rdata_re = racl_addr_hit_read[6] & reg_re & !reg_error;
  assign fdata_we = racl_addr_hit_write[7] & reg_we & !reg_error;

  assign fdata_fbyte_wd = reg_wdata[7:0];

  assign fdata_start_wd = reg_wdata[8];

  assign fdata_stop_wd = reg_wdata[9];

  assign fdata_readb_wd = reg_wdata[10];

  assign fdata_rcont_wd = reg_wdata[11];

  assign fdata_nakok_wd = reg_wdata[12];
  assign fifo_ctrl_we = racl_addr_hit_write[8] & reg_we & !reg_error;

  assign fifo_ctrl_rxrst_wd = reg_wdata[0];

  assign fifo_ctrl_fmtrst_wd = reg_wdata[1];

  assign fifo_ctrl_acqrst_wd = reg_wdata[7];

  assign fifo_ctrl_txrst_wd = reg_wdata[8];
  assign host_fifo_config_we = racl_addr_hit_write[9] & reg_we & !reg_error;

  assign host_fifo_config_rx_thresh_wd = reg_wdata[11:0];

  assign host_fifo_config_fmt_thresh_wd = reg_wdata[27:16];
  assign target_fifo_config_we = racl_addr_hit_write[10] & reg_we & !reg_error;

  assign target_fifo_config_tx_thresh_wd = reg_wdata[11:0];

  assign target_fifo_config_acq_thresh_wd = reg_wdata[27:16];
  assign host_fifo_status_re = racl_addr_hit_read[11] & reg_re & !reg_error;
  assign target_fifo_status_re = racl_addr_hit_read[12] & reg_re & !reg_error;
  assign ovrd_we = racl_addr_hit_write[13] & reg_we & !reg_error;

  assign ovrd_txovrden_wd = reg_wdata[0];

  assign ovrd_sclval_wd = reg_wdata[1];

  assign ovrd_sdaval_wd = reg_wdata[2];
  assign val_re = racl_addr_hit_read[14] & reg_re & !reg_error;
  assign timing0_we = racl_addr_hit_write[15] & reg_we & !reg_error;

  assign timing0_thigh_wd = reg_wdata[12:0];

  assign timing0_tlow_wd = reg_wdata[28:16];
  assign timing1_we = racl_addr_hit_write[16] & reg_we & !reg_error;

  assign timing1_t_r_wd = reg_wdata[9:0];

  assign timing1_t_f_wd = reg_wdata[24:16];
  assign timing2_we = racl_addr_hit_write[17] & reg_we & !reg_error;

  assign timing2_tsu_sta_wd = reg_wdata[12:0];

  assign timing2_thd_sta_wd = reg_wdata[28:16];
  assign timing3_we = racl_addr_hit_write[18] & reg_we & !reg_error;

  assign timing3_tsu_dat_wd = reg_wdata[8:0];

  assign timing3_thd_dat_wd = reg_wdata[28:16];
  assign timing4_we = racl_addr_hit_write[19] & reg_we & !reg_error;

  assign timing4_tsu_sto_wd = reg_wdata[12:0];

  assign timing4_t_buf_wd = reg_wdata[28:16];
  assign timeout_ctrl_we = racl_addr_hit_write[20] & reg_we & !reg_error;

  assign timeout_ctrl_val_wd = reg_wdata[29:0];

  assign timeout_ctrl_mode_wd = reg_wdata[30];

  assign timeout_ctrl_en_wd = reg_wdata[31];
  assign target_id_we = racl_addr_hit_write[21] & reg_we & !reg_error;

  assign target_id_address0_wd = reg_wdata[6:0];

  assign target_id_mask0_wd = reg_wdata[13:7];

  assign target_id_address1_wd = reg_wdata[20:14];

  assign target_id_mask1_wd = reg_wdata[27:21];
  assign acqdata_re = racl_addr_hit_read[22] & reg_re & !reg_error;
  assign txdata_we = racl_addr_hit_write[23] & reg_we & !reg_error;

  assign txdata_wd = reg_wdata[7:0];
  assign host_timeout_ctrl_we = racl_addr_hit_write[24] & reg_we & !reg_error;

  assign host_timeout_ctrl_wd = reg_wdata[19:0];
  assign target_timeout_ctrl_we = racl_addr_hit_write[25] & reg_we & !reg_error;

  assign target_timeout_ctrl_val_wd = reg_wdata[30:0];

  assign target_timeout_ctrl_en_wd = reg_wdata[31];
  assign target_nack_count_re = racl_addr_hit_read[26] & reg_re & !reg_error;

  assign target_nack_count_wd = '1;
  assign target_ack_ctrl_re = racl_addr_hit_read[27] & reg_re & !reg_error;
  assign target_ack_ctrl_we = racl_addr_hit_write[27] & reg_we & !reg_error;

  assign target_ack_ctrl_nbytes_wd = reg_wdata[8:0];

  assign target_ack_ctrl_nack_wd = reg_wdata[31];
  assign acq_fifo_next_data_re = racl_addr_hit_read[28] & reg_re & !reg_error;
  assign host_nack_handler_timeout_we = racl_addr_hit_write[29] & reg_we & !reg_error;

  assign host_nack_handler_timeout_val_wd = reg_wdata[30:0];

  assign host_nack_handler_timeout_en_wd = reg_wdata[31];
  assign controller_events_we = racl_addr_hit_write[30] & reg_we & !reg_error;

  assign controller_events_nack_wd = reg_wdata[0];

  assign controller_events_unhandled_nack_timeout_wd = reg_wdata[1];

  assign controller_events_bus_timeout_wd = reg_wdata[2];

  assign controller_events_arbitration_lost_wd = reg_wdata[3];
  assign target_events_we = racl_addr_hit_write[31] & reg_we & !reg_error;

  assign target_events_tx_pending_wd = reg_wdata[0];

  assign target_events_bus_timeout_wd = reg_wdata[1];

  assign target_events_arbitration_lost_wd = reg_wdata[2];

  // Assign write-enables to checker logic vector.
  always_comb begin
    reg_we_check[0] = intr_state_we;
    reg_we_check[1] = intr_enable_we;
    reg_we_check[2] = intr_test_we;
    reg_we_check[3] = alert_test_we;
    reg_we_check[4] = ctrl_we;
    reg_we_check[5] = 1'b0;
    reg_we_check[6] = 1'b0;
    reg_we_check[7] = fdata_we;
    reg_we_check[8] = fifo_ctrl_we;
    reg_we_check[9] = host_fifo_config_we;
    reg_we_check[10] = target_fifo_config_we;
    reg_we_check[11] = 1'b0;
    reg_we_check[12] = 1'b0;
    reg_we_check[13] = ovrd_we;
    reg_we_check[14] = 1'b0;
    reg_we_check[15] = timing0_we;
    reg_we_check[16] = timing1_we;
    reg_we_check[17] = timing2_we;
    reg_we_check[18] = timing3_we;
    reg_we_check[19] = timing4_we;
    reg_we_check[20] = timeout_ctrl_we;
    reg_we_check[21] = target_id_we;
    reg_we_check[22] = 1'b0;
    reg_we_check[23] = txdata_we;
    reg_we_check[24] = host_timeout_ctrl_we;
    reg_we_check[25] = target_timeout_ctrl_we;
    reg_we_check[26] = 1'b0;
    reg_we_check[27] = target_ack_ctrl_we;
    reg_we_check[28] = 1'b0;
    reg_we_check[29] = host_nack_handler_timeout_we;
    reg_we_check[30] = controller_events_we;
    reg_we_check[31] = target_events_we;
  end

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      racl_addr_hit_read[0]: begin
        reg_rdata_next[0] = intr_state_fmt_threshold_qs;
        reg_rdata_next[1] = intr_state_rx_threshold_qs;
        reg_rdata_next[2] = intr_state_acq_threshold_qs;
        reg_rdata_next[3] = intr_state_rx_overflow_qs;
        reg_rdata_next[4] = intr_state_controller_halt_qs;
        reg_rdata_next[5] = intr_state_scl_interference_qs;
        reg_rdata_next[6] = intr_state_sda_interference_qs;
        reg_rdata_next[7] = intr_state_stretch_timeout_qs;
        reg_rdata_next[8] = intr_state_sda_unstable_qs;
        reg_rdata_next[9] = intr_state_cmd_complete_qs;
        reg_rdata_next[10] = intr_state_tx_stretch_qs;
        reg_rdata_next[11] = intr_state_tx_threshold_qs;
        reg_rdata_next[12] = intr_state_acq_stretch_qs;
        reg_rdata_next[13] = intr_state_unexp_stop_qs;
        reg_rdata_next[14] = intr_state_host_timeout_qs;
      end

      racl_addr_hit_read[1]: begin
        reg_rdata_next[0] = intr_enable_fmt_threshold_qs;
        reg_rdata_next[1] = intr_enable_rx_threshold_qs;
        reg_rdata_next[2] = intr_enable_acq_threshold_qs;
        reg_rdata_next[3] = intr_enable_rx_overflow_qs;
        reg_rdata_next[4] = intr_enable_controller_halt_qs;
        reg_rdata_next[5] = intr_enable_scl_interference_qs;
        reg_rdata_next[6] = intr_enable_sda_interference_qs;
        reg_rdata_next[7] = intr_enable_stretch_timeout_qs;
        reg_rdata_next[8] = intr_enable_sda_unstable_qs;
        reg_rdata_next[9] = intr_enable_cmd_complete_qs;
        reg_rdata_next[10] = intr_enable_tx_stretch_qs;
        reg_rdata_next[11] = intr_enable_tx_threshold_qs;
        reg_rdata_next[12] = intr_enable_acq_stretch_qs;
        reg_rdata_next[13] = intr_enable_unexp_stop_qs;
        reg_rdata_next[14] = intr_enable_host_timeout_qs;
      end

      racl_addr_hit_read[2]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
        reg_rdata_next[2] = '0;
        reg_rdata_next[3] = '0;
        reg_rdata_next[4] = '0;
        reg_rdata_next[5] = '0;
        reg_rdata_next[6] = '0;
        reg_rdata_next[7] = '0;
        reg_rdata_next[8] = '0;
        reg_rdata_next[9] = '0;
        reg_rdata_next[10] = '0;
        reg_rdata_next[11] = '0;
        reg_rdata_next[12] = '0;
        reg_rdata_next[13] = '0;
        reg_rdata_next[14] = '0;
      end

      racl_addr_hit_read[3]: begin
        reg_rdata_next[0] = '0;
      end

      racl_addr_hit_read[4]: begin
        reg_rdata_next[0] = ctrl_enablehost_qs;
        reg_rdata_next[1] = ctrl_enabletarget_qs;
        reg_rdata_next[2] = ctrl_llpbk_qs;
        reg_rdata_next[3] = ctrl_nack_addr_after_timeout_qs;
        reg_rdata_next[4] = ctrl_ack_ctrl_en_qs;
        reg_rdata_next[5] = ctrl_multi_controller_monitor_en_qs;
        reg_rdata_next[6] = ctrl_tx_stretch_ctrl_en_qs;
      end

      racl_addr_hit_read[5]: begin
        reg_rdata_next[0] = status_fmtfull_qs;
        reg_rdata_next[1] = status_rxfull_qs;
        reg_rdata_next[2] = status_fmtempty_qs;
        reg_rdata_next[3] = status_hostidle_qs;
        reg_rdata_next[4] = status_targetidle_qs;
        reg_rdata_next[5] = status_rxempty_qs;
        reg_rdata_next[6] = status_txfull_qs;
        reg_rdata_next[7] = status_acqfull_qs;
        reg_rdata_next[8] = status_txempty_qs;
        reg_rdata_next[9] = status_acqempty_qs;
        reg_rdata_next[10] = status_ack_ctrl_stretch_qs;
      end

      racl_addr_hit_read[6]: begin
        reg_rdata_next[7:0] = rdata_qs;
      end

      racl_addr_hit_read[7]: begin
        reg_rdata_next[7:0] = '0;
        reg_rdata_next[8] = '0;
        reg_rdata_next[9] = '0;
        reg_rdata_next[10] = '0;
        reg_rdata_next[11] = '0;
        reg_rdata_next[12] = '0;
      end

      racl_addr_hit_read[8]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
        reg_rdata_next[7] = '0;
        reg_rdata_next[8] = '0;
      end

      racl_addr_hit_read[9]: begin
        reg_rdata_next[11:0] = host_fifo_config_rx_thresh_qs;
        reg_rdata_next[27:16] = host_fifo_config_fmt_thresh_qs;
      end

      racl_addr_hit_read[10]: begin
        reg_rdata_next[11:0] = target_fifo_config_tx_thresh_qs;
        reg_rdata_next[27:16] = target_fifo_config_acq_thresh_qs;
      end

      racl_addr_hit_read[11]: begin
        reg_rdata_next[11:0] = host_fifo_status_fmtlvl_qs;
        reg_rdata_next[27:16] = host_fifo_status_rxlvl_qs;
      end

      racl_addr_hit_read[12]: begin
        reg_rdata_next[11:0] = target_fifo_status_txlvl_qs;
        reg_rdata_next[27:16] = target_fifo_status_acqlvl_qs;
      end

      racl_addr_hit_read[13]: begin
        reg_rdata_next[0] = ovrd_txovrden_qs;
        reg_rdata_next[1] = ovrd_sclval_qs;
        reg_rdata_next[2] = ovrd_sdaval_qs;
      end

      racl_addr_hit_read[14]: begin
        reg_rdata_next[15:0] = val_scl_rx_qs;
        reg_rdata_next[31:16] = val_sda_rx_qs;
      end

      racl_addr_hit_read[15]: begin
        reg_rdata_next[12:0] = timing0_thigh_qs;
        reg_rdata_next[28:16] = timing0_tlow_qs;
      end

      racl_addr_hit_read[16]: begin
        reg_rdata_next[9:0] = timing1_t_r_qs;
        reg_rdata_next[24:16] = timing1_t_f_qs;
      end

      racl_addr_hit_read[17]: begin
        reg_rdata_next[12:0] = timing2_tsu_sta_qs;
        reg_rdata_next[28:16] = timing2_thd_sta_qs;
      end

      racl_addr_hit_read[18]: begin
        reg_rdata_next[8:0] = timing3_tsu_dat_qs;
        reg_rdata_next[28:16] = timing3_thd_dat_qs;
      end

      racl_addr_hit_read[19]: begin
        reg_rdata_next[12:0] = timing4_tsu_sto_qs;
        reg_rdata_next[28:16] = timing4_t_buf_qs;
      end

      racl_addr_hit_read[20]: begin
        reg_rdata_next[29:0] = timeout_ctrl_val_qs;
        reg_rdata_next[30] = timeout_ctrl_mode_qs;
        reg_rdata_next[31] = timeout_ctrl_en_qs;
      end

      racl_addr_hit_read[21]: begin
        reg_rdata_next[6:0] = target_id_address0_qs;
        reg_rdata_next[13:7] = target_id_mask0_qs;
        reg_rdata_next[20:14] = target_id_address1_qs;
        reg_rdata_next[27:21] = target_id_mask1_qs;
      end

      racl_addr_hit_read[22]: begin
        reg_rdata_next[7:0] = acqdata_abyte_qs;
        reg_rdata_next[10:8] = acqdata_signal_qs;
      end

      racl_addr_hit_read[23]: begin
        reg_rdata_next[7:0] = '0;
      end

      racl_addr_hit_read[24]: begin
        reg_rdata_next[19:0] = host_timeout_ctrl_qs;
      end

      racl_addr_hit_read[25]: begin
        reg_rdata_next[30:0] = target_timeout_ctrl_val_qs;
        reg_rdata_next[31] = target_timeout_ctrl_en_qs;
      end

      racl_addr_hit_read[26]: begin
        reg_rdata_next[7:0] = target_nack_count_qs;
      end

      racl_addr_hit_read[27]: begin
        reg_rdata_next[8:0] = target_ack_ctrl_nbytes_qs;
        reg_rdata_next[31] = '0;
      end

      racl_addr_hit_read[28]: begin
        reg_rdata_next[7:0] = acq_fifo_next_data_qs;
      end

      racl_addr_hit_read[29]: begin
        reg_rdata_next[30:0] = host_nack_handler_timeout_val_qs;
        reg_rdata_next[31] = host_nack_handler_timeout_en_qs;
      end

      racl_addr_hit_read[30]: begin
        reg_rdata_next[0] = controller_events_nack_qs;
        reg_rdata_next[1] = controller_events_unhandled_nack_timeout_qs;
        reg_rdata_next[2] = controller_events_bus_timeout_qs;
        reg_rdata_next[3] = controller_events_arbitration_lost_qs;
      end

      racl_addr_hit_read[31]: begin
        reg_rdata_next[0] = target_events_tx_pending_qs;
        reg_rdata_next[1] = target_events_bus_timeout_qs;
        reg_rdata_next[2] = target_events_arbitration_lost_qs;
      end

      default: begin
        reg_rdata_next = '1;
      end
    endcase
  end

  // shadow busy
  logic shadow_busy;
  assign shadow_busy = 1'b0;

  // register busy
  assign reg_busy = shadow_busy;

  // Unused signal tieoff

  // wdata / byte enable are not always fully used
  // add a blanket unused statement to handle lint waivers
  logic unused_wdata;
  logic unused_be;
  assign unused_wdata = ^reg_wdata;
  assign unused_be = ^reg_be;
  logic unused_policy_sel;
  assign unused_policy_sel = ^racl_policies_i;

  // Assertions for Register Interface
    
    

  

  

  // this is formulated as an assumption such that the FPV testbenches do disprove this
  // property by mistake
  //`ASSUME(reqParity, tl_reg_h2d.a_valid |-> tl_reg_h2d.a_user.chk_en == tlul_pkg::CheckDis)

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// This adapter module allows using a single-port SRAM like a FIFO.  It has been written for I2C,
// but it could later be generalized into a prim.

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module i2c_fifo_sync_sram_adapter #(
  // Width of each entry (in bits)
  parameter int unsigned Width = 1,
  // Total depth of the FIFO (in number of entries), including the output buffer in this module.
  // Must be at least 3.
  parameter int unsigned Depth = 3,
  // Address width of the SRAM
  parameter int unsigned SramAw = 1,
  // Base address of the FIFO in the SRAM
  parameter logic [SramAw-1:0] SramBaseAddr = '0,
  // Derived parameters; don't override!
  localparam int unsigned DepthW = prim_util_pkg::vbits(Depth + 1)
) (
  input  logic              clk_i,
  input  logic              rst_ni,
  input  logic              clr_i,

  // FIFO interface
  input  logic              fifo_wvalid_i,
  output logic              fifo_wready_o,
  input  logic [Width-1:0]  fifo_wdata_i,
  output logic              fifo_rvalid_o,
  input  logic              fifo_rready_i,
  output logic [Width-1:0]  fifo_rdata_o,
  output logic [DepthW-1:0] fifo_depth_o,

  // SRAM interface.  When this module reads from the SRAM, it expects the read data in the next
  // cycle.
  output logic              sram_req_o,
  input  logic              sram_gnt_i,
  output logic              sram_write_o,
  output logic [SramAw-1:0] sram_addr_o,
  output logic [Width-1:0]  sram_wdata_o,
  output logic [Width-1:0]  sram_wmask_o,
  input  logic [Width-1:0]  sram_rdata_i,
  input  logic              sram_rvalid_i,

  output logic              err_o
);

  // Depth of the input buffer.
  localparam int unsigned InpBufDepth = 2;

  // Depth of the output buffer.  To support a read in the cycle after N consecutive cycles in which
  // this module simultaneously got written and read, the depth needs to be N + 1 (one entry extra
  // to cover the single-cycle latency of SRAM reads).  We currently support this for 1 cycle.
  localparam int unsigned OupBufDepth = 2;

  // Depth of the SRAM-stored FIFO; simply the entries that don't fit into the output buffer.
  localparam int SramFifoDepth = Depth - OupBufDepth;

  // While it would theoretically be possible that the output buffer is as deep as the entire FIFO,
  // the current implementation doesn't support this.
  

  localparam int unsigned InpBufDepthW = prim_util_pkg::vbits(InpBufDepth + 1);
  localparam int unsigned OupBufDepthW = prim_util_pkg::vbits(OupBufDepth + 1);
  localparam int unsigned SramPtrW = prim_util_pkg::vbits(SramFifoDepth);
  localparam int unsigned SramDepthW = prim_util_pkg::vbits(SramFifoDepth + 1);

  

  localparam int unsigned SramAddrLeadingZeros = SramAw - SramPtrW;

  // Input buffer
  logic                    inp_buf_wvalid, inp_buf_wready,
                           inp_buf_rvalid, inp_buf_rready,
                           inp_buf_err;
  logic [Width-1:0]        inp_buf_rdata;
  logic [InpBufDepthW-1:0] inp_buf_depth;
  prim_fifo_sync #(
    .Width(Width),
    .Pass (1'b1),
    .Depth(InpBufDepth)
  ) u_inp_buf (
    .clk_i,
    .rst_ni,
    .clr_i,
    .wvalid_i(inp_buf_wvalid),
    .wready_o(inp_buf_wready),
    .wdata_i (fifo_wdata_i),
    .rvalid_o(inp_buf_rvalid),
    .rready_i(inp_buf_rready),
    .rdata_o (inp_buf_rdata),
    .full_o  (/* unused */),
    .depth_o (inp_buf_depth),
    .err_o   (inp_buf_err)
  );

  // Output buffer
  logic                    oup_buf_wvalid, oup_buf_wready, oup_buf_full, oup_buf_almost_full,
                           oup_buf_err;
  logic [Width-1:0]        oup_buf_wdata;
  logic [OupBufDepthW-1:0] oup_buf_depth;
  prim_fifo_sync #(
    .Width(Width),
    .Pass (1'b1),
    .Depth(OupBufDepth)
  ) u_oup_buf (
    .clk_i,
    .rst_ni,
    .clr_i,
    .wvalid_i(oup_buf_wvalid),
    .wready_o(oup_buf_wready),
    .wdata_i (oup_buf_wdata),
    .rvalid_o(fifo_rvalid_o),
    .rready_i(fifo_rready_i),
    .rdata_o (fifo_rdata_o),
    .full_o  (oup_buf_full),
    .depth_o (oup_buf_depth),
    .err_o   (oup_buf_err)
  );
  assign inp_buf_wvalid = fifo_wvalid_i && fifo_wready_o;
  assign oup_buf_almost_full = oup_buf_depth >= OupBufDepthW'(OupBufDepth - 1);

  // Signal whether we access the SRAM in this cycle
  logic sram_access;
  assign sram_access = sram_req_o && sram_gnt_i;

  // SRAM read and write addresses
  logic [SramAw-1:0]     sram_wr_addr, sram_rd_addr;
  logic [SramPtrW-1:0]   sram_wr_ptr, sram_rd_ptr;
  logic [SramDepthW-1:0] sram_depth;
  logic                  sram_incr_wr_ptr, sram_incr_rd_ptr;
  logic                  sram_full, sram_empty;
  logic                  sram_ptrs_err;
  prim_fifo_sync_cnt #(
    .Depth (SramFifoDepth),
    .Secure(1'b0)
  ) u_sram_ptrs (
    .clk_i,
    .rst_ni,
    .clr_i,
    .incr_wptr_i(sram_incr_wr_ptr),
    .incr_rptr_i(sram_incr_rd_ptr),
    .wptr_o     (sram_wr_ptr),
    .rptr_o     (sram_rd_ptr),
    .full_o     (sram_full),
    .empty_o    (sram_empty),
    .depth_o    (sram_depth),
    .err_o      (sram_ptrs_err)
  );
  assign sram_incr_wr_ptr = sram_access && sram_write_o;
  assign sram_incr_rd_ptr = sram_access && !sram_write_o;
  if (SramAddrLeadingZeros > 0) begin : gen_zero_extend_sram_addrs
    assign sram_wr_addr = {{SramAddrLeadingZeros{1'b0}}, sram_wr_ptr} + SramBaseAddr;
    assign sram_rd_addr = {{SramAddrLeadingZeros{1'b0}}, sram_rd_ptr} + SramBaseAddr;
  end else begin : gen_no_zero_extend_sram_addrs
    assign sram_wr_addr = sram_wr_ptr + SramBaseAddr;
    assign sram_rd_addr = sram_rd_ptr + SramBaseAddr;
  end

  // FF to remember whether we read from the SRAM in the previous clock cycle.
  logic sram_read_in_prev_cyc_d, sram_read_in_prev_cyc_q;
  assign sram_read_in_prev_cyc_d = clr_i ? 1'b0 : sram_incr_rd_ptr;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      sram_read_in_prev_cyc_q <= 1'b0;
    end else begin
      sram_read_in_prev_cyc_q <= sram_read_in_prev_cyc_d;
    end
  end

  // Control logic for FIFO interface wready, output buffer writes, and SRAM requests
  logic state_err;
  always_comb begin
    inp_buf_rready = 1'b0;
    oup_buf_wvalid = 1'b0;
    oup_buf_wdata = inp_buf_rdata;
    sram_req_o = 1'b0;
    sram_write_o = 1'b0;
    sram_addr_o = sram_wr_addr;
    state_err = 1'b0;

    // If the SRAM was read in the previous cycle, write the read data to the output buffer.
    if (sram_read_in_prev_cyc_q) begin
      oup_buf_wvalid = 1'b1;
      oup_buf_wdata = sram_rdata_i;
      // The output buffer must be ready; otherwise we are in an erroneous state.
      state_err = !oup_buf_wready;
    end

    // If the SRAM is not empty, data from the input buffer must flow via the SRAM.
    if (!sram_empty) begin

      // Prioritize refilling of the output buffer: if the output buffer is not being filled to the
      // last slot in the current cycle or it is being read in the current cycle, read from the SRAM
      // so the output buffer can be written in the next cycle.
      if (!((oup_buf_almost_full && oup_buf_wvalid) || oup_buf_full)
          || (fifo_rvalid_o && fifo_rready_i)) begin
        sram_req_o = 1'b1;
        sram_write_o = 1'b0;
        sram_addr_o = sram_rd_addr;

      // If the output buffer is full (and not being read), drain the input buffer into the SRAM.
      end else begin
        sram_req_o = !sram_full && inp_buf_rvalid;
        sram_write_o = 1'b1;
        sram_addr_o = sram_wr_addr;
        inp_buf_rready = !sram_full && sram_gnt_i;
      end

    // If the SRAM is empty, data must flow from the input buffer to the output buffer if the output
    // buffer is ready and is not receiving data read from the SRAM in the previous cycle
    end else if (oup_buf_wready && !sram_read_in_prev_cyc_q) begin
      oup_buf_wvalid = inp_buf_rvalid;
      oup_buf_wdata = inp_buf_rdata;
      inp_buf_rready = oup_buf_wready;

    // Otherwise the SRAM is empty but the output buffer cannot take the data from the input buffer,
    // so drain the input buffer into the SRAM.
    end else begin
      sram_req_o = !sram_full && inp_buf_rvalid;
      sram_write_o = 1'b1;
      sram_addr_o = sram_wr_addr;
      inp_buf_rready = !sram_full && sram_gnt_i;
    end
  end

  // Error output is high if any of the internal errors is high
  assign err_o = |{inp_buf_err, oup_buf_err, sram_ptrs_err, state_err};

  // The SRAM and the output buffer together form the entire architectural capacity of the FIFO.
  // Thus, when both are full, the FIFO is no longer ready to receive writes even though the input
  // buffer could store one additional entry.  This ensures that in the cycle after an entry has
  // been read from the full FIFO, the next entry can be written to the FIFO.
  // (It may be possible that all input buffer slots except one can be counted to the architectural
  // capacity of the FIFO, but this is a relatively small optimization left for future work.)
  assign fifo_wready_o = inp_buf_wready && !(sram_full && oup_buf_full);

  // The current depth of the FIFO represented by this module is the depth of all buffers plus the
  // FIFO in the SRAM plus one if there's an entry in transition between SRAM and output buffer.
  assign fifo_depth_o = DepthW'(inp_buf_depth) + DepthW'(sram_depth) + DepthW'(oup_buf_depth) +
                        DepthW'(sram_read_in_prev_cyc_q);

  // SRAM write data always comes from the input buffer.
  assign sram_wdata_o = inp_buf_rdata;
  assign sram_wmask_o = '1;

  // `sram_rvalid_i` is only used for assertions.
  logic unused_sram_rvalid;
  assign unused_sram_rvalid = sram_rvalid_i;

  // When we read from the SRAM in the previous cycle, we expect valid read data in this cycle.
  

  // When we read from the SRAM in the previous cycle, the output buffer must be ready to store data
  // in this cycle.
  

  // We must never write the SRAM when it is full.
  

  // We must never read from the SRAM when it is empty.
  

  // We must never be in an erroneous state (impossible without functional defects).
  
endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module i2c_fifos
import i2c_pkg::*;
import i2c_reg_pkg::FifoDepth;
import i2c_reg_pkg::AcqFifoDepth;
#(
  localparam int unsigned FifoDepthW = $clog2(FifoDepth + 1),
  localparam int unsigned AcqFifoDepthW = $clog2(AcqFifoDepth + 1)
) (
  input  logic                             clk_i,
  input  logic                             rst_ni,
  input  prim_ram_1p_pkg::ram_1p_cfg_t     ram_cfg_i,
  output prim_ram_1p_pkg::ram_1p_cfg_rsp_t ram_cfg_rsp_o,

  input  logic                             fmt_fifo_clr_i,
  output logic [FifoDepthW-1:0]            fmt_fifo_depth_o,
  // FMT FIFO: writes controlled by CSR
  input  logic                             fmt_fifo_wvalid_i,
  output logic                             fmt_fifo_wready_o,
  input  logic [FMT_FIFO_WIDTH-1:0] fmt_fifo_wdata_i,
  // FMT FIFO: reads controlled by FSM
  output logic                             fmt_fifo_rvalid_o,
  input  logic                             fmt_fifo_rready_i,
  output logic [FMT_FIFO_WIDTH-1:0]        fmt_fifo_rdata_o,

  input  logic                             rx_fifo_clr_i,
  output logic [FifoDepthW-1:0]            rx_fifo_depth_o,
  // RX FIFO: writes controller by FSM
  input  logic                             rx_fifo_wvalid_i,
  output logic                             rx_fifo_wready_o,
  input  logic [RX_FIFO_WIDTH-1:0]         rx_fifo_wdata_i,
  // RX FIFO: reads controlled by CSR
  output logic                             rx_fifo_rvalid_o,
  input  logic                             rx_fifo_rready_i,
  output logic [RX_FIFO_WIDTH-1:0]         rx_fifo_rdata_o,

  input  logic                             tx_fifo_clr_i,
  output logic [FifoDepthW-1:0]            tx_fifo_depth_o,
  // TX FIFO: writes controlled by CSR
  input  logic                             tx_fifo_wvalid_i,
  output logic                             tx_fifo_wready_o,
  input  logic [TX_FIFO_WIDTH-1:0]         tx_fifo_wdata_i,
  // TX FIFO: reads controlled by FSM
  output logic                             tx_fifo_rvalid_o,
  input  logic                             tx_fifo_rready_i,
  output logic [TX_FIFO_WIDTH-1:0]         tx_fifo_rdata_o,

  input  logic                             acq_fifo_clr_i,
  output logic [AcqFifoDepthW-1:0]         acq_fifo_depth_o,
  // ACQ FIFO: writes controlled by FSM
  input  logic                             acq_fifo_wvalid_i,
  output logic                             acq_fifo_wready_o,
  input  logic [ACQ_FIFO_WIDTH-1:0]        acq_fifo_wdata_i,
  // ACQ FIFO: reads controlled by CSR
  output logic                             acq_fifo_rvalid_o,
  input  logic                             acq_fifo_rready_i,
  output logic [ACQ_FIFO_WIDTH-1:0]        acq_fifo_rdata_o
);

  // RAM synthesis parameters
  localparam int unsigned RamDepth = 464;
  
  localparam int unsigned RamAw = prim_util_pkg::vbits(RamDepth);
  localparam int unsigned RamWidth = 13;
  

  // RAM address map
  localparam logic [RamAw-1:0] FmtFifoRamBaseAddr = RamAw'(0);
  localparam logic [RamAw-1:0] RxFifoRamBaseAddr  = RamAw'(1 * FifoDepth);
  localparam logic [RamAw-1:0] TxFifoRamBaseAddr  = RamAw'(2 * FifoDepth);
  localparam logic [RamAw-1:0] AcqFifoRamBaseAddr = RamAw'(3 * FifoDepth);

  // RAM read data, which is a common signal to all adapters
  logic [RamWidth-1:0] ram_rdata;

  // RAM adapter for FMT FIFO
  logic [RamWidth-1:0] fmt_fifo_wdata, fmt_fifo_rdata, fmt_ram_wdata;
  logic fmt_ram_req, fmt_ram_gnt, fmt_ram_write, fmt_ram_rvalid;
  logic [RamAw-1:0] fmt_ram_addr;
  i2c_fifo_sync_sram_adapter #(
    .Width       (RamWidth),
    .Depth       (FifoDepth),
    .SramAw      (RamAw),
    .SramBaseAddr(FmtFifoRamBaseAddr)
  ) u_fmt_fifo_sram_adapter (
    .clk_i,
    .rst_ni,
    .clr_i        (fmt_fifo_clr_i),
    .fifo_wvalid_i(fmt_fifo_wvalid_i),
    .fifo_wready_o(fmt_fifo_wready_o),
    .fifo_wdata_i (fmt_fifo_wdata),
    .fifo_rvalid_o(fmt_fifo_rvalid_o),
    .fifo_rready_i(fmt_fifo_rready_i),
    .fifo_rdata_o (fmt_fifo_rdata),
    .fifo_depth_o (fmt_fifo_depth_o),
    .sram_req_o   (fmt_ram_req),
    .sram_gnt_i   (fmt_ram_gnt),
    .sram_write_o (fmt_ram_write),
    .sram_addr_o  (fmt_ram_addr),
    .sram_wdata_o (fmt_ram_wdata),
    .sram_wmask_o (/* unused */),
    .sram_rdata_i (ram_rdata),
    .sram_rvalid_i(fmt_ram_rvalid),
    .err_o        (/* unused */)
  );
  assign fmt_fifo_wdata = fmt_fifo_wdata_i;
  assign fmt_fifo_rdata_o = fmt_fifo_rdata[FMT_FIFO_WIDTH-1:0];

  // RAM adapter for RX FIFO
  logic [RamWidth-1:0] rx_fifo_wdata, rx_fifo_rdata, rx_ram_wdata;
  logic rx_ram_req, rx_ram_gnt, rx_ram_write, rx_ram_rvalid;
  logic [RamAw-1:0] rx_ram_addr;
  i2c_fifo_sync_sram_adapter #(
    .Width       (RamWidth),
    .Depth       (FifoDepth),
    .SramAw      (RamAw),
    .SramBaseAddr(RxFifoRamBaseAddr)
  ) u_rx_fifo_sram_adapter (
    .clk_i,
    .rst_ni,
    .clr_i        (rx_fifo_clr_i),
    .fifo_wvalid_i(rx_fifo_wvalid_i),
    .fifo_wready_o(rx_fifo_wready_o),
    .fifo_wdata_i (rx_fifo_wdata),
    .fifo_rvalid_o(rx_fifo_rvalid_o),
    .fifo_rready_i(rx_fifo_rready_i),
    .fifo_rdata_o (rx_fifo_rdata),
    .fifo_depth_o (rx_fifo_depth_o),
    .sram_req_o   (rx_ram_req),
    .sram_gnt_i   (rx_ram_gnt),
    .sram_write_o (rx_ram_write),
    .sram_addr_o  (rx_ram_addr),
    .sram_wdata_o (rx_ram_wdata),
    .sram_wmask_o (/* unused */),
    .sram_rdata_i (ram_rdata),
    .sram_rvalid_i(rx_ram_rvalid),
    .err_o        (/* unused */)
  );
  assign rx_fifo_wdata = {{(RamWidth - RX_FIFO_WIDTH){1'b0}}, rx_fifo_wdata_i};
  assign rx_fifo_rdata_o = rx_fifo_rdata[RX_FIFO_WIDTH-1:0];
  logic unused_rx_fifo_rdata;
  assign unused_rx_fifo_rdata = ^rx_fifo_rdata[(RamWidth-1):(RX_FIFO_WIDTH-1)];

  // RAM adapter for TX FIFO
  logic [RamWidth-1:0] tx_fifo_wdata, tx_fifo_rdata, tx_ram_wdata;
  logic tx_ram_req, tx_ram_gnt, tx_ram_write, tx_ram_rvalid;
  logic [RamAw-1:0] tx_ram_addr;
  i2c_fifo_sync_sram_adapter #(
    .Width       (RamWidth),
    .Depth       (FifoDepth),
    .SramAw      (RamAw),
    .SramBaseAddr(TxFifoRamBaseAddr)
  ) u_tx_fifo_sram_adapter (
    .clk_i,
    .rst_ni,
    .clr_i        (tx_fifo_clr_i),
    .fifo_wvalid_i(tx_fifo_wvalid_i),
    .fifo_wready_o(tx_fifo_wready_o),
    .fifo_wdata_i (tx_fifo_wdata),
    .fifo_rvalid_o(tx_fifo_rvalid_o),
    .fifo_rready_i(tx_fifo_rready_i),
    .fifo_rdata_o (tx_fifo_rdata),
    .fifo_depth_o (tx_fifo_depth_o),
    .sram_req_o   (tx_ram_req),
    .sram_gnt_i   (tx_ram_gnt),
    .sram_write_o (tx_ram_write),
    .sram_addr_o  (tx_ram_addr),
    .sram_wdata_o (tx_ram_wdata),
    .sram_wmask_o (/* unused */),
    .sram_rdata_i (ram_rdata),
    .sram_rvalid_i(tx_ram_rvalid),
    .err_o        (/* unused */)
  );
  assign tx_fifo_wdata = {{(RamWidth - TX_FIFO_WIDTH){1'b0}}, tx_fifo_wdata_i};
  assign tx_fifo_rdata_o = tx_fifo_rdata[TX_FIFO_WIDTH-1:0];
  logic unused_tx_fifo_rdata;
  assign unused_tx_fifo_rdata = ^tx_fifo_rdata[(RamWidth-1):(TX_FIFO_WIDTH-1)];

  // RAM adapter for ACQ FIFO
  logic [RamWidth-1:0] acq_fifo_wdata, acq_fifo_rdata, acq_ram_wdata;
  logic acq_ram_req, acq_ram_gnt, acq_ram_write, acq_ram_rvalid;
  logic [RamAw-1:0] acq_ram_addr;
  i2c_fifo_sync_sram_adapter #(
    .Width       (RamWidth),
    .Depth       (AcqFifoDepth),
    .SramAw      (RamAw),
    .SramBaseAddr(AcqFifoRamBaseAddr)
  ) u_acq_fifo_sram_adapter (
    .clk_i,
    .rst_ni,
    .clr_i        (acq_fifo_clr_i),
    .fifo_wvalid_i(acq_fifo_wvalid_i),
    .fifo_wready_o(acq_fifo_wready_o),
    .fifo_wdata_i (acq_fifo_wdata),
    .fifo_rvalid_o(acq_fifo_rvalid_o),
    .fifo_rready_i(acq_fifo_rready_i),
    .fifo_rdata_o (acq_fifo_rdata),
    .fifo_depth_o (acq_fifo_depth_o),
    .sram_req_o   (acq_ram_req),
    .sram_gnt_i   (acq_ram_gnt),
    .sram_write_o (acq_ram_write),
    .sram_addr_o  (acq_ram_addr),
    .sram_wdata_o (acq_ram_wdata),
    .sram_wmask_o (/* unused */),
    .sram_rdata_i (ram_rdata),
    .sram_rvalid_i(acq_ram_rvalid),
    .err_o        (/* unused */)
  );
  assign acq_fifo_wdata = {{(RamWidth - ACQ_FIFO_WIDTH){1'b0}}, acq_fifo_wdata_i};
  assign acq_fifo_rdata_o = acq_fifo_rdata[ACQ_FIFO_WIDTH-1:0];
  logic unused_acq_fifo_rdata;
  assign unused_acq_fifo_rdata = ^acq_fifo_rdata[(RamWidth-1):(ACQ_FIFO_WIDTH-1)];

  // RAM signals
  logic                ram_req,
                       ram_write,
                       ram_rvalid;
  logic [RamAw-1:0]    ram_addr;
  logic [RamWidth-1:0] ram_wdata;

  // RAM arbiter
  localparam int unsigned RamArbN = 4;
  localparam int unsigned RamArbIdxW = prim_util_pkg::vbits(RamArbN);
  // Data for arbiter consists of write bit, address, and write data
  localparam int unsigned RamArbDw = 1 + RamAw + RamWidth;
  logic [RamArbN-1:0] ram_arb_req, ram_arb_gnt;
  logic [RamArbIdxW-1:0] ram_arb_idx;
  logic [RamArbDw-1:0] ram_arb_inp_data[RamArbN];
  logic [RamArbDw-1:0] ram_arb_oup_data;
  prim_arbiter_tree #(
    .N         (RamArbN),
    .DW        (RamArbDw),
    .EnDataPort(1)
  ) u_ram_arbiter (
    .clk_i,
    .rst_ni,
    .req_chk_i(1'b1),
    .req_i    (ram_arb_req),
    .data_i   (ram_arb_inp_data),
    .gnt_o    (ram_arb_gnt),
    .idx_o    (ram_arb_idx),
    .valid_o  (ram_req),
    .data_o   (ram_arb_oup_data),
    .ready_i  (1'b1)
  );
  assign ram_arb_req[0] = fmt_ram_req;
  assign ram_arb_inp_data[0] = {fmt_ram_write, fmt_ram_addr, fmt_ram_wdata};
  assign fmt_ram_gnt = ram_arb_gnt[0];
  assign ram_arb_req[1] = rx_ram_req;
  assign ram_arb_inp_data[1] = {rx_ram_write, rx_ram_addr, rx_ram_wdata};
  assign rx_ram_gnt = ram_arb_gnt[1];
  assign ram_arb_req[2] = tx_ram_req;
  assign ram_arb_inp_data[2] = {tx_ram_write, tx_ram_addr, tx_ram_wdata};
  assign tx_ram_gnt = ram_arb_gnt[2];
  assign ram_arb_req[3] = acq_ram_req;
  assign ram_arb_inp_data[3] = {acq_ram_write, acq_ram_addr, acq_ram_wdata};
  assign acq_ram_gnt = ram_arb_gnt[3];

  // Demux `ram_rvalid` based on arbiter index one cycle earlier.
  logic [RamArbIdxW-1:0] ram_arb_idx_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      ram_arb_idx_q <= '0;
    end else begin
      ram_arb_idx_q <= ram_arb_idx;
    end
  end
  assign fmt_ram_rvalid = (ram_arb_idx_q == unsigned'(RamArbIdxW'(0))) && ram_rvalid;
  assign rx_ram_rvalid  = (ram_arb_idx_q == unsigned'(RamArbIdxW'(1))) && ram_rvalid;
  assign tx_ram_rvalid  = (ram_arb_idx_q == unsigned'(RamArbIdxW'(2))) && ram_rvalid;
  assign acq_ram_rvalid = (ram_arb_idx_q == unsigned'(RamArbIdxW'(3))) && ram_rvalid;

  // RAM instance
  prim_ram_1p_adv #(
    .Depth               (RamDepth),
    .Width               (RamWidth),
    .DataBitsPerMask     (RamWidth),
    .EnableECC           (1'b0),
    .EnableParity        (1'b0),
    .EnableInputPipeline (1'b0),
    .EnableOutputPipeline(1'b0)
  ) u_ram_1p (
    .clk_i,
    .rst_ni,
    .req_i    (ram_req),
    .write_i  (ram_write),
    .addr_i   (ram_addr),
    .wdata_i  (ram_wdata),
    .wmask_i  ('1),
    .rdata_o  (ram_rdata),
    .rvalid_o (ram_rvalid),
    .rerror_o (/* unused */),
    .cfg_i    (ram_cfg_i),
    .cfg_rsp_o(ram_cfg_rsp_o),
    .alert_o  (/* unused */)
  );
  assign {ram_write, ram_addr, ram_wdata} = ram_arb_oup_data;

  // For the FMT, ACQ, and TX FIFOs, we assume that a write request stays stable until it has been
  // granted.  Put differently, we assume this module for those FIFOs will never see a write that
  // would be dropped (e.g., because the FIFO is full).  This does not hold for the RX FIFO, for
  // which `i2c_core` will register an overflow event if there is a wvalid without a wready.
  
  
  

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description: I2C core module

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module i2c_core import i2c_pkg::*;
#(
  parameter int unsigned InputDelayCycles = 0
) (
  input                                    clk_i,
  input                                    rst_ni,
  input  prim_ram_1p_pkg::ram_1p_cfg_t     ram_cfg_i,
  output prim_ram_1p_pkg::ram_1p_cfg_rsp_t ram_cfg_rsp_o,

  input i2c_reg_pkg::i2c_reg2hw_t          reg2hw,
  output i2c_reg_pkg::i2c_hw2reg_t         hw2reg,

  input                                    scl_i,
  output logic                             scl_o,
  input                                    sda_i,
  output logic                             sda_o,

  output logic                             lsio_trigger_o,

  output logic                             intr_fmt_threshold_o,
  output logic                             intr_rx_threshold_o,
  output logic                             intr_acq_threshold_o,
  output logic                             intr_rx_overflow_o,
  output logic                             intr_controller_halt_o,
  output logic                             intr_scl_interference_o,
  output logic                             intr_sda_interference_o,
  output logic                             intr_stretch_timeout_o,
  output logic                             intr_sda_unstable_o,
  output logic                             intr_cmd_complete_o,
  output logic                             intr_tx_stretch_o,
  output logic                             intr_tx_threshold_o,
  output logic                             intr_acq_stretch_o,
  output logic                             intr_unexp_stop_o,
  output logic                             intr_host_timeout_o
);

  import i2c_reg_pkg::FifoDepth;
  import i2c_reg_pkg::AcqFifoDepth;

  // Number of bits required to represent the FIFO level/depth.
  localparam int unsigned FifoDepthW = $clog2(FifoDepth + 1);
  localparam int unsigned AcqFifoDepthW = $clog2(AcqFifoDepth+1);

  // Maximum number of bits required to represent the level/depth of any FIFO.
  localparam int unsigned MaxFifoDepthW = 12;

  // Round-trip delay for outputs to appear on the inputs, not including rise
  // time. This is the input delay external to this IP, plus the output flop,
  // plus the 2-flop synchronizer on the input. The total value here
  // represents the minimum allowed high and low times for SCL.
  localparam int unsigned RoundTripCycles = InputDelayCycles + 2 + 1;

  logic [12:0] thigh;
  logic [12:0] tlow;
  logic [12:0] t_r;
  logic [12:0] t_f;
  logic [12:0] thd_sta;
  logic [12:0] tsu_sta;
  logic [12:0] tsu_sto;
  logic [12:0] tsu_dat;
  logic [12:0] thd_dat;
  logic [12:0] t_buf;
  logic [29:0] bus_active_timeout;
  logic        stretch_timeout_enable;
  logic        bus_timeout_enable;
  logic [19:0] host_timeout;
  logic [30:0] nack_timeout;
  logic        nack_timeout_en;
  logic [30:0] host_nack_handler_timeout;
  logic        host_nack_handler_timeout_en;

  logic scl_sync;
  logic sda_sync;
  logic scl_out_controller_fsm, sda_out_controller_fsm;
  logic scl_out_target_fsm, sda_out_target_fsm;
  logic scl_out_fsm;
  logic sda_out_fsm;
  logic controller_transmitting;
  logic target_transmitting;

  // bus_event_detect goes low after any drive change from this IP, and it
  // returns to high once enough time has passed for the output change to
  // reach the FSMs. This is used to qualify detection of unexpected bus events,
  // where some other I2C controller or target is driving SCL or SDA
  // simultaneously.
  logic bus_event_detect;
  logic [10:0] bus_event_detect_cnt;
  logic sda_released_but_low;
  logic controller_sda_interference;
  logic target_arbitration_lost;

  logic bus_free;
  logic start_detect;
  logic stop_detect;

  logic event_rx_overflow;
  logic status_controller_halt;
  logic event_nak;
  logic event_unhandled_nak_timeout;
  logic event_controller_arbitration_lost;
  logic event_scl_interference;
  logic event_sda_interference;
  logic event_bus_active_timeout;
  logic event_stretch_timeout;
  logic event_sda_unstable;
  logic event_read_cmd_received;
  logic event_cmd_complete;
  logic event_controller_cmd_complete, event_target_cmd_complete;
  logic event_target_nack;
  logic event_tx_arbitration_lost;
  logic event_tx_bus_timeout;
  logic event_tx_stretch;
  logic event_acq_stretch;
  logic event_unexp_stop;
  logic event_host_timeout;

  logic unhandled_unexp_nak;
  logic unhandled_tx_stretch_event;
  logic target_ack_ctrl_stretching;
  logic target_ack_ctrl_sw_nack;

  logic [15:0] scl_rx_val;
  logic [15:0] sda_rx_val;

  logic override;

  logic                      fmt_fifo_wvalid;
  logic                      fmt_fifo_wready;
  logic [FMT_FIFO_WIDTH-1:0] fmt_fifo_wdata;
  logic [FifoDepthW-1:0]     fmt_fifo_depth;
  logic                      fmt_fifo_rvalid;
  logic                      fmt_fifo_rready;
  logic [FMT_FIFO_WIDTH-1:0] fmt_fifo_rdata;
  logic [7:0]                fmt_byte;
  logic                      fmt_flag_start_before;
  logic                      fmt_flag_stop_after;
  logic                      fmt_flag_read_bytes;
  logic                      fmt_flag_read_continue;
  logic                      fmt_flag_nak_ok;

  logic                     i2c_fifo_rxrst;
  logic                     i2c_fifo_fmtrst;
  logic [MaxFifoDepthW-1:0] i2c_fifo_rx_thresh;
  logic [MaxFifoDepthW-1:0] i2c_fifo_fmt_thresh;

  logic                     rx_fifo_wvalid;
  logic                     rx_fifo_wready;
  logic [RX_FIFO_WIDTH-1:0] rx_fifo_wdata;
  logic [FifoDepthW-1:0]    rx_fifo_depth;
  logic                     rx_fifo_rvalid;
  logic                     rx_fifo_rready;
  logic [RX_FIFO_WIDTH-1:0] rx_fifo_rdata;

  // FMT FIFO level below programmed threshold?
  logic                     fmt_lt_threshold;
  // Rx FIFO level above programmed threshold?
  logic                     rx_gt_threshold;

  logic                     tx_fifo_wvalid;
  logic                     tx_fifo_wready;
  logic [TX_FIFO_WIDTH-1:0] tx_fifo_wdata;
  logic [FifoDepthW-1:0]    tx_fifo_depth;
  logic                     tx_fifo_rvalid;
  logic                     tx_fifo_rready;
  logic [TX_FIFO_WIDTH-1:0] tx_fifo_rdata;

  logic                      acq_fifo_wvalid;
  logic [ACQ_FIFO_WIDTH-1:0] acq_fifo_wdata;
  logic [AcqFifoDepthW-1:0]  acq_fifo_depth;
  logic                      acq_fifo_full;
  logic                      acq_fifo_rvalid;
  logic                      acq_fifo_rready;
  logic [ACQ_FIFO_WIDTH-1:0] acq_fifo_rdata;

  logic                     i2c_fifo_txrst;
  logic                     i2c_fifo_acqrst;
  logic [MaxFifoDepthW-1:0] i2c_fifo_tx_thresh;
  logic [MaxFifoDepthW-1:0] i2c_fifo_acq_thresh;

  // Tx FIFO level below programmed threshold?
  logic        tx_lt_threshold;
  // ACQ FIFO level above programmed threshold?
  logic        acq_gt_threshold;

  logic        host_idle;
  logic        target_idle;

  logic        host_enable;
  logic        target_enable;
  logic        line_loopback;
  logic        target_loopback;

  logic [6:0]  target_address0;
  logic [6:0]  target_mask0;
  logic [6:0]  target_address1;
  logic [6:0]  target_mask1;

  // Unused parts of exposed bits
  logic        unused_rx_thr_qe;
  logic        unused_fmt_thr_qe;
  logic        unused_tx_thr_qe;
  logic        unused_acq_thr_qe;
  logic [7:0]  unused_rx_fifo_rdata_q;
  logic [7:0]  unused_acq_fifo_adata_q;
  logic [ACQ_FIFO_WIDTH-9:0] unused_acq_fifo_signal_q;
  logic        unused_alert_test_qe;
  logic        unused_alert_test_q;

  assign hw2reg.status.fmtfull.d = ~fmt_fifo_wready;
  assign hw2reg.status.rxfull.d = ~rx_fifo_wready;
  assign hw2reg.status.fmtempty.d = ~fmt_fifo_rvalid;
  assign hw2reg.status.hostidle.d = host_idle;
  assign hw2reg.status.targetidle.d = target_idle;
  assign hw2reg.status.rxempty.d = ~rx_fifo_rvalid;
  assign hw2reg.status.ack_ctrl_stretch.d = target_ack_ctrl_stretching;

  assign hw2reg.rdata.d = rx_fifo_rdata;
  assign hw2reg.host_fifo_status.fmtlvl.d = MaxFifoDepthW'(fmt_fifo_depth);
  assign hw2reg.host_fifo_status.rxlvl.d = MaxFifoDepthW'(rx_fifo_depth);
  assign hw2reg.val.scl_rx.d = scl_rx_val;
  assign hw2reg.val.sda_rx.d = sda_rx_val;

  assign hw2reg.status.txfull.d = ~tx_fifo_wready;
  assign hw2reg.status.acqfull.d = acq_fifo_full;
  assign hw2reg.status.txempty.d = ~tx_fifo_rvalid;
  assign hw2reg.status.acqempty.d = ~acq_fifo_rvalid;
  assign hw2reg.target_fifo_status.txlvl.d = MaxFifoDepthW'(tx_fifo_depth);
  assign hw2reg.target_fifo_status.acqlvl.d = MaxFifoDepthW'(acq_fifo_depth);
  assign hw2reg.acqdata.abyte.d = acq_fifo_rdata[7:0];
  assign hw2reg.acqdata.signal.d = acq_fifo_rdata[ACQ_FIFO_WIDTH-1:8];

  // Add one to the target NACK count if this target has sent a NACK and if
  // counter has not saturated.
  assign hw2reg.target_nack_count.de = event_target_nack && (reg2hw.target_nack_count.q < 8'hFF);
  assign hw2reg.target_nack_count.d  = reg2hw.target_nack_count.q + 1;

  assign override = reg2hw.ovrd.txovrden;

  assign scl_o = override ? reg2hw.ovrd.sclval : scl_out_fsm;
  assign sda_o = override ? reg2hw.ovrd.sdaval : sda_out_fsm;

  assign host_enable = reg2hw.ctrl.enablehost.q;
  assign target_enable = reg2hw.ctrl.enabletarget.q;
  assign line_loopback = reg2hw.ctrl.llpbk.q;

  assign event_cmd_complete = event_controller_cmd_complete | event_target_cmd_complete;

  // Target loopback simply plays back whatever is received from the external host
  // back to it.
  assign target_loopback = target_enable & line_loopback;

  assign target_address0 = reg2hw.target_id.address0.q;
  assign target_mask0 = reg2hw.target_id.mask0.q;
  assign target_address1 = reg2hw.target_id.address1.q;
  assign target_mask1 = reg2hw.target_id.mask1.q;

  // Flop I2C bus outputs
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      scl_out_fsm <= 1'b1;
      sda_out_fsm <= 1'b1;
    end else begin
      // Drive 0 if any FSM requests it.
      scl_out_fsm <= scl_out_controller_fsm & scl_out_target_fsm;
      sda_out_fsm <= sda_out_controller_fsm & sda_out_target_fsm;
    end
  end

  // Sample scl_i and sda_i at system clock
  always_ff @ (posedge clk_i or negedge rst_ni) begin : rx_oversampling
    if(!rst_ni) begin
       scl_rx_val <= 16'h0;
       sda_rx_val <= 16'h0;
    end else begin
       scl_rx_val <= {scl_rx_val[14:0], scl_sync};
       sda_rx_val <= {sda_rx_val[14:0], sda_sync};
    end
  end

  assign thigh                        = reg2hw.timing0.thigh.q;
  assign tlow                         = reg2hw.timing0.tlow.q;
  assign t_r                          = 13'(reg2hw.timing1.t_r.q);
  assign t_f                          = 13'(reg2hw.timing1.t_f.q);
  assign tsu_sta                      = reg2hw.timing2.tsu_sta.q;
  assign thd_sta                      = reg2hw.timing2.thd_sta.q;
  assign tsu_dat                      = 13'(reg2hw.timing3.tsu_dat.q);
  assign thd_dat                      = reg2hw.timing3.thd_dat.q;
  assign tsu_sto                      = reg2hw.timing4.tsu_sto.q;
  assign t_buf                        = reg2hw.timing4.t_buf.q;
  assign bus_active_timeout           = reg2hw.timeout_ctrl.val.q;
  assign stretch_timeout_enable       = reg2hw.timeout_ctrl.en.q &&
                                        (reg2hw.timeout_ctrl.mode.q == StretchTimeoutMode);
  assign bus_timeout_enable           = reg2hw.timeout_ctrl.en.q &&
                                        (reg2hw.timeout_ctrl.mode.q == BusTimeoutMode);
  assign host_timeout                 = reg2hw.host_timeout_ctrl.q;
  assign nack_timeout                 = reg2hw.target_timeout_ctrl.val.q;
  assign nack_timeout_en              = reg2hw.target_timeout_ctrl.en.q;
  assign host_nack_handler_timeout    = reg2hw.host_nack_handler_timeout.val.q;
  assign host_nack_handler_timeout_en = reg2hw.host_nack_handler_timeout.en.q;
  assign target_ack_ctrl_sw_nack      = reg2hw.target_ack_ctrl.nack.qe &
                                        reg2hw.target_ack_ctrl.nack.q;

  assign i2c_fifo_rxrst      = reg2hw.fifo_ctrl.rxrst.q & reg2hw.fifo_ctrl.rxrst.qe;
  assign i2c_fifo_fmtrst     = reg2hw.fifo_ctrl.fmtrst.q & reg2hw.fifo_ctrl.fmtrst.qe;
  assign i2c_fifo_rx_thresh  = reg2hw.host_fifo_config.rx_thresh.q;
  assign i2c_fifo_fmt_thresh = reg2hw.host_fifo_config.fmt_thresh.q;

  assign i2c_fifo_txrst      = reg2hw.fifo_ctrl.txrst.q & reg2hw.fifo_ctrl.txrst.qe;
  assign i2c_fifo_acqrst     = reg2hw.fifo_ctrl.acqrst.q & reg2hw.fifo_ctrl.acqrst.qe;
  assign i2c_fifo_tx_thresh  = reg2hw.target_fifo_config.tx_thresh.q;
  assign i2c_fifo_acq_thresh = reg2hw.target_fifo_config.acq_thresh.q;

  // FMT FIFO level below programmed threshold?
  assign fmt_lt_threshold = (MaxFifoDepthW'(fmt_fifo_depth) < i2c_fifo_fmt_thresh);
  // Rx FIFO level above programmed threshold?
  assign rx_gt_threshold  = (MaxFifoDepthW'(rx_fifo_depth)  > i2c_fifo_rx_thresh);
  // Tx FIFO level below programmed threshold?
  assign tx_lt_threshold  = (MaxFifoDepthW'(tx_fifo_depth)  < i2c_fifo_tx_thresh);
  // ACQ FIFO level above programmed threshold?
  assign acq_gt_threshold = (MaxFifoDepthW'(acq_fifo_depth) > i2c_fifo_acq_thresh);

  assign lsio_trigger_o    = rx_gt_threshold;
  assign event_rx_overflow = rx_fifo_wvalid & ~rx_fifo_wready;
  assign event_acq_stretch = acq_fifo_full || target_ack_ctrl_stretching;

  // The fifo write enable is controlled by fbyte, start, stop, read, rcont,
  // and nakok field qe bits.
  // When all qe bits are asserted, fdata is injected into the fifo.
  assign fmt_fifo_wvalid     = reg2hw.fdata.fbyte.qe &
                               reg2hw.fdata.start.qe &
                               reg2hw.fdata.stop.qe  &
                               reg2hw.fdata.readb.qe  &
                               reg2hw.fdata.rcont.qe &
                               reg2hw.fdata.nakok.qe;
  assign fmt_fifo_wdata[7:0] = reg2hw.fdata.fbyte.q;
  assign fmt_fifo_wdata[8]   = reg2hw.fdata.start.q;
  assign fmt_fifo_wdata[9]   = reg2hw.fdata.stop.q;
  assign fmt_fifo_wdata[10]  = reg2hw.fdata.readb.q;
  assign fmt_fifo_wdata[11]  = reg2hw.fdata.rcont.q;
  assign fmt_fifo_wdata[12]  = reg2hw.fdata.nakok.q;

  assign fmt_byte               = fmt_fifo_rvalid ? fmt_fifo_rdata[7:0] : '0;
  assign fmt_flag_start_before  = fmt_fifo_rvalid ? fmt_fifo_rdata[8] : '0;
  assign fmt_flag_stop_after    = fmt_fifo_rvalid ? fmt_fifo_rdata[9] : '0;
  assign fmt_flag_read_bytes    = fmt_fifo_rvalid ? fmt_fifo_rdata[10] : '0;
  assign fmt_flag_read_continue = fmt_fifo_rvalid ? fmt_fifo_rdata[11] : '0;
  assign fmt_flag_nak_ok        = fmt_fifo_rvalid ? fmt_fifo_rdata[12] : '0;

  // Operating this HWIP as a controller-transmitter, the addressed Target device
  // may NACK our bytes. In Byte-Formatted Programming Mode, each FDATA format indicator
  // can set the 'NAKOK' bit to ignore the Target's NACK and proceed to the next item in
  // the FMTFIFO. If 'NAKOK' is not set, the 'controller_halt' interrupt is asserted, and the FSM
  // halts until software intervenes. In addition, the 'controller_events.nack' status bit is set.
  // To acknowledge the 'NACK', software should clear the status bit by writing 1 to it in the
  // CONTROLLER_EVENTS register.
  assign unhandled_unexp_nak = reg2hw.controller_events.nack.q;

  assign unused_rx_thr_qe  = reg2hw.host_fifo_config.rx_thresh.qe;
  assign unused_fmt_thr_qe = reg2hw.host_fifo_config.fmt_thresh.qe;
  assign unused_tx_thr_qe  = reg2hw.target_fifo_config.tx_thresh.qe;
  assign unused_acq_thr_qe = reg2hw.target_fifo_config.acq_thresh.qe;
  assign unused_rx_fifo_rdata_q = reg2hw.rdata.q;
  assign unused_acq_fifo_adata_q = reg2hw.acqdata.abyte.q;
  assign unused_acq_fifo_signal_q = reg2hw.acqdata.signal.q;
  assign unused_alert_test_qe = reg2hw.alert_test.qe;
  assign unused_alert_test_q = reg2hw.alert_test.q;

  i2c_fifos u_fifos (
    .clk_i,
    .rst_ni,
    .ram_cfg_i,
    .ram_cfg_rsp_o,

    .fmt_fifo_clr_i   (i2c_fifo_fmtrst),
    .fmt_fifo_depth_o (fmt_fifo_depth),
    .fmt_fifo_wvalid_i(fmt_fifo_wvalid),
    .fmt_fifo_wready_o(fmt_fifo_wready),
    .fmt_fifo_wdata_i (fmt_fifo_wdata),
    .fmt_fifo_rvalid_o(fmt_fifo_rvalid),
    .fmt_fifo_rready_i(fmt_fifo_rready),
    .fmt_fifo_rdata_o (fmt_fifo_rdata),

    .rx_fifo_clr_i   (i2c_fifo_rxrst),
    .rx_fifo_depth_o (rx_fifo_depth),
    .rx_fifo_wvalid_i(rx_fifo_wvalid),
    .rx_fifo_wready_o(rx_fifo_wready),
    .rx_fifo_wdata_i (rx_fifo_wdata),
    .rx_fifo_rvalid_o(rx_fifo_rvalid),
    .rx_fifo_rready_i(rx_fifo_rready),
    .rx_fifo_rdata_o (rx_fifo_rdata),

    .tx_fifo_clr_i   (i2c_fifo_txrst),
    .tx_fifo_depth_o (tx_fifo_depth),
    .tx_fifo_wvalid_i(tx_fifo_wvalid),
    .tx_fifo_wready_o(tx_fifo_wready),
    .tx_fifo_wdata_i (tx_fifo_wdata),
    .tx_fifo_rvalid_o(tx_fifo_rvalid),
    .tx_fifo_rready_i(tx_fifo_rready),
    .tx_fifo_rdata_o (tx_fifo_rdata),

    .acq_fifo_clr_i   (i2c_fifo_acqrst),
    .acq_fifo_depth_o (acq_fifo_depth),
    .acq_fifo_wvalid_i(acq_fifo_wvalid),
    .acq_fifo_wready_o(),
    .acq_fifo_wdata_i (acq_fifo_wdata),
    .acq_fifo_rvalid_o(acq_fifo_rvalid),
    .acq_fifo_rready_i(acq_fifo_rready),
    .acq_fifo_rdata_o (acq_fifo_rdata)
  );

  assign rx_fifo_rready = reg2hw.rdata.re;

  // Need to add a valid qualification to write only payload bytes
  logic valid_target_lb_wr;
  i2c_acq_byte_id_e acq_type;
  assign acq_type = i2c_acq_byte_id_e'(acq_fifo_rdata[ACQ_FIFO_WIDTH-1:8]);

  assign valid_target_lb_wr = target_enable & (acq_type == AcqData);

  // only write into tx fifo if it's payload
  assign tx_fifo_wvalid = target_loopback ? acq_fifo_rvalid & valid_target_lb_wr : reg2hw.txdata.qe;
  assign tx_fifo_wdata  = target_loopback ? acq_fifo_rdata[7:0] : reg2hw.txdata.q;

  // During line loopback, pop from acquisition fifo only when there is space in
  // the tx_fifo.  We are also allowed to pop even if there is no space if th acq entry
  // is not data payload.
  assign acq_fifo_rready = (reg2hw.acqdata.abyte.re & reg2hw.acqdata.signal.re) |
                           (target_loopback & (tx_fifo_wready | (acq_type != AcqData)));

  // sync the incoming SCL and SDA signals
  prim_flop_2sync #(
    .Width(1),
    .ResetValue(1'b1)
  ) u_i2c_sync_scl (
    .clk_i,
    .rst_ni,
    .d_i (scl_i),
    .q_o (scl_sync)
  );

  prim_flop_2sync #(
    .Width(1),
    .ResetValue(1'b1)
  ) u_i2c_sync_sda (
    .clk_i,
    .rst_ni,
    .d_i (sda_i),
    .q_o (sda_sync)
  );

  // Various bus collision events are detected while SCL is high.
  logic sda_fsm, sda_fsm_q;
  logic scl_fsm, scl_fsm_q;
  assign sda_fsm = sda_out_controller_fsm & sda_out_target_fsm;
  assign scl_fsm = scl_out_controller_fsm & scl_out_target_fsm;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      sda_fsm_q <= 1'b1;
      scl_fsm_q <= 1'b1;
    end else begin
      sda_fsm_q <= sda_fsm;
      scl_fsm_q <= scl_fsm;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      bus_event_detect_cnt <= '1;
    end else if ((scl_fsm != scl_fsm_q) || (sda_fsm != sda_fsm_q)) begin
      // Wait for the round-trip time on SCL changes or on SDA changes. The
      // latter handles Start and Stop conditions, so changes while SCL is high
      // are allowed to propagate. The rise time is used here because it
      // should be the longer value. The (-1) term here is to account for the
      // delay in the counter.
      // Note that there are limits to this method of detecting arbitration.
      // A separate, buggy device that drives clock low faster than the counter
      // can expire would not trigger loss of arbitration.
      bus_event_detect_cnt <= reg2hw.timing1.t_r.q + 10'(RoundTripCycles - 1);
    end else if (bus_event_detect_cnt != '0) begin
      bus_event_detect_cnt <= bus_event_detect_cnt - 1'b1;
    end
  end
  assign bus_event_detect = (bus_event_detect_cnt == '0);
  assign sda_released_but_low = bus_event_detect && scl_sync && (sda_fsm_q != sda_sync);
  // What about unexpected start / stop on the bits that are read?
  assign controller_sda_interference = controller_transmitting && sda_released_but_low;
  assign target_arbitration_lost = target_transmitting && sda_released_but_low;

  assign event_sda_interference = controller_sda_interference;

  // The bus monitor detects starts, stops, and bus timeouts. It also reports
  // when the bus is free for the controller to transmit.
  i2c_bus_monitor u_i2c_bus_monitor (
    .clk_i,
    .rst_ni,

    .scl_i                          (scl_sync),
    .sda_i                          (sda_sync),

    .controller_enable_i            (host_enable),
    .multi_controller_enable_i      (reg2hw.ctrl.multi_controller_monitor_en.q),
    .target_enable_i                (target_enable),
    .target_idle_i                  (target_idle),
    .thd_dat_i                      (thd_dat),
    .t_buf_i                        (t_buf),
    .bus_active_timeout_i           (bus_active_timeout),
    .bus_active_timeout_en_i        (bus_timeout_enable),
    .bus_inactive_timeout_i         (host_timeout),

    .bus_free_o                     (bus_free),
    .start_detect_o                 (start_detect),
    .stop_detect_o                  (stop_detect),

    .event_bus_active_timeout_o     (event_bus_active_timeout),
    .event_host_timeout_o           (event_host_timeout)
  );

  i2c_controller_fsm #(
    .FifoDepth(FifoDepth)
  ) u_i2c_controller_fsm (
    .clk_i,
    .rst_ni,

    .scl_i                          (scl_sync),
    .scl_o                          (scl_out_controller_fsm),
    .sda_i                          (sda_sync),
    .sda_o                          (sda_out_controller_fsm),
    .bus_free_i                     (bus_free),
    .transmitting_o                 (controller_transmitting),

    .host_enable_i                  (host_enable),
    .halt_controller_i              (status_controller_halt),

    .fmt_fifo_rvalid_i       (fmt_fifo_rvalid),
    .fmt_fifo_depth_i        (fmt_fifo_depth),
    .fmt_fifo_rready_o       (fmt_fifo_rready),

    .fmt_byte_i                     (fmt_byte),
    .fmt_flag_start_before_i        (fmt_flag_start_before),
    .fmt_flag_stop_after_i          (fmt_flag_stop_after),
    .fmt_flag_read_bytes_i          (fmt_flag_read_bytes),
    .fmt_flag_read_continue_i       (fmt_flag_read_continue),
    .fmt_flag_nak_ok_i              (fmt_flag_nak_ok),
    .unhandled_unexp_nak_i          (unhandled_unexp_nak),
    .unhandled_nak_timeout_i        (reg2hw.controller_events.unhandled_nack_timeout.q),

    .rx_fifo_wvalid_o               (rx_fifo_wvalid),
    .rx_fifo_wdata_o                (rx_fifo_wdata),

    .host_idle_o                    (host_idle),

    .thigh_i                        (thigh),
    .tlow_i                         (tlow),
    .t_r_i                          (t_r),
    .t_f_i                          (t_f),
    .thd_sta_i                      (thd_sta),
    .tsu_sta_i                      (tsu_sta),
    .tsu_sto_i                      (tsu_sto),
    .thd_dat_i                      (thd_dat),
    .sda_interference_i             (controller_sda_interference),
    .stretch_timeout_i              (bus_active_timeout),
    .timeout_enable_i               (stretch_timeout_enable),
    .host_nack_handler_timeout_i    (host_nack_handler_timeout),
    .host_nack_handler_timeout_en_i (host_nack_handler_timeout_en),
    .event_nak_o                    (event_nak),
    .event_unhandled_nak_timeout_o  (event_unhandled_nak_timeout),
    .event_arbitration_lost_o       (event_controller_arbitration_lost),
    .event_scl_interference_o       (event_scl_interference),
    .event_stretch_timeout_o        (event_stretch_timeout),
    .event_sda_unstable_o           (event_sda_unstable),
    .event_cmd_complete_o           (event_controller_cmd_complete)
  );

  i2c_target_fsm #(
    .AcqFifoDepth(AcqFifoDepth)
  ) u_i2c_target_fsm (
    .clk_i,
    .rst_ni,

    .scl_i                          (scl_sync),
    .scl_o                          (scl_out_target_fsm),
    .sda_i                          (sda_sync),
    .sda_o                          (sda_out_target_fsm),
    .start_detect_i                 (start_detect),
    .stop_detect_i                  (stop_detect),
    .transmitting_o                 (target_transmitting),

    .target_enable_i                (target_enable),

    .tx_fifo_rvalid_i        (tx_fifo_rvalid),
    .tx_fifo_rready_o        (tx_fifo_rready),
    .tx_fifo_rdata_i         (tx_fifo_rdata),

    .acq_fifo_wvalid_o              (acq_fifo_wvalid),
    .acq_fifo_wdata_o               (acq_fifo_wdata),
    .acq_fifo_rdata_i               (acq_fifo_rdata),
    .acq_fifo_full_o                (acq_fifo_full),
    .acq_fifo_depth_i               (acq_fifo_depth),

    .target_idle_o                  (target_idle),

    .t_r_i                          (t_r),
    .tsu_dat_i                      (tsu_dat),
    .thd_dat_i                      (thd_dat),
    .nack_timeout_i                 (nack_timeout),
    .nack_timeout_en_i              (nack_timeout_en),
    .nack_addr_after_timeout_i      (reg2hw.ctrl.nack_addr_after_timeout.q),
    .arbitration_lost_i             (target_arbitration_lost),
    .bus_timeout_i                  (event_bus_active_timeout),
    .unhandled_tx_stretch_event_i   (unhandled_tx_stretch_event),
    .ack_ctrl_mode_i                (reg2hw.ctrl.ack_ctrl_en.q),
    .auto_ack_cnt_o                 (hw2reg.target_ack_ctrl.nbytes.d),
    .auto_ack_load_i                (reg2hw.target_ack_ctrl.nbytes.qe),
    .auto_ack_load_value_i          (reg2hw.target_ack_ctrl.nbytes.q),
    .sw_nack_i                      (target_ack_ctrl_sw_nack),
    .ack_ctrl_stretching_o          (target_ack_ctrl_stretching),
    .acq_fifo_next_data_o           (hw2reg.acq_fifo_next_data.d),
    .target_address0_i              (target_address0),
    .target_mask0_i                 (target_mask0),
    .target_address1_i              (target_address1),
    .target_mask1_i                 (target_mask1),
    .event_target_nack_o            (event_target_nack),
    .event_read_cmd_received_o      (event_read_cmd_received),
    .event_cmd_complete_o           (event_target_cmd_complete),
    .event_tx_stretch_o             (event_tx_stretch),
    .event_unexp_stop_o             (event_unexp_stop),
    .event_tx_arbitration_lost_o    (event_tx_arbitration_lost),
    .event_tx_bus_timeout_o         (event_tx_bus_timeout)
  );

  prim_intr_hw #(
    .Width(1),
    .IntrT("Status")
  ) intr_hw_fmt_threshold (
    .clk_i,
    .rst_ni,
    .event_intr_i           (fmt_lt_threshold),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.fmt_threshold.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.fmt_threshold.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.fmt_threshold.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.fmt_threshold.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.fmt_threshold.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.fmt_threshold.d),
    .intr_o                 (intr_fmt_threshold_o)
  );

  prim_intr_hw #(
    .Width(1),
    .IntrT("Status")
  ) intr_hw_rx_threshold (
    .clk_i,
    .rst_ni,
    .event_intr_i           (rx_gt_threshold),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.rx_threshold.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.rx_threshold.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.rx_threshold.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.rx_threshold.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.rx_threshold.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.rx_threshold.d),
    .intr_o                 (intr_rx_threshold_o)
  );

  prim_intr_hw #(
    .Width(1),
    .IntrT("Status")
  ) intr_hw_acq_threshold (
    .clk_i,
    .rst_ni,
    .event_intr_i           (acq_gt_threshold),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.acq_threshold.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.acq_threshold.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.acq_threshold.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.acq_threshold.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.acq_threshold.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.acq_threshold.d),
    .intr_o                 (intr_acq_threshold_o)
  );

  prim_intr_hw #(.Width(1)) intr_hw_rx_overflow (
    .clk_i,
    .rst_ni,
    .event_intr_i           (event_rx_overflow),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.rx_overflow.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.rx_overflow.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.rx_overflow.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.rx_overflow.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.rx_overflow.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.rx_overflow.d),
    .intr_o                 (intr_rx_overflow_o)
  );

  prim_intr_hw #(
    .Width(1),
    .IntrT("Status")
  ) intr_hw_controller_halt (
    .clk_i,
    .rst_ni,
    .event_intr_i           (status_controller_halt),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.controller_halt.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.controller_halt.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.controller_halt.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.controller_halt.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.controller_halt.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.controller_halt.d),
    .intr_o                 (intr_controller_halt_o)
  );

  prim_intr_hw #(.Width(1)) intr_hw_scl_interference (
    .clk_i,
    .rst_ni,
    .event_intr_i           (event_scl_interference),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.scl_interference.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.scl_interference.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.scl_interference.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.scl_interference.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.scl_interference.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.scl_interference.d),
    .intr_o                 (intr_scl_interference_o)
  );

  prim_intr_hw #(.Width(1)) intr_hw_sda_interference (
    .clk_i,
    .rst_ni,
    .event_intr_i           (event_sda_interference),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.sda_interference.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.sda_interference.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.sda_interference.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.sda_interference.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.sda_interference.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.sda_interference.d),
    .intr_o                 (intr_sda_interference_o)
  );

  prim_intr_hw #(.Width(1)) intr_hw_stretch_timeout (
    .clk_i,
    .rst_ni,
    .event_intr_i           (event_stretch_timeout),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.stretch_timeout.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.stretch_timeout.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.stretch_timeout.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.stretch_timeout.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.stretch_timeout.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.stretch_timeout.d),
    .intr_o                 (intr_stretch_timeout_o)
  );

  prim_intr_hw #(.Width(1)) intr_hw_sda_unstable (
    .clk_i,
    .rst_ni,
    .event_intr_i           (event_sda_unstable),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.sda_unstable.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.sda_unstable.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.sda_unstable.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.sda_unstable.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.sda_unstable.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.sda_unstable.d),
    .intr_o                 (intr_sda_unstable_o)
  );

  prim_intr_hw #(.Width(1)) intr_hw_cmd_complete (
    .clk_i,
    .rst_ni,
    .event_intr_i           (event_cmd_complete),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.cmd_complete.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.cmd_complete.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.cmd_complete.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.cmd_complete.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.cmd_complete.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.cmd_complete.d),
    .intr_o                 (intr_cmd_complete_o)
  );

  prim_intr_hw #(
    .Width(1),
    .IntrT("Status")
  ) intr_hw_tx_stretch (
    .clk_i,
    .rst_ni,
    .event_intr_i           (event_tx_stretch),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.tx_stretch.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.tx_stretch.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.tx_stretch.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.tx_stretch.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.tx_stretch.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.tx_stretch.d),
    .intr_o                 (intr_tx_stretch_o)
  );

  prim_intr_hw #(
    .Width(1),
    .IntrT("Status")
  ) intr_hw_tx_threshold (
    .clk_i,
    .rst_ni,
    .event_intr_i           (tx_lt_threshold),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.tx_threshold.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.tx_threshold.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.tx_threshold.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.tx_threshold.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.tx_threshold.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.tx_threshold.d),
    .intr_o                 (intr_tx_threshold_o)
  );

  prim_intr_hw #(
    .Width(1),
    .IntrT("Status")
  ) intr_hw_acq_overflow (
    .clk_i,
    .rst_ni,
    .event_intr_i           (event_acq_stretch),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.acq_stretch.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.acq_stretch.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.acq_stretch.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.acq_stretch.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.acq_stretch.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.acq_stretch.d),
    .intr_o                 (intr_acq_stretch_o)
  );

  prim_intr_hw #(.Width(1)) intr_hw_unexp_stop (
    .clk_i,
    .rst_ni,
    .event_intr_i           (event_unexp_stop),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.unexp_stop.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.unexp_stop.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.unexp_stop.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.unexp_stop.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.unexp_stop.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.unexp_stop.d),
    .intr_o                 (intr_unexp_stop_o)
  );

  prim_intr_hw #(.Width(1)) intr_hw_host_timeout (
    .clk_i,
    .rst_ni,
    .event_intr_i           (event_host_timeout),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.host_timeout.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.host_timeout.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.host_timeout.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.host_timeout.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.host_timeout.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.host_timeout.d),
    .intr_o                 (intr_host_timeout_o)
  );

  assign hw2reg.controller_events.nack.d  = 1'b1;
  assign hw2reg.controller_events.nack.de = event_nak;
  assign hw2reg.controller_events.unhandled_nack_timeout.d  = 1'b1;
  assign hw2reg.controller_events.unhandled_nack_timeout.de = event_unhandled_nak_timeout;
  assign hw2reg.controller_events.bus_timeout.d  = 1'b1;
  assign hw2reg.controller_events.bus_timeout.de = event_bus_active_timeout && !host_idle;
  assign hw2reg.controller_events.arbitration_lost.d  = 1'b1;
  assign hw2reg.controller_events.arbitration_lost.de = event_controller_arbitration_lost;
  assign status_controller_halt = | {
    reg2hw.controller_events.nack.q,
    reg2hw.controller_events.unhandled_nack_timeout.q,
    reg2hw.controller_events.bus_timeout.q,
    reg2hw.controller_events.arbitration_lost.q
  };

  assign hw2reg.target_events.tx_pending.d  = 1'b1;
  assign hw2reg.target_events.tx_pending.de = event_read_cmd_received &&
                                              reg2hw.ctrl.tx_stretch_ctrl_en.q;
  assign hw2reg.target_events.bus_timeout.d  = 1'b1;
  assign hw2reg.target_events.bus_timeout.de = event_tx_bus_timeout;
  assign hw2reg.target_events.arbitration_lost.d  = 1'b1;
  assign hw2reg.target_events.arbitration_lost.de = event_tx_arbitration_lost;
  assign unhandled_tx_stretch_event = | {
    reg2hw.target_events.tx_pending.q,
    reg2hw.target_events.bus_timeout.q,
    reg2hw.target_events.arbitration_lost.q
  };

  ////////////////
  // ASSERTIONS //
  ////////////////

  
  

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description: I2C bus idle and timeout monitoring, plus Start/Stop
// detection.

module i2c_bus_monitor import i2c_pkg::*;
(
  input                            clk_i,
  input                            rst_ni,

  input                            scl_i,
  input                            sda_i,

  input                            controller_enable_i,
  input                            multi_controller_enable_i,
  input                            target_enable_i,
  input                            target_idle_i,
  input [12:0]                     thd_dat_i,              // Data hold time(< 200 ns, < thd_sta)
  input [12:0]                     t_buf_i,                // Bus free time (< 5 us)
  input [29:0]                     bus_active_timeout_i,   // SCL held low  (~25 ms)
  input                            bus_active_timeout_en_i,
  input [19:0]                     bus_inactive_timeout_i, // SCL held high (~50 us)

  output logic                     bus_free_o,
  output                           start_detect_o,
  output                           stop_detect_o,

  output                           event_bus_active_timeout_o,
  output                           event_host_timeout_o

);

  // Only activate this monitor if at least one of the modules is enabled.
  logic monitor_enable, monitor_enable_q;
  assign monitor_enable = controller_enable_i | target_enable_i | multi_controller_enable_i;

  always_ff @ (posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      monitor_enable_q <= 1'b0;
    end else begin
      monitor_enable_q <= monitor_enable;
    end
  end

  // SDA and SCL at the previous clock edge
  logic scl_i_q, sda_i_q;
  always_ff @ (posedge clk_i or negedge rst_ni) begin : bus_prev
    if (!rst_ni) begin
      scl_i_q <= 1'b1;
      sda_i_q <= 1'b1;
    end else begin
      scl_i_q <= scl_i;
      sda_i_q <= sda_i;
    end
  end

  // Start and Stop detection
  //
  // To resolve ambiguity with early SDA arrival, reject control symbols when
  // SCL goes low too soon. The hold time for ordinary data/ACK bits is too
  // short to reliably see SCL change before SDA. Use the hold time for
  // control signals to ensure a Start or Stop symbol was actually received.
  // Requirements: thd_dat + 1 < thd_sta
  //   The extra (+1) here is to account for a late SDA arrival due to CDC
  //   skew.
  //
  // Note that this counter combines Start and Stop detection into one
  // counter. A controller-only reset scenario could end up with a Stop
  // following shortly after a Start, with the requisite setup time not
  // observed.
  logic        start_det_trigger, start_det_pending;
  logic        start_det;     // indicates start or repeated start is detected on the bus
  logic        stop_det_trigger, stop_det_pending;
  logic        stop_det;      // indicates stop is detected on the bus

  // Stop / Start detection counter
  logic [13:0] ctrl_det_count;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      ctrl_det_count <= '0;
    end else if (start_det_trigger || stop_det_trigger) begin
      ctrl_det_count <= 14'd1;
    end else if (start_det_pending || stop_det_pending) begin
      ctrl_det_count <= ctrl_det_count + 1'b1;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      start_det_pending <= 1'b0;
    end else if (start_det_trigger) begin
      start_det_pending <= 1'b1;
    end else if (!monitor_enable || !scl_i || start_det || stop_det_trigger) begin
      start_det_pending <= 1'b0;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      stop_det_pending <= 1'b0;
    end else if (stop_det_trigger) begin
      stop_det_pending <= 1'b1;
    end else if (!monitor_enable || !scl_i || stop_det || start_det_trigger) begin
      stop_det_pending <= 1'b0;
    end
  end

  // (Repeated) Start condition detection by target
  assign start_det_trigger = monitor_enable && (scl_i_q && scl_i) & (sda_i_q && !sda_i);
  assign start_det = monitor_enable && start_det_pending && (ctrl_det_count >= 14'(thd_dat_i));
  assign start_detect_o = start_det;

  // Stop condition detection by target
  assign stop_det_trigger = monitor_enable && (scl_i_q && scl_i) & (!sda_i_q && sda_i);
  assign stop_det = monitor_enable && stop_det_pending && (ctrl_det_count >= 14'(thd_dat_i));
  assign stop_detect_o = stop_det;

  //
  // Bus timeout logic
  //

  // Detection of bus in a released state.
  logic bus_idling;
  assign bus_idling = scl_i && (sda_i == sda_i_q);

  logic [29:0] bus_release_cnt, bus_release_cnt_sel;
  logic bus_release_cnt_load, bus_release_cnt_dec;

  // bus_inactive_timeout_det is only high for the case where the bus release
  // counter reaches zero for bus idling, not the wait after a Stop condition.
  logic bus_inactive_timeout_det;

  logic bus_inactive_timeout_en;
  assign bus_inactive_timeout_en = (bus_inactive_timeout_i > '0);

  // bus_active_timeout latches high when SCL has been held low for too long.
  // This can be done intentionally or unintentionally, as the response for
  // target devices should be to abort the current transaction and release any
  // hold on the bus. Note that the bus doesn't immediately transition to
  // "free" status, since the controller can continue holding SCL low for some
  // time.
  logic bus_active_timeout_det_d, bus_active_timeout_det_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      bus_active_timeout_det_q <= 1'b0;
    end else begin
      bus_active_timeout_det_q <= bus_active_timeout_det_d;
    end
  end

  // Bus release counter.
  // Together with the FSM below, this counter detects bus timeouts and the end
  // of the bus free time following a Stop condition.
  always_ff @ (posedge clk_i or negedge rst_ni) begin : bus_idle
    if (!rst_ni) begin
      bus_release_cnt <= '0;
    end else if (monitor_enable && !monitor_enable_q) begin
      // The rising edge of monitor enable resets the counter for
      // multi-controller mode.
      if (multi_controller_enable_i) begin
        // For the multi-controller case, wait until the bus isn't busy before
        // transmitting.
        bus_release_cnt <= 30'(bus_inactive_timeout_i);
      end
    end else if (bus_release_cnt_load) begin
      bus_release_cnt <= bus_release_cnt_sel;
    end else if (bus_release_cnt_dec && (bus_release_cnt != '0)) begin
      bus_release_cnt <= bus_release_cnt - 1'b1;
    end
  end

  typedef enum logic [1:0] {
    // Bus is currently free. Can transmit.
    StBusFree,
    // Bus is busy and not held with SCL high.
    StBusBusyLow,
    // Bus is currently busy, but SCL is held high.
    StBusBusyHigh,
    // Bus is currently busy, but saw a Stop. Count down to Bus Free.
    StBusBusyStop
  } bus_state_e;

  bus_state_e state_q, state_d;

  always_comb begin
    state_d = state_q;
    bus_release_cnt_load = 1'b0;
    bus_release_cnt_sel = 30'(t_buf_i);
    bus_release_cnt_dec = 1'b0;
    bus_inactive_timeout_det = 1'b0;
    bus_active_timeout_det_d = bus_active_timeout_det_q;

    unique case (state_q)
      StBusFree: begin
        bus_active_timeout_det_d = 1'b0;

        if (!scl_i || !sda_i) begin
          state_d = StBusBusyLow;
          bus_release_cnt_load = 1'b1;
          bus_release_cnt_sel = bus_active_timeout_i;
        end
      end

      StBusBusyLow: begin
        bus_release_cnt_dec = !scl_i;

        if (stop_det) begin
          state_d = StBusBusyStop;
          bus_release_cnt_load = 1'b1;
          bus_release_cnt_sel = 30'(t_buf_i);
        end else if (bus_idling && bus_inactive_timeout_en) begin
          state_d = StBusBusyHigh;
          bus_release_cnt_load = 1'b1;
          bus_release_cnt_sel = 30'(bus_inactive_timeout_i);
        end else if (scl_i) begin
          bus_release_cnt_load = 1'b1;
          bus_release_cnt_sel = bus_active_timeout_i;
          if (bus_active_timeout_det_q) begin
            // SCL was released due to the bus timeout, so go to BusFree.
            state_d = StBusFree;
          end
        end else if (bus_release_cnt == 30'd1) begin
          // The active timeout occurs when SCL has been held continuously low
          // for too long. Both the controller and target should respond to
          // this timeout and release the bus. We don't consider the bus free
          // yet, though: SCL must be released first.
          bus_active_timeout_det_d = bus_active_timeout_en_i;
        end
      end

      StBusBusyHigh: begin
        bus_release_cnt_dec = 1'b1;

        if (stop_det) begin
          state_d = StBusBusyStop;
          bus_release_cnt_load = 1'b1;
          bus_release_cnt_sel = 30'(t_buf_i);
        end else if (!bus_idling) begin
          state_d = StBusBusyLow;
          bus_release_cnt_load = 1'b1;
          bus_release_cnt_sel = bus_active_timeout_i;
        end else if (bus_release_cnt == 30'd1) begin
          // The host_timeout interrupt occurs regardless of which value of
          // SDA was present, but only transition to StBusFree if we entered
          // this state with SDA high. If SDA is low, a change to SCL will
          // cause a transition back to StBusBusyLow. If SDA changes from low
          // to high, we get a Stop condition and transition to StBusBusyStop.
          bus_inactive_timeout_det = bus_inactive_timeout_en;
          if (sda_i) begin
            state_d = StBusFree;
          end
        end
      end

      StBusBusyStop: begin
        bus_release_cnt_dec = 1'b1;

        if (!scl_i || !sda_i) begin
          state_d = StBusBusyLow;
        end else if (bus_release_cnt == 30'd1) begin
          state_d = StBusFree;
        end
      end

      default: begin
        state_d = StBusFree;
      end
    endcase
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      state_q <= StBusFree;
    end else if (!monitor_enable) begin
      state_q <= StBusFree;
    end else if (monitor_enable && !monitor_enable_q) begin
      if (multi_controller_enable_i) begin
        // For the multi-controller case, wait until the bus isn't busy before
        // transmitting.
        state_q <= StBusBusyHigh;
      end else begin
        state_q <= StBusFree;
      end
    end else begin
      state_q <= state_d;
    end
  end

  always_comb begin
    if (multi_controller_enable_i) begin
      bus_free_o = (state_q == StBusFree);
    end else begin
      // For single-controller cases, the bus is only "busy" while waiting for the "bus free" time
      // after a Stop condition. In other words, that is the only time our controller can't
      // continue to the next transaction.
      bus_free_o = (state_q != StBusBusyStop);
    end
  end

  assign event_bus_active_timeout_o = bus_active_timeout_det_d && !bus_active_timeout_det_q;
  assign event_host_timeout_o = !target_idle_i && bus_inactive_timeout_det;

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description: I2C finite state machine

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module i2c_controller_fsm import i2c_pkg::*;
#(
  parameter int FifoDepth = 64,
  localparam int FifoDepthWidth = $clog2(FifoDepth+1)
) (
  input        clk_i,  // clock
  input        rst_ni, // active low reset

  input        scl_i,  // serial clock input from i2c bus
  output logic scl_o,  // serial clock output to i2c bus
  input        sda_i,  // serial data input from i2c bus
  output logic sda_o,  // serial data output to i2c bus
  input        bus_free_i,     // High if the bus is free for a new transmission
  output logic transmitting_o, // Controller is currently transmitting SDA

  input        host_enable_i,     // enable host functionality
  input        halt_controller_i, // Halt the controller FSM in Idle

  input                      fmt_fifo_rvalid_i, // indicates there is valid data in fmt_fifo
  input [FifoDepthWidth-1:0] fmt_fifo_depth_i,  // fmt_fifo_depth
  output logic               fmt_fifo_rready_o, // populates fmt_fifo
  input [7:0]                fmt_byte_i,        // byte in fmt_fifo to be sent to target
  input                      fmt_flag_start_before_i, // issue start before sending byte
  input                      fmt_flag_stop_after_i,   // issue stop after sending byte
  input                      fmt_flag_read_bytes_i,   // indicates byte is an number of reads
  input                      fmt_flag_read_continue_i,// host to send Ack to final byte read
  input                      fmt_flag_nak_ok_i,       // no Ack is expected
  input                      unhandled_unexp_nak_i,
  input                      unhandled_nak_timeout_i, // NACK handler timeout event not cleared

  output logic                     rx_fifo_wvalid_o, // high if there is valid data in rx_fifo
  output logic [RX_FIFO_WIDTH-1:0] rx_fifo_wdata_o,  // byte in rx_fifo read from target

  output logic       host_idle_o,      // indicates the host is idle

  input [12:0] thigh_i,    // high period of the SCL in clock units
  input [12:0] tlow_i,     // low period of the SCL in clock units
  input [12:0] t_r_i,      // rise time of both SDA and SCL in clock units
  input [12:0] t_f_i,      // fall time of both SDA and SCL in clock units
  input [12:0] thd_sta_i,  // hold time for (repeated) START in clock units
  input [12:0] tsu_sta_i,  // setup time for repeated START in clock units
  input [12:0] tsu_sto_i,  // setup time for STOP in clock units
  input [12:0] thd_dat_i,  // data hold time in clock units
  input        sda_interference_i, // High when SCL is high and SDA doesn't match while transmitting
  input [29:0] stretch_timeout_i,  // max time target connected to this host may stretch the clock
  input        timeout_enable_i,   // assert if target stretches clock past max
  input [30:0] host_nack_handler_timeout_i, // Timeout threshold for unhandled Host-Mode 'nak' irq.
  input        host_nack_handler_timeout_en_i,

  output logic event_nak_o,              // target didn't Ack when expected
  output logic event_unhandled_nak_timeout_o, // SW didn't handle the NACK in time
  output logic event_arbitration_lost_o, // Lost arbitration after beginning a transaction
  output logic event_scl_interference_o, // other device forcing SCL low
  output logic event_stretch_timeout_o,  // target stretches clock past max time
  output logic event_sda_unstable_o,     // SDA is not constant during SCL pulse
  output logic event_cmd_complete_o      // Command is complete
);

  // I2C bus clock timing variables
  logic [15:0] tcount_q;      // current counter for setting delays
  logic [15:0] tcount_d;      // next counter for setting delays
  logic        load_tcount;   // indicates counter must be loaded
  logic [30:0] stretch_idle_cnt; // counter for clock being stretched by target
                                 // or clock idle by host.
  logic [30:0] unhandled_nak_cnt; // In Host-mode, count cycles where the FSM is halted awaiting
                                  // the nak irq to be handled by SW.
  logic        incr_nak_cnt;

  // (IP in HOST-Mode) This bit is active when the FSM is in a state where a TARGET might
  // be trying to stretch the clock, preventing the controller FSM from continuing.
  logic        stretch_en;

  // Bit and byte counter variables
  logic [2:0]  bit_index;     // bit being transmitted to or read from the bus
  logic        bit_decr;      // indicates bit_index must be decremented by 1
  logic        bit_clr;       // indicates bit_index must be reset to 7
  logic [8:0]  byte_num;      // number of bytes to read
  logic [8:0]  byte_index;    // byte being read from the bus
  logic        byte_decr;     // indicates byte_index must be decremented by 1
  logic        byte_clr;      // indicates byte_index must be reset to byte_num

  // Other internal variables
  logic        scl_d;         // scl internal
  logic        sda_d;         // data internal
  logic        scl_i_q;       // scl_i delayed by one clock
  logic        sda_i_q;       // sda_i delayed by one clock
  logic [7:0]  read_byte;     // register for reads from target
  logic        read_byte_clr; // clear read_byte contents
  logic        shift_data_en; // indicates data must be shifted in from the bus
  logic        trans_started; // indicates a transaction has started
  logic        pend_restart;  // there is a pending restart waiting to be processed
  logic        req_restart;   // request restart
  logic        log_start;     // indicates start is been issued
  logic        log_stop;      // indicates stop is been issued
  logic        auto_stop_d, auto_stop_q; // Tracks whether a Stop symbol was autonomously generated.
  logic        ctrl_symbol_failed; // If SCL pulls low before the controller can issue Start/Stop

  // Clock counter implementation
  typedef enum logic [3:0] {
    tSetupStart,
    tHoldStart,
    tClockStart,
    tClockLow,
    tClockPulse,
    tClockHigh,
    tHoldBit,
    tClockStop,
    tSetupStop,
    tNoDelay
  } tcount_sel_e;

  tcount_sel_e tcount_sel;

  always_comb begin : counter_functions
    tcount_d = tcount_q;
    if (load_tcount) begin
      unique case (tcount_sel)
        tSetupStart : tcount_d = 16'(t_r_i) + 16'(tsu_sta_i);
        tHoldStart  : tcount_d = 16'(t_f_i) + 16'(thd_sta_i);
        tClockStart : tcount_d = 16'(thd_dat_i);
        tClockLow   : tcount_d = 16'(tlow_i) - 16'(thd_dat_i);
        tClockPulse : tcount_d = 16'(t_r_i) + 16'(thigh_i);
        tClockHigh  : tcount_d = 16'(thigh_i);
        tHoldBit    : tcount_d = 16'(t_f_i) + 16'(thd_dat_i);
        tClockStop  : tcount_d = 16'(t_f_i) + 16'(tlow_i) - 16'(thd_dat_i);
        tSetupStop  : tcount_d = 16'(t_r_i) + 16'(tsu_sto_i);
        tNoDelay    : tcount_d = 16'h0001;
        default     : tcount_d = 16'h0001;
      endcase
    end else if (
      host_enable_i ||
      // If we disable Host-Mode mid-txn, keep counting until the end of
      // byte, at which point we create a STOP condition then return to Idle.
      (!host_idle_o && !host_enable_i)) begin
      tcount_d = tcount_q - 1'b1;
    end
  end

  always_ff @ (posedge clk_i or negedge rst_ni) begin : clk_counter
    if (!rst_ni) begin
      tcount_q <= '1;
    end else begin
      tcount_q <= tcount_d;
    end
  end

  // Clock stretching/idle detection when i2c_ctrl.
  // When in host mode, this is a stretch count for how long an external target
  // has stretched the clock.
  // When in target mode, this is an idle count for how long an external host
  // has kept the clock idle after a START indication.
  always_ff @ (posedge clk_i or negedge rst_ni) begin : clk_stretch
    if (!rst_ni) begin
      stretch_idle_cnt <= '0;
    end else if (stretch_en && !scl_i) begin
      // HOST-mode count of clock stretching
      stretch_idle_cnt <= stretch_idle_cnt + 1'b1;
    end else begin
      stretch_idle_cnt <= '0;
    end
  end

  // The TARGET can stretch the clock during any time that the host drives SCL to 0.
  // However, we (the HOST) cannot know it is being stretched until we release SCL,
  // usually trying to create the next clock pulse.
  // There is a minimum 3-cycle round trip (1-cycle output flop, 2-cycle input synchronizer),
  // between releasing the clock and observing the effect of releasing the clock on
  // the inputs. However, this is really '1 + t_r + 2' as the bus also needs to slew to '1
  // before can observe it. Even if the TARGET is not stretching the clock, we cannot
  // confirm it until at-least this amount of time has elapsed.
  //
  // 'stretch_predict_cnt_expired' becomes active once we have observed (4 + t_r) cycles of
  // delay, and if !scl_i at this point we know that the TARGET is stretching the clock.
  // > This implementation requires 'thigh >= 4' to guarantee we don't miss stretching.
  logic [30:0] stretch_cnt_threshold;
  assign stretch_cnt_threshold = 31'd2 + 31'(t_r_i);

  logic stretch_predict_cnt_expired;
  always_ff @ (posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      stretch_predict_cnt_expired <= 1'b0;
    end else begin
      if (stretch_idle_cnt == stretch_cnt_threshold) begin
        stretch_predict_cnt_expired <= 1'b1;
      end else if (!stretch_en) begin
        stretch_predict_cnt_expired <= 1'b0;
      end
    end
  end

  // While the FSM is halted due to an unhandled 'nak' irq in Host-Mode, this counter can
  // be used to trigger a timeout which disables Host-Mode and creates a STOP condition to
  // end the transaction.
  logic unhandled_nak_cnt_expired;
  always_ff @ (posedge clk_i or negedge rst_ni) begin : unhandled_nak_cnt_b
    if (!rst_ni) begin
      unhandled_nak_cnt <= '0;
      unhandled_nak_cnt_expired <= 1'b0;
    end else if (incr_nak_cnt) begin
      // Increment the counter while the FSM is halted in Idle.
      unhandled_nak_cnt <= unhandled_nak_cnt + 1'b1;
      if (unhandled_nak_cnt > host_nack_handler_timeout_i) begin
        unhandled_nak_cnt_expired <= 1'b1;
      end
    end else begin
      unhandled_nak_cnt <= '0;
      unhandled_nak_cnt_expired <= 1'b0;
    end
  end

  assign event_unhandled_nak_timeout_o = unhandled_nak_cnt_expired;

  // Bit index implementation
  always_ff @ (posedge clk_i or negedge rst_ni) begin : bit_counter
    if (!rst_ni) begin
      bit_index <= 3'd7;
    end else if (bit_clr) begin
      bit_index <= 3'd7;
    end else if (bit_decr) begin
      bit_index <= bit_index - 1'b1;
    end else begin
      bit_index <= bit_index;
    end
  end

  // Deserializer for a byte read from the bus
  always_ff @ (posedge clk_i or negedge rst_ni) begin : read_register
    if (!rst_ni) begin
      read_byte <= 8'h00;
    end else if (read_byte_clr) begin
      read_byte <= 8'h00;
    end else if (shift_data_en) begin
      read_byte[7:0] <= {read_byte[6:0], sda_i};  // MSB goes in first
    end
  end

  // Number of bytes to read
  always_comb begin : byte_number
    if (!fmt_flag_read_bytes_i) byte_num = 9'd0;
    else if (fmt_byte_i == '0) byte_num = 9'd256;
    else byte_num = 9'(fmt_byte_i);
  end

  // Byte index implementation
  always_ff @ (posedge clk_i or negedge rst_ni) begin : byte_counter
    if (!rst_ni) begin
      byte_index <= '0;
    end else if (byte_clr) begin
      byte_index <= byte_num;
    end else if (byte_decr) begin
      byte_index <= byte_index - 1'b1;
    end else begin
      byte_index <= byte_index;
    end
  end

  // SDA and SCL at the previous clock edge
  always_ff @ (posedge clk_i or negedge rst_ni) begin : bus_prev
    if (!rst_ni) begin
      scl_i_q <= 1'b1;
      sda_i_q <= 1'b1;
    end else begin
      scl_i_q <= scl_i;
      sda_i_q <= sda_i;
    end
  end

  // SCL going low early is just clock synchronization. SCL switching so fast that the controller
  // can't even sense its outputs is cause for a bus error.
  assign event_arbitration_lost_o = event_sda_unstable_o || sda_interference_i ||
                                    ctrl_symbol_failed;

  // Registers whether a transaction start has been observed.
  // A transaction start does not include a "restart", but rather
  // the first start after enabling i2c, or a start observed after a
  // stop.
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      trans_started <= '0;
    end else if (trans_started && (!host_enable_i || event_arbitration_lost_o)) begin
      trans_started <= '0;
    end else if (log_start) begin
      trans_started <= 1'b1;
    end else if (log_stop) begin
      trans_started <= 1'b0;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      pend_restart <= '0;
    end else if (pend_restart && !host_enable_i) begin
      pend_restart <= '0;
    end else if (req_restart) begin
      pend_restart <= 1'b1;
    end else if (log_start) begin
      pend_restart <= '0;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      auto_stop_q <= 1'b0;
    end else begin
      auto_stop_q <= auto_stop_d;
    end
  end

  // State definitions
  typedef enum logic [4:0] {
    Idle,
    ///////////////////////
    // Host function states
    ///////////////////////
    Active, PopFmtFifo,
    // Host function starts a transaction
    SetupStart, HoldStart, ClockStart,
    // Host function stops a transaction
    SetupStop, HoldStop, ClockStop,
    // Host function transmits a bit to the external target
    ClockLow, ClockPulse, HoldBit,
    // Host function receives an ack from the external target
    ClockLowAck, ClockPulseAck, HoldDevAck,
    // Host function reads a bit from the external target
    ReadClockLow, ReadClockPulse, ReadHoldBit,
    // Host function transmits an ack to the external target
    HostClockLowAck, HostClockPulseAck, HostHoldBitAck
  } state_e;

  state_e state_q, state_d;


  // Increment the NACK timeout count if the controller is halted in Idle and
  // the timeout hasn't yet occurred.
  assign incr_nak_cnt = unhandled_unexp_nak_i && host_enable_i && (state_q == Idle) &&
                        host_nack_handler_timeout_en_i && !unhandled_nak_timeout_i;

  // Outputs for each state
  always_comb begin : state_outputs
    host_idle_o = 1'b1;
    sda_d = 1'b1;
    scl_d = 1'b1;
    transmitting_o = 1'b0;
    log_start = 1'b0;
    log_stop = 1'b0;
    fmt_fifo_rready_o = 1'b0;
    rx_fifo_wvalid_o = 1'b0;
    rx_fifo_wdata_o = RX_FIFO_WIDTH'(0);
    event_nak_o = 1'b0;
    event_scl_interference_o = 1'b0;
    ctrl_symbol_failed = 1'b0;
    event_sda_unstable_o = 1'b0;
    event_cmd_complete_o = 1'b0;
    stretch_en = 1'b0;
    unique case (state_q)
      // Idle: initial state, SDA is released (high), SCL is released if the
      // bus is idle. Otherwise, if no STOP condition has been sent yet,
      // continue pulling SCL low in host mode.
      Idle : begin
        sda_d = 1'b1;
        if (trans_started) begin
          host_idle_o = 1'b0;
          scl_d = 1'b0;
        end else begin
          host_idle_o = 1'b1;
          scl_d = 1'b1;
        end
      end

      ///////////////
      // HOST MODE //
      ///////////////

      // SetupStart: SDA and SCL are released
      SetupStart : begin
        host_idle_o = 1'b0;
        sda_d = 1'b1;
        scl_d = 1'b1;
        transmitting_o = 1'b1;
        // If this is a restart, SCL was last low, and a target could be stretching the clock.
        stretch_en = trans_started;
        if (trans_started && !scl_i && scl_i_q) begin
          // If this is a repeated Start, an early clock prevents issuing the symbol. If it's not
          // a repeated start, the FSM will just go back to Idle and wait for the bus to go free
          // again.
          ctrl_symbol_failed = 1'b1;
        end else if (tcount_q == 16'd1) begin
          log_start = 1'b1;
          event_cmd_complete_o = pend_restart;
        end
      end
      // HoldStart: SDA is pulled low, SCL is released
      HoldStart : begin
        host_idle_o = 1'b0;
        sda_d = 1'b0;
        scl_d = 1'b1;
        transmitting_o = 1'b1;
        if (scl_i_q && !scl_i)  event_scl_interference_o = 1'b1;
      end
      // ClockStart: SCL is pulled low, SDA stays low
      ClockStart : begin
        host_idle_o = 1'b0;
        sda_d = 1'b0;
        scl_d = 1'b0;
        transmitting_o = 1'b1;
      end
      ClockLow : begin
        host_idle_o = 1'b0;
        if (pend_restart) begin
          sda_d = 1'b1;
        end else begin
          sda_d = fmt_byte_i[bit_index];
        end
        scl_d = 1'b0;
        transmitting_o = 1'b1;
      end
      // ClockPulse: SCL is released, SDA keeps the indexed bit value
      ClockPulse : begin
        host_idle_o = 1'b0;
        sda_d = fmt_byte_i[bit_index];
        scl_d = 1'b1;
        transmitting_o = 1'b1;
        stretch_en = 1'b1;
        if (scl_i_q && !scl_i)  event_scl_interference_o = 1'b1;
        if (scl_i_q && scl_i && (sda_i_q != sda_i)) begin
          // Unexpected Stop / Start
          event_sda_unstable_o = 1'b1;
        end
      end
      // HoldBit: SCL is pulled low
      HoldBit : begin
        host_idle_o = 1'b0;
        sda_d = fmt_byte_i[bit_index];
        scl_d = 1'b0;
        transmitting_o = 1'b1;
      end
      // ClockLowAck: SCL pulled low, SDA is released
      ClockLowAck : begin
        host_idle_o = 1'b0;
        sda_d = 1'b1;
        scl_d = 1'b0;
      end
      // ClockPulseAck: SCL is released
      ClockPulseAck : begin
        host_idle_o = 1'b0;
        sda_d = 1'b1;
        scl_d = 1'b1;
        if (!scl_i_q && scl_i && sda_i && !fmt_flag_nak_ok_i) event_nak_o = 1'b1;
        stretch_en = 1'b1;
        if (scl_i_q && !scl_i)  event_scl_interference_o = 1'b1;
        if (scl_i_q && scl_i && (sda_i_q != sda_i)) begin
          // Unexpected Stop / Start
          event_sda_unstable_o = 1'b1;
        end
      end
      // HoldDevAck: SCL is pulled low
      HoldDevAck : begin
        host_idle_o = 1'b0;
        sda_d = 1'b1;
        scl_d = 1'b0;
      end
      // ReadClockLow: SCL is pulled low, SDA is released
      ReadClockLow : begin
        host_idle_o = 1'b0;
        sda_d = 1'b1;
        scl_d = 1'b0;
      end
      // ReadClockPulse: SCL is released, the indexed bit value is read off SDA
      ReadClockPulse : begin
        host_idle_o = 1'b0;
        scl_d = 1'b1;
        stretch_en = 1'b1;
        if (scl_i_q && !scl_i)  event_scl_interference_o = 1'b1;
        if (scl_i_q && scl_i && (sda_i_q != sda_i)) begin
          // Unexpected Stop / Start
          event_sda_unstable_o = 1'b1;
        end
      end
      // ReadHoldBit: SCL is pulled low
      ReadHoldBit : begin
        host_idle_o = 1'b0;
        scl_d = 1'b0;
        if (bit_index == '0 && tcount_q == 16'd1) begin
          rx_fifo_wvalid_o = 1'b1;      // assert that rx_fifo has valid data
          rx_fifo_wdata_o = read_byte;  // transfer read data to rx_fifo
        end
      end
      // HostClockLowAck: SCL pulled low, SDA is conditional
      HostClockLowAck : begin
        host_idle_o = 1'b0;
        scl_d = 1'b0;
        transmitting_o = 1'b1;

        // If it is the last byte of a read, send a NAK before the stop.
        // Otherwise send the ack.
        if (fmt_flag_read_continue_i) sda_d = 1'b0;
        else if (byte_index == 9'd1) sda_d = 1'b1;
        else sda_d = 1'b0;
      end
      // HostClockPulseAck: SCL is released
      HostClockPulseAck : begin
        host_idle_o = 1'b0;
        if (fmt_flag_read_continue_i) sda_d = 1'b0;
        else if (byte_index == 9'd1) sda_d = 1'b1;
        else sda_d = 1'b0;
        scl_d = 1'b1;
        transmitting_o = 1'b1;
        stretch_en = 1'b1;
        if (scl_i_q && !scl_i)  event_scl_interference_o = 1'b1;
        if (scl_i_q && scl_i && (sda_i_q != sda_i)) begin
          // Unexpected Stop / Start
          event_sda_unstable_o = 1'b1;
        end
      end
      // HostHoldBitAck: SCL is pulled low
      HostHoldBitAck : begin
        host_idle_o = 1'b0;
        if (fmt_flag_read_continue_i) sda_d = 1'b0;
        else if (byte_index == 9'd1) sda_d = 1'b1;
        else sda_d = 1'b0;
        scl_d = 1'b0;
        transmitting_o = 1'b1;
      end
      // ClockStop: SCL is pulled low, SDA stays low
      ClockStop : begin
        host_idle_o = 1'b0;
        sda_d = 1'b0;
        scl_d = 1'b0;
        transmitting_o = 1'b1;
      end
      // SetupStop: SDA is pulled low, SCL is released
      SetupStop : begin
        host_idle_o = 1'b0;
        sda_d = 1'b0;
        scl_d = 1'b1;
        transmitting_o = 1'b1;
        stretch_en = 1'b1;
        if (!scl_i && scl_i_q) begin
          // Failed to issue Stop before some other device could pull SCL low.
          ctrl_symbol_failed = 1'b1;
        end
      end
      // HoldStop: SDA and SCL are released
      HoldStop : begin
        host_idle_o = 1'b0;
        sda_d = 1'b1;
        scl_d = 1'b1;
        event_cmd_complete_o = 1'b1;
        if (!sda_i && !scl_i) begin
          // Failed to issue Stop before some other device could pull SCL low.
          ctrl_symbol_failed = 1'b1;
        end else if (sda_i) begin
          log_stop = 1'b1;
        end
      end
      // Active: continue while keeping SCL low
      Active : begin
        host_idle_o = 1'b0;

        // If this is a transaction start, do not drive scl low
        // since in the next state we will drive it high to initiate
        // the start bit.
        // If this is a restart, continue driving the clock low.
        scl_d = fmt_flag_start_before_i && !trans_started;
      end
      // PopFmtFifo: populate fmt_fifo
      PopFmtFifo : begin
        host_idle_o = 1'b0;
        if (fmt_flag_stop_after_i) scl_d = 1'b1;
        else scl_d = 1'b0;
        fmt_fifo_rready_o = 1'b1;
      end

      // default
      default : begin
        host_idle_o = 1'b1;
        sda_d = 1'b1;
        scl_d = 1'b1;
        transmitting_o = 1'b0;
        log_start = 1'b0;
        log_stop = 1'b0;
        event_scl_interference_o = 1'b0;
        ctrl_symbol_failed = 1'b0;
        fmt_fifo_rready_o = 1'b0;
        rx_fifo_wvalid_o = 1'b0;
        rx_fifo_wdata_o = RX_FIFO_WIDTH'(0);
        event_nak_o = 1'b0;
        event_sda_unstable_o = 1'b0;
        event_cmd_complete_o = 1'b0;
      end
    endcase // unique case (state_q)
  end

  // Conditional state transition
  always_comb begin : state_functions
    state_d = state_q;
    load_tcount = 1'b0;
    tcount_sel = tNoDelay;
    bit_decr = 1'b0;
    bit_clr = 1'b0;
    byte_decr = 1'b0;
    byte_clr = 1'b0;
    read_byte_clr = 1'b0;
    shift_data_en = 1'b0;
    req_restart = 1'b0;
    auto_stop_d = auto_stop_q;

    unique case (state_q)
      // Idle: initial state, SDA is released (high), and SCL is released if there is no ongoing
      // transaction.
      Idle : begin
        if (host_enable_i) begin
          if (unhandled_unexp_nak_i || unhandled_nak_timeout_i || halt_controller_i) begin
            // If we are awaiting software to handle an unexpected NACK, halt the FSM here.
            // The current transaction does not end, and SCL remains in its current state.
            // Software typically should handle an unexpected NACK by either disabling the
            // controller (causing host_enable_i to fall) or by the following sequence:
            //   1. Clear and/or populate the FMT FIFO.
            //   2. Clear CONTROLLER_EVENTS.NACK
            // Note that if the timeout feature is enabled, the controller will be forced to
            // issue a Stop if software takes too long to address the NACK. A short timeout
            // could also be used to automatically issue a Stop whenever an unexpected NACK
            // occurs.
            // Note that we may also halt here on a bus timeout or if arbitration was lost, so
            // software may fix up the FIFOs before beginning a new transaction.
            if (trans_started && unhandled_nak_cnt_expired) begin
              // If our timeout counter expires, generate a STOP condition automatically.
              auto_stop_d = 1'b1;
              state_d = ClockStop;
              load_tcount = 1'b1;
              tcount_sel = tClockStop;
            end
          end else if (fmt_fifo_rvalid_i) begin
            if (trans_started || bus_free_i) begin
              state_d = Active;
            end
          end
        end else if (trans_started && !host_enable_i) begin
            auto_stop_d = 1'b1;
            state_d = ClockStop;
            load_tcount = 1'b1;
            tcount_sel = tClockStop;
        end
      end

      ///////////////
      // HOST MODE //
      ///////////////

      // SetupStart: SDA and SCL are released
      SetupStart : begin
        if (!trans_started && !scl_i) begin
          // This was the start of a transaction, but another device beat us to access. Go back to
          // Idle, and wait for the next turn.
          state_d = Idle;
        end else if (trans_started && !scl_i && !scl_i_q && stretch_predict_cnt_expired) begin
          // Saw stretching. Remain in this state and don't count down until we see SCL high.
          state_d = SetupStart;
          load_tcount = 1'b1;
          // This double-counts the rise time, unfortunately.
          tcount_sel = tSetupStart;
        end else if (trans_started && !scl_i && scl_i_q) begin
          // Failed to issue repeated Start. Effectively lost arbitration.
          state_d = Idle;
        end else if (tcount_q == 16'd1) begin
          state_d = HoldStart;
          load_tcount = 1'b1;
          tcount_sel = tHoldStart;
        end
      end
      // HoldStart: SDA is pulled low, SCL is released
      HoldStart : begin
        if (tcount_q == 16'd1 || (!scl_i && scl_i_q)) begin
          state_d = ClockStart;
          load_tcount = 1'b1;
          tcount_sel = tClockStart;
        end
      end
      // ClockStart: SCL is pulled low, SDA stays low
      ClockStart : begin
        if (tcount_q == 16'd1) begin
          state_d = ClockLow;
          load_tcount = 1'b1;
          tcount_sel = tClockLow;
        end
      end
      // ClockLow: SCL stays low, shift indexed bit onto SDA
      ClockLow : begin
        if (tcount_q == 16'd1) begin
          load_tcount = 1'b1;
          if (pend_restart) begin
            state_d = SetupStart;
            tcount_sel = tSetupStart;
          end else begin
            state_d = ClockPulse;
            tcount_sel = tClockPulse;
          end
        end
      end
      // ClockPulse: SCL is released, SDA keeps the indexed bit value
      ClockPulse : begin
        if (!scl_i && !scl_i_q && stretch_predict_cnt_expired) begin
          // Saw stretching. Remain in this state and don't count down until we see SCL high.
          load_tcount = 1'b1;
          tcount_sel = tClockHigh;
        end else if (scl_i_q && scl_i && (sda_i_q != sda_i)) begin
          // Unexpected Stop / Start
          state_d = Idle;
        end else if (tcount_q == 16'd1 || (!scl_i && scl_i_q)) begin
          // Transition either when we finish counting our high period or
          // another controller pulls clock low.
          state_d = HoldBit;
          load_tcount = 1'b1;
          tcount_sel = tHoldBit;
        end
      end
      // HoldBit: SCL is pulled low
      HoldBit : begin
        if (tcount_q == 16'd1) begin
          load_tcount = 1'b1;
          tcount_sel = tClockLow;
          if (bit_index == '0) begin
            state_d = ClockLowAck;
            bit_clr = 1'b1;
          end else begin
            state_d = ClockLow;
            bit_decr = 1'b1;
          end
        end
      end
      // ClockLowAck: Target is allowed to drive ack back
      // to host (dut)
      ClockLowAck : begin
        if (tcount_q == 16'd1) begin
          state_d = ClockPulseAck;
          load_tcount = 1'b1;
          tcount_sel = tClockPulse;
        end
      end
      // ClockPulseAck: SCL is released
      ClockPulseAck : begin
        if (!scl_i && !scl_i_q && stretch_predict_cnt_expired) begin
          // Saw stretching. Remain in this state and don't count down until we see SCL high.
          load_tcount = 1'b1;
          tcount_sel = tClockHigh;
        end else if (scl_i_q && scl_i && (sda_i_q != sda_i)) begin
          // Unexpected Stop / Start
          state_d = Idle;
        end else begin
          if (tcount_q == 16'd1 || (!scl_i && scl_i_q)) begin
            state_d = HoldDevAck;
            load_tcount = 1'b1;
            tcount_sel = tHoldBit;
          end
        end
      end
      // HoldDevAck: SCL is pulled low
      HoldDevAck : begin
        if (tcount_q == 16'd1) begin
          if (fmt_flag_stop_after_i) begin
            state_d = ClockStop;
            load_tcount = 1'b1;
            tcount_sel = tClockStop;
          end else begin
            state_d = PopFmtFifo;
            load_tcount = 1'b1;
            tcount_sel = tNoDelay;
          end
        end
      end
      // ReadClockLow: SCL is pulled low, SDA is released
      ReadClockLow : begin
        if (tcount_q == 16'd1) begin
          state_d = ReadClockPulse;
          load_tcount = 1'b1;
          tcount_sel = tClockPulse;
        end
      end
      // ReadClockPulse: SCL is released, the indexed bit value is read off SDA
      ReadClockPulse : begin
        if (!scl_i && !scl_i_q && stretch_predict_cnt_expired) begin
          // Saw stretching. Remain in this state and don't count down until we see SCL high.
          load_tcount = 1'b1;
          tcount_sel = tClockHigh;
        end else if (scl_i_q && scl_i && (sda_i_q != sda_i)) begin
          // Unexpected Stop / Start
          state_d = Idle;
        end else if (tcount_q == 16'd1 || (!scl_i && scl_i_q)) begin
          state_d = ReadHoldBit;
          load_tcount = 1'b1;
          tcount_sel = tHoldBit;
          shift_data_en = 1'b1; // SDA is sampled on the final clk_i cycle of the SCL pulse.
        end
      end
      // ReadHoldBit: SCL is pulled low
      ReadHoldBit : begin
        if (tcount_q == 16'd1) begin
          load_tcount = 1'b1;
          tcount_sel = tClockLow;
          if (bit_index == '0) begin
            state_d = HostClockLowAck;
            bit_clr = 1'b1;
            read_byte_clr = 1'b1;
          end else begin
            state_d = ReadClockLow;
            bit_decr = 1'b1;
          end
        end
      end
      // HostClockLowAck: SCL is pulled low, SDA is conditional based on
      // byte position
      HostClockLowAck : begin
        if (tcount_q == 16'd1) begin
          state_d = HostClockPulseAck;
          load_tcount = 1'b1;
          tcount_sel = tClockPulse;
        end
      end
      // HostClockPulseAck: SCL is released
      HostClockPulseAck : begin
        if (!scl_i && !scl_i_q && stretch_predict_cnt_expired) begin
          // Saw stretching. Remain in this state and don't count down until we see SCL high.
          load_tcount = 1'b1;
          tcount_sel = tClockHigh;
        end else if (scl_i_q && scl_i && (sda_i_q != sda_i)) begin
          // Unexpected Stop / Start
          state_d = Idle;
        end else if (tcount_q == 16'd1 || (!scl_i && scl_i_q)) begin
          state_d = HostHoldBitAck;
          load_tcount = 1'b1;
          tcount_sel = tHoldBit;
        end
      end
      // HostHoldBitAck: SCL is pulled low
      HostHoldBitAck : begin
        if (tcount_q == 16'd1) begin
          if (byte_index == 9'd1) begin
            if (fmt_flag_stop_after_i) begin
              state_d = ClockStop;
              load_tcount = 1'b1;
              tcount_sel = tClockStop;
            end else begin
              state_d = PopFmtFifo;
              load_tcount = 1'b1;
              tcount_sel = tNoDelay;
            end
          end else begin
            state_d = ReadClockLow;
            load_tcount = 1'b1;
            tcount_sel = tClockLow;
            byte_decr = 1'b1;
          end
        end
      end
      // ClockStop: SCL is pulled low, SDA stays low
      ClockStop : begin
        if (tcount_q == 16'd1) begin
          state_d = SetupStop;
          load_tcount = 1'b1;
          tcount_sel = tSetupStop;
        end
      end
      // SetupStop: SDA is pulled low, SCL is released
      SetupStop : begin
        if (!scl_i && !scl_i_q && stretch_predict_cnt_expired) begin
          // Saw stretching. Remain in this state and don't count down until we see SCL high.
          load_tcount = 1'b1;
          tcount_sel = tSetupStop;
        end else if (!scl_i && scl_i_q) begin
          // Failed to issue Stop before some other device could pull SCL low.
          state_d = Idle;
        end else if (tcount_q == 16'd1) begin
          state_d = HoldStop;
        end
      end
      // HoldStop: SDA and SCL are released
      HoldStop : begin
        if (!sda_i && !scl_i) begin
          // Failed to issue Stop before some other device could pull SCL low.
          state_d = Idle;
          auto_stop_d = 1'b0;
        end else if (sda_i) begin
          auto_stop_d = 1'b0;
          if (auto_stop_q) begin
            // If this Stop symbol was generated automatically, go back to Idle.
            state_d = Idle;
            load_tcount = 1'b1;
            tcount_sel = tNoDelay;
          end else begin
            state_d = PopFmtFifo;
            load_tcount = 1'b1;
            tcount_sel = tNoDelay;
          end
        end
      end
      // Active: continue while keeping SCL low
      Active : begin
        if (fmt_flag_read_bytes_i) begin
          byte_clr = 1'b1;
          state_d = ReadClockLow;
          load_tcount = 1'b1;
          tcount_sel = tClockLow;
        end else if (fmt_flag_start_before_i && !trans_started) begin
          state_d = SetupStart;
          load_tcount = 1'b1;
          tcount_sel = tSetupStart;
        end else begin
          state_d = ClockLow;
          load_tcount = 1'b1;
          req_restart = fmt_flag_start_before_i;
          tcount_sel = tClockLow;
        end
      end
      // PopFmtFifo: pop fmt_fifo item
      PopFmtFifo : begin
        if (!host_enable_i && trans_started) begin
          auto_stop_d = 1'b1;
          state_d = ClockStop;
          load_tcount = 1'b1;
          tcount_sel = tClockStop;
        end else if (!host_enable_i || (fmt_fifo_depth_i == 7'h1) ||
                     unhandled_unexp_nak_i || !trans_started) begin
          state_d = Idle;
          load_tcount = 1'b1;
          tcount_sel = tNoDelay;
        end else begin
          state_d = Active;
          load_tcount = 1'b1;
          tcount_sel = tNoDelay;
        end
      end

      // default
      default : begin
        state_d = Idle;
        load_tcount = 1'b0;
        tcount_sel = tNoDelay;
        bit_decr = 1'b0;
        bit_clr = 1'b0;
        byte_decr = 1'b0;
        byte_clr = 1'b0;
        read_byte_clr = 1'b0;
        shift_data_en = 1'b0;
        auto_stop_d = 1'b0;
      end
    endcase // unique case (state_q)

    if (trans_started && (sda_interference_i || ctrl_symbol_failed)) begin
      state_d = Idle;
    end
  end

  // Synchronous state transition
  always_ff @ (posedge clk_i or negedge rst_ni) begin : state_transition
    if (!rst_ni) begin
      state_q <= Idle;
    end else begin
      state_q <= state_d;
    end
  end

  assign scl_o = scl_d;
  assign sda_o = sda_d;

  // Target stretched clock beyond timeout
  assign event_stretch_timeout_o = stretch_en && timeout_enable_i &&
                                   (stretch_idle_cnt > 31'(stretch_timeout_i));

  // Make sure we never attempt to send a single cycle glitch
  

  // TODO: Handle the assertion below
//  // I2C bus outputs
//  always_ff @(posedge clk_i or negedge rst_ni) begin
//    if (!rst_ni) begin
//      scl_q <= 1'b1;
//      sda_q <= 1'b1;
//    end else begin
//      scl_q <= scl_d;
//      sda_q <= sda_d;
//    end
//  end
//
//  // Check that we don't change SCL and SDA in the same clock cycle in host mode.
//  `ASSERT(SclSdaChangeNotSimultaneous_A, !(host_enable_i && (scl_d != scl_q) && (sda_d != sda_q)))

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description: I2C finite state machine

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module i2c_target_fsm import i2c_pkg::*;
#(
  parameter int unsigned AcqFifoDepth = 64,
  localparam int unsigned AcqFifoDepthWidth = $clog2(AcqFifoDepth+1)
) (
  input        clk_i,  // clock
  input        rst_ni, // active low reset

  input        scl_i,  // serial clock input from i2c bus
  output logic scl_o,  // serial clock output to i2c bus
  input        sda_i,  // serial data input from i2c bus
  output logic sda_o,  // serial data output to i2c bus
  input        start_detect_i,
  input        stop_detect_i,
  output logic transmitting_o, // Target is transmitting SDA (disambiguates high sda_o)

  input        target_enable_i, // enable target functionality

  input                      tx_fifo_rvalid_i, // indicates there is valid data in tx_fifo
  output logic               tx_fifo_rready_o, // pop entry from tx_fifo
  input [TX_FIFO_WIDTH-1:0]  tx_fifo_rdata_i,  // byte in tx_fifo to be sent to host

  output logic                      acq_fifo_wvalid_o, // high if there is valid data in acq_fifo
  output logic [ACQ_FIFO_WIDTH-1:0] acq_fifo_wdata_o,  // data to write to acq_fifo from target
  input [AcqFifoDepthWidth-1:0]     acq_fifo_depth_i,  // fill level of acq_fifo
  output logic                      acq_fifo_full_o,   // local version of "full"
  input [ACQ_FIFO_WIDTH-1:0]        acq_fifo_rdata_i,  // only used for assertion

  output logic       target_idle_o,    // indicates the target is idle

  input [12:0] t_r_i,      // rise time of both SDA and SCL in clock units
  input [12:0] tsu_dat_i,  // data setup time in clock units
  input [12:0] thd_dat_i,  // data hold time in clock units
  input [30:0] nack_timeout_i,     // max time target may stretch until it should NACK
  input        nack_timeout_en_i,  // enable nack timeout
  input        nack_addr_after_timeout_i,
  input        arbitration_lost_i, // Lost arbitration while transmitting
  input        bus_timeout_i,      // The bus timed out, with SCL held low for too long.

  input        unhandled_tx_stretch_event_i, // An unhandled event requests TX stretching

  // ACK Control Mode signals
  input              ack_ctrl_mode_i,       // Whether ACK Control Mode is enabled
  output logic [8:0] auto_ack_cnt_o,        // Current Auto ACK count
  input              auto_ack_load_i,       // SW requests load of the Auto ACK counter
  input        [8:0] auto_ack_load_value_i, // SW's value to load into the Auto ACK counter
  input              sw_nack_i,             // SW pulses high to NACK while stretching in ack_ctrl
  output logic       ack_ctrl_stretching_o, // Stretching due to zero Auto ACK count
  output logic [7:0] acq_fifo_next_data_o,  // SW uses this for deciding whether to NACK data bytes

  input logic [6:0] target_address0_i,
  input logic [6:0] target_mask0_i,
  input logic [6:0] target_address1_i,
  input logic [6:0] target_mask1_i,

  output logic event_target_nack_o,         // this target sent a NACK (this is used to keep count)
  output logic event_cmd_complete_o,        // Command is complete
  output logic event_tx_stretch_o,          // tx transaction is being stretched
  output logic event_unexp_stop_o,          // target received an unexpected stop
  output logic event_tx_arbitration_lost_o, // Arbitration was lost during a read transfer
  output logic event_tx_bus_timeout_o,      // Bus timed out during a read transfer
  output logic event_read_cmd_received_o    // A read awaits confirmation for TX FIFO release
);

  // I2C bus clock timing variables
  logic [15:0] tcount_q;      // current counter for setting delays
  logic [15:0] tcount_d;      // next counter for setting delays
  logic        load_tcount;   // indicates counter must be loaded
  logic [30:0] stretch_active_cnt; // In target mode keep track of how long it has stretched for
                                   // the NACK timeout feature.

  logic        actively_stretching; // Only high when this target is holding SCL low to stretch.
  logic        ack_ctrl_stretching; // Stretching due to Auto ACK Count exhausted

  logic        nack_transaction_q; // Set if the rest of the transaction needs to be nack'd.
  logic        nack_transaction_d;

  // Other internal variables
  logic        scl_d;         // scl internal
  logic        sda_d, sda_q;  // data internal
  logic        scl_i_q;       // scl_i delayed by one clock

  // Target specific variables
  logic        restart_det_q; // indicates the latest start was a repeated start
  logic        restart_det_d;
  logic        address0_match;// indicates target's address0 matches the one sent by host
  logic        address1_match;// indicates target's address1 matches the one sent by host
  logic        address_match; // indicates one of target's addresses matches the one sent by host
  logic        xact_for_us_q; // Target was addressed in this transaction
  logic        xact_for_us_d; //     - We only record Stop if the Target was addressed.
  logic        xfer_for_us_q; // Target was addressed in this transfer
  logic        xfer_for_us_d; //     - event_cmd_complete_o is only for our transfers
  logic [7:0]  input_byte;    // register for reads from host
  logic        input_byte_clr;// clear input_byte contents
  logic        acq_fifo_plenty_space;
  logic        acq_fifo_full_or_last_space;
  logic        stretch_addr;
  logic        stretch_rx;
  logic        stretch_tx;
  logic        nack_timeout;
  logic        expect_stop;

  // Target ACK control variables
  logic [8:0]  auto_ack_cnt_q, auto_ack_cnt_d; // Remaining bytes that may be auto ACK'd
  logic        can_auto_ack; // Whether the FSM may automatically ACK

  // Target bit counter variables
  logic [3:0]  bit_idx;       // bit index including ack/nack
  logic        bit_ack;       // indicates ACK bit been sent or received
  logic        rw_bit;        // indicates host wants to read (1) or write (0)
  logic        host_ack;      // indicates host acknowledged transmitted byte


  // Clock counter implementation
  typedef enum logic [1:0] {
    tSetupData,
    tHoldData,
    tNoDelay
  } tcount_sel_e;

  tcount_sel_e tcount_sel;

  always_comb begin : counter_functions
    tcount_d = tcount_q;
    if (load_tcount) begin
      unique case (tcount_sel)
        tSetupData  : tcount_d = 16'(t_r_i) + 16'(tsu_dat_i);
        tHoldData   : tcount_d = 16'(thd_dat_i);
        tNoDelay    : tcount_d = 16'h0001;
        default     : tcount_d = 16'h0001;
      endcase
    end else if (target_enable_i) begin
      tcount_d = tcount_q - 1'b1;
    end
  end

  always_ff @ (posedge clk_i or negedge rst_ni) begin : clk_counter
    if (!rst_ni) begin
      tcount_q <= '1;
    end else begin
      tcount_q <= tcount_d;
    end
  end

  // Keep track of how long the target has been stretching. This is used to
  // timeout and send a NACK instead.
  always_ff @ (posedge clk_i or negedge rst_ni) begin : clk_nack_after_stretch
    if (!rst_ni) begin
      stretch_active_cnt <= '0;
    end else if (actively_stretching) begin
      stretch_active_cnt <= stretch_active_cnt + 1'b1;
    end else if (start_detect_i && target_idle_o) begin
      stretch_active_cnt <= '0;
    end
  end

  // Track remaining number of bytes that may be automatically ACK'd
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      auto_ack_cnt_q <= '0;
    end else if (auto_ack_load_i && ack_ctrl_stretching) begin
      // Loads are only accepted while stretching to avoid races.
      auto_ack_cnt_q <= auto_ack_load_value_i;
    end else begin
      auto_ack_cnt_q <= auto_ack_cnt_d;
    end
  end

  assign can_auto_ack = !ack_ctrl_mode_i || (auto_ack_cnt_q > '0);
  assign auto_ack_cnt_o = auto_ack_cnt_q;
  assign ack_ctrl_stretching_o = ack_ctrl_stretching;
  assign acq_fifo_next_data_o = input_byte;

  // Latch whether this transaction is to be NACK'd.
  always_ff @ (posedge clk_i or negedge rst_ni) begin : clk_nack_transaction
    if (!rst_ni) begin
      nack_transaction_q <= 1'b0;
    end else begin
      nack_transaction_q <= nack_transaction_d;
    end
  end

  // SDA and SCL at the previous clock edge
  always_ff @ (posedge clk_i or negedge rst_ni) begin : bus_prev
    if (!rst_ni) begin
      scl_i_q <= 1'b1;
    end else begin
      scl_i_q <= scl_i;
    end
  end

  // Track the transaction framing and this target's participation in it.
  always_ff @ (posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      restart_det_q <= 1'b0;
      xact_for_us_q <= 1'b0;
      xfer_for_us_q <= 1'b0;
    end else begin
      restart_det_q <= restart_det_d;
      xact_for_us_q <= xact_for_us_d;
      xfer_for_us_q <= xfer_for_us_d;
    end
  end

  // Bit counter on the target side
  assign bit_ack = (bit_idx == 4'd8); // ack

  // Increment counter on negative SCL edge
  always_ff @ (posedge clk_i or negedge rst_ni) begin : tgt_bit_counter
    if (!rst_ni) begin
      bit_idx <= 4'd0;
    end else if (start_detect_i) begin
      bit_idx <= 4'd0;
    end else if (scl_i_q && !scl_i) begin
      // input byte clear is always asserted on a "start"
      // condition.
      if (input_byte_clr || bit_ack) bit_idx <= 4'd0;
      else bit_idx <= bit_idx + 1'b1;
    end else begin
      bit_idx <= bit_idx;
    end
  end

  // Deserializer for a byte read from the bus on the target side
  assign address0_match = ((input_byte[7:1] & target_mask0_i) == target_address0_i) &&
                          (target_mask0_i != '0);
  assign address1_match = ((input_byte[7:1] & target_mask1_i) == target_address1_i) &&
                          (target_mask1_i != '0);
  assign address_match = (address0_match || address1_match);

  // Shift data in on positive SCL edge
  always_ff @ (posedge clk_i or negedge rst_ni) begin : tgt_input_register
    if (!rst_ni) begin
      input_byte <= 8'h00;
    end else if (input_byte_clr) begin
      input_byte <= 8'h00;
    end else if (!scl_i_q && scl_i) begin
      if (!bit_ack) input_byte[7:0] <= {input_byte[6:0], sda_i};  // MSB goes in first
    end
  end

  // Detection by the target of ACK bit sent by the host
  always_ff @ (posedge clk_i or negedge rst_ni) begin : host_ack_register
    if (!rst_ni) begin
      host_ack <= 1'b0;
    end else if (!scl_i_q && scl_i) begin
      if (bit_ack) host_ack <= ~sda_i;
    end
  end

  // An artificial acq_fifo_wready is used here to ensure we always have
  // space to absorb a stop / repeat start format byte.  Without guaranteeing
  // space for this entry, the target module would need to stretch the
  // repeat start / stop indication.  If a system does not support stretching,
  // there's no good way for a stop to be NACK'd.
  // Besides the space necessary for the stop format byte, we also need one
  // space to send a NACK. This means that we can notify software that a NACK
  // has happened while still keeping space for a subsequent stop or repeated
  // start.
  logic [AcqFifoDepthWidth-1:0] acq_fifo_remainder;
  assign acq_fifo_remainder = AcqFifoDepthWidth'(AcqFifoDepth) - acq_fifo_depth_i;
  // This is used for acq_fifo_full_o to send the ACQ FIFO full alert to
  // software.
  assign acq_fifo_plenty_space = acq_fifo_remainder > AcqFifoDepthWidth'(2);
  assign acq_fifo_full_or_last_space = acq_fifo_remainder <= AcqFifoDepthWidth'(1);

  // State definitions
  typedef enum logic [4:0] {
    Idle,
    /////////////////////////
    // Target function states
    /////////////////////////

    // Target function receives start and address from external host
    AcquireStart, AddrRead,
    // Target function acknowledges the address and returns an ack to external host
    AddrAckWait, AddrAckSetup, AddrAckPulse, AddrAckHold,
    // Target function sends read data to external host-receiver
    TransmitWait, TransmitSetup, TransmitPulse, TransmitHold,
    // Target function receives ack from external host
    TransmitAck, TransmitAckPulse, WaitForStop,
    // Target function receives write data from the external host
    AcquireByte,
    // Target function sends ack to external host
    AcquireAckWait, AcquireAckSetup, AcquireAckPulse, AcquireAckHold,
    // Target function clock stretch handling.
    StretchAddrAck, StretchAddrAckSetup, StretchAddr,
    StretchTx, StretchTxSetup,
    StretchAcqFull, StretchAcqSetup
  } state_e;

  state_e state_q, state_d;

  logic rw_bit_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rw_bit_q <= '0;
    end else if (bit_ack && address_match) begin
      rw_bit_q <= rw_bit;
    end
  end

  // Reverse the bit order since data should be sent out MSB first
  logic [TX_FIFO_WIDTH-1:0] tx_fifo_rdata;
  assign tx_fifo_rdata = {<<1{tx_fifo_rdata_i}};

  // The usage of target_idle_o directly confuses xcelium and leads the
  // the simulator to a combinational loop. While it may be a tool recognized
  // loop, it is not an actual physical loop, since target_idle affects only
  // state_d, which is not used directly by any logic in this module.
  // This is a work around for a known tool limitation.
  logic target_idle;
  assign target_idle = target_idle_o;

  // During a host issued read, a stop was received without first seeing a nack.
  // This may be harmless but is technically illegal behavior, notify software.
  assign event_unexp_stop_o = target_enable_i & xfer_for_us_q & rw_bit_q &
                              stop_detect_i & !expect_stop;

  // Record each transaction that gets NACK'd.
  assign event_target_nack_o = !nack_transaction_q && nack_transaction_d;

  // Outputs for each state
  always_comb begin : state_outputs
    target_idle_o = 1'b1;
    sda_d = 1'b1;
    scl_d = 1'b1;
    transmitting_o = 1'b0;
    tx_fifo_rready_o = 1'b0;
    acq_fifo_wvalid_o = 1'b0;
    acq_fifo_wdata_o = ACQ_FIFO_WIDTH'(0);
    event_cmd_complete_o = 1'b0;
    rw_bit = rw_bit_q;
    expect_stop = 1'b0;
    restart_det_d = restart_det_q;
    xact_for_us_d = xact_for_us_q;
    xfer_for_us_d = xfer_for_us_q;
    auto_ack_cnt_d = auto_ack_cnt_q;
    ack_ctrl_stretching = 1'b0;
    nack_transaction_d = nack_transaction_q;
    actively_stretching = 1'b0;
    event_tx_arbitration_lost_o = 1'b0;
    event_tx_bus_timeout_o = 1'b0;
    event_read_cmd_received_o = 1'b0;

    unique case (state_q)
      // Idle: initial state, SDA is released (high), SCL is released if the
      // bus is idle. Otherwise, if no STOP condition has been sent yet,
      // continue pulling SCL low in host mode.
      Idle : begin
        sda_d = 1'b1;
        scl_d = 1'b1;
        restart_det_d = 1'b0;
        xact_for_us_d = 1'b0;
        xfer_for_us_d = 1'b0;
        nack_transaction_d = 1'b0;
      end

      /////////////////
      // TARGET MODE //
      /////////////////

      // AcquireStart: hold for the end of the start condition
      AcquireStart : begin
        target_idle_o = 1'b0;
        xfer_for_us_d = 1'b0;
        auto_ack_cnt_d = '0;
      end
      // AddrRead: read and compare target address
      AddrRead : begin
        target_idle_o = 1'b0;
        rw_bit = input_byte[0];

        if (bit_ack) begin
          if (address_match) begin
            xact_for_us_d = 1'b1;
            xfer_for_us_d = 1'b1;
          end
        end
      end
      // AddrAckWait: pause for hold time before acknowledging
      AddrAckWait : begin
        target_idle_o = 1'b0;

        if (scl_i) begin
          // The controller is going too fast. Abandon the transaction.
          // Nothing gets recorded for this case.
          nack_transaction_d = 1'b1;
        end
      end
      // AddrAckSetup: target pulls SDA low while SCL is low
      AddrAckSetup : begin
        target_idle_o = 1'b0;
        sda_d = 1'b0;
        transmitting_o = 1'b1;
      end
      // AddrAckPulse: target pulls SDA low while SCL is released
      AddrAckPulse : begin
        target_idle_o = 1'b0;
        sda_d = 1'b0;
        transmitting_o = 1'b1;
      end
      // AddrAckHold: target pulls SDA low while SCL is pulled low
      AddrAckHold : begin
        target_idle_o = 1'b0;
        sda_d = 1'b0;
        transmitting_o = 1'b1;

        // Upon transition to next state, populate the acquisition fifo
        if (tcount_q == 16'd1) begin
          if (nack_transaction_q) begin
            // No need to record anything here. We already recorded the first
            // NACK'd byte in a stretch state or abandoned the transaction in
            // AddrAckWait.
          end else if (!stretch_addr) begin
            // Only write to fifo if stretching conditions are not met
            acq_fifo_wvalid_o = 1'b1;
            event_read_cmd_received_o = rw_bit_q;
          end

          if (restart_det_q) begin
            acq_fifo_wdata_o = {AcqRestart, input_byte};
          end else begin
            acq_fifo_wdata_o = {AcqStart, input_byte};
          end
        end
      end
      // TransmitWait: Check if data is available prior to transmit
      TransmitWait : begin
        target_idle_o = 1'b0;
      end
      // TransmitSetup: target shifts indexed bit onto SDA while SCL is low
      TransmitSetup : begin
        target_idle_o = 1'b0;
        sda_d = tx_fifo_rdata[3'(bit_idx)];
        transmitting_o = 1'b1;
      end
      // TransmitPulse: target holds indexed bit onto SDA while SCL is released
      TransmitPulse : begin
        target_idle_o = 1'b0;

        // Hold value
        sda_d = sda_q;
        transmitting_o = 1'b1;
      end
      // TransmitHold: target holds indexed bit onto SDA while SCL is pulled low, for the hold time
      TransmitHold : begin
        target_idle_o = 1'b0;

        // Hold value
        sda_d = sda_q;
        transmitting_o = 1'b1;
      end
      // TransmitAck: target waits for host to ACK transmission
      TransmitAck : begin
        target_idle_o = 1'b0;
      end
      TransmitAckPulse : begin
        target_idle_o = 1'b0;
        if (!scl_i) begin
          // Pop Fifo regardless of ack/nack
          tx_fifo_rready_o = 1'b1;
        end
      end
      // WaitForStop just waiting for host to trigger a stop after nack
      WaitForStop : begin
        target_idle_o = 1'b0;
        expect_stop = 1'b1;
        sda_d = 1'b1;
      end
      // AcquireByte: target acquires a byte
      AcquireByte : begin
        target_idle_o = 1'b0;
      end
      // AcquireAckWait: pause before acknowledging
      AcquireAckWait : begin
        target_idle_o = 1'b0;
        if (scl_i) begin
          // The controller is going too fast. Abandon the transaction.
          // Nothing is recorded for this case.
          nack_transaction_d = 1'b1;
        end
      end
      // AcquireAckSetup: target pulls SDA low while SCL is low
      AcquireAckSetup : begin
        target_idle_o = 1'b0;
        sda_d = 1'b0;
        transmitting_o = 1'b1;
      end
      // AcquireAckPulse: target pulls SDA low while SCL is released
      AcquireAckPulse : begin
        target_idle_o = 1'b0;
        sda_d = 1'b0;
        transmitting_o = 1'b1;
      end
      // AcquireAckHold: target pulls SDA low while SCL is pulled low
      AcquireAckHold : begin
        target_idle_o = 1'b0;
        sda_d = 1'b0;
        transmitting_o = 1'b1;

        if (tcount_q == 16'd1) begin
          auto_ack_cnt_d = auto_ack_cnt_q - 1'b1;
          acq_fifo_wvalid_o = ~stretch_rx;          // assert that acq_fifo has space
          acq_fifo_wdata_o = {AcqData, input_byte}; // transfer data to acq_fifo
        end
      end
      // StretchAddrAck: target stretches the clock if matching address cannot be
      // deposited yet. (During ACK phase)
      StretchAddrAck : begin
        target_idle_o = 1'b0;
        scl_d = 1'b0;
        actively_stretching = stretch_addr;

        if (nack_timeout) begin
          nack_transaction_d = 1'b1;
          // Record NACK'd Start bytes as long as there is space.
          // The next state is always WaitForStop, so the ACQ FIFO needs to be
          // written here.
          acq_fifo_wvalid_o = !acq_fifo_full_or_last_space;
          acq_fifo_wdata_o = {AcqNackStart, input_byte};
        end
      end
      // StretchAddrAckSetup: target pulls SDA low while pulling SCL low for
      // setup time. This is to prepare the setup time after a stretch.
      StretchAddrAckSetup : begin
        target_idle_o = 1'b0;
        sda_d = 1'b0;
        scl_d = 1'b0;
        transmitting_o = 1'b1;
      end
      // StretchAddr: target stretches the clock if matching address cannot be
      // deposited yet.
      StretchAddr : begin
        target_idle_o = 1'b0;
        scl_d = 1'b0;
        actively_stretching = stretch_addr;

        if (nack_timeout) begin
          nack_transaction_d = 1'b1;
          // Record NACK'd Start bytes as long as there is space.
          // The next state is always WaitForStop, so the ACQ FIFO needs to be
          // written here.
          acq_fifo_wvalid_o = !acq_fifo_full_or_last_space;
          acq_fifo_wdata_o = {AcqNackStart, input_byte};
        end else if (!stretch_addr) begin
          acq_fifo_wvalid_o = 1'b1;
          if (restart_det_q) begin
            acq_fifo_wdata_o = {AcqRestart, input_byte};
          end else begin
            acq_fifo_wdata_o = {AcqStart, input_byte};
          end
        end
      end
      // StretchTx: target stretches the clock when tx_fifo is empty
      StretchTx : begin
        target_idle_o = 1'b0;
        scl_d = 1'b0;
        actively_stretching = stretch_tx;

        if (nack_timeout) begin
          // Only the NackStop will get recorded (later) to provide ACQ FIFO
          // history of the failed transaction. Meanwhile, the NACK timeout
          // will still get reported.
          nack_transaction_d = 1'b1;
        end
      end
      // StretchTxSetup: drive the return data
      StretchTxSetup : begin
        target_idle_o = 1'b0;
        scl_d = 1'b0;
        sda_d = tx_fifo_rdata[3'(bit_idx)];
        transmitting_o = 1'b1;
      end
      // StretchAcqFull: target stretches the clock when acq_fifo is full
      StretchAcqFull : begin
        target_idle_o = 1'b0;
        scl_d = 1'b0;
        ack_ctrl_stretching = !can_auto_ack;
        actively_stretching = stretch_rx;


        if (nack_timeout || (sw_nack_i && !can_auto_ack)) begin
          nack_transaction_d = 1'b1;
          acq_fifo_wvalid_o = !acq_fifo_full_or_last_space;
          acq_fifo_wdata_o = {AcqNack, input_byte};
        end
      end
      // StretchAcqSetup: Drive the ACK and wait for tSetupData before
      // releasing SCL
      StretchAcqSetup : begin
        target_idle_o = 1'b0;
        scl_d = 1'b0;
        sda_d = 1'b0;
        transmitting_o = 1'b1;
      end
      // default
      default : begin
        target_idle_o = 1'b1;
        sda_d = 1'b1;
        scl_d = 1'b1;
        transmitting_o = 1'b0;
        tx_fifo_rready_o = 1'b0;
        acq_fifo_wvalid_o = 1'b0;
        acq_fifo_wdata_o = ACQ_FIFO_WIDTH'(0);
        event_cmd_complete_o = 1'b0;
        restart_det_d = 1'b0;
        xact_for_us_d = 1'b0;
        auto_ack_cnt_d = '0;
        ack_ctrl_stretching = 1'b0;
        nack_transaction_d = 1'b0;
        actively_stretching = 1'b0;
      end
    endcase // unique case (state_q)

    // start / stop override
    if (target_enable_i && (stop_detect_i || bus_timeout_i)) begin
      event_cmd_complete_o = xfer_for_us_q;
      event_tx_bus_timeout_o = bus_timeout_i && rw_bit_q;
      // Note that we assume the ACQ FIFO can accept a new item and will
      // receive the arbiter grant without delay. No other FIFOs should have
      // activity during a Start or Stop symbol.
      // TODO: Add an assertion.
      acq_fifo_wvalid_o = xact_for_us_q;
      if (nack_transaction_q || bus_timeout_i) begin
        acq_fifo_wdata_o = {AcqNackStop, input_byte};
      end else begin
        acq_fifo_wdata_o = {AcqStop, input_byte};
      end
    end else if (target_enable_i && start_detect_i) begin
      restart_det_d = !target_idle_o;
      event_cmd_complete_o = xfer_for_us_q;
    end else if (arbitration_lost_i) begin
      nack_transaction_d = 1'b1;
      event_cmd_complete_o = xfer_for_us_q;
      event_tx_arbitration_lost_o = rw_bit_q;
    end
  end

  assign stretch_rx   = !acq_fifo_plenty_space || !can_auto_ack;
  assign stretch_addr = !acq_fifo_plenty_space;

  // This condition determines whether this target has stretched beyond the
  // timeout in which case it must now send a NACK to the host.
  assign nack_timeout = nack_timeout_en_i && stretch_active_cnt >= nack_timeout_i;

  // Stretch Tx phase when:
  // 1. When there is no data to return to host
  // 2. When the acq_fifo contains any entry other than a singular start condition
  //    read command.
  // 3. When there are unhandled events set in the TX_EVENTS CSR. This is
  //    a synchronization point with software, which needs to clear them
  //    first.
  //
  // Besides the unhandled events, only the fifo depth is checked here, because
  // stretch_tx is only evaluated by the fsm on the read path. This means a read
  // start byte has already been deposited, and there is no need for checking
  // the value of the current state for this signal.
  assign stretch_tx = !tx_fifo_rvalid_i || unhandled_tx_stretch_event_i ||
                      (acq_fifo_depth_i > AcqFifoDepthWidth'(1'b1));

  // Only used for assertion
  logic unused_acq_rdata;
  assign unused_acq_rdata = |acq_fifo_rdata_i;

  // Conditional state transition
  always_comb begin : state_functions
    state_d = state_q;
    load_tcount = 1'b0;
    tcount_sel = tNoDelay;
    input_byte_clr = 1'b0;
    event_tx_stretch_o = 1'b0;

    unique case (state_q)
      // Idle: initial state, SDA and SCL are released (high)
      Idle : begin
        // The bus is idle. Waiting for a Start.
      end

      /////////////////
      // TARGET MODE //
      /////////////////

      // AcquireStart: hold for the end of the start condition
      AcquireStart : begin
        if (!scl_i) begin
          state_d = AddrRead;
          input_byte_clr = 1'b1;
        end
      end
      // AddrRead: read and compare target address
      AddrRead : begin
        // bit_ack goes high the cycle after scl_i goes low, after the 8th bit
        // was captured.
        if (bit_ack) begin
          if (address_match) begin
            state_d = AddrAckWait;
            // Wait for hold time to avoid interfering with the controller.
            load_tcount = 1'b1;
            tcount_sel = tHoldData;
          end else begin // !address_match
            // This means this transfer is not meant for us.
            state_d = WaitForStop;
          end
        end
      end
      // AddrAckWait: pause for hold time before acknowledging
      AddrAckWait : begin
        if (scl_i) begin
          // The controller is going too fast. Abandon the transaction.
          state_d = WaitForStop;
        end else if (tcount_q == 16'd1) begin
          if (!nack_addr_after_timeout_i) begin
            // Always ACK addresses in this mode.
            state_d = AddrAckSetup;
          end else begin
            if (nack_transaction_q) begin
              // We must have stretched before, and software has been notified
              // through an ACQ FIFO full event. For writes we should NACK all
              // bytes in the transfer unconditionally. For reads, we NACK
              // the address byte, then release SDA for the rest of the
              // transfer.
              // Essentially, we're waiting for the end of the transaction.
              state_d = WaitForStop;
            end else if (stretch_addr) begin
              // Not enough bytes to capture the Start/address byte, but might
              // need to NACK.
              state_d = StretchAddrAck;
            end else begin
              // The transaction hasn't already been NACK'd, and there is
              // room in the ACQ FIFO. Proceed.
              state_d = AddrAckSetup;
            end
          end
        end
      end
      // AddrAckSetup: target pulls SDA low while SCL is low
      AddrAckSetup : begin
        if (scl_i) state_d = AddrAckPulse;
      end
      // AddrAckPulse: target pulls SDA low while SCL is released
      AddrAckPulse : begin
        if (!scl_i) begin
          state_d = AddrAckHold;
          load_tcount = 1'b1;
          tcount_sel = tHoldData;
        end
      end
      // AddrAckHold: target pulls SDA low while SCL is pulled low
      AddrAckHold : begin
        if (tcount_q == 16'd1) begin
          // Stretch when requested by software or when there is insufficient
          // space to hold the start / address format byte.
          // If there is sufficient space, the format byte is written into the acquisition fifo.
          // Don't stretch when we are unconditionally nacking the next byte
          // anyways.
          if (nack_transaction_q) begin
            // If the Target is set to NACK already, release SDA and wait
            // for a Stop. This isn't an ideal response for SMBus reads, since
            // 127 bytes of 0xff will just happen to have a correct PEC. It's
            // best for software to ensure there is always space in the ACQ
            // FIFO.
            state_d = WaitForStop;
          end else if (stretch_addr) begin // !nack_transaction_q
            // Stretching because there is insufficient space to hold the
            // start / address format byte.
            // We should only reach here with !nack_addr_after_timeout_i, since
            // we had enough space for nack_addr_after_timeout_i already,
            // before issuing the ACK.
            state_d = StretchAddr;
          end else if (rw_bit_q) begin
            // Not NACKing automatically, not stretching, and it's a read.
            state_d = TransmitWait;
          end else begin
            // Not NACKing automatically, not stretching, and it's a write.
            state_d = AcquireByte;
          end
        end
      end
      // TransmitWait: Evaluate whether there are entries to send first
      TransmitWait : begin
        if (stretch_tx) begin
          state_d = StretchTx;
        end else begin
          state_d = TransmitSetup;
        end
      end
      // TransmitSetup: target shifts indexed bit onto SDA while SCL is low
      TransmitSetup : begin
        if (scl_i) state_d = TransmitPulse;
      end
      // TransmitPulse: target shifts indexed bit onto SDA while SCL is released
      TransmitPulse : begin
        if (!scl_i) begin
          state_d = TransmitHold;
          load_tcount = 1'b1;
          tcount_sel = tHoldData;
        end
      end
      // TransmitHold: target shifts indexed bit onto SDA while SCL is pulled low
      TransmitHold : begin
        if (tcount_q == 16'd1) begin
          if (bit_ack) begin
            state_d = TransmitAck;
          end else begin
            load_tcount = 1'b1;
            tcount_sel = tHoldData;
            state_d = TransmitSetup;
          end
        end
      end
      // Wait for clock to become positive.
      TransmitAck : begin
        if (scl_i) begin
          state_d = TransmitAckPulse;
        end
      end
      // TransmitAckPulse: target waits for host to ACK transmission
      // If a nak is received, that means a stop is incoming.
      TransmitAckPulse : begin
        if (!scl_i) begin
          // If host acknowledged, that means we must continue
          if (host_ack) begin
            state_d = TransmitWait;
          end else begin
            // If host nak'd then the transaction is about to terminate, go to a wait state
            state_d = WaitForStop;
          end
        end
      end
      // An inert state just waiting for host to issue a stop
      // Cannot cycle back to idle directly as other events depend on the system being
      // non-idle.
      WaitForStop : begin
        state_d = WaitForStop;
      end
      // AcquireByte: target acquires a byte
      AcquireByte : begin
        if (bit_ack) begin
          state_d = AcquireAckWait;
          load_tcount = 1'b1;
          tcount_sel = tHoldData;
        end
      end
      // AcquireAckWait: pause for hold time before acknowledging
      AcquireAckWait : begin
        if (scl_i) begin
          // The controller is going too fast. Abandon the transaction.
          state_d = WaitForStop;
        end else if (tcount_q == 16'd1) begin
          if (nack_transaction_q) begin
            state_d = WaitForStop;
          end else if (stretch_rx) begin
            // If there is no space for the current entry, stretch clocks and
            // wait for software to make space. Also stretch if ACK Control
            // Mode is enabled and the auto_ack_cnt is exhausted.
            state_d = StretchAcqFull;
          end else begin
            state_d = AcquireAckSetup;
          end
        end
      end
      // AcquireAckSetup: target pulls SDA low while SCL is low
      AcquireAckSetup : begin
        if (scl_i) state_d = AcquireAckPulse;
      end
      // AcquireAckPulse: target pulls SDA low while SCL is released
      AcquireAckPulse : begin
        if (!scl_i) begin
          state_d = AcquireAckHold;
          load_tcount = 1'b1;
          tcount_sel = tHoldData;
        end
      end
      // AcquireAckHold: target pulls SDA low while SCL is pulled low
      AcquireAckHold : begin
        if (tcount_q == 16'd1) begin
          state_d = AcquireByte;
        end
      end
      // StretchAddrAck: The address phase can not yet be completed, stretch
      // clock and wait.
      StretchAddrAck : begin
        // When there is space in the FIFO go to the next state.
        // If we hit our nack timeout, we must nack the full transaction.
        if (nack_timeout) begin
          state_d = WaitForStop;
        end else if (!stretch_addr) begin
          state_d = StretchAddrAckSetup;
          load_tcount = 1'b1;
          tcount_sel = tSetupData;
        end
      end
      // StretchAddrAckSetup: target pulls SDA low while pulling SCL low for
      // setup time. This is to prepare the setup time after a stretch.
      StretchAddrAckSetup : begin
        if (tcount_q == 16'd1) begin
          state_d = AddrAckSetup;
        end
      end
      // StretchAddr: The address phase can not yet be completed, stretch
      // clock and wait.
      StretchAddr : begin
        // When there is space in the FIFO go to the next state.
        // If we hit our nack timeout, we must nack the full transaction.
        if (nack_timeout) begin
          state_d = WaitForStop;
        end else if (!stretch_addr) begin
          // When transmitting after an address stretch, we need to assume
          // that it looks like a Tx stretch.  This is because if we try
          // to follow the normal path, the logic will release the clock
          // too early relative to driving the data.  This will cause a
          // setup violation.  This is the same case to needing StretchTxSetup.
          state_d = rw_bit_q ? StretchTx : AcquireByte;
        end
      end
      // StretchTx: target stretches the clock when tx conditions are not satisfied.
      StretchTx : begin
        // When in stretch state, always notify software that help is required.
        event_tx_stretch_o = 1'b1;
        if (nack_timeout) begin
          state_d = WaitForStop;
        end else if (!stretch_tx) begin
          // When data becomes available, we must first drive it onto the line
          // for at least the "setup" period.  If we do not, once the clock is released, the
          // pull-up in the system will likely immediately trigger a rising clock
          // edge (since the stretch likely pushed us way beyond the original intended
          // rise).  If we do not artificially create the setup period here, it will
          // likely create a timing violation.
          state_d = StretchTxSetup;
          load_tcount = 1'b1;
          tcount_sel = tSetupData;

          // When leaving stretch state, de-assert software notification
          event_tx_stretch_o = 1'b0;
        end
      end
      // StretchTxSetup: Wait for tSetupData before going to transmit
      StretchTxSetup : begin
        if (tcount_q == 16'd1) begin
          state_d = TransmitSetup;
        end
      end
      // StretchAcqFull: target stretches the clock when acq_fifo is full
      // When space becomes available, move on to prepare to ACK. If we hit
      // our NACK timeout we must continue and unconditionally NACK the next
      // one.
      // If ACK Control Mode is enabled, also stretch if the Auto ACK counter
      // is exhausted. If the conditions for an ACK Control stretch are
      // present, NACK the transaction if directed by SW.
      StretchAcqFull : begin
        if (nack_timeout || (sw_nack_i && !can_auto_ack)) begin
          state_d = WaitForStop;
        end else if (~stretch_rx) begin
          state_d = StretchAcqSetup;
          load_tcount = 1'b1;
          tcount_sel = tSetupData;
        end
      end
      // StretchAcqSetup: Drive the ACK and wait for tSetupData before
      // releasing SCL
      StretchAcqSetup : begin
        if (tcount_q == 16'd1) begin
          state_d = AcquireAckSetup;
        end
      end
      // default
      default : begin
        state_d = Idle;
        load_tcount = 1'b0;
        tcount_sel = tNoDelay;
        input_byte_clr = 1'b0;
        event_tx_stretch_o = 1'b0;
      end
    endcase // unique case (state_q)

    // When a start is detected, always go to the acquire start state.
    // Differences in repeated start / start handling are done in the
    // other FSM.
    if (!target_idle && !target_enable_i) begin
      // If the target function is currently not idle but target_enable is suddenly dropped,
      // (maybe because the host locked up and we want to cycle back to an initial state),
      // transition immediately.
      // The same treatment is not given to the host mode because it already attempts to
      // gracefully terminate.  If the host cannot gracefully terminate for whatever reason,
      // (the other side is holding SCL low), we may need to forcefully reset the module.
      // ICEBOX(#18004): It may be worth having a force stop condition to force the host back to
      // Idle in case graceful termination is not possible.
      state_d = Idle;
    end else if (target_enable_i && start_detect_i) begin
      state_d = AcquireStart;
    end else if (stop_detect_i || bus_timeout_i) begin
      state_d = Idle;
    end else if (arbitration_lost_i) begin
      state_d = WaitForStop;
    end
  end

  // Synchronous state transition
  always_ff @ (posedge clk_i or negedge rst_ni) begin : state_transition
    if (!rst_ni) begin
      state_q <= Idle;
    end else begin
      state_q <= state_d;
    end
  end

  // Saved sda output used in certain states.
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      sda_q <= 1'b1;
    end else begin
      sda_q <= sda_d;
    end
  end

  assign scl_o = scl_d;
  assign sda_o = sda_d;

  // Fed out for interrupt purposes
  assign acq_fifo_full_o = !acq_fifo_plenty_space;

  // Make sure we never attempt to send a single cycle glitch
  

  // If we are actively transmitting, that must mean that there are no
  // unhandled write commands and if there is a command present it must be
  // a read.
  

  // Check that ACQ FIFO is deep enough to support a stop/rstart as well as
  // a nack when it is full.
  

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description: I2C top level wrapper file

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macros and helper code for using assertions.
//  - Provides default clk and rst options to simplify code
//  - Provides boiler plate template for common assertions



///////////////////
// Helper macros //
///////////////////

// Default clk and reset signals used by assertion macros below.



// Converts an arbitrary block of code into a Verilog string


// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.


// This macro is suitable for conditionally triggering lint errors, e.g., if a Sec parameter takes
// on a non-default value. This may be required for pre-silicon/FPGA evaluation but we don't want
// to allow this for tapeout.


// Static assertions for checks inside SV packages. If the conditions is not true, this will
// trigger an error during elaboration.


// The basic helper macros are actually defined in "implementation headers". The macros should do
// the same thing in each case (except for the dummy flavour), but in a way that the respective
// tools support.
//
// If the tool supports assertions in some form, we also define INC_ASSERT (which can be used to
// hide signal definitions that are only used for assertions).
//
// The list of basic macros supported is:
//
//  ASSERT_I:     Immediate assertion. Note that immediate assertions are sensitive to simulation
//                glitches.
//
//  ASSERT_INIT:  Assertion in initial block. Can be used for things like parameter checking.
//
//  ASSERT_INIT_NET: Assertion in initial block. Can be used for initial value of a net.
//
//  ASSERT_FINAL: Assertion in final block. Can be used for things like queues being empty at end of
//                sim, all credits returned at end of sim, state machines in idle at end of sim.
//
//  ASSERT_AT_RESET: Assertion just before reset. Can be used to check sum-like properties that get
//                   cleared at reset.
//                   Note that unless your simulation ends with a reset, the property does not get
//                   checked at end of simulation; use ASSERT_AT_RESET_AND_FINAL if the property
//                   should also get checked at end of simulation.
//
//  ASSERT_AT_RESET_AND_FINAL: Assertion just before reset and in final block. Can be used to check
//                             sum-like properties before every reset and at the end of simulation.
//
//  ASSERT:       Assert a concurrent property directly. It can be called as a module (or
//                interface) body item.
//
//                Note: We use (__rst !== '0) in the disable iff statements instead of (__rst ==
//                '1). This properly disables the assertion in cases when reset is X at the
//                beginning of a simulation. For that case, (reset == '1) does not disable the
//                assertion.
//
//  ASSERT_NEVER: Assert a concurrent property NEVER happens
//
//  ASSERT_KNOWN: Assert that signal has a known value (each bit is either '0' or '1') after reset.
//                It can be called as a module (or interface) body item.
//
//  COVER:        Cover a concurrent property
//
//  ASSUME:       Assume a concurrent property
//
//  ASSUME_I:     Assume an immediate property

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Macro bodies included by prim_assert.sv for tools that don't support assertions. See
// prim_assert.sv for documentation for each of the macros.
















//////////////////////////////
// Complex assertion macros //
//////////////////////////////

// Assert that signal is an active-high pulse with pulse length of 1 clock cycle


// Assert that a property is true only when an enable signal is set.  It can be called as a module
// (or interface) body item.


// Assert that signal has a known value (each bit is either '0' or '1') after reset if enable is
// set.  It can be called as a module (or interface) body item.


//////////////////////////////////
// For formal verification only //
//////////////////////////////////

// Note that the existing set of ASSERT macros specified above shall be used for FPV,
// thereby ensuring that the assertions are evaluated during DV simulations as well.

// ASSUME_FPV
// Assume a concurrent property during formal verification only.


// ASSUME_I_FPV
// Assume a concurrent property during formal verification only.


// COVER_FPV
// Cover a concurrent property during formal verification


// FPV assertion that proves that the FSM control flow is linear (no loops)
// The sequence triggers whenever the state changes and stores the current state as "initial_state".
// Then thereafter we must never see that state again until reset.
// It is possible for the reset to release ahead of the clock.
// Create a small "gray" window beyond the usual rst time to avoid
// checking.


// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// // Macros and helper code for security countermeasures.





// When a named error signal rises, expect to see an associated error in at most MAX_CYCLES_ cycles.
//
// The NAME_ argument gets included in the name of the generated assertion, following an FpSecCm
// prefix. The error signal should be at HIER_.ERR_NAME_ and the posedge is ignored if GATE_ is
// true.
//
// This macro drives a magic "unused_assert_connected" signal, which is used for a static check to
// ensure the assertions are in place.


// When an error signal rises, expect to see the associated alert in at most MAX_CYCLE_ cycles.
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR. The ALERT_ argument is the name of the alert that we expect to be
// asserted.
//
// This macro adds an assumption that says the named error signal will stay low for the first 10
// cycles after reset.


// When an error signal rises, expect to see the associated ALERT_IN_ signal go high in at most
// MAX_CYCLES_
//
// This is expected to cause an alert to be signalled, but avoids needing to reason about the
// internals of the alert sender (which are checked with formal properties in the prim_alert_rxtx*
// cores).
//
// The NAME_, HIER_, GATE_, MAX_CYCLES_ and ERR_NAME_ arguments are the same as for
// `ASSERT_ERROR_TRIGGER_ERR.


////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger alerts
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// The input flavour of assertions for CMs that trigger alerts
//
// Note that the default value for MAX_CYCLES_ in these assertions is much smaller than
// _SEC_CM_ALERT_MAX_CYC. Because we are asserting something about the *input* for the alert system,
// the timing can be much tighter: we default to two cycles.
//
////////////////////////////////////////////////////////////////////////////////













////////////////////////////////////////////////////////////////////////////////
//
// Assertions for CMs that trigger some other form of error
//
////////////////////////////////////////////////////////////////////////////////











 // PRIM_ASSERT_SEC_CM_SVH

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0



/////////////////////////////////////
// Default Values for Macros below //
/////////////////////////////////////





/////////////////////
// Register Macros //
/////////////////////

// TODO: define other variations of register macros so that they can be used throughout all designs
// to make the code more concise.

// Register with asynchronous reset.


///////////////////////////
// Macro for Sparse FSMs //
///////////////////////////

// Simulation tools typically infer FSMs and report coverage for these separately. However, tools
// like Xcelium and VCS seem to have problems inferring FSMs if the state register is not coded in
// a behavioral always_ff block in the same hierarchy. To that end, this uses a modified variant
// with a second behavioral register definition for RTL simulations so that FSMs can be inferred.
// Note that in this variant, the __q output is disconnected from prim_sparse_fsm_flop and attached
// to the behavioral flop. An assertion is added to ensure equivalence between the
// prim_sparse_fsm_flop output and the behavioral flop output in that case.


 // PRIM_FLOP_MACROS_SV


 // PRIM_ASSERT_SV


module i2c
  import i2c_reg_pkg::*;
#(
  parameter logic [NumAlerts-1:0]           AlertAsyncOn              = {NumAlerts{1'b1}},
  // Number of cycles a differential skew is tolerated on the alert signal
  parameter int unsigned                    AlertSkewCycles           = 1,
  parameter int unsigned                    InputDelayCycles          = 0,
  parameter bit                             EnableRacl                = 1'b0,
  parameter bit                             RaclErrorRsp              = EnableRacl,
  parameter top_racl_pkg::racl_policy_sel_t RaclPolicySelVec[NumRegs] = '{NumRegs{0}}
) (
  input                                    clk_i,
  input                                    rst_ni,
  input  prim_ram_1p_pkg::ram_1p_cfg_t     ram_cfg_i,
  output prim_ram_1p_pkg::ram_1p_cfg_rsp_t ram_cfg_rsp_o,

  // Bus Interface
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,

  // Alerts
  input  prim_alert_pkg::alert_rx_t [NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t [NumAlerts-1:0] alert_tx_o,

  // RACL interface
  input  top_racl_pkg::racl_policy_vec_t racl_policies_i,
  output top_racl_pkg::racl_error_log_t  racl_error_o,

  // Generic IO
  input                     cio_scl_i,
  output logic              cio_scl_o,
  output logic              cio_scl_en_o,
  input                     cio_sda_i,
  output logic              cio_sda_o,
  output logic              cio_sda_en_o,

  output logic              lsio_trigger_o,

  // Interrupts
  output logic              intr_fmt_threshold_o,
  output logic              intr_rx_threshold_o,
  output logic              intr_acq_threshold_o,
  output logic              intr_rx_overflow_o,
  output logic              intr_controller_halt_o,
  output logic              intr_scl_interference_o,
  output logic              intr_sda_interference_o,
  output logic              intr_stretch_timeout_o,
  output logic              intr_sda_unstable_o,
  output logic              intr_cmd_complete_o,
  output logic              intr_tx_stretch_o,
  output logic              intr_tx_threshold_o,
  output logic              intr_acq_stretch_o,
  output logic              intr_unexp_stop_o,
  output logic              intr_host_timeout_o
);

  i2c_reg2hw_t reg2hw;
  i2c_hw2reg_t hw2reg;

  logic [NumAlerts-1:0] alert_test, alerts;

  i2c_reg_top #(
    .EnableRacl(EnableRacl),
    .RaclErrorRsp(RaclErrorRsp),
    .RaclPolicySelVec(RaclPolicySelVec)
  ) u_reg (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o,
    .reg2hw,
    .hw2reg,
    .racl_policies_i,
    .racl_error_o,
    // SEC_CM: BUS.INTEGRITY
    .intg_err_o(alerts[0])
  );

  assign alert_test = {
    reg2hw.alert_test.q &
    reg2hw.alert_test.qe
  };

  for (genvar i = 0; i < NumAlerts; i++) begin : gen_alert_tx
    prim_alert_sender #(
      .AsyncOn(AlertAsyncOn[i]),
      .SkewCycles(AlertSkewCycles),
      .IsFatal(1'b1)
    ) u_prim_alert_sender (
      .clk_i,
      .rst_ni,
      .alert_test_i  ( alert_test[i] ),
      .alert_req_i   ( alerts[0]     ),
      .alert_ack_o   (               ),
      .alert_state_o (               ),
      .alert_rx_i    ( alert_rx_i[i] ),
      .alert_tx_o    ( alert_tx_o[i] )
    );
  end

  logic scl_int;
  logic sda_int;

  i2c_core #(
    .InputDelayCycles(InputDelayCycles)
  ) i2c_core (
    .clk_i,
    .rst_ni,
    .ram_cfg_i,
    .ram_cfg_rsp_o,

    .reg2hw,
    .hw2reg,

    .scl_i(cio_scl_i),
    .scl_o(scl_int),
    .sda_i(cio_sda_i),
    .sda_o(sda_int),

    .lsio_trigger_o,

    .intr_fmt_threshold_o,
    .intr_rx_threshold_o,
    .intr_acq_threshold_o,
    .intr_rx_overflow_o,
    .intr_controller_halt_o,
    .intr_scl_interference_o,
    .intr_sda_interference_o,
    .intr_stretch_timeout_o,
    .intr_sda_unstable_o,
    .intr_cmd_complete_o,
    .intr_tx_stretch_o,
    .intr_tx_threshold_o,
    .intr_acq_stretch_o,
    .intr_unexp_stop_o,
    .intr_host_timeout_o
  );

  // For I2C, in standard, fast and fast-plus modes, outputs simulated as open-drain outputs.
  // Asserting scl or sda high should be equivalent to a tri-state output.
  // The output, when enabled, should only assert low.

  assign cio_scl_o = 1'b0;
  assign cio_sda_o = 1'b0;

  assign cio_scl_en_o = ~scl_int;
  assign cio_sda_en_o = ~sda_int;

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  // Alert assertions for reg_we onehot check
                                                                                     
                        
  
endmodule
