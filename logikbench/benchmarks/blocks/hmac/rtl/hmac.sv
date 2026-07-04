// Compiled by morty-0.9.0 / 2026-06-23 22:55:16.778007409 -04:00

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

package prim_sha2_pkg;

  localparam int NumRound256 = 64;   // SHA-224, SHA-256
  localparam int NumRound512 = 80;   // SHA-512, SHA-384

  typedef logic [31:0] sha_word32_t;
  typedef logic [63:0] sha_word64_t;

  localparam int WordByte32 = $bits(sha_word32_t)/8;
  localparam int WordByte64 = $bits(sha_word64_t)/8;

  typedef struct packed {
    sha_word32_t           data;
    logic [WordByte32-1:0] mask; // 4 mask bits: to mask off bytes if this is not word-aligned
                                 // set to all-1 for word-aligned input
  } sha_fifo32_t;

  typedef struct packed {
    sha_word64_t           data;
    logic [WordByte64-1:0] mask; // 8 mask bits: to mask off bytes if this is not word-aligned
                                 // set to all-1 for word-aligned input
  } sha_fifo64_t;

  typedef enum logic [1:0] {
    FifoIdle,
    FifoLoadFromFifo,
    FifoWait
  } fifoctl_state_e;

  // one-hot encoded
  typedef enum logic [3:0] {
    SHA2_256  = 4'b0001,
    SHA2_384  = 4'b0010,
    SHA2_512  = 4'b0100,
    SHA2_None = 4'b1000
  } digest_mode_e;

  // one-hot encoded
  typedef enum logic [5:0] {
    Key_128  = 6'b00_0001,
    Key_256  = 6'b00_0010,
    Key_384  = 6'b00_0100,
    Key_512  = 6'b00_1000,
    Key_1024 = 6'b01_0000,
    Key_None = 6'b10_0000
  } key_length_e;

  localparam sha_word32_t InitHash_256 [8]= '{
    32'h 6a09_e667, 32'h bb67_ae85, 32'h 3c6e_f372, 32'h a54f_f53a,
    32'h 510e_527f, 32'h 9b05_688c, 32'h 1f83_d9ab, 32'h 5be0_cd19
  };

  localparam sha_word64_t InitHash_384 [8]= '{
    64'h cbbb_9d5d_c105_9ed8, 64'h 629a_292a_367c_d507, 64'h 9159_015a_3070_dd17,
    64'h 152f_ecd8_f70e_5939, 64'h 6733_2667_ffc0_0b31, 64'h 8eb4_4a87_6858_1511,
    64'h db0c_2e0d_64f9_8fa7, 64'h 47b5_481d_befa_4fa4
  };

  localparam sha_word64_t InitHash_512 [8]= '{
    64'h 6a09_e667_f3bc_c908, 64'h bb67_ae85_84ca_a73b, 64'h 3c6e_f372_fe94_f82b,
    64'h a54f_f53a_5f1d_36f1, 64'h 510e_527f_ade6_82d1, 64'h 9b05_688c_2b3e_6c1f,
    64'h 1f83_d9ab_fb41_bd6b, 64'h 5be0_cd19_137e_2179
  };

  // SHA-256 constants
  localparam sha_word32_t CubicRootPrime256 [NumRound256] = '{
    32'h 428a_2f98, 32'h 7137_4491, 32'h b5c0_fbcf, 32'h e9b5_dba5,
    32'h 3956_c25b, 32'h 59f1_11f1, 32'h 923f_82a4, 32'h ab1c_5ed5,
    32'h d807_aa98, 32'h 1283_5b01, 32'h 2431_85be, 32'h 550c_7dc3,
    32'h 72be_5d74, 32'h 80de_b1fe, 32'h 9bdc_06a7, 32'h c19b_f174,
    32'h e49b_69c1, 32'h efbe_4786, 32'h 0fc1_9dc6, 32'h 240c_a1cc,
    32'h 2de9_2c6f, 32'h 4a74_84aa, 32'h 5cb0_a9dc, 32'h 76f9_88da,
    32'h 983e_5152, 32'h a831_c66d, 32'h b003_27c8, 32'h bf59_7fc7,
    32'h c6e0_0bf3, 32'h d5a7_9147, 32'h 06ca_6351, 32'h 1429_2967,
    32'h 27b7_0a85, 32'h 2e1b_2138, 32'h 4d2c_6dfc, 32'h 5338_0d13,
    32'h 650a_7354, 32'h 766a_0abb, 32'h 81c2_c92e, 32'h 9272_2c85,
    32'h a2bf_e8a1, 32'h a81a_664b, 32'h c24b_8b70, 32'h c76c_51a3,
    32'h d192_e819, 32'h d699_0624, 32'h f40e_3585, 32'h 106a_a070,
    32'h 19a4_c116, 32'h 1e37_6c08, 32'h 2748_774c, 32'h 34b0_bcb5,
    32'h 391c_0cb3, 32'h 4ed8_aa4a, 32'h 5b9c_ca4f, 32'h 682e_6ff3,
    32'h 748f_82ee, 32'h 78a5_636f, 32'h 84c8_7814, 32'h 8cc7_0208,
    32'h 90be_fffa, 32'h a450_6ceb, 32'h bef9_a3f7, 32'h c671_78f2
  };

  // SHA-512/SHA-384 constants
  localparam sha_word64_t CubicRootPrime512 [NumRound512] = '{
    64'h 428a_2f98_d728_ae22, 64'h 7137_4491_23ef_65cd, 64'h b5c0_fbcf_ec4d_3b2f,
    64'h e9b5_dba5_8189_dbbc, 64'h 3956_c25b_f348_b538, 64'h 59f1_11f1_b605_d019,
    64'h 923f_82a4_af19_4f9b, 64'h ab1c_5ed5_da6d_8118, 64'h d807_aa98_a303_0242,
    64'h 1283_5b01_4570_6fbe, 64'h 2431_85be_4ee4_b28c, 64'h 550c_7dc3_d5ff_b4e2,
    64'h 72be_5d74_f27b_896f, 64'h 80de_b1fe_3b16_96b1, 64'h 9bdc_06a7_25c7_1235,
    64'h c19b_f174_cf69_2694, 64'h e49b_69c1_9ef1_4ad2, 64'h efbe_4786_384f_25e3,
    64'h 0fc1_9dc6_8b8c_d5b5, 64'h 240c_a1cc_77ac_9c65, 64'h 2de9_2c6f_592b_0275,
    64'h 4a74_84aa_6ea6_e483, 64'h 5cb0_a9dc_bd41_fbd4, 64'h 76f9_88da_8311_53b5,
    64'h 983e_5152_ee66_dfab, 64'h a831_c66d_2db4_3210, 64'h b003_27c8_98fb_213f,
    64'h bf59_7fc7_beef_0ee4, 64'h c6e0_0bf3_3da8_8fc2, 64'h d5a7_9147_930a_a725,
    64'h 06ca_6351_e003_826f, 64'h 1429_2967_0a0e_6e70, 64'h 27b7_0a85_46d2_2ffc,
    64'h 2e1b_2138_5c26_c926, 64'h 4d2c_6dfc_5ac4_2aed, 64'h 5338_0d13_9d95_b3df,
    64'h 650a_7354_8baf_63de, 64'h 766a_0abb_3c77_b2a8, 64'h 81c2_c92e_47ed_aee6,
    64'h 9272_2c85_1482_353b, 64'h a2bf_e8a1_4cf1_0364, 64'h a81a_664b_bc42_3001,
    64'h c24b_8b70_d0f8_9791, 64'h c76c_51a3_0654_be30, 64'h d192_e819_d6ef_5218,
    64'h d699_0624_5565_a910, 64'h f40e_3585_5771_202a, 64'h 106a_a070_32bb_d1b8,
    64'h 19a4_c116_b8d2_d0c8, 64'h 1e37_6c08_5141_ab53, 64'h 2748_774c_df8e_eb99,
    64'h 34b0_bcb5_e19b_48a8, 64'h 391c_0cb3_c5c9_5a63, 64'h 4ed8_aa4a_e341_8acb,
    64'h 5b9c_ca4f_7763_e373, 64'h 682e_6ff3_d6b2_b8a3, 64'h 748f_82ee_5def_b2fc,
    64'h 78a5_636f_4317_2f60, 64'h 84c8_7814_a1f0_ab72, 64'h 8cc7_0208_1a64_39ec,
    64'h 90be_fffa_2363_1e28, 64'h a450_6ceb_de82_bde9, 64'h bef9_a3f7_b2c6_7915,
    64'h c671_78f2_e372_532b, 64'h ca27_3ece_ea26_619c, 64'h d186_b8c7_21c0_c207,
    64'h eada_7dd6_cde0_eb1e, 64'h f57d_4f7f_ee6e_d178, 64'h 06f0_67aa_7217_6fba,
    64'h 0a63_7dc5_a2c8_98a6, 64'h 113f_9804_bef9_0dae, 64'h 1b71_0b35_131c_471b,
    64'h 28db_77f5_2304_7d84, 64'h 32ca_ab7b_40c7_2493, 64'h 3c9e_be0a_15c9_bebc,
    64'h 431d_67c4_9c10_0d4c, 64'h 4cc5_d4be_cb3e_42b6, 64'h 597f_299c_fc65_7e2a,
    64'h 5fcb_6fab_3ad6_faec, 64'h 6c44_198c_4a47_5817
  };

  function automatic sha_word32_t conv_endian32(input sha_word32_t v, input logic swap);
    sha_word32_t conv_data;
    conv_data = {<<8{v}};
    conv_endian32 = (swap) ? conv_data : v;
  endfunction : conv_endian32

  function automatic sha_word32_t rotr32(input sha_word32_t v, input integer amt);
    rotr32 = (v >> amt) | (v << (32-amt));
  endfunction : rotr32

  function automatic sha_word64_t rotr64(input sha_word64_t v, input integer amt);
    rotr64 = (v >> amt) | (v << (64-amt));
  endfunction : rotr64

  function automatic sha_word32_t shiftr32(input sha_word32_t v, input integer amt);
    shiftr32 = (v >> amt);
  endfunction : shiftr32

  function automatic sha_word64_t shiftr64(input sha_word64_t v, input integer amt);
    shiftr64 = (v >> amt);
  endfunction : shiftr64

  // compression function for SHA-256 in multi-mode configuration
  function automatic sha_word64_t [7:0] compress_multi_256(input sha_word32_t w,
                                                           input sha_word32_t k,
                                                           input sha_word64_t [7:0] h_i);
    // as input: takes 64-bit word hash vector, 32-bit slice of w[0] and 32-bit constant
    automatic sha_word32_t sigma_0, sigma_1, ch, maj, temp1, temp2;

    sigma_1 = rotr32(h_i[4][31:0], 6) ^ rotr32(h_i[4][31:0], 11) ^ rotr32(h_i[4][31:0], 25);
    ch = (h_i[4][31:0] & h_i[5][31:0]) ^ (~h_i[4][31:0] & h_i[6][31:0]);
    temp1 = (h_i[7][31:0] + sigma_1 + ch + k + w);
    sigma_0 = rotr32(h_i[0][31:0], 2) ^ rotr32(h_i[0][31:0], 13) ^ rotr32(h_i[0][31:0], 22);
    maj = (h_i[0][31:0] & h_i[1][31:0]) ^ (h_i[0][31:0] & h_i[2][31:0]) ^
          (h_i[1][31:0] & h_i[2][31:0]);
    temp2 = (sigma_0 + maj);

    // 32-bit zero padding to complete 64-bit words of hash vector for output
    compress_multi_256[7] = {32'b0, h_i[6][31:0]};          // h = g
    compress_multi_256[6] = {32'b0, h_i[5][31:0]};          // g = f
    compress_multi_256[5] = {32'b0, h_i[4][31:0]};          // f = e
    compress_multi_256[4] = {32'b0, h_i[3][31:0] + temp1};  // e = (d + temp1)
    compress_multi_256[3] = {32'b0, h_i[2][31:0]};          // d = c
    compress_multi_256[2] = {32'b0, h_i[1][31:0]};          // c = b
    compress_multi_256[1] = {32'b0, h_i[0][31:0]};          // b = a
    compress_multi_256[0] = {32'b0, (temp1 + temp2)};       // a = (temp1 + temp2)
  endfunction : compress_multi_256

  // compression function for SHA-256 in 256-only configuration
  function automatic sha_word32_t [7:0] compress_256(input sha_word32_t w,
                                                     input sha_word32_t k,
                                                     input sha_word32_t [7:0] h_i);
    automatic sha_word32_t sigma_0, sigma_1, ch, maj, temp1, temp2;

    sigma_1 = rotr32(h_i[4], 6) ^ rotr32(h_i[4], 11) ^ rotr32(h_i[4], 25);
    ch = (h_i[4] & h_i[5]) ^ (~h_i[4] & h_i[6]);
    temp1 = (h_i[7] + sigma_1 + ch + k + w);
    sigma_0 = rotr32(h_i[0], 2) ^ rotr32(h_i[0], 13) ^ rotr32(h_i[0], 22);
    maj = (h_i[0] & h_i[1]) ^ (h_i[0] & h_i[2]) ^
          (h_i[1] & h_i[2]);
    temp2 = (sigma_0 + maj);

    compress_256[7] = h_i[6];          // h = g
    compress_256[6] = h_i[5];          // g = f
    compress_256[5] = h_i[4];          // f = e
    compress_256[4] = h_i[3] + temp1;  // e = (d + temp1)
    compress_256[3] = h_i[2];          // d = c
    compress_256[2] = h_i[1];          // c = b
    compress_256[1] = h_i[0];          // b = a
    compress_256[0] = temp1 + temp2;       // a = (temp1 + temp2)
  endfunction : compress_256

  // compression function for SHA-512/384
  function automatic sha_word64_t [7:0] compress_512(input sha_word64_t w,
                                                     input sha_word64_t k,
                                                     input sha_word64_t [7:0] h_i);
    automatic sha_word64_t sigma_0, sigma_1, ch, maj, temp1, temp2;

    sigma_1 = rotr64(h_i[4], 14) ^ rotr64(h_i[4], 18) ^ rotr64(h_i[4], 41);
    ch = (h_i[4] & h_i[5]) ^ (~h_i[4] & h_i[6]);
    temp1 = (h_i[7] + sigma_1 + ch + k + w);
    sigma_0 = rotr64(h_i[0], 28) ^ rotr64(h_i[0], 34) ^ rotr64(h_i[0], 39);
    maj = (h_i[0] & h_i[1]) ^ (h_i[0] & h_i[2]) ^ (h_i[1] & h_i[2]);
    temp2 = (sigma_0 + maj);

    compress_512[7] = h_i[6];          // h = g
    compress_512[6] = h_i[5];          // g = f
    compress_512[5] = h_i[4];          // f = e
    compress_512[4] = h_i[3] + temp1;  // e = (d + temp1)
    compress_512[3] = h_i[2];          // d = c
    compress_512[2] = h_i[1];          // c = b
    compress_512[1] = h_i[0];          // b = a
    compress_512[0] = (temp1 + temp2); // a = (temp1 + temp2)
  endfunction : compress_512

  function automatic sha_word32_t calc_w_256(input sha_word32_t w_0,
                                             input sha_word32_t w_1,
                                             input sha_word32_t w_9,
                                             input sha_word32_t w_14);
    automatic sha_word32_t sum0, sum1;
    sum0 = rotr32(w_1,   7) ^ rotr32(w_1,  18) ^ shiftr32(w_1,   3);
    sum1 = rotr32(w_14, 17) ^ rotr32(w_14, 19) ^ shiftr32(w_14, 10);
    calc_w_256 = w_0 + sum0 + w_9 + sum1;
  endfunction : calc_w_256

  function automatic sha_word64_t calc_w_512(input sha_word64_t w_0,
                                             input sha_word64_t w_1,
                                             input sha_word64_t w_9,
                                             input sha_word64_t w_14);
    automatic sha_word64_t sum0, sum1;
    sum0 = rotr64(w_1,   1) ^ rotr64(w_1,  8) ^ shiftr64(w_1,   7);
    sum1 = rotr64(w_14, 19) ^ rotr64(w_14, 61) ^ shiftr64(w_14, 6);
    calc_w_512 = w_0 + sum0 + w_9 + sum1;
  endfunction : calc_w_512

  typedef enum logic [31:0] {
    NoError                    = 32'h 0000_0000,
    // SwPushMsgWhenShaDisabled is not used in this version. The error code is
    // guarded by the HW. HW drops the message write request if `sha_en` is
    // off. eunchan@ left the error code to not corrupt the code sequence.
    // Need to rename to DeprecatedSwPush...
    //
    // Issue #3022
    SwPushMsgWhenShaDisabled   = 32'h 0000_0001,
    SwHashStartWhenShaDisabled = 32'h 0000_0002,
    SwUpdateSecretKeyInProcess = 32'h 0000_0003,
    SwHashStartWhenActive      = 32'h 0000_0004,
    SwPushMsgWhenDisallowed    = 32'h 0000_0005,
    SwInvalidConfig            = 32'h 0000_0006
  } err_code_e;

endpackage : prim_sha2_pkg
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
//
// SHA-256/Multi-Mode SHA-2 Padding logic

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


module prim_sha2_pad import prim_sha2_pkg::*;
#(
  parameter bit MultimodeEn = 1
 ) (
  input clk_i,
  input rst_ni,

  // to actual FIFO
  input                 fifo_rvalid_i,
  input  sha_fifo64_t   fifo_rdata_i,
  output logic          fifo_rready_o,
  // from SHA2 compression engine
  output logic          shaf_rvalid_o,
  output sha_word64_t   shaf_rdata_o,
  input                 shaf_rready_i,
  input                 sha_en_i,
  input                 hash_start_i,
  input                 hash_stop_i,
  input                 hash_continue_i,
  input digest_mode_e   digest_mode_i,
  input                 hash_process_i,
  input                 hash_done_i,
  input        [127:0]  message_length_i,   // # of bytes in bits (8 bits granularity)
  output logic          msg_feed_complete_o // indicates all message is feeded
);

  logic [127:0] tx_count_d, tx_count;    // fin received data count.
  logic         inc_txcount;
  logic         fifo_partial;
  logic         txcnt_eq_1a0;
  logic         txcnt_eq_msg_len;
  logic         hash_go;

  logic         hash_stop_flag_d, hash_stop_flag_q;
  logic         hash_process_flag_d, hash_process_flag_q;
  digest_mode_e digest_mode_flag_d,  digest_mode_flag_q;

  // Most operations and control signals are identical no matter if we are starting or continuing
  // to hash.
  assign hash_go = hash_start_i | hash_continue_i;

  // tie off unused inport ports and signals
  if (!MultimodeEn) begin : gen_tie_unused
    logic unused_signals;
    assign unused_signals = ^{message_length_i[127:64]};
  end

  assign fifo_partial = MultimodeEn ? ~&fifo_rdata_i.mask :
                                      ~&fifo_rdata_i.mask[3:0];

  // tx_count[8:0] == 'h1c0 --> should send LenHi
  assign txcnt_eq_1a0 = (digest_mode_flag_q == SHA2_256   || ~MultimodeEn)               ?
                                                                        (tx_count[8:0] == 9'h1a0)  :
                        ((digest_mode_flag_q == SHA2_384) || (digest_mode_flag_q == SHA2_512)) ?
                                                                        (tx_count[9:0] == 10'h340) :
                                                                        '0;

  if (MultimodeEn) begin : gen_txcnt_comp_multimode
    assign txcnt_eq_msg_len = (tx_count == message_length_i);
  end else begin : gen_txcnt_comp_no_multimode
    assign txcnt_eq_msg_len = (tx_count[63:0] == message_length_i[63:0]);
  end

  assign hash_stop_flag_d = (~sha_en_i || hash_go || hash_done_i) ? 1'b0 :
                            hash_stop_i                           ? 1'b1 :
                                                                    hash_stop_flag_q;

  assign hash_process_flag_d = (~sha_en_i || hash_go || hash_done_i) ? 1'b0 :
                               hash_process_i                        ? 1'b1 :
                                                                       hash_process_flag_q;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      hash_stop_flag_q    <= 1'b0;
      hash_process_flag_q <= 1'b0;
    end else begin
      hash_stop_flag_q    <= hash_stop_flag_d;
      hash_process_flag_q <= hash_process_flag_d;
    end
  end

  // data path: fout_wdata
  typedef enum logic [2:0] {
    FifoIn,         // fin_wdata, fin_wstrb
    Pad80,          // {8'h80, 8'h00} , strb (calc based on len[4:3])
    Pad00,          // 32'h0, full strb
    LenHi,          // len[63:32], full strb
    LenLo           // len[31:0], full strb
  } sel_data_e;
  sel_data_e sel_data;

  always_comb begin
    unique case (sel_data)
      FifoIn: begin
        shaf_rdata_o = fifo_rdata_i.data;
      end

      Pad80: begin
        // {a[7:0], b[7:0], c[7:0], d[7:0]}
        // msglen[4:3] == 00 |-> {'h80, 'h00, 'h00, 'h00}
        // msglen[4:3] == 01 |-> {msg,  'h80, 'h00, 'h00}
        // msglen[4:3] == 10 |-> {msg[15:0],  'h80, 'h00}
        // msglen[4:3] == 11 |-> {msg[23:0],        'h80}
        if ((digest_mode_flag_q == SHA2_256) || ~MultimodeEn) begin
          unique case (message_length_i[4:3])
            2'b 00:  shaf_rdata_o = 64'h 0000_0000_8000_0000;
            2'b 01:  shaf_rdata_o = {32'h 0000_0000, fifo_rdata_i.data[31:24], 24'h 8000_00};
            2'b 10:  shaf_rdata_o = {32'h 0000_0000, fifo_rdata_i.data[31:16], 16'h 8000};
            default: shaf_rdata_o = {32'h 0000_0000, fifo_rdata_i.data[31: 8],  8'h 80}; // 2'b11
          endcase
        end else begin // SHA384 || SHA512
          unique case (message_length_i[5:3])
            3'b 000: shaf_rdata_o = 64'h 8000_0000_0000_0000;
            3'b 001: shaf_rdata_o = {fifo_rdata_i.data[63:56], 56'h 8000_0000_0000_00};
            3'b 010: shaf_rdata_o = {fifo_rdata_i.data[63:48], 48'h 8000_0000_0000};
            3'b 011: shaf_rdata_o = {fifo_rdata_i.data[63:40], 40'h 8000_0000_00};
            3'b 100: shaf_rdata_o = {fifo_rdata_i.data[63:32], 32'h 8000_0000};
            3'b 101: shaf_rdata_o = {fifo_rdata_i.data[63:24], 24'h 8000_00};
            3'b 110: shaf_rdata_o = {fifo_rdata_i.data[63:16], 16'h 8000};
            default: shaf_rdata_o = {fifo_rdata_i.data[63:8],  8'h 80}; // 3'b111
          endcase
        end
      end

      Pad00: begin
        shaf_rdata_o = '0;
      end

      LenHi: begin
        shaf_rdata_o = ((digest_mode_flag_q == SHA2_256) || ~MultimodeEn) ?
                       {32'b0, message_length_i[63:32]} :
                       message_length_i[127:64]; // SHA384 || SHA512
      end

      LenLo: begin
        shaf_rdata_o = ((digest_mode_flag_q == SHA2_256) || ~MultimodeEn) ?
                       {32'b0, message_length_i[31:0]} :
                       message_length_i[63:0]; // SHA384 || SHA512
      end

      default: begin
        shaf_rdata_o = '0;
      end
    endcase

    if (!MultimodeEn) shaf_rdata_o [63:32] = 32'b0; // assign most sig 32 bits to constant 0
  end

  // Padded length
  // $ceil(message_length_i + 8 + 64, 512) -> message_length_i [8:0] + 440 and ignore carry
  //assign length_added = (message_length_i[8:0] + 9'h1b8) ;

  // fifo control
  // add 8'h 80 , N 8'h00, 64'h message_length_i

  // Steps
  // 1. `hash_start_i` from CPU (or DMA?)
  // 2. calculate `padded_length` from `message_length_i`
  // 3. Check if tx_count == message_length_i, then go to 5
  // 4. Receiving FIFO input (hand over to fifo output)
  // 5. Padding bit 1 (8'h80) followed by 8'h00 if needed
  // 6. Padding with length (high -> low)

  // State Machine
  typedef enum logic [2:0] {
    StIdle,        // fin_full to prevent unwanted FIFO write
    StFifoReceive, // Check tx_count == message_length_i
    StPad80,       // 8'h 80 + 8'h 00 X N
    StPad00,
    StLenHi,
    StLenLo
  } pad_st_e;

  pad_st_e st_q, st_d;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) st_q <= StIdle;
    else         st_q <= st_d;
  end

  // Next state
  always_comb begin
    shaf_rvalid_o = 1'b0;
    inc_txcount   = 1'b0;
    sel_data      = FifoIn;
    fifo_rready_o = 1'b0;
    st_d          = StIdle;

    unique case (st_q)
      StIdle: begin
        sel_data      = FifoIn;
        shaf_rvalid_o = 1'b0;
        if (sha_en_i && hash_go) begin
          inc_txcount = 1'b0;
          st_d        = StFifoReceive;
        end else begin
          st_d        = StIdle;
        end
      end

      StFifoReceive: begin
        sel_data = FifoIn;
        if (fifo_partial && fifo_rvalid_i) begin
          // End of the message (last bit is not word-aligned) , assume hash_process_flag is set
          shaf_rvalid_o = 1'b0; // Update entry at StPad80
          inc_txcount   = 1'b0;
          fifo_rready_o = 1'b0;
          st_d = StPad80;
        end else if (!hash_process_flag_q) begin
          fifo_rready_o = shaf_rready_i;
          shaf_rvalid_o = fifo_rvalid_i;
          inc_txcount   = shaf_rready_i;
          st_d = StFifoReceive;
        end else if (txcnt_eq_msg_len) begin
          // already received all msg and was waiting process flag
          shaf_rvalid_o = 1'b0;
          inc_txcount   = 1'b0;
          fifo_rready_o = 1'b0;
          st_d = StPad80;
        end else begin
          shaf_rvalid_o = fifo_rvalid_i;
          fifo_rready_o = shaf_rready_i; // 0 always
          inc_txcount   = shaf_rready_i; // 0 always
          st_d = StFifoReceive;
        end

        if (txcnt_eq_msg_len && hash_stop_flag_q) begin
          shaf_rvalid_o = 1'b0;
          inc_txcount   = 1'b0;
          fifo_rready_o = 1'b0;
          st_d = StIdle;
        end
      end

      StPad80: begin
        sel_data      = Pad80;
        shaf_rvalid_o = 1'b1;
        fifo_rready_o = (digest_mode_flag_q == SHA2_256 || ~MultimodeEn) ?
                        shaf_rready_i && |message_length_i[4:3] :
                        // SHA384 || SHA512. Only when partial.
                        shaf_rready_i && |message_length_i[5:3];

        // exactly 192 bits left, do not need to pad00's
        if (shaf_rready_i && txcnt_eq_1a0) begin
          st_d        = StLenHi;
          inc_txcount = 1'b1;
        // it does not matter if value is < or > than 416 bits.  If it's the former, 00 pad until
        // length field.  If >, then the next chunk will contain the length field with appropriate
        // 0 padding.
        end else if (shaf_rready_i && !txcnt_eq_1a0) begin
          st_d        = StPad00;
          inc_txcount = 1'b1;
        end else begin
          st_d        = StPad80;
          inc_txcount = 1'b0;
        end

        // # Below part is temporal code to speed up the SHA by 16 clocks per chunk
        // # (80 clk --> 64 clk)
        // # leaving this as a reference but needs to verify it.
        //if (shaf_rready_i && !txcnt_eq_1a0) begin
        //  st_d = StPad00;
        //
        //  inc_txcount = 1'b1;
        //  shaf_rvalid_o = (msg_word_aligned) ? 1'b1 : fifo_rvalid;
        //  fifo_rready = (msg_word_aligned) ? 1'b0 : 1'b1;
        //end else if (!shaf_rready_i && !txcnt_eq_1a0) begin
        //  st_d = StPad80;
        //
        //  inc_txcount = 1'b0;
        //  shaf_rvalid_o = (msg_word_aligned) ? 1'b1 : fifo_rvalid;
        //
        //end else if (shaf_rready_i && txcnt_eq_1a0) begin
        //  st_d = StLenHi;
        //  inc_txcount = 1'b1;
        //end else begin
        //  // !shaf_rready_i && txcnt_eq_1a0 , just wait until fifo_rready asserted
        //  st_d = StPad80;
        //  inc_txcount = 1'b0;
        //end
      end

      StPad00: begin
        sel_data      = Pad00;
        shaf_rvalid_o = 1'b1;

        if (shaf_rready_i) begin
          inc_txcount = 1'b1;
          if (txcnt_eq_1a0) st_d = StLenHi;
          else              st_d = StPad00;
        end else begin
          st_d = StPad00;
        end
      end

      StLenHi: begin
        sel_data      = LenHi;
        shaf_rvalid_o = 1'b1;

        st_d = StLenHi;
        inc_txcount = 1'b0;

        if (shaf_rready_i) begin
          st_d = StLenLo;
          inc_txcount = 1'b1;
        end
      end

      StLenLo: begin
        sel_data        = LenLo;
        shaf_rvalid_o   = 1'b1;

        st_d        = StLenLo;
        inc_txcount = 1'b0;

        if (shaf_rready_i) begin
          st_d        = StIdle;
          inc_txcount = 1'b1;
        end
      end

      default: begin
        st_d = StIdle;
      end
    endcase

    if (!sha_en_i) begin
      st_d = StIdle;
    // We do not allow the cancellation of an ongoing padding operation, i.e., reverting back to the
    // `StFifoReceive` state while being in the states `StPad80`, `StPad00`, `StLenHi` or `StLenLo`.
    end else if (hash_go && (st_q inside {StIdle, StFifoReceive})) begin
      st_d = StFifoReceive;
    end
  end

  // tx_count
  always_comb begin
    tx_count_d = tx_count;

    if (hash_start_i) begin
      // When starting a fresh hash, initialize the data counter to zero.
      tx_count_d = '0;
    end else if (hash_continue_i) begin
      // When continuing to hash, set the data counter to the current message length.
      tx_count_d = message_length_i;
    end else if (inc_txcount) begin
      if ((digest_mode_flag_q == SHA2_256) || !MultimodeEn) begin
        tx_count_d[127:5] = tx_count[127:5] + 1'b1;
      end else begin // SHA384 || SHA512
        tx_count_d[127:6] = tx_count[127:6] + 1'b1;
      end
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) tx_count <= '0;
    else         tx_count <= tx_count_d;
  end

  assign digest_mode_flag_d = (hash_start_i || hash_continue_i) ? digest_mode_i  :    // set config
                              hash_done_i                       ? SHA2_None      :    // clear
                                                                  digest_mode_flag_q; // keep

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni)  digest_mode_flag_q <= SHA2_None;
    else          digest_mode_flag_q <= digest_mode_flag_d;
  end

  // State machine is in Idle only when it meets tx_count == message length
  assign msg_feed_complete_o = (hash_process_flag_q || hash_stop_flag_q) && (st_q == StIdle);

  ////////////////
  // Assertions //
  ////////////////

  

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// SHA-256/384/512 configurable mode engine (64-bit word datapath)

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


module prim_sha2 import prim_sha2_pkg::*;
#(
  parameter bit MultimodeEn = 0, // assert to enable multi-mode digest feature

  localparam int unsigned RndWidth256 = $clog2(NumRound256),
  localparam int unsigned RndWidth512 = $clog2(NumRound512),
  localparam sha_word64_t ZeroWord      = '0
 ) (
  input clk_i,
  input rst_ni,

  input               wipe_secret_i,
  input sha_word32_t  wipe_v_i,
  // control signals and message words input to the message FIFO
  input               fifo_rvalid_i, // indicates that the message FIFO (prim_sync_fifo) has words
                                     // ready to write into the SHA-2 padding buffer
  input  sha_fifo64_t fifo_rdata_i,
  output logic        fifo_rready_o, // indicates the internal padding buffer is ready to receive
                                     // words from the message FIFO
  // control signals
  input               sha_en_i,   // if disabled, it clears internal content
  input               hash_start_i, // start hashing: initialize data counter to zero and clear
                                    // digest
  input               hash_stop_i, // stop hashing: after all data up to message length has been
                                   // hashed, stop without padding
  input               hash_continue_i, // continue hashing: set data counter to `message_length_i`
                                       // and use current digest
  input digest_mode_e digest_mode_i,
  input               hash_process_i,
  output logic        hash_done_o,

  input  [63:0]             message_length_i, // bits but byte based
  input  sha_word64_t [7:0] digest_i,
  input  logic [7:0]        digest_we_i,
  output sha_word64_t [7:0] digest_o, // tie off unused port slice when MultimodeEn = 0
  output logic digest_on_blk_o, // digest being computed for a complete block
  output fifoctl_state_e fifo_st_o,
  output logic hash_running_o, // `1` iff hash computation is active (as opposed to `idle_o`, which
                               // is also `0` and thus 'busy' when waiting for a FIFO input)
  output logic idle_o
);

  logic        msg_feed_complete;
  logic        shaf_rready;
  logic        shaf_rvalid;

  // control signals - shared for both modes
  logic update_w_from_fifo, calculate_next_w;
  logic init_hash, run_hash, one_chunk_done;
  logic update_digest, clear_digest;
  logic hash_done_next; // to meet the phase with digest value
  logic hash_go;

  // datapath signals - shared for both modes
  logic [RndWidth512-1:0] round_d, round_q;
  logic [3:0]             w_index_d, w_index_q;
  digest_mode_e           digest_mode_flag_d, digest_mode_flag_q;
  sha_word64_t            shaf_rdata;

  // tie off unused input ports and signals slices
  if (!MultimodeEn) begin : gen_tie_unused
    logic [7:0] unused_digest_upper;
    for (genvar i = 0; i < 8; i++) begin : gen_unused_digest_upper
      assign unused_digest_upper[i] = ^digest_i[i][63:32];
    end
    logic unused_signals;
    assign unused_signals = ^{shaf_rdata[63:32], unused_digest_upper};
  end

  // Most operations and control signals are identical no matter if we are starting or continuing
  // to hash.
  assign hash_go = hash_start_i | hash_continue_i;

  assign digest_mode_flag_d = hash_go     ? digest_mode_i   :    // latch in configured mode
                              hash_done_o ? SHA2_None       :    // clear
                                            digest_mode_flag_q;  // keep

  if (MultimodeEn) begin : gen_multimode
    // datapath signal definitions for multi-mode
    sha_word64_t [7:0]  hash_d, hash_q; // a,b,c,d,e,f,g,h
    sha_word64_t [15:0] w_d, w_q;
    sha_word64_t [7:0]  digest_d, digest_q;

    // compute w
    always_comb begin : compute_w_multimode
      w_d = w_q;
      if (wipe_secret_i) begin
        w_d = {32{wipe_v_i}};
      end else if (!sha_en_i || hash_go) begin
        w_d = '0;
      end else if (!run_hash && update_w_from_fifo) begin
        // this logic runs at the first stage of SHA: hash not running yet,
        // still filling in first 16 words
        w_d = {shaf_rdata, w_q[15:1]};
      end else if (calculate_next_w) begin // message scheduling/derivation for last 48/64 rounds
        if (digest_mode_flag_q == SHA2_256) begin
          // this computes the next w[16] and shifts out w[0] into compression below
          w_d = {{32'b0, calc_w_256(w_q[0][31:0], w_q[1][31:0], w_q[9][31:0],
                w_q[14][31:0])}, w_q[15:1]};
        end else if ((digest_mode_flag_q == SHA2_384) || (digest_mode_flag_q == SHA2_512)) begin
          w_d = {calc_w_512(w_q[0], w_q[1], w_q[9], w_q[14]), w_q[15:1]};
        end
      end else if (run_hash) begin
        // just shift-out the words as they get consumed. There's no incoming data.
        w_d = {ZeroWord, w_q[15:1]};
      end
    end : compute_w_multimode

    // update w
    always_ff @(posedge clk_i or negedge rst_ni) begin : update_w_multimode
      if (!rst_ni)            w_q <= '0;
      else if (MultimodeEn)   w_q <= w_d;
    end : update_w_multimode

    // compute hash
    always_comb begin : compression_multimode
      hash_d = hash_q;
      if (wipe_secret_i) begin
        hash_d = {16{wipe_v_i}};
      end else if (init_hash) begin
        hash_d = digest_q;
      end else if (run_hash) begin
        if (digest_mode_flag_q == SHA2_256) begin
          hash_d = compress_multi_256(w_q[0][31:0],
                   CubicRootPrime256[round_q[RndWidth256-1:0]], hash_q);
        end else begin // SHA384 || SHA512
          hash_d = compress_512(w_q[0], CubicRootPrime512[round_q], hash_q);
        end
      end
    end : compression_multimode

    // update hash
    always_ff @(posedge clk_i or negedge rst_ni) begin : update_hash_multimode
      if (!rst_ni)  hash_q <= '0;
      else          hash_q <= hash_d;
    end : update_hash_multimode

    // compute digest
    always_comb begin : compute_digest_multimode
      digest_d = digest_q;
      if (wipe_secret_i) begin
        digest_d = {16{wipe_v_i}};
      end else if (hash_start_i) begin
        for (int i = 0 ; i < 8 ; i++) begin
          if (digest_mode_i == SHA2_256) begin
            digest_d[i] = {32'b0, InitHash_256[i]};
          end else if (digest_mode_i == SHA2_384) begin
            digest_d[i] = InitHash_384[i];
          end else if (digest_mode_i == SHA2_512) begin
            digest_d[i] = InitHash_512[i];
          end
        end
      end else if (clear_digest) begin
        digest_d = '0;
      end else if (!sha_en_i) begin
        for (int i = 0; i < 8; i++) begin
          digest_d[i] = digest_we_i[i] ? digest_i[i] : digest_q[i];
        end
      end else if (update_digest) begin
        for (int i = 0 ; i < 8 ; i++) begin
          digest_d[i] = digest_q[i] + hash_q[i];
        end
      end
    end : compute_digest_multimode

    // update digest
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni)  digest_q <= '0;
      else          digest_q <= digest_d;
    end

    // assign digest to output
    assign digest_o = digest_q;

    // When wipe_secret is high, sensitive internal variables are cleared by extending the wipe
    // value specified in the register
    
    
    
  end else begin : gen_256 // MultimodeEn = 0
    // datapath signal definitions for SHA-2 256 only
    sha_word32_t        shaf_rdata256;
    sha_word32_t [7:0]  hash256_d, hash256_q; // a,b,c,d,e,f,g,h
    sha_word32_t [15:0] w256_d, w256_q;
    sha_word32_t [7:0]  digest256_d, digest256_q;

    assign shaf_rdata256 = shaf_rdata[31:0];

    always_comb begin : compute_w_256
      // ~MultimodeEn
      w256_d = w256_q;
      if (wipe_secret_i) begin
        w256_d = {16{wipe_v_i}};
      end else if (!sha_en_i || hash_go) begin
        w256_d = '0;
      end else if (!run_hash && update_w_from_fifo) begin
        // this logic runs at the first stage of SHA: hash not running yet,
        // still filling in first 16 words
        w256_d = {shaf_rdata256, w256_q[15:1]};
      end else if (calculate_next_w) begin // message scheduling/derivation for last 48/64 rounds
        w256_d = {calc_w_256(w256_q[0][31:0], w256_q[1][31:0], w256_q[9][31:0],
                 w256_q[14][31:0]), w256_q[15:1]};
      end else if (run_hash) begin
        // just shift-out the words as they get consumed. There's no incoming data.
        w256_d = {ZeroWord[31:0], w256_q[15:1]};
      end
    end : compute_w_256

    // update w_256
    always_ff @(posedge clk_i or negedge rst_ni) begin : update_w_256
      if (!rst_ni)            w256_q <= '0;
      else if (!MultimodeEn)  w256_q <= w256_d;
    end : update_w_256

    // compute hash_256
    always_comb begin : compression_256
      hash256_d = hash256_q;
      if (wipe_secret_i) begin
        hash256_d = {8{wipe_v_i}};
      end else if (init_hash) begin
        hash256_d = digest256_q;
      end else if (run_hash) begin
        hash256_d = compress_256(w256_q[0], CubicRootPrime256[round_q[RndWidth256-1:0]], hash256_q);
      end
    end : compression_256

    // update hash_256
    always_ff @(posedge clk_i or negedge rst_ni) begin : update_hash256
      if (!rst_ni) hash256_q <= '0;
      else         hash256_q <= hash256_d;
    end : update_hash256

    // compute digest_256
    always_comb begin : compute_digest_256
      digest256_d = digest256_q;
      if (wipe_secret_i) begin
        digest256_d = {8{wipe_v_i}};
      end else if (hash_start_i) begin
        for (int i = 0 ; i < 8 ; i++) begin
            digest256_d[i] = InitHash_256[i];
        end
      end else if (clear_digest) begin
        digest256_d = '0;
      end else if (!sha_en_i) begin
        for (int i = 0; i < 8; i++) begin
          digest256_d[i] = digest_we_i[i] ? digest_i[i][31:0] : digest256_q[i];
        end
      end else if (update_digest) begin
        for (int i = 0 ; i < 8 ; i++) begin
          digest256_d[i] = digest256_q[i] + hash256_q[i];
        end
      end
    end : compute_digest_256

    // update digest_256
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni)  digest256_q <= '0;
      else          digest256_q <= digest256_d;
    end

    // assign digest to output
    for (genvar i = 0; i < 8; i++) begin  : gen_assign_digest_256
      assign digest_o[i][31:0]  = digest256_q[i];
      assign digest_o[i][63:32] = 32'b0;
    end

    // When wipe_secret is high, sensitive internal variables are cleared by extending the wipe
    // value specifed in the register
    
    
    
  end

  // compute round counter (shared)
  always_comb begin : round_counter
    round_d = round_q;
    if (!sha_en_i || hash_go) begin
      round_d = '0;
    end else if (run_hash) begin
      if (((round_q[RndWidth256-1:0] == RndWidth256'(unsigned'(NumRound256-1))) &&
         (digest_mode_flag_q == SHA2_256 || !MultimodeEn)) ||
         ((round_q == RndWidth512'(unsigned'(NumRound512-1))) &&
         ((digest_mode_flag_q == SHA2_384) || (digest_mode_flag_q == SHA2_512)))) begin
        round_d = '0;
      end else begin
        round_d = round_q + 1;
      end
    end
  end

  // update round counter (shared)
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) round_q <= '0;
    else         round_q <= round_d;
  end

  // compute w_index (shared)
  assign w_index_d = (~sha_en_i || hash_go) ? '0            :  // clear
                     update_w_from_fifo     ? w_index_q + 1 :  // increment
                                              w_index_q;       // keep
  // update w_index (shared)
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) w_index_q <= '0;
    else         w_index_q <= w_index_d;
  end

  // ready for a word from the padding buffer in sha2_pad
  assign shaf_rready = update_w_from_fifo;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) hash_done_o <= 1'b0;
    else         hash_done_o <= hash_done_next;
  end

  fifoctl_state_e fifo_st_q, fifo_st_d;

  assign fifo_st_o = fifo_st_q;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) fifo_st_q <= FifoIdle;
    else         fifo_st_q <= fifo_st_d;
  end

  always_comb begin
    fifo_st_d          = fifo_st_q;
    update_w_from_fifo = 1'b0;
    hash_done_next     = 1'b0;

    unique case (fifo_st_q)
      FifoIdle: begin
        if (hash_go) fifo_st_d = FifoLoadFromFifo;
        else         fifo_st_d = FifoIdle;
      end

      FifoLoadFromFifo: begin
        if (!shaf_rvalid) begin
          // Wait until it is filled
          fifo_st_d          = FifoLoadFromFifo;
          update_w_from_fifo = 1'b0;
          if (msg_feed_complete) begin
            fifo_st_d       = FifoIdle;
            hash_done_next  = 1'b1;
          end
        end else if (w_index_q == 4'd 15) begin
          fifo_st_d = FifoWait;
          // To increment w_index and it rolls over to 0
          update_w_from_fifo = 1'b1;
        end else begin
          fifo_st_d          = FifoLoadFromFifo;
          update_w_from_fifo = 1'b1;
        end
      end

      FifoWait: begin
        if (msg_feed_complete && one_chunk_done) begin
          fifo_st_d      = FifoIdle;
          // hashing the full message is done
          hash_done_next = 1'b1;
        end else if (one_chunk_done) begin
          fifo_st_d      = FifoLoadFromFifo;
        end else begin
          fifo_st_d      = FifoWait;
        end
      end

      default: begin
        fifo_st_d = FifoIdle;
      end
    endcase

    if (!sha_en_i)  begin
      fifo_st_d          = FifoIdle;
      update_w_from_fifo = 1'b0;
    end else if (hash_go) begin
      fifo_st_d          = FifoLoadFromFifo;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) digest_mode_flag_q <= SHA2_None;
    else         digest_mode_flag_q <= digest_mode_flag_d;
  end

  // SHA control (shared)
  typedef enum logic [1:0] {
    ShaIdle,
    ShaCompress,
    ShaUpdateDigest
  } sha_st_t;

  sha_st_t sha_st_q, sha_st_d;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) sha_st_q <= ShaIdle;
    else         sha_st_q <= sha_st_d;
  end

  logic sha_en_q;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) sha_en_q <= 1'b0;
    else         sha_en_q <= sha_en_i;
  end

  assign clear_digest = hash_start_i | (~sha_en_i & sha_en_q);

  always_comb begin
    update_digest    = 1'b0;
    calculate_next_w = 1'b0;
    init_hash        = 1'b0;
    run_hash         = 1'b0;
    sha_st_d         = sha_st_q;

    unique case (sha_st_q)
      ShaIdle: begin
        if (fifo_st_q == FifoWait) begin
          init_hash = 1'b1;
          sha_st_d  = ShaCompress;
        end else begin
          sha_st_d  = ShaIdle;
        end
      end

      ShaCompress: begin
        run_hash = 1'b1;
        if (((digest_mode_flag_q == SHA2_256 || ~MultimodeEn) && round_q < 48) ||
           (((digest_mode_flag_q == SHA2_384) ||
           (digest_mode_flag_q == SHA2_512)) && round_q < 64)) begin
          calculate_next_w = 1'b1;
        end else if (one_chunk_done) begin
          sha_st_d = ShaUpdateDigest;
        end else begin
          sha_st_d = ShaCompress;
        end
      end

      ShaUpdateDigest: begin
        update_digest = 1'b1;
        if (fifo_st_q == FifoWait) begin
          init_hash = 1'b1;
          sha_st_d  = ShaCompress;
        end else begin
          sha_st_d  = ShaIdle;
        end
      end

      default: begin
        sha_st_d = ShaIdle;
      end
    endcase

    if (!sha_en_i || hash_go) sha_st_d  = ShaIdle;
  end

  logic update_digest_q, update_digest_d;

  // Determine whether a digest is being computed for a complete block: when `update_digest` is set,
  // this module is not waiting for more data from the FIFO, and `message_length_i` is zero modulo a
  // complete block (512 bit for SHA2_256 and 1024 bit for SHA2_384 and SHA2_512).
  assign digest_on_blk_o = (update_digest || update_digest_q) && (fifo_st_q == FifoIdle) && (
      (digest_mode_flag_q == SHA2_256                 && message_length_i[8:0] == '0) ||
      (digest_mode_flag_q inside {SHA2_384, SHA2_512} && message_length_i[9:0] == '0));

  assign update_digest_d = digest_on_blk_o ? 1'b0 :
                           update_digest   ? 1'b1 : update_digest_q;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      update_digest_q <= 1'b0;
    end else begin
      update_digest_q <= update_digest_d;
    end
  end

  assign one_chunk_done = ((digest_mode_flag_q == SHA2_256 || ~MultimodeEn)
                          && (round_q == 7'd63)) ? 1'b1 :
                          (((digest_mode_flag_q == SHA2_384) || (digest_mode_flag_q == SHA2_512))
                          && (round_q == 7'd79)) ? 1'b1 : 1'b0;

  prim_sha2_pad #(
      .MultimodeEn(MultimodeEn)
    ) u_pad (
    .clk_i,
    .rst_ni,
    .fifo_rvalid_i,
    .fifo_rdata_i,
    .fifo_rready_o,
    .shaf_rvalid_o (shaf_rvalid), // is set when the 512-bit chunk is ready in the padding buffer
    .shaf_rdata_o  (shaf_rdata),
    .shaf_rready_i (shaf_rready), // indicates that w is ready for more words from padding buffer
    .sha_en_i,
    .hash_start_i,
    .hash_stop_i,
    .hash_continue_i,
    .digest_mode_i,
    .hash_process_i,
    .hash_done_i (hash_done_o),
    .message_length_i ({64'b0, message_length_i}), // 128-bit message length per NIST-FIPS-180-4
    .msg_feed_complete_o (msg_feed_complete)
  );

  assign hash_running_o = init_hash | run_hash | update_digest;

  // Idle
  assign idle_o = (fifo_st_q == FifoIdle) && (sha_st_q == ShaIdle) && !hash_go;

  ////////////////
  // Assertions //
  ////////////////

  

endmodule : prim_sha2
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// 32-bit input wrapper for the SHA-2 engine

module prim_sha2_32 import prim_sha2_pkg::*;
#(
  parameter bit MultimodeEn = 0 // assert to enable multi-mode feature
 ) (
  input clk_i,
  input rst_ni,

  input              wipe_secret_i,
  input sha_word32_t wipe_v_i,
  // Control signals and message words input to the message FIFO
  input               fifo_rvalid_i,      // indicates that there are data words/word parts
                                          // ready to write into the SHA-2 padding buffer
  input  sha_fifo32_t fifo_rdata_i,
  output logic        fifo_rready_o,      // indicates that the wrapper word accumulation buffer is
                                          // ready to receive words to feed into the SHA-2 engine
  // Control signals
  input                     sha_en_i, // if disabled, it clears internal content
  input                     hash_start_i,
  input                     hash_stop_i,
  input                     hash_continue_i,
  input digest_mode_e       digest_mode_i,
  input                     hash_process_i,
  output logic              hash_done_o,
  input [63:0]              message_length_i,
  input  sha_word64_t [7:0] digest_i,
  input  logic [7:0]        digest_we_i,
  output sha_word64_t [7:0] digest_o,         // use extended digest length
  output logic              digest_on_blk_o,
  output logic              hash_running_o,
  output logic              idle_o
);
  // signal definitions shared for both 256-bit and multi-mode
  sha_fifo64_t  full_word;
  logic sha_ready, hash_go;

  // Most operations and control signals are identical no matter if we are starting or re-starting
  // to hash.
  assign hash_go = hash_start_i | hash_continue_i;

  fifoctl_state_e fifo_st;

  // tie off unused ports/port slices
  if (!MultimodeEn) begin : gen_tie_unused
    logic unused_signals;
    assign unused_signals = ^{digest_mode_i, hash_go};
  end

  // logic and prim_sha2 instantiation for MultimodeEn = 1
  if (MultimodeEn) begin : gen_multimode_logic
    // signal definitions for multi-mode
    sha_fifo64_t  word_buffer_d, word_buffer_q;
    logic [1:0]   word_part_count_d, word_part_count_q;
    logic         sha_process, process_flag_d, process_flag_q;
    logic         word_valid;
    logic         word_part_inc, word_part_reset;
    digest_mode_e digest_mode_flag_d, digest_mode_flag_q;

    always_comb begin : multimode_combinational
      word_part_inc    = 1'b0;
      word_part_reset  = 1'b0;
      full_word.mask   = 8'hFF; // to keep the padding buffer ready to receive
      full_word.data   = 64'h0;
      sha_process      = 1'b0;
      word_valid       = 1'b0;
      fifo_rready_o    = 1'b0;

      // assign word_buffer
      if (!sha_en_i || hash_go) word_buffer_d = 0;
      else                      word_buffer_d = word_buffer_q;

      if (sha_en_i && fifo_rvalid_i) begin // valid incoming word part and SHA engine is enabled
        if (word_part_count_q == 2'b00) begin
          if (digest_mode_flag_q != SHA2_256) begin
            // accumulate most significant 32 bits of word and mask bits
            word_buffer_d.data[63:32] = fifo_rdata_i.data;
            word_buffer_d.mask[7:4]   = fifo_rdata_i.mask;
            if (fifo_st == FifoLoadFromFifo) begin
              fifo_rready_o = 1'b1; // load word from FIFO
              word_part_inc = 1'b1;
            end else begin
              fifo_rready_o = 1'b0; // do not load from FIFO
              word_part_inc = 1'b0;
            end
          end else begin   // SHA2_256 so pad and push out the word
            word_valid = 1'b1;
            // store the word with most significant padding
            word_buffer_d.data = {32'b0, fifo_rdata_i.data};
            word_buffer_d.mask = {4'hF, fifo_rdata_i.mask}; // pad with all-1 byte mask
            // pad with all-zero data and all-one byte masking and push word out already for 256
            full_word.data =  {32'b0, fifo_rdata_i.data};
            full_word.mask =  {4'hF, fifo_rdata_i.mask};
            if (hash_process_i || process_flag_q) begin
                sha_process = 1'b1;
            end
            if (sha_ready == 1'b1) begin
              // if word has been absorbed into hash engine
              fifo_rready_o = 1'b1; // word pushed out to SHA engine so word buffer ready
            end else begin
              fifo_rready_o = 1'b0;
            end
          end

        end else if (word_part_count_q == 2'b01) begin
          // accumulate least significant 32 bits and mask
          word_buffer_d.data [31:0] = fifo_rdata_i.data;
          word_buffer_d.mask [3:0]  = fifo_rdata_i.mask;

          // now ready to pass full word through
          word_valid              = 1'b1;
          full_word.data [63:32]  = word_buffer_q.data[63:32];
          full_word.mask [7:4]    = word_buffer_q.mask[7:4];
          full_word.data [31:0]   = fifo_rdata_i.data;
          full_word.mask  [3:0]   = fifo_rdata_i.mask;

          if (hash_process_i || process_flag_q) begin
              sha_process = 1'b1;
          end
          if (sha_ready == 1'b1) begin
            // word has been consumed
            fifo_rready_o     = 1'b1; // word pushed out to SHA engine so word buffer ready
            word_part_reset   = 1'b1;
            word_part_inc     = 1'b0;
          end else begin
            fifo_rready_o     = 1'b0;
            word_part_inc     = 1'b0;
          end
        end else if (word_part_count_q == 2'b10) begin // word buffer is full and not loaded out yet
          // fifo_rready_o is now deasserted: accumulated word is waiting to be pushed out
          fifo_rready_o     = 1'b0;
          word_valid        = 1'b1; // word buffer is ready to shift word out to SHA engine
          full_word         = word_buffer_q;
          if (hash_process_i || process_flag_q) begin
              sha_process   = 1'b1;
          end
          if (sha_ready == 1'b1) begin // waiting on sha_ready to turn 1
            // do not assert fifo_rready_o yet
            word_part_reset = 1'b1;
          end
        end
      end else if (sha_en_i) begin // hash engine still enabled but no new valid input
        // provide the last latched input so long as hash is enabled
        full_word = word_buffer_q;
        if (word_part_count_q == 2'b00 && (hash_process_i || process_flag_q)) begin
          sha_process = 1'b1; // wait on hash_process_i
        end else if (word_part_count_q == 2'b01 && (hash_process_i || process_flag_q)) begin
          // 384/512: msg ended: apply 32-bit word packing and push last word
          full_word.data [31:0] = 32'b0;
          full_word.mask [3:0]  = 4'h0;
          word_valid            = 1'b1;
          sha_process           = 1'b1;
          if (sha_ready == 1'b1) begin // word has been consumed
            word_part_reset = 1'b1; // which will also reset word_valid in the next cycle
          end
        end else if (word_part_count_q == 2'b01) begin // word feeding stalled but msg not ended
          word_valid = 1'b0;
        end else if (word_part_count_q == 2'b10 && (hash_process_i || process_flag_q)) begin
          // 384/512: msg ended but last word still waiting to be fed in
          word_valid  = 1'b1;
          sha_process = 1'b1;
          if (sha_ready == 1'b1) begin // word has been consumed
            word_part_reset = 1'b1; // which will also reset word_valid in the next cycle
          end
        end else if (word_part_count_q == 2'b10) begin // word feeding stalled
          word_valid = 1'b0;
        end
      end

      // assign word_part_count_d
      if ((word_part_reset || hash_go || !sha_en_i)) begin
        word_part_count_d = '0;
      end else if (word_part_inc) begin
        word_part_count_d = word_part_count_q + 1'b1;
      end else begin
        word_part_count_d = word_part_count_q;
      end

      // assign digest_mode_flag_d
      if (hash_go)          digest_mode_flag_d = digest_mode_i;      // latch in configured mode
      else if (hash_done_o) digest_mode_flag_d = SHA2_None;          // clear
      else                  digest_mode_flag_d = digest_mode_flag_q; // keep

      // assign process_flag
      if (!sha_en_i || hash_go) process_flag_d = 1'b0;
      else if (hash_process_i)  process_flag_d = 1'b1;
      else                      process_flag_d = process_flag_q;
    end : multimode_combinational

    prim_sha2 #(
      .MultimodeEn(1)
    ) u_prim_sha2_multimode (
      .clk_i (clk_i),
      .rst_ni (rst_ni),
      .wipe_secret_i      (wipe_secret_i),
      .wipe_v_i           (wipe_v_i),
      .fifo_rvalid_i      (word_valid),
      .fifo_rdata_i       (full_word),
      .fifo_rready_o      (sha_ready),
      .sha_en_i           (sha_en_i),
      .hash_start_i       (hash_start_i),
      .hash_stop_i        (hash_stop_i),
      .hash_continue_i    (hash_continue_i),
      .digest_mode_i      (digest_mode_i),
      .hash_process_i     (sha_process),
      .hash_done_o        (hash_done_o),
      .message_length_i   (message_length_i),
      .digest_i           (digest_i),
      .digest_we_i        (digest_we_i),
      .digest_o           (digest_o),
      .digest_on_blk_o    (digest_on_blk_o),
      .fifo_st_o          (fifo_st),
      .hash_running_o     (hash_running_o),
      .idle_o             (idle_o)
    );

    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni)  word_part_count_q <= '0;
      else          word_part_count_q <= word_part_count_d;
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni)  word_buffer_q <= 0;
      else          word_buffer_q <= word_buffer_d;
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin
     if (!rst_ni)          process_flag_q <= '0;
      else  process_flag_q <= process_flag_d;
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) digest_mode_flag_q <= SHA2_None;
      else         digest_mode_flag_q <= digest_mode_flag_d;
    end
  // logic and prim_sha2 instantiation for MultimodeEn = 0
  end else begin : gen_sha256_logic  // MultimodeEn = 0
    always_comb begin : sha256_combinational
      full_word.data   = {32'b0, fifo_rdata_i.data};
      full_word.mask   = {4'hF,  fifo_rdata_i.mask};
      fifo_rready_o    = sha_ready;
    end : sha256_combinational

    prim_sha2 #(
      .MultimodeEn(0)
    ) u_prim_sha2_256 (
      .clk_i (clk_i),
      .rst_ni (rst_ni),
      .wipe_secret_i      (wipe_secret_i),
      .wipe_v_i           (wipe_v_i),
      .fifo_rvalid_i      (fifo_rvalid_i), // feed input directly
      .fifo_rdata_i       (full_word),
      .fifo_rready_o      (sha_ready),
      .sha_en_i           (sha_en_i),
      .hash_start_i       (hash_start_i),
      .hash_stop_i        (hash_stop_i),
      .hash_continue_i    (hash_continue_i),
      .digest_mode_i      (SHA2_None),      // unused input port tied to ground
      .hash_process_i     (hash_process_i), // feed input port directly to SHA-2 engine
      .hash_done_o        (hash_done_o),
      .message_length_i   (message_length_i),
      .digest_i           (digest_i),
      .digest_we_i        (digest_we_i),
      .digest_o           (digest_o),
      .digest_on_blk_o    (digest_on_blk_o),
      .fifo_st_o          (fifo_st),
      .hash_running_o     (hash_running_o),
      .idle_o             (idle_o)
    );
  end

endmodule : prim_sha2_32
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

package top_pkg;

localparam int TL_AW=32;
localparam int TL_DW=32;    // = TL_DBW * 8; TL_DBW must be a power-of-two
localparam int TL_AIW=8;    // a_source, d_source
localparam int TL_DIW=1;    // d_sink
localparam int TL_AUW=28;   // a_user
localparam int TL_DUW=14;   // d_user
localparam int TL_DBW=(TL_DW>>3);
localparam int TL_SZW=$clog2($clog2(TL_DBW)+1);

// Number of cycles a differential skew is tolerated on the alert signal
localparam int unsigned AlertSkewCycles = 3;

// NOTE THAT THIS IS A FEATURE FOR TEST CHIPS ONLY TO MITIGATE
// THE RISK OF A BROKEN OTP MACRO. THIS WILL BE DISABLED FOR
// PRODUCTION DEVICES.
localparam int SecVolatileRawUnlockEn = 1;

// The CTN SRAM is set to the same size as the discrete flash (2 x 512kB).
localparam int CtnSramSize = 2 * 512 * 1024;
localparam int CtnSramDepth = CtnSramSize / TL_DBW;
localparam int CtnSramAw = prim_util_pkg::vbits(CtnSramDepth);

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
//
// Synchronous TL-UL FIFO, used to add elasticity (the ability for
// transactions to stall on one side without affecting the other side)
// to a TL-UL bus. This instantiates two pairs (data + integrity) of FIFOs:
// one pair for the request side, and another pair for the response side.

module tlul_fifo_sync #(
  parameter bit          ReqPass = 1'b1,
  parameter bit          RspPass = 1'b1,
  parameter int unsigned ReqDepth = 2,
  parameter int unsigned RspDepth = 2,
  parameter int unsigned SpareReqW = 1,
  parameter int unsigned SpareRspW = 1
) (
  input                     clk_i,
  input                     rst_ni,
  input  tlul_pkg::tl_h2d_t tl_h_i,
  output tlul_pkg::tl_d2h_t tl_h_o,
  output tlul_pkg::tl_h2d_t tl_d_o,
  input  tlul_pkg::tl_d2h_t tl_d_i,
  input  [SpareReqW-1:0]    spare_req_i,
  output [SpareReqW-1:0]    spare_req_o,
  input  [SpareRspW-1:0]    spare_rsp_i,
  output [SpareRspW-1:0]    spare_rsp_o
);

  // Put everything on the request side into two FIFOs.
  // The first FIFO holds all data except the integrity bits of the `a_user` field. The second FIFO
  // only holds the command and data integrity bits of the `a_user` field. This is a FI
  // countermeasure, as a fault into one of the two FIFOs will trigger an integrity error once the
  // integrity bits are checked.
  localparam int unsigned REQFIFO_INTG_WIDTH = tlul_pkg::H2DCmdIntgWidth + tlul_pkg::DataIntgWidth;
  localparam int unsigned REQFIFO_WIDTH = $bits(tlul_pkg::tl_h2d_t) -2 + SpareReqW -
                                            REQFIFO_INTG_WIDTH;

  prim_fifo_sync #(.Width(REQFIFO_WIDTH), .Pass(ReqPass), .Depth(ReqDepth)) reqfifo (
    .clk_i,
    .rst_ni,
    .clr_i         (1'b0          ),
    .wvalid_i      (tl_h_i.a_valid),
    .wready_o      (tl_h_o.a_ready),
    .wdata_i       ({tl_h_i.a_opcode,
                     tl_h_i.a_param,
                     tl_h_i.a_size,
                     tl_h_i.a_source,
                     tl_h_i.a_address,
                     tl_h_i.a_mask,
                     tl_h_i.a_data,
                     tl_h_i.a_user.rsvd,
                     tl_h_i.a_user.instr_type,
                     spare_req_i}),
    .rvalid_o      (tl_d_o.a_valid),
    .rready_i      (tl_d_i.a_ready),
    .rdata_o       ({tl_d_o.a_opcode,
                     tl_d_o.a_param,
                     tl_d_o.a_size,
                     tl_d_o.a_source,
                     tl_d_o.a_address,
                     tl_d_o.a_mask,
                     tl_d_o.a_data,
                     tl_d_o.a_user.rsvd,
                     tl_d_o.a_user.instr_type,
                     spare_req_o}),
    .full_o        (),
    .depth_o       (),
    .err_o         ());

  // Buffer the inputs of the FIFO holding the integrity to avoid synthesis optimizations.
  localparam int NumBufferBitsReqFifoIntg = $bits({
    tl_h_i.a_valid,
    tl_d_i.a_ready
  });

  logic [NumBufferBitsReqFifoIntg-1:0] buf_reqfifo_intg_in, buf_reqfifo_intg_out;
  logic reqfifo_intg_a_valid_buf;
  logic reqfifo_intg_a_ready_buf;

  assign buf_reqfifo_intg_in = {
    tl_h_i.a_valid,
    tl_d_i.a_ready
  };

  assign {
    reqfifo_intg_a_valid_buf,
    reqfifo_intg_a_ready_buf
  } = buf_reqfifo_intg_out;

  prim_buf #(
    .Width(NumBufferBitsReqFifoIntg)
  ) u_reqfifo_intg_prim_buf (
    .in_i(buf_reqfifo_intg_in),
    .out_o(buf_reqfifo_intg_out)
  );

  prim_fifo_sync #(.Width(REQFIFO_INTG_WIDTH), .Pass(ReqPass), .Depth(ReqDepth)) reqfifo_intg (
    .clk_i,
    .rst_ni,
    .clr_i         (1'b0          ),
    .wvalid_i      (reqfifo_intg_a_valid_buf),
    .wready_o      (),
    .wdata_i       ({tl_h_i.a_user.cmd_intg,
                     tl_h_i.a_user.data_intg}),
    .rvalid_o      (),
    .rready_i      (reqfifo_intg_a_ready_buf),
    .rdata_o       ({tl_d_o.a_user.cmd_intg,
                     tl_d_o.a_user.data_intg}),
    .full_o        (),
    .depth_o       (),
    .err_o         ());

  // Put everything on the response side into the other two FIFOs.
  // The integrity bits and all other bits are separated into two different FIFOs for the same
  // reason as above.
  localparam int unsigned RSPFIFO_INTG_WIDTH = $bits(tlul_pkg::tl_d_user_t);
  localparam int unsigned RSPFIFO_WIDTH = $bits(tlul_pkg::tl_d2h_t) -2 + SpareRspW -
                                            RSPFIFO_INTG_WIDTH;

  prim_fifo_sync #(.Width(RSPFIFO_WIDTH), .Pass(RspPass), .Depth(RspDepth)) rspfifo (
    .clk_i,
    .rst_ni,
    .clr_i         (1'b0          ),
    .wvalid_i      (tl_d_i.d_valid),
    .wready_o      (tl_d_o.d_ready),
    .wdata_i       ({tl_d_i.d_opcode,
                     tl_d_i.d_param ,
                     tl_d_i.d_size  ,
                     tl_d_i.d_source,
                     tl_d_i.d_sink  ,
                     (tl_d_i.d_opcode == tlul_pkg::AccessAckData) ? tl_d_i.d_data :
                                                                    {top_pkg::TL_DW{1'b0}} ,
                     tl_d_i.d_error ,
                     spare_rsp_i}),
    .rvalid_o      (tl_h_o.d_valid),
    .rready_i      (tl_h_i.d_ready),
    .rdata_o       ({tl_h_o.d_opcode,
                     tl_h_o.d_param ,
                     tl_h_o.d_size  ,
                     tl_h_o.d_source,
                     tl_h_o.d_sink  ,
                     tl_h_o.d_data  ,
                     tl_h_o.d_error ,
                     spare_rsp_o}),
    .full_o        (),
    .depth_o       (),
    .err_o         ());

  // Buffer the inputs of the FIFO holding the integrity to avoid synthesis optimizations.
  localparam int NumBufferBitsRspFifoIntg = $bits({
    tl_d_i.d_valid,
    tl_h_i.d_ready
  });

  logic [NumBufferBitsRspFifoIntg-1:0] buf_rspfifo_intg_in, buf_rspfifo_intg_out;
  logic rspfifo_intg_d_valid_buf;
  logic rspfifo_intg_d_ready_buf;

  assign buf_rspfifo_intg_in = {
    tl_d_i.d_valid,
    tl_h_i.d_ready
  };

  assign {
    rspfifo_intg_d_valid_buf,
    rspfifo_intg_d_ready_buf
  } = buf_rspfifo_intg_out;

  prim_buf #(
    .Width(NumBufferBitsRspFifoIntg)
  ) u_rspfifo_intg_prim_buf (
    .in_i(buf_rspfifo_intg_in),
    .out_o(buf_rspfifo_intg_out)
  );

  prim_fifo_sync #(.Width(RSPFIFO_INTG_WIDTH), .Pass(RspPass), .Depth(RspDepth)) rspfifo_intg (
    .clk_i,
    .rst_ni,
    .clr_i         (1'b0          ),
    .wvalid_i      (rspfifo_intg_d_valid_buf),
    .wready_o      (),
    .wdata_i       (tl_d_i.d_user),
    .rvalid_o      (),
    .rready_i      (rspfifo_intg_d_ready_buf),
    .rdata_o       (tl_h_o.d_user),
    .full_o        (),
    .depth_o       (),
    .err_o         ());

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
// Combine InW data and write to OutW data if packed to full word or stop signal

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


// ICEBOX(#12958): Revise to send out the empty status.
module prim_packer #(
  parameter int unsigned InW  = 32,
  parameter int unsigned OutW = 32,

  // If 1, The input/output are byte granularity
  parameter int HintByteData = 0,

  // Turn on protect against FI for the pos variable
  parameter bit EnProtection = 1'b 0
) (
  input clk_i ,
  input rst_ni,

  input                   valid_i,
  input        [InW-1:0]  data_i,
  input        [InW-1:0]  mask_i,
  output                  ready_o,

  output logic            valid_o,
  output logic [OutW-1:0] data_o,
  output logic [OutW-1:0] mask_o,
  input                   ready_i,

  input                   flush_i,  // If 1, send out remnant and clear state
  output logic            flush_done_o,

  // When EnProtection is set, err_o raises an error case (position variable
  // mismatch)
  output logic            err_o
);

  localparam int unsigned Width    = InW + OutW;  // storage width
  localparam int unsigned ConcatW  = Width + InW; // Input concatenated width
  localparam int unsigned PtrW     = $clog2(ConcatW+1);
  localparam int unsigned IdxW     = prim_util_pkg::vbits(InW);
  localparam int unsigned OnesCntW = $clog2(InW+1);

  logic valid_next, ready_next;
  logic [Width-1:0]   stored_data, stored_mask;
  logic [ConcatW-1:0] concat_data, concat_mask;
  logic [ConcatW-1:0] shiftl_data, shiftl_mask;
  logic [InW-1:0]     shiftr_data, shiftr_mask;

  logic [PtrW-1:0]     pos_q;         // Current write position
  logic [IdxW-1:0]     lod_idx;       // result of Leading One Detector
  logic [OnesCntW-1:0] inmask_ones;   // Counting Ones for mask_i

  logic ack_in, ack_out;

  logic flush_valid; // flush data out request
  logic flush_done;

  // Computing next position ==================================================
  always_comb begin
    // counting mask_i ones
    inmask_ones = '0;
    for (int i = 0 ; i < InW ; i++) begin
      inmask_ones = inmask_ones + OnesCntW'(mask_i[i]);
    end
  end

  logic [PtrW-1:0] pos_with_input;
  assign pos_with_input = pos_q + PtrW'(inmask_ones);

  if (EnProtection == 1'b 0) begin : g_pos_nodup
    logic [PtrW-1:0] pos_d;

    always_comb begin
      pos_d = pos_q;

      unique case ({ack_in, ack_out})
        2'b00: pos_d = pos_q;
        2'b01: pos_d = (int'(pos_q) <= OutW) ? '0 : pos_q - PtrW'(OutW);
        2'b10: pos_d = pos_with_input;
        2'b11: pos_d = (int'(pos_with_input) <= OutW) ? '0 : pos_with_input - PtrW'(OutW);
        default: pos_d = pos_q;
      endcase
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        pos_q <= '0;
      end else if (flush_done) begin
        pos_q <= '0;
      end else begin
        pos_q <= pos_d;
      end
    end

    assign err_o = 1'b 0; // No checker logic

  end else begin : g_pos_dupcnt // EnProtection == 1'b 1
    // incr_en: Increase the pos by cnt_step. ack_in && !ack_out
    // decr_en: Decrease the pos by cnt_step. !ack_in && ack_out
    // set_en:  Set to specific value in case of ack_in && ack_out.
    //          This case, the value could be increased or decreased based on
    //          the input size (inmask_ones)
    logic            cnt_incr_en, cnt_decr_en, cnt_set_en;
    logic [PtrW-1:0] cnt_step, cnt_set;

    assign cnt_incr_en =  ack_in && !ack_out;
    assign cnt_decr_en = !ack_in &&  ack_out;
    assign cnt_set_en  =  ack_in &&  ack_out;

    // counter has underflow protection.
    assign cnt_step = (cnt_incr_en) ? PtrW'(inmask_ones) : PtrW'(OutW);

    always_comb begin : cnt_set_logic

      // default, consuming all data
      cnt_set = '0;

      if (pos_with_input > PtrW'(OutW)) begin
        // pos_q + inmask_ones is bigger than Output width. Still data remained.
        cnt_set = pos_with_input - PtrW'(OutW);
      end
    end : cnt_set_logic


    prim_count #(
      .Width      (PtrW),
      .ResetValue ('0  )
    ) u_pos (
      .clk_i,
      .rst_ni,

      .clr_i              (flush_done),

      .set_i              (cnt_set_en),
      .set_cnt_i          (cnt_set   ),

      .incr_en_i          (cnt_incr_en),
      .decr_en_i          (cnt_decr_en),
      .step_i             (cnt_step   ),
      .commit_i           (1'b1       ),

      .cnt_o              (pos_q     ), // Current counter state
      .cnt_after_commit_o (          ), // Next counter state

      .err_o
    );
  end // g_pos_dupcnt

  //---------------------------------------------------------------------------

  // Leading one detector for mask_i
  always_comb begin
    lod_idx = 0;
    for (int i = InW-1; i >= 0 ; i--) begin
      if (mask_i[i] == 1'b1) begin
        lod_idx = IdxW'(unsigned'(i));
      end
    end
  end

  assign ack_in  = valid_i & ready_o;
  assign ack_out = valid_o & ready_i;

  // Data process =============================================================
  //  shiftr : Input data shifted right to put the leading one at bit zero
  assign shiftr_data = (valid_i) ? data_i >> lod_idx : '0;
  assign shiftr_mask = (valid_i) ? mask_i >> lod_idx : '0;

  //  shiftl : Input data shifted into the current stored position
  assign shiftl_data = ConcatW'(shiftr_data) << pos_q;
  assign shiftl_mask = ConcatW'(shiftr_mask) << pos_q;

  // concat : Merging stored and shiftl
  assign concat_data = {{(InW){1'b0}}, stored_data & stored_mask} |
                       (shiftl_data & shiftl_mask);
  assign concat_mask = {{(InW){1'b0}}, stored_mask} | shiftl_mask;

  logic [Width-1:0] stored_data_next, stored_mask_next;

  always_comb begin
    unique case ({ack_in, ack_out})
      2'b 00: begin
        stored_data_next = stored_data;
        stored_mask_next = stored_mask;
      end
      2'b 01: begin
        // ack_out : shift the amount of OutW
        stored_data_next = {{OutW{1'b0}}, stored_data[Width-1:OutW]};
        stored_mask_next = {{OutW{1'b0}}, stored_mask[Width-1:OutW]};
      end
      2'b 10: begin
        // ack_in : Store concat data
        stored_data_next = concat_data[0+:Width];
        stored_mask_next = concat_mask[0+:Width];
      end
      2'b 11: begin
        // both : shift the concat_data
        stored_data_next = concat_data[ConcatW-1:OutW];
        stored_mask_next = concat_mask[ConcatW-1:OutW];
      end
      default: begin
        stored_data_next = stored_data;
        stored_mask_next = stored_mask;
      end
    endcase
  end

  // Store the data temporary if it doesn't exceed OutW
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      stored_data <= '0;
      stored_mask <= '0;
    end else if (flush_done) begin
      stored_data <= '0;
      stored_mask <= '0;
    end else begin
      stored_data <= stored_data_next;
      stored_mask <= stored_mask_next;
    end
  end
  //---------------------------------------------------------------------------

  // flush handling
  typedef enum logic {
    FlushIdle,
    FlushSend
  } flush_st_e;
  flush_st_e flush_st, flush_st_next;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      flush_st <= FlushIdle;
    end else begin
      flush_st <= flush_st_next;
    end
  end

  always_comb begin
    flush_st_next = FlushIdle;

    flush_valid = 1'b0;
    flush_done  = 1'b0;

    unique case (flush_st)
      FlushIdle: begin
        if (flush_i) begin
          flush_st_next = FlushSend;
        end else begin
          flush_st_next = FlushIdle;
        end
      end

      FlushSend: begin
        if (pos_q == '0) begin
          flush_st_next = FlushIdle;

          flush_valid = 1'b 0;
          flush_done  = 1'b 1;
        end else begin
          flush_st_next = FlushSend;

          flush_valid = 1'b 1;
          flush_done  = 1'b 0;
        end
      end
      default: begin
        flush_st_next = FlushIdle;

        flush_valid = 1'b 0;
        flush_done  = 1'b 0;
      end
    endcase
  end

  assign flush_done_o = flush_done;


  // Output signals ===========================================================
  assign valid_next = (int'(pos_q) >= OutW) ? 1'b 1 : flush_valid;

  // storage space is InW + OutW. So technically, ready_o can be asserted even
  // if `pos_q` is greater than OutW. But in order to do that, the logic should
  // use `inmask_ones` value whether pos_q+inmask_ones is less than (InW+OutW)
  // with `valid_i`. It creates a path from `valid_i` --> `ready_o`.
  // It may create a timing loop in some modules that use `ready_o` to
  // `valid_i` (which is not a good practice though)
  assign ready_next = int'(pos_q) <= OutW;

  // Output request
  assign valid_o = valid_next;
  assign data_o  = stored_data[OutW-1:0];
  assign mask_o  = stored_mask[OutW-1:0];

  // ready_o
  assign ready_o = ready_next;
  //---------------------------------------------------------------------------

  //////////////////////////////////////////////
  // Assertions, Assumptions, and Coverpoints //
  //////////////////////////////////////////////
  // Assumption: mask_i should be contiguous ones
  // e.g: 0011100 --> OK
  //      0100011 --> Not OK
  if (InW > 1) begin : gen_mask_assert
    
  end

  // Flush and Write Enable cannot be asserted same time
  

  // While in flush state, new request shouldn't come
  

  // If not acked, input port keeps asserting valid and data
  

  

  // If not acked, valid_o should keep asserting
  

  // If stored data is greater than the output width, valid should be asserted
  

  // If output port doesn't accept the data, the data should be stable
  

  // If input data & stored data are greater than OutW, remained should be stored
  

  

  // Assertions for byte hint enabled
  if (HintByteData != 0) begin : g_byte_assert
    
    

    // Masking[8*i+:8] should be all zero or all one
    for (genvar i = 0 ; i < InW/8 ; i++) begin : g_byte_input_masking
      
    end
    for (genvar i = 0 ; i < OutW/8 ; i++) begin : g_byte_output_masking
      
    end
  end
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
 * Tile-Link UL adapter for SRAM-like devices
 *
 * This module handles byte writes for tlul integrity.
 * When a byte write is received, the downstream data is read first
 * to correctly create the integrity constant.
 *
 * A tlul transaction goes through this module.  If required, a
 * tlul read transaction is generated out first.  If not required, the
 * incoming tlul transaction is directly muxed out.
 */
module tlul_sram_byte import tlul_pkg::*; #(
  parameter bit EnableIntg     = 0, // Enable integrity handling at byte level,
  parameter int Outstanding    = 1,
  parameter bit EnableReadback = 0  // Enable readback checks on all transactions must have
                                    // EnableIntg == 1 to enable
) (
  input clk_i,
  input rst_ni,

  input tl_h2d_t tl_i,
  output tl_d2h_t tl_o,

  output tl_h2d_t tl_sram_o,
  input tl_d2h_t tl_sram_i,

  // if incoming transaction already has an error, do not
  // attempt to handle the byte-write access.  Instead treat as
  // feedthrough and allow the system to directly error back.
  // The error indication is also fed through
  input error_i,
  output logic error_o,
  output logic alert_o,

  output logic compound_txn_in_progress_o,

  input prim_mubi_pkg::mubi4_t readback_en_i,

  input logic wr_collision_i,
  input logic write_pending_i
);

  import prim_mubi_pkg::mubi4_t;
  import prim_mubi_pkg::mubi4_test_true_loose;
  import prim_mubi_pkg::mubi4_test_false_strict;
  import prim_mubi_pkg::MuBi4True;
  import prim_mubi_pkg::MuBi4False;
  import prim_mubi_pkg::MuBi4Width;

  // Encoding generated with:
  // $ ./util/design/sparse-fsm-encode.py -d 3 -m 11 -n 8 \
  //     -s 718546395 --language=sv
  //
  // Hamming distance histogram:
  //
  //  0: --
  //  1: --
  //  2: --
  //  3: |||||||||||||| (25.45%)
  //  4: |||||||||||||||||||| (36.36%)
  //  5: |||||||||||| (21.82%)
  //  6: ||||||| (12.73%)
  //  7: || (3.64%)
  //  8: --
  //
  // Minimum Hamming distance: 3
  // Maximum Hamming distance: 7
  // Minimum Hamming weight: 1
  // Maximum Hamming weight: 6
  //
  localparam int StateWidth = 8;
  typedef enum logic [StateWidth-1:0] {
    StPassThru              = 8'b01111110,
    StWaitRd                = 8'b00000010,
    StWriteCmd              = 8'b11110001,
    StWrReadBackInit        = 8'b10011001,
    StWrReadBack            = 8'b00001111,
    StWrReadBackDWait       = 8'b00110000,
    StRdReadBack            = 8'b10101100,
    StRdReadBackDWait       = 8'b11000000,
    StByteWrReadBackInit    = 8'b01010111,
    StByteWrReadBack        = 8'b11100111,
    StByteWrReadBackDWait   = 8'b11111111
  } state_e;

  if (EnableIntg) begin : gen_integ_handling
    // state and selection
    logic stall_host;
    logic wait_phase;
    logic rd_phase;
    logic rd_wait;
    logic wr_phase;
    logic rdback_phase;
    logic rdback_phase_wrreadback;
    logic rdback_wait;
    logic readback_err;
    logic sync_fifo_a_size_outputs_mismatch;
    logic sync_fifo_outputs_mismatch;
    logic tl_i_fifo_intg_err, tl_intg_err;
    state_e state_d, state_q;

    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        state_q <= StPassThru;
      end else begin
        state_q <= state_d;
      end
    end

    // transaction qualifying signals
    logic a_ack;  // upstream a channel acknowledgement
    logic d_ack;  // upstream d channel acknowledgement
    logic sram_a_ack; // downstream a channel acknowledgement
    logic sram_d_ack; // downstream d channel acknowledgement
    logic wr_txn;
    logic byte_wr_txn;
    logic byte_req_ack;
    logic hold_tx_data;

    localparam int unsigned PendingTxnCntW = prim_util_pkg::vbits(Outstanding+1);

    // prim fifo for capturing info
    typedef struct packed {
      tl_a_op_e                       a_opcode;
      logic                     [2:0] a_param;
      logic     [top_pkg::TL_SZW-1:0] a_size;
      logic     [top_pkg::TL_AIW-1:0] a_source;
      logic      [top_pkg::TL_AW-1:0] a_address;
      logic     [top_pkg::TL_DBW-1:0] a_mask;
      logic      [top_pkg::TL_DW-1:0] a_data;
      logic [tlul_pkg::RsvdWidth-1:0] a_user_rsvd;
      prim_mubi_pkg::mubi4_t          a_user_instr_type;
    } tl_txn_data_t;

    typedef struct packed {
      logic [tlul_pkg::H2DCmdIntgWidth-1:0] a_user_cmd_intg;
      logic   [tlul_pkg::DataIntgWidth-1:0] a_user_data_intg;
    } tl_txn_intg_t;

    tl_txn_data_t held_data;
    tl_txn_intg_t held_intg;

    // Outputs of the sync_fifo_a_size FIFOs.
    typedef struct packed {
      logic [PendingTxnCntW-1:0]  pending_txn_cnt;
      logic [top_pkg::TL_SZW-1:0] a_size;
      logic                       size_fifo_rdy;
    } sync_fifo_a_size_outputs_t;

    sync_fifo_a_size_outputs_t sync_fifo_a_size_outputs;
    sync_fifo_a_size_outputs_t sync_fifo_a_size_shadow_outputs;

    assign a_ack = tl_i.a_valid & tl_o.a_ready;
    assign d_ack = tl_o.d_valid & tl_i.d_ready;
    assign sram_a_ack = tl_sram_o.a_valid & tl_sram_i.a_ready;
    assign sram_d_ack = tl_sram_i.d_valid & tl_sram_o.d_ready;
    assign wr_txn = (tl_i.a_opcode == PutFullData) | (tl_i.a_opcode == PutPartialData);

    assign byte_req_ack = byte_wr_txn & a_ack & ~error_i;
    assign byte_wr_txn = tl_i.a_valid & ~&tl_i.a_mask & wr_txn;

    // Alert generation.
    assign alert_o = readback_err | sync_fifo_a_size_outputs_mismatch |
      sync_fifo_outputs_mismatch | tl_intg_err;

    logic                     rdback_chk_ok;
    mubi4_t                   rdback_check_q, rdback_check_d;
    mubi4_t                   rdback_en_q, rdback_en_d;
    logic [31:0]              rdback_data_exp_q, rdback_data_exp_d;
    logic [DataIntgWidth-1:0] rdback_data_exp_intg_q, rdback_data_exp_intg_d;

    if (EnableReadback) begin : gen_readback_logic
      logic rdback_chk_ok_unbuf;

      assign rdback_chk_ok_unbuf = (rdback_data_exp_q == tl_sram_i.d_data);

      prim_sec_anchor_buf #(
        .Width(1)
      ) u_rdback_chk_ok_buf (
        .in_i (rdback_chk_ok_unbuf),
        .out_o(rdback_chk_ok)
      );

      prim_flop #(
        .Width(MuBi4Width),
        .ResetValue(MuBi4Width'(MuBi4False))
      ) u_rdback_check_flop (
        .clk_i,
        .rst_ni,

        .d_i(MuBi4Width'(rdback_check_d)),
        .q_o({rdback_check_q})
      );

      prim_flop #(
        .Width(MuBi4Width),
        .ResetValue(MuBi4Width'(MuBi4False))
      ) u_rdback_en_flop (
        .clk_i,
        .rst_ni,

        .d_i(MuBi4Width'(rdback_en_d)),
        .q_o({rdback_en_q})
      );

      prim_flop #(
        .Width(32),
        .ResetValue(0)
      ) u_rdback_data_exp (
        .clk_i,
        .rst_ni,

        .d_i(rdback_data_exp_d),
        .q_o(rdback_data_exp_q)
      );

      prim_flop #(
        .Width(DataIntgWidth),
        .ResetValue(0)
      ) u_rdback_data_exp_intg (
        .clk_i,
        .rst_ni,

        .d_i(rdback_data_exp_intg_d),
        .q_o(rdback_data_exp_intg_q)
      );

    // If the readback feature is enabled and we are currently in the readback phase,
    // no address collision should happen inside prim_ram_1p_scr. If this would be the
    // case, we would read from the holding register inside prim_ram_1p_scr instead of
    // actually performing the readback from the memory.
    


    // If the readback feature is enabled, we assume that the write phase takes one extra cycle
    // due to the underlying scrambling mechanism. If this additional cycle is not needed anymore
    // in the future (e.g. due to the removal of the scrambling mechanism), the readback does not
    // need to be delayed by one cycle in the FSM below.
    


    end else begin: gen_no_readback_logic
      assign rdback_chk_ok          = 1'b0;
      assign rdback_check_q         = MuBi4False;
      assign rdback_en_q            = MuBi4False;
      assign rdback_data_exp_q      = 1'b0;
      assign rdback_data_exp_intg_q = 1'b0;

      logic unused_rdback;

      assign unused_rdback = ^{rdback_check_d, rdback_data_exp_d, rdback_data_exp_intg_d,
                               rdback_en_d};
    end

    // state machine handling
    always_comb begin
      rd_wait = 1'b0;
      wait_phase = 1'b0;
      stall_host = 1'b0;
      wr_phase = 1'b0;
      rd_phase = 1'b0;
      rdback_phase = 1'b0;
      rdback_phase_wrreadback = 1'b0;
      rdback_wait = 1'b0;
      state_d = state_q;
      hold_tx_data = 1'b0;
      readback_err = 1'b0;
      rdback_check_d = rdback_check_q;
      rdback_en_d = rdback_en_q;
      rdback_data_exp_d  = rdback_data_exp_q;
      rdback_data_exp_intg_d  = rdback_data_exp_intg_q;

      unique case (state_q)
        StPassThru: begin
          if (mubi4_test_true_loose(rdback_en_q) && mubi4_test_true_loose(rdback_check_q)) begin
            // When we're expecting a readback check that means we'll see a data response from the
            // SRAM this cycle which we need to check against the readback registers. During this
            // cycle the data response out (via tl_o) will be squashed to invalid but we can accept
            // a new transaction (via tl_i).
            rdback_wait    = 1'b1;
            rdback_check_d = MuBi4False;

            // Perform the readback check.
            if (!rdback_chk_ok) begin
              readback_err = 1'b1;
            end
          end

          if (byte_wr_txn) begin
            rd_phase = 1'b1;
            if (byte_req_ack) begin
              state_d = StWaitRd;
            end
          end else if (a_ack && mubi4_test_true_loose(rdback_en_q) && !error_i) begin
            // For reads and full word writes we'll first do the transaction and then do a readback
            // check. Setting `hold_tx_data` here will preserve the transaction information in
            // u_sync_fifo for doing the readback transaction.
            hold_tx_data = 1'b1;
            state_d      = wr_txn ? StWrReadBackInit : StRdReadBack;
          end

          if (!tl_sram_o.a_valid && !tl_o.d_valid &&
              mubi4_test_false_strict(rdback_check_q)) begin
            // Store readback enable into register when bus is idle and no readback is processed.
            rdback_en_d = readback_en_i;
          end
        end

        // Due to the way things are serialized, there is no way for the logic to tell which read
        // belongs to the partial read unless it flushes all prior transactions. Hence, we wait
        // here until exactly one outstanding transaction remains (that one is the partial read).
        StWaitRd: begin
          rd_phase = 1'b1;
          stall_host = 1'b1;
          if (sync_fifo_a_size_outputs.pending_txn_cnt == PendingTxnCntW'(1)) begin
            rd_wait = 1'b1;
            if (sram_d_ack) begin
              state_d = StWriteCmd;
            end
          end
        end

        StWriteCmd: begin
          stall_host = 1'b1;
          wr_phase = 1'b1;

          if (sram_a_ack) begin
            state_d = mubi4_test_true_loose(rdback_en_q) ? StByteWrReadBackInit : StPassThru;
            rdback_check_d         = mubi4_test_true_loose(rdback_en_q) ? MuBi4True : MuBi4False;
            rdback_data_exp_d      = tl_sram_o.a_data;
            rdback_data_exp_intg_d = tl_sram_o.a_user.data_intg;
          end
        end

        StWrReadBackInit: begin
          // Perform readback after full write. To avoid that we read the holding register
          // in the readback, wait until the write was processed by the memory module.
          if (EnableReadback == 0) begin : gen_inv_state_StWrReadBackInit
            // If readback is disabled, we shouldn't be in this state.
            readback_err = 1'b1;
          end

          // Stall the host to perform the readback in the next cycle.
          stall_host = 1'b1;

          // Need to ensure there's no other transactions in flight before we do the readback (the
          // initial write we're doing the readback for should be the only one active).
          if (sync_fifo_a_size_outputs.pending_txn_cnt == PendingTxnCntW'(1)) begin
            wait_phase  = 1'b1;
            // Data we're checking against the readback is captured from the write transaction that
            // was sent.
            rdback_check_d         = mubi4_test_true_loose(rdback_en_q) ? MuBi4True : MuBi4False;
            rdback_data_exp_d      = held_data.a_data;
            rdback_data_exp_intg_d = held_intg.a_user_data_intg;
            if (d_ack) begin
              // Got an immediate TL-UL write response. Wait for one cycle until the holding
              // register is flushed and then perform the readback.
              state_d = StWrReadBack;
            end else  begin
              // No response yet to the initial write.
              state_d = StWrReadBackDWait;
            end
          end
        end

        StWrReadBack: begin
          // Perform readback and check response in StPassThru.
          if (EnableReadback == 0) begin : gen_inv_state_StWrReadBack
            // If readback is disabled, we shouldn't be in this state.
            readback_err = 1'b1;
          end

          stall_host = 1'b1;

          rdback_phase = 1'b1;

          state_d = StPassThru;
        end

        StWrReadBackDWait: begin
          // We have not received the d_valid response of the initial write. Wait
          // for the valid signal.
          if (EnableReadback == 0) begin : gen_inv_state_StWrReadBackDWait
            // If readback is disabled, we shouldn't be in this state.
            readback_err = 1'b1;
          end

          // Wait until we get write response.
          wait_phase  = 1'b1;

          stall_host = 1'b1;

          if (d_ack) begin
            // Got the TL-UL write response. Wait for one cycle until the holding
            // register is flushed and then perform the readback.
            state_d = StWrReadBack;
          end
        end

        StByteWrReadBackInit: begin
          // Perform readback after partial write. To avoid that we read the holding register
          // in the readback, do the actual readback check in the next FSM state.
          if (EnableReadback == 0) begin : gen_inv_state_StByteWrReadBackInit
            // If readback is disabled, we shouldn't be in this state.
            readback_err = 1'b1;
          end

          // Sends out a read to a readback check on a partial write. The host is stalled whilst
          // this is happening.
          stall_host = 1'b1;

          // Wait for one cycle with sending readback request to SRAM to avoid reading from
          // holding register.
          wait_phase  = 1'b1;

          if (d_ack) begin
            // Got an immediate TL-UL write response. Wait for one cycle until the holding
            // register is flushed and then perform the readback.
            state_d = StByteWrReadBack;
          end else begin
            // No response received for initial write. We already can send the
            // request for the readback in the next cycle but we need to wait
            // for the response for the initial write before doing the readback
            // check.
            state_d = StByteWrReadBackDWait;
          end
        end

        StByteWrReadBack: begin
          // Wait until the memory module has completed the partial write.
          // Perform readback and check response in StPassThru.
          if (EnableReadback == 0) begin : gen_inv_state_StByteWrReadBack
            // If readback is disabled, we shouldn't be in this state.
            readback_err = 1'b1;
          end

          stall_host = 1'b1;

          rdback_phase_wrreadback = 1'b1;

          state_d = StPassThru;
        end

        StByteWrReadBackDWait: begin
          if (EnableReadback == 0) begin : gen_inv_state_StByteWrReadBackDWait
            // If readback is disabled, we shouldn't be in this state.
            readback_err = 1'b1;
          end

          stall_host = 1'b1;

          // Wait for one cycle with sending readback request to SRAM.
          wait_phase  = 1'b1;

          if (d_ack) begin
            // Got the TL-UL write response. Wait for one cycle until the holding
            // register is flushed and then perform the readback.
            state_d = StByteWrReadBack;
          end
        end

        StRdReadBack: begin
          if (EnableReadback == 0) begin : gen_inv_state_StRdReadBack
            // If readback is disabled, we shouldn't be in this state.
            readback_err = 1'b1;
          end

          // Sends out a read to a readback check on a read. The host is stalled whilst
          // this is happening.
          stall_host = 1'b1;

          // Need to ensure there's no other transactions in flight before we do the readback (the
          // read we're doing the readback for should be the only one active).
          if (sync_fifo_a_size_outputs.pending_txn_cnt == PendingTxnCntW'(1)) begin
            rdback_phase = 1'b1;

            if (d_ack) begin
              state_d                = StPassThru;
              // Data for the readback check comes from the first read.
              rdback_check_d         = mubi4_test_true_loose(rdback_en_q) ? MuBi4True : MuBi4False;
              rdback_data_exp_d      = tl_o.d_data;
              rdback_data_exp_intg_d = tl_o.d_user.data_intg;
            end else  begin
              // No response yet to the initial read, so go wait for it.
              state_d = StRdReadBackDWait;
            end
          end
        end

        StRdReadBackDWait : begin
          if (EnableReadback == 0) begin : gen_inv_state_StRdReadBackDWait
            // If readback is disabled, we shouldn't be in this state.
            readback_err = 1'b1;
          end

          stall_host = 1'b1;

          if (d_ack) begin
            // Response received for first read. Now need to await data for the readback check
            // which is done in the `StPassThru` state.
            state_d                = StPassThru;
            // Data for the readback check comes from the first read.
            rdback_check_d         = mubi4_test_true_loose(rdback_en_q) ? MuBi4True : MuBi4False;
            rdback_data_exp_d      = tl_o.d_data;
            rdback_data_exp_intg_d = tl_o.d_user.data_intg;
          end
        end

        default: begin
          readback_err = 1'b1;
        end
      endcase // unique case (state_q)

    end

    tl_txn_data_t txn_data;
    tl_txn_intg_t txn_intg;
    logic fifo_rdy_data, fifo_rdy_intg;
    logic txn_data_intg_wr;
    localparam int TxnDataWidth = $bits(tl_txn_data_t);
    localparam int TxnIntgWidth = $bits(tl_txn_intg_t);

    assign txn_data = '{
      a_opcode: tl_i.a_opcode,
      a_param: tl_i.a_param,
      a_size: tl_i.a_size,
      a_source: tl_i.a_source,
      a_address: tl_i.a_address,
      a_mask: tl_i.a_mask,
      a_data: tl_i.a_data,
      a_user_rsvd: tl_i.a_user.rsvd,
      a_user_instr_type: tl_i.a_user.instr_type
    };

    assign txn_intg = '{
      a_user_cmd_intg: tl_i.a_user.cmd_intg,
      a_user_data_intg: tl_i.a_user.data_intg
    };

    assign txn_data_intg_wr = hold_tx_data | byte_req_ack;

    prim_fifo_sync #(
      .Width(TxnDataWidth),
      .Pass(1'b0),
      .Depth(1),
      .OutputZeroIfEmpty(1'b0),
      .NeverClears(1'b1)
    ) u_sync_fifo_data (
      .clk_i,
      .rst_ni,
      .clr_i(1'b0),
      .wvalid_i(txn_data_intg_wr),
      .wready_o(fifo_rdy_data),
      .wdata_i(txn_data),
      .rvalid_o(),
      .rready_i(sram_a_ack),
      .rdata_o(held_data),
      .full_o(),
      .depth_o(),
      .err_o()
    );

     // Buffer the inputs of the FIFO holding the integrity to avoid synthesis optimizations.
    localparam int NumBufferBitsSyncIntg = $bits({
      txn_data_intg_wr,
      sram_a_ack
    });

    logic [NumBufferBitsSyncIntg-1:0] buf_sync_fifo_intg_in, buf_sync_fifo_intg_out;
    logic txn_data_intg_wr_buf;
    logic sram_a_ack_buf;

    assign buf_sync_fifo_intg_in = {
      txn_data_intg_wr,
      sram_a_ack
    };

    assign {
      txn_data_intg_wr_buf,
      sram_a_ack_buf
    } = buf_sync_fifo_intg_out;

    prim_buf #(
      .Width(NumBufferBitsSyncIntg)
    ) u_sync_fifo_intg_prim_buf (
      .in_i(buf_sync_fifo_intg_in),
      .out_o(buf_sync_fifo_intg_out)
    );

    prim_fifo_sync #(
      .Width(TxnIntgWidth),
      .Pass(1'b0),
      .Depth(1),
      .OutputZeroIfEmpty(1'b0),
      .NeverClears(1'b1)
    ) u_sync_fifo_intg (
      .clk_i,
      .rst_ni,
      .clr_i(1'b0),
      .wvalid_i(txn_data_intg_wr_buf),
      .wready_o(fifo_rdy_intg),
      .wdata_i(txn_intg),
      .rvalid_o(),
      .rready_i(sram_a_ack_buf),
      .rdata_o(held_intg),
      .full_o(),
      .depth_o(),
      .err_o()
    );

    // Raise an alert if there is a mismatch in the duplicated FIFOs.
    assign sync_fifo_outputs_mismatch = (fifo_rdy_data != fifo_rdy_intg);

    // Re-assemble the incoming tl_i request after the FIFO to check its integrity.
    tl_a_user_t tl_i_fifo_a_user;
    tl_h2d_t tl_i_fifo;
    assign tl_i_fifo_a_user = '{
      rsvd: held_data.a_user_rsvd,
      instr_type: held_data.a_user_instr_type,
      cmd_intg: held_intg.a_user_cmd_intg,
      data_intg: held_intg.a_user_data_intg
    };

    assign tl_i_fifo = '{
      a_valid: sram_a_ack,
      a_opcode: held_data.a_opcode,
      a_param: held_data.a_param,
      a_size: held_data.a_size,
      a_source: held_data.a_source,
      a_address: held_data.a_address,
      a_mask: held_data.a_mask,
      a_data: held_data.a_data,
      a_user: tl_i_fifo_a_user,
      d_ready:  1'b1
    };

    tlul_cmd_intg_chk u_cmd_intg_chk (
      .tl_i(tl_i_fifo),
      .err_o (tl_i_fifo_intg_err)
    );

    // Enable the integrity check comparison once we have seen the first write to the FIFO.
    // This is necessary as the u_sync_fifo_data/intg FIFOs do not use the OutputZeroIfEmpty
    // option. Hence, after reset, the FFs within the FIFO are not initialized, resulting in
    // integrity and DV failures (firing X assertions).
    logic enable_intg_check_cmp_q;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        enable_intg_check_cmp_q <= 1'b0;
      end else if (txn_data_intg_wr)begin
        enable_intg_check_cmp_q <= 1'b1;
      end
    end

    assign tl_intg_err = enable_intg_check_cmp_q & tl_i_fifo_intg_err;

    // captured read data
    logic [top_pkg::TL_DW-1:0] rsp_data;
    always_ff @(posedge clk_i) begin
      if (sram_d_ack && rd_wait) begin
        rsp_data <= tl_sram_i.d_data;
      end
    end

    // while we could simply not assert a_ready to ensure the host keeps
    // the request lines stable, there is no guarantee the hosts (if there are multiple)
    // do not re-arbitrate on every cycle if its transactions are not accepted.
    // As a result, it is better to capture the transaction attributes.
    logic [top_pkg::TL_DW-1:0] combined_data, unused_data;
    always_comb begin
      for (int i = 0; i < top_pkg::TL_DBW; i++) begin
        combined_data[i*8 +: 8] = held_data.a_mask[i] ?
                                  held_data.a_data[i*8 +: 8] :
                                  rsp_data[i*8 +: 8];
      end
    end

    // Compute updated integrity bits for the data.
    // Note that the CMD integrity does not have to be correct, since it is not consumed nor
    // checked further downstream.
    logic [tlul_pkg::DataIntgWidth-1:0] data_intg;

    tlul_data_integ_enc u_tlul_data_integ_enc (
      .data_i(combined_data),
      .data_intg_o({data_intg, unused_data})
    );

    tl_a_user_t combined_user;
    always_comb begin
      combined_user.cmd_intg   = held_intg.a_user_cmd_intg;
      combined_user.data_intg  = data_intg;
      combined_user.rsvd       = held_data.a_user_rsvd;
      combined_user.instr_type = held_data.a_user_instr_type;
    end

    localparam int unsigned AccessSize = $clog2(top_pkg::TL_DBW);
    always_comb begin
      // Pass-through by default
      tl_sram_o = tl_i;
      // If we're waiting for an internal read for RMW, or a readback read, we force this to 1.
      tl_sram_o.d_ready = tl_i.d_ready | rd_wait | rdback_wait;

      // We take over the TL-UL bus if there is a pending read or write for the RMW transaction.
      // TL-UL signals are selectively muxed below to reduce complexity and remove long timing
      // paths through the error_i signal. In particular, we avoid creating paths from error_i
      // to the address and data output since these may feed into RAM scrambling logic further
      // downstream.

      // Write transactions for RMW or reads when in readback mode.
      if (wr_phase | rdback_phase | rdback_phase_wrreadback) begin
        tl_sram_o.a_valid   = 1'b1;
        // During a read-modify write, always access the entire word.
        tl_sram_o.a_opcode  = wr_phase ? PutFullData : Get;
        // In either read-modify write or SRAM readback mode, use the mask, size and address
        // of the original request.
        tl_sram_o.a_size =
            (wr_phase | rdback_phase_wrreadback) ? top_pkg::TL_SZW'(AccessSize) : held_data.a_size;
        tl_sram_o.a_mask =
            (wr_phase | rdback_phase_wrreadback) ? '{default: '1}               : held_data.a_mask;
        // override with held / combined data.
        // need to use word aligned addresses here.
        tl_sram_o.a_address = held_data.a_address;
        tl_sram_o.a_address[AccessSize-1:0] =
            (wr_phase | rdback_phase_wrreadback) ? '0 : held_data.a_address[AccessSize-1:0];
        tl_sram_o.a_source  = held_data.a_source;
        tl_sram_o.a_param   = held_data.a_param;
        tl_sram_o.a_data    = wr_phase ? combined_data : '0;
        tl_sram_o.a_user    = wr_phase ? combined_user : '0;
      // Read transactions for RMW.
      end else if (rd_phase) begin
        // need to use word aligned addresses here.
        tl_sram_o.a_address[AccessSize-1:0] = '0;
        // Only override the control signals if there is no error at the input.
        if (!error_i || stall_host) begin
          // Since we are performing a read-modify-write operation,
          // we always access the entire word.
          tl_sram_o.a_size    = top_pkg::TL_SZW'(AccessSize);
          tl_sram_o.a_mask    = '{default: '1};
          // use incoming valid as long as we are not stalling the host
          tl_sram_o.a_valid   = tl_i.a_valid & ~stall_host;
          tl_sram_o.a_opcode  = Get;
        end
      end else if (wait_phase) begin
        // Delay the readback request to avoid that we are reading the holding
        // register.
        tl_sram_o.a_valid = 1'b0;
      end
    end

    // This assert is necessary for the casting of AccessSize.
    

    assign error_o = error_i & ~stall_host;

    prim_fifo_sync #(
      .Width(top_pkg::TL_SZW),
      .Pass(1'b0),
      .Depth(Outstanding),
      .OutputZeroIfEmpty(1'b1),
      .NeverClears(1'b1)
    ) u_sync_fifo_a_size (
      .clk_i,
      .rst_ni,
      .clr_i(1'b0),
      .wvalid_i(a_ack),
      .wready_o(sync_fifo_a_size_outputs.size_fifo_rdy),
      .wdata_i(tl_i.a_size),
      .rvalid_o(),
      .rready_i(d_ack),
      .rdata_o(sync_fifo_a_size_outputs.a_size),
      .full_o(),
      .depth_o(sync_fifo_a_size_outputs.pending_txn_cnt),
      .err_o()
    );

    // Create a shadow copy of the u_sync_fifo_a_size FIFO and compare its output.
    localparam int NumBufferBitsSyncASize = $bits({
      a_ack,
      tl_i.a_size,
      d_ack
    });

    logic [NumBufferBitsSyncASize-1:0] buf_sync_fifo_a_size_in, buf_sync_fifo_a_size_out;
    logic a_ack_buf;
    logic d_ack_buf;
    logic [top_pkg::TL_SZW-1:0] a_size_buf;

    assign buf_sync_fifo_a_size_in = {
      a_ack,
      tl_i.a_size,
      d_ack
    };

    assign {
      a_ack_buf,
      a_size_buf,
      d_ack_buf
    } = buf_sync_fifo_a_size_out;

    // Buffer the inputs of the FIFO to avoid synthesis optimizations.
    prim_buf #(
      .Width(NumBufferBitsSyncASize)
    ) u_sync_fifo_a_size_prim_buf (
      .in_i(buf_sync_fifo_a_size_in),
      .out_o(buf_sync_fifo_a_size_out)
    );

    prim_fifo_sync #(
      .Width(top_pkg::TL_SZW),
      .Pass(1'b0),
      .Depth(Outstanding),
      .OutputZeroIfEmpty(1'b1),
      .NeverClears(1'b1)
    ) u_sync_fifo_a_size_shadow (
      .clk_i,
      .rst_ni,
      .clr_i(1'b0),
      .wvalid_i(a_ack_buf),
      .wready_o(sync_fifo_a_size_shadow_outputs.size_fifo_rdy),
      .wdata_i(a_size_buf),
      .rvalid_o(),
      .rready_i(d_ack_buf),
      .rdata_o(sync_fifo_a_size_shadow_outputs.a_size),
      .full_o(),
      .depth_o(sync_fifo_a_size_shadow_outputs.pending_txn_cnt),
      .err_o()
    );

    // Raise an alert if there is a mismatch in the duplicated FIFOs.
    assign sync_fifo_a_size_outputs_mismatch =
      (sync_fifo_a_size_shadow_outputs != sync_fifo_a_size_outputs);

    always_comb begin
      tl_o = tl_sram_i;

      // pass a_ready through directly if we are not stalling
      tl_o.a_ready = tl_sram_i.a_ready & ~stall_host & fifo_rdy_data &
        sync_fifo_a_size_outputs.size_fifo_rdy;

      // when internal logic has taken over, do not show response to host during
      // read phase.  During write phase, allow the host to see the completion.
      tl_o.d_valid = tl_sram_i.d_valid & ~rd_wait & ~rdback_wait;

      // the size returned by tl_sram_i does not always correspond to the actual
      // transaction size in cases where a read modify write operation is
      // performed. Hence, we always return the registered size here.
      tl_o.d_size  = sync_fifo_a_size_outputs.a_size;
    end // always_comb

    // unused info from tl_sram_i
    // see explanation in above block
    logic unused_tl;
    assign unused_tl = |tl_sram_i.d_size;

    // when byte access detected, go to wait read
    
    // when in wait for read, a successful response should move to write phase
    
    // The readback logic assumes that any request on the readback channel will be instantly granted
    // (i.e. after the initial SRAM read or write request from the external requester has been
    // granted). This helps simplify the logic. It is guaranteed when connected to an SRAM as it
    // produces no back pressure. When connected to a scrambled SRAM the key going invalid will
    // cause a_ready to drop. The `compound_txn_in_progress_o` output is provided for this scenario.
    // When asserted SRAM should not drop `a_ready` even if there is an invalid scrambling key.
    

    // The readback logic assumes the result of a read transaction issues for the readback will get
    // an immediate response. This can be guaranteed when connected to a SRAM, see above comment.
    

    // When in the StByteWrReadbackInit state, pending_txn_cnt (the depth of a FIFO)
    // will always be 1. We will have seen StWaitRd -> StWriteCmd -> StByteWrReadBackInit
    // to get to this FSM state and the FIFO cannot be pushed or popped along that path.
    

    assign compound_txn_in_progress_o = wr_phase | rdback_phase | rdback_phase_wrreadback;
  end else begin : gen_no_integ_handling
    // In this case we pass everything just through.
    assign tl_sram_o = tl_i;
    assign tl_o = tl_sram_i;
    assign error_o = error_i;
    assign alert_o = 1'b0;
    assign compound_txn_in_progress_o = 1'b0;

    // Signal only used in readback mode.
    mubi4_t unused_readback_en;
    assign unused_readback_en = readback_en_i;

  end

  // Signals only used for SVA.
  logic unused_write_pending, unused_wr_collision;
  assign unused_write_pending = write_pending_i;
  assign unused_wr_collision = wr_collision_i;

  // EnableReadback requires that EnableIntg is on.
  // EnableIntg can be used without EnableReadback.
  
endmodule // tlul_adapter_sram
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
 * Tile-Link UL adapter for SRAM-like devices
 *
 * - Intentionally omitted BaseAddr in case of multiple memory maps are used in a SoC,
 *   it means that aliasing can happen if target device size in TL-UL crossbar is bigger
 *   than SRAM size
 * - At most one of EnableDataIntgGen / EnableDataIntgPt can be enabled. However it
 *   possible for both to be disabled.
 *   A module can neither generate an integrity response nor pass through any pre-existing
 *   integrity.  This might be the case for non-security critical memories where there is
 *   no stored integrity AND another entity upstream is already generating returning integrity.
 *   There is however no case where EnableDataIntgGen and EnableDataIntgPt are both true.
 */
module tlul_adapter_sram
  import tlul_pkg::*;
  import prim_mubi_pkg::mubi4_t;
#(
  parameter int SramAw            = 12,
  parameter int SramDw            = 32, // Must be multiple of the TL width
  parameter int SramDepth         = 2**SramAw, // Must be <= 2**SramAw
  parameter int Outstanding       = 1,  // Only one request is accepted
  parameter int SramBusBankAW     = 12, // SRAM bus address width of the SRAM bank. Only used
                                        // when DataXorAddr=1.
  parameter bit ByteAccess        = 1,  // 1: Enables sub-word write transactions. Note that this
                                        //    results in read-modify-write operations for integrity
                                        //    re-generation if EnableDataIntgPt is set to 1.
  parameter bit ErrOnWrite        = 0,  // 1: Writes not allowed, automatically error
  parameter bit ErrOnRead         = 0,  // 1: Reads not allowed, automatically error
  parameter bit CmdIntgCheck      = 0,  // 1: Enable command integrity check
  parameter bit EnableRspIntgGen  = 0,  // 1: Generate response integrity
  parameter bit EnableDataIntgGen = 0,  // 1: Generate response data integrity
  parameter bit EnableDataIntgPt  = 0,  // 1: Passthrough command/response data integrity
  parameter bit SecFifoPtr        = 0,  // 1: Duplicated fifo pointers
  parameter bit EnableReadback    = 0,  // 1: Readback and check written/read data.
  parameter bit DataXorAddr       = 0,  // 1: XOR data and address for address protection
  localparam int WidthMult        = SramDw / top_pkg::TL_DW,
  localparam int IntgWidth        = tlul_pkg::DataIntgWidth * WidthMult,
  localparam int DataOutW         = EnableDataIntgPt ? SramDw + IntgWidth : SramDw
) (
  input   clk_i,
  input   rst_ni,

  // TL-UL interface
  input   tl_h2d_t          tl_i,
  output  tl_d2h_t          tl_o,

  // control interface
  input   mubi4_t en_ifetch_i,

  // SRAM interface
  output logic                 req_o,
  output mubi4_t               req_type_o,
  input                        gnt_i,
  output logic                 we_o,
  output logic [SramAw-1:0]    addr_o,
  output logic [DataOutW-1:0]  wdata_o,
  output logic [DataOutW-1:0]  wmask_o,
  output logic                 intg_error_o,
  output logic [RsvdWidth-1:0] user_rsvd_o,
  input        [DataOutW-1:0]  rdata_i,
  input                        rvalid_i,
  input        [1:0]           rerror_i, // 2 bit error [1]: Uncorrectable, [0]: Correctable
  output logic                 compound_txn_in_progress_o,
  input  mubi4_t               readback_en_i,
  output logic                 readback_error_o,
  input  logic                 wr_collision_i,
  input  logic                 write_pending_i
);

  localparam int SramByte = SramDw/8;
  localparam int DataBitWidth = prim_util_pkg::vbits(SramByte);
  localparam int WoffsetWidth = (SramByte == top_pkg::TL_DBW) ? 1 :
                                DataBitWidth - prim_util_pkg::vbits(top_pkg::TL_DBW);

  logic error_det; // Internal protocol error checker
  logic error_internal; // Internal protocol error checker
  logic wr_attr_error;
  logic instr_error;
  logic wr_vld_error;
  logic rd_vld_error;
  logic rsp_fifo_error;
  logic sramreqfifo_error;
  logic reqfifo_error;
  logic intg_error;
  logic tlul_error;
  logic readback_error;
  logic sram_byte_readback_error;
  logic addr_miss_error;

  // readback check
  logic readback_error_q;
  if (EnableReadback) begin : gen_cmd_readback_check
    assign readback_error = sram_byte_readback_error;
    // permanently latch readback error until reset
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        readback_error_q <= '0;
      end else if (readback_error) begin
        readback_error_q <= 1'b1;
      end
    end
  end else begin : gen_no_readback_check
    logic unused_sram_byte_readback_error;
    assign unused_sram_byte_readback_error = sram_byte_readback_error;
    assign readback_error = '0;
    assign readback_error_q = '0;
  end

  // readback error output is permanent and should be used for alert generation
  // or other downstream effects
  assign readback_error_o = readback_error | readback_error_q;

  // integrity check
  if (CmdIntgCheck) begin : gen_cmd_intg_check
    tlul_cmd_intg_chk u_cmd_intg_chk (
      .tl_i(tl_i),
      .err_o (intg_error)
    );
  end else begin : gen_no_cmd_intg_check
    assign intg_error = '0;
  end

  // permanently latch integrity error until reset
  logic intg_error_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      intg_error_q <= '0;
    end else if (intg_error || rsp_fifo_error || sramreqfifo_error || reqfifo_error) begin
      intg_error_q <= 1'b1;
    end
  end

  // integrity error output is permanent and should be used for alert generation
  // or other downstream effects
  assign intg_error_o = intg_error | rsp_fifo_error | sramreqfifo_error |
      reqfifo_error | intg_error_q;

  // wr_attr_error is true if this is a PUT with an unsupported request size or mask. This is only
  // possible if ByteAccess is not allowed.
  assign wr_attr_error = (ByteAccess == 0) &&
                         (tl_i.a_opcode == PutFullData || tl_i.a_opcode == PutPartialData) &&
                         (tl_i.a_mask != '1 || tl_i.a_size != 2'h2);

  // An instruction type transaction is only valid if en_ifetch is enabled
  // If the instruction type is completely invalid, also considered an instruction error
  assign instr_error = prim_mubi_pkg::mubi4_test_invalid(tl_i.a_user.instr_type) |
                       (prim_mubi_pkg::mubi4_test_true_strict(tl_i.a_user.instr_type) &
                        prim_mubi_pkg::mubi4_test_false_loose(en_ifetch_i));

  if (ErrOnWrite == 1) begin : gen_no_writes
    assign wr_vld_error = tl_i.a_opcode != Get;
  end else begin : gen_writes_allowed
    assign wr_vld_error = 1'b0;
  end

  if (ErrOnRead == 1) begin: gen_no_reads
    assign rd_vld_error = tl_i.a_opcode == Get;
  end else begin : gen_reads_allowed
    assign rd_vld_error = 1'b0;
  end

  if (2**SramAw == SramDepth) begin : gen_no_addr_chk
    // The depth of the memory is a power of two. Here, we only ever get to see addresses that hit
    // in the memory.
    assign addr_miss_error = 1'b0;
  end else begin : gen_addr_chk
    // The depth of the memory is not a power of two. We have to signal an error if the address
    // hits the unmapped range.
    assign addr_miss_error = tl_i.a_address[DataBitWidth +: SramAw] >= SramDepth;
  end

  // tlul protocol check
  tlul_err u_err (
    .clk_i,
    .rst_ni,
    .tl_i(tl_i),
    .err_o (tlul_error)
  );

  // error return is transactional and thus does not used the "latched" intg_err signal
  assign error_det = wr_attr_error | wr_vld_error | rd_vld_error | instr_error |
                     tlul_error    | intg_error   | addr_miss_error;

  // from sram_byte to adapter logic
  tl_h2d_t tl_i_int;
  // from adapter logic to sram_byte
  tl_d2h_t tl_o_int;
  // from sram_byte to rsp_gen
  tl_d2h_t tl_out;

  // not all parts of tl_i_int are used
  logic unused_tl_i_int;
  assign unused_tl_i_int = ^tl_i_int;

  tlul_rsp_intg_gen #(
    .EnableRspIntgGen(EnableRspIntgGen),
    .EnableDataIntgGen(EnableDataIntgGen),
    .RspIntgInIsZero(1'b1)
  ) u_rsp_gen (
    .tl_i(tl_out),
    .tl_o
  );

  // byte handling for integrity
  tlul_sram_byte #(
    .EnableIntg(ByteAccess & EnableDataIntgPt & !ErrOnWrite),
    .Outstanding(Outstanding),
    .EnableReadback(EnableReadback)
  ) u_sram_byte (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o(tl_out),
    .tl_sram_o(tl_i_int),
    .tl_sram_i(tl_o_int),
    .error_i(error_det),
    .error_o(error_internal),
    .alert_o(sram_byte_readback_error),
    .compound_txn_in_progress_o,
    .readback_en_i,
    .wr_collision_i,
    .write_pending_i
  );

  typedef struct packed {
    logic [top_pkg::TL_DBW-1:0] mask ; // Byte mask within the TL-UL word
    logic [WoffsetWidth-1:0]    woffset ; // Offset of the TL-UL word within the SRAM word
  } sram_req_t ;

  typedef struct packed {
    logic [SramBusBankAW-1:0] addr; // Address of the request going to the memory.
  } sram_req_addr_t ;

  typedef struct packed {
    logic                       is_read ;
    logic                       error ;
    prim_mubi_pkg::mubi4_t      instr_type;
    logic [top_pkg::TL_SZW-1:0] size ;
    logic [top_pkg::TL_AIW-1:0] source ;
  } req_t ;

  typedef struct packed {
    logic [top_pkg::TL_DW-1:0] data ;
    logic [DataIntgWidth-1:0]  data_intg ;
    logic                      error ;
  } rsp_t ;

  localparam int SramReqWidth = $bits(sram_req_t);
  localparam int SramReqFifoWidth = SramReqWidth + (DataXorAddr ? SramBusBankAW : 0);
  localparam int ReqFifoWidth = $bits(req_t) ;
  localparam int RspFifoWidth = $bits(rsp_t) ;

  // FIFO signal in case OutStand is greater than 1
  // If request is latched, {write, source} is pushed to req fifo.
  // Req fifo is popped when D channel is acknowledged (v & r)
  // D channel valid is asserted if it is write request or rsp fifo not empty if read.
  logic reqfifo_wvalid, reqfifo_wready;
  logic reqfifo_rvalid, reqfifo_rready;
  req_t reqfifo_wdata,  reqfifo_rdata;

  logic sramreqfifo_wvalid, sramreqfifo_wready;
  logic sramreqfifo_rready;

  // An item in u_sramreqfifo is the request itself, together (if DataXorAddr is nonzero) with some
  // bits of the request address. These values are in sram_req_*data and sram_addr_*data, which get
  // combined to fifo items in sramreqfifo_*data.
  sram_req_t                   sram_req_wdata, sram_req_rdata;
  logic [SramBusBankAW-1:0]    sram_addr_wdata, sram_addr_rdata;
  logic [SramReqFifoWidth-1:0] sramreqfifo_wdata, sramreqfifo_rdata;

  if (DataXorAddr) begin : gen_combine_with_addr
    assign sramreqfifo_wdata = {sram_addr_wdata, sram_req_wdata};
    assign {sram_addr_rdata, sram_req_rdata} = sramreqfifo_rdata;
  end else begin : gen_combine_without_addr
    assign sramreqfifo_wdata = sram_req_wdata;
    assign sram_addr_rdata = '0;
    assign sram_req_rdata = sramreqfifo_rdata;
  end

  logic rspfifo_wvalid, rspfifo_wready;
  logic rspfifo_rvalid, rspfifo_rready;
  rsp_t rspfifo_wdata,  rspfifo_rdata;

  logic a_ack, d_ack, sram_ack;
  assign a_ack    = tl_i_int.a_valid & tl_o_int.a_ready ;
  assign d_ack    = tl_o_int.d_valid & tl_i_int.d_ready ;
  assign sram_ack = req_o        & gnt_i ;

  // Valid handling
  logic d_valid, d_error;
  always_comb begin
    d_valid = 1'b0;

    if (reqfifo_rvalid) begin
      if (reqfifo_rdata.error) begin
        // Return error response. Assume no request went out to SRAM
        d_valid = 1'b1;
      end else if (reqfifo_rdata.is_read) begin
        d_valid = rspfifo_rvalid;
      end else begin
        // Write without error
        d_valid = 1'b1;
      end
    end else begin
      d_valid = 1'b0;
    end
  end



  always_comb begin
    d_error = 1'b0;

    if (reqfifo_rvalid) begin
      if (reqfifo_rdata.is_read) begin
        d_error = rspfifo_rdata.error | reqfifo_rdata.error;
      end else begin
        d_error = reqfifo_rdata.error;
      end
    end else begin
      d_error = 1'b0;
    end
  end

  logic vld_rd_rsp;
  assign vld_rd_rsp = d_valid & rspfifo_rvalid & reqfifo_rdata.is_read;
  // If the response data is not valid, we set it to an illegal blanking value which is determined
  // by whether the current transaction is an instruction fetch or a regular read operation.
  logic [top_pkg::TL_DW-1:0] error_blanking_data;
  assign error_blanking_data = (prim_mubi_pkg::mubi4_test_true_strict(reqfifo_rdata.instr_type)) ?
                                 DataWhenInstrError :
                                 DataWhenError;

  // Since DataWhenInstrError and DataWhenError can be arbitrary parameters
  // we statically calculate the correct integrity values for these parameters here so that
  // they do not have to be supplied externally.
  logic [top_pkg::TL_DW-1:0] unused_instr, unused_data;
  logic [DataIntgWidth-1:0] error_instr_integ, error_data_integ;
  tlul_data_integ_enc u_tlul_data_integ_enc_instr (
    .data_i(DataMaxWidth'(DataWhenInstrError)),
    .data_intg_o({error_instr_integ, unused_instr})
  );
  tlul_data_integ_enc u_tlul_data_integ_enc_data (
    .data_i(DataMaxWidth'(DataWhenError)),
    .data_intg_o({error_data_integ, unused_data})
  );

  logic [DataIntgWidth-1:0] error_blanking_integ;
  assign error_blanking_integ = (prim_mubi_pkg::mubi4_test_true_strict(reqfifo_rdata.instr_type)) ?
                                 error_instr_integ :
                                 error_data_integ;

  logic [top_pkg::TL_DW-1:0] d_data;
  assign d_data = (vld_rd_rsp & ~d_error) ? rspfifo_rdata.data   // valid read
                                          : error_blanking_data; // write or TL-UL error

  // If this a write response with data fields set to 0, we have to set all ECC bits correctly
  // since we are using an inverted Hsiao code.
  logic [DataIntgWidth-1:0] data_intg;
  assign data_intg = (reqfifo_rdata.error) ? error_blanking_integ    : // TL-UL error
                     (vld_rd_rsp)          ? rspfifo_rdata.data_intg : // valid read
                     prim_secded_pkg::SecdedInv3932ZeroEcc;            // valid write

  // When an error is seen on an incoming transaction it gets an immediate response without
  // performing an SRAM request. It may be the transaction receives a ready the first cycle it is
  // seen, but if not we force a ready the following cycle. This avoids factoring the error
  // calculation into the outgoing ready preventing a feedthrough path from the incoming tilelink
  // signals to the outgoing tilelink signals.
  logic missed_err_gnt_d, missed_err_gnt_q;

  // Track whether we've seen an incoming transaction with an error that didn't get a ready
  assign missed_err_gnt_d = error_internal & tl_i_int.a_valid & ~tl_o_int.a_ready;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      missed_err_gnt_q <= 1'b0;
    end else begin
      missed_err_gnt_q <= missed_err_gnt_d;
    end
  end

  assign tl_o_int = '{
      d_valid  : d_valid ,
      d_opcode : (d_valid && !reqfifo_rdata.is_read) ? AccessAck : AccessAckData,
      d_param  : '0,
      d_size   : (d_valid) ? reqfifo_rdata.size : '0,
      d_source : (d_valid) ? reqfifo_rdata.source : '0,
      d_sink   : 1'b0,
      d_data   : d_data,
      d_user   : '{default: '0, data_intg: data_intg},
      d_error  : d_valid && d_error,
      a_ready  : (gnt_i | missed_err_gnt_q) & reqfifo_wready & sramreqfifo_wready
  };

  // a_ready depends on the FIFO full condition and grant from SRAM (or SRAM arbiter)
  // assemble response, including read response, write response, and error for unsupported stuff

  // Output to SRAM:
  //    Generate request only when no internal error occurs. If error occurs, the request should be
  //    dropped and returned error response to the host. So, error to be pushed to reqfifo.
  //    In this case, it is assumed the request is granted (may cause ordering issue later?)
  assign req_o       = tl_i_int.a_valid & reqfifo_wready & ~error_internal;
  assign req_type_o  = tl_i_int.a_user.instr_type;
  assign we_o        = tl_i_int.a_valid & (tl_i_int.a_opcode inside {PutFullData, PutPartialData});
  assign addr_o      = (tl_i_int.a_valid) ? tl_i_int.a_address[DataBitWidth+:SramAw] : '0;
  assign user_rsvd_o = (tl_i_int.a_valid) ? tl_i_int.a_user.rsvd : '0;

  // Support SRAMs wider than the TL-UL word width by mapping the parts of the
  // TL-UL address which are more fine-granular than the SRAM width to the
  // SRAM write mask.
  logic [WoffsetWidth-1:0] woffset;
  if (top_pkg::TL_DW != SramDw) begin : gen_wordwidthadapt
    assign woffset = tl_i_int.a_address[DataBitWidth-1:prim_util_pkg::vbits(top_pkg::TL_DBW)];
  end else begin : gen_no_wordwidthadapt
    assign woffset = '0;
  end

  // The size of the data/wmask depends on whether passthrough integrity is enabled.
  // If passthrough integrity is enabled, the data is concatenated with the integrity passed through
  // the user bits.  Otherwise, it is the data only.
  localparam int DataWidth = EnableDataIntgPt ? top_pkg::TL_DW + DataIntgWidth : top_pkg::TL_DW;

  // Final combined wmask / wdata
  logic [WidthMult-1:0][DataWidth-1:0] wmask_combined;
  logic [WidthMult-1:0][DataWidth-1:0] wdata_combined;

  // Original tlul portion
  logic [WidthMult-1:0][top_pkg::TL_DW-1:0] wmask_int;
  logic [WidthMult-1:0][top_pkg::TL_DW-1:0] wdata_int;

  // Integrity portion
  logic [WidthMult-1:0][DataIntgWidth-1:0] wmask_intg;
  logic [WidthMult-1:0][DataIntgWidth-1:0] wdata_intg;

  always_comb begin
    wmask_int = '0;
    wdata_int = '0;

    if (tl_i_int.a_valid) begin
      for (int i = 0 ; i < top_pkg::TL_DW/8 ; i++) begin
        wmask_int[woffset][8*i +: 8] = {8{tl_i_int.a_mask[i]}};
        wdata_int[woffset][8*i +: 8] = (tl_i_int.a_mask[i] && we_o) ? tl_i_int.a_data[8*i+:8] : '0;
      end
    end
  end

  always_comb begin
    wmask_intg  = '0;
    wdata_intg  = '0;

    if (tl_i_int.a_valid) begin
      wmask_intg[woffset] = {DataIntgWidth{1'b1}};
      wdata_intg[woffset] = tl_i_int.a_user.data_intg;
    end
  end

  for (genvar i = 0; i < WidthMult; i++) begin : gen_write_output
    if (EnableDataIntgPt) begin : gen_combined_output
      assign wmask_combined[i] = {wmask_intg[i], wmask_int[i]};
      assign wdata_combined[i] = {wdata_intg[i], wdata_int[i]};
    end else begin : gen_ft_output
      logic unused_w;
      assign wmask_combined[i] = wmask_int[i];
      assign wdata_combined[i] = wdata_int[i];
      assign unused_w = |wmask_intg & |wdata_intg;
    end
  end

  assign wmask_o = wmask_combined;
  assign wdata_o = wdata_combined;

  assign reqfifo_wvalid = a_ack ; // Push to FIFO only when granted
  assign reqfifo_wdata  = '{
    is_read: tl_i_int.a_opcode == Get,
    error:  error_internal,
    instr_type: tl_i_int.a_user.instr_type,
    size:   tl_i_int.a_size,
    source: tl_i_int.a_source
  }; // Store the request only. Doesn't have to store data
  assign reqfifo_rready = d_ack ;

  // push together with ReqFIFO, pop upon returning read
  assign sram_req_wdata = '{
    mask    : tl_i_int.a_mask,
    woffset : woffset
  };
  assign sramreqfifo_wvalid = sram_ack & ~we_o;
  assign sramreqfifo_rready = rspfifo_wvalid;

  assign rspfifo_wvalid = rvalid_i & reqfifo_rvalid;

  assign sram_addr_wdata = tl_i_int.a_address[DataBitWidth+:SramBusBankAW];

  // Make sure only requested bytes are forwarded
  logic [WidthMult-1:0][DataWidth-1:0] rdata_reshaped;
  logic [DataWidth-1:0] rdata_tlword;

  // This just changes the array format so that the correct word can be selected by indexing.
  assign rdata_reshaped = rdata_i;

  if (EnableDataIntgPt) begin : gen_no_rmask
    always_comb begin
      // If the read mask is set to zero, all read data is zeroed out by the mask.
      // We have to set the ECC bits accordingly since we are using an inverted Hsiao code.
      rdata_tlword = prim_secded_pkg::SecdedInv3932ZeroWord;
      // Otherwise, if at least one mask bit is nonzero, we are passing through the integrity.
      // In that case we need to feed back the entire word since otherwise the integrity
      // will not calculate correctly.
      if (|sram_req_rdata.mask) begin
        // Select correct word.
        if (DataXorAddr) begin : gen_data_xor_addr
          // When DataXorAddr is enabled, on a read, the address is XORed with the data fetched from
          // the memory in the underlying memory controller (e.g., flash controller). At this point,
          // the address is again removed. If the address in the read transaction has been modified,
          // e.g., due to a fault, rdata now contains faulty data, which is detected by the
          // integrity mechanism.
          rdata_tlword = {
              rdata_reshaped[sram_req_rdata.woffset][DataWidth-1:top_pkg::TL_DW],
              rdata_reshaped[sram_req_rdata.woffset][top_pkg::TL_DW-1:0] ^
                  {{(top_pkg::TL_DW-SramBusBankAW){1'b0}}, sram_addr_rdata}
          };
        end else begin: gen_no_data_xor_addr
          rdata_tlword = rdata_reshaped[sram_req_rdata.woffset];
        end
      end
    end
  end else begin : gen_rmask
    logic [DataWidth-1:0] rmask;
    always_comb begin
      rmask = '0;
      for (int i = 0 ; i < top_pkg::TL_DW/8 ; i++) begin
        rmask[8*i +: 8] = {8{sram_req_rdata.mask[i]}};
      end
    end
    // Select correct word and mask it.
    assign rdata_tlword = rdata_reshaped[sram_req_rdata.woffset] & rmask;
  end

  assign rspfifo_wdata  = '{
    data      : rdata_tlword[top_pkg::TL_DW-1:0],
    data_intg : EnableDataIntgPt ? rdata_tlword[DataWidth-1 -: DataIntgWidth] : '0,
    error     : rerror_i[1] // Only care for Uncorrectable error
  };
  assign rspfifo_rready = reqfifo_rdata.is_read & ~reqfifo_rdata.error & reqfifo_rready;

  // This module only cares about uncorrectable errors.
  logic unused_rerror;
  assign unused_rerror = rerror_i[0];

  // FIFO instance: REQ, RSP

  // ReqFIFO is to store the Access type to match to the Response data.
  //    For instance, SRAM accepts the write request but doesn't return the
  //    acknowledge. In this case, it may be hard to determine when the D
  //    response for the write data should send out if reads/writes are
  //    interleaved. So, to make it in-order (even TL-UL allows out-of-order
  //    responses), storing the request is necessary. And if the read entry
  //    is write op, it is safe to return the response right away. If it is
  //    read request, then D response is waiting until read data arrives.
  prim_fifo_sync #(
    .Width       (ReqFifoWidth),
    .Pass        (1'b0),
    .Depth       (Outstanding),
    .NeverClears (1'b1),
    .Secure      (SecFifoPtr)
  ) u_reqfifo (
    .clk_i,
    .rst_ni,
    .clr_i   (1'b0),
    .wvalid_i(reqfifo_wvalid),
    .wready_o(reqfifo_wready),
    .wdata_i (reqfifo_wdata),
    .rvalid_o(reqfifo_rvalid),
    .rready_i(reqfifo_rready),
    .rdata_o (reqfifo_rdata),
    .full_o  (),
    .depth_o (),
    .err_o   (reqfifo_error)
  );

  // sramreqfifo:
  //    While the ReqFIFO holds the request until it is sent back via TL-UL, the
  //    sramreqfifo only needs to hold the mask and word offset until the read
  //    data returns from memory.
  prim_fifo_sync #(
    .Width             (SramReqFifoWidth),
    .Pass              (1'b0),
    .Depth             (Outstanding),
    .NeverClears       (1'b1),
    .Secure            (SecFifoPtr),
    .OutputZeroIfEmpty (1)
  ) u_sramreqfifo (
    .clk_i,
    .rst_ni,
    .clr_i   (1'b0),
    .wvalid_i(sramreqfifo_wvalid),
    .wready_o(sramreqfifo_wready),
    .wdata_i (sramreqfifo_wdata),
    .rvalid_o(),
    .rready_i(sramreqfifo_rready),
    .rdata_o (sramreqfifo_rdata),
    .full_o  (),
    .depth_o (),
    .err_o   (sramreqfifo_error)
  );

  if (!DataXorAddr) begin : gen_no_data_xor_addr_fifo
    // If u_sramreqfifo doesn't contain any address data, nothing will be reading sram_addr_wdata or
    // sram_addr_rdata. Tie them off with an unused signal.
    logic unused_sram_addresses;
    assign unused_sram_addresses = ^{sram_addr_wdata, sram_addr_rdata};
  end

  // Rationale having #Outstanding depth in response FIFO.
  //    In normal case, if the host or the crossbar accepts the response data,
  //    response FIFO isn't needed. But if in any case it has a chance to be
  //    back pressured, the response FIFO should store the returned data not to
  //    lose the data from the SRAM interface. Remember, SRAM interface doesn't
  //    have back-pressure signal such as read_ready.
  prim_fifo_sync #(
    .Width       (RspFifoWidth),
    .Pass        (1'b1),
    .Depth       (Outstanding),
    .NeverClears (1'b1),
    .Secure      (SecFifoPtr)
  ) u_rspfifo (
    .clk_i,
    .rst_ni,
    .clr_i   (1'b0),
    .wvalid_i(rspfifo_wvalid),
    .wready_o(rspfifo_wready),
    .wdata_i (rspfifo_wdata),
    .rvalid_o(rspfifo_rvalid),
    .rready_i(rspfifo_rready),
    .rdata_o (rspfifo_rdata),
    .full_o  (),
    .depth_o (),
    .err_o   (rsp_fifo_error)
  );

  // below assertion fails when SRAM rvalid is asserted even though ReqFifo is empty
  

  // below assertion fails when outstanding value is too small (SRAM rvalid is asserted
  // even though the RspFifo is full)
  

  // If both ErrOnWrite and ErrOnRead are set, this block is useless
  

  
  
  // Either the memory has a power-of-two depth and the address width perfectly matches, or the
  // depth is not a power of two but the address width is still minimal.
  

  // These parameter options cannot both be true at the same time
  

  // Make sure that outputs are defined (a special case for tl_o is explained separately below)
  
  
  
  
  

  // We'd like to claim that the payload of the TL output is known, but this isn't necessarily true!
  // This block is just an adapter that converts from an SRAM interface to a TL interface. To make
  // the assertion true, we need to weaken it to say that that tl_o is only X if the SRAM supplied
  // that X.
  //
  // This is a bit tricky to track because SRAM responses get stored in u_rspfifo. Assuming that the
  // FIFO doesn't manufacture X's (an assertion in prim_fifo_sync), the only stage of the path
  // needed in this file is the following:
  
  

  // The definition of d_valid leads to the assertion below.
  
endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// TL-UL error responder module, used by tlul_socket_1n to help response
// to requests to no correct address space. Responses are always one cycle
// after request with no stalling unless response is stuck on the way out.

module tlul_err_resp #(
  // By default, we return a proper bus error. In some cases, we need to return a blank all-zero
  // response without setting the error bit, and for those cases ReturnBlankResp can be set to 1.
  parameter bit ReturnBlankResp = 0
) (
  input                     clk_i,
  input                     rst_ni,
  input  tlul_pkg::tl_h2d_t tl_h_i,
  output tlul_pkg::tl_d2h_t tl_h_o
);
  import tlul_pkg::*;
  import prim_mubi_pkg::*;

  tl_a_op_e                          err_opcode;
  logic [$bits(tl_h_i.a_source)-1:0] err_source;
  logic [$bits(tl_h_i.a_size)-1:0]   err_size;
  logic                              err_rsp_pending;
  mubi4_t                            err_instr_type;
  tlul_pkg::tl_d2h_t                 tl_h_o_int;

  tlul_rsp_intg_gen #(
    .EnableRspIntgGen(1),
    .EnableDataIntgGen(1)
  ) u_intg_gen (
    .tl_i(tl_h_o_int),
    .tl_o(tl_h_o)
  );

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      err_rsp_pending <= 1'b0;
      err_source      <= {top_pkg::TL_AIW{1'b0}};
      err_opcode      <= Get;
      err_size        <= '0;
      err_instr_type  <= MuBi4False;
    end else if (err_rsp_pending && tl_h_i.d_ready) begin
      err_rsp_pending <= 1'b0;
    end else if (tl_h_i.a_valid && tl_h_o_int.a_ready) begin
      err_rsp_pending <= 1'b1;
      err_source      <= tl_h_i.a_source;
      err_opcode      <= tl_h_i.a_opcode;
      err_size        <= tl_h_i.a_size;
      err_instr_type  <= tl_h_i.a_user.instr_type;
    end
  end

  assign tl_h_o_int.a_ready  = ~err_rsp_pending;
  assign tl_h_o_int.d_valid  = err_rsp_pending;
  if (ReturnBlankResp) begin : gen_zero_resp
    assign tl_h_o_int.d_data = '0;
  end else begin : gen_err_resp
    assign tl_h_o_int.d_data   = (mubi4_test_true_strict(err_instr_type)) ? DataWhenInstrError :
                                                                            DataWhenError;
  end
  assign tl_h_o_int.d_source = err_source;
  assign tl_h_o_int.d_sink   = '0;
  assign tl_h_o_int.d_param  = '0;
  assign tl_h_o_int.d_size   = err_size;
  assign tl_h_o_int.d_opcode = (err_opcode == Get) ? AccessAckData : AccessAck;
  assign tl_h_o_int.d_user   = '0;
  assign tl_h_o_int.d_error  = ~ReturnBlankResp;

  // Waive unused bits of tl_h_i
  logic unused_tl_h;
  assign unused_tl_h = ^{tl_h_i, err_instr_type};

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// TL-UL socket 1:N module
//
// configuration settings
//   device_count: 4
//
// Verilog parameters
//   HReqPass:      if 1 then host requests can pass through on empty fifo,
//                  default 1
//   HRspPass:      if 1 then host responses can pass through on empty fifo,
//                  default 1
//   DReqPass:      (one per device_count) if 1 then device i requests can
//                  pass through on empty fifo, default 1
//   DRspPass:      (one per device_count) if 1 then device i responses can
//                  pass through on empty fifo, default 1
//   HReqDepth:     Depth of host request FIFO, default 2
//   HRspDepth:     Depth of host response FIFO, default 2
//   DReqDepth:     (one per device_count) Depth of device i request FIFO,
//                  default 2
//   DRspDepth:     (one per device_count) Depth of device i response FIFO,
//                  default 2
//   ExplicitErrs:  This module always returns a request error if dev_select_i
//                  is greater than N-1. If ExplicitErrs is set then the width
//                  of the dev_select_i signal will be chosen to make sure that
//                  this is possible. This only makes a difference if N is a
//                  power of 2.
//
// Requests must stall to one device until all responses from other devices
// have returned.  Need to keep a counter of all outstanding requests and
// wait until that counter is zero before switching devices.
//
// This module will return a request error if the input value of 'dev_select_i'
// is not within the range 0..N-1. Thus the instantiator of the socket
// can indicate error by any illegal value of dev_select_i. 4'b1111 is
// recommended for visibility
//
// The maximum value of N is 63

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


module tlul_socket_1n #(
  parameter int unsigned  N            = 4,
  parameter bit           HReqPass     = 1'b1,
  parameter bit           HRspPass     = 1'b1,
  parameter bit [N-1:0]   DReqPass     = {N{1'b1}},
  parameter bit [N-1:0]   DRspPass     = {N{1'b1}},
  parameter bit [3:0]     HReqDepth    = 4'h1,
  parameter bit [3:0]     HRspDepth    = 4'h1,
  parameter bit [N*4-1:0] DReqDepth    = {N{4'h1}},
  parameter bit [N*4-1:0] DRspDepth    = {N{4'h1}},
  parameter bit           ExplicitErrs = 1'b1,

  // The width of dev_select_i. We must be able to select any of the N devices
  // (i.e. values 0..N-1). If ExplicitErrs is set, we also need to be able to
  // represent N.
  localparam int unsigned NWD = $clog2(ExplicitErrs ? N+1 : N)
) (
  input                     clk_i,
  input                     rst_ni,
  input  tlul_pkg::tl_h2d_t tl_h_i,
  output tlul_pkg::tl_d2h_t tl_h_o,
  output tlul_pkg::tl_h2d_t tl_d_o    [N],
  input  tlul_pkg::tl_d2h_t tl_d_i    [N],
  input  [NWD-1:0]          dev_select_i
);

  

  // Since our steering is done after potential FIFOing, we need to
  // shove our device select bits into spare bits of reqfifo

  // instantiate the host fifo, create intermediate bus 't'

  // FIFO'd version of device select
  logic [NWD-1:0] dev_select_t;

  tlul_pkg::tl_h2d_t   tl_t_o;
  tlul_pkg::tl_d2h_t   tl_t_i;

  tlul_fifo_sync #(
    .ReqPass(HReqPass),
    .RspPass(HRspPass),
    .ReqDepth(HReqDepth),
    .RspDepth(HRspDepth),
    .SpareReqW(NWD)
  ) fifo_h (
    .clk_i,
    .rst_ni,
    .tl_h_i,
    .tl_h_o,
    .tl_d_o     (tl_t_o),
    .tl_d_i     (tl_t_i),
    .spare_req_i (dev_select_i),
    .spare_req_o (dev_select_t),
    .spare_rsp_i (1'b0),
    .spare_rsp_o ());


  // We need to keep track of how many requests are outstanding,
  // and to which device. New requests are compared to this and
  // stall until that number is zero.
  localparam int MaxOutstanding = 2**top_pkg::TL_AIW; // Up to 256 outstanding
  localparam int OutstandingW = $clog2(MaxOutstanding+1);
  logic [OutstandingW-1:0] num_req_outstanding;
  logic [NWD-1:0]          dev_select_outstanding;
  logic                    hold_all_requests;
  logic                    accept_t_req, accept_t_rsp;

  assign  accept_t_req = tl_t_o.a_valid & tl_t_i.a_ready;
  assign  accept_t_rsp = tl_t_i.d_valid & tl_t_o.d_ready;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      num_req_outstanding <= '0;
      dev_select_outstanding <= '0;
    end else if (accept_t_req) begin
      if (!accept_t_rsp) begin
        num_req_outstanding <= num_req_outstanding + 1'b1;
      end
      dev_select_outstanding <= dev_select_t;
    end else if (accept_t_rsp) begin
      num_req_outstanding <= num_req_outstanding - 1'b1;
    end
  end

  

  assign hold_all_requests =
      (num_req_outstanding != '0) &
      (dev_select_t != dev_select_outstanding);

  // Make N copies of 't' request side with modified reqvalid, call
  // them 'u[0]' .. 'u[n-1]'.

  tlul_pkg::tl_h2d_t   tl_u_o [N+1];
  tlul_pkg::tl_d2h_t   tl_u_i [N+1];

  // ensure that when a device is not selected, both command
  // data integrity can never match
  tlul_pkg::tl_a_user_t blanked_auser;
  assign blanked_auser = '{
    rsvd: tl_t_o.a_user.rsvd,
    instr_type: tl_t_o.a_user.instr_type,
    cmd_intg: tlul_pkg::get_bad_cmd_intg(tl_t_o),
    data_intg: tlul_pkg::get_bad_data_intg(tlul_pkg::BlankedAData)
  };

  // if a host is not selected, or if requests are held off, blank the bus
  for (genvar i = 0 ; i < N ; i++) begin : gen_u_o
    logic dev_select;
    assign dev_select = dev_select_t == NWD'(i) & ~hold_all_requests;

    assign tl_u_o[i].a_valid   = tl_t_o.a_valid & dev_select;
    assign tl_u_o[i].a_opcode  = tl_t_o.a_opcode;
    assign tl_u_o[i].a_param   = tl_t_o.a_param;
    assign tl_u_o[i].a_size    = tl_t_o.a_size;
    assign tl_u_o[i].a_source  = tl_t_o.a_source;
    assign tl_u_o[i].a_address = tl_t_o.a_address;
    assign tl_u_o[i].a_mask    = tl_t_o.a_mask;
    assign tl_u_o[i].a_data    = dev_select ?
                                 tl_t_o.a_data :
                                 tlul_pkg::BlankedAData;
    assign tl_u_o[i].a_user    = dev_select ?
                                 tl_t_o.a_user :
                                 blanked_auser;

    assign tl_u_o[i].d_ready   = tl_t_o.d_ready;
  end


  tlul_pkg::tl_d2h_t tl_t_p ;

  // for the returning reqready, only look at the device we're addressing
  logic hfifo_reqready;
  always_comb begin
    hfifo_reqready = tl_u_i[N].a_ready; // default to error
    for (int idx = 0 ; idx < N ; idx++) begin
      //if (dev_select_outstanding == NWD'(idx)) hfifo_reqready = tl_u_i[idx].a_ready;
      if (dev_select_t == NWD'(idx)) hfifo_reqready = tl_u_i[idx].a_ready;
    end
    if (hold_all_requests) hfifo_reqready = 1'b0;
  end
  // Adding a_valid as a qualifier. This prevents the a_ready from having unknown value
  // when the address is unknown and the Host TL-UL FIFO is bypass mode.
  assign tl_t_i.a_ready = tl_t_o.a_valid & hfifo_reqready;

  always_comb begin
    tl_t_p = tl_u_i[N];
    for (int idx = 0 ; idx < N ; idx++) begin
      if (dev_select_outstanding == NWD'(idx)) tl_t_p = tl_u_i[idx];
    end
  end
  assign tl_t_i.d_valid  = tl_t_p.d_valid ;
  assign tl_t_i.d_opcode = tl_t_p.d_opcode;
  assign tl_t_i.d_param  = tl_t_p.d_param ;
  assign tl_t_i.d_size   = tl_t_p.d_size  ;
  assign tl_t_i.d_source = tl_t_p.d_source;
  assign tl_t_i.d_sink   = tl_t_p.d_sink  ;
  assign tl_t_i.d_data   = tl_t_p.d_data  ;
  assign tl_t_i.d_user   = tl_t_p.d_user  ;
  assign tl_t_i.d_error  = tl_t_p.d_error ;

  // Instantiate all the device FIFOs
  for (genvar i = 0 ; i < N ; i++) begin : gen_dfifo
    tlul_fifo_sync #(
      .ReqPass(DReqPass[i]),
      .RspPass(DRspPass[i]),
      .ReqDepth(DReqDepth[i*4+:4]),
      .RspDepth(DRspDepth[i*4+:4])
    ) fifo_d (
      .clk_i,
      .rst_ni,
      .tl_h_i      (tl_u_o[i]),
      .tl_h_o      (tl_u_i[i]),
      .tl_d_o      (tl_d_o[i]),
      .tl_d_i      (tl_d_i[i]),
      .spare_req_i (1'b0),
      .spare_req_o (),
      .spare_rsp_i (1'b0),
      .spare_rsp_o ());
  end

  // Instantiate the error responder. It's only needed if a value greater than
  // N-1 is actually representable in NWD bits.
  if ($clog2(N+1) <= NWD) begin : gen_err_resp
    assign tl_u_o[N].d_ready     = tl_t_o.d_ready;
    assign tl_u_o[N].a_valid     = tl_t_o.a_valid &
                                   (dev_select_t >= NWD'(N)) &
                                   ~hold_all_requests;
    assign tl_u_o[N].a_opcode    = tl_t_o.a_opcode;
    assign tl_u_o[N].a_param     = tl_t_o.a_param;
    assign tl_u_o[N].a_size      = tl_t_o.a_size;
    assign tl_u_o[N].a_source    = tl_t_o.a_source;
    assign tl_u_o[N].a_address   = tl_t_o.a_address;
    assign tl_u_o[N].a_mask      = tl_t_o.a_mask;
    assign tl_u_o[N].a_data      = tl_t_o.a_data;
    assign tl_u_o[N].a_user      = tl_t_o.a_user;
    tlul_err_resp err_resp (
      .clk_i,
      .rst_ni,
      .tl_h_i     (tl_u_o[N]),
      .tl_h_o     (tl_u_i[N])
    );
  end else begin : gen_no_err_resp // block: gen_err_resp
    assign tl_u_o[N] = '0;
    assign tl_u_i[N] = '0;
    logic unused_sig;
    assign unused_sig = ^tl_u_o[N];
  end

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Package auto-generated by `reggen` containing data structure

package hmac_reg_pkg;

  // Param list
  parameter int NumDigestWords = 16;
  parameter int NumKeyWords = 32;
  parameter int NumAlerts = 1;

  // Address widths within the block
  parameter int BlockAw = 13;

  // Number of registers for every interface
  parameter int NumRegs = 59;

  // Alert indices
  typedef enum int {
    AlertFatalFaultIdx = 0
  } hmac_alert_idx_t;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////

  typedef struct packed {
    struct packed {
      logic        q;
    } hmac_err;
    struct packed {
      logic        q;
    } fifo_empty;
    struct packed {
      logic        q;
    } hmac_done;
  } hmac_reg2hw_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
    } hmac_err;
    struct packed {
      logic        q;
    } fifo_empty;
    struct packed {
      logic        q;
    } hmac_done;
  } hmac_reg2hw_intr_enable_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } hmac_err;
    struct packed {
      logic        q;
      logic        qe;
    } fifo_empty;
    struct packed {
      logic        q;
      logic        qe;
    } hmac_done;
  } hmac_reg2hw_intr_test_reg_t;

  typedef struct packed {
    logic        q;
    logic        qe;
  } hmac_reg2hw_alert_test_reg_t;

  typedef struct packed {
    struct packed {
      logic [5:0]  q;
      logic        qe;
    } key_length;
    struct packed {
      logic [3:0]  q;
      logic        qe;
    } digest_size;
    struct packed {
      logic        q;
      logic        qe;
    } key_swap;
    struct packed {
      logic        q;
      logic        qe;
    } digest_swap;
    struct packed {
      logic        q;
      logic        qe;
    } endian_swap;
    struct packed {
      logic        q;
      logic        qe;
    } sha_en;
    struct packed {
      logic        q;
      logic        qe;
    } hmac_en;
  } hmac_reg2hw_cfg_reg_t;

  typedef struct packed {
    struct packed {
      logic        q;
      logic        qe;
    } hash_continue;
    struct packed {
      logic        q;
      logic        qe;
    } hash_stop;
    struct packed {
      logic        q;
      logic        qe;
    } hash_process;
    struct packed {
      logic        q;
      logic        qe;
    } hash_start;
  } hmac_reg2hw_cmd_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } hmac_reg2hw_wipe_secret_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } hmac_reg2hw_key_mreg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } hmac_reg2hw_digest_mreg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } hmac_reg2hw_msg_length_lower_reg_t;

  typedef struct packed {
    logic [31:0] q;
    logic        qe;
  } hmac_reg2hw_msg_length_upper_reg_t;

  typedef struct packed {
    struct packed {
      logic        d;
      logic        de;
    } hmac_err;
    struct packed {
      logic        d;
      logic        de;
    } fifo_empty;
    struct packed {
      logic        d;
      logic        de;
    } hmac_done;
  } hmac_hw2reg_intr_state_reg_t;

  typedef struct packed {
    struct packed {
      logic [5:0]  d;
    } key_length;
    struct packed {
      logic [3:0]  d;
    } digest_size;
    struct packed {
      logic        d;
    } key_swap;
    struct packed {
      logic        d;
    } digest_swap;
    struct packed {
      logic        d;
    } endian_swap;
    struct packed {
      logic        d;
    } sha_en;
    struct packed {
      logic        d;
    } hmac_en;
  } hmac_hw2reg_cfg_reg_t;

  typedef struct packed {
    struct packed {
      logic [5:0]  d;
    } fifo_depth;
    struct packed {
      logic        d;
    } fifo_full;
    struct packed {
      logic        d;
    } fifo_empty;
    struct packed {
      logic        d;
    } hmac_idle;
  } hmac_hw2reg_status_reg_t;

  typedef struct packed {
    logic [31:0] d;
    logic        de;
  } hmac_hw2reg_err_code_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } hmac_hw2reg_key_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } hmac_hw2reg_digest_mreg_t;

  typedef struct packed {
    logic [31:0] d;
  } hmac_hw2reg_msg_length_lower_reg_t;

  typedef struct packed {
    logic [31:0] d;
  } hmac_hw2reg_msg_length_upper_reg_t;

  // Register -> HW type
  typedef struct packed {
    hmac_reg2hw_intr_state_reg_t intr_state; // [1726:1724]
    hmac_reg2hw_intr_enable_reg_t intr_enable; // [1723:1721]
    hmac_reg2hw_intr_test_reg_t intr_test; // [1720:1715]
    hmac_reg2hw_alert_test_reg_t alert_test; // [1714:1713]
    hmac_reg2hw_cfg_reg_t cfg; // [1712:1691]
    hmac_reg2hw_cmd_reg_t cmd; // [1690:1683]
    hmac_reg2hw_wipe_secret_reg_t wipe_secret; // [1682:1650]
    hmac_reg2hw_key_mreg_t [31:0] key; // [1649:594]
    hmac_reg2hw_digest_mreg_t [15:0] digest; // [593:66]
    hmac_reg2hw_msg_length_lower_reg_t msg_length_lower; // [65:33]
    hmac_reg2hw_msg_length_upper_reg_t msg_length_upper; // [32:0]
  } hmac_reg2hw_t;

  // HW -> register type
  typedef struct packed {
    hmac_hw2reg_intr_state_reg_t intr_state; // [1662:1657]
    hmac_hw2reg_cfg_reg_t cfg; // [1656:1642]
    hmac_hw2reg_status_reg_t status; // [1641:1633]
    hmac_hw2reg_err_code_reg_t err_code; // [1632:1600]
    hmac_hw2reg_key_mreg_t [31:0] key; // [1599:576]
    hmac_hw2reg_digest_mreg_t [15:0] digest; // [575:64]
    hmac_hw2reg_msg_length_lower_reg_t msg_length_lower; // [63:32]
    hmac_hw2reg_msg_length_upper_reg_t msg_length_upper; // [31:0]
  } hmac_hw2reg_t;

  // Register offsets
  parameter logic [BlockAw-1:0] HMAC_INTR_STATE_OFFSET = 13'h 0;
  parameter logic [BlockAw-1:0] HMAC_INTR_ENABLE_OFFSET = 13'h 4;
  parameter logic [BlockAw-1:0] HMAC_INTR_TEST_OFFSET = 13'h 8;
  parameter logic [BlockAw-1:0] HMAC_ALERT_TEST_OFFSET = 13'h c;
  parameter logic [BlockAw-1:0] HMAC_CFG_OFFSET = 13'h 10;
  parameter logic [BlockAw-1:0] HMAC_CMD_OFFSET = 13'h 14;
  parameter logic [BlockAw-1:0] HMAC_STATUS_OFFSET = 13'h 18;
  parameter logic [BlockAw-1:0] HMAC_ERR_CODE_OFFSET = 13'h 1c;
  parameter logic [BlockAw-1:0] HMAC_WIPE_SECRET_OFFSET = 13'h 20;
  parameter logic [BlockAw-1:0] HMAC_KEY_0_OFFSET = 13'h 24;
  parameter logic [BlockAw-1:0] HMAC_KEY_1_OFFSET = 13'h 28;
  parameter logic [BlockAw-1:0] HMAC_KEY_2_OFFSET = 13'h 2c;
  parameter logic [BlockAw-1:0] HMAC_KEY_3_OFFSET = 13'h 30;
  parameter logic [BlockAw-1:0] HMAC_KEY_4_OFFSET = 13'h 34;
  parameter logic [BlockAw-1:0] HMAC_KEY_5_OFFSET = 13'h 38;
  parameter logic [BlockAw-1:0] HMAC_KEY_6_OFFSET = 13'h 3c;
  parameter logic [BlockAw-1:0] HMAC_KEY_7_OFFSET = 13'h 40;
  parameter logic [BlockAw-1:0] HMAC_KEY_8_OFFSET = 13'h 44;
  parameter logic [BlockAw-1:0] HMAC_KEY_9_OFFSET = 13'h 48;
  parameter logic [BlockAw-1:0] HMAC_KEY_10_OFFSET = 13'h 4c;
  parameter logic [BlockAw-1:0] HMAC_KEY_11_OFFSET = 13'h 50;
  parameter logic [BlockAw-1:0] HMAC_KEY_12_OFFSET = 13'h 54;
  parameter logic [BlockAw-1:0] HMAC_KEY_13_OFFSET = 13'h 58;
  parameter logic [BlockAw-1:0] HMAC_KEY_14_OFFSET = 13'h 5c;
  parameter logic [BlockAw-1:0] HMAC_KEY_15_OFFSET = 13'h 60;
  parameter logic [BlockAw-1:0] HMAC_KEY_16_OFFSET = 13'h 64;
  parameter logic [BlockAw-1:0] HMAC_KEY_17_OFFSET = 13'h 68;
  parameter logic [BlockAw-1:0] HMAC_KEY_18_OFFSET = 13'h 6c;
  parameter logic [BlockAw-1:0] HMAC_KEY_19_OFFSET = 13'h 70;
  parameter logic [BlockAw-1:0] HMAC_KEY_20_OFFSET = 13'h 74;
  parameter logic [BlockAw-1:0] HMAC_KEY_21_OFFSET = 13'h 78;
  parameter logic [BlockAw-1:0] HMAC_KEY_22_OFFSET = 13'h 7c;
  parameter logic [BlockAw-1:0] HMAC_KEY_23_OFFSET = 13'h 80;
  parameter logic [BlockAw-1:0] HMAC_KEY_24_OFFSET = 13'h 84;
  parameter logic [BlockAw-1:0] HMAC_KEY_25_OFFSET = 13'h 88;
  parameter logic [BlockAw-1:0] HMAC_KEY_26_OFFSET = 13'h 8c;
  parameter logic [BlockAw-1:0] HMAC_KEY_27_OFFSET = 13'h 90;
  parameter logic [BlockAw-1:0] HMAC_KEY_28_OFFSET = 13'h 94;
  parameter logic [BlockAw-1:0] HMAC_KEY_29_OFFSET = 13'h 98;
  parameter logic [BlockAw-1:0] HMAC_KEY_30_OFFSET = 13'h 9c;
  parameter logic [BlockAw-1:0] HMAC_KEY_31_OFFSET = 13'h a0;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_0_OFFSET = 13'h a4;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_1_OFFSET = 13'h a8;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_2_OFFSET = 13'h ac;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_3_OFFSET = 13'h b0;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_4_OFFSET = 13'h b4;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_5_OFFSET = 13'h b8;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_6_OFFSET = 13'h bc;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_7_OFFSET = 13'h c0;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_8_OFFSET = 13'h c4;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_9_OFFSET = 13'h c8;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_10_OFFSET = 13'h cc;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_11_OFFSET = 13'h d0;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_12_OFFSET = 13'h d4;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_13_OFFSET = 13'h d8;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_14_OFFSET = 13'h dc;
  parameter logic [BlockAw-1:0] HMAC_DIGEST_15_OFFSET = 13'h e0;
  parameter logic [BlockAw-1:0] HMAC_MSG_LENGTH_LOWER_OFFSET = 13'h e4;
  parameter logic [BlockAw-1:0] HMAC_MSG_LENGTH_UPPER_OFFSET = 13'h e8;

  // Reset values for hwext registers and their fields
  parameter logic [2:0] HMAC_INTR_TEST_RESVAL = 3'h 0;
  parameter logic [0:0] HMAC_INTR_TEST_HMAC_DONE_RESVAL = 1'h 0;
  parameter logic [0:0] HMAC_INTR_TEST_FIFO_EMPTY_RESVAL = 1'h 0;
  parameter logic [0:0] HMAC_INTR_TEST_HMAC_ERR_RESVAL = 1'h 0;
  parameter logic [0:0] HMAC_ALERT_TEST_RESVAL = 1'h 0;
  parameter logic [0:0] HMAC_ALERT_TEST_FATAL_FAULT_RESVAL = 1'h 0;
  parameter logic [14:0] HMAC_CFG_RESVAL = 15'h 4100;
  parameter logic [0:0] HMAC_CFG_ENDIAN_SWAP_RESVAL = 1'h 0;
  parameter logic [0:0] HMAC_CFG_DIGEST_SWAP_RESVAL = 1'h 0;
  parameter logic [0:0] HMAC_CFG_KEY_SWAP_RESVAL = 1'h 0;
  parameter logic [3:0] HMAC_CFG_DIGEST_SIZE_RESVAL = 4'h 8;
  parameter logic [5:0] HMAC_CFG_KEY_LENGTH_RESVAL = 6'h 20;
  parameter logic [3:0] HMAC_CMD_RESVAL = 4'h 0;
  parameter logic [9:0] HMAC_STATUS_RESVAL = 10'h 3;
  parameter logic [0:0] HMAC_STATUS_HMAC_IDLE_RESVAL = 1'h 1;
  parameter logic [0:0] HMAC_STATUS_FIFO_EMPTY_RESVAL = 1'h 1;
  parameter logic [31:0] HMAC_WIPE_SECRET_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_0_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_1_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_2_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_3_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_4_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_5_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_6_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_7_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_8_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_9_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_10_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_11_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_12_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_13_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_14_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_15_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_16_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_17_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_18_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_19_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_20_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_21_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_22_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_23_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_24_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_25_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_26_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_27_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_28_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_29_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_30_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_KEY_31_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_0_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_1_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_2_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_3_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_4_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_5_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_6_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_7_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_8_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_9_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_10_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_11_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_12_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_13_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_14_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_DIGEST_15_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_MSG_LENGTH_LOWER_RESVAL = 32'h 0;
  parameter logic [31:0] HMAC_MSG_LENGTH_UPPER_RESVAL = 32'h 0;

  // Window parameters
  parameter logic [BlockAw-1:0] HMAC_MSG_FIFO_OFFSET = 13'h 1000;
  parameter int unsigned        HMAC_MSG_FIFO_SIZE   = 'h 1000;
  parameter int unsigned        HMAC_MSG_FIFO_IDX    = 0;

  // Register index
  typedef enum int {
    HMAC_INTR_STATE,
    HMAC_INTR_ENABLE,
    HMAC_INTR_TEST,
    HMAC_ALERT_TEST,
    HMAC_CFG,
    HMAC_CMD,
    HMAC_STATUS,
    HMAC_ERR_CODE,
    HMAC_WIPE_SECRET,
    HMAC_KEY_0,
    HMAC_KEY_1,
    HMAC_KEY_2,
    HMAC_KEY_3,
    HMAC_KEY_4,
    HMAC_KEY_5,
    HMAC_KEY_6,
    HMAC_KEY_7,
    HMAC_KEY_8,
    HMAC_KEY_9,
    HMAC_KEY_10,
    HMAC_KEY_11,
    HMAC_KEY_12,
    HMAC_KEY_13,
    HMAC_KEY_14,
    HMAC_KEY_15,
    HMAC_KEY_16,
    HMAC_KEY_17,
    HMAC_KEY_18,
    HMAC_KEY_19,
    HMAC_KEY_20,
    HMAC_KEY_21,
    HMAC_KEY_22,
    HMAC_KEY_23,
    HMAC_KEY_24,
    HMAC_KEY_25,
    HMAC_KEY_26,
    HMAC_KEY_27,
    HMAC_KEY_28,
    HMAC_KEY_29,
    HMAC_KEY_30,
    HMAC_KEY_31,
    HMAC_DIGEST_0,
    HMAC_DIGEST_1,
    HMAC_DIGEST_2,
    HMAC_DIGEST_3,
    HMAC_DIGEST_4,
    HMAC_DIGEST_5,
    HMAC_DIGEST_6,
    HMAC_DIGEST_7,
    HMAC_DIGEST_8,
    HMAC_DIGEST_9,
    HMAC_DIGEST_10,
    HMAC_DIGEST_11,
    HMAC_DIGEST_12,
    HMAC_DIGEST_13,
    HMAC_DIGEST_14,
    HMAC_DIGEST_15,
    HMAC_MSG_LENGTH_LOWER,
    HMAC_MSG_LENGTH_UPPER
  } hmac_id_e;

  // Register width information to check illegal writes
  parameter logic [3:0] HMAC_PERMIT [59] = '{
    4'b 0001, // index[ 0] HMAC_INTR_STATE
    4'b 0001, // index[ 1] HMAC_INTR_ENABLE
    4'b 0001, // index[ 2] HMAC_INTR_TEST
    4'b 0001, // index[ 3] HMAC_ALERT_TEST
    4'b 0011, // index[ 4] HMAC_CFG
    4'b 0001, // index[ 5] HMAC_CMD
    4'b 0011, // index[ 6] HMAC_STATUS
    4'b 1111, // index[ 7] HMAC_ERR_CODE
    4'b 1111, // index[ 8] HMAC_WIPE_SECRET
    4'b 1111, // index[ 9] HMAC_KEY_0
    4'b 1111, // index[10] HMAC_KEY_1
    4'b 1111, // index[11] HMAC_KEY_2
    4'b 1111, // index[12] HMAC_KEY_3
    4'b 1111, // index[13] HMAC_KEY_4
    4'b 1111, // index[14] HMAC_KEY_5
    4'b 1111, // index[15] HMAC_KEY_6
    4'b 1111, // index[16] HMAC_KEY_7
    4'b 1111, // index[17] HMAC_KEY_8
    4'b 1111, // index[18] HMAC_KEY_9
    4'b 1111, // index[19] HMAC_KEY_10
    4'b 1111, // index[20] HMAC_KEY_11
    4'b 1111, // index[21] HMAC_KEY_12
    4'b 1111, // index[22] HMAC_KEY_13
    4'b 1111, // index[23] HMAC_KEY_14
    4'b 1111, // index[24] HMAC_KEY_15
    4'b 1111, // index[25] HMAC_KEY_16
    4'b 1111, // index[26] HMAC_KEY_17
    4'b 1111, // index[27] HMAC_KEY_18
    4'b 1111, // index[28] HMAC_KEY_19
    4'b 1111, // index[29] HMAC_KEY_20
    4'b 1111, // index[30] HMAC_KEY_21
    4'b 1111, // index[31] HMAC_KEY_22
    4'b 1111, // index[32] HMAC_KEY_23
    4'b 1111, // index[33] HMAC_KEY_24
    4'b 1111, // index[34] HMAC_KEY_25
    4'b 1111, // index[35] HMAC_KEY_26
    4'b 1111, // index[36] HMAC_KEY_27
    4'b 1111, // index[37] HMAC_KEY_28
    4'b 1111, // index[38] HMAC_KEY_29
    4'b 1111, // index[39] HMAC_KEY_30
    4'b 1111, // index[40] HMAC_KEY_31
    4'b 1111, // index[41] HMAC_DIGEST_0
    4'b 1111, // index[42] HMAC_DIGEST_1
    4'b 1111, // index[43] HMAC_DIGEST_2
    4'b 1111, // index[44] HMAC_DIGEST_3
    4'b 1111, // index[45] HMAC_DIGEST_4
    4'b 1111, // index[46] HMAC_DIGEST_5
    4'b 1111, // index[47] HMAC_DIGEST_6
    4'b 1111, // index[48] HMAC_DIGEST_7
    4'b 1111, // index[49] HMAC_DIGEST_8
    4'b 1111, // index[50] HMAC_DIGEST_9
    4'b 1111, // index[51] HMAC_DIGEST_10
    4'b 1111, // index[52] HMAC_DIGEST_11
    4'b 1111, // index[53] HMAC_DIGEST_12
    4'b 1111, // index[54] HMAC_DIGEST_13
    4'b 1111, // index[55] HMAC_DIGEST_14
    4'b 1111, // index[56] HMAC_DIGEST_15
    4'b 1111, // index[57] HMAC_MSG_LENGTH_LOWER
    4'b 1111  // index[58] HMAC_MSG_LENGTH_UPPER
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


module hmac_reg_top (
  input clk_i,
  input rst_ni,
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,

  // Output port for window
  output tlul_pkg::tl_h2d_t tl_win_o,
  input  tlul_pkg::tl_d2h_t tl_win_i,

  // To HW
  output hmac_reg_pkg::hmac_reg2hw_t reg2hw, // Write
  input  hmac_reg_pkg::hmac_hw2reg_t hw2reg, // Read

  // Integrity check errors
  output logic intg_err_o
);

  import hmac_reg_pkg::* ;

  localparam int AW = 13;
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
  logic [58:0] reg_we_check;
  prim_reg_we_check #(
    .OneHotWidth(59)
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

  tlul_pkg::tl_h2d_t tl_socket_h2d [2];
  tlul_pkg::tl_d2h_t tl_socket_d2h [2];

  logic [0:0] reg_steer;

  // socket_1n connection
  assign tl_reg_h2d = tl_socket_h2d[1];
  assign tl_socket_d2h[1] = tl_reg_d2h;

  assign tl_win_o = tl_socket_h2d[0];
  assign tl_socket_d2h[0] = tl_win_i;

  // Create Socket_1n
  tlul_socket_1n #(
    .N            (2),
    .HReqPass     (1'b1),
    .HRspPass     (1'b1),
    .DReqPass     ({2{1'b1}}),
    .DRspPass     ({2{1'b1}}),
    .HReqDepth    (4'h0),
    .HRspDepth    (4'h0),
    .DReqDepth    ({2{4'h0}}),
    .DRspDepth    ({2{4'h0}}),
    .ExplicitErrs (1'b0)
  ) u_socket (
    .clk_i  (clk_i),
    .rst_ni (rst_ni),
    .tl_h_i (tl_i),
    .tl_h_o (tl_o_pre),
    .tl_d_o (tl_socket_h2d),
    .tl_d_i (tl_socket_d2h),
    .dev_select_i (reg_steer)
  );

  // Create steering logic
  always_comb begin
    reg_steer =
        tl_i.a_address[AW-1:0] inside {[4096:8191]} ? 1'd0 :
        // Default set to register
        1'd1;

    // Override this in case of an integrity error
    if (intg_err) begin
      reg_steer = 1'd1;
    end
  end

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
    .error_i (reg_error)
  );

  // cdc oversampling signals

  assign reg_rdata = reg_rdata_next ;
  assign reg_error = addrmiss | wr_err | intg_err;

  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  logic intr_state_we;
  logic intr_state_hmac_done_qs;
  logic intr_state_hmac_done_wd;
  logic intr_state_fifo_empty_qs;
  logic intr_state_hmac_err_qs;
  logic intr_state_hmac_err_wd;
  logic intr_enable_we;
  logic intr_enable_hmac_done_qs;
  logic intr_enable_hmac_done_wd;
  logic intr_enable_fifo_empty_qs;
  logic intr_enable_fifo_empty_wd;
  logic intr_enable_hmac_err_qs;
  logic intr_enable_hmac_err_wd;
  logic intr_test_we;
  logic intr_test_hmac_done_wd;
  logic intr_test_fifo_empty_wd;
  logic intr_test_hmac_err_wd;
  logic alert_test_we;
  logic alert_test_wd;
  logic cfg_re;
  logic cfg_we;
  logic cfg_hmac_en_qs;
  logic cfg_hmac_en_wd;
  logic cfg_sha_en_qs;
  logic cfg_sha_en_wd;
  logic cfg_endian_swap_qs;
  logic cfg_endian_swap_wd;
  logic cfg_digest_swap_qs;
  logic cfg_digest_swap_wd;
  logic cfg_key_swap_qs;
  logic cfg_key_swap_wd;
  logic [3:0] cfg_digest_size_qs;
  logic [3:0] cfg_digest_size_wd;
  logic [5:0] cfg_key_length_qs;
  logic [5:0] cfg_key_length_wd;
  logic cmd_we;
  logic cmd_hash_start_wd;
  logic cmd_hash_process_wd;
  logic cmd_hash_stop_wd;
  logic cmd_hash_continue_wd;
  logic status_re;
  logic status_hmac_idle_qs;
  logic status_fifo_empty_qs;
  logic status_fifo_full_qs;
  logic [5:0] status_fifo_depth_qs;
  logic [31:0] err_code_qs;
  logic wipe_secret_we;
  logic [31:0] wipe_secret_wd;
  logic key_0_we;
  logic [31:0] key_0_wd;
  logic key_1_we;
  logic [31:0] key_1_wd;
  logic key_2_we;
  logic [31:0] key_2_wd;
  logic key_3_we;
  logic [31:0] key_3_wd;
  logic key_4_we;
  logic [31:0] key_4_wd;
  logic key_5_we;
  logic [31:0] key_5_wd;
  logic key_6_we;
  logic [31:0] key_6_wd;
  logic key_7_we;
  logic [31:0] key_7_wd;
  logic key_8_we;
  logic [31:0] key_8_wd;
  logic key_9_we;
  logic [31:0] key_9_wd;
  logic key_10_we;
  logic [31:0] key_10_wd;
  logic key_11_we;
  logic [31:0] key_11_wd;
  logic key_12_we;
  logic [31:0] key_12_wd;
  logic key_13_we;
  logic [31:0] key_13_wd;
  logic key_14_we;
  logic [31:0] key_14_wd;
  logic key_15_we;
  logic [31:0] key_15_wd;
  logic key_16_we;
  logic [31:0] key_16_wd;
  logic key_17_we;
  logic [31:0] key_17_wd;
  logic key_18_we;
  logic [31:0] key_18_wd;
  logic key_19_we;
  logic [31:0] key_19_wd;
  logic key_20_we;
  logic [31:0] key_20_wd;
  logic key_21_we;
  logic [31:0] key_21_wd;
  logic key_22_we;
  logic [31:0] key_22_wd;
  logic key_23_we;
  logic [31:0] key_23_wd;
  logic key_24_we;
  logic [31:0] key_24_wd;
  logic key_25_we;
  logic [31:0] key_25_wd;
  logic key_26_we;
  logic [31:0] key_26_wd;
  logic key_27_we;
  logic [31:0] key_27_wd;
  logic key_28_we;
  logic [31:0] key_28_wd;
  logic key_29_we;
  logic [31:0] key_29_wd;
  logic key_30_we;
  logic [31:0] key_30_wd;
  logic key_31_we;
  logic [31:0] key_31_wd;
  logic digest_0_re;
  logic digest_0_we;
  logic [31:0] digest_0_qs;
  logic [31:0] digest_0_wd;
  logic digest_1_re;
  logic digest_1_we;
  logic [31:0] digest_1_qs;
  logic [31:0] digest_1_wd;
  logic digest_2_re;
  logic digest_2_we;
  logic [31:0] digest_2_qs;
  logic [31:0] digest_2_wd;
  logic digest_3_re;
  logic digest_3_we;
  logic [31:0] digest_3_qs;
  logic [31:0] digest_3_wd;
  logic digest_4_re;
  logic digest_4_we;
  logic [31:0] digest_4_qs;
  logic [31:0] digest_4_wd;
  logic digest_5_re;
  logic digest_5_we;
  logic [31:0] digest_5_qs;
  logic [31:0] digest_5_wd;
  logic digest_6_re;
  logic digest_6_we;
  logic [31:0] digest_6_qs;
  logic [31:0] digest_6_wd;
  logic digest_7_re;
  logic digest_7_we;
  logic [31:0] digest_7_qs;
  logic [31:0] digest_7_wd;
  logic digest_8_re;
  logic digest_8_we;
  logic [31:0] digest_8_qs;
  logic [31:0] digest_8_wd;
  logic digest_9_re;
  logic digest_9_we;
  logic [31:0] digest_9_qs;
  logic [31:0] digest_9_wd;
  logic digest_10_re;
  logic digest_10_we;
  logic [31:0] digest_10_qs;
  logic [31:0] digest_10_wd;
  logic digest_11_re;
  logic digest_11_we;
  logic [31:0] digest_11_qs;
  logic [31:0] digest_11_wd;
  logic digest_12_re;
  logic digest_12_we;
  logic [31:0] digest_12_qs;
  logic [31:0] digest_12_wd;
  logic digest_13_re;
  logic digest_13_we;
  logic [31:0] digest_13_qs;
  logic [31:0] digest_13_wd;
  logic digest_14_re;
  logic digest_14_we;
  logic [31:0] digest_14_qs;
  logic [31:0] digest_14_wd;
  logic digest_15_re;
  logic digest_15_we;
  logic [31:0] digest_15_qs;
  logic [31:0] digest_15_wd;
  logic msg_length_lower_re;
  logic msg_length_lower_we;
  logic [31:0] msg_length_lower_qs;
  logic [31:0] msg_length_lower_wd;
  logic msg_length_upper_re;
  logic msg_length_upper_we;
  logic [31:0] msg_length_upper_qs;
  logic [31:0] msg_length_upper_wd;

  // Register instances
  // R[intr_state]: V(False)
  //   F[hmac_done]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_hmac_done (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_hmac_done_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.hmac_done.de),
    .d      (hw2reg.intr_state.hmac_done.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.hmac_done.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_hmac_done_qs)
  );

  //   F[fifo_empty]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_fifo_empty (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.intr_state.fifo_empty.de),
    .d      (hw2reg.intr_state.fifo_empty.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.fifo_empty.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_fifo_empty_qs)
  );

  //   F[hmac_err]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_hmac_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_hmac_err_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.hmac_err.de),
    .d      (hw2reg.intr_state.hmac_err.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.hmac_err.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_hmac_err_qs)
  );


  // R[intr_enable]: V(False)
  //   F[hmac_done]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_hmac_done (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_hmac_done_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.hmac_done.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_hmac_done_qs)
  );

  //   F[fifo_empty]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_fifo_empty (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_fifo_empty_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.fifo_empty.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_fifo_empty_qs)
  );

  //   F[hmac_err]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_hmac_err (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_hmac_err_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.hmac_err.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_hmac_err_qs)
  );


  // R[intr_test]: V(True)
  logic intr_test_qe;
  logic [2:0] intr_test_flds_we;
  assign intr_test_qe = &intr_test_flds_we;
  //   F[hmac_done]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_hmac_done (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_hmac_done_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[0]),
    .q      (reg2hw.intr_test.hmac_done.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.hmac_done.qe = intr_test_qe;

  //   F[fifo_empty]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_fifo_empty (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_fifo_empty_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[1]),
    .q      (reg2hw.intr_test.fifo_empty.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.fifo_empty.qe = intr_test_qe;

  //   F[hmac_err]: 2:2
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_hmac_err (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_hmac_err_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[2]),
    .q      (reg2hw.intr_test.hmac_err.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.hmac_err.qe = intr_test_qe;


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


  // R[cfg]: V(True)
  logic cfg_qe;
  logic [6:0] cfg_flds_we;
  assign cfg_qe = &cfg_flds_we;
  //   F[hmac_en]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_cfg_hmac_en (
    .re     (cfg_re),
    .we     (cfg_we),
    .wd     (cfg_hmac_en_wd),
    .d      (hw2reg.cfg.hmac_en.d),
    .qre    (),
    .qe     (cfg_flds_we[0]),
    .q      (reg2hw.cfg.hmac_en.q),
    .ds     (),
    .qs     (cfg_hmac_en_qs)
  );
  assign reg2hw.cfg.hmac_en.qe = cfg_qe;

  //   F[sha_en]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_cfg_sha_en (
    .re     (cfg_re),
    .we     (cfg_we),
    .wd     (cfg_sha_en_wd),
    .d      (hw2reg.cfg.sha_en.d),
    .qre    (),
    .qe     (cfg_flds_we[1]),
    .q      (reg2hw.cfg.sha_en.q),
    .ds     (),
    .qs     (cfg_sha_en_qs)
  );
  assign reg2hw.cfg.sha_en.qe = cfg_qe;

  //   F[endian_swap]: 2:2
  prim_subreg_ext #(
    .DW    (1)
  ) u_cfg_endian_swap (
    .re     (cfg_re),
    .we     (cfg_we),
    .wd     (cfg_endian_swap_wd),
    .d      (hw2reg.cfg.endian_swap.d),
    .qre    (),
    .qe     (cfg_flds_we[2]),
    .q      (reg2hw.cfg.endian_swap.q),
    .ds     (),
    .qs     (cfg_endian_swap_qs)
  );
  assign reg2hw.cfg.endian_swap.qe = cfg_qe;

  //   F[digest_swap]: 3:3
  prim_subreg_ext #(
    .DW    (1)
  ) u_cfg_digest_swap (
    .re     (cfg_re),
    .we     (cfg_we),
    .wd     (cfg_digest_swap_wd),
    .d      (hw2reg.cfg.digest_swap.d),
    .qre    (),
    .qe     (cfg_flds_we[3]),
    .q      (reg2hw.cfg.digest_swap.q),
    .ds     (),
    .qs     (cfg_digest_swap_qs)
  );
  assign reg2hw.cfg.digest_swap.qe = cfg_qe;

  //   F[key_swap]: 4:4
  prim_subreg_ext #(
    .DW    (1)
  ) u_cfg_key_swap (
    .re     (cfg_re),
    .we     (cfg_we),
    .wd     (cfg_key_swap_wd),
    .d      (hw2reg.cfg.key_swap.d),
    .qre    (),
    .qe     (cfg_flds_we[4]),
    .q      (reg2hw.cfg.key_swap.q),
    .ds     (),
    .qs     (cfg_key_swap_qs)
  );
  assign reg2hw.cfg.key_swap.qe = cfg_qe;

  //   F[digest_size]: 8:5
  prim_subreg_ext #(
    .DW    (4)
  ) u_cfg_digest_size (
    .re     (cfg_re),
    .we     (cfg_we),
    .wd     (cfg_digest_size_wd),
    .d      (hw2reg.cfg.digest_size.d),
    .qre    (),
    .qe     (cfg_flds_we[5]),
    .q      (reg2hw.cfg.digest_size.q),
    .ds     (),
    .qs     (cfg_digest_size_qs)
  );
  assign reg2hw.cfg.digest_size.qe = cfg_qe;

  //   F[key_length]: 14:9
  prim_subreg_ext #(
    .DW    (6)
  ) u_cfg_key_length (
    .re     (cfg_re),
    .we     (cfg_we),
    .wd     (cfg_key_length_wd),
    .d      (hw2reg.cfg.key_length.d),
    .qre    (),
    .qe     (cfg_flds_we[6]),
    .q      (reg2hw.cfg.key_length.q),
    .ds     (),
    .qs     (cfg_key_length_qs)
  );
  assign reg2hw.cfg.key_length.qe = cfg_qe;


  // R[cmd]: V(True)
  logic cmd_qe;
  logic [3:0] cmd_flds_we;
  assign cmd_qe = &cmd_flds_we;
  //   F[hash_start]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_cmd_hash_start (
    .re     (1'b0),
    .we     (cmd_we),
    .wd     (cmd_hash_start_wd),
    .d      ('0),
    .qre    (),
    .qe     (cmd_flds_we[0]),
    .q      (reg2hw.cmd.hash_start.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.cmd.hash_start.qe = cmd_qe;

  //   F[hash_process]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_cmd_hash_process (
    .re     (1'b0),
    .we     (cmd_we),
    .wd     (cmd_hash_process_wd),
    .d      ('0),
    .qre    (),
    .qe     (cmd_flds_we[1]),
    .q      (reg2hw.cmd.hash_process.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.cmd.hash_process.qe = cmd_qe;

  //   F[hash_stop]: 2:2
  prim_subreg_ext #(
    .DW    (1)
  ) u_cmd_hash_stop (
    .re     (1'b0),
    .we     (cmd_we),
    .wd     (cmd_hash_stop_wd),
    .d      ('0),
    .qre    (),
    .qe     (cmd_flds_we[2]),
    .q      (reg2hw.cmd.hash_stop.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.cmd.hash_stop.qe = cmd_qe;

  //   F[hash_continue]: 3:3
  prim_subreg_ext #(
    .DW    (1)
  ) u_cmd_hash_continue (
    .re     (1'b0),
    .we     (cmd_we),
    .wd     (cmd_hash_continue_wd),
    .d      ('0),
    .qre    (),
    .qe     (cmd_flds_we[3]),
    .q      (reg2hw.cmd.hash_continue.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.cmd.hash_continue.qe = cmd_qe;


  // R[status]: V(True)
  //   F[hmac_idle]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_hmac_idle (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.hmac_idle.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_hmac_idle_qs)
  );

  //   F[fifo_empty]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_fifo_empty (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.fifo_empty.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_fifo_empty_qs)
  );

  //   F[fifo_full]: 2:2
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_fifo_full (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.fifo_full.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_fifo_full_qs)
  );

  //   F[fifo_depth]: 9:4
  prim_subreg_ext #(
    .DW    (6)
  ) u_status_fifo_depth (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.fifo_depth.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_fifo_depth_qs)
  );


  // R[err_code]: V(False)
  prim_subreg #(
    .DW      (32),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (32'h0),
    .Mubi    (1'b0)
  ) u_err_code (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.err_code.de),
    .d      (hw2reg.err_code.d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (err_code_qs)
  );


  // R[wipe_secret]: V(True)
  logic wipe_secret_qe;
  logic [0:0] wipe_secret_flds_we;
  assign wipe_secret_qe = &wipe_secret_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_wipe_secret (
    .re     (1'b0),
    .we     (wipe_secret_we),
    .wd     (wipe_secret_wd),
    .d      ('0),
    .qre    (),
    .qe     (wipe_secret_flds_we[0]),
    .q      (reg2hw.wipe_secret.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.wipe_secret.qe = wipe_secret_qe;


  // Subregister 0 of Multireg key
  // R[key_0]: V(True)
  logic key_0_qe;
  logic [0:0] key_0_flds_we;
  assign key_0_qe = &key_0_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_0 (
    .re     (1'b0),
    .we     (key_0_we),
    .wd     (key_0_wd),
    .d      (hw2reg.key[0].d),
    .qre    (),
    .qe     (key_0_flds_we[0]),
    .q      (reg2hw.key[0].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[0].qe = key_0_qe;


  // Subregister 1 of Multireg key
  // R[key_1]: V(True)
  logic key_1_qe;
  logic [0:0] key_1_flds_we;
  assign key_1_qe = &key_1_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_1 (
    .re     (1'b0),
    .we     (key_1_we),
    .wd     (key_1_wd),
    .d      (hw2reg.key[1].d),
    .qre    (),
    .qe     (key_1_flds_we[0]),
    .q      (reg2hw.key[1].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[1].qe = key_1_qe;


  // Subregister 2 of Multireg key
  // R[key_2]: V(True)
  logic key_2_qe;
  logic [0:0] key_2_flds_we;
  assign key_2_qe = &key_2_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_2 (
    .re     (1'b0),
    .we     (key_2_we),
    .wd     (key_2_wd),
    .d      (hw2reg.key[2].d),
    .qre    (),
    .qe     (key_2_flds_we[0]),
    .q      (reg2hw.key[2].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[2].qe = key_2_qe;


  // Subregister 3 of Multireg key
  // R[key_3]: V(True)
  logic key_3_qe;
  logic [0:0] key_3_flds_we;
  assign key_3_qe = &key_3_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_3 (
    .re     (1'b0),
    .we     (key_3_we),
    .wd     (key_3_wd),
    .d      (hw2reg.key[3].d),
    .qre    (),
    .qe     (key_3_flds_we[0]),
    .q      (reg2hw.key[3].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[3].qe = key_3_qe;


  // Subregister 4 of Multireg key
  // R[key_4]: V(True)
  logic key_4_qe;
  logic [0:0] key_4_flds_we;
  assign key_4_qe = &key_4_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_4 (
    .re     (1'b0),
    .we     (key_4_we),
    .wd     (key_4_wd),
    .d      (hw2reg.key[4].d),
    .qre    (),
    .qe     (key_4_flds_we[0]),
    .q      (reg2hw.key[4].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[4].qe = key_4_qe;


  // Subregister 5 of Multireg key
  // R[key_5]: V(True)
  logic key_5_qe;
  logic [0:0] key_5_flds_we;
  assign key_5_qe = &key_5_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_5 (
    .re     (1'b0),
    .we     (key_5_we),
    .wd     (key_5_wd),
    .d      (hw2reg.key[5].d),
    .qre    (),
    .qe     (key_5_flds_we[0]),
    .q      (reg2hw.key[5].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[5].qe = key_5_qe;


  // Subregister 6 of Multireg key
  // R[key_6]: V(True)
  logic key_6_qe;
  logic [0:0] key_6_flds_we;
  assign key_6_qe = &key_6_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_6 (
    .re     (1'b0),
    .we     (key_6_we),
    .wd     (key_6_wd),
    .d      (hw2reg.key[6].d),
    .qre    (),
    .qe     (key_6_flds_we[0]),
    .q      (reg2hw.key[6].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[6].qe = key_6_qe;


  // Subregister 7 of Multireg key
  // R[key_7]: V(True)
  logic key_7_qe;
  logic [0:0] key_7_flds_we;
  assign key_7_qe = &key_7_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_7 (
    .re     (1'b0),
    .we     (key_7_we),
    .wd     (key_7_wd),
    .d      (hw2reg.key[7].d),
    .qre    (),
    .qe     (key_7_flds_we[0]),
    .q      (reg2hw.key[7].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[7].qe = key_7_qe;


  // Subregister 8 of Multireg key
  // R[key_8]: V(True)
  logic key_8_qe;
  logic [0:0] key_8_flds_we;
  assign key_8_qe = &key_8_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_8 (
    .re     (1'b0),
    .we     (key_8_we),
    .wd     (key_8_wd),
    .d      (hw2reg.key[8].d),
    .qre    (),
    .qe     (key_8_flds_we[0]),
    .q      (reg2hw.key[8].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[8].qe = key_8_qe;


  // Subregister 9 of Multireg key
  // R[key_9]: V(True)
  logic key_9_qe;
  logic [0:0] key_9_flds_we;
  assign key_9_qe = &key_9_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_9 (
    .re     (1'b0),
    .we     (key_9_we),
    .wd     (key_9_wd),
    .d      (hw2reg.key[9].d),
    .qre    (),
    .qe     (key_9_flds_we[0]),
    .q      (reg2hw.key[9].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[9].qe = key_9_qe;


  // Subregister 10 of Multireg key
  // R[key_10]: V(True)
  logic key_10_qe;
  logic [0:0] key_10_flds_we;
  assign key_10_qe = &key_10_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_10 (
    .re     (1'b0),
    .we     (key_10_we),
    .wd     (key_10_wd),
    .d      (hw2reg.key[10].d),
    .qre    (),
    .qe     (key_10_flds_we[0]),
    .q      (reg2hw.key[10].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[10].qe = key_10_qe;


  // Subregister 11 of Multireg key
  // R[key_11]: V(True)
  logic key_11_qe;
  logic [0:0] key_11_flds_we;
  assign key_11_qe = &key_11_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_11 (
    .re     (1'b0),
    .we     (key_11_we),
    .wd     (key_11_wd),
    .d      (hw2reg.key[11].d),
    .qre    (),
    .qe     (key_11_flds_we[0]),
    .q      (reg2hw.key[11].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[11].qe = key_11_qe;


  // Subregister 12 of Multireg key
  // R[key_12]: V(True)
  logic key_12_qe;
  logic [0:0] key_12_flds_we;
  assign key_12_qe = &key_12_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_12 (
    .re     (1'b0),
    .we     (key_12_we),
    .wd     (key_12_wd),
    .d      (hw2reg.key[12].d),
    .qre    (),
    .qe     (key_12_flds_we[0]),
    .q      (reg2hw.key[12].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[12].qe = key_12_qe;


  // Subregister 13 of Multireg key
  // R[key_13]: V(True)
  logic key_13_qe;
  logic [0:0] key_13_flds_we;
  assign key_13_qe = &key_13_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_13 (
    .re     (1'b0),
    .we     (key_13_we),
    .wd     (key_13_wd),
    .d      (hw2reg.key[13].d),
    .qre    (),
    .qe     (key_13_flds_we[0]),
    .q      (reg2hw.key[13].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[13].qe = key_13_qe;


  // Subregister 14 of Multireg key
  // R[key_14]: V(True)
  logic key_14_qe;
  logic [0:0] key_14_flds_we;
  assign key_14_qe = &key_14_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_14 (
    .re     (1'b0),
    .we     (key_14_we),
    .wd     (key_14_wd),
    .d      (hw2reg.key[14].d),
    .qre    (),
    .qe     (key_14_flds_we[0]),
    .q      (reg2hw.key[14].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[14].qe = key_14_qe;


  // Subregister 15 of Multireg key
  // R[key_15]: V(True)
  logic key_15_qe;
  logic [0:0] key_15_flds_we;
  assign key_15_qe = &key_15_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_15 (
    .re     (1'b0),
    .we     (key_15_we),
    .wd     (key_15_wd),
    .d      (hw2reg.key[15].d),
    .qre    (),
    .qe     (key_15_flds_we[0]),
    .q      (reg2hw.key[15].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[15].qe = key_15_qe;


  // Subregister 16 of Multireg key
  // R[key_16]: V(True)
  logic key_16_qe;
  logic [0:0] key_16_flds_we;
  assign key_16_qe = &key_16_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_16 (
    .re     (1'b0),
    .we     (key_16_we),
    .wd     (key_16_wd),
    .d      (hw2reg.key[16].d),
    .qre    (),
    .qe     (key_16_flds_we[0]),
    .q      (reg2hw.key[16].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[16].qe = key_16_qe;


  // Subregister 17 of Multireg key
  // R[key_17]: V(True)
  logic key_17_qe;
  logic [0:0] key_17_flds_we;
  assign key_17_qe = &key_17_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_17 (
    .re     (1'b0),
    .we     (key_17_we),
    .wd     (key_17_wd),
    .d      (hw2reg.key[17].d),
    .qre    (),
    .qe     (key_17_flds_we[0]),
    .q      (reg2hw.key[17].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[17].qe = key_17_qe;


  // Subregister 18 of Multireg key
  // R[key_18]: V(True)
  logic key_18_qe;
  logic [0:0] key_18_flds_we;
  assign key_18_qe = &key_18_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_18 (
    .re     (1'b0),
    .we     (key_18_we),
    .wd     (key_18_wd),
    .d      (hw2reg.key[18].d),
    .qre    (),
    .qe     (key_18_flds_we[0]),
    .q      (reg2hw.key[18].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[18].qe = key_18_qe;


  // Subregister 19 of Multireg key
  // R[key_19]: V(True)
  logic key_19_qe;
  logic [0:0] key_19_flds_we;
  assign key_19_qe = &key_19_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_19 (
    .re     (1'b0),
    .we     (key_19_we),
    .wd     (key_19_wd),
    .d      (hw2reg.key[19].d),
    .qre    (),
    .qe     (key_19_flds_we[0]),
    .q      (reg2hw.key[19].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[19].qe = key_19_qe;


  // Subregister 20 of Multireg key
  // R[key_20]: V(True)
  logic key_20_qe;
  logic [0:0] key_20_flds_we;
  assign key_20_qe = &key_20_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_20 (
    .re     (1'b0),
    .we     (key_20_we),
    .wd     (key_20_wd),
    .d      (hw2reg.key[20].d),
    .qre    (),
    .qe     (key_20_flds_we[0]),
    .q      (reg2hw.key[20].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[20].qe = key_20_qe;


  // Subregister 21 of Multireg key
  // R[key_21]: V(True)
  logic key_21_qe;
  logic [0:0] key_21_flds_we;
  assign key_21_qe = &key_21_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_21 (
    .re     (1'b0),
    .we     (key_21_we),
    .wd     (key_21_wd),
    .d      (hw2reg.key[21].d),
    .qre    (),
    .qe     (key_21_flds_we[0]),
    .q      (reg2hw.key[21].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[21].qe = key_21_qe;


  // Subregister 22 of Multireg key
  // R[key_22]: V(True)
  logic key_22_qe;
  logic [0:0] key_22_flds_we;
  assign key_22_qe = &key_22_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_22 (
    .re     (1'b0),
    .we     (key_22_we),
    .wd     (key_22_wd),
    .d      (hw2reg.key[22].d),
    .qre    (),
    .qe     (key_22_flds_we[0]),
    .q      (reg2hw.key[22].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[22].qe = key_22_qe;


  // Subregister 23 of Multireg key
  // R[key_23]: V(True)
  logic key_23_qe;
  logic [0:0] key_23_flds_we;
  assign key_23_qe = &key_23_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_23 (
    .re     (1'b0),
    .we     (key_23_we),
    .wd     (key_23_wd),
    .d      (hw2reg.key[23].d),
    .qre    (),
    .qe     (key_23_flds_we[0]),
    .q      (reg2hw.key[23].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[23].qe = key_23_qe;


  // Subregister 24 of Multireg key
  // R[key_24]: V(True)
  logic key_24_qe;
  logic [0:0] key_24_flds_we;
  assign key_24_qe = &key_24_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_24 (
    .re     (1'b0),
    .we     (key_24_we),
    .wd     (key_24_wd),
    .d      (hw2reg.key[24].d),
    .qre    (),
    .qe     (key_24_flds_we[0]),
    .q      (reg2hw.key[24].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[24].qe = key_24_qe;


  // Subregister 25 of Multireg key
  // R[key_25]: V(True)
  logic key_25_qe;
  logic [0:0] key_25_flds_we;
  assign key_25_qe = &key_25_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_25 (
    .re     (1'b0),
    .we     (key_25_we),
    .wd     (key_25_wd),
    .d      (hw2reg.key[25].d),
    .qre    (),
    .qe     (key_25_flds_we[0]),
    .q      (reg2hw.key[25].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[25].qe = key_25_qe;


  // Subregister 26 of Multireg key
  // R[key_26]: V(True)
  logic key_26_qe;
  logic [0:0] key_26_flds_we;
  assign key_26_qe = &key_26_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_26 (
    .re     (1'b0),
    .we     (key_26_we),
    .wd     (key_26_wd),
    .d      (hw2reg.key[26].d),
    .qre    (),
    .qe     (key_26_flds_we[0]),
    .q      (reg2hw.key[26].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[26].qe = key_26_qe;


  // Subregister 27 of Multireg key
  // R[key_27]: V(True)
  logic key_27_qe;
  logic [0:0] key_27_flds_we;
  assign key_27_qe = &key_27_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_27 (
    .re     (1'b0),
    .we     (key_27_we),
    .wd     (key_27_wd),
    .d      (hw2reg.key[27].d),
    .qre    (),
    .qe     (key_27_flds_we[0]),
    .q      (reg2hw.key[27].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[27].qe = key_27_qe;


  // Subregister 28 of Multireg key
  // R[key_28]: V(True)
  logic key_28_qe;
  logic [0:0] key_28_flds_we;
  assign key_28_qe = &key_28_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_28 (
    .re     (1'b0),
    .we     (key_28_we),
    .wd     (key_28_wd),
    .d      (hw2reg.key[28].d),
    .qre    (),
    .qe     (key_28_flds_we[0]),
    .q      (reg2hw.key[28].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[28].qe = key_28_qe;


  // Subregister 29 of Multireg key
  // R[key_29]: V(True)
  logic key_29_qe;
  logic [0:0] key_29_flds_we;
  assign key_29_qe = &key_29_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_29 (
    .re     (1'b0),
    .we     (key_29_we),
    .wd     (key_29_wd),
    .d      (hw2reg.key[29].d),
    .qre    (),
    .qe     (key_29_flds_we[0]),
    .q      (reg2hw.key[29].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[29].qe = key_29_qe;


  // Subregister 30 of Multireg key
  // R[key_30]: V(True)
  logic key_30_qe;
  logic [0:0] key_30_flds_we;
  assign key_30_qe = &key_30_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_30 (
    .re     (1'b0),
    .we     (key_30_we),
    .wd     (key_30_wd),
    .d      (hw2reg.key[30].d),
    .qre    (),
    .qe     (key_30_flds_we[0]),
    .q      (reg2hw.key[30].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[30].qe = key_30_qe;


  // Subregister 31 of Multireg key
  // R[key_31]: V(True)
  logic key_31_qe;
  logic [0:0] key_31_flds_we;
  assign key_31_qe = &key_31_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_key_31 (
    .re     (1'b0),
    .we     (key_31_we),
    .wd     (key_31_wd),
    .d      (hw2reg.key[31].d),
    .qre    (),
    .qe     (key_31_flds_we[0]),
    .q      (reg2hw.key[31].q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.key[31].qe = key_31_qe;


  // Subregister 0 of Multireg digest
  // R[digest_0]: V(True)
  logic digest_0_qe;
  logic [0:0] digest_0_flds_we;
  assign digest_0_qe = &digest_0_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_digest_0 (
    .re     (digest_0_re),
    .we     (digest_0_we),
    .wd     (digest_0_wd),
    .d      (hw2reg.digest[0].d),
    .qre    (),
    .qe     (digest_0_flds_we[0]),
    .q      (reg2hw.digest[0].q),
    .ds     (),
    .qs     (digest_0_qs)
  );
  assign reg2hw.digest[0].qe = digest_0_qe;


  // Subregister 1 of Multireg digest
  // R[digest_1]: V(True)
  logic digest_1_qe;
  logic [0:0] digest_1_flds_we;
  assign digest_1_qe = &digest_1_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_digest_1 (
    .re     (digest_1_re),
    .we     (digest_1_we),
    .wd     (digest_1_wd),
    .d      (hw2reg.digest[1].d),
    .qre    (),
    .qe     (digest_1_flds_we[0]),
    .q      (reg2hw.digest[1].q),
    .ds     (),
    .qs     (digest_1_qs)
  );
  assign reg2hw.digest[1].qe = digest_1_qe;


  // Subregister 2 of Multireg digest
  // R[digest_2]: V(True)
  logic digest_2_qe;
  logic [0:0] digest_2_flds_we;
  assign digest_2_qe = &digest_2_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_digest_2 (
    .re     (digest_2_re),
    .we     (digest_2_we),
    .wd     (digest_2_wd),
    .d      (hw2reg.digest[2].d),
    .qre    (),
    .qe     (digest_2_flds_we[0]),
    .q      (reg2hw.digest[2].q),
    .ds     (),
    .qs     (digest_2_qs)
  );
  assign reg2hw.digest[2].qe = digest_2_qe;


  // Subregister 3 of Multireg digest
  // R[digest_3]: V(True)
  logic digest_3_qe;
  logic [0:0] digest_3_flds_we;
  assign digest_3_qe = &digest_3_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_digest_3 (
    .re     (digest_3_re),
    .we     (digest_3_we),
    .wd     (digest_3_wd),
    .d      (hw2reg.digest[3].d),
    .qre    (),
    .qe     (digest_3_flds_we[0]),
    .q      (reg2hw.digest[3].q),
    .ds     (),
    .qs     (digest_3_qs)
  );
  assign reg2hw.digest[3].qe = digest_3_qe;


  // Subregister 4 of Multireg digest
  // R[digest_4]: V(True)
  logic digest_4_qe;
  logic [0:0] digest_4_flds_we;
  assign digest_4_qe = &digest_4_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_digest_4 (
    .re     (digest_4_re),
    .we     (digest_4_we),
    .wd     (digest_4_wd),
    .d      (hw2reg.digest[4].d),
    .qre    (),
    .qe     (digest_4_flds_we[0]),
    .q      (reg2hw.digest[4].q),
    .ds     (),
    .qs     (digest_4_qs)
  );
  assign reg2hw.digest[4].qe = digest_4_qe;


  // Subregister 5 of Multireg digest
  // R[digest_5]: V(True)
  logic digest_5_qe;
  logic [0:0] digest_5_flds_we;
  assign digest_5_qe = &digest_5_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_digest_5 (
    .re     (digest_5_re),
    .we     (digest_5_we),
    .wd     (digest_5_wd),
    .d      (hw2reg.digest[5].d),
    .qre    (),
    .qe     (digest_5_flds_we[0]),
    .q      (reg2hw.digest[5].q),
    .ds     (),
    .qs     (digest_5_qs)
  );
  assign reg2hw.digest[5].qe = digest_5_qe;


  // Subregister 6 of Multireg digest
  // R[digest_6]: V(True)
  logic digest_6_qe;
  logic [0:0] digest_6_flds_we;
  assign digest_6_qe = &digest_6_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_digest_6 (
    .re     (digest_6_re),
    .we     (digest_6_we),
    .wd     (digest_6_wd),
    .d      (hw2reg.digest[6].d),
    .qre    (),
    .qe     (digest_6_flds_we[0]),
    .q      (reg2hw.digest[6].q),
    .ds     (),
    .qs     (digest_6_qs)
  );
  assign reg2hw.digest[6].qe = digest_6_qe;


  // Subregister 7 of Multireg digest
  // R[digest_7]: V(True)
  logic digest_7_qe;
  logic [0:0] digest_7_flds_we;
  assign digest_7_qe = &digest_7_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_digest_7 (
    .re     (digest_7_re),
    .we     (digest_7_we),
    .wd     (digest_7_wd),
    .d      (hw2reg.digest[7].d),
    .qre    (),
    .qe     (digest_7_flds_we[0]),
    .q      (reg2hw.digest[7].q),
    .ds     (),
    .qs     (digest_7_qs)
  );
  assign reg2hw.digest[7].qe = digest_7_qe;


  // Subregister 8 of Multireg digest
  // R[digest_8]: V(True)
  logic digest_8_qe;
  logic [0:0] digest_8_flds_we;
  assign digest_8_qe = &digest_8_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_digest_8 (
    .re     (digest_8_re),
    .we     (digest_8_we),
    .wd     (digest_8_wd),
    .d      (hw2reg.digest[8].d),
    .qre    (),
    .qe     (digest_8_flds_we[0]),
    .q      (reg2hw.digest[8].q),
    .ds     (),
    .qs     (digest_8_qs)
  );
  assign reg2hw.digest[8].qe = digest_8_qe;


  // Subregister 9 of Multireg digest
  // R[digest_9]: V(True)
  logic digest_9_qe;
  logic [0:0] digest_9_flds_we;
  assign digest_9_qe = &digest_9_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_digest_9 (
    .re     (digest_9_re),
    .we     (digest_9_we),
    .wd     (digest_9_wd),
    .d      (hw2reg.digest[9].d),
    .qre    (),
    .qe     (digest_9_flds_we[0]),
    .q      (reg2hw.digest[9].q),
    .ds     (),
    .qs     (digest_9_qs)
  );
  assign reg2hw.digest[9].qe = digest_9_qe;


  // Subregister 10 of Multireg digest
  // R[digest_10]: V(True)
  logic digest_10_qe;
  logic [0:0] digest_10_flds_we;
  assign digest_10_qe = &digest_10_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_digest_10 (
    .re     (digest_10_re),
    .we     (digest_10_we),
    .wd     (digest_10_wd),
    .d      (hw2reg.digest[10].d),
    .qre    (),
    .qe     (digest_10_flds_we[0]),
    .q      (reg2hw.digest[10].q),
    .ds     (),
    .qs     (digest_10_qs)
  );
  assign reg2hw.digest[10].qe = digest_10_qe;


  // Subregister 11 of Multireg digest
  // R[digest_11]: V(True)
  logic digest_11_qe;
  logic [0:0] digest_11_flds_we;
  assign digest_11_qe = &digest_11_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_digest_11 (
    .re     (digest_11_re),
    .we     (digest_11_we),
    .wd     (digest_11_wd),
    .d      (hw2reg.digest[11].d),
    .qre    (),
    .qe     (digest_11_flds_we[0]),
    .q      (reg2hw.digest[11].q),
    .ds     (),
    .qs     (digest_11_qs)
  );
  assign reg2hw.digest[11].qe = digest_11_qe;


  // Subregister 12 of Multireg digest
  // R[digest_12]: V(True)
  logic digest_12_qe;
  logic [0:0] digest_12_flds_we;
  assign digest_12_qe = &digest_12_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_digest_12 (
    .re     (digest_12_re),
    .we     (digest_12_we),
    .wd     (digest_12_wd),
    .d      (hw2reg.digest[12].d),
    .qre    (),
    .qe     (digest_12_flds_we[0]),
    .q      (reg2hw.digest[12].q),
    .ds     (),
    .qs     (digest_12_qs)
  );
  assign reg2hw.digest[12].qe = digest_12_qe;


  // Subregister 13 of Multireg digest
  // R[digest_13]: V(True)
  logic digest_13_qe;
  logic [0:0] digest_13_flds_we;
  assign digest_13_qe = &digest_13_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_digest_13 (
    .re     (digest_13_re),
    .we     (digest_13_we),
    .wd     (digest_13_wd),
    .d      (hw2reg.digest[13].d),
    .qre    (),
    .qe     (digest_13_flds_we[0]),
    .q      (reg2hw.digest[13].q),
    .ds     (),
    .qs     (digest_13_qs)
  );
  assign reg2hw.digest[13].qe = digest_13_qe;


  // Subregister 14 of Multireg digest
  // R[digest_14]: V(True)
  logic digest_14_qe;
  logic [0:0] digest_14_flds_we;
  assign digest_14_qe = &digest_14_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_digest_14 (
    .re     (digest_14_re),
    .we     (digest_14_we),
    .wd     (digest_14_wd),
    .d      (hw2reg.digest[14].d),
    .qre    (),
    .qe     (digest_14_flds_we[0]),
    .q      (reg2hw.digest[14].q),
    .ds     (),
    .qs     (digest_14_qs)
  );
  assign reg2hw.digest[14].qe = digest_14_qe;


  // Subregister 15 of Multireg digest
  // R[digest_15]: V(True)
  logic digest_15_qe;
  logic [0:0] digest_15_flds_we;
  assign digest_15_qe = &digest_15_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_digest_15 (
    .re     (digest_15_re),
    .we     (digest_15_we),
    .wd     (digest_15_wd),
    .d      (hw2reg.digest[15].d),
    .qre    (),
    .qe     (digest_15_flds_we[0]),
    .q      (reg2hw.digest[15].q),
    .ds     (),
    .qs     (digest_15_qs)
  );
  assign reg2hw.digest[15].qe = digest_15_qe;


  // R[msg_length_lower]: V(True)
  logic msg_length_lower_qe;
  logic [0:0] msg_length_lower_flds_we;
  assign msg_length_lower_qe = &msg_length_lower_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_msg_length_lower (
    .re     (msg_length_lower_re),
    .we     (msg_length_lower_we),
    .wd     (msg_length_lower_wd),
    .d      (hw2reg.msg_length_lower.d),
    .qre    (),
    .qe     (msg_length_lower_flds_we[0]),
    .q      (reg2hw.msg_length_lower.q),
    .ds     (),
    .qs     (msg_length_lower_qs)
  );
  assign reg2hw.msg_length_lower.qe = msg_length_lower_qe;


  // R[msg_length_upper]: V(True)
  logic msg_length_upper_qe;
  logic [0:0] msg_length_upper_flds_we;
  assign msg_length_upper_qe = &msg_length_upper_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_msg_length_upper (
    .re     (msg_length_upper_re),
    .we     (msg_length_upper_we),
    .wd     (msg_length_upper_wd),
    .d      (hw2reg.msg_length_upper.d),
    .qre    (),
    .qe     (msg_length_upper_flds_we[0]),
    .q      (reg2hw.msg_length_upper.q),
    .ds     (),
    .qs     (msg_length_upper_qs)
  );
  assign reg2hw.msg_length_upper.qe = msg_length_upper_qe;



  logic [58:0] addr_hit;
  always_comb begin
    addr_hit[ 0] = (reg_addr == HMAC_INTR_STATE_OFFSET);
    addr_hit[ 1] = (reg_addr == HMAC_INTR_ENABLE_OFFSET);
    addr_hit[ 2] = (reg_addr == HMAC_INTR_TEST_OFFSET);
    addr_hit[ 3] = (reg_addr == HMAC_ALERT_TEST_OFFSET);
    addr_hit[ 4] = (reg_addr == HMAC_CFG_OFFSET);
    addr_hit[ 5] = (reg_addr == HMAC_CMD_OFFSET);
    addr_hit[ 6] = (reg_addr == HMAC_STATUS_OFFSET);
    addr_hit[ 7] = (reg_addr == HMAC_ERR_CODE_OFFSET);
    addr_hit[ 8] = (reg_addr == HMAC_WIPE_SECRET_OFFSET);
    addr_hit[ 9] = (reg_addr == HMAC_KEY_0_OFFSET);
    addr_hit[10] = (reg_addr == HMAC_KEY_1_OFFSET);
    addr_hit[11] = (reg_addr == HMAC_KEY_2_OFFSET);
    addr_hit[12] = (reg_addr == HMAC_KEY_3_OFFSET);
    addr_hit[13] = (reg_addr == HMAC_KEY_4_OFFSET);
    addr_hit[14] = (reg_addr == HMAC_KEY_5_OFFSET);
    addr_hit[15] = (reg_addr == HMAC_KEY_6_OFFSET);
    addr_hit[16] = (reg_addr == HMAC_KEY_7_OFFSET);
    addr_hit[17] = (reg_addr == HMAC_KEY_8_OFFSET);
    addr_hit[18] = (reg_addr == HMAC_KEY_9_OFFSET);
    addr_hit[19] = (reg_addr == HMAC_KEY_10_OFFSET);
    addr_hit[20] = (reg_addr == HMAC_KEY_11_OFFSET);
    addr_hit[21] = (reg_addr == HMAC_KEY_12_OFFSET);
    addr_hit[22] = (reg_addr == HMAC_KEY_13_OFFSET);
    addr_hit[23] = (reg_addr == HMAC_KEY_14_OFFSET);
    addr_hit[24] = (reg_addr == HMAC_KEY_15_OFFSET);
    addr_hit[25] = (reg_addr == HMAC_KEY_16_OFFSET);
    addr_hit[26] = (reg_addr == HMAC_KEY_17_OFFSET);
    addr_hit[27] = (reg_addr == HMAC_KEY_18_OFFSET);
    addr_hit[28] = (reg_addr == HMAC_KEY_19_OFFSET);
    addr_hit[29] = (reg_addr == HMAC_KEY_20_OFFSET);
    addr_hit[30] = (reg_addr == HMAC_KEY_21_OFFSET);
    addr_hit[31] = (reg_addr == HMAC_KEY_22_OFFSET);
    addr_hit[32] = (reg_addr == HMAC_KEY_23_OFFSET);
    addr_hit[33] = (reg_addr == HMAC_KEY_24_OFFSET);
    addr_hit[34] = (reg_addr == HMAC_KEY_25_OFFSET);
    addr_hit[35] = (reg_addr == HMAC_KEY_26_OFFSET);
    addr_hit[36] = (reg_addr == HMAC_KEY_27_OFFSET);
    addr_hit[37] = (reg_addr == HMAC_KEY_28_OFFSET);
    addr_hit[38] = (reg_addr == HMAC_KEY_29_OFFSET);
    addr_hit[39] = (reg_addr == HMAC_KEY_30_OFFSET);
    addr_hit[40] = (reg_addr == HMAC_KEY_31_OFFSET);
    addr_hit[41] = (reg_addr == HMAC_DIGEST_0_OFFSET);
    addr_hit[42] = (reg_addr == HMAC_DIGEST_1_OFFSET);
    addr_hit[43] = (reg_addr == HMAC_DIGEST_2_OFFSET);
    addr_hit[44] = (reg_addr == HMAC_DIGEST_3_OFFSET);
    addr_hit[45] = (reg_addr == HMAC_DIGEST_4_OFFSET);
    addr_hit[46] = (reg_addr == HMAC_DIGEST_5_OFFSET);
    addr_hit[47] = (reg_addr == HMAC_DIGEST_6_OFFSET);
    addr_hit[48] = (reg_addr == HMAC_DIGEST_7_OFFSET);
    addr_hit[49] = (reg_addr == HMAC_DIGEST_8_OFFSET);
    addr_hit[50] = (reg_addr == HMAC_DIGEST_9_OFFSET);
    addr_hit[51] = (reg_addr == HMAC_DIGEST_10_OFFSET);
    addr_hit[52] = (reg_addr == HMAC_DIGEST_11_OFFSET);
    addr_hit[53] = (reg_addr == HMAC_DIGEST_12_OFFSET);
    addr_hit[54] = (reg_addr == HMAC_DIGEST_13_OFFSET);
    addr_hit[55] = (reg_addr == HMAC_DIGEST_14_OFFSET);
    addr_hit[56] = (reg_addr == HMAC_DIGEST_15_OFFSET);
    addr_hit[57] = (reg_addr == HMAC_MSG_LENGTH_LOWER_OFFSET);
    addr_hit[58] = (reg_addr == HMAC_MSG_LENGTH_UPPER_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = (reg_we &
              ((addr_hit[ 0] & (|(HMAC_PERMIT[ 0] & ~reg_be))) |
               (addr_hit[ 1] & (|(HMAC_PERMIT[ 1] & ~reg_be))) |
               (addr_hit[ 2] & (|(HMAC_PERMIT[ 2] & ~reg_be))) |
               (addr_hit[ 3] & (|(HMAC_PERMIT[ 3] & ~reg_be))) |
               (addr_hit[ 4] & (|(HMAC_PERMIT[ 4] & ~reg_be))) |
               (addr_hit[ 5] & (|(HMAC_PERMIT[ 5] & ~reg_be))) |
               (addr_hit[ 6] & (|(HMAC_PERMIT[ 6] & ~reg_be))) |
               (addr_hit[ 7] & (|(HMAC_PERMIT[ 7] & ~reg_be))) |
               (addr_hit[ 8] & (|(HMAC_PERMIT[ 8] & ~reg_be))) |
               (addr_hit[ 9] & (|(HMAC_PERMIT[ 9] & ~reg_be))) |
               (addr_hit[10] & (|(HMAC_PERMIT[10] & ~reg_be))) |
               (addr_hit[11] & (|(HMAC_PERMIT[11] & ~reg_be))) |
               (addr_hit[12] & (|(HMAC_PERMIT[12] & ~reg_be))) |
               (addr_hit[13] & (|(HMAC_PERMIT[13] & ~reg_be))) |
               (addr_hit[14] & (|(HMAC_PERMIT[14] & ~reg_be))) |
               (addr_hit[15] & (|(HMAC_PERMIT[15] & ~reg_be))) |
               (addr_hit[16] & (|(HMAC_PERMIT[16] & ~reg_be))) |
               (addr_hit[17] & (|(HMAC_PERMIT[17] & ~reg_be))) |
               (addr_hit[18] & (|(HMAC_PERMIT[18] & ~reg_be))) |
               (addr_hit[19] & (|(HMAC_PERMIT[19] & ~reg_be))) |
               (addr_hit[20] & (|(HMAC_PERMIT[20] & ~reg_be))) |
               (addr_hit[21] & (|(HMAC_PERMIT[21] & ~reg_be))) |
               (addr_hit[22] & (|(HMAC_PERMIT[22] & ~reg_be))) |
               (addr_hit[23] & (|(HMAC_PERMIT[23] & ~reg_be))) |
               (addr_hit[24] & (|(HMAC_PERMIT[24] & ~reg_be))) |
               (addr_hit[25] & (|(HMAC_PERMIT[25] & ~reg_be))) |
               (addr_hit[26] & (|(HMAC_PERMIT[26] & ~reg_be))) |
               (addr_hit[27] & (|(HMAC_PERMIT[27] & ~reg_be))) |
               (addr_hit[28] & (|(HMAC_PERMIT[28] & ~reg_be))) |
               (addr_hit[29] & (|(HMAC_PERMIT[29] & ~reg_be))) |
               (addr_hit[30] & (|(HMAC_PERMIT[30] & ~reg_be))) |
               (addr_hit[31] & (|(HMAC_PERMIT[31] & ~reg_be))) |
               (addr_hit[32] & (|(HMAC_PERMIT[32] & ~reg_be))) |
               (addr_hit[33] & (|(HMAC_PERMIT[33] & ~reg_be))) |
               (addr_hit[34] & (|(HMAC_PERMIT[34] & ~reg_be))) |
               (addr_hit[35] & (|(HMAC_PERMIT[35] & ~reg_be))) |
               (addr_hit[36] & (|(HMAC_PERMIT[36] & ~reg_be))) |
               (addr_hit[37] & (|(HMAC_PERMIT[37] & ~reg_be))) |
               (addr_hit[38] & (|(HMAC_PERMIT[38] & ~reg_be))) |
               (addr_hit[39] & (|(HMAC_PERMIT[39] & ~reg_be))) |
               (addr_hit[40] & (|(HMAC_PERMIT[40] & ~reg_be))) |
               (addr_hit[41] & (|(HMAC_PERMIT[41] & ~reg_be))) |
               (addr_hit[42] & (|(HMAC_PERMIT[42] & ~reg_be))) |
               (addr_hit[43] & (|(HMAC_PERMIT[43] & ~reg_be))) |
               (addr_hit[44] & (|(HMAC_PERMIT[44] & ~reg_be))) |
               (addr_hit[45] & (|(HMAC_PERMIT[45] & ~reg_be))) |
               (addr_hit[46] & (|(HMAC_PERMIT[46] & ~reg_be))) |
               (addr_hit[47] & (|(HMAC_PERMIT[47] & ~reg_be))) |
               (addr_hit[48] & (|(HMAC_PERMIT[48] & ~reg_be))) |
               (addr_hit[49] & (|(HMAC_PERMIT[49] & ~reg_be))) |
               (addr_hit[50] & (|(HMAC_PERMIT[50] & ~reg_be))) |
               (addr_hit[51] & (|(HMAC_PERMIT[51] & ~reg_be))) |
               (addr_hit[52] & (|(HMAC_PERMIT[52] & ~reg_be))) |
               (addr_hit[53] & (|(HMAC_PERMIT[53] & ~reg_be))) |
               (addr_hit[54] & (|(HMAC_PERMIT[54] & ~reg_be))) |
               (addr_hit[55] & (|(HMAC_PERMIT[55] & ~reg_be))) |
               (addr_hit[56] & (|(HMAC_PERMIT[56] & ~reg_be))) |
               (addr_hit[57] & (|(HMAC_PERMIT[57] & ~reg_be))) |
               (addr_hit[58] & (|(HMAC_PERMIT[58] & ~reg_be)))));
  end

  // Generate write-enables
  assign intr_state_we = addr_hit[0] & reg_we & !reg_error;

  assign intr_state_hmac_done_wd = reg_wdata[0];

  assign intr_state_hmac_err_wd = reg_wdata[2];
  assign intr_enable_we = addr_hit[1] & reg_we & !reg_error;

  assign intr_enable_hmac_done_wd = reg_wdata[0];

  assign intr_enable_fifo_empty_wd = reg_wdata[1];

  assign intr_enable_hmac_err_wd = reg_wdata[2];
  assign intr_test_we = addr_hit[2] & reg_we & !reg_error;

  assign intr_test_hmac_done_wd = reg_wdata[0];

  assign intr_test_fifo_empty_wd = reg_wdata[1];

  assign intr_test_hmac_err_wd = reg_wdata[2];
  assign alert_test_we = addr_hit[3] & reg_we & !reg_error;

  assign alert_test_wd = reg_wdata[0];
  assign cfg_re = addr_hit[4] & reg_re & !reg_error;
  assign cfg_we = addr_hit[4] & reg_we & !reg_error;

  assign cfg_hmac_en_wd = reg_wdata[0];

  assign cfg_sha_en_wd = reg_wdata[1];

  assign cfg_endian_swap_wd = reg_wdata[2];

  assign cfg_digest_swap_wd = reg_wdata[3];

  assign cfg_key_swap_wd = reg_wdata[4];

  assign cfg_digest_size_wd = reg_wdata[8:5];

  assign cfg_key_length_wd = reg_wdata[14:9];
  assign cmd_we = addr_hit[5] & reg_we & !reg_error;

  assign cmd_hash_start_wd = reg_wdata[0];

  assign cmd_hash_process_wd = reg_wdata[1];

  assign cmd_hash_stop_wd = reg_wdata[2];

  assign cmd_hash_continue_wd = reg_wdata[3];
  assign status_re = addr_hit[6] & reg_re & !reg_error;
  assign wipe_secret_we = addr_hit[8] & reg_we & !reg_error;

  assign wipe_secret_wd = reg_wdata[31:0];
  assign key_0_we = addr_hit[9] & reg_we & !reg_error;

  assign key_0_wd = reg_wdata[31:0];
  assign key_1_we = addr_hit[10] & reg_we & !reg_error;

  assign key_1_wd = reg_wdata[31:0];
  assign key_2_we = addr_hit[11] & reg_we & !reg_error;

  assign key_2_wd = reg_wdata[31:0];
  assign key_3_we = addr_hit[12] & reg_we & !reg_error;

  assign key_3_wd = reg_wdata[31:0];
  assign key_4_we = addr_hit[13] & reg_we & !reg_error;

  assign key_4_wd = reg_wdata[31:0];
  assign key_5_we = addr_hit[14] & reg_we & !reg_error;

  assign key_5_wd = reg_wdata[31:0];
  assign key_6_we = addr_hit[15] & reg_we & !reg_error;

  assign key_6_wd = reg_wdata[31:0];
  assign key_7_we = addr_hit[16] & reg_we & !reg_error;

  assign key_7_wd = reg_wdata[31:0];
  assign key_8_we = addr_hit[17] & reg_we & !reg_error;

  assign key_8_wd = reg_wdata[31:0];
  assign key_9_we = addr_hit[18] & reg_we & !reg_error;

  assign key_9_wd = reg_wdata[31:0];
  assign key_10_we = addr_hit[19] & reg_we & !reg_error;

  assign key_10_wd = reg_wdata[31:0];
  assign key_11_we = addr_hit[20] & reg_we & !reg_error;

  assign key_11_wd = reg_wdata[31:0];
  assign key_12_we = addr_hit[21] & reg_we & !reg_error;

  assign key_12_wd = reg_wdata[31:0];
  assign key_13_we = addr_hit[22] & reg_we & !reg_error;

  assign key_13_wd = reg_wdata[31:0];
  assign key_14_we = addr_hit[23] & reg_we & !reg_error;

  assign key_14_wd = reg_wdata[31:0];
  assign key_15_we = addr_hit[24] & reg_we & !reg_error;

  assign key_15_wd = reg_wdata[31:0];
  assign key_16_we = addr_hit[25] & reg_we & !reg_error;

  assign key_16_wd = reg_wdata[31:0];
  assign key_17_we = addr_hit[26] & reg_we & !reg_error;

  assign key_17_wd = reg_wdata[31:0];
  assign key_18_we = addr_hit[27] & reg_we & !reg_error;

  assign key_18_wd = reg_wdata[31:0];
  assign key_19_we = addr_hit[28] & reg_we & !reg_error;

  assign key_19_wd = reg_wdata[31:0];
  assign key_20_we = addr_hit[29] & reg_we & !reg_error;

  assign key_20_wd = reg_wdata[31:0];
  assign key_21_we = addr_hit[30] & reg_we & !reg_error;

  assign key_21_wd = reg_wdata[31:0];
  assign key_22_we = addr_hit[31] & reg_we & !reg_error;

  assign key_22_wd = reg_wdata[31:0];
  assign key_23_we = addr_hit[32] & reg_we & !reg_error;

  assign key_23_wd = reg_wdata[31:0];
  assign key_24_we = addr_hit[33] & reg_we & !reg_error;

  assign key_24_wd = reg_wdata[31:0];
  assign key_25_we = addr_hit[34] & reg_we & !reg_error;

  assign key_25_wd = reg_wdata[31:0];
  assign key_26_we = addr_hit[35] & reg_we & !reg_error;

  assign key_26_wd = reg_wdata[31:0];
  assign key_27_we = addr_hit[36] & reg_we & !reg_error;

  assign key_27_wd = reg_wdata[31:0];
  assign key_28_we = addr_hit[37] & reg_we & !reg_error;

  assign key_28_wd = reg_wdata[31:0];
  assign key_29_we = addr_hit[38] & reg_we & !reg_error;

  assign key_29_wd = reg_wdata[31:0];
  assign key_30_we = addr_hit[39] & reg_we & !reg_error;

  assign key_30_wd = reg_wdata[31:0];
  assign key_31_we = addr_hit[40] & reg_we & !reg_error;

  assign key_31_wd = reg_wdata[31:0];
  assign digest_0_re = addr_hit[41] & reg_re & !reg_error;
  assign digest_0_we = addr_hit[41] & reg_we & !reg_error;

  assign digest_0_wd = reg_wdata[31:0];
  assign digest_1_re = addr_hit[42] & reg_re & !reg_error;
  assign digest_1_we = addr_hit[42] & reg_we & !reg_error;

  assign digest_1_wd = reg_wdata[31:0];
  assign digest_2_re = addr_hit[43] & reg_re & !reg_error;
  assign digest_2_we = addr_hit[43] & reg_we & !reg_error;

  assign digest_2_wd = reg_wdata[31:0];
  assign digest_3_re = addr_hit[44] & reg_re & !reg_error;
  assign digest_3_we = addr_hit[44] & reg_we & !reg_error;

  assign digest_3_wd = reg_wdata[31:0];
  assign digest_4_re = addr_hit[45] & reg_re & !reg_error;
  assign digest_4_we = addr_hit[45] & reg_we & !reg_error;

  assign digest_4_wd = reg_wdata[31:0];
  assign digest_5_re = addr_hit[46] & reg_re & !reg_error;
  assign digest_5_we = addr_hit[46] & reg_we & !reg_error;

  assign digest_5_wd = reg_wdata[31:0];
  assign digest_6_re = addr_hit[47] & reg_re & !reg_error;
  assign digest_6_we = addr_hit[47] & reg_we & !reg_error;

  assign digest_6_wd = reg_wdata[31:0];
  assign digest_7_re = addr_hit[48] & reg_re & !reg_error;
  assign digest_7_we = addr_hit[48] & reg_we & !reg_error;

  assign digest_7_wd = reg_wdata[31:0];
  assign digest_8_re = addr_hit[49] & reg_re & !reg_error;
  assign digest_8_we = addr_hit[49] & reg_we & !reg_error;

  assign digest_8_wd = reg_wdata[31:0];
  assign digest_9_re = addr_hit[50] & reg_re & !reg_error;
  assign digest_9_we = addr_hit[50] & reg_we & !reg_error;

  assign digest_9_wd = reg_wdata[31:0];
  assign digest_10_re = addr_hit[51] & reg_re & !reg_error;
  assign digest_10_we = addr_hit[51] & reg_we & !reg_error;

  assign digest_10_wd = reg_wdata[31:0];
  assign digest_11_re = addr_hit[52] & reg_re & !reg_error;
  assign digest_11_we = addr_hit[52] & reg_we & !reg_error;

  assign digest_11_wd = reg_wdata[31:0];
  assign digest_12_re = addr_hit[53] & reg_re & !reg_error;
  assign digest_12_we = addr_hit[53] & reg_we & !reg_error;

  assign digest_12_wd = reg_wdata[31:0];
  assign digest_13_re = addr_hit[54] & reg_re & !reg_error;
  assign digest_13_we = addr_hit[54] & reg_we & !reg_error;

  assign digest_13_wd = reg_wdata[31:0];
  assign digest_14_re = addr_hit[55] & reg_re & !reg_error;
  assign digest_14_we = addr_hit[55] & reg_we & !reg_error;

  assign digest_14_wd = reg_wdata[31:0];
  assign digest_15_re = addr_hit[56] & reg_re & !reg_error;
  assign digest_15_we = addr_hit[56] & reg_we & !reg_error;

  assign digest_15_wd = reg_wdata[31:0];
  assign msg_length_lower_re = addr_hit[57] & reg_re & !reg_error;
  assign msg_length_lower_we = addr_hit[57] & reg_we & !reg_error;

  assign msg_length_lower_wd = reg_wdata[31:0];
  assign msg_length_upper_re = addr_hit[58] & reg_re & !reg_error;
  assign msg_length_upper_we = addr_hit[58] & reg_we & !reg_error;

  assign msg_length_upper_wd = reg_wdata[31:0];

  // Assign write-enables to checker logic vector.
  always_comb begin
    reg_we_check[0] = intr_state_we;
    reg_we_check[1] = intr_enable_we;
    reg_we_check[2] = intr_test_we;
    reg_we_check[3] = alert_test_we;
    reg_we_check[4] = cfg_we;
    reg_we_check[5] = cmd_we;
    reg_we_check[6] = 1'b0;
    reg_we_check[7] = 1'b0;
    reg_we_check[8] = wipe_secret_we;
    reg_we_check[9] = key_0_we;
    reg_we_check[10] = key_1_we;
    reg_we_check[11] = key_2_we;
    reg_we_check[12] = key_3_we;
    reg_we_check[13] = key_4_we;
    reg_we_check[14] = key_5_we;
    reg_we_check[15] = key_6_we;
    reg_we_check[16] = key_7_we;
    reg_we_check[17] = key_8_we;
    reg_we_check[18] = key_9_we;
    reg_we_check[19] = key_10_we;
    reg_we_check[20] = key_11_we;
    reg_we_check[21] = key_12_we;
    reg_we_check[22] = key_13_we;
    reg_we_check[23] = key_14_we;
    reg_we_check[24] = key_15_we;
    reg_we_check[25] = key_16_we;
    reg_we_check[26] = key_17_we;
    reg_we_check[27] = key_18_we;
    reg_we_check[28] = key_19_we;
    reg_we_check[29] = key_20_we;
    reg_we_check[30] = key_21_we;
    reg_we_check[31] = key_22_we;
    reg_we_check[32] = key_23_we;
    reg_we_check[33] = key_24_we;
    reg_we_check[34] = key_25_we;
    reg_we_check[35] = key_26_we;
    reg_we_check[36] = key_27_we;
    reg_we_check[37] = key_28_we;
    reg_we_check[38] = key_29_we;
    reg_we_check[39] = key_30_we;
    reg_we_check[40] = key_31_we;
    reg_we_check[41] = digest_0_we;
    reg_we_check[42] = digest_1_we;
    reg_we_check[43] = digest_2_we;
    reg_we_check[44] = digest_3_we;
    reg_we_check[45] = digest_4_we;
    reg_we_check[46] = digest_5_we;
    reg_we_check[47] = digest_6_we;
    reg_we_check[48] = digest_7_we;
    reg_we_check[49] = digest_8_we;
    reg_we_check[50] = digest_9_we;
    reg_we_check[51] = digest_10_we;
    reg_we_check[52] = digest_11_we;
    reg_we_check[53] = digest_12_we;
    reg_we_check[54] = digest_13_we;
    reg_we_check[55] = digest_14_we;
    reg_we_check[56] = digest_15_we;
    reg_we_check[57] = msg_length_lower_we;
    reg_we_check[58] = msg_length_upper_we;
  end

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[0] = intr_state_hmac_done_qs;
        reg_rdata_next[1] = intr_state_fifo_empty_qs;
        reg_rdata_next[2] = intr_state_hmac_err_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[0] = intr_enable_hmac_done_qs;
        reg_rdata_next[1] = intr_enable_fifo_empty_qs;
        reg_rdata_next[2] = intr_enable_hmac_err_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
        reg_rdata_next[2] = '0;
      end

      addr_hit[3]: begin
        reg_rdata_next[0] = '0;
      end

      addr_hit[4]: begin
        reg_rdata_next[0] = cfg_hmac_en_qs;
        reg_rdata_next[1] = cfg_sha_en_qs;
        reg_rdata_next[2] = cfg_endian_swap_qs;
        reg_rdata_next[3] = cfg_digest_swap_qs;
        reg_rdata_next[4] = cfg_key_swap_qs;
        reg_rdata_next[8:5] = cfg_digest_size_qs;
        reg_rdata_next[14:9] = cfg_key_length_qs;
      end

      addr_hit[5]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
        reg_rdata_next[2] = '0;
        reg_rdata_next[3] = '0;
      end

      addr_hit[6]: begin
        reg_rdata_next[0] = status_hmac_idle_qs;
        reg_rdata_next[1] = status_fifo_empty_qs;
        reg_rdata_next[2] = status_fifo_full_qs;
        reg_rdata_next[9:4] = status_fifo_depth_qs;
      end

      addr_hit[7]: begin
        reg_rdata_next[31:0] = err_code_qs;
      end

      addr_hit[8]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[9]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[10]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[11]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[12]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[13]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[14]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[15]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[16]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[17]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[18]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[19]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[20]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[21]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[22]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[23]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[24]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[25]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[26]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[27]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[28]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[29]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[30]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[31]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[32]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[33]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[34]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[35]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[36]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[37]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[38]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[39]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[40]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[41]: begin
        reg_rdata_next[31:0] = digest_0_qs;
      end

      addr_hit[42]: begin
        reg_rdata_next[31:0] = digest_1_qs;
      end

      addr_hit[43]: begin
        reg_rdata_next[31:0] = digest_2_qs;
      end

      addr_hit[44]: begin
        reg_rdata_next[31:0] = digest_3_qs;
      end

      addr_hit[45]: begin
        reg_rdata_next[31:0] = digest_4_qs;
      end

      addr_hit[46]: begin
        reg_rdata_next[31:0] = digest_5_qs;
      end

      addr_hit[47]: begin
        reg_rdata_next[31:0] = digest_6_qs;
      end

      addr_hit[48]: begin
        reg_rdata_next[31:0] = digest_7_qs;
      end

      addr_hit[49]: begin
        reg_rdata_next[31:0] = digest_8_qs;
      end

      addr_hit[50]: begin
        reg_rdata_next[31:0] = digest_9_qs;
      end

      addr_hit[51]: begin
        reg_rdata_next[31:0] = digest_10_qs;
      end

      addr_hit[52]: begin
        reg_rdata_next[31:0] = digest_11_qs;
      end

      addr_hit[53]: begin
        reg_rdata_next[31:0] = digest_12_qs;
      end

      addr_hit[54]: begin
        reg_rdata_next[31:0] = digest_13_qs;
      end

      addr_hit[55]: begin
        reg_rdata_next[31:0] = digest_14_qs;
      end

      addr_hit[56]: begin
        reg_rdata_next[31:0] = digest_15_qs;
      end

      addr_hit[57]: begin
        reg_rdata_next[31:0] = msg_length_lower_qs;
      end

      addr_hit[58]: begin
        reg_rdata_next[31:0] = msg_length_upper_qs;
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

  // Assertions for Register Interface
    
    

  

  

  // this is formulated as an assumption such that the FPV testbenches do disprove this
  // property by mistake
  //`ASSUME(reqParity, tl_reg_h2d.a_valid |-> tl_reg_h2d.a_user.chk_en == tlul_pkg::CheckDis)

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// HMAC Core implementation

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


module hmac_core import prim_sha2_pkg::*; (
  input clk_i,
  input rst_ni,

  input [1023:0]      secret_key_i, // {word0, word1, ..., word7}
  input               hmac_en_i,
  input digest_mode_e digest_size_i,
  input key_length_e  key_length_i,

  input        reg_hash_start_i,
  input        reg_hash_stop_i,
  input        reg_hash_continue_i,
  input        reg_hash_process_i,
  output logic hash_done_o,
  output logic sha_hash_start_o,
  output logic sha_hash_continue_o,
  output logic sha_hash_process_o,
  input        sha_hash_done_i,

  // fifo
  output logic        sha_rvalid_o,
  output sha_fifo32_t sha_rdata_o,
  input               sha_rready_i,

  input               fifo_rvalid_i,
  input  sha_fifo32_t fifo_rdata_i,
  output logic        fifo_rready_o,

  // fifo control (select and fifo write data)
  output logic       fifo_wsel_o,      // 0: from reg, 1: from digest
  output logic       fifo_wvalid_o,
  // 0: digest[0][upper], 1:digest[0][lower] .. 14: digest[7][upper], 15: digest[7][lower]
  output logic [3:0] fifo_wdata_sel_o,
  input              fifo_wready_i,

  input  [63:0] message_length_i,
  output [63:0] sha_message_length_o,

  output logic idle_o
);

  localparam int unsigned BlockSizeSHA256     = 512;
  localparam int unsigned BlockSizeSHA512     = 1024;

  localparam int unsigned BlockSizeBitsSHA256 = $clog2(BlockSizeSHA256);
  localparam int unsigned BlockSizeBitsSHA512 = $clog2(BlockSizeSHA512);

  localparam int unsigned HashWordBitsSHA256  = $clog2($bits(sha_word32_t));

  localparam bit [63:0] BlockSizeSHA256in64  = 64'(BlockSizeSHA256);
  localparam bit [63:0] BlockSizeSHA512in64  = 64'(BlockSizeSHA512);

  logic hash_start;    // generated from internal state machine
  logic hash_continue; // generated from internal state machine
  logic hash_process;  // generated from internal state machine to trigger hash
  logic hmac_hash_done;

  logic [BlockSizeSHA256-1:0] i_pad_256;
  logic [BlockSizeSHA512-1:0] i_pad_512;
  logic [BlockSizeSHA256-1:0] o_pad_256;
  logic [BlockSizeSHA512-1:0] o_pad_512;

  logic [63:0] txcount, txcount_d; // works for both digest lengths

  logic [BlockSizeBitsSHA512-HashWordBitsSHA256-1:0] pad_index_512;
  logic [BlockSizeBitsSHA256-HashWordBitsSHA256-1:0] pad_index_256;
  logic clr_txcount, load_txcount, inc_txcount;

  logic hmac_sha_rvalid;

  logic idle_d, idle_q;
  logic reg_hash_stop_d, reg_hash_stop_q;

  typedef enum logic [1:0] {
    SelIPad,
    SelOPad,
    SelFifo
  } sel_rdata_t;

  sel_rdata_t sel_rdata;

  typedef enum logic {
    SelIPadMsg,
    SelOPadMsg
  } sel_msglen_t;

  sel_msglen_t sel_msglen;

  typedef enum logic {
    Inner,  // Update when state goes to StIPad
    Outer   // Update when state enters StOPad
  } round_t ;

  logic update_round ;
  round_t round_q, round_d;

  typedef enum logic [2:0] {
    StIdle,
    StIPad,
    StMsg,              // Actual Msg, and Digest both
    StPushToMsgFifo,    // Digest --> Msg Fifo
    StWaitResp,         // Hash done( by checking processed_length? or hash_done)
    StOPad,
    StDone              // hmac_done
  } st_e ;

  st_e st_q, st_d;

  logic clr_fifo_wdata_sel;
  logic txcnt_eq_blksz;

  logic reg_hash_process_flag;

  assign sha_hash_start_o    = (hmac_en_i) ? hash_start    : reg_hash_start_i;
  assign sha_hash_continue_o = (hmac_en_i) ? hash_continue : reg_hash_continue_i;

  assign sha_hash_process_o  = (hmac_en_i) ? reg_hash_process_i | hash_process : reg_hash_process_i;
  assign hash_done_o         = (hmac_en_i) ? hmac_hash_done                    : sha_hash_done_i;

  assign pad_index_512 = txcount[BlockSizeBitsSHA512-1:HashWordBitsSHA256];
  assign pad_index_256 = txcount[BlockSizeBitsSHA256-1:HashWordBitsSHA256];

  // adjust inner and outer padding depending on key length and block size
  always_comb begin : adjust_key_pad_length
    // set defaults
    i_pad_256 = '{default: '0};
    i_pad_512 = '{default: '0};
    o_pad_256 = '{default: '0};
    o_pad_512 = '{default: '0};

    unique case (key_length_i)
      Key_128: begin
        i_pad_256 = {secret_key_i[1023:896],
                    {(BlockSizeSHA256-128){1'b0}}} ^ {(BlockSizeSHA256/8){8'h36}};
        i_pad_512 = {secret_key_i[1023:896],
                    {(BlockSizeSHA512-128){1'b0}}} ^ {(BlockSizeSHA512/8){8'h36}};
        o_pad_256 = {secret_key_i[1023:896],
                    {(BlockSizeSHA256-128){1'b0}}} ^ {(BlockSizeSHA256/8){8'h5c}};
        o_pad_512 = {secret_key_i[1023:896],
                    {(BlockSizeSHA512-128){1'b0}}} ^ {(BlockSizeSHA512/8){8'h5c}};
      end
      Key_256: begin
        i_pad_256 = {secret_key_i[1023:768],
                    {(BlockSizeSHA256-256){1'b0}}} ^ {(BlockSizeSHA256/8){8'h36}};
        i_pad_512 = {secret_key_i[1023:768],
                    {(BlockSizeSHA512-256){1'b0}}} ^ {(BlockSizeSHA512/8){8'h36}};
        o_pad_256 = {secret_key_i[1023:768],
                    {(BlockSizeSHA256-256){1'b0}}} ^ {(BlockSizeSHA256/8){8'h5c}};
        o_pad_512 = {secret_key_i[1023:768],
                    {(BlockSizeSHA512-256){1'b0}}} ^ {(BlockSizeSHA512/8){8'h5c}};
      end
      Key_384: begin
        i_pad_256 = {secret_key_i[1023:640],
                    {(BlockSizeSHA256-384){1'b0}}} ^ {(BlockSizeSHA256/8){8'h36}};
        i_pad_512 = {secret_key_i[1023:640],
                    {(BlockSizeSHA512-384){1'b0}}} ^ {(BlockSizeSHA512/8){8'h36}};
        o_pad_256 = {secret_key_i[1023:640],
                    {(BlockSizeSHA256-384){1'b0}}} ^ {(BlockSizeSHA256/8){8'h5c}};
        o_pad_512 = {secret_key_i[1023:640],
                    {(BlockSizeSHA512-384){1'b0}}} ^ {(BlockSizeSHA512/8){8'h5c}};
      end
      Key_512: begin
        i_pad_256 = secret_key_i[1023:512] ^ {(BlockSizeSHA256/8){8'h36}};
        i_pad_512 = {secret_key_i[1023:512],
                    {(BlockSizeSHA512-512){1'b0}}} ^ {(BlockSizeSHA512/8){8'h36}};
        o_pad_256 = secret_key_i[1023:512] ^ {(BlockSizeSHA256/8){8'h5c}};
        o_pad_512 = {secret_key_i[1023:512],
                    {(BlockSizeSHA512-512){1'b0}}} ^ {(BlockSizeSHA512/8){8'h5c}};
      end
      Key_1024: begin // not allowed to be configured for SHA-2 256
        // zero out for SHA-2 256
        i_pad_256 = '{default: '0};
        i_pad_512 = secret_key_i[1023:0]   ^ {(BlockSizeSHA512/8){8'h36}};
        // zero out for SHA-2 256
        o_pad_256 = '{default: '0};
        o_pad_512 = secret_key_i[1023:0]   ^ {(BlockSizeSHA512/8){8'h5c}};
      end
      default: begin
      end
    endcase
  end

  assign fifo_rready_o = (hmac_en_i) ? (st_q == StMsg) & sha_rready_i : sha_rready_i ;
  // sha_rvalid is controlled by State Machine below.
  assign sha_rvalid_o  = (!hmac_en_i) ? fifo_rvalid_i : hmac_sha_rvalid ;
  assign sha_rdata_o =
    (!hmac_en_i)    ? fifo_rdata_i                                                             :
    (sel_rdata == SelIPad && digest_size_i == SHA2_256)
                  ? '{data: i_pad_256[(BlockSizeSHA256-1)-32*pad_index_256-:32], mask: '1} :
    (sel_rdata == SelIPad && ((digest_size_i == SHA2_384) || (digest_size_i == SHA2_512)))
                  ? '{data: i_pad_512[(BlockSizeSHA512-1)-32*pad_index_512-:32], mask: '1} :
    (sel_rdata == SelOPad && digest_size_i == SHA2_256)
                  ? '{data: o_pad_256[(BlockSizeSHA256-1)-32*pad_index_256-:32], mask: '1} :
    (sel_rdata == SelOPad && ((digest_size_i == SHA2_384) || (digest_size_i == SHA2_512)))
                  ? '{data: o_pad_512[(BlockSizeSHA512-1)-32*pad_index_512-:32], mask: '1} :
    // Well-defined default case `sel_rdata == SelFifo`. `sel_rdata == 2'b11` cannot occur.
                  fifo_rdata_i;

  logic [63:0] sha_msg_len;

  always_comb begin: assign_sha_message_length
    sha_msg_len = '0;
    if (!hmac_en_i) begin
      sha_msg_len = message_length_i;
    // HASH = (o_pad || HASH_INTERMEDIATE (i_pad || msg))
    // message length for HASH_INTERMEDIATE = block size (i_pad) + message length
    end else if (sel_msglen == SelIPadMsg) begin
      if (digest_size_i == SHA2_256) begin
        sha_msg_len = message_length_i + BlockSizeSHA256in64;
      end else if ((digest_size_i == SHA2_384) || (digest_size_i == SHA2_512)) begin
        sha_msg_len = message_length_i + BlockSizeSHA512in64;
      // `SHA2_None` is a permissible value in the `SelIPadMsg` case. It can not occur for the
      // `SelOPadMsg` message length.
      end else begin
        sha_msg_len = '0;
      end
    end else begin // `SelOPadMsg`
      // message length for HASH = block size (o_pad) + HASH_INTERMEDIATE digest length
      if (digest_size_i == SHA2_256) begin
        sha_msg_len = BlockSizeSHA256in64 + 64'd256;
      end else if (digest_size_i == SHA2_384) begin
        sha_msg_len = BlockSizeSHA512in64 + 64'd384;
      end else begin // SHA512
        sha_msg_len = BlockSizeSHA512in64 + 64'd512;
      end
    end
  end

  assign sha_message_length_o = sha_msg_len;

  always_comb begin
    txcnt_eq_blksz = '0;

    unique case (digest_size_i)
      SHA2_256: txcnt_eq_blksz = (txcount[BlockSizeBitsSHA256-1:0] == '0) && (txcount != '0);
      SHA2_384: txcnt_eq_blksz = (txcount[BlockSizeBitsSHA512-1:0] == '0) && (txcount != '0);
      SHA2_512: txcnt_eq_blksz = (txcount[BlockSizeBitsSHA512-1:0] == '0) && (txcount != '0);
      default;
    endcase
  end

  assign inc_txcount = sha_rready_i && sha_rvalid_o;

  // txcount
  //    Looks like txcount can be removed entirely here in hmac_core
  //    In the first round (InnerPaddedKey), it can just watch process and hash_done
  //    In the second round, it only needs count 256 bits for hash digest to trigger
  //    hash_process to SHA2
  always_comb begin
    txcount_d = txcount;
    if (clr_txcount) begin
      txcount_d = '0;
    end else if (load_txcount) begin
      // When loading, add block size to the message length because the SW-visible message length
      // does not include the block containing the key xor'ed with the inner pad.
      unique case (digest_size_i)
        SHA2_256: txcount_d = message_length_i + BlockSizeSHA256in64;
        SHA2_384: txcount_d = message_length_i + BlockSizeSHA512in64;
        SHA2_512: txcount_d = message_length_i + BlockSizeSHA512in64;
        default : txcount_d = message_length_i + '0;
      endcase
    end else if (inc_txcount) begin
      txcount_d[63:5] = txcount[63:5] + 1'b1; // increment by 32 (data word size)
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) txcount <= '0;
    else         txcount <= txcount_d;
  end

  // reg_hash_process_i trigger logic
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      reg_hash_process_flag <= 1'b0;
    end else if (reg_hash_process_i) begin
      reg_hash_process_flag <= 1'b1;
    end else if (hmac_hash_done || reg_hash_start_i || reg_hash_continue_i) begin
      reg_hash_process_flag <= 1'b0;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      round_q <= Inner;
    end else if (update_round) begin
      round_q <= round_d;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      fifo_wdata_sel_o <= '0;
    end else if (clr_fifo_wdata_sel) begin
      fifo_wdata_sel_o <= '0;
    end else if (fifo_wsel_o && fifo_wvalid_o) begin
      fifo_wdata_sel_o <= fifo_wdata_sel_o + 1'b1; // increment by 1
    end
  end

  assign sel_msglen = (round_q == Inner) ? SelIPadMsg : SelOPadMsg ;

  always_ff @(posedge clk_i or negedge rst_ni) begin : state_ff
    if (!rst_ni) st_q <= StIdle;
    else         st_q <= st_d;
  end

  always_comb begin : next_state
    hmac_hash_done     = 1'b0;
    hmac_sha_rvalid    = 1'b0;
    clr_txcount        = 1'b0;
    load_txcount       = 1'b0;
    update_round       = 1'b0;
    round_d            = Inner;
    fifo_wsel_o        = 1'b0;   // from register
    fifo_wvalid_o      = 1'b0;
    clr_fifo_wdata_sel = 1'b1;
    sel_rdata          = SelFifo;
    hash_start         = 1'b0;
    hash_continue      = 1'b0;
    hash_process       = 1'b0;
    st_d               = st_q;

    unique case (st_q)
      StIdle: begin
        // reset round to Inner
        // we always switch context into inner round since outer round computes once over
        // single block at the end (outer key pad + inner hash)
        update_round = 1'b1;
        round_d      = Inner;
        if (hmac_en_i && reg_hash_start_i) begin
          st_d = StIPad; // start at StIPad if told to start

          clr_txcount  = 1'b1;
          hash_start   = 1'b1;
        end else if (hmac_en_i && reg_hash_continue_i) begin
          st_d = StMsg; // skip StIPad if told to continue - assumed it finished StIPad

          load_txcount  = 1'b1;
          hash_continue = 1'b1;
        end else begin
          st_d = StIdle;
        end
      end

      StIPad: begin
        sel_rdata = SelIPad;

        if (txcnt_eq_blksz) begin
          st_d = StMsg;

          hmac_sha_rvalid = 1'b0; // block new read request
        end else begin
          st_d = StIPad;

          hmac_sha_rvalid = 1'b1;
        end
      end

      StMsg: begin
        sel_rdata   = SelFifo;
        fifo_wsel_o = (round_q == Outer);

        if ( (((round_q == Inner) && reg_hash_process_flag) || (round_q == Outer))
            && (txcount >= sha_message_length_o)) begin
          st_d    = StWaitResp;

          hmac_sha_rvalid = 1'b0; // block reading words from MSG FIFO
          hash_process    = (round_q == Outer);
        end else if (txcnt_eq_blksz && (txcount >= sha_message_length_o)
                     && reg_hash_stop_q && (round_q == Inner)) begin
          // wait till all MSG words are pushed out from FIFO (txcount reaches msg length)
          // before transitioning to StWaitResp to wait on sha_hash_done_i and disabling
          // reading from MSG FIFO
          st_d =  StWaitResp;

          hmac_sha_rvalid = 1'b0;
        end else begin
          st_d            = StMsg;
          hmac_sha_rvalid = fifo_rvalid_i;
        end
      end

      StWaitResp: begin
        hmac_sha_rvalid = 1'b0;

        if (sha_hash_done_i) begin
          if (round_q == Outer) begin
            st_d = StDone;
          end else begin // round_q == Inner
            if (reg_hash_stop_q) begin
              st_d = StDone;
            end else begin
              st_d = StPushToMsgFifo;
            end
          end
        end else begin
          st_d = StWaitResp;
        end
      end

      StPushToMsgFifo: begin
        hmac_sha_rvalid    = 1'b0;
        fifo_wsel_o        = 1'b1;
        fifo_wvalid_o      = 1'b1;
        clr_fifo_wdata_sel = 1'b0;

        if (fifo_wready_i && (((fifo_wdata_sel_o == 4'd7) && (digest_size_i == SHA2_256)) ||
                             ((fifo_wdata_sel_o == 4'd15) && (digest_size_i == SHA2_512)) ||
                             ((fifo_wdata_sel_o == 4'd11) && (digest_size_i == SHA2_384)))) begin

          st_d = StOPad;

          clr_txcount  = 1'b1;
          update_round = 1'b1;
          round_d      = Outer;
          hash_start   = 1'b1;
        end else begin
          st_d = StPushToMsgFifo;

        end
      end

      StOPad: begin
        sel_rdata   = SelOPad;
        fifo_wsel_o = 1'b1; // Remained HMAC select to indicate HMAC is in second stage

        if (txcnt_eq_blksz) begin
          st_d = StMsg;

          hmac_sha_rvalid = 1'b0; // block new read request
        end else begin
          st_d = StOPad;

          hmac_sha_rvalid = 1'b1;
        end
      end

      StDone: begin
        // raise interrupt (hash_done)
        st_d = StIdle;

        hmac_hash_done = 1'b1;
      end

      default: begin
        st_d = StIdle;
      end

    endcase
  end

  // raise reg_hash_stop_d flag at reg_hash_stop_i and keep it until sha_hash_done_i is asserted
  // to indicate the hashing operation on current block has completed
  assign reg_hash_stop_d = (reg_hash_stop_i == 1'b1)                            ? 1'b1 :
                           (sha_hash_done_i == 1'b1 && reg_hash_stop_q == 1'b1) ? 1'b0 :
                                                                                  reg_hash_stop_q;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      reg_hash_stop_q <= 1'b0;
    end else begin
      reg_hash_stop_q <= reg_hash_stop_d;
    end
  end

  // Idle status signaling: This module ..
  assign idle_d =
      // .. is not idle when told to start or continue
      (reg_hash_start_i || reg_hash_continue_i) ? 1'b0 :
      // .. is idle when the FSM is in the Idle state
      (st_q == StIdle) ? 1'b1 :
      // .. is idle when it has processed a complete block of a message and is told to stop in any
      // FSM state
      (txcnt_eq_blksz && reg_hash_stop_d) ? 1'b1 :
      // .. and keeps the current idle state in all other cases.
      idle_q;

  assign idle_o = idle_d;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      idle_q <= 1'b1;
    end else begin
      idle_q <= idle_d;
    end
  end

  ////////////////
  // Assertions //
  ////////////////

  
  

endmodule
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// HMAC/SHA-2 256/384/512

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


module hmac
  import prim_sha2_pkg::*;
  import hmac_reg_pkg::*;
#(
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}},
  // Number of cycles a differential skew is tolerated on the alert signal
  parameter int unsigned AlertSkewCycles = 1
) (
  input clk_i,
  input rst_ni,

  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,

  input  prim_alert_pkg::alert_rx_t [NumAlerts-1:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t [NumAlerts-1:0] alert_tx_o,

  output logic intr_hmac_done_o,
  output logic intr_fifo_empty_o,
  output logic intr_hmac_err_o,

  output prim_mubi_pkg::mubi4_t idle_o
);


  /////////////////////////
  // Signal declarations //
  /////////////////////////
  hmac_reg2hw_t reg2hw;
  hmac_hw2reg_t hw2reg;

  tlul_pkg::tl_h2d_t  tl_win_h2d;
  tlul_pkg::tl_d2h_t  tl_win_d2h;

  logic [1023:0] secret_key, secret_key_d;

  // Logic will support key length <= block size
  // Will default to key length = block size, if key length > block size or unsupported value
  key_length_e key_length_supplied, key_length;

  logic        wipe_secret;
  logic [31:0] wipe_v;

  logic        fifo_rvalid;
  logic        fifo_rready;
  sha_fifo32_t fifo_rdata;

  logic        fifo_wvalid, fifo_wready;
  sha_fifo32_t fifo_wdata;
  logic        fifo_full;
  logic        fifo_empty;
  logic [5:0]  fifo_depth;

  logic        msg_fifo_req;
  logic        msg_fifo_gnt;
  logic        msg_fifo_we;
  logic [31:0] msg_fifo_wdata;
  logic [31:0] msg_fifo_wmask;
  logic [31:0] msg_fifo_rdata;
  logic [1:0]  msg_fifo_rerror;
  logic [31:0] msg_fifo_wdata_endian;
  logic [31:0] msg_fifo_wmask_endian;

  logic        packer_ready;
  logic        packer_flush_done;

  logic         reg_fifo_wvalid;
  sha_word32_t  reg_fifo_wdata;
  sha_word32_t  reg_fifo_wmask;
  logic         hmac_fifo_wsel;
  logic         hmac_fifo_wvalid;
  logic [3:0]   hmac_fifo_wdata_sel;

  logic         shaf_rvalid;
  sha_fifo32_t  shaf_rdata;
  logic         shaf_rready;

  logic        sha_en;
  logic        hmac_en;
  logic        endian_swap;
  logic        digest_swap;
  logic        key_swap;

  logic        reg_hash_start;
  logic        sha_hash_start;
  logic        reg_hash_stop;
  logic        reg_hash_continue;
  logic        sha_hash_continue;
  logic        hash_start;     // hash_start is reg_hash_start gated with extra checks
  logic        hash_continue;  // hash_continue is reg_hash_continue gated with extra checks
  logic        hash_process;   // hash_process is reg_hash_process gated with extra checks
  logic        hash_start_or_continue;
  logic        hash_done_event;
  logic        reg_hash_process;
  logic        sha_hash_process;
  logic        digest_on_blk;

  logic        reg_hash_done;
  logic        sha_hash_done;

  logic [63:0] message_length, message_length_d;
  logic [63:0] sha_message_length;

  err_code_e  err_code;
  logic       err_valid;
  logic       invalid_config; // HMAC/SHA-2 is configured with invalid digest size/key length
  logic       invalid_config_atstart;

  sha_word64_t [7:0] digest, digest_sw;
  logic [7:0]        digest_sw_we;

  digest_mode_e digest_size, digest_size_supplied;
  // this is the digest size captured into HMAC when it gets started
  digest_mode_e digest_size_started_d, digest_size_started_q;

  hmac_reg2hw_cfg_reg_t cfg_reg;
  logic                 cfg_block;   // Prevents changing config
  logic                 msg_allowed; // MSG_FIFO from software is allowed

  logic hmac_core_idle;
  logic sha_core_idle;
  logic hash_running;
  logic idle;

  ///////////////////////
  // Connect registers //
  ///////////////////////
  assign hw2reg.status.fifo_full.d  = fifo_full;
  assign hw2reg.status.fifo_empty.d = fifo_empty;
  assign hw2reg.status.fifo_depth.d = fifo_depth;
  assign hw2reg.status.hmac_idle.d  = idle;

  typedef enum logic [1:0] {
    DoneAwaitCmd,
    DoneAwaitHashDone,
    DoneAwaitMessageComplete,
    DoneAwaitHashComplete
  } done_state_e;

  done_state_e done_state_d, done_state_q;

  always_comb begin
    done_state_d    = done_state_q;
    hash_done_event = 1'b0;

    unique case (done_state_q)
      DoneAwaitCmd: begin
        if (sha_hash_process) begin
          // SHA has been told to process the message, so signal *done* when the hash is done.
          done_state_d = DoneAwaitHashDone;
        end else if (reg_hash_stop) begin
          // SHA has been told to stop, so first wait for the current message block to be complete.
          done_state_d = DoneAwaitMessageComplete;
        end
      end

      DoneAwaitHashDone: begin
        if (reg_hash_done) begin
          hash_done_event = 1'b1;
          done_state_d = DoneAwaitCmd;
        end
      end

      DoneAwaitMessageComplete: begin
        if (digest_on_blk) begin
          // Once the digest is being computed for the complete message block, wait for the hash to
          // complete.
          done_state_d = DoneAwaitHashComplete;
        end
      end

      DoneAwaitHashComplete: begin
        if (!hash_running) begin
          hash_done_event = 1'b1;
          done_state_d = DoneAwaitCmd;
        end
      end

      default: ;
    endcase
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      done_state_q <= DoneAwaitCmd;
    end else begin
      done_state_q <= done_state_d;
    end
  end

  assign wipe_secret = reg2hw.wipe_secret.qe;
  assign wipe_v      = reg2hw.wipe_secret.q;

  // update secret key
  always_comb begin : update_secret_key
    secret_key_d = secret_key;
    if (wipe_secret) begin
      secret_key_d = {32{wipe_v}};
    end else if (!cfg_block) begin
      // Allow updating secret key only when the engine is in Idle.
      for (int i = 0; i < 32; i++) begin
        if (reg2hw.key[31-i].qe) begin
          // swap byte endianness per secret key word if key_swap = 1
          secret_key_d[32*i+:32] = conv_endian32(reg2hw.key[31-i].q, key_swap);
        end
      end
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) secret_key <= '0;
    else         secret_key <= secret_key_d;
  end

  for (genvar i = 0; i < 32; i++) begin : gen_key
    assign hw2reg.key[31-i].d      = '0;
  end

  // Retain the previous digest in CSRs until HMAC is actually started with a valid configuration
  always_comb begin : assign_digest_reg
    // default
    // digest SW -> HW
    digest_sw     = '0;
    digest_sw_we  = '0;
    // digest HW -> SW
    hw2reg.digest = '0;

    for (int i = 0; i < 8; i++) begin
      // digest SW -> HW (depends on digest size configured even before starting/enabling)
      // capturing the intermediate digests written by SW when restoring context into the SHA-2
      // engine before it is started
      if (digest_size == SHA2_256) begin
        // digest SW -> HW
        digest_sw[i][31:0] = conv_endian32(reg2hw.digest[i].q, digest_swap);
        digest_sw_we[i]    = reg2hw.digest[i].qe;
      end else if ((digest_size == SHA2_384) || (digest_size == SHA2_512)) begin
        // digest SW -> HW
        digest_sw[i][63:32]    = reg2hw.digest[2*i].qe ?
                                 conv_endian32(reg2hw.digest[2*i].q, digest_swap) :
                                 digest[i][63:32];
        digest_sw[i][31:0]     = reg2hw.digest[2*i+1].qe ?
                                 conv_endian32(reg2hw.digest[2*i+1].q, digest_swap) :
                                 digest[i][31:0];
        digest_sw_we[i]        = reg2hw.digest[2*i].qe | reg2hw.digest[2*i+1].qe;
      end

      // digest HW -> SW (depends on configuration that has been started)
      if (digest_size_started_q == SHA2_256) begin
        hw2reg.digest[i].d   = conv_endian32(digest[i][31:0], digest_swap);
        // replicate digest[0..7] into digest[8..15]. Digest[8...15] are irrelevant for SHA2_256,
        // but this ensures all digest CSRs are wiped out with random value (at wipe_secret)
        // across different configurations.
        hw2reg.digest[i+8].d = conv_endian32(digest[i][31:0], digest_swap);
      end else if ((digest_size_started_q == SHA2_384) || (digest_size_started_q == SHA2_512)) begin
        // digest HW -> SW
        // digest swap only within each 32-bit word of the 64-bit digest word, not digest swap
        // on the entire 64-bit digest word
        hw2reg.digest[2*i].d   = conv_endian32(digest[i][63:32], digest_swap);
        hw2reg.digest[2*i+1].d = conv_endian32(digest[i][31:0], digest_swap);
      end else begin // for SHA2_None
        // to ensure secret wiping is always passed to digest CSRs
        hw2reg.digest[i].d   = conv_endian32(digest[i][31:0], digest_swap);
        hw2reg.digest[i+8].d = conv_endian32(digest[i][31:0], digest_swap);
      end
    end
  end

  logic unused_cfg_qe;
  assign unused_cfg_qe = ^{cfg_reg.sha_en.qe,      cfg_reg.hmac_en.qe,
                           cfg_reg.endian_swap.qe, cfg_reg.digest_swap.qe,
                           cfg_reg.key_swap.qe,    cfg_reg.digest_size.qe,
                           cfg_reg.key_length.qe };

  assign sha_en               = cfg_reg.sha_en.q;
  assign hmac_en              = cfg_reg.hmac_en.q;

  assign digest_size_supplied = digest_mode_e'(cfg_reg.digest_size.q);
  always_comb begin : cast_digest_size
    digest_size = SHA2_None;

    unique case (digest_size_supplied)
      SHA2_256:  digest_size = SHA2_256;
      SHA2_384:  digest_size = SHA2_384;
      SHA2_512:  digest_size = SHA2_512;
      // unsupported digest size values are mapped to SHA2_None
      // if HMAC/SHA-2 is triggered to start with this digest size, it is blocked
      // and an error is signalled to SW
      default:   digest_size = SHA2_None;
    endcase
  end

  // Hold the previous digest size till HMAC is started with the new digest size configured
  assign digest_size_started_d = (hash_start_or_continue) ? digest_size : digest_size_started_q;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) digest_size_started_q <= SHA2_None;
    else         digest_size_started_q <= digest_size_started_d;
  end

  assign key_length_supplied  = key_length_e'(cfg_reg.key_length.q);
  always_comb begin : cast_key_length
    key_length = Key_None;

    unique case (key_length_supplied)
      Key_128:  key_length = Key_128;
      Key_256:  key_length = Key_256;
      Key_384:  key_length = Key_384;
      Key_512:  key_length = Key_512;
      Key_1024: key_length = Key_1024;
      // unsupported key length values are mapped to Key_None
      // if HMAC (not SHA-2) is triggered to start with this key length, it is blocked
      // and an error is signalled to SW
      default:  key_length = Key_None;
    endcase
  end

  assign endian_swap = cfg_reg.endian_swap.q;
  assign digest_swap = cfg_reg.digest_swap.q;
  assign key_swap    = cfg_reg.key_swap.q;

  assign hw2reg.cfg.hmac_en.d     = cfg_reg.hmac_en.q;
  assign hw2reg.cfg.sha_en.d      = cfg_reg.sha_en.q;
  assign hw2reg.cfg.digest_size.d = digest_mode_e'(digest_size);
  assign hw2reg.cfg.key_length.d  = key_length_e'(key_length);
  assign hw2reg.cfg.endian_swap.d = cfg_reg.endian_swap.q;
  assign hw2reg.cfg.digest_swap.d = cfg_reg.digest_swap.q;
  assign hw2reg.cfg.key_swap.d    = cfg_reg.key_swap.q;

  assign reg_hash_start    = reg2hw.cmd.hash_start.qe & reg2hw.cmd.hash_start.q;
  assign reg_hash_stop     = reg2hw.cmd.hash_stop.qe & reg2hw.cmd.hash_stop.q;
  assign reg_hash_continue = reg2hw.cmd.hash_continue.qe & reg2hw.cmd.hash_continue.q;
  assign reg_hash_process  = reg2hw.cmd.hash_process.qe & reg2hw.cmd.hash_process.q;

  // Error code register
  assign hw2reg.err_code.de = err_valid;
  assign hw2reg.err_code.d  = err_code;

  /////////////////////
  // Control signals //
  /////////////////////
  assign hash_start             = reg_hash_start    & sha_en & ~cfg_block & ~invalid_config;
  assign hash_continue          = reg_hash_continue & sha_en & ~cfg_block & ~invalid_config;
  assign hash_process           = reg_hash_process  & sha_en & cfg_block &  ~invalid_config;
  assign hash_start_or_continue = hash_start | hash_continue;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      cfg_block <= '0;
    end else if (hash_start_or_continue) begin
      cfg_block <= 1'b 1;
    end else if (reg_hash_done || reg_hash_stop) begin
      cfg_block <= 1'b 0;
    end
  end
  // Hold the configuration during the process
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      cfg_reg <= '{
        hmac_en: '{
          q: 1'b0,
          qe: 1'b0
        },
        sha_en: '{
          q: 1'b0,
          qe: 1'b0
        },
        endian_swap: '{
          q: HMAC_CFG_ENDIAN_SWAP_RESVAL,
          qe: 1'b0
        },
        digest_swap: '{
          q: HMAC_CFG_DIGEST_SWAP_RESVAL,
          qe: 1'b0
        },
        key_swap: '{
          q: HMAC_CFG_KEY_SWAP_RESVAL,
          qe: 1'b0
        },
        digest_size: '{
          q: HMAC_CFG_DIGEST_SIZE_RESVAL,
          qe: 1'b0
        },
        key_length: '{
          q: HMAC_CFG_KEY_LENGTH_RESVAL,
          qe: 1'b0
        },
        default:'0
      };
    end else if (!cfg_block && reg2hw.cfg.hmac_en.qe) begin
      cfg_reg <= reg2hw.cfg ;
    end
  end

  // Open up the MSG_FIFO from the TL-UL port when it is ready
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      msg_allowed <= '0;
    end else if (hash_start_or_continue) begin
      msg_allowed <= 1'b 1;
    end else if (packer_flush_done) begin
      msg_allowed <= 1'b 0;
    end
  end

  ////////////////
  // Interrupts //
  ////////////////

  // instantiate interrupt hardware primitive
  prim_intr_hw #(.Width(1)) intr_hw_hmac_done (
    .clk_i,
    .rst_ni,
    .event_intr_i           (hash_done_event),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.hmac_done.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.hmac_done.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.hmac_done.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.hmac_done.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.hmac_done.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.hmac_done.d),
    .intr_o                 (intr_hmac_done_o)
  );

  // FIFO empty interrupt
  //
  // The FIFO empty interrupt is **not useful** for software if:
  // - The HMAC block is running in HMAC mode and performing the second round of computing the
  //   final hash of the outer key as well as the result of the first round using the inner key.
  //   The FIFO is then managed entirely by the hardware.
  // - The FIFO is currently not writeable by software.
  // - Software has already written the Process command. The HMAC block will now empty the
  //   FIFO and load its content into the SHA2 core, add the padding and then perform
  //   the final hashing operation. Software cannot append the message further.
  // - Software has written the Stop command. The HMAC block will not wait for further input from
  //   software after finishing the current block.
  //
  // The FIFO empty interrupt can be **useful** for software in particular if:
  // - The FIFO was completely full previously. However, unless the HMAC block is currently
  //   processing a block, it always empties the message FIFO faster than software can fill it up,
  //   meaning the message FIFO is empty most of the time. Note, the empty status is signaled only
  //   once after the FIFO was completely full. The FIFO needs to be full again for the empty
  //   status to be signaled again next time it's empty.
  logic status_fifo_empty, fifo_empty_gate;
  logic fifo_empty_negedge, fifo_empty_q;
  logic fifo_full_posedge, fifo_full_q;
  logic fifo_full_seen_d, fifo_full_seen_q;
  assign fifo_empty_negedge = fifo_empty_q & ~fifo_empty;
  assign fifo_full_posedge  = ~fifo_full_q & fifo_full;

  // Track whether the FIFO was full after being empty. We clear the tracking:
  // - When receiving the Start, Continue, Process or Stop command. This is to start over for the
  //   next message.
  // - When seeing a negative edge on the empty signal. This signals that software has reacted to
  //   the interrupt and is filling up the FIFO again.
  assign fifo_full_seen_d =
      reg_hash_start   || reg_hash_continue ||
      reg_hash_process || reg_hash_stop     ? 1'b 0 :
      fifo_empty_negedge                    ? 1'b 0 :
      fifo_full_posedge                     ? 1'b 1 : fifo_full_seen_q;

  // The interrupt is gated unless software is actually allowed to write the FIFO and the FIFO was
  // full before.
  assign fifo_empty_gate = ~msg_allowed || ~fifo_full_seen_q;

  assign status_fifo_empty = fifo_empty_gate ? 1'b 0 : fifo_empty;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      fifo_empty_q     <= 1'b 0;
      fifo_full_q      <= 1'b 0;
      fifo_full_seen_q <= 1'b 0;
    end else begin
      fifo_empty_q     <= fifo_empty;
      fifo_full_q      <= fifo_full;
      fifo_full_seen_q <= fifo_full_seen_d;
    end
  end

  prim_intr_hw #(
    .Width(1),
    .IntrT("Status")
  ) intr_hw_fifo_empty (
    .clk_i,
    .rst_ni,
    .event_intr_i           (status_fifo_empty),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.fifo_empty.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.fifo_empty.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.fifo_empty.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.fifo_empty.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.fifo_empty.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.fifo_empty.d),
    .intr_o                 (intr_fifo_empty_o)
  );
  prim_intr_hw #(.Width(1)) intr_hw_hmac_err (
    .clk_i,
    .rst_ni,
    .event_intr_i           (err_valid),
    .reg2hw_intr_enable_q_i (reg2hw.intr_enable.hmac_err.q),
    .reg2hw_intr_test_q_i   (reg2hw.intr_test.hmac_err.q),
    .reg2hw_intr_test_qe_i  (reg2hw.intr_test.hmac_err.qe),
    .reg2hw_intr_state_q_i  (reg2hw.intr_state.hmac_err.q),
    .hw2reg_intr_state_de_o (hw2reg.intr_state.hmac_err.de),
    .hw2reg_intr_state_d_o  (hw2reg.intr_state.hmac_err.d),
    .intr_o                 (intr_hmac_err_o)
  );

  ///////////////
  // Instances //
  ///////////////

  assign msg_fifo_rdata  = '1;  // Return all F
  assign msg_fifo_rerror = '1;  // Return error for read access
  assign msg_fifo_gnt    = msg_fifo_req & ~hmac_fifo_wsel & packer_ready;

  /////////////////////
  // Unused Signals //
  /////////////////////
  logic unused_signals;
  assign unused_signals = ^{reg_fifo_wmask[7:1],   reg_fifo_wmask[15:9],
                            reg_fifo_wmask[23:17], reg_fifo_wmask[31:25]};

  // FIFO control: from packer into message FIFO
  sha_fifo32_t reg_fifo_wentry;
  assign reg_fifo_wentry.data = conv_endian32(reg_fifo_wdata, 1'b1); // always convert
  assign reg_fifo_wentry.mask = {reg_fifo_wmask[0],  reg_fifo_wmask[8],
                                 reg_fifo_wmask[16], reg_fifo_wmask[24]};
  assign fifo_empty  = ~fifo_rvalid;
  assign fifo_wvalid = (hmac_fifo_wsel && fifo_wready) ? hmac_fifo_wvalid : reg_fifo_wvalid;

  logic index;
  always_comb begin : select_fifo_wdata
    // default when !hmac_fifo_wsel
    index      = 1'b0;
    fifo_wdata = reg_fifo_wentry;

    if (hmac_fifo_wsel) begin
      fifo_wdata = '0;
      if (digest_size == SHA2_256) begin
        // only reads out lower 32 bits of each digest word and discards upper 32-bit zero padding
        fifo_wdata = '{data: digest[hmac_fifo_wdata_sel[2:0]][31:0], mask: '1};
      end else if ((digest_size == SHA2_384) || (digest_size == SHA2_512)) begin
        // reads out first upper 32 bits then lower 32 bits of each digest word
        index = !hmac_fifo_wdata_sel[0];
        fifo_wdata = '{data: digest[hmac_fifo_wdata_sel[3:1]][32*index+:32], mask: '1};
      end
    end
  end

  // Extended for 1024-bit block
  localparam int MsgFifoDepth = 32;
  prim_fifo_sync #(
    .Width       ($bits(sha_fifo32_t)),
    .Pass        (1'b1),
    .Depth       (MsgFifoDepth),
    .NeverClears (1'b1)
  ) u_msg_fifo (
    .clk_i,
    .rst_ni,
    .clr_i   (1'b0),

    .wvalid_i(fifo_wvalid & sha_en),
    .wready_o(fifo_wready),
    .wdata_i (fifo_wdata),

    .depth_o (fifo_depth),
    .full_o  (fifo_full),

    .rvalid_o(fifo_rvalid),
    .rready_i(fifo_rready),
    .rdata_o (fifo_rdata),
    .err_o   ()
  );

  // TL ADAPTER SRAM
  tlul_adapter_sram #(
    .SramAw (9),
    .SramDw (32),
    .Outstanding (1),
    .ByteAccess  (1),
    .ErrOnRead   (1)
  ) u_tlul_adapter (
    .clk_i,
    .rst_ni,
    .tl_i                       (tl_win_h2d),
    .tl_o                       (tl_win_d2h),
    .en_ifetch_i                (prim_mubi_pkg::MuBi4False),
    .req_o                      (msg_fifo_req   ),
    .req_type_o                 (               ),
    .gnt_i                      (msg_fifo_gnt   ),
    .we_o                       (msg_fifo_we    ),
    .addr_o                     (               ), // Doesn't care the address
                                                   // other than sub-word
    .wdata_o                    (msg_fifo_wdata ),
    .wmask_o                    (msg_fifo_wmask ),
    .intg_error_o               (               ),
    .user_rsvd_o                (               ),
    .rdata_i                    (msg_fifo_rdata ),
    .rvalid_i                   (1'b0           ),
    .rerror_i                   (msg_fifo_rerror),
    .compound_txn_in_progress_o (),
    .readback_en_i              (prim_mubi_pkg::MuBi4False),
    .readback_error_o           (),
    .wr_collision_i             (1'b0),
    .write_pending_i            (1'b0)
  );

  // TL-UL to MSG_FIFO byte write handling
  logic msg_write;

  assign msg_write = msg_fifo_req & msg_fifo_we & ~hmac_fifo_wsel & msg_allowed;

  logic [$clog2(32+1)-1:0] wmask_ones;

  always_comb begin
    wmask_ones = '0;
    for (int i = 0 ; i < 32 ; i++) begin
      wmask_ones = wmask_ones + msg_fifo_wmask[i];
    end
  end

  // Calculate written message
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) message_length <= '0;
    else         message_length <= message_length_d;
  end

  always_comb begin
    message_length_d = message_length;
    if (!cfg_block) begin
      if (reg2hw.msg_length_lower.qe) begin
        message_length_d[31:0]  = reg2hw.msg_length_lower.q;
      end
      if (reg2hw.msg_length_upper.qe) begin
        message_length_d[63:32] = reg2hw.msg_length_upper.q;
      end
    end

    if (hash_start) begin
      message_length_d = '0;
    end else if (msg_write && sha_en && packer_ready) begin
      message_length_d = message_length + 64'(wmask_ones);
    end
  end

  assign hw2reg.msg_length_upper.d = message_length[63:32];
  assign hw2reg.msg_length_lower.d = message_length[31:0];

  // Convert endian here
  //    prim_packer always packs to the right, but SHA engine assumes incoming
  //    to be big-endian, [31:24] comes first. So, the data is reverted after
  //    prim_packer before the message fifo. here to reverse if not big-endian
  //    before pushing to the packer.
  assign msg_fifo_wdata_endian = conv_endian32(msg_fifo_wdata, endian_swap);
  assign msg_fifo_wmask_endian = conv_endian32(msg_fifo_wmask, endian_swap);

  prim_packer #(
    .InW          (32),
    .OutW         (32),
    .EnProtection (1'b 0)
  ) u_packer (
    .clk_i,
    .rst_ni,

    .valid_i      (msg_write & sha_en),
    .data_i       (msg_fifo_wdata_endian),
    .mask_i       (msg_fifo_wmask_endian),
    .ready_o      (packer_ready),

    .valid_o      (reg_fifo_wvalid),
    .data_o       (reg_fifo_wdata),
    .mask_o       (reg_fifo_wmask),
    .ready_i      (fifo_wready & ~hmac_fifo_wsel),

    .flush_i      (hash_process),
    .flush_done_o (packer_flush_done), // ignore at this moment

    .err_o  () // Not used
  );

  hmac_core u_hmac (
    .clk_i,
    .rst_ni,
    .secret_key_i  (secret_key),
    .hmac_en_i     (hmac_en),
    .digest_size_i (digest_size),
    .key_length_i  (key_length),

    .reg_hash_start_i    (hash_start),
    .reg_hash_stop_i     (reg_hash_stop),
    .reg_hash_continue_i (hash_continue),
    .reg_hash_process_i  (packer_flush_done), // Trigger after all msg written
    .hash_done_o         (reg_hash_done),
    .sha_hash_start_o    (sha_hash_start),
    .sha_hash_continue_o (sha_hash_continue),
    .sha_hash_process_o  (sha_hash_process),
    .sha_hash_done_i     (sha_hash_done),

    .sha_rvalid_o     (shaf_rvalid),
    .sha_rdata_o      (shaf_rdata),
    .sha_rready_i     (shaf_rready),

    .fifo_rvalid_i (fifo_rvalid),
    .fifo_rdata_i  (fifo_rdata),
    .fifo_rready_o (fifo_rready),

    .fifo_wsel_o      (hmac_fifo_wsel),
    .fifo_wvalid_o    (hmac_fifo_wvalid),
    .fifo_wdata_sel_o (hmac_fifo_wdata_sel),
    .fifo_wready_i    (fifo_wready),

    .message_length_i     (message_length),
    .sha_message_length_o (sha_message_length),

    .idle_o           (hmac_core_idle)
  );

  // Instantiate SHA-2 256/384/512 engine
  prim_sha2_32 #(
      .MultimodeEn(1)
  ) u_prim_sha2_512 (
    .clk_i,
    .rst_ni,
    .wipe_secret_i        (wipe_secret),
    .wipe_v_i             (wipe_v),
    .fifo_rvalid_i        (shaf_rvalid),
    .fifo_rdata_i         (shaf_rdata),
    .fifo_rready_o        (shaf_rready),
    .sha_en_i             (sha_en),
    .hash_start_i         (sha_hash_start),
    .hash_stop_i          (reg_hash_stop),
    .hash_continue_i      (sha_hash_continue),
    .digest_mode_i        (digest_size),
    .hash_process_i       (sha_hash_process),
    .message_length_i     (sha_message_length),
    .digest_i             (digest_sw),
    .digest_we_i          (digest_sw_we),
    .digest_o             (digest),
    .hash_running_o       (hash_running),
    .digest_on_blk_o      (digest_on_blk),
    .hash_done_o          (sha_hash_done),
    .idle_o               (sha_core_idle)
  );

  // Register top
  logic [NumAlerts-1:0] alert_test, alerts;
  hmac_reg_top u_reg (
    .clk_i,
    .rst_ni,

    .tl_i,
    .tl_o,

    .tl_win_o   (tl_win_h2d),
    .tl_win_i   (tl_win_d2h),

    .reg2hw,
    .hw2reg,

    // SEC_CM: BUS.INTEGRITY
    .intg_err_o (alerts[0])
  );

  // Alerts
  assign alert_test = {
    reg2hw.alert_test.q &
    reg2hw.alert_test.qe
  };

  localparam logic [NumAlerts-1:0] AlertIsFatal = {1'b1};
  for (genvar i = 0; i < NumAlerts; i++) begin : gen_alert_tx
    prim_alert_sender #(
      .AsyncOn(AlertAsyncOn[i]),
      .SkewCycles(AlertSkewCycles),
      .IsFatal(AlertIsFatal[i])
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

  /////////////////////////
  // HMAC Error Handling //
  /////////////////////////
  logic hash_start_sha_disabled, update_seckey_inprocess;
  logic hash_start_active;  // `reg_hash_start` or `reg_hash_continue` set when hash already active
  logic msg_push_not_allowed; // Message is received when `hash_start_or_continue` isn't set

  assign hash_start_sha_disabled = (reg_hash_start | reg_hash_continue) & ~sha_en;
  assign hash_start_active = (reg_hash_start | reg_hash_continue) & cfg_block;
  assign msg_push_not_allowed = msg_fifo_req & ~msg_allowed;

  // Invalid/unconfigured HMAC/SHA-2: not configured/invalid digest size or
  // not configured/invalid key length for HMAC mode or
  // key_length = 1024-bit for digest_size = SHA2_256 (max 512-bit is supported for SHA-2 256)
  assign invalid_config = ((digest_size == SHA2_None)            |
                           ((key_length == Key_None) && hmac_en) |
                           ((key_length == Key_1024) && (digest_size == SHA2_256) && hmac_en));

  // invalid_config at reg_hash_start or reg_hash_continue will signal an error to the SW
  assign invalid_config_atstart = (reg_hash_start || reg_hash_continue) & invalid_config;

  always_comb begin
    update_seckey_inprocess = 1'b0;
    if (cfg_block) begin
      for (int i = 0 ; i < 32 ; i++) begin
        if (reg2hw.key[i].qe) begin
          update_seckey_inprocess = update_seckey_inprocess | 1'b1;
        end
      end
    end else begin
      update_seckey_inprocess = 1'b0;
    end
  end

  // Update ERR_CODE register and interrupt only when no pending interrupt.
  // This ensures only the first event of the series of events can be seen to sw.
  // It is recommended that the software reads ERR_CODE register when interrupt
  // is pending to avoid any race conditions.
  assign err_valid = ~reg2hw.intr_state.hmac_err.q &
                   ( hash_start_sha_disabled | update_seckey_inprocess
                   | hash_start_active | msg_push_not_allowed | invalid_config_atstart);

  always_comb begin
    // default
    err_code = NoError;

    priority case (1'b1)
      // SwInvalidConfig has the highest priority: SW configures HMAC incorrectly
      invalid_config_atstart: begin
        err_code = SwInvalidConfig;
      end

      hash_start_sha_disabled: begin
        err_code = SwHashStartWhenShaDisabled;
      end

      hash_start_active: begin
        err_code = SwHashStartWhenActive;
      end

      msg_push_not_allowed: begin
        err_code = SwPushMsgWhenDisallowed;
      end

      update_seckey_inprocess: begin
        err_code = SwUpdateSecretKeyInProcess;
      end

      default: begin
        err_code = NoError;
      end
    endcase
  end

  /////////////////////
  // Idle output     //
  /////////////////////
  // TBD this should be connected later
  // Idle: AND condition of:
  //  - packer empty: Currently no way to guarantee the packer is empty.
  //    temporary, the logic uses packer output (reg_fifo_wvalid)
  //  - MSG_FIFO  --> fifo_rvalid
  //  - HMAC_CORE --> hmac_core_idle
  //  - SHA2_CORE --> sha_core_idle
  //  - Clean interrupt status
  // ICEBOX(#12958): Revise prim_packer and replace `reg_fifo_wvalid` to the
  // empty status.
  assign idle = !reg_fifo_wvalid && !fifo_rvalid
              && hmac_core_idle && sha_core_idle;

  prim_mubi_pkg::mubi4_t idle_q, idle_d;
  assign idle_d = prim_mubi_pkg::mubi4_bool_to_mubi(idle);
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      idle_q <= prim_mubi_pkg::MuBi4False;
    end else begin
      idle_q <= idle_d;
    end
  end
  assign idle_o = idle_q;

  //////////////////////////////////////////////
  // Assertions, Assumptions, and Coverpoints //
  //////////////////////////////////////////////

 // SYNTHESIS
 // VERILATOR

  // Alert assertions for reg_we onehot check
                                                                                     
                        
  
endmodule
