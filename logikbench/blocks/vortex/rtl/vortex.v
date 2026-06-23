module vortex_core_wrap (
	clk,
	reset,
	busy
);
	input wire clk;
	input wire reset;
	output wire busy;
	generate
		if (1) begin : dcr_bus_if
			wire req_valid;
			localparam VX_gpu_pkg_VX_DCR_ADDR_WIDTH = 12;
			localparam VX_gpu_pkg_VX_DCR_DATA_WIDTH = 32;
			wire [44:0] req_data;
			wire rsp_valid;
			wire [31:0] rsp_data;
		end
	endgenerate
	localparam VX_gpu_pkg_DCACHE_WORD_SIZE = 16;
	localparam VX_gpu_pkg_XLENB = 4;
	localparam VX_gpu_pkg_LSU_WORD_SIZE = VX_gpu_pkg_XLENB;
	localparam VX_gpu_pkg_DCACHE_CHANNELS = 1;
	localparam VX_gpu_pkg_DCACHE_NUM_REQS = 1;
	localparam VX_gpu_pkg_DCACHE_MERGED_REQS = 1;
	localparam VX_gpu_pkg_DCACHE_MEM_BATCHES = 1;
	localparam VX_gpu_pkg_DCACHE_TAG_ID_BITS = 2;
	localparam VX_gpu_pkg_UUID_WIDTH = 44;
	localparam VX_gpu_pkg_DCACHE_CORE_TAG_WIDTH = 46;
	localparam VX_gpu_pkg_DCACHE_TAG_WIDTH_BASE = 47;
	localparam VX_gpu_pkg_DCACHE_TAG_WIDTH = VX_gpu_pkg_DCACHE_TAG_WIDTH_BASE;
	localparam _param_3A2A6_DATA_SIZE = VX_gpu_pkg_DCACHE_WORD_SIZE;
	localparam _param_3A2A6_TAG_WIDTH = VX_gpu_pkg_DCACHE_TAG_WIDTH;
	genvar _arr_3A2A6;
	generate
		for (_arr_3A2A6 = 0; _arr_3A2A6 <= 0; _arr_3A2A6 = _arr_3A2A6 + 1) begin : dcache_bus_if
			localparam DATA_SIZE = _param_3A2A6_DATA_SIZE;
			localparam VX_gpu_pkg_NC_BITS = 0;
			localparam VX_gpu_pkg_NT_BITS = 2;
			localparam VX_gpu_pkg_NW_BITS = 2;
			localparam VX_gpu_pkg_HART_ID_BITS = 4;
			localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
			localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
			localparam ATTR_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
			localparam VX_gpu_pkg_UUID_WIDTH = 44;
			localparam TAG_WIDTH = _param_3A2A6_TAG_WIDTH;
			localparam ADDR_WIDTH = 28;
			wire req_valid;
			wire [232:0] req_data;
			wire req_ready;
			wire rsp_valid;
			wire [174:0] rsp_data;
			wire rsp_ready;
		end
	endgenerate
	localparam VX_gpu_pkg_NW_BITS = 2;
	localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
	localparam VX_gpu_pkg_ICACHE_TAG_ID_BITS = VX_gpu_pkg_NW_WIDTH;
	localparam VX_gpu_pkg_ICACHE_FETCH_TAG_WIDTH = 46;
	localparam VX_gpu_pkg_ICACHE_TAG_WIDTH_BASE = 47;
	localparam VX_gpu_pkg_ICACHE_TAG_WIDTH = VX_gpu_pkg_ICACHE_TAG_WIDTH_BASE;
	localparam VX_gpu_pkg_ICACHE_WORD_SIZE = 4;
	localparam _param_61AD2_DATA_SIZE = VX_gpu_pkg_ICACHE_WORD_SIZE;
	localparam _param_61AD2_TAG_WIDTH = VX_gpu_pkg_ICACHE_TAG_WIDTH;
	generate
		if (1) begin : icache_bus_if
			localparam DATA_SIZE = _param_61AD2_DATA_SIZE;
			localparam VX_gpu_pkg_NC_BITS = 0;
			localparam VX_gpu_pkg_NT_BITS = 2;
			localparam VX_gpu_pkg_NW_BITS = 2;
			localparam VX_gpu_pkg_HART_ID_BITS = 4;
			localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
			localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
			localparam ATTR_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
			localparam VX_gpu_pkg_UUID_WIDTH = 44;
			localparam TAG_WIDTH = _param_61AD2_TAG_WIDTH;
			localparam ADDR_WIDTH = 30;
			wire req_valid;
			wire [126:0] req_data;
			wire req_ready;
			wire rsp_valid;
			wire [78:0] rsp_data;
			wire rsp_ready;
		end
		if (1) begin : kmu_bus_if
			wire valid;
			localparam VX_gpu_pkg_NT_BITS = 2;
			localparam VX_gpu_pkg_NW_BITS = 2;
			localparam VX_gpu_pkg_CTA_TID_WIDTH = 4;
			localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
			localparam VX_gpu_pkg_PC_BITS = 32;
			wire [395:0] data;
			wire ready;
		end
		if (1) begin : gbar_bus_if
			wire req_valid;
			localparam VX_gpu_pkg_NB_BITS = 3;
			localparam VX_gpu_pkg_NB_WIDTH = VX_gpu_pkg_NB_BITS;
			localparam VX_gpu_pkg_NC_BITS = 0;
			localparam VX_gpu_pkg_NC_WIDTH = 1;
			wire [4:0] req_data;
			wire req_ready;
			wire rsp_valid;
			wire [2:0] rsp_data;
			wire rsp_ready;
		end
	endgenerate
	localparam _bbase_D1E3E_dcache_bus_if = 0;
	function automatic [11:0] sv2v_cast_12;
		input reg [11:0] inp;
		sv2v_cast_12 = inp;
	endfunction
	function automatic signed [15:0] sv2v_cast_16_signed;
		input reg signed [15:0] inp;
		sv2v_cast_16_signed = inp;
	endfunction
	function automatic [2:0] sv2v_cast_3;
		input reg [2:0] inp;
		sv2v_cast_3 = inp;
	endfunction
	function automatic [4:0] sv2v_cast_5;
		input reg [4:0] inp;
		sv2v_cast_5 = inp;
	endfunction
	function automatic [16:0] sv2v_cast_17;
		input reg [16:0] inp;
		sv2v_cast_17 = inp;
	endfunction
	function automatic signed [16:0] sv2v_cast_17_signed;
		input reg signed [16:0] inp;
		sv2v_cast_17_signed = inp;
	endfunction
	function automatic signed [14:0] sv2v_cast_15_signed;
		input reg signed [14:0] inp;
		sv2v_cast_15_signed = inp;
	endfunction
	function automatic [17:0] sv2v_cast_18;
		input reg [17:0] inp;
		sv2v_cast_18 = inp;
	endfunction
	function automatic signed [17:0] sv2v_cast_18_signed;
		input reg signed [17:0] inp;
		sv2v_cast_18_signed = inp;
	endfunction
	function automatic [13:0] sv2v_cast_14;
		input reg [13:0] inp;
		sv2v_cast_14 = inp;
	endfunction
	function automatic [3:0] sv2v_cast_4;
		input reg [3:0] inp;
		sv2v_cast_4 = inp;
	endfunction
	function automatic [31:0] sv2v_cast_32;
		input reg [31:0] inp;
		sv2v_cast_32 = inp;
	endfunction
	function automatic signed [1:0] sv2v_cast_2_signed;
		input reg signed [1:0] inp;
		sv2v_cast_2_signed = inp;
	endfunction
	function automatic signed [2:0] sv2v_cast_C02D6_signed;
		input reg signed [2:0] inp;
		sv2v_cast_C02D6_signed = inp;
	endfunction
	function automatic [5:0] sv2v_cast_6;
		input reg [5:0] inp;
		sv2v_cast_6 = inp;
	endfunction
	function automatic [1:0] sv2v_cast_2;
		input reg [1:0] inp;
		sv2v_cast_2 = inp;
	endfunction
	function automatic [0:0] sv2v_cast_1;
		input reg [0:0] inp;
		sv2v_cast_1 = inp;
	endfunction
	function automatic [43:0] sv2v_cast_44;
		input reg [43:0] inp;
		sv2v_cast_44 = inp;
	endfunction
	function automatic signed [0:0] sv2v_cast_1_signed;
		input reg signed [0:0] inp;
		sv2v_cast_1_signed = inp;
	endfunction
	function automatic signed [2:0] sv2v_cast_3_signed;
		input reg signed [2:0] inp;
		sv2v_cast_3_signed = inp;
	endfunction
	function automatic signed [31:0] sv2v_cast_32_signed;
		input reg signed [31:0] inp;
		sv2v_cast_32_signed = inp;
	endfunction
	function automatic signed [25:0] sv2v_cast_26_signed;
		input reg signed [25:0] inp;
		sv2v_cast_26_signed = inp;
	endfunction
	function automatic [25:0] sv2v_cast_26;
		input reg [25:0] inp;
		sv2v_cast_26 = inp;
	endfunction
	function automatic [9:0] sv2v_cast_10;
		input reg [9:0] inp;
		sv2v_cast_10 = inp;
	endfunction
	generate
		if (1) begin : core
			localparam CORE_ID = 0;
			localparam INSTANCE_ID = "";
			wire clk;
			wire reset;
			localparam VX_gpu_pkg_DCACHE_WORD_SIZE = 16;
			localparam VX_gpu_pkg_XLENB = 4;
			localparam VX_gpu_pkg_LSU_WORD_SIZE = VX_gpu_pkg_XLENB;
			localparam VX_gpu_pkg_DCACHE_CHANNELS = 1;
			localparam VX_gpu_pkg_DCACHE_NUM_REQS = 1;
			localparam _mbase_dcache_bus_if = 0;
			wire busy;
			if (1) begin : schedule_if
				wire valid;
				localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
				localparam VX_gpu_pkg_NCTA_BITS = 2;
				localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
				localparam VX_gpu_pkg_PC_BITS = 32;
				localparam VX_gpu_pkg_UUID_WIDTH = 44;
				wire [83:0] data;
				wire ready;
				wire [3:0] ibuf_pop;
			end
			if (1) begin : fetch_if
				wire valid;
				localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
				localparam VX_gpu_pkg_NCTA_BITS = 2;
				localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
				localparam VX_gpu_pkg_PC_BITS = 32;
				localparam VX_gpu_pkg_UUID_WIDTH = 44;
				wire [115:0] data;
				wire ready;
				wire [3:0] ibuf_pop;
			end
			if (1) begin : decode_if
				wire valid;
				localparam VX_gpu_pkg_XLENB = 4;
				localparam VX_gpu_pkg_XLENB_W = 2;
				localparam VX_gpu_pkg_BYTESEL_BITS = 4;
				localparam VX_gpu_pkg_EX_SFU = 2;
				localparam VX_gpu_pkg_EX_FPU = 3;
				localparam VX_gpu_pkg_EX_TCU = 3;
				localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
				localparam VX_gpu_pkg_EX_BITS = 2;
				localparam VX_gpu_pkg_INST_OP_BITS = 4;
				localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
				localparam VX_gpu_pkg_NCTA_BITS = 2;
				localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
				localparam VX_gpu_pkg_REG_TYPES = 2;
				localparam VX_gpu_pkg_RV_REGS = 32;
				localparam VX_gpu_pkg_NUM_REGS = 64;
				localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
				localparam VX_gpu_pkg_NUM_SRC_OPDS = 3;
				localparam VX_gpu_pkg_NUM_XREGS = 2;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
				localparam VX_gpu_pkg_PC_BITS = 32;
				localparam VX_gpu_pkg_UUID_WIDTH = 44;
				localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
				localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
				localparam VX_gpu_pkg_INST_FMT_BITS = 2;
				localparam VX_gpu_pkg_INST_FRM_BITS = 3;
				wire [150:0] data;
				wire ready;
				wire [3:0] ibuf_pop;
			end
			if (1) begin : sched_csr_if
				localparam VX_gpu_pkg_PERF_CTR_BITS = 44;
				wire [43:0] cycles;
				wire [43:0] instret;
				wire [3:0] active_warps;
				wire [15:0] thread_masks;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
				wire [1:0] csr_rd_wid;
				localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
				localparam VX_gpu_pkg_NCTA_BITS = 2;
				localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
				wire [1:0] csr_rd_cta_id;
				wire [31:0] mscratch;
				localparam VX_gpu_pkg_NT_BITS = 2;
				localparam VX_gpu_pkg_CTA_TID_WIDTH = 4;
				localparam VX_gpu_pkg_PC_BITS = 32;
				wire [341:0] cta_csrs;
				wire [47:0] cta_tid;
				wire csr_wr_valid;
				wire [1:0] csr_wr_wid;
				wire [31:0] csr_wr_data;
				wire [31:0] csr_mstatus;
				wire [31:0] csr_mtvec;
				wire [31:0] csr_mepc;
				wire [31:0] csr_mcause;
				wire [31:0] csr_mtval;
				wire trap_csr_wr_valid;
				wire [11:0] trap_csr_wr_addr;
				wire [31:0] trap_csr_wr_data;
			end
			if (1) begin : decode_sched_if
				wire valid;
				wire unlock;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
				wire [1:0] wid;
			end
			genvar _arr_1C427;
			for (_arr_1C427 = 0; _arr_1C427 <= 0; _arr_1C427 = _arr_1C427 + 1) begin : issue_sched_if
				wire valid;
				localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
				localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
				localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
				wire [1:0] wis;
			end
			if (1) begin : commit_sched_if
				wire [3:0] committed_warps;
			end
			genvar _arr_7F753;
			for (_arr_7F753 = 0; _arr_7F753 <= 0; _arr_7F753 = _arr_7F753 + 1) begin : branch_ctl_if
				wire valid;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
				wire [1:0] wid;
				wire taken;
				localparam VX_gpu_pkg_PC_BITS = 32;
				wire [31:0] dest;
				wire is_trap;
				wire is_mret;
				wire [3:0] trap_cause;
			end
			if (1) begin : warp_ctl_if
				wire wspawn_valid;
				wire tmc_valid;
				wire split_valid;
				wire sjoin_valid;
				wire bar_valid;
				wire wsync_valid;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
				wire [1:0] wid;
				wire [3:0] tmc;
				localparam VX_gpu_pkg_PC_BITS = 32;
				wire [35:0] wspawn;
				wire [40:0] split;
				localparam VX_gpu_pkg_DV_STACK_SIZE = 3;
				localparam VX_gpu_pkg_DV_STACK_SIZEW = 2;
				wire [5:0] sjoin;
				localparam VX_gpu_pkg_NC_BITS = 0;
				localparam VX_gpu_pkg_NC_WIDTH = 1;
				localparam VX_gpu_pkg_BAR_SIZE_W = 5;
				localparam VX_gpu_pkg_NB_BITS = 3;
				localparam VX_gpu_pkg_NB_WIDTH = VX_gpu_pkg_NB_BITS;
				wire [12:0] bar;
				wire [3:0] warp_pending_alm_empty;
				wire lsu_sched_drained;
				wire [1:0] dvstack_wid;
				wire [1:0] dvstack_ptr;
				localparam VX_gpu_pkg_BAR_ADDR_BITS = 5;
				localparam VX_gpu_pkg_BAR_ADDR_W = VX_gpu_pkg_BAR_ADDR_BITS;
				wire [4:0] bar_addr;
				wire bar_phase;
			end
			localparam VX_gpu_pkg_EX_SFU = 2;
			localparam VX_gpu_pkg_EX_FPU = 3;
			localparam VX_gpu_pkg_EX_TCU = 3;
			localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
			genvar _arr_F8EC5;
			for (_arr_F8EC5 = 0; _arr_F8EC5 <= 3; _arr_F8EC5 = _arr_F8EC5 + 1) begin : dispatch_if
				wire valid;
				localparam VX_gpu_pkg_XLENB = 4;
				localparam VX_gpu_pkg_XLENB_W = 2;
				localparam VX_gpu_pkg_BYTESEL_BITS = 4;
				localparam VX_gpu_pkg_INST_OP_BITS = 4;
				localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
				localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
				localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
				localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
				localparam VX_gpu_pkg_NCTA_BITS = 2;
				localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
				localparam VX_gpu_pkg_REG_TYPES = 2;
				localparam VX_gpu_pkg_RV_REGS = 32;
				localparam VX_gpu_pkg_NUM_REGS = 64;
				localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
				localparam VX_gpu_pkg_NUM_XREGS = 2;
				localparam VX_gpu_pkg_PC_BITS = 32;
				localparam VX_gpu_pkg_SIMD_COUNT = 1;
				localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
				localparam VX_gpu_pkg_SIMD_IDX_W = 1;
				localparam VX_gpu_pkg_UUID_WIDTH = 44;
				localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
				localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
				localparam VX_gpu_pkg_INST_FMT_BITS = 2;
				localparam VX_gpu_pkg_INST_FRM_BITS = 3;
				wire [512:0] data;
				wire ready;
			end
			genvar _arr_C42BE;
			for (_arr_C42BE = 0; _arr_C42BE <= 3; _arr_C42BE = _arr_C42BE + 1) begin : commit_if
				wire valid;
				localparam VX_gpu_pkg_XLENB = 4;
				localparam VX_gpu_pkg_XLENB_W = 2;
				localparam VX_gpu_pkg_BYTESEL_BITS = 4;
				localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
				localparam VX_gpu_pkg_NCTA_BITS = 2;
				localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
				localparam VX_gpu_pkg_REG_TYPES = 2;
				localparam VX_gpu_pkg_RV_REGS = 32;
				localparam VX_gpu_pkg_NUM_REGS = 64;
				localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
				localparam VX_gpu_pkg_NUM_XREGS = 2;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
				localparam VX_gpu_pkg_PC_BITS = 32;
				localparam VX_gpu_pkg_SIMD_COUNT = 1;
				localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
				localparam VX_gpu_pkg_SIMD_IDX_W = 1;
				localparam VX_gpu_pkg_UUID_WIDTH = 44;
				wire [227:0] data;
				wire ready;
			end
			genvar _arr_DBD45;
			for (_arr_DBD45 = 0; _arr_DBD45 <= 0; _arr_DBD45 = _arr_DBD45 + 1) begin : writeback_if
				wire valid;
				localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
				localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
				localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
				localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
				localparam VX_gpu_pkg_NCTA_BITS = 2;
				localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
				localparam VX_gpu_pkg_REG_TYPES = 2;
				localparam VX_gpu_pkg_RV_REGS = 32;
				localparam VX_gpu_pkg_NUM_REGS = 64;
				localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
				localparam VX_gpu_pkg_NUM_XREGS = 2;
				localparam VX_gpu_pkg_PC_BITS = 32;
				localparam VX_gpu_pkg_SIMD_COUNT = 1;
				localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
				localparam VX_gpu_pkg_SIMD_IDX_W = 1;
				localparam VX_gpu_pkg_UUID_WIDTH = 44;
				localparam VX_gpu_pkg_XLENB = 4;
				wire [239:0] data;
			end
			localparam VX_gpu_pkg_LSU_MEM_BATCHES = 1;
			localparam VX_gpu_pkg_LSU_TAG_ID_BITS = 1;
			localparam VX_gpu_pkg_UUID_WIDTH = 44;
			localparam VX_gpu_pkg_LSU_TAG_WIDTH = 45;
			localparam _param_D2283_NUM_LANES = 4;
			localparam _param_D2283_DATA_SIZE = VX_gpu_pkg_LSU_WORD_SIZE;
			localparam _param_D2283_TAG_WIDTH = VX_gpu_pkg_LSU_TAG_WIDTH;
			genvar _arr_D2283;
			for (_arr_D2283 = 0; _arr_D2283 <= 0; _arr_D2283 = _arr_D2283 + 1) begin : lsu_mem_if
				localparam NUM_LANES = _param_D2283_NUM_LANES;
				localparam DATA_SIZE = _param_D2283_DATA_SIZE;
				localparam TAG_WIDTH = _param_D2283_TAG_WIDTH;
				localparam VX_gpu_pkg_NC_BITS = 0;
				localparam VX_gpu_pkg_NT_BITS = 2;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_HART_ID_BITS = 4;
				localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
				localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
				localparam USER_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
				localparam ADDR_WIDTH = 30;
				localparam VX_gpu_pkg_UUID_WIDTH = 44;
				wire req_valid;
				wire [365:0] req_data;
				wire req_ready;
				wire rsp_valid;
				wire [176:0] rsp_data;
				wire rsp_ready;
			end
			genvar _arr_74E75;
			for (_arr_74E75 = 0; _arr_74E75 <= 0; _arr_74E75 = _arr_74E75 + 1) begin : lsu_client_if
				wire req_valid;
				localparam VX_gpu_pkg_XLENB = 4;
				localparam VX_gpu_pkg_LSU_WORD_SIZE = VX_gpu_pkg_XLENB;
				localparam VX_gpu_pkg_LSU_ADDR_WIDTH = 30;
				localparam VX_gpu_pkg_INST_LSU_BITS = 4;
				localparam VX_gpu_pkg_XLENB_W = 2;
				localparam VX_gpu_pkg_BYTESEL_BITS = 4;
				localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
				localparam VX_gpu_pkg_NCTA_BITS = 2;
				localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
				localparam VX_gpu_pkg_REG_TYPES = 2;
				localparam VX_gpu_pkg_RV_REGS = 32;
				localparam VX_gpu_pkg_NUM_REGS = 64;
				localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
				localparam VX_gpu_pkg_NUM_XREGS = 2;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
				localparam VX_gpu_pkg_PC_BITS = 32;
				localparam VX_gpu_pkg_UUID_WIDTH = 44;
				localparam VX_gpu_pkg_LSU_CLIENT_TAG_WIDTH = 114;
				localparam VX_gpu_pkg_NC_BITS = 0;
				localparam VX_gpu_pkg_NT_BITS = 2;
				localparam VX_gpu_pkg_HART_ID_BITS = 4;
				localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
				localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
				wire [434:0] req_data;
				wire req_ready;
				wire rsp_valid;
				wire [247:0] rsp_data;
				wire rsp_ready;
			end
			wire [0:0] lsu_sched_empty;
			localparam VX_gpu_pkg_DCACHE_MERGED_REQS = 1;
			localparam VX_gpu_pkg_DCACHE_MEM_BATCHES = 1;
			localparam VX_gpu_pkg_DCACHE_TAG_ID_BITS = 2;
			localparam VX_gpu_pkg_DCACHE_CORE_TAG_WIDTH = 46;
			localparam VX_gpu_pkg_DCACHE_TAG_WIDTH_BASE = 47;
			localparam _param_17854_DATA_SIZE = VX_gpu_pkg_DCACHE_WORD_SIZE;
			localparam _param_17854_TAG_WIDTH = VX_gpu_pkg_DCACHE_TAG_WIDTH_BASE;
			genvar _arr_17854;
			for (_arr_17854 = 0; _arr_17854 <= 0; _arr_17854 = _arr_17854 + 1) begin : mmu_dcache_if
				localparam DATA_SIZE = _param_17854_DATA_SIZE;
				localparam VX_gpu_pkg_NC_BITS = 0;
				localparam VX_gpu_pkg_NT_BITS = 2;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_HART_ID_BITS = 4;
				localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
				localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
				localparam ATTR_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
				localparam VX_gpu_pkg_UUID_WIDTH = 44;
				localparam TAG_WIDTH = _param_17854_TAG_WIDTH;
				localparam ADDR_WIDTH = 28;
				wire req_valid;
				wire [232:0] req_data;
				wire req_ready;
				wire rsp_valid;
				wire [174:0] rsp_data;
				wire rsp_ready;
			end
			localparam VX_gpu_pkg_NW_BITS = 2;
			localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
			localparam VX_gpu_pkg_ICACHE_TAG_ID_BITS = VX_gpu_pkg_NW_WIDTH;
			localparam VX_gpu_pkg_ICACHE_FETCH_TAG_WIDTH = 46;
			localparam VX_gpu_pkg_ICACHE_WORD_SIZE = 4;
			localparam _param_4C937_DATA_SIZE = VX_gpu_pkg_ICACHE_WORD_SIZE;
			localparam _param_4C937_TAG_WIDTH = VX_gpu_pkg_ICACHE_FETCH_TAG_WIDTH;
			genvar _arr_4C937;
			for (_arr_4C937 = 0; _arr_4C937 <= 0; _arr_4C937 = _arr_4C937 + 1) begin : fetch_icache_if
				localparam DATA_SIZE = _param_4C937_DATA_SIZE;
				localparam VX_gpu_pkg_NC_BITS = 0;
				localparam VX_gpu_pkg_NT_BITS = 2;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_HART_ID_BITS = 4;
				localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
				localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
				localparam ATTR_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
				localparam VX_gpu_pkg_UUID_WIDTH = 44;
				localparam TAG_WIDTH = _param_4C937_TAG_WIDTH;
				localparam ADDR_WIDTH = 30;
				wire req_valid;
				wire [125:0] req_data;
				wire req_ready;
				wire rsp_valid;
				wire [77:0] rsp_data;
				wire rsp_ready;
			end
			localparam VX_gpu_pkg_ICACHE_TAG_WIDTH_BASE = 47;
			localparam _param_A5C94_DATA_SIZE = VX_gpu_pkg_ICACHE_WORD_SIZE;
			localparam _param_A5C94_TAG_WIDTH = VX_gpu_pkg_ICACHE_TAG_WIDTH_BASE;
			genvar _arr_A5C94;
			for (_arr_A5C94 = 0; _arr_A5C94 <= 0; _arr_A5C94 = _arr_A5C94 + 1) begin : mmu_icache_if
				localparam DATA_SIZE = _param_A5C94_DATA_SIZE;
				localparam VX_gpu_pkg_NC_BITS = 0;
				localparam VX_gpu_pkg_NT_BITS = 2;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_HART_ID_BITS = 4;
				localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
				localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
				localparam ATTR_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
				localparam VX_gpu_pkg_UUID_WIDTH = 44;
				localparam TAG_WIDTH = _param_A5C94_TAG_WIDTH;
				localparam ADDR_WIDTH = 30;
				wire req_valid;
				wire [126:0] req_data;
				wire req_ready;
				wire rsp_valid;
				wire [78:0] rsp_data;
				wire rsp_ready;
			end
			if (1) begin : dcr_csr_if
				wire valid;
				wire [11:0] addr;
				wire [7:0] mpm_class;
				localparam VX_gpu_pkg_VX_DCR_DATA_WIDTH = 32;
				wire [31:0] value;
				wire ready;
			end
			if (1) begin : dcr_flush_if
				wire req;
				wire done;
			end
			if (1) begin : dcr_flush_dcache_if
				wire req;
				wire done;
			end
			if (1) begin : dcr_flush_icache_if
				wire req;
				wire done;
			end
			assign dcr_flush_dcache_if.req = dcr_flush_if.req;
			assign dcr_flush_icache_if.req = dcr_flush_if.req;
			assign dcr_flush_if.done = dcr_flush_dcache_if.done & dcr_flush_icache_if.done;
			wire dcr_busy;
			localparam _param_8BD24_INSTANCE_ID = "";
			localparam _param_8BD24_CORE_ID = CORE_ID;
			if (1) begin : dcr_data
				localparam INSTANCE_ID = _param_8BD24_INSTANCE_ID;
				localparam CORE_ID = _param_8BD24_CORE_ID;
				wire clk;
				wire reset;
				wire dcr_busy;
				wire [7:0] mpm_class = vortex_core_wrap.dcr_bus_if.req_data[22+:8];
				wire [5:0] mpm_tag_idx = vortex_core_wrap.dcr_bus_if.req_data[16+:6];
				wire [15:0] mpm_target_cid = vortex_core_wrap.dcr_bus_if.req_data[0+:16];
				wire [11:0] mpm_csr_addr = (mpm_tag_idx[5] ? 12'hb80 + sv2v_cast_12(mpm_tag_idx[4:0]) : 12'hb00 + sv2v_cast_12(mpm_tag_idx[4:0]));
				reg dcr_csr_pending_r;
				reg [11:0] dcr_csr_addr_r;
				wire is_mpm_read = (((vortex_core_wrap.dcr_bus_if.req_valid && ~vortex_core_wrap.dcr_bus_if.req_data[44]) && (vortex_core_wrap.dcr_bus_if.req_data[43-:12] == 12'h001)) && (mpm_target_cid == sv2v_cast_16_signed(CORE_ID))) && ~dcr_csr_pending_r;
				always @(posedge clk)
					if (reset) begin
						dcr_csr_pending_r <= 1'b0;
						dcr_csr_addr_r <= 1'sb0;
					end
					else if (is_mpm_read) begin
						dcr_csr_pending_r <= 1'b1;
						dcr_csr_addr_r <= mpm_csr_addr;
					end
					else if (vortex_core_wrap.core.dcr_csr_if.ready)
						dcr_csr_pending_r <= 1'b0;
				assign vortex_core_wrap.core.dcr_csr_if.valid = dcr_csr_pending_r;
				assign vortex_core_wrap.core.dcr_csr_if.addr = dcr_csr_addr_r;
				assign vortex_core_wrap.core.dcr_csr_if.mpm_class = mpm_class;
				wire dcr_csr_if_fire = vortex_core_wrap.core.dcr_csr_if.valid && vortex_core_wrap.core.dcr_csr_if.ready;
				reg flush_pending_r;
				wire is_flush_read = (((vortex_core_wrap.dcr_bus_if.req_valid && ~vortex_core_wrap.dcr_bus_if.req_data[44]) && (vortex_core_wrap.dcr_bus_if.req_data[43-:12] == 12'h000)) && (mpm_target_cid == sv2v_cast_16_signed(CORE_ID))) && ~flush_pending_r;
				always @(posedge clk)
					if (reset)
						flush_pending_r <= 1'b0;
					else if (is_flush_read)
						flush_pending_r <= 1'b1;
					else if (vortex_core_wrap.core.dcr_flush_if.done)
						flush_pending_r <= 1'b0;
				assign vortex_core_wrap.core.dcr_flush_if.req = flush_pending_r;
				wire flush_done = flush_pending_r && vortex_core_wrap.core.dcr_flush_if.done;
				reg rsp_valid_r;
				localparam VX_gpu_pkg_VX_DCR_DATA_WIDTH = 32;
				reg [31:0] rsp_data_r;
				always @(posedge clk)
					if (reset) begin
						rsp_valid_r <= 1'b0;
						rsp_data_r <= 1'sb0;
					end
					else begin
						rsp_valid_r <= dcr_csr_if_fire || flush_done;
						if (dcr_csr_if_fire)
							rsp_data_r <= vortex_core_wrap.core.dcr_csr_if.value;
						else if (flush_done)
							rsp_data_r <= 1'sb0;
					end
				assign vortex_core_wrap.dcr_bus_if.rsp_valid = rsp_valid_r;
				assign vortex_core_wrap.dcr_bus_if.rsp_data = rsp_data_r;
				assign dcr_busy = (dcr_csr_pending_r || flush_pending_r) || rsp_valid_r;
			end
			assign dcr_data.clk = clk;
			assign dcr_data.reset = reset;
			assign dcr_busy = dcr_data.dcr_busy;
			wire sched_busy;
			localparam _bbase_2A783_branch_ctl_if = 0;
			localparam _bbase_2A783_issue_sched_if = 0;
			localparam _param_2A783_INSTANCE_ID = "";
			localparam _param_2A783_CORE_ID = CORE_ID;
			if (1) begin : scheduler
				localparam INSTANCE_ID = _param_2A783_INSTANCE_ID;
				localparam CORE_ID = _param_2A783_CORE_ID;
				wire clk;
				wire reset;
				localparam _mbase_branch_ctl_if = 0;
				localparam _mbase_issue_sched_if = 0;
				wire busy;
				reg [3:0] active_warps;
				reg [3:0] active_warps_n;
				reg [3:0] stalled_warps;
				reg [3:0] stalled_warps_n;
				reg [15:0] thread_masks;
				reg [15:0] thread_masks_n;
				localparam VX_gpu_pkg_PC_BITS = 32;
				reg [127:0] warp_pcs;
				reg [127:0] warp_pcs_n;
				reg [127:0] mscratch_r;
				localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
				localparam VX_gpu_pkg_NCTA_BITS = 2;
				localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
				reg [7:0] cta_id_per_warp_r;
				reg [127:0] mstatus_r;
				reg [127:0] mtvec_r;
				reg [127:0] mepc_r;
				reg [127:0] mcause_r;
				reg [127:0] mtval_r;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
				wire [1:0] schedule_wid;
				wire [3:0] schedule_tmask;
				wire [31:0] schedule_pc;
				wire schedule_valid;
				wire schedule_ready;
				wire cta_fire;
				wire [1:0] cta_wid;
				wire [31:0] cta_PC;
				wire [3:0] cta_tmask;
				localparam VX_gpu_pkg_NT_BITS = 2;
				localparam VX_gpu_pkg_CTA_TID_WIDTH = 4;
				wire [341:0] cta_csrs;
				wire [11:0] cta_base_tid;
				wire cta_dispatcher_busy;
				wire cta_init;
				wire cta_ctx_write;
				wire [1:0] cta_ctx_waddr;
				wire [337:0] cta_ctx_wdata;
				wire [1:0] cta_ctx_raddr;
				wire [337:0] cta_ctx_rdata;
				VX_dp_ram #(
					.DATAW(338),
					.SIZE(VX_gpu_pkg_NUM_CTA_MAX),
					.RDW_MODE("R"),
					.RADDR_REG(1)
				) cta_ctx_ram(
					.clk(clk),
					.reset(reset),
					.read(1'b1),
					.write(cta_ctx_write),
					.wren(1'b1),
					.waddr(cta_ctx_waddr),
					.wdata(cta_ctx_wdata),
					.raddr(cta_ctx_raddr),
					.rdata(cta_ctx_rdata)
				);
				wire cta_warp_write;
				wire [1:0] cta_warp_waddr;
				wire [49:0] cta_warp_wdata;
				wire [1:0] cta_warp_raddr;
				wire [49:0] cta_warp_rdata;
				VX_dp_ram #(
					.DATAW(50),
					.SIZE(4),
					.RDW_MODE("R"),
					.RADDR_REG(1)
				) cta_warp_ram(
					.clk(clk),
					.reset(reset),
					.read(1'b1),
					.write(cta_warp_write),
					.wren(1'b1),
					.waddr(cta_warp_waddr),
					.wdata(cta_warp_wdata),
					.raddr(cta_warp_raddr),
					.rdata(cta_warp_rdata)
				);
				wire cta_warp_done = vortex_core_wrap.core.warp_ctl_if.tmc_valid && (vortex_core_wrap.core.warp_ctl_if.tmc[3-:4] == 0);
				localparam _param_47DEB_INSTANCE_ID = "";
				if (1) begin : cta_dispatcher
					localparam INSTANCE_ID = _param_47DEB_INSTANCE_ID;
					wire clk;
					wire reset;
					wire [3:0] active_warps;
					wire warp_done;
					localparam VX_gpu_pkg_NW_BITS = 2;
					localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
					wire [1:0] warp_done_wid;
					wire cta_fire;
					wire [1:0] cta_wid;
					localparam VX_gpu_pkg_PC_BITS = 32;
					wire [31:0] cta_PC;
					localparam VX_gpu_pkg_NT_BITS = 2;
					localparam VX_gpu_pkg_CTA_TID_WIDTH = 4;
					wire [11:0] cta_base_tid;
					wire [3:0] cta_tmask;
					localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
					localparam VX_gpu_pkg_NCTA_BITS = 2;
					localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
					wire [341:0] cta_csrs;
					wire cta_init;
					wire busy;
					localparam NUM_CTA_SLOTS = 4;
					localparam CS_BITS = VX_gpu_pkg_NW_WIDTH;
					localparam LMEM_SIZE = 16384;
					wire rem_warps_read;
					wire rem_warps_write;
					wire [1:0] rem_warps_waddr;
					wire [VX_gpu_pkg_NW_WIDTH:0] rem_warps_wdata;
					wire [1:0] rem_warps_raddr;
					wire [VX_gpu_pkg_NW_WIDTH:0] rem_warps_rdata;
					wire lmem_size_read;
					wire lmem_size_write;
					wire [1:0] lmem_size_waddr;
					wire [14:0] lmem_size_wdata;
					wire [1:0] lmem_size_raddr;
					wire [14:0] lmem_size_rdata;
					VX_dp_ram #(
						.DATAW(3),
						.SIZE(NUM_CTA_SLOTS),
						.RDW_MODE("R"),
						.OUT_REG(1)
					) rem_warps_ram(
						.clk(clk),
						.reset(reset),
						.wren(1'b1),
						.read(rem_warps_read),
						.write(rem_warps_write),
						.waddr(rem_warps_waddr),
						.wdata(rem_warps_wdata),
						.raddr(rem_warps_raddr),
						.rdata(rem_warps_rdata)
					);
					VX_dp_ram #(
						.DATAW(15),
						.SIZE(NUM_CTA_SLOTS),
						.RDW_MODE("R"),
						.OUT_REG(1)
					) lmem_size_ram(
						.clk(clk),
						.reset(reset),
						.wren(1'b1),
						.read(lmem_size_read),
						.write(lmem_size_write),
						.waddr(lmem_size_waddr),
						.wdata(lmem_size_wdata),
						.raddr(lmem_size_raddr),
						.rdata(lmem_size_rdata)
					);
					reg [3:0] slot_valid_r;
					reg [1:0] head_r;
					reg [1:0] tail_r;
					reg [13:0] lmem_tail_r;
					reg [14:0] free_size_r;
					reg [13:0] cur_lmem_base_r;
					reg [7:0] cta_slot_per_warp_r;
					wire [1:0] done_slot = cta_slot_per_warp_r[warp_done_wid * 2+:2];
					reg warp_done_r;
					reg warp_done_r_dly;
					reg [1:0] done_slot_r;
					reg [1:0] done_slot_r_dly;
					reg [7:0] cur_ctx_id_r;
					reg [3:0] warp_init_mask_r;
					reg warp_skip_init_r;
					reg state;
					reg [31:0] warp_PC;
					reg [31:0] entry_r;
					reg [95:0] block_idx_r;
					reg [14:0] block_dim_r;
					reg [95:0] grid_dim_r;
					reg [31:0] param_r;
					reg [VX_gpu_pkg_CTA_TID_WIDTH:0] block_size_r;
					reg [11:0] warp_step_r;
					reg [VX_gpu_pkg_NW_WIDTH:0] cluster_size_r;
					reg warp_fire_r;
					reg [1:0] warp_id_r;
					reg [3:0] warp_tmask_r;
					reg [1:0] cta_rank_r;
					reg [11:0] thread_idx_r;
					reg [1:0] cur_slot_r;
					reg [3:0] dispatched_warps;
					wire [1:0] warp_id_n;
					wire warp_ready;
					VX_priority_encoder #(
						.N(4),
						.REVERSE(0)
					) priority_enc(
						.data_in(~(active_warps | dispatched_warps)),
						.onehot_out(),
						.index_out(warp_id_n),
						.valid_out(warp_ready)
					);
					wire kmu_bus_if_fire = vortex_core_wrap.kmu_bus_if.valid && vortex_core_wrap.kmu_bus_if.ready;
					wire [VX_gpu_pkg_NW_WIDTH:0] cta_num_warps;
					wire [VX_gpu_pkg_NW_WIDTH:0] kmu_num_warps;
					wire [VX_gpu_pkg_CTA_TID_WIDTH:0] block_size_next;
					wire [3:0] partial_tmask;
					if (1) begin : g_nt_nonzero
						assign cta_num_warps = sv2v_cast_3(block_size_r[VX_gpu_pkg_CTA_TID_WIDTH:VX_gpu_pkg_NT_BITS]) + sv2v_cast_3(|block_size_r[1:0]);
						assign kmu_num_warps = sv2v_cast_3(vortex_core_wrap.kmu_bus_if.data[37:35]) + sv2v_cast_3(|vortex_core_wrap.kmu_bus_if.data[34:33]);
						assign block_size_next = {block_size_r[VX_gpu_pkg_CTA_TID_WIDTH:VX_gpu_pkg_NT_BITS] - 1'b1, block_size_r[1:0]};
						assign partial_tmask = (4'sd1 << block_size_r[1:0]) - 4'sd1;
					end
					wire is_full_warp = |block_size_r[VX_gpu_pkg_CTA_TID_WIDTH:VX_gpu_pkg_NT_BITS];
					wire is_last_warp = cta_num_warps == 3'sd1;
					wire [VX_gpu_pkg_CTA_TID_WIDTH:0] next_x = {1'b0, thread_idx_r[0+:4]} + {1'b0, warp_step_r[0+:4]};
					wire wrap_x = next_x >= {1'b0, block_dim_r[3-:4]};
					wire [VX_gpu_pkg_CTA_TID_WIDTH:0] next_y = ({1'b0, thread_idx_r[4+:4]} + {1'b0, warp_step_r[4+:4]}) + sv2v_cast_5(wrap_x);
					wire wrap_y = next_y >= {1'b0, block_dim_r[8-:4]};
					reg rem_warps_write_r;
					reg [1:0] rem_warps_waddr_r;
					reg [VX_gpu_pkg_NW_WIDTH:0] rem_warps_wdata_r;
					reg rem_warps_write_rr;
					reg [1:0] rem_warps_waddr_rr;
					reg [VX_gpu_pkg_NW_WIDTH:0] rem_warps_wdata_rr;
					wire [VX_gpu_pkg_NW_WIDTH:0] rem_warps_rdata_fwd = (rem_warps_write_r && (rem_warps_waddr_r == done_slot_r_dly) ? rem_warps_wdata_r : (rem_warps_write_rr && (rem_warps_waddr_rr == done_slot_r_dly) ? rem_warps_wdata_rr : rem_warps_rdata));
					wire cta_done = (warp_done_r_dly && slot_valid_r[done_slot_r_dly]) && (rem_warps_rdata_fwd == 3'sd1);
					wire head_reclaimable_s1 = (head_r != tail_r) && !slot_valid_r[head_r];
					reg head_reclaimable_dly;
					localparam LMEM_LOG = 14;
					localparam SPAN_W = 17;
					wire [LMEM_LOG:0] aligned_lmem_size = vortex_core_wrap.kmu_bus_if.data[52-:15];
					wire is_first_of_cluster = vortex_core_wrap.kmu_bus_if.data[0];
					wire [16:0] aligned_lmem_size_w = sv2v_cast_17(aligned_lmem_size);
					wire [16:0] eff_span = (is_first_of_cluster ? sv2v_cast_17(vortex_core_wrap.kmu_bus_if.data[17-:17]) : aligned_lmem_size_w);
					wire [16:0] lmem_wrap_threshold = sv2v_cast_17_signed(LMEM_SIZE) - eff_span;
					wire lmem_span_wraps = sv2v_cast_17({1'b0, lmem_tail_r}) >= lmem_wrap_threshold;
					wire lmem_alloc_wraps = is_first_of_cluster && lmem_span_wraps;
					wire [LMEM_LOG:0] lmem_padding = (lmem_alloc_wraps ? sv2v_cast_15_signed(LMEM_SIZE) - {1'b0, lmem_tail_r} : 15'sd0);
					wire [LMEM_LOG:0] lmem_total_cost = aligned_lmem_size + lmem_padding;
					wire [SPAN_W:0] eff_span_plus_size = sv2v_cast_18(eff_span) + sv2v_cast_18_signed(LMEM_SIZE);
					wire [SPAN_W:0] lmem_admit_cost = (lmem_alloc_wraps ? eff_span_plus_size - sv2v_cast_18({1'b0, lmem_tail_r}) : sv2v_cast_18(eff_span));
					wire table_notfull = ~slot_valid_r[tail_r];
					wire lmem_ok = sv2v_cast_18({1'b0, free_size_r}) >= lmem_admit_cost;
					assign vortex_core_wrap.kmu_bus_if.ready = (((state == 1'd0) && table_notfull) && lmem_ok) && !rem_warps_write_r;
					wire [LMEM_LOG:0] lmem_next_tail = (lmem_alloc_wraps ? aligned_lmem_size : {1'b0, lmem_tail_r} + aligned_lmem_size);
					assign rem_warps_read = warp_done_r;
					assign rem_warps_raddr = done_slot_r;
					assign rem_warps_write = (kmu_bus_if_fire && (state == 1'd0)) || rem_warps_write_r;
					assign rem_warps_waddr = (kmu_bus_if_fire && (state == 1'd0) ? tail_r : rem_warps_waddr_r);
					assign rem_warps_wdata = (kmu_bus_if_fire && (state == 1'd0) ? sv2v_cast_3(kmu_num_warps) : rem_warps_wdata_r);
					assign lmem_size_read = head_reclaimable_s1 || (cta_done && (done_slot_r_dly == head_r));
					assign lmem_size_raddr = head_r;
					assign lmem_size_write = kmu_bus_if_fire && (state == 1'd0);
					assign lmem_size_waddr = tail_r;
					assign lmem_size_wdata = lmem_total_cost;
					always @(posedge clk)
						if (reset) begin
							state <= 1'd0;
							warp_fire_r <= 0;
							warp_id_r <= 1'sb0;
							warp_tmask_r <= 1'sb0;
							cur_ctx_id_r <= 1'sb0;
							warp_init_mask_r <= 1'sb0;
							warp_skip_init_r <= 0;
							head_r <= 1'sb0;
							tail_r <= 1'sb0;
							lmem_tail_r <= 1'sb0;
							cur_lmem_base_r <= 1'sb0;
							free_size_r <= sv2v_cast_15_signed(LMEM_SIZE);
							slot_valid_r <= 1'sb0;
							dispatched_warps <= 1'sb0;
							warp_done_r <= 0;
							warp_done_r_dly <= 0;
							done_slot_r <= 1'sb0;
							done_slot_r_dly <= 1'sb0;
							cur_slot_r <= 1'sb0;
							cluster_size_r <= 3'sd1;
							rem_warps_waddr_r <= 1'sb0;
							rem_warps_wdata_r <= 1'sb0;
							rem_warps_write_r <= 0;
							rem_warps_waddr_rr <= 1'sb0;
							rem_warps_wdata_rr <= 1'sb0;
							rem_warps_write_rr <= 0;
							head_reclaimable_dly <= 0;
							cta_slot_per_warp_r <= 1'sb0;
						end
						else begin
							warp_done_r <= warp_done;
							warp_done_r_dly <= warp_done_r;
							if (warp_done)
								done_slot_r <= done_slot;
							done_slot_r_dly <= done_slot_r;
							if ((state == 1'd1) && warp_ready)
								cta_slot_per_warp_r[warp_id_n * 2+:2] <= cur_slot_r;
							rem_warps_write_rr <= rem_warps_write_r;
							rem_warps_waddr_rr <= rem_warps_waddr_r;
							rem_warps_wdata_rr <= rem_warps_wdata_r;
							if (warp_done_r_dly && slot_valid_r[done_slot_r_dly]) begin
								rem_warps_waddr_r <= done_slot_r_dly;
								rem_warps_wdata_r <= rem_warps_rdata_fwd - 1;
								rem_warps_write_r <= 1;
								if (cta_done)
									slot_valid_r[done_slot_r_dly] <= 1'b0;
							end
							else
								rem_warps_write_r <= 0;
							head_reclaimable_dly <= head_reclaimable_s1 || (cta_done && (done_slot_r_dly == head_r));
							if (head_reclaimable_s1 || (cta_done && (done_slot_r_dly == head_r)))
								head_r <= head_r + 2'sd1;
							if (head_reclaimable_dly)
								free_size_r <= (free_size_r + lmem_size_rdata) - (kmu_bus_if_fire ? lmem_total_cost : {15 {1'sb0}});
							else if (kmu_bus_if_fire)
								free_size_r <= free_size_r - lmem_total_cost;
							case (state)
								1'd0:
									if (kmu_bus_if_fire) begin
										if (vortex_core_wrap.kmu_bus_if.data[331-:8] != cur_ctx_id_r) begin
											cur_ctx_id_r <= vortex_core_wrap.kmu_bus_if.data[331-:8];
											warp_init_mask_r <= 1'sb0;
										end
										warp_PC <= vortex_core_wrap.kmu_bus_if.data[395-:32];
										entry_r <= vortex_core_wrap.kmu_bus_if.data[363-:32];
										block_idx_r <= vortex_core_wrap.kmu_bus_if.data[291-:96];
										block_dim_r <= vortex_core_wrap.kmu_bus_if.data[195-:15];
										grid_dim_r <= vortex_core_wrap.kmu_bus_if.data[180-:96];
										param_r <= vortex_core_wrap.kmu_bus_if.data[84-:32];
										block_size_r <= vortex_core_wrap.kmu_bus_if.data[37-:5];
										warp_step_r <= vortex_core_wrap.kmu_bus_if.data[32-:12];
										cluster_size_r <= vortex_core_wrap.kmu_bus_if.data[20-:3];
										cta_rank_r <= 1'sb0;
										thread_idx_r <= 1'sb0;
										cur_lmem_base_r <= (lmem_alloc_wraps ? {14 {1'sb0}} : lmem_tail_r);
										lmem_tail_r <= (lmem_alloc_wraps ? sv2v_cast_14(aligned_lmem_size) : lmem_next_tail[13:0]);
										slot_valid_r[tail_r] <= 1'b1;
										tail_r <= tail_r + 2'sd1;
										cur_slot_r <= tail_r;
										dispatched_warps <= 1'sb0;
										state <= 1'd1;
									end
								1'd1: begin
									if (warp_ready) begin
										warp_fire_r <= 1;
										warp_id_r <= warp_id_n;
										dispatched_warps[warp_id_n] <= 1'b1;
										warp_tmask_r <= (is_full_warp ? {4 {1'b1}} : partial_tmask);
										warp_skip_init_r <= warp_init_mask_r[warp_id_n];
									end
									else
										warp_fire_r <= 0;
									if (warp_fire_r) begin
										cta_rank_r <= cta_rank_r + 2'sd1;
										block_size_r <= block_size_next;
										warp_init_mask_r[warp_id_r] <= 1'b1;
										thread_idx_r[0+:4] <= (wrap_x ? sv2v_cast_4(next_x - {1'b0, block_dim_r[3-:4]}) : sv2v_cast_4(next_x));
										thread_idx_r[4+:4] <= (wrap_y ? sv2v_cast_4(next_y - {1'b0, block_dim_r[8-:4]}) : sv2v_cast_4(next_y));
										thread_idx_r[8+:4] <= (thread_idx_r[8+:4] + warp_step_r[8+:4]) + sv2v_cast_4(wrap_y);
										if (is_last_warp) begin
											warp_fire_r <= 0;
											state <= 1'd0;
										end
									end
								end
							endcase
						end
					assign cta_fire = warp_fire_r;
					assign cta_wid = warp_id_r;
					assign cta_PC = warp_PC;
					assign cta_tmask = warp_tmask_r;
					assign cta_init = ~warp_skip_init_r;
					reg [VX_gpu_pkg_NW_WIDTH:0] cta_size_r;
					always @(posedge clk)
						if (reset)
							cta_size_r <= 1'sb0;
						else if (kmu_bus_if_fire)
							cta_size_r <= sv2v_cast_3(kmu_num_warps);
					assign cta_csrs[341-:2] = cur_slot_r;
					assign cta_csrs[339-:2] = cta_rank_r;
					assign cta_csrs[337-:3] = cta_size_r;
					assign cta_base_tid = thread_idx_r;
					assign cta_csrs[334-:96] = block_idx_r;
					assign cta_csrs[238-:15] = block_dim_r;
					assign cta_csrs[223-:96] = grid_dim_r;
					assign cta_csrs[127-:32] = entry_r;
					assign cta_csrs[95-:32] = param_r;
					assign cta_csrs[63-:32] = 32'hffff0000 | sv2v_cast_32(cur_lmem_base_r);
					assign cta_csrs[31-:32] = sv2v_cast_32(cluster_size_r);
					assign busy = state == 1'd1;
				end
				assign cta_dispatcher.clk = clk;
				assign cta_dispatcher.reset = reset;
				assign cta_dispatcher.active_warps = active_warps;
				assign cta_dispatcher.warp_done = cta_warp_done;
				assign cta_dispatcher.warp_done_wid = vortex_core_wrap.core.warp_ctl_if.wid;
				assign cta_fire = cta_dispatcher.cta_fire;
				assign cta_wid = cta_dispatcher.cta_wid;
				assign cta_PC = cta_dispatcher.cta_PC;
				assign cta_tmask = cta_dispatcher.cta_tmask;
				assign cta_csrs = cta_dispatcher.cta_csrs;
				assign cta_base_tid = cta_dispatcher.cta_base_tid;
				assign cta_init = cta_dispatcher.cta_init;
				assign cta_dispatcher_busy = cta_dispatcher.busy;
				assign vortex_core_wrap.core.sched_csr_if.mscratch = mscratch_r[vortex_core_wrap.core.sched_csr_if.csr_rd_wid * 32+:32];
				assign vortex_core_wrap.core.sched_csr_if.csr_mstatus = mstatus_r[vortex_core_wrap.core.sched_csr_if.csr_rd_wid * 32+:32];
				assign vortex_core_wrap.core.sched_csr_if.csr_mtvec = mtvec_r[vortex_core_wrap.core.sched_csr_if.csr_rd_wid * 32+:32];
				assign vortex_core_wrap.core.sched_csr_if.csr_mepc = mepc_r[vortex_core_wrap.core.sched_csr_if.csr_rd_wid * 32+:32];
				assign vortex_core_wrap.core.sched_csr_if.csr_mcause = mcause_r[vortex_core_wrap.core.sched_csr_if.csr_rd_wid * 32+:32];
				assign vortex_core_wrap.core.sched_csr_if.csr_mtval = mtval_r[vortex_core_wrap.core.sched_csr_if.csr_rd_wid * 32+:32];
				assign cta_warp_write = cta_fire;
				assign cta_warp_waddr = cta_wid;
				assign cta_warp_wdata[49-:2] = cta_csrs[339-:2];
				wire [47:0] cta_tid_w;
				assign cta_tid_w[0+:12] = cta_base_tid;
				genvar _gv_j_8;
				for (_gv_j_8 = 1; _gv_j_8 < 4; _gv_j_8 = _gv_j_8 + 1) begin : g_cta_tid_ripple
					localparam j = _gv_j_8;
					wire [VX_gpu_pkg_CTA_TID_WIDTH:0] nx = {1'b0, cta_tid_w[((j - 1) * 3) * 4+:4]} + 5'sd1;
					wire wrap_x = nx >= {1'b0, cta_csrs[227-:4]};
					wire [VX_gpu_pkg_CTA_TID_WIDTH:0] ny = {1'b0, cta_tid_w[(((j - 1) * 3) + 1) * 4+:4]} + sv2v_cast_5(wrap_x);
					wire wrap_y = wrap_x && (ny >= {1'b0, cta_csrs[232-:4]});
					assign cta_tid_w[(j * 3) * 4+:4] = (wrap_x ? sv2v_cast_4(nx - {1'b0, cta_csrs[227-:4]}) : sv2v_cast_4(nx));
					assign cta_tid_w[((j * 3) + 1) * 4+:4] = (wrap_y ? sv2v_cast_4(ny - {1'b0, cta_csrs[232-:4]}) : sv2v_cast_4(ny));
					assign cta_tid_w[((j * 3) + 2) * 4+:4] = cta_tid_w[(((j - 1) * 3) + 2) * 4+:4] + sv2v_cast_4(wrap_y);
				end
				assign cta_warp_wdata[47-:48] = cta_tid_w;
				assign cta_ctx_write = cta_fire;
				assign cta_ctx_waddr = cta_csrs[341-:2];
				assign cta_ctx_wdata[337-:3] = cta_csrs[337-:3];
				assign cta_ctx_wdata[334-:96] = cta_csrs[334-:96];
				assign cta_ctx_wdata[238-:15] = cta_csrs[238-:15];
				assign cta_ctx_wdata[223-:96] = cta_csrs[223-:96];
				assign cta_ctx_wdata[95-:32] = cta_csrs[95-:32];
				assign cta_ctx_wdata[63-:32] = cta_csrs[63-:32];
				assign cta_ctx_wdata[31-:32] = cta_csrs[31-:32];
				assign cta_ctx_wdata[127-:32] = cta_csrs[127-:32];
				assign cta_warp_raddr = vortex_core_wrap.core.sched_csr_if.csr_rd_wid;
				assign cta_ctx_raddr = vortex_core_wrap.core.sched_csr_if.csr_rd_cta_id;
				assign vortex_core_wrap.core.sched_csr_if.cta_csrs[341-:2] = vortex_core_wrap.core.sched_csr_if.csr_rd_cta_id;
				assign vortex_core_wrap.core.sched_csr_if.cta_csrs[339-:2] = cta_warp_rdata[49-:2];
				assign vortex_core_wrap.core.sched_csr_if.cta_tid = cta_warp_rdata[47-:48];
				assign vortex_core_wrap.core.sched_csr_if.cta_csrs[337-:3] = cta_ctx_rdata[337-:3];
				assign vortex_core_wrap.core.sched_csr_if.cta_csrs[334-:96] = cta_ctx_rdata[334-:96];
				assign vortex_core_wrap.core.sched_csr_if.cta_csrs[238-:15] = cta_ctx_rdata[238-:15];
				assign vortex_core_wrap.core.sched_csr_if.cta_csrs[223-:96] = cta_ctx_rdata[223-:96];
				assign vortex_core_wrap.core.sched_csr_if.cta_csrs[95-:32] = cta_ctx_rdata[95-:32];
				assign vortex_core_wrap.core.sched_csr_if.cta_csrs[63-:32] = cta_ctx_rdata[63-:32];
				assign vortex_core_wrap.core.sched_csr_if.cta_csrs[31-:32] = cta_ctx_rdata[31-:32];
				assign vortex_core_wrap.core.sched_csr_if.cta_csrs[127-:32] = cta_ctx_rdata[127-:32];
				wire join_valid;
				wire join_is_dvg;
				wire join_is_else;
				wire [1:0] join_wid;
				wire [3:0] join_tmask;
				wire [31:0] join_pc;
				localparam VX_gpu_pkg_PERF_CTR_BITS = 44;
				reg [43:0] cycles;
				wire schedule_fire = schedule_valid && schedule_ready;
				wire schedule_if_fire = vortex_core_wrap.core.schedule_if.valid && vortex_core_wrap.core.schedule_if.ready;
				wire [0:0] branch_valid;
				wire [1:0] branch_wid;
				wire [0:0] branch_taken;
				wire [31:0] branch_dest;
				wire [0:0] branch_is_trap;
				wire [0:0] branch_is_mret;
				wire [3:0] branch_trap_cause;
				genvar _gv_i_103;
				for (_gv_i_103 = 0; _gv_i_103 < 1; _gv_i_103 = _gv_i_103 + 1) begin : g_branch_init
					localparam i = _gv_i_103;
					assign branch_valid[i] = vortex_core_wrap.core.branch_ctl_if[i + _mbase_branch_ctl_if].valid;
					assign branch_wid[i * 2+:2] = vortex_core_wrap.core.branch_ctl_if[i + _mbase_branch_ctl_if].wid;
					assign branch_taken[i] = vortex_core_wrap.core.branch_ctl_if[i + _mbase_branch_ctl_if].taken;
					assign branch_dest[i * 32+:32] = vortex_core_wrap.core.branch_ctl_if[i + _mbase_branch_ctl_if].dest;
					assign branch_is_trap[i] = vortex_core_wrap.core.branch_ctl_if[i + _mbase_branch_ctl_if].is_trap;
					assign branch_is_mret[i] = vortex_core_wrap.core.branch_ctl_if[i + _mbase_branch_ctl_if].is_mret;
					assign branch_trap_cause[i * 4+:4] = vortex_core_wrap.core.branch_ctl_if[i + _mbase_branch_ctl_if].trap_cause;
				end
				wire [3:0] bar_unlock_mask;
				wire bar_unlock_valid;
				reg [35:0] wspawn;
				reg wspawn_valid;
				reg [1:0] wspawn_wid;
				reg is_single_warp;
				wire [2:0] active_warps_cnt;
				VX_popcount #(
					.N(4),
					.MODEL(1)
				) __pop_count_ex254(
					.data_in(active_warps),
					.data_out(active_warps_cnt)
				);
				function automatic [31:0] VX_gpu_pkg_from_fullPC;
					input reg [31:0] pc;
					VX_gpu_pkg_from_fullPC = pc;
				endfunction
				always @(*) begin
					active_warps_n = active_warps;
					stalled_warps_n = stalled_warps;
					thread_masks_n = thread_masks;
					warp_pcs_n = warp_pcs;
					if (cta_fire) begin
						active_warps_n[cta_wid] = 1;
						warp_pcs_n[cta_wid * 32+:32] = (cta_init ? cta_PC : warp_pcs[cta_wid * 32+:32] - VX_gpu_pkg_from_fullPC(32'sd20));
						thread_masks_n[cta_wid * 4+:4] = cta_tmask;
					end
					if (vortex_core_wrap.core.decode_sched_if.valid && vortex_core_wrap.core.decode_sched_if.unlock)
						stalled_warps_n[vortex_core_wrap.core.decode_sched_if.wid] = 0;
					if (wspawn_valid && is_single_warp) begin
						active_warps_n = active_warps_n | wspawn[35-:4];
						begin : sv2v_autoblock_1
							integer i;
							for (i = 0; i < 4; i = i + 1)
								if (wspawn[32 + i] && (sv2v_cast_2_signed(i) != wspawn_wid)) begin
									thread_masks_n[i * 4] = 1;
									warp_pcs_n[i * 32+:32] = wspawn[31-:VX_gpu_pkg_PC_BITS];
								end
						end
						stalled_warps_n[wspawn_wid] = 0;
					end
					if (vortex_core_wrap.core.warp_ctl_if.tmc_valid) begin
						active_warps_n[vortex_core_wrap.core.warp_ctl_if.wid] = vortex_core_wrap.core.warp_ctl_if.tmc[3-:4] != 0;
						thread_masks_n[vortex_core_wrap.core.warp_ctl_if.wid * 4+:4] = vortex_core_wrap.core.warp_ctl_if.tmc[3-:4];
						stalled_warps_n[vortex_core_wrap.core.warp_ctl_if.wid] = 0;
					end
					if (vortex_core_wrap.core.warp_ctl_if.split_valid) begin
						if (vortex_core_wrap.core.warp_ctl_if.split[40])
							thread_masks_n[vortex_core_wrap.core.warp_ctl_if.wid * 4+:4] = vortex_core_wrap.core.warp_ctl_if.split[39-:4];
						stalled_warps_n[vortex_core_wrap.core.warp_ctl_if.wid] = 0;
					end
					if (join_valid) begin
						if (join_is_dvg) begin
							if (join_is_else)
								warp_pcs_n[join_wid * 32+:32] = join_pc;
							thread_masks_n[join_wid * 4+:4] = join_tmask;
						end
						stalled_warps_n[join_wid] = 0;
					end
					if (bar_unlock_valid)
						stalled_warps_n = stalled_warps_n & ~bar_unlock_mask;
					if (vortex_core_wrap.core.warp_ctl_if.wsync_valid)
						stalled_warps_n[vortex_core_wrap.core.warp_ctl_if.wid] = 0;
					begin : sv2v_autoblock_2
						integer i;
						for (i = 0; i < 1; i = i + 1)
							if (branch_valid[i]) begin
								if (branch_is_trap[i])
									warp_pcs_n[branch_wid[i * 2+:2] * 32+:32] = VX_gpu_pkg_from_fullPC(mtvec_r[branch_wid[i * 2+:2] * 32+:32] & ~32'sd3);
								else if (branch_is_mret[i])
									warp_pcs_n[branch_wid[i * 2+:2] * 32+:32] = VX_gpu_pkg_from_fullPC(mepc_r[branch_wid[i * 2+:2] * 32+:32]);
								else if (branch_taken[i])
									warp_pcs_n[branch_wid[i * 2+:2] * 32+:32] = branch_dest[i * 32+:32];
								stalled_warps_n[branch_wid[i * 2+:2]] = 0;
							end
					end
					if (schedule_fire)
						stalled_warps_n[schedule_wid] = 1;
					if (schedule_if_fire)
						warp_pcs_n[vortex_core_wrap.core.schedule_if.data[39-:2] * 32+:32] = vortex_core_wrap.core.schedule_if.data[31-:32] + VX_gpu_pkg_from_fullPC(32'sd4);
				end
				function automatic [31:0] VX_gpu_pkg_to_fullPC;
					input reg [31:0] pc;
					VX_gpu_pkg_to_fullPC = pc;
				endfunction
				always @(posedge clk)
					if (reset) begin
						stalled_warps <= 1'sb0;
						warp_pcs <= 1'sb0;
						active_warps <= 1'sb0;
						thread_masks <= 1'sb0;
						cycles <= 1'sb0;
						wspawn_valid <= 0;
						warp_pcs <= 1'sb0;
						active_warps <= 1'sb0;
						thread_masks <= 1'sb0;
						is_single_warp <= 0;
						mscratch_r <= 1'sb0;
						mstatus_r <= 1'sb0;
						mtvec_r <= 1'sb0;
						mepc_r <= 1'sb0;
						mcause_r <= 1'sb0;
						mtval_r <= 1'sb0;
					end
					else begin
						active_warps <= active_warps_n;
						stalled_warps <= stalled_warps_n;
						thread_masks <= thread_masks_n;
						warp_pcs <= warp_pcs_n;
						is_single_warp <= active_warps_cnt == sv2v_cast_C02D6_signed(1);
						if (vortex_core_wrap.core.warp_ctl_if.wspawn_valid) begin
							wspawn_valid <= 1;
							wspawn[35-:4] <= vortex_core_wrap.core.warp_ctl_if.wspawn[35-:4];
							wspawn[31-:VX_gpu_pkg_PC_BITS] <= vortex_core_wrap.core.warp_ctl_if.wspawn[31-:32];
							wspawn_wid <= vortex_core_wrap.core.warp_ctl_if.wid;
						end
						if (wspawn_valid && is_single_warp) begin
							wspawn_valid <= 0;
							begin : sv2v_autoblock_3
								integer i;
								for (i = 0; i < 4; i = i + 1)
									if (wspawn[32 + i] && (sv2v_cast_2_signed(i) != wspawn_wid))
										mscratch_r[i * 32+:32] <= mscratch_r[wspawn_wid * 32+:32];
							end
						end
						if (cta_fire) begin
							mscratch_r[cta_wid * 32+:32] <= cta_csrs[95-:32];
							cta_id_per_warp_r[cta_wid * 2+:2] <= cta_csrs[341-:2];
						end
						if (vortex_core_wrap.core.sched_csr_if.csr_wr_valid)
							mscratch_r[vortex_core_wrap.core.sched_csr_if.csr_wr_wid * 32+:32] <= vortex_core_wrap.core.sched_csr_if.csr_wr_data;
						if (vortex_core_wrap.core.sched_csr_if.trap_csr_wr_valid)
							case (vortex_core_wrap.core.sched_csr_if.trap_csr_wr_addr)
								12'h300: mstatus_r[vortex_core_wrap.core.sched_csr_if.csr_wr_wid * 32+:32] <= vortex_core_wrap.core.sched_csr_if.trap_csr_wr_data;
								12'h305: mtvec_r[vortex_core_wrap.core.sched_csr_if.csr_wr_wid * 32+:32] <= vortex_core_wrap.core.sched_csr_if.trap_csr_wr_data;
								12'h341: mepc_r[vortex_core_wrap.core.sched_csr_if.csr_wr_wid * 32+:32] <= vortex_core_wrap.core.sched_csr_if.trap_csr_wr_data;
								12'h342: mcause_r[vortex_core_wrap.core.sched_csr_if.csr_wr_wid * 32+:32] <= vortex_core_wrap.core.sched_csr_if.trap_csr_wr_data;
								12'h343: mtval_r[vortex_core_wrap.core.sched_csr_if.csr_wr_wid * 32+:32] <= vortex_core_wrap.core.sched_csr_if.trap_csr_wr_data;
								default:
									;
							endcase
						begin : sv2v_autoblock_4
							integer i;
							for (i = 0; i < 1; i = i + 1)
								if (branch_valid[i] && branch_is_trap[i]) begin
									mepc_r[branch_wid[i * 2+:2] * 32+:32] <= VX_gpu_pkg_to_fullPC(branch_dest[i * 32+:32]);
									mcause_r[branch_wid[i * 2+:2] * 32+:32] <= sv2v_cast_32(branch_trap_cause[i * 4+:4]);
									mtval_r[branch_wid[i * 2+:2] * 32+:32] <= 1'sb0;
								end
						end
						if (busy)
							cycles <= cycles + 1;
					end
				localparam _param_C44D9_INSTANCE_ID = "";
				localparam _param_C44D9_CORE_ID = CORE_ID;
				if (1) begin : bar_unit
					localparam INSTANCE_ID = _param_C44D9_INSTANCE_ID;
					localparam CORE_ID = _param_C44D9_CORE_ID;
					wire clk;
					wire reset;
					wire req_valid;
					localparam VX_gpu_pkg_NW_BITS = 2;
					localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
					wire [1:0] req_wid;
					localparam VX_gpu_pkg_NC_BITS = 0;
					localparam VX_gpu_pkg_NC_WIDTH = 1;
					localparam VX_gpu_pkg_BAR_SIZE_W = 5;
					localparam VX_gpu_pkg_NB_BITS = 3;
					localparam VX_gpu_pkg_NB_WIDTH = VX_gpu_pkg_NB_BITS;
					wire [12:0] req_data;
					localparam VX_gpu_pkg_BAR_ADDR_BITS = 5;
					localparam VX_gpu_pkg_BAR_ADDR_W = VX_gpu_pkg_BAR_ADDR_BITS;
					wire [4:0] read_addr;
					wire read_phase;
					wire [3:0] active_warps;
					wire unlock_valid;
					wire [3:0] unlock_mask;
					localparam EVENT_WIDTH = 6;
					localparam BAR_STATEW = 12;
					localparam USE_GBAR = 1'd0;
					wire [3:0] mask_r;
					reg [3:0] mask_n;
					wire [1:0] count_r;
					reg [1:0] count_n;
					wire [5:0] events_r;
					reg [5:0] events_n;
					reg phase_r;
					reg phase_n;
					reg unlock_valid_n;
					reg [3:0] unlock_mask_n;
					reg gbar_req_valid_r;
					reg gbar_req_valid_n;
					reg [2:0] gbar_req_id_r;
					reg [2:0] gbar_req_id_n;
					reg [0:0] gbar_req_size_m1_r;
					reg [0:0] gbar_req_size_m1_n;
					wire gbar_rsp_ready = ~req_valid;
					wire [3:0] wait_mask = (4'sd1 << req_wid) | mask_r;
					wire [1:0] next_count = count_r + 2'sd1;
					wire next_phase = ~phase_r;
					always @(*) begin
						mask_n = mask_r;
						count_n = count_r;
						events_n = events_r;
						phase_n = phase_r;
						unlock_valid_n = 0;
						unlock_mask_n = 1'sbx;
						gbar_req_valid_n = gbar_req_valid_r;
						gbar_req_id_n = gbar_req_id_r;
						gbar_req_size_m1_n = gbar_req_size_m1_r;
						if (req_valid && ~req_data[8]) begin
							if (req_data[9]) begin
								if (req_data[5])
									events_n = (events_r + sv2v_cast_6(req_data[4-:VX_gpu_pkg_BAR_SIZE_W])) + 6'sd1;
								else
									events_n = events_r - 6'sd1;
								if (((req_data[5] == 0) && (events_r == 6'sd1)) && (count_r == 0)) begin
									mask_n = 1'sb0;
									unlock_valid_n = 1;
									unlock_mask_n = mask_r;
									phase_n = next_phase;
								end
							end
							else if (req_data[7]) begin
								if (count_r == sv2v_cast_2(req_data[4-:VX_gpu_pkg_BAR_SIZE_W])) begin
									count_n = 1'sb0;
									if (events_r == 0) begin
										mask_n = 1'sb0;
										unlock_valid_n = 1;
										unlock_mask_n = (req_data[6] ? wait_mask : mask_r);
										phase_n = next_phase;
									end
									else if (req_data[6])
										mask_n = wait_mask;
								end
								else begin
									count_n = next_count;
									if (req_data[6])
										mask_n = wait_mask;
								end
							end
							else if (req_data[5] != phase_r) begin
								unlock_valid_n = 1;
								unlock_mask_n = 4'sd1 << req_wid;
							end
							else
								mask_n = wait_mask;
						end
						if (USE_GBAR) begin
							if (req_valid && req_data[8]) begin
								if (req_data[9]) begin
									if (req_data[5])
										events_n = (events_r + sv2v_cast_6(req_data[4-:VX_gpu_pkg_BAR_SIZE_W])) + 6'sd1;
									else
										events_n = events_r - 6'sd1;
									if (((req_data[5] == 0) && (events_r == 6'sd1)) && (wait_mask == active_warps)) begin
										mask_n = 1'sb0;
										gbar_req_valid_n = 1;
										gbar_req_id_n = req_data[12-:3];
										gbar_req_size_m1_n = sv2v_cast_1(count_r);
									end
								end
								else if (req_data[7]) begin
									count_n = sv2v_cast_2(req_data[4-:VX_gpu_pkg_BAR_SIZE_W]);
									if ((wait_mask == active_warps) && (events_r == 0)) begin
										mask_n = 1'sb0;
										gbar_req_valid_n = 1;
										gbar_req_id_n = req_data[12-:3];
										gbar_req_size_m1_n = sv2v_cast_1(req_data[4-:VX_gpu_pkg_BAR_SIZE_W]);
									end
									else
										mask_n = wait_mask;
								end
								else if (req_data[5] != phase_r) begin
									unlock_valid_n = 1;
									unlock_mask_n = 4'sd1 << req_wid;
								end
								else
									mask_n = wait_mask;
							end
							if ((vortex_core_wrap.gbar_bus_if.rsp_valid && gbar_rsp_ready) && (vortex_core_wrap.gbar_bus_if.rsp_data[2-:3] == gbar_req_id_r)) begin
								unlock_valid_n = 1;
								unlock_mask_n = active_warps;
								phase_n = next_phase;
							end
							if (gbar_req_valid_r && vortex_core_wrap.gbar_bus_if.req_ready)
								gbar_req_valid_n = 0;
						end
					end
					wire [11:0] store_state_rdata;
					wire store_phase_rdata;
					wire [4:0] store_raddr = read_addr;
					reg [4:0] store_waddr;
					wire [11:0] store_state_wdata = {mask_n, count_n, events_n};
					wire store_phase_wdata = phase_n;
					wire store_write = req_valid || vortex_core_wrap.gbar_bus_if.rsp_valid;
					VX_dp_ram #(
						.DATAW(BAR_STATEW),
						.SIZE(32),
						.RDW_MODE("W"),
						.OUT_REG(1)
					) barrier_state_store(
						.clk(clk),
						.reset(reset),
						.read(1'b1),
						.write(store_write),
						.wren(1'b1),
						.raddr(store_raddr),
						.waddr(store_waddr),
						.wdata(store_state_wdata),
						.rdata(store_state_rdata)
					);
					VX_dp_ram #(
						.DATAW(1),
						.SIZE(32),
						.RDW_MODE("W"),
						.RADDR_REG(1)
					) barrier_phase_store(
						.clk(clk),
						.reset(reset),
						.read(1'b1),
						.write(store_write),
						.wren(1'b1),
						.raddr(store_raddr),
						.waddr(store_waddr),
						.wdata(store_phase_wdata),
						.rdata(store_phase_rdata)
					);
					reg [31:0] store_valids;
					wire is_rdw_hazard = store_write && (store_waddr == store_raddr);
					wire store_phase_rdata_v = (store_valids[store_raddr] ? store_phase_rdata : 1'b0);
					always @(posedge clk) begin
						if (reset) begin
							store_valids <= 1'sb0;
							phase_r <= 1'sb0;
						end
						else begin
							if (store_write)
								store_valids[store_waddr] <= 1'b1;
							phase_r <= (store_write ? store_phase_wdata : store_phase_rdata_v);
						end
						store_waddr <= store_raddr;
					end
					assign {mask_r, count_r, events_r} = (store_valids[store_waddr] ? store_state_rdata : {12 {1'sb0}});
					wire phase_async = (is_rdw_hazard ? phase_n : store_phase_rdata_v);
					reg unlock_valid_r;
					reg [3:0] unlock_mask_r;
					always @(posedge clk) begin
						if (reset)
							unlock_valid_r <= 0;
						else
							unlock_valid_r <= unlock_valid_n;
						unlock_mask_r <= unlock_mask_n;
					end
					assign read_phase = phase_async;
					assign unlock_valid = unlock_valid_r;
					assign unlock_mask = unlock_mask_r;
					if (USE_GBAR) begin : g_gbar
						always @(posedge clk) begin
							if (reset)
								gbar_req_valid_r <= 0;
							else
								gbar_req_valid_r <= gbar_req_valid_n;
							gbar_req_size_m1_r <= gbar_req_size_m1_n;
							gbar_req_id_r <= gbar_req_id_n;
						end
						assign vortex_core_wrap.gbar_bus_if.req_valid = gbar_req_valid_r;
						assign vortex_core_wrap.gbar_bus_if.req_data[4-:3] = gbar_req_id_r;
						assign vortex_core_wrap.gbar_bus_if.req_data[1-:1] = gbar_req_size_m1_r;
						assign vortex_core_wrap.gbar_bus_if.req_data[0-:1] = 1'sd0;
						assign vortex_core_wrap.gbar_bus_if.rsp_ready = gbar_rsp_ready;
					end
					else begin : g_nogbar
						wire [1:1] sv2v_tmp_9448A;
						assign sv2v_tmp_9448A = 0;
						always @(*) gbar_req_valid_r = sv2v_tmp_9448A;
						wire [1:1] sv2v_tmp_2C0AD;
						assign sv2v_tmp_2C0AD = 1'sbx;
						always @(*) gbar_req_size_m1_r = sv2v_tmp_2C0AD;
						wire [3:1] sv2v_tmp_8951D;
						assign sv2v_tmp_8951D = 1'sbx;
						always @(*) gbar_req_id_r = sv2v_tmp_8951D;
						assign vortex_core_wrap.gbar_bus_if.req_valid = 0;
						assign vortex_core_wrap.gbar_bus_if.req_data = 1'sbx;
						assign vortex_core_wrap.gbar_bus_if.rsp_ready = 0;
					end
				end
				assign bar_unit.clk = clk;
				assign bar_unit.reset = reset;
				assign bar_unit.req_valid = vortex_core_wrap.core.warp_ctl_if.bar_valid;
				assign bar_unit.req_wid = vortex_core_wrap.core.warp_ctl_if.wid;
				assign bar_unit.req_data = vortex_core_wrap.core.warp_ctl_if.bar;
				assign bar_unit.read_addr = vortex_core_wrap.core.warp_ctl_if.bar_addr;
				assign vortex_core_wrap.core.warp_ctl_if.bar_phase = bar_unit.read_phase;
				assign bar_unit.active_warps = active_warps;
				assign bar_unlock_valid = bar_unit.unlock_valid;
				assign bar_unlock_mask = bar_unit.unlock_mask;
				VX_split_join #(
					.INSTANCE_ID(""),
					.OUT_REG(1)
				) split_join(
					.clk(clk),
					.reset(reset),
					.split_valid(vortex_core_wrap.core.warp_ctl_if.split_valid),
					.sjoin_valid(vortex_core_wrap.core.warp_ctl_if.sjoin_valid),
					.wid(vortex_core_wrap.core.warp_ctl_if.wid),
					.split(vortex_core_wrap.core.warp_ctl_if.split),
					.sjoin(vortex_core_wrap.core.warp_ctl_if.sjoin),
					.join_valid(join_valid),
					.join_is_dvg(join_is_dvg),
					.join_is_else(join_is_else),
					.join_wid(join_wid),
					.join_tmask(join_tmask),
					.join_pc(join_pc),
					.stack_wid(vortex_core_wrap.core.warp_ctl_if.dvstack_wid),
					.stack_ptr(vortex_core_wrap.core.warp_ctl_if.dvstack_ptr)
				);
				wire [3:0] ready_warps = active_warps & ~stalled_warps;
				localparam IBUF_CW = 3;
				wire [3:0] schedule_onehot;
				reg [3:0] ibuf_full;
				wire [3:0] ibuf_full_n;
				genvar _gv_i_104;
				for (_gv_i_104 = 0; _gv_i_104 < 4; _gv_i_104 = _gv_i_104 + 1) begin : g_ibuf_cnt
					localparam i = _gv_i_104;
					reg [2:0] size_r;
					wire [2:0] size_n;
					wire incr = schedule_fire && schedule_onehot[i];
					wire decr = vortex_core_wrap.core.schedule_if.ibuf_pop[i];
					assign size_n = (size_r + sv2v_cast_3(incr)) - sv2v_cast_3(decr);
					assign ibuf_full_n[i] = size_n == 3'sd4;
					always @(posedge clk)
						if (reset) begin
							size_r <= 1'sb0;
							ibuf_full[i] <= 1'b0;
						end
						else begin
							size_r <= size_n;
							ibuf_full[i] <= ibuf_full_n[i];
						end
				end
				wire [3:0] preferred_warps = ready_warps & ~ibuf_full;
				reg all_ibuf_full;
				always @(posedge clk)
					if (reset)
						all_ibuf_full <= 1'b0;
					else
						all_ibuf_full <= &ibuf_full_n;
				wire [3:0] schedule_warps = (all_ibuf_full ? ready_warps : preferred_warps);
				VX_priority_encoder #(.N(4)) wid_select(
					.data_in(schedule_warps),
					.index_out(schedule_wid),
					.valid_out(schedule_valid),
					.onehot_out(schedule_onehot)
				);
				wire [143:0] schedule_data;
				genvar _gv_i_105;
				for (_gv_i_105 = 0; _gv_i_105 < 4; _gv_i_105 = _gv_i_105 + 1) begin : g_schedule_data
					localparam i = _gv_i_105;
					assign schedule_data[i * 36+:36] = {thread_masks[i * 4+:4], warp_pcs[i * 32+:32]};
				end
				assign {schedule_tmask, schedule_pc} = {schedule_data[(schedule_wid * 36) + 35-:4], schedule_data[(schedule_wid * 36) + 31-:32]};
				localparam VX_gpu_pkg_UUID_WIDTH = 44;
				wire [43:0] instr_uuid;
				VX_uuid_gen #(.CORE_ID(CORE_ID)) uuid_gen(
					.clk(clk),
					.reset(reset),
					.incr(schedule_fire),
					.wid(schedule_wid),
					.uuid(instr_uuid)
				);
				wire [1:0] schedule_cta_id = cta_id_per_warp_r[schedule_wid * 2+:2];
				VX_elastic_buffer #(
					.DATAW(84),
					.SIZE(2),
					.OUT_REG(1)
				) out_buf(
					.clk(clk),
					.reset(reset),
					.valid_in(schedule_valid),
					.ready_in(schedule_ready),
					.data_in({schedule_tmask, schedule_pc, schedule_wid, schedule_cta_id, instr_uuid}),
					.data_out({vortex_core_wrap.core.schedule_if.data[35-:4], vortex_core_wrap.core.schedule_if.data[31-:32], vortex_core_wrap.core.schedule_if.data[39-:2], vortex_core_wrap.core.schedule_if.data[37-:2], vortex_core_wrap.core.schedule_if.data[83-:44]}),
					.valid_out(vortex_core_wrap.core.schedule_if.valid),
					.ready_out(vortex_core_wrap.core.schedule_if.ready)
				);
				reg [43:0] instret;
				wire [3:0] committed_warps_v = vortex_core_wrap.core.commit_sched_if.committed_warps;
				wire [2:0] committed_warps_cnt_v;
				VX_popcount #(
					.N(4),
					.MODEL(1)
				) __pop_count_ex588(
					.data_in(committed_warps_v),
					.data_out(committed_warps_cnt_v)
				);
				always @(posedge clk)
					if (reset)
						instret <= 1'sb0;
					else
						instret <= instret + sv2v_cast_44(committed_warps_cnt_v);
				wire [3:0] pending_warp_empty;
				wire [3:0] pending_warp_alm_empty;
				genvar _gv_i_106;
				localparam VX_gpu_pkg_ISSUE_ISW_BITS = 0;
				localparam VX_gpu_pkg_ISSUE_ISW_W = 1;
				localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
				localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
				localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
				function automatic [0:0] VX_gpu_pkg_wid_to_isw;
					input reg [1:0] wid;
					VX_gpu_pkg_wid_to_isw = 0;
				endfunction
				function automatic [1:0] VX_gpu_pkg_wid_to_wis;
					input reg [1:0] wid;
					VX_gpu_pkg_wid_to_wis = wid >> VX_gpu_pkg_ISSUE_ISW_BITS;
				endfunction
				for (_gv_i_106 = 0; _gv_i_106 < 4; _gv_i_106 = _gv_i_106 + 1) begin : g_pending_warps
					localparam i = _gv_i_106;
					localparam [0:0] isw = 0;
					localparam [1:0] wis = i >> VX_gpu_pkg_ISSUE_ISW_BITS;
					VX_pending_size #(
						.SIZE(256),
						.ALM_EMPTY(1)
					) per_warp_ctr(
						.clk(clk),
						.reset(reset),
						.incr(vortex_core_wrap.core.issue_sched_if[isw + _mbase_issue_sched_if].valid && (vortex_core_wrap.core.issue_sched_if[isw + _mbase_issue_sched_if].wis == wis)),
						.decr(vortex_core_wrap.core.commit_sched_if.committed_warps[i]),
						.empty(pending_warp_empty[i]),
						.alm_empty(pending_warp_alm_empty[i]),
						.full(),
						.alm_full(),
						.size()
					);
				end
				wire busy_buf;
				VX_pipe_register #(
					.DATAW(1),
					.RESETW(1),
					.DEPTH(1)
				) __buffer_ex624(
					.clk(clk),
					.reset(reset),
					.enable(1'b1),
					.data_in((active_warps_n != 0) || ~(&pending_warp_empty)),
					.data_out(busy_buf)
				);
				assign busy = busy_buf || cta_dispatcher_busy;
				assign vortex_core_wrap.core.warp_ctl_if.warp_pending_alm_empty = pending_warp_alm_empty;
				assign vortex_core_wrap.core.sched_csr_if.cycles = cycles;
				assign vortex_core_wrap.core.sched_csr_if.instret = instret;
				assign vortex_core_wrap.core.sched_csr_if.active_warps = active_warps;
				assign vortex_core_wrap.core.sched_csr_if.thread_masks = thread_masks;
				reg [31:0] timeout_ctr;
				reg timeout_enable;
				always @(posedge clk)
					if (reset) begin
						timeout_ctr <= 1'sb0;
						timeout_enable <= 0;
					end
					else begin
						if (vortex_core_wrap.core.decode_sched_if.valid && vortex_core_wrap.core.decode_sched_if.unlock)
							timeout_enable <= 1;
						if ((timeout_enable && (active_warps != 0)) && (active_warps == stalled_warps))
							timeout_ctr <= timeout_ctr + 1;
						else if ((active_warps == 0) || (active_warps != stalled_warps))
							timeout_ctr <= 1'sb0;
					end
				localparam VX_gpu_pkg_STALL_TIMEOUT = 100000;
				localparam SCHED_STALL_TIMEOUT = VX_gpu_pkg_STALL_TIMEOUT;
			end
			assign scheduler.clk = clk;
			assign scheduler.reset = reset;
			assign sched_busy = scheduler.busy;
			localparam _bbase_4EF94_icache_bus_if = 0;
			localparam _param_4EF94_INSTANCE_ID = "";
			if (1) begin : fetch
				localparam INSTANCE_ID = _param_4EF94_INSTANCE_ID;
				wire clk;
				wire reset;
				localparam _mbase_icache_bus_if = _bbase_4EF94_icache_bus_if;
				wire icache_req_valid;
				wire icache_req_ready;
				localparam VX_gpu_pkg_ICACHE_WORD_SIZE = 4;
				localparam VX_gpu_pkg_ICACHE_ADDR_WIDTH = 30;
				wire [29:0] icache_req_addr;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
				localparam VX_gpu_pkg_ICACHE_TAG_ID_BITS = VX_gpu_pkg_NW_WIDTH;
				localparam VX_gpu_pkg_UUID_WIDTH = 44;
				localparam VX_gpu_pkg_ICACHE_FETCH_TAG_WIDTH = 46;
				wire [45:0] icache_req_tag;
				wire [1:0] icache_req_wid;
				wire [43:0] icache_req_uuid;
				wire [43:0] rsp_uuid;
				localparam VX_gpu_pkg_PC_BITS = 32;
				wire [31:0] rsp_PC;
				wire [3:0] rsp_tmask;
				wire [1:0] req_tag;
				wire [1:0] rsp_tag;
				localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
				localparam VX_gpu_pkg_NCTA_BITS = 2;
				localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
				wire [1:0] rsp_cta_id;
				wire icache_req_fire = icache_req_valid && icache_req_ready;
				assign req_tag = vortex_core_wrap.core.schedule_if.data[39-:2];
				assign {rsp_uuid, rsp_tag} = vortex_core_wrap.core.fetch_icache_if[_mbase_icache_bus_if].rsp_data[45-:_param_4C937_TAG_WIDTH];
				VX_dp_ram #(
					.DATAW(38),
					.SIZE(4),
					.RDW_MODE("R"),
					.LUTRAM(1)
				) tag_store(
					.clk(clk),
					.reset(reset),
					.read(1'b1),
					.write(icache_req_fire),
					.wren(1'b1),
					.waddr(req_tag),
					.wdata({vortex_core_wrap.core.schedule_if.data[31-:32], vortex_core_wrap.core.schedule_if.data[35-:4], vortex_core_wrap.core.schedule_if.data[37-:2]}),
					.raddr(rsp_tag),
					.rdata({rsp_PC, rsp_tmask, rsp_cta_id})
				);
				assign icache_req_valid = vortex_core_wrap.core.schedule_if.valid;
				assign icache_req_addr = vortex_core_wrap.core.schedule_if.data[2+:VX_gpu_pkg_ICACHE_ADDR_WIDTH];
				assign icache_req_wid = vortex_core_wrap.core.schedule_if.data[39-:2];
				assign icache_req_uuid = vortex_core_wrap.core.schedule_if.data[83-:44];
				assign icache_req_tag = {icache_req_uuid, icache_req_wid};
				assign vortex_core_wrap.core.schedule_if.ibuf_pop = vortex_core_wrap.core.fetch_if.ibuf_pop;
				assign vortex_core_wrap.core.schedule_if.ready = icache_req_ready;
				assign vortex_core_wrap.core.fetch_if.valid = vortex_core_wrap.core.fetch_icache_if[_mbase_icache_bus_if].rsp_valid;
				assign vortex_core_wrap.core.fetch_if.data[67-:4] = rsp_tmask;
				assign vortex_core_wrap.core.fetch_if.data[71-:2] = rsp_tag;
				assign vortex_core_wrap.core.fetch_if.data[69-:2] = rsp_cta_id;
				assign vortex_core_wrap.core.fetch_if.data[63-:32] = rsp_PC;
				assign vortex_core_wrap.core.fetch_if.data[31-:32] = vortex_core_wrap.core.fetch_icache_if[_mbase_icache_bus_if].rsp_data[77-:32];
				assign vortex_core_wrap.core.fetch_if.data[115-:44] = rsp_uuid;
				assign vortex_core_wrap.core.fetch_icache_if[_mbase_icache_bus_if].rsp_ready = vortex_core_wrap.core.fetch_if.ready;
				VX_elastic_buffer #(
					.DATAW(76),
					.SIZE(2),
					.OUT_REG(1)
				) req_buf(
					.clk(clk),
					.reset(reset),
					.valid_in(icache_req_valid),
					.ready_in(icache_req_ready),
					.data_in({icache_req_addr, icache_req_tag}),
					.data_out({vortex_core_wrap.core.fetch_icache_if[_mbase_icache_bus_if].req_data[124-:30], vortex_core_wrap.core.fetch_icache_if[_mbase_icache_bus_if].req_data[45-:_param_4C937_TAG_WIDTH]}),
					.valid_out(vortex_core_wrap.core.fetch_icache_if[_mbase_icache_bus_if].req_valid),
					.ready_out(vortex_core_wrap.core.fetch_icache_if[_mbase_icache_bus_if].req_ready)
				);
				assign vortex_core_wrap.core.fetch_icache_if[_mbase_icache_bus_if].req_data[58-:13] = 1'sb0;
				assign vortex_core_wrap.core.fetch_icache_if[_mbase_icache_bus_if].req_data[125] = 1'b0;
				assign vortex_core_wrap.core.fetch_icache_if[_mbase_icache_bus_if].req_data[62-:4] = 1'sb1;
				assign vortex_core_wrap.core.fetch_icache_if[_mbase_icache_bus_if].req_data[94-:32] = 1'sb0;
			end
			assign fetch.clk = clk;
			assign fetch.reset = reset;
			localparam _bbase_56071_core_bus_if = 0;
			localparam _bbase_56071_cache_bus_if = 0;
			localparam _param_56071_WORD_SIZE = VX_gpu_pkg_ICACHE_WORD_SIZE;
			localparam _param_56071_TAG_WIDTH = VX_gpu_pkg_ICACHE_FETCH_TAG_WIDTH;
			if (1) begin : icache_dcr_flush
				localparam WORD_SIZE = _param_56071_WORD_SIZE;
				localparam TAG_WIDTH = _param_56071_TAG_WIDTH;
				wire clk;
				wire reset;
				localparam _mbase_core_bus_if = _bbase_56071_core_bus_if;
				localparam _mbase_cache_bus_if = _bbase_56071_cache_bus_if;
				localparam _param_4D2A0_DATA_SIZE = WORD_SIZE;
				localparam _param_4D2A0_TAG_WIDTH = TAG_WIDTH;
				if (1) begin : flush_bus_if
					localparam DATA_SIZE = _param_4D2A0_DATA_SIZE;
					localparam VX_gpu_pkg_NC_BITS = 0;
					localparam VX_gpu_pkg_NT_BITS = 2;
					localparam VX_gpu_pkg_NW_BITS = 2;
					localparam VX_gpu_pkg_HART_ID_BITS = 4;
					localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
					localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
					localparam ATTR_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
					localparam VX_gpu_pkg_UUID_WIDTH = 44;
					localparam TAG_WIDTH = _param_4D2A0_TAG_WIDTH;
					localparam ADDR_WIDTH = 30;
					wire req_valid;
					wire [125:0] req_data;
					wire req_ready;
					wire rsp_valid;
					wire [77:0] rsp_data;
					wire rsp_ready;
				end
				reg flush_inflight_r;
				reg flush_done_r;
				wire flush_req_fire = flush_bus_if.req_valid && flush_bus_if.req_ready;
				always @(posedge clk)
					if (reset) begin
						flush_inflight_r <= 1'b0;
						flush_done_r <= 1'b0;
					end
					else if (!vortex_core_wrap.core.dcr_flush_icache_if.req) begin
						flush_inflight_r <= 1'b0;
						flush_done_r <= 1'b0;
					end
					else begin
						if (flush_req_fire)
							flush_inflight_r <= 1'b1;
						else if (flush_bus_if.rsp_valid)
							flush_inflight_r <= 1'b0;
						if (flush_bus_if.rsp_valid)
							flush_done_r <= 1'b1;
					end
				assign flush_bus_if.req_valid = (vortex_core_wrap.core.dcr_flush_icache_if.req && !flush_inflight_r) && !flush_done_r;
				localparam VX_gpu_pkg_MEM_ATTR_FLUSH_OFFS = 0;
				localparam VX_gpu_pkg_NC_BITS = 0;
				localparam VX_gpu_pkg_NT_BITS = 2;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_HART_ID_BITS = 4;
				localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
				localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
				function automatic signed [12:0] sv2v_cast_928CB_signed;
					input reg signed [12:0] inp;
					sv2v_cast_928CB_signed = inp;
				endfunction
				function automatic [29:0] sv2v_cast_C7F56;
					input reg [29:0] inp;
					sv2v_cast_C7F56 = inp;
				endfunction
				function automatic [31:0] sv2v_cast_04B4B;
					input reg [31:0] inp;
					sv2v_cast_04B4B = inp;
				endfunction
				function automatic [3:0] sv2v_cast_25A49;
					input reg [3:0] inp;
					sv2v_cast_25A49 = inp;
				endfunction
				function automatic [12:0] sv2v_cast_09E57;
					input reg [12:0] inp;
					sv2v_cast_09E57 = inp;
				endfunction
				function automatic [45:0] sv2v_cast_1FB23;
					input reg [45:0] inp;
					sv2v_cast_1FB23 = inp;
				endfunction
				assign flush_bus_if.req_data = {1'b0, sv2v_cast_C7F56(1'sb0), sv2v_cast_04B4B(1'sb0), sv2v_cast_25A49(1'sb0), sv2v_cast_09E57(sv2v_cast_928CB_signed(1)), sv2v_cast_1FB23(1'sb0)};
				assign vortex_core_wrap.core.dcr_flush_icache_if.done = flush_done_r;
				assign flush_bus_if.rsp_ready = 1'b1;
				localparam _param_4FC03_DATA_SIZE = WORD_SIZE;
				localparam _param_4FC03_TAG_WIDTH = TAG_WIDTH;
				genvar _arr_4FC03;
				for (_arr_4FC03 = 0; _arr_4FC03 <= 1; _arr_4FC03 = _arr_4FC03 + 1) begin : dcache_arb_in_if
					localparam DATA_SIZE = _param_4FC03_DATA_SIZE;
					localparam VX_gpu_pkg_NC_BITS = 0;
					localparam VX_gpu_pkg_NT_BITS = 2;
					localparam VX_gpu_pkg_NW_BITS = 2;
					localparam VX_gpu_pkg_HART_ID_BITS = 4;
					localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
					localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
					localparam ATTR_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
					localparam VX_gpu_pkg_UUID_WIDTH = 44;
					localparam TAG_WIDTH = _param_4FC03_TAG_WIDTH;
					localparam ADDR_WIDTH = 30;
					wire req_valid;
					wire [125:0] req_data;
					wire req_ready;
					wire rsp_valid;
					wire [77:0] rsp_data;
					wire rsp_ready;
				end
				assign dcache_arb_in_if[0].req_valid = vortex_core_wrap.core.fetch_icache_if[_mbase_core_bus_if].req_valid;
				assign dcache_arb_in_if[0].req_data = vortex_core_wrap.core.fetch_icache_if[_mbase_core_bus_if].req_data;
				assign vortex_core_wrap.core.fetch_icache_if[_mbase_core_bus_if].req_ready = dcache_arb_in_if[0].req_ready;
				assign vortex_core_wrap.core.fetch_icache_if[_mbase_core_bus_if].rsp_valid = dcache_arb_in_if[0].rsp_valid;
				assign vortex_core_wrap.core.fetch_icache_if[_mbase_core_bus_if].rsp_data = dcache_arb_in_if[0].rsp_data;
				assign dcache_arb_in_if[0].rsp_ready = vortex_core_wrap.core.fetch_icache_if[_mbase_core_bus_if].rsp_ready;
				assign dcache_arb_in_if[1].req_valid = flush_bus_if.req_valid;
				assign dcache_arb_in_if[1].req_data = flush_bus_if.req_data;
				assign flush_bus_if.req_ready = dcache_arb_in_if[1].req_ready;
				assign flush_bus_if.rsp_valid = dcache_arb_in_if[1].rsp_valid;
				assign flush_bus_if.rsp_data = dcache_arb_in_if[1].rsp_data;
				assign dcache_arb_in_if[1].rsp_ready = flush_bus_if.rsp_ready;
				localparam _param_8051A_DATA_SIZE = WORD_SIZE;
				localparam _param_8051A_TAG_WIDTH = 47;
				genvar _arr_8051A;
				for (_arr_8051A = 0; _arr_8051A <= 0; _arr_8051A = _arr_8051A + 1) begin : dcache_arb_out_if
					localparam DATA_SIZE = _param_8051A_DATA_SIZE;
					localparam VX_gpu_pkg_NC_BITS = 0;
					localparam VX_gpu_pkg_NT_BITS = 2;
					localparam VX_gpu_pkg_NW_BITS = 2;
					localparam VX_gpu_pkg_HART_ID_BITS = 4;
					localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
					localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
					localparam ATTR_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
					localparam VX_gpu_pkg_UUID_WIDTH = 44;
					localparam TAG_WIDTH = _param_8051A_TAG_WIDTH;
					localparam ADDR_WIDTH = 30;
					wire req_valid;
					wire [126:0] req_data;
					wire req_ready;
					wire rsp_valid;
					wire [78:0] rsp_data;
					wire rsp_ready;
				end
				localparam _bbase_3A0C0_bus_in_if = 0;
				localparam _bbase_3A0C0_bus_out_if = 0;
				localparam _param_3A0C0_NUM_INPUTS = 2;
				localparam _param_3A0C0_NUM_OUTPUTS = 1;
				localparam _param_3A0C0_DATA_SIZE = WORD_SIZE;
				localparam _param_3A0C0_TAG_WIDTH = TAG_WIDTH;
				localparam _param_3A0C0_TAG_SEL_IDX = 0;
				localparam _param_3A0C0_ARBITER = "P";
				localparam _param_3A0C0_STICKY = 1;
				if (1) begin : dcache_flush_arb
					localparam NUM_INPUTS = _param_3A0C0_NUM_INPUTS;
					localparam NUM_OUTPUTS = _param_3A0C0_NUM_OUTPUTS;
					localparam DATA_SIZE = _param_3A0C0_DATA_SIZE;
					localparam TAG_WIDTH = _param_3A0C0_TAG_WIDTH;
					localparam TAG_SEL_IDX = _param_3A0C0_TAG_SEL_IDX;
					localparam REQ_OUT_BUF = 0;
					localparam RSP_OUT_BUF = 0;
					localparam ARBITER = _param_3A0C0_ARBITER;
					localparam STICKY = _param_3A0C0_STICKY;
					localparam ADDR_WIDTH = 30;
					localparam VX_gpu_pkg_NC_BITS = 0;
					localparam VX_gpu_pkg_NT_BITS = 2;
					localparam VX_gpu_pkg_NW_BITS = 2;
					localparam VX_gpu_pkg_HART_ID_BITS = 4;
					localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
					localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
					localparam ATTR_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
					wire clk;
					wire reset;
					localparam _mbase_bus_in_if = 0;
					localparam _mbase_bus_out_if = 0;
					localparam DATA_WIDTH = 32;
					localparam LOG_NUM_REQS = 1;
					localparam REQ_DATAW = 126;
					localparam RSP_DATAW = 78;
					localparam SEL_COUNT = NUM_OUTPUTS;
					wire [1:0] req_valid_in;
					wire [251:0] req_data_in;
					wire [1:0] req_ready_in;
					wire [0:0] req_valid_out;
					wire [125:0] req_data_out;
					wire [0:0] req_sel_out;
					wire [0:0] req_ready_out;
					genvar _gv_i_254;
					for (_gv_i_254 = 0; _gv_i_254 < NUM_INPUTS; _gv_i_254 = _gv_i_254 + 1) begin : g_req_data_in
						localparam i = _gv_i_254;
						assign req_valid_in[i] = vortex_core_wrap.core.icache_dcr_flush.dcache_arb_in_if[i + _mbase_bus_in_if].req_valid;
						assign req_data_in[i * REQ_DATAW+:REQ_DATAW] = vortex_core_wrap.core.icache_dcr_flush.dcache_arb_in_if[i + _mbase_bus_in_if].req_data;
						assign vortex_core_wrap.core.icache_dcr_flush.dcache_arb_in_if[i + _mbase_bus_in_if].req_ready = req_ready_in[i];
					end
					VX_stream_arb #(
						.NUM_INPUTS(NUM_INPUTS),
						.NUM_OUTPUTS(NUM_OUTPUTS),
						.DATAW(REQ_DATAW),
						.ARBITER(ARBITER),
						.STICKY(STICKY),
						.OUT_BUF(REQ_OUT_BUF)
					) req_arb(
						.clk(clk),
						.reset(reset),
						.valid_in(req_valid_in),
						.ready_in(req_ready_in),
						.data_in(req_data_in),
						.data_out(req_data_out),
						.sel_out(req_sel_out),
						.valid_out(req_valid_out),
						.ready_out(req_ready_out)
					);
					genvar _gv_i_255;
					for (_gv_i_255 = 0; _gv_i_255 < NUM_OUTPUTS; _gv_i_255 = _gv_i_255 + 1) begin : g_bus_out_if
						localparam i = _gv_i_255;
						wire [45:0] req_tag_out;
						assign vortex_core_wrap.core.icache_dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].req_valid = req_valid_out[i];
						assign {vortex_core_wrap.core.icache_dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].req_data[126], vortex_core_wrap.core.icache_dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].req_data[125-:30], vortex_core_wrap.core.icache_dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].req_data[95-:32], vortex_core_wrap.core.icache_dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].req_data[63-:4], vortex_core_wrap.core.icache_dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].req_data[59-:13], req_tag_out} = req_data_out[i * REQ_DATAW+:REQ_DATAW];
						assign req_ready_out[i] = vortex_core_wrap.core.icache_dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].req_ready;
						if (1) begin : g_req_tag_sel_out
							VX_bits_insert #(
								.N(TAG_WIDTH),
								.S(LOG_NUM_REQS),
								.POS(TAG_SEL_IDX)
							) bits_insert(
								.data_in(req_tag_out),
								.ins_in(req_sel_out[i+:1]),
								.data_out(vortex_core_wrap.core.icache_dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].req_data[46-:_param_8051A_TAG_WIDTH])
							);
						end
					end
					wire [1:0] rsp_valid_out;
					wire [155:0] rsp_data_out;
					wire [1:0] rsp_ready_out;
					wire [0:0] rsp_valid_in;
					wire [77:0] rsp_data_in;
					wire [0:0] rsp_ready_in;
					if (1) begin : g_rsp_select
						wire [0:0] rsp_sel_in;
						genvar _gv_i_256;
						for (_gv_i_256 = 0; _gv_i_256 < NUM_OUTPUTS; _gv_i_256 = _gv_i_256 + 1) begin : g_rsp_data_in
							localparam i = _gv_i_256;
							wire [45:0] rsp_tag_out;
							VX_bits_remove #(
								.N(47),
								.S(LOG_NUM_REQS),
								.POS(TAG_SEL_IDX)
							) bits_remove(
								.data_in(vortex_core_wrap.core.icache_dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].rsp_data[46-:_param_8051A_TAG_WIDTH]),
								.sel_out(rsp_sel_in[i+:1]),
								.data_out(rsp_tag_out)
							);
							assign rsp_valid_in[i] = vortex_core_wrap.core.icache_dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].rsp_valid;
							assign rsp_data_in[i * 78+:78] = {vortex_core_wrap.core.icache_dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].rsp_data[78-:32], rsp_tag_out};
							assign vortex_core_wrap.core.icache_dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].rsp_ready = rsp_ready_in[i];
						end
						VX_stream_switch #(
							.NUM_INPUTS(NUM_OUTPUTS),
							.NUM_OUTPUTS(NUM_INPUTS),
							.DATAW(RSP_DATAW),
							.OUT_BUF(RSP_OUT_BUF)
						) rsp_switch(
							.clk(clk),
							.reset(reset),
							.sel_in(rsp_sel_in),
							.valid_in(rsp_valid_in),
							.ready_in(rsp_ready_in),
							.data_in(rsp_data_in),
							.data_out(rsp_data_out),
							.valid_out(rsp_valid_out),
							.ready_out(rsp_ready_out)
						);
					end
					genvar _gv_i_258;
					for (_gv_i_258 = 0; _gv_i_258 < NUM_INPUTS; _gv_i_258 = _gv_i_258 + 1) begin : g_output
						localparam i = _gv_i_258;
						assign vortex_core_wrap.core.icache_dcr_flush.dcache_arb_in_if[i + _mbase_bus_in_if].rsp_valid = rsp_valid_out[i];
						assign vortex_core_wrap.core.icache_dcr_flush.dcache_arb_in_if[i + _mbase_bus_in_if].rsp_data = rsp_data_out[i * 78+:78];
						assign rsp_ready_out[i] = vortex_core_wrap.core.icache_dcr_flush.dcache_arb_in_if[i + _mbase_bus_in_if].rsp_ready;
					end
				end
				assign dcache_flush_arb.clk = clk;
				assign dcache_flush_arb.reset = reset;
				assign vortex_core_wrap.core.mmu_icache_if[_mbase_cache_bus_if].req_valid = dcache_arb_out_if[0].req_valid;
				assign vortex_core_wrap.core.mmu_icache_if[_mbase_cache_bus_if].req_data = dcache_arb_out_if[0].req_data;
				assign dcache_arb_out_if[0].req_ready = vortex_core_wrap.core.mmu_icache_if[_mbase_cache_bus_if].req_ready;
				assign dcache_arb_out_if[0].rsp_valid = vortex_core_wrap.core.mmu_icache_if[_mbase_cache_bus_if].rsp_valid;
				assign dcache_arb_out_if[0].rsp_data = vortex_core_wrap.core.mmu_icache_if[_mbase_cache_bus_if].rsp_data;
				assign vortex_core_wrap.core.mmu_icache_if[_mbase_cache_bus_if].rsp_ready = dcache_arb_out_if[0].rsp_ready;
			end
			assign icache_dcr_flush.clk = clk;
			assign icache_dcr_flush.reset = reset;
			localparam _param_EA58B_INSTANCE_ID = "";
			if (1) begin : decode
				localparam INSTANCE_ID = _param_EA58B_INSTANCE_ID;
				wire clk;
				wire reset;
				localparam VX_gpu_pkg_XLENB = 4;
				localparam VX_gpu_pkg_XLENB_W = 2;
				localparam VX_gpu_pkg_BYTESEL_BITS = 4;
				localparam VX_gpu_pkg_EX_SFU = 2;
				localparam VX_gpu_pkg_EX_FPU = 3;
				localparam VX_gpu_pkg_EX_TCU = 3;
				localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
				localparam VX_gpu_pkg_EX_BITS = 2;
				localparam VX_gpu_pkg_INST_OP_BITS = 4;
				localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
				localparam VX_gpu_pkg_NCTA_BITS = 2;
				localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
				localparam VX_gpu_pkg_REG_TYPES = 2;
				localparam VX_gpu_pkg_RV_REGS = 32;
				localparam VX_gpu_pkg_NUM_REGS = 64;
				localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
				localparam VX_gpu_pkg_NUM_SRC_OPDS = 3;
				localparam VX_gpu_pkg_NUM_XREGS = 2;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
				localparam VX_gpu_pkg_PC_BITS = 32;
				localparam VX_gpu_pkg_UUID_WIDTH = 44;
				localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
				localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
				localparam VX_gpu_pkg_INST_FMT_BITS = 2;
				localparam VX_gpu_pkg_INST_FRM_BITS = 3;
				localparam OUT_DATAW = 151;
				reg [1:0] ex_type;
				reg [3:0] op_type;
				reg [24:0] op_args;
				reg [23:0] reg_ids;
				reg [VX_gpu_pkg_NUM_SRC_OPDS:0] use_regs;
				reg [1:0] rd_xregs;
				reg [1:0] wr_xregs;
				reg [3:0] bytesel;
				reg is_wstall;
				wire [31:0] instr = vortex_core_wrap.core.fetch_if.data[31-:32];
				wire [6:0] opcode = instr[6:0];
				wire [1:0] funct2 = instr[26:25];
				wire [2:0] funct3 = instr[14:12];
				wire [4:0] funct5 = instr[31:27];
				wire [6:0] funct7 = instr[31:25];
				wire [11:0] u_12 = instr[31:20];
				wire [4:0] rd = instr[11:7];
				wire [4:0] rs1 = instr[19:15];
				wire [4:0] rs2 = instr[24:20];
				wire [4:0] rs3 = instr[31:27];
				wire is_itype_sh = funct3[0] && ~funct3[1];
				wire is_csr_fflags = u_12 == 12'h001;
				wire is_csr_frm = u_12 == 12'h002;
				wire is_csr_fcsr = u_12 == 12'h003;
				wire frm_is_dyn = funct3 == 3'b111;
				wire is_rd_zero = rd == 0;
				reg csr_write;
				always @(*) begin
					csr_write = 1'b0;
					(* full_case, parallel_case *)
					case (funct3)
						3'b001, 3'b101: csr_write = 1'b1;
						3'b010, 3'b011: csr_write = rs1 != 0;
						3'b110, 3'b111: csr_write = rs1 != 0;
						default: csr_write = 1'b0;
					endcase
				end
				wire [19:0] ui_imm = instr[31:12];
				wire [11:0] i_imm = (is_itype_sh ? {7'b0000000, instr[24:20]} : u_12);
				wire [11:0] s_imm = {funct7, rd};
				wire [11:0] b_imm = {instr[31], instr[7], instr[30:25], instr[11:8]};
				wire [19:0] jal_imm = {instr[31], instr[19:12], instr[20], instr[30:21]};
				localparam VX_gpu_pkg_INST_ALU_BITS = 4;
				reg [3:0] r_type;
				localparam VX_gpu_pkg_INST_ALU_ADD = 4'b0000;
				localparam VX_gpu_pkg_INST_ALU_AND = 4'b1100;
				localparam VX_gpu_pkg_INST_ALU_OR = 4'b1101;
				localparam VX_gpu_pkg_INST_ALU_SLL = 4'b1111;
				localparam VX_gpu_pkg_INST_ALU_SLT = 4'b0101;
				localparam VX_gpu_pkg_INST_ALU_SLTU = 4'b0100;
				localparam VX_gpu_pkg_INST_ALU_SRA = 4'b1001;
				localparam VX_gpu_pkg_INST_ALU_SRL = 4'b1000;
				localparam VX_gpu_pkg_INST_ALU_SUB = 4'b0111;
				localparam VX_gpu_pkg_INST_ALU_XOR = 4'b1110;
				always @(*)
					case (funct3)
						3'h0: r_type = (opcode[5] && funct7[5] ? VX_gpu_pkg_INST_ALU_SUB : VX_gpu_pkg_INST_ALU_ADD);
						3'h1: r_type = VX_gpu_pkg_INST_ALU_SLL;
						3'h2: r_type = VX_gpu_pkg_INST_ALU_SLT;
						3'h3: r_type = VX_gpu_pkg_INST_ALU_SLTU;
						3'h4: r_type = VX_gpu_pkg_INST_ALU_XOR;
						3'h5: r_type = (funct7[5] ? VX_gpu_pkg_INST_ALU_SRA : VX_gpu_pkg_INST_ALU_SRL);
						3'h6: r_type = VX_gpu_pkg_INST_ALU_OR;
						3'h7: r_type = VX_gpu_pkg_INST_ALU_AND;
					endcase
				localparam VX_gpu_pkg_INST_BR_BITS = 4;
				reg [3:0] b_type;
				localparam VX_gpu_pkg_INST_BR_BEQ = 4'b0000;
				localparam VX_gpu_pkg_INST_BR_BGE = 4'b0111;
				localparam VX_gpu_pkg_INST_BR_BGEU = 4'b0110;
				localparam VX_gpu_pkg_INST_BR_BLT = 4'b0101;
				localparam VX_gpu_pkg_INST_BR_BLTU = 4'b0100;
				localparam VX_gpu_pkg_INST_BR_BNE = 4'b0010;
				always @(*)
					case (funct3)
						3'h0: b_type = VX_gpu_pkg_INST_BR_BEQ;
						3'h1: b_type = VX_gpu_pkg_INST_BR_BNE;
						3'h4: b_type = VX_gpu_pkg_INST_BR_BLT;
						3'h5: b_type = VX_gpu_pkg_INST_BR_BGE;
						3'h6: b_type = VX_gpu_pkg_INST_BR_BLTU;
						3'h7: b_type = VX_gpu_pkg_INST_BR_BGEU;
						default: b_type = 1'sbx;
					endcase
				reg [3:0] s_type;
				localparam VX_gpu_pkg_INST_BR_EBREAK = 4'b1011;
				localparam VX_gpu_pkg_INST_BR_ECALL = 4'b1010;
				localparam VX_gpu_pkg_INST_BR_MRET = 4'b1110;
				localparam VX_gpu_pkg_INST_BR_SRET = 4'b1101;
				localparam VX_gpu_pkg_INST_BR_URET = 4'b1100;
				always @(*)
					case (u_12)
						12'h000: s_type = VX_gpu_pkg_INST_BR_ECALL;
						12'h001: s_type = VX_gpu_pkg_INST_BR_EBREAK;
						12'h002: s_type = VX_gpu_pkg_INST_BR_URET;
						12'h102: s_type = VX_gpu_pkg_INST_BR_SRET;
						12'h302: s_type = VX_gpu_pkg_INST_BR_MRET;
						default: s_type = 1'sbx;
					endcase
				localparam VX_gpu_pkg_INST_M_BITS = 3;
				reg [2:0] m_type;
				localparam VX_gpu_pkg_INST_M_DIV = 3'b100;
				localparam VX_gpu_pkg_INST_M_DIVU = 3'b101;
				localparam VX_gpu_pkg_INST_M_MUL = 3'b000;
				localparam VX_gpu_pkg_INST_M_MULH = 3'b010;
				localparam VX_gpu_pkg_INST_M_MULHSU = 3'b011;
				localparam VX_gpu_pkg_INST_M_MULHU = 3'b001;
				localparam VX_gpu_pkg_INST_M_REM = 3'b110;
				localparam VX_gpu_pkg_INST_M_REMU = 3'b111;
				always @(*)
					case (funct3)
						3'h0: m_type = VX_gpu_pkg_INST_M_MUL;
						3'h1: m_type = VX_gpu_pkg_INST_M_MULH;
						3'h2: m_type = VX_gpu_pkg_INST_M_MULHSU;
						3'h3: m_type = VX_gpu_pkg_INST_M_MULHU;
						3'h4: m_type = VX_gpu_pkg_INST_M_DIV;
						3'h5: m_type = VX_gpu_pkg_INST_M_DIVU;
						3'h6: m_type = VX_gpu_pkg_INST_M_REM;
						3'h7: m_type = VX_gpu_pkg_INST_M_REMU;
					endcase
				wire decode_is_rvc = 1'b0;
				localparam VX_gpu_pkg_ALU_TYPE_ARITH = 0;
				localparam VX_gpu_pkg_ALU_TYPE_BRANCH = 1;
				localparam VX_gpu_pkg_ALU_TYPE_MULDIV = 2;
				localparam VX_gpu_pkg_ALU_TYPE_OTHER = 3;
				localparam [3:0] VX_gpu_pkg_BYTESEL_DEFAULT = 4'hc;
				localparam VX_gpu_pkg_EX_ALU = 0;
				localparam VX_gpu_pkg_EX_LSU = 1;
				localparam VX_gpu_pkg_INST_ALU_AUIPC = 4'b0011;
				localparam VX_gpu_pkg_INST_ALU_CZEQ = 4'b1010;
				localparam VX_gpu_pkg_INST_ALU_CZNE = 4'b1011;
				localparam VX_gpu_pkg_INST_ALU_LUI = 4'b0010;
				localparam VX_gpu_pkg_INST_AUIPC = 7'b0010111;
				localparam VX_gpu_pkg_INST_B = 7'b1100011;
				localparam VX_gpu_pkg_INST_BR_JAL = 4'b1000;
				localparam VX_gpu_pkg_INST_BR_JALR = 4'b1001;
				localparam VX_gpu_pkg_INST_EXT1 = 7'b0001011;
				localparam VX_gpu_pkg_INST_EXT2 = 7'b0101011;
				localparam VX_gpu_pkg_INST_FCI = 7'b1010011;
				localparam VX_gpu_pkg_INST_FENCE = 7'b0001111;
				localparam VX_gpu_pkg_INST_FL = 7'b0000111;
				localparam VX_gpu_pkg_INST_FMADD = 7'b1000011;
				localparam VX_gpu_pkg_INST_FMSUB = 7'b1000111;
				localparam VX_gpu_pkg_INST_FNMADD = 7'b1001111;
				localparam VX_gpu_pkg_INST_FNMSUB = 7'b1001011;
				localparam VX_gpu_pkg_INST_FPU_CMP = 4'b1100;
				localparam VX_gpu_pkg_INST_FPU_DIV = 4'b0100;
				localparam VX_gpu_pkg_INST_FPU_F2I = 4'b1000;
				localparam VX_gpu_pkg_INST_FPU_F2U = 4'b1001;
				localparam VX_gpu_pkg_INST_FPU_I2F = 4'b1010;
				localparam VX_gpu_pkg_INST_FPU_MISC = 4'b1110;
				localparam VX_gpu_pkg_INST_FPU_SQRT = 4'b0101;
				localparam VX_gpu_pkg_INST_FPU_U2F = 4'b1011;
				localparam VX_gpu_pkg_INST_FS = 7'b0100111;
				localparam VX_gpu_pkg_INST_I = 7'b0010011;
				localparam VX_gpu_pkg_INST_JAL = 7'b1101111;
				localparam VX_gpu_pkg_INST_JALR = 7'b1100111;
				localparam VX_gpu_pkg_INST_L = 7'b0000011;
				localparam VX_gpu_pkg_INST_LSU_FENCE = 4'b1111;
				localparam VX_gpu_pkg_INST_LSU_LBU = 4'b0100;
				localparam VX_gpu_pkg_INST_LSU_LHU = 4'b0101;
				localparam VX_gpu_pkg_INST_LUI = 7'b0110111;
				localparam VX_gpu_pkg_INST_R = 7'b0110011;
				localparam VX_gpu_pkg_INST_R_F7_MUL = 7'b0000001;
				localparam VX_gpu_pkg_INST_R_F7_ZICOND = 7'b0000111;
				localparam VX_gpu_pkg_INST_S = 7'b0100011;
				localparam VX_gpu_pkg_INST_SFU_BAR = 4'h4;
				localparam VX_gpu_pkg_INST_SFU_JOIN = 4'h3;
				localparam VX_gpu_pkg_INST_SFU_PRED = 4'h5;
				localparam VX_gpu_pkg_INST_SFU_SPLIT = 4'h2;
				localparam VX_gpu_pkg_INST_SFU_TMC = 4'h0;
				localparam VX_gpu_pkg_INST_SFU_WSPAWN = 4'h1;
				localparam VX_gpu_pkg_INST_SFU_WSYNC = 4'ha;
				localparam VX_gpu_pkg_INST_SYS = 7'b1110011;
				localparam VX_gpu_pkg_INST_WGATHER = 4'h8;
				localparam VX_gpu_pkg_REG_TYPE_BITS = 1;
				localparam VX_gpu_pkg_REG_TYPE_F = 1;
				localparam VX_gpu_pkg_REG_TYPE_I = 0;
				localparam VX_gpu_pkg_RV_RD = 0;
				localparam VX_gpu_pkg_RV_REGS_BITS = 5;
				localparam VX_gpu_pkg_RV_RS1 = 1;
				localparam VX_gpu_pkg_RV_RS2 = 2;
				localparam VX_gpu_pkg_RV_RS3 = 3;
				localparam VX_gpu_pkg_XREG_0 = 0;
				localparam VX_gpu_pkg_XREG_1 = 1;
				function automatic [3:0] VX_gpu_pkg_inst_sfu_csr;
					input reg [2:0] funct3;
					VX_gpu_pkg_inst_sfu_csr = (4'h6 + sv2v_cast_4(funct3[1:0])) - 4'h1;
				endfunction
				function automatic [5:0] VX_gpu_pkg_make_reg_num;
					input reg [0:0] rtype;
					input reg [4:0] idx;
					VX_gpu_pkg_make_reg_num = (sv2v_cast_6(rtype) << VX_gpu_pkg_RV_REGS_BITS) | sv2v_cast_6(idx);
				endfunction
				always @(*) begin
					ex_type = 1'sbx;
					op_type = 1'sbx;
					op_args = 1'sbx;
					reg_ids = 1'sbx;
					use_regs = 1'sb0;
					rd_xregs = 1'sb0;
					wr_xregs = 1'sb0;
					bytesel = VX_gpu_pkg_BYTESEL_DEFAULT;
					is_wstall = 0;
					case (opcode)
						VX_gpu_pkg_INST_I: begin
							ex_type = VX_gpu_pkg_EX_ALU;
							op_type = r_type;
							op_args[21-:2] = VX_gpu_pkg_ALU_TYPE_ARITH;
							op_args[22] = 0;
							op_args[24] = 0;
							op_args[23] = 1;
							op_args[19-:20] = {{9 {i_imm[11]}}, i_imm[10:0]};
							reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rd);
							use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
							reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
							use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
						end
						VX_gpu_pkg_INST_R: begin
							ex_type = VX_gpu_pkg_EX_ALU;
							op_args[22] = 0;
							op_args[24] = 0;
							op_args[23] = 0;
							reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rd);
							use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
							reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
							use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
							reg_ids[12+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs2);
							use_regs[VX_gpu_pkg_RV_RS2] = 1'b1;
							case (funct7)
								VX_gpu_pkg_INST_R_F7_MUL: begin
									op_type = sv2v_cast_4(m_type);
									op_args[21-:2] = VX_gpu_pkg_ALU_TYPE_MULDIV;
								end
								VX_gpu_pkg_INST_R_F7_ZICOND: begin
									op_type = (funct3[1] ? VX_gpu_pkg_INST_ALU_CZNE : VX_gpu_pkg_INST_ALU_CZEQ);
									op_args[21-:2] = VX_gpu_pkg_ALU_TYPE_ARITH;
								end
								default: begin
									op_type = r_type;
									op_args[21-:2] = VX_gpu_pkg_ALU_TYPE_ARITH;
								end
							endcase
						end
						VX_gpu_pkg_INST_LUI: begin
							ex_type = VX_gpu_pkg_EX_ALU;
							op_type = VX_gpu_pkg_INST_ALU_LUI;
							op_args[21-:2] = VX_gpu_pkg_ALU_TYPE_ARITH;
							op_args[22] = 0;
							op_args[24] = 0;
							op_args[23] = 1;
							op_args[19-:20] = ui_imm;
							reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rd);
							use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
						end
						VX_gpu_pkg_INST_AUIPC: begin
							ex_type = VX_gpu_pkg_EX_ALU;
							op_type = VX_gpu_pkg_INST_ALU_AUIPC;
							op_args[21-:2] = VX_gpu_pkg_ALU_TYPE_ARITH;
							op_args[22] = 0;
							op_args[24] = 1;
							op_args[23] = 1;
							op_args[19-:20] = ui_imm;
							reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rd);
							use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
						end
						VX_gpu_pkg_INST_JAL: begin
							ex_type = VX_gpu_pkg_EX_ALU;
							op_type = VX_gpu_pkg_INST_BR_JAL;
							op_args[21-:2] = VX_gpu_pkg_ALU_TYPE_BRANCH;
							op_args[24] = 1;
							op_args[23] = 1;
							op_args[19-:20] = jal_imm;
							op_args[22] = decode_is_rvc;
							is_wstall = 1;
							reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rd);
							use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
						end
						VX_gpu_pkg_INST_JALR: begin
							ex_type = VX_gpu_pkg_EX_ALU;
							op_type = VX_gpu_pkg_INST_BR_JALR;
							op_args[21-:2] = VX_gpu_pkg_ALU_TYPE_BRANCH;
							op_args[24] = 0;
							op_args[23] = 1;
							op_args[19-:20] = {{9 {u_12[11]}}, u_12[10:0]};
							op_args[22] = decode_is_rvc;
							is_wstall = 1;
							reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rd);
							use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
							reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
							use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
						end
						VX_gpu_pkg_INST_B: begin
							ex_type = VX_gpu_pkg_EX_ALU;
							op_type = b_type;
							op_args[21-:2] = VX_gpu_pkg_ALU_TYPE_BRANCH;
							op_args[24] = 1;
							op_args[23] = 1;
							op_args[19-:20] = {{9 {b_imm[11]}}, b_imm[10:0]};
							op_args[22] = decode_is_rvc;
							is_wstall = 1;
							reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
							use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
							reg_ids[12+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs2);
							use_regs[VX_gpu_pkg_RV_RS2] = 1'b1;
						end
						VX_gpu_pkg_INST_FENCE: begin
							ex_type = VX_gpu_pkg_EX_LSU;
							op_type = VX_gpu_pkg_INST_LSU_FENCE;
							op_args[13] = 0;
							op_args[12] = 0;
							op_args[15-:2] = 0;
							op_args[11-:12] = 0;
						end
						VX_gpu_pkg_INST_SYS:
							if (funct3[1:0] != 0) begin
								ex_type = VX_gpu_pkg_EX_SFU;
								op_type = VX_gpu_pkg_inst_sfu_csr(funct3);
								op_args[16-:12] = u_12;
								op_args[17] = funct3[2];
								op_args[4-:5] = rs1;
								rd_xregs[VX_gpu_pkg_XREG_0] = is_csr_fcsr || is_csr_fflags;
								rd_xregs[VX_gpu_pkg_XREG_1] = is_csr_fcsr || is_csr_frm;
								wr_xregs[VX_gpu_pkg_XREG_0] = csr_write && (is_csr_fcsr || is_csr_fflags);
								wr_xregs[VX_gpu_pkg_XREG_1] = csr_write && (is_csr_fcsr || is_csr_frm);
								reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rd);
								use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
								reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
								use_regs[VX_gpu_pkg_RV_RS1] = ~funct3[2];
							end
							else begin
								ex_type = VX_gpu_pkg_EX_ALU;
								op_type = s_type;
								op_args[21-:2] = VX_gpu_pkg_ALU_TYPE_BRANCH;
								op_args[23] = 1;
								op_args[24] = 1;
								op_args[19-:20] = 20'd4;
								op_args[22] = decode_is_rvc;
								is_wstall = 1;
								reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rd);
								use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
							end
						VX_gpu_pkg_INST_FL, VX_gpu_pkg_INST_L: begin
							ex_type = VX_gpu_pkg_EX_LSU;
							op_type = sv2v_cast_4({1'b0, funct3});
							op_args[13] = 0;
							op_args[12] = opcode[2];
							op_args[15-:2] = 0;
							op_args[11-:12] = u_12;
							reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
							use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
							reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(opcode[2], rd);
							use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
						end
						VX_gpu_pkg_INST_FS, VX_gpu_pkg_INST_S: begin
							ex_type = VX_gpu_pkg_EX_LSU;
							op_type = sv2v_cast_4({1'b1, funct3});
							op_args[13] = 1;
							op_args[12] = opcode[2];
							op_args[15-:2] = 0;
							op_args[11-:12] = s_imm;
							reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
							use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
							reg_ids[12+:6] = VX_gpu_pkg_make_reg_num(opcode[2], rs2);
							use_regs[VX_gpu_pkg_RV_RS2] = 1'b1;
						end
						VX_gpu_pkg_INST_FMADD, VX_gpu_pkg_INST_FMSUB, VX_gpu_pkg_INST_FNMSUB, VX_gpu_pkg_INST_FNMADD: begin
							ex_type = VX_gpu_pkg_EX_FPU;
							op_type = sv2v_cast_4({3'b001, opcode[3]});
							op_args[4-:3] = funct3;
							op_args[0] = funct2[0];
							op_args[1] = opcode[3] ^ opcode[2];
							rd_xregs[VX_gpu_pkg_XREG_1] = frm_is_dyn;
							wr_xregs[VX_gpu_pkg_XREG_0] = 1'b1;
							reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rd);
							use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
							reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rs1);
							use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
							reg_ids[12+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rs2);
							use_regs[VX_gpu_pkg_RV_RS2] = 1'b1;
							reg_ids[18+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rs3);
							use_regs[VX_gpu_pkg_RV_RS3] = 1'b1;
						end
						VX_gpu_pkg_INST_FCI: begin
							ex_type = VX_gpu_pkg_EX_FPU;
							op_args[4-:3] = funct3;
							op_args[0] = funct2[0];
							op_args[1] = rs2[1];
							wr_xregs[VX_gpu_pkg_XREG_0] = 1'b1;
							case (funct5)
								5'b00000, 5'b00001, 5'b00010: begin
									op_type = sv2v_cast_4({3'b000, funct5[1]});
									op_args[1] = funct5[0];
									rd_xregs[VX_gpu_pkg_XREG_1] = frm_is_dyn;
									reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rd);
									use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
									reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rs1);
									use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
									reg_ids[12+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rs2);
									use_regs[VX_gpu_pkg_RV_RS2] = 1'b1;
								end
								5'b00100: begin
									op_type = VX_gpu_pkg_INST_FPU_MISC;
									op_args[4-:3] = sv2v_cast_3(funct3[1:0]);
									wr_xregs[VX_gpu_pkg_XREG_0] = 1'b0;
									reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rd);
									use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
									reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rs1);
									use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
									reg_ids[12+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rs2);
									use_regs[VX_gpu_pkg_RV_RS2] = 1'b1;
								end
								5'b00101: begin
									op_type = VX_gpu_pkg_INST_FPU_MISC;
									op_args[4-:3] = sv2v_cast_3_signed((funct3[0] ? 7 : 6));
									reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rd);
									use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
									reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rs1);
									use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
									reg_ids[12+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rs2);
									use_regs[VX_gpu_pkg_RV_RS2] = 1'b1;
								end
								5'b00011: begin
									op_type = VX_gpu_pkg_INST_FPU_DIV;
									rd_xregs[VX_gpu_pkg_XREG_1] = frm_is_dyn;
									reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rd);
									use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
									reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rs1);
									use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
									reg_ids[12+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rs2);
									use_regs[VX_gpu_pkg_RV_RS2] = 1'b1;
								end
								5'b01011: begin
									op_type = VX_gpu_pkg_INST_FPU_SQRT;
									rd_xregs[VX_gpu_pkg_XREG_1] = frm_is_dyn;
									reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rd);
									use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
									reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rs1);
									use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
								end
								5'b10100: begin
									op_type = VX_gpu_pkg_INST_FPU_CMP;
									reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rd);
									use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
									reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rs1);
									use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
									reg_ids[12+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rs2);
									use_regs[VX_gpu_pkg_RV_RS2] = 1'b1;
								end
								5'b11000: begin
									op_type = (rs2[0] ? VX_gpu_pkg_INST_FPU_F2U : VX_gpu_pkg_INST_FPU_F2I);
									rd_xregs[VX_gpu_pkg_XREG_1] = frm_is_dyn;
									reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rd);
									use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
									reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rs1);
									use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
								end
								5'b11010: begin
									op_type = (rs2[0] ? VX_gpu_pkg_INST_FPU_U2F : VX_gpu_pkg_INST_FPU_I2F);
									rd_xregs[VX_gpu_pkg_XREG_1] = frm_is_dyn;
									reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rd);
									use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
									reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
									use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
								end
								5'b11100: begin
									if (funct3[0]) begin
										op_type = VX_gpu_pkg_INST_FPU_MISC;
										op_args[4-:3] = 3'sd3;
									end
									else begin
										op_type = VX_gpu_pkg_INST_FPU_MISC;
										op_args[4-:3] = 3'sd4;
									end
									wr_xregs[VX_gpu_pkg_XREG_0] = 1'b0;
									reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rd);
									use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
									reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rs1);
									use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
								end
								5'b11110: begin
									op_type = VX_gpu_pkg_INST_FPU_MISC;
									op_args[4-:3] = 3'sd5;
									wr_xregs[VX_gpu_pkg_XREG_0] = 1'b0;
									reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rd);
									use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
									reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
									use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
								end
								default:
									;
							endcase
						end
						VX_gpu_pkg_INST_EXT1:
							case (funct7)
								7'h00: begin
									ex_type = VX_gpu_pkg_EX_SFU;
									is_wstall = 1;
									case (funct3)
										3'h0: begin
											op_type = VX_gpu_pkg_INST_SFU_TMC;
											reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
											use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
										end
										3'h1: begin
											op_type = VX_gpu_pkg_INST_SFU_WSPAWN;
											reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
											use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
											reg_ids[12+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs2);
											use_regs[VX_gpu_pkg_RV_RS2] = 1'b1;
											is_wstall = 1;
										end
										3'h2: begin
											op_type = VX_gpu_pkg_INST_SFU_SPLIT;
											op_args[2] = rs2[0];
											reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
											use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
											reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rd);
											use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
										end
										3'h3: begin
											op_type = VX_gpu_pkg_INST_SFU_JOIN;
											reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
											use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
										end
										3'h4: begin
											op_type = VX_gpu_pkg_INST_SFU_BAR;
											op_args[1] = 1;
											op_args[0] = 0;
											reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
											use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
											reg_ids[12+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs2);
											use_regs[VX_gpu_pkg_RV_RS2] = 1'b1;
										end
										3'h5: begin
											op_type = VX_gpu_pkg_INST_SFU_PRED;
											op_args[2] = rd[0];
											reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
											use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
											reg_ids[12+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs2);
											use_regs[VX_gpu_pkg_RV_RS2] = 1'b1;
										end
										3'h6: begin
											op_type = VX_gpu_pkg_INST_SFU_BAR;
											op_args[1] = 0;
											op_args[0] = ~is_rd_zero;
											is_wstall = is_rd_zero;
											reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rd);
											use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
											reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
											use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
											reg_ids[12+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs2);
											use_regs[VX_gpu_pkg_RV_RS2] = 1'b1;
										end
										3'h7: op_type = VX_gpu_pkg_INST_SFU_WSYNC;
									endcase
								end
								7'h01: begin
									ex_type = VX_gpu_pkg_EX_ALU;
									op_args[21-:2] = VX_gpu_pkg_ALU_TYPE_OTHER;
									op_args[22] = 0;
									reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rd);
									use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
									reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
									use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
									if (funct3[2]) begin
										reg_ids[12+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs2);
										use_regs[VX_gpu_pkg_RV_RS2] = 1'b1;
									end
									op_type = sv2v_cast_4(funct3);
								end
								7'h04:
									case (funct3)
										3'h1: begin
											ex_type = VX_gpu_pkg_EX_LSU;
											op_type = VX_gpu_pkg_INST_LSU_LBU;
											op_args[13] = 0;
											op_args[12] = 1;
											op_args[15-:2] = 2'b01;
											op_args[11-:12] = 1'sb0;
											reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rd);
											use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
											reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
											use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
											reg_ids[12+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs2);
											use_regs[VX_gpu_pkg_RV_RS2] = 1'b1;
										end
										3'h2: begin
											ex_type = VX_gpu_pkg_EX_LSU;
											op_type = VX_gpu_pkg_INST_LSU_LHU;
											op_args[13] = 0;
											op_args[12] = 1;
											op_args[15-:2] = 2'b10;
											op_args[11-:12] = 1'sb0;
											reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_F), rd);
											use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
											reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
											use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
											reg_ids[12+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs2);
											use_regs[VX_gpu_pkg_RV_RS2] = 1'b1;
										end
										default:
											;
									endcase
								default:
									;
							endcase
						VX_gpu_pkg_INST_EXT2:
							case (funct3)
								3'h0: begin
									ex_type = VX_gpu_pkg_EX_ALU;
									op_args[21-:2] = VX_gpu_pkg_ALU_TYPE_OTHER;
									op_args[19-:20] = {{18 {1'b0}}, funct2};
									op_args[22] = 0;
									reg_ids[0+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rd);
									use_regs[VX_gpu_pkg_RV_RD] = 1'b1;
									reg_ids[6+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs1);
									use_regs[VX_gpu_pkg_RV_RS1] = 1'b1;
									reg_ids[12+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs2);
									use_regs[VX_gpu_pkg_RV_RS2] = 1'b1;
									reg_ids[18+:6] = VX_gpu_pkg_make_reg_num(sv2v_cast_1_signed(VX_gpu_pkg_REG_TYPE_I), rs3);
									use_regs[VX_gpu_pkg_RV_RS3] = 1'b1;
									op_type = VX_gpu_pkg_INST_WGATHER;
								end
								default:
									;
							endcase
						default:
							;
					endcase
				end
				wire wb = use_regs[VX_gpu_pkg_RV_RD] && (reg_ids[0+:6] != 0);
				VX_elastic_buffer #(
					.DATAW(OUT_DATAW),
					.SIZE(0)
				) req_buf(
					.clk(clk),
					.reset(reset),
					.valid_in(vortex_core_wrap.core.fetch_if.valid),
					.ready_in(vortex_core_wrap.core.fetch_if.ready),
					.data_in({vortex_core_wrap.core.fetch_if.data[115-:44], vortex_core_wrap.core.fetch_if.data[71-:2], vortex_core_wrap.core.fetch_if.data[69-:2], vortex_core_wrap.core.fetch_if.data[67-:4], vortex_core_wrap.core.fetch_if.data[63-:32], ex_type, op_type, op_args, wb, rd_xregs, wr_xregs, use_regs[3:1], reg_ids[0+:6], bytesel, reg_ids[6+:6], reg_ids[12+:6], reg_ids[18+:6]}),
					.data_out({vortex_core_wrap.core.decode_if.data[150-:44], vortex_core_wrap.core.decode_if.data[106-:2], vortex_core_wrap.core.decode_if.data[104-:2], vortex_core_wrap.core.decode_if.data[102-:4], vortex_core_wrap.core.decode_if.data[98-:32], vortex_core_wrap.core.decode_if.data[66-:2], vortex_core_wrap.core.decode_if.data[64-:4], vortex_core_wrap.core.decode_if.data[60-:25], vortex_core_wrap.core.decode_if.data[35], vortex_core_wrap.core.decode_if.data[34-:2], vortex_core_wrap.core.decode_if.data[32-:2], vortex_core_wrap.core.decode_if.data[30-:3], vortex_core_wrap.core.decode_if.data[27-:6], vortex_core_wrap.core.decode_if.data[21-:4], vortex_core_wrap.core.decode_if.data[17-:6], vortex_core_wrap.core.decode_if.data[11-:6], vortex_core_wrap.core.decode_if.data[5-:6]}),
					.valid_out(vortex_core_wrap.core.decode_if.valid),
					.ready_out(vortex_core_wrap.core.decode_if.ready)
				);
				wire fetch_fire = vortex_core_wrap.core.fetch_if.valid && vortex_core_wrap.core.fetch_if.ready;
				reg decode_sched_valid_r;
				reg decode_sched_unlock_r;
				reg [1:0] decode_sched_wid_r;
				always @(posedge clk)
					if (reset)
						decode_sched_valid_r <= 1'b0;
					else begin
						decode_sched_valid_r <= fetch_fire;
						decode_sched_unlock_r <= ~is_wstall;
						decode_sched_wid_r <= vortex_core_wrap.core.fetch_if.data[71-:2];
					end
				assign vortex_core_wrap.core.decode_sched_if.valid = decode_sched_valid_r;
				assign vortex_core_wrap.core.decode_sched_if.wid = decode_sched_wid_r;
				assign vortex_core_wrap.core.decode_sched_if.unlock = decode_sched_unlock_r;
				assign vortex_core_wrap.core.fetch_if.ibuf_pop = vortex_core_wrap.core.decode_if.ibuf_pop;
			end
			assign decode.clk = clk;
			assign decode.reset = reset;
			localparam _bbase_A82B2_writeback_if = 0;
			localparam _bbase_A82B2_dispatch_if = 0;
			localparam _bbase_A82B2_issue_sched_if = 0;
			localparam _param_A82B2_INSTANCE_ID = "";
			if (1) begin : issue
				localparam INSTANCE_ID = _param_A82B2_INSTANCE_ID;
				wire clk;
				wire reset;
				localparam _mbase_writeback_if = 0;
				localparam VX_gpu_pkg_EX_SFU = 2;
				localparam VX_gpu_pkg_EX_FPU = 3;
				localparam VX_gpu_pkg_EX_TCU = 3;
				localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
				localparam _mbase_dispatch_if = 0;
				localparam _mbase_issue_sched_if = 0;
				localparam VX_gpu_pkg_ISSUE_ISW_BITS = 0;
				localparam VX_gpu_pkg_ISSUE_ISW_W = 1;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
				function automatic [0:0] VX_gpu_pkg_wid_to_isw;
					input reg [1:0] wid;
					VX_gpu_pkg_wid_to_isw = 0;
				endfunction
				wire [0:0] decode_isw = VX_gpu_pkg_wid_to_isw(vortex_core_wrap.core.decode_if.data[106-:2]);
				wire [0:0] decode_ready_in;
				assign vortex_core_wrap.core.decode_if.ready = decode_ready_in[decode_isw];
				wire [0:0] issued_warps;
				localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
				localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
				localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
				wire [1:0] issued_warp_wis;
				genvar _gv_issue_id_1;
				function automatic [1:0] VX_gpu_pkg_wis_to_wid;
					input reg [1:0] wis;
					input reg [0:0] isw;
					VX_gpu_pkg_wis_to_wid = wis;
				endfunction
				for (_gv_issue_id_1 = 0; _gv_issue_id_1 < 1; _gv_issue_id_1 = _gv_issue_id_1 + 1) begin : g_slices
					localparam issue_id = _gv_issue_id_1;
					genvar _arr_4F9C5;
					for (_arr_4F9C5 = 0; _arr_4F9C5 <= 3; _arr_4F9C5 = _arr_4F9C5 + 1) begin : per_issue_dispatch_if
						wire valid;
						localparam VX_gpu_pkg_XLENB = 4;
						localparam VX_gpu_pkg_XLENB_W = 2;
						localparam VX_gpu_pkg_BYTESEL_BITS = 4;
						localparam VX_gpu_pkg_INST_OP_BITS = 4;
						localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
						localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
						localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
						localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
						localparam VX_gpu_pkg_NCTA_BITS = 2;
						localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
						localparam VX_gpu_pkg_REG_TYPES = 2;
						localparam VX_gpu_pkg_RV_REGS = 32;
						localparam VX_gpu_pkg_NUM_REGS = 64;
						localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
						localparam VX_gpu_pkg_NUM_XREGS = 2;
						localparam VX_gpu_pkg_PC_BITS = 32;
						localparam VX_gpu_pkg_SIMD_COUNT = 1;
						localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
						localparam VX_gpu_pkg_SIMD_IDX_W = 1;
						localparam VX_gpu_pkg_UUID_WIDTH = 44;
						localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
						localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
						localparam VX_gpu_pkg_INST_FMT_BITS = 2;
						localparam VX_gpu_pkg_INST_FRM_BITS = 3;
						wire [512:0] data;
						wire ready;
					end
					if (1) begin : slice_decode_if
						wire valid;
						localparam VX_gpu_pkg_XLENB = 4;
						localparam VX_gpu_pkg_XLENB_W = 2;
						localparam VX_gpu_pkg_BYTESEL_BITS = 4;
						localparam VX_gpu_pkg_EX_SFU = 2;
						localparam VX_gpu_pkg_EX_FPU = 3;
						localparam VX_gpu_pkg_EX_TCU = 3;
						localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
						localparam VX_gpu_pkg_EX_BITS = 2;
						localparam VX_gpu_pkg_INST_OP_BITS = 4;
						localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
						localparam VX_gpu_pkg_NCTA_BITS = 2;
						localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
						localparam VX_gpu_pkg_REG_TYPES = 2;
						localparam VX_gpu_pkg_RV_REGS = 32;
						localparam VX_gpu_pkg_NUM_REGS = 64;
						localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
						localparam VX_gpu_pkg_NUM_SRC_OPDS = 3;
						localparam VX_gpu_pkg_NUM_XREGS = 2;
						localparam VX_gpu_pkg_NW_BITS = 2;
						localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
						localparam VX_gpu_pkg_PC_BITS = 32;
						localparam VX_gpu_pkg_UUID_WIDTH = 44;
						localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
						localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
						localparam VX_gpu_pkg_INST_FMT_BITS = 2;
						localparam VX_gpu_pkg_INST_FRM_BITS = 3;
						wire [150:0] data;
						wire ready;
						wire [3:0] ibuf_pop;
					end
					assign slice_decode_if.valid = vortex_core_wrap.core.decode_if.valid && (decode_isw == issue_id);
					assign slice_decode_if.data = vortex_core_wrap.core.decode_if.data;
					assign decode_ready_in[issue_id] = slice_decode_if.ready;
					genvar _gv_w_2;
					for (_gv_w_2 = 0; _gv_w_2 < VX_gpu_pkg_PER_ISSUE_WARPS; _gv_w_2 = _gv_w_2 + 1) begin : g_ibuf_pop
						localparam w = _gv_w_2;
						assign vortex_core_wrap.core.decode_if.ibuf_pop[w] = slice_decode_if.ibuf_pop[w];
					end
					localparam _bbase_37CB8_writeback_if = _gv_issue_id_1 + _mbase_writeback_if;
					localparam _bbase_37CB8_dispatch_if = 0;
					localparam _param_37CB8_INSTANCE_ID = "";
					localparam _param_37CB8_ISSUE_ID = issue_id;
					if (1) begin : issue_slice
						localparam INSTANCE_ID = _param_37CB8_INSTANCE_ID;
						localparam ISSUE_ID = _param_37CB8_ISSUE_ID;
						wire clk;
						wire reset;
						localparam _mbase_writeback_if = _bbase_37CB8_writeback_if;
						localparam VX_gpu_pkg_EX_SFU = 2;
						localparam VX_gpu_pkg_EX_FPU = 3;
						localparam VX_gpu_pkg_EX_TCU = 3;
						localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
						localparam _mbase_dispatch_if = 0;
						wire warp_issued;
						localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
						localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
						localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
						wire [1:0] warp_issued_wis;
						genvar _arr_E93C8;
						for (_arr_E93C8 = 0; _arr_E93C8 <= 3; _arr_E93C8 = _arr_E93C8 + 1) begin : ibuffer_if
							wire valid;
							localparam VX_gpu_pkg_XLENB = 4;
							localparam VX_gpu_pkg_XLENB_W = 2;
							localparam VX_gpu_pkg_BYTESEL_BITS = 4;
							localparam VX_gpu_pkg_EX_SFU = 2;
							localparam VX_gpu_pkg_EX_FPU = 3;
							localparam VX_gpu_pkg_EX_TCU = 3;
							localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
							localparam VX_gpu_pkg_EX_BITS = 2;
							localparam VX_gpu_pkg_INST_OP_BITS = 4;
							localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
							localparam VX_gpu_pkg_NCTA_BITS = 2;
							localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
							localparam VX_gpu_pkg_REG_TYPES = 2;
							localparam VX_gpu_pkg_RV_REGS = 32;
							localparam VX_gpu_pkg_NUM_REGS = 64;
							localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
							localparam VX_gpu_pkg_NUM_SRC_OPDS = 3;
							localparam VX_gpu_pkg_NUM_XREGS = 2;
							localparam VX_gpu_pkg_NW_BITS = 2;
							localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
							localparam VX_gpu_pkg_PC_BITS = 32;
							localparam VX_gpu_pkg_UUID_WIDTH = 44;
							localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
							localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
							localparam VX_gpu_pkg_INST_FMT_BITS = 2;
							localparam VX_gpu_pkg_INST_FRM_BITS = 3;
							reg [152:0] data;
							wire ready;
						end
						if (1) begin : scoreboard_if
							wire valid;
							localparam VX_gpu_pkg_XLENB = 4;
							localparam VX_gpu_pkg_XLENB_W = 2;
							localparam VX_gpu_pkg_BYTESEL_BITS = 4;
							localparam VX_gpu_pkg_EX_SFU = 2;
							localparam VX_gpu_pkg_EX_FPU = 3;
							localparam VX_gpu_pkg_EX_TCU = 3;
							localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
							localparam VX_gpu_pkg_EX_BITS = 2;
							localparam VX_gpu_pkg_INST_OP_BITS = 4;
							localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
							localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
							localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
							localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
							localparam VX_gpu_pkg_NCTA_BITS = 2;
							localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
							localparam VX_gpu_pkg_REG_TYPES = 2;
							localparam VX_gpu_pkg_RV_REGS = 32;
							localparam VX_gpu_pkg_NUM_REGS = 64;
							localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
							localparam VX_gpu_pkg_NUM_SRC_OPDS = 3;
							localparam VX_gpu_pkg_NUM_XREGS = 2;
							localparam VX_gpu_pkg_PC_BITS = 32;
							localparam VX_gpu_pkg_UUID_WIDTH = 44;
							localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
							localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
							localparam VX_gpu_pkg_INST_FMT_BITS = 2;
							localparam VX_gpu_pkg_INST_FRM_BITS = 3;
							wire [148:0] data;
							wire ready;
						end
						if (1) begin : operands_if
							wire valid;
							localparam VX_gpu_pkg_XLENB = 4;
							localparam VX_gpu_pkg_XLENB_W = 2;
							localparam VX_gpu_pkg_BYTESEL_BITS = 4;
							localparam VX_gpu_pkg_EX_SFU = 2;
							localparam VX_gpu_pkg_EX_FPU = 3;
							localparam VX_gpu_pkg_EX_TCU = 3;
							localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
							localparam VX_gpu_pkg_EX_BITS = 2;
							localparam VX_gpu_pkg_INST_OP_BITS = 4;
							localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
							localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
							localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
							localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
							localparam VX_gpu_pkg_NCTA_BITS = 2;
							localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
							localparam VX_gpu_pkg_REG_TYPES = 2;
							localparam VX_gpu_pkg_RV_REGS = 32;
							localparam VX_gpu_pkg_NUM_REGS = 64;
							localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
							localparam VX_gpu_pkg_NUM_XREGS = 2;
							localparam VX_gpu_pkg_PC_BITS = 32;
							localparam VX_gpu_pkg_SIMD_COUNT = 1;
							localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
							localparam VX_gpu_pkg_SIMD_IDX_W = 1;
							localparam VX_gpu_pkg_UUID_WIDTH = 44;
							localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
							localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
							localparam VX_gpu_pkg_INST_FMT_BITS = 2;
							localparam VX_gpu_pkg_INST_FRM_BITS = 3;
							wire [514:0] data;
							wire ready;
						end
						wire [3:0] dispatch_ready;
						localparam _bbase_888AB_ibuffer_if = 0;
						localparam _param_888AB_INSTANCE_ID = "";
						localparam _param_888AB_ISSUE_ID = ISSUE_ID;
						if (1) begin : ibuffer
							localparam INSTANCE_ID = _param_888AB_INSTANCE_ID;
							localparam ISSUE_ID = _param_888AB_ISSUE_ID;
							wire clk;
							wire reset;
							localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
							localparam _mbase_ibuffer_if = 0;
							localparam VX_gpu_pkg_XLENB = 4;
							localparam VX_gpu_pkg_XLENB_W = 2;
							localparam VX_gpu_pkg_BYTESEL_BITS = 4;
							localparam VX_gpu_pkg_EX_SFU = 2;
							localparam VX_gpu_pkg_EX_FPU = 3;
							localparam VX_gpu_pkg_EX_TCU = 3;
							localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
							localparam VX_gpu_pkg_EX_BITS = 2;
							localparam VX_gpu_pkg_INST_OP_BITS = 4;
							localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
							localparam VX_gpu_pkg_NCTA_BITS = 2;
							localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
							localparam VX_gpu_pkg_REG_TYPES = 2;
							localparam VX_gpu_pkg_RV_REGS = 32;
							localparam VX_gpu_pkg_NUM_REGS = 64;
							localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
							localparam VX_gpu_pkg_NUM_SRC_OPDS = 3;
							localparam VX_gpu_pkg_NUM_XREGS = 2;
							localparam VX_gpu_pkg_NW_BITS = 2;
							localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
							localparam VX_gpu_pkg_PC_BITS = 32;
							localparam VX_gpu_pkg_UUID_WIDTH = 44;
							localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
							localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
							localparam VX_gpu_pkg_INST_FMT_BITS = 2;
							localparam VX_gpu_pkg_INST_FRM_BITS = 3;
							localparam OUT_DATAW = 153;
							localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
							localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
							localparam VX_gpu_pkg_ISSUE_ISW_BITS = 0;
							function automatic [1:0] VX_gpu_pkg_wid_to_wis;
								input reg [1:0] wid;
								VX_gpu_pkg_wid_to_wis = wid >> VX_gpu_pkg_ISSUE_ISW_BITS;
							endfunction
							wire [1:0] decode_wis = VX_gpu_pkg_wid_to_wis(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.data[106-:2]);
							wire [3:0] ibuf_ready_in;
							assign vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.ready = ibuf_ready_in[decode_wis];
							genvar _gv_w_1;
							localparam VX_gpu_pkg_UOP_PACKLD = 0;
							localparam VX_gpu_pkg_UOP_TCU = 1;
							localparam VX_gpu_pkg_UOP_MAX = 1;
							for (_gv_w_1 = 0; _gv_w_1 < VX_gpu_pkg_PER_ISSUE_WARPS; _gv_w_1 = _gv_w_1 + 1) begin : g_bufs
								localparam w = _gv_w_1;
								if (1) begin : ibuffer_tmp_if
									wire valid;
									localparam VX_gpu_pkg_XLENB = 4;
									localparam VX_gpu_pkg_XLENB_W = 2;
									localparam VX_gpu_pkg_BYTESEL_BITS = 4;
									localparam VX_gpu_pkg_EX_SFU = 2;
									localparam VX_gpu_pkg_EX_FPU = 3;
									localparam VX_gpu_pkg_EX_TCU = 3;
									localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
									localparam VX_gpu_pkg_EX_BITS = 2;
									localparam VX_gpu_pkg_INST_OP_BITS = 4;
									localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
									localparam VX_gpu_pkg_NCTA_BITS = 2;
									localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
									localparam VX_gpu_pkg_REG_TYPES = 2;
									localparam VX_gpu_pkg_RV_REGS = 32;
									localparam VX_gpu_pkg_NUM_REGS = 64;
									localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
									localparam VX_gpu_pkg_NUM_SRC_OPDS = 3;
									localparam VX_gpu_pkg_NUM_XREGS = 2;
									localparam VX_gpu_pkg_NW_BITS = 2;
									localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
									localparam VX_gpu_pkg_PC_BITS = 32;
									localparam VX_gpu_pkg_UUID_WIDTH = 44;
									localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
									localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
									localparam VX_gpu_pkg_INST_FMT_BITS = 2;
									localparam VX_gpu_pkg_INST_FRM_BITS = 3;
									wire [152:0] data;
									wire ready;
								end
								VX_elastic_buffer #(
									.DATAW(OUT_DATAW),
									.SIZE(4),
									.OUT_REG(1)
								) instr_buf(
									.clk(clk),
									.reset(reset),
									.valid_in(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.valid && (decode_wis == sv2v_cast_2_signed(w))),
									.data_in({vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.data[150-:44], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.data[106-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.data[104-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.data[102-:4], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.data[98-:32], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.data[66-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.data[64-:4], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.data[60-:25], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.data[35], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.data[34-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.data[32-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.data[30-:3], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.data[27-:6], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.data[21-:4], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.data[17-:6], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.data[11-:6], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.data[5-:6], 2'b11}),
									.ready_in(ibuf_ready_in[w]),
									.valid_out(ibuffer_tmp_if.valid),
									.data_out(ibuffer_tmp_if.data),
									.ready_out(ibuffer_tmp_if.ready)
								);
								assign vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].slice_decode_if.ibuf_pop[w] = ibuffer_tmp_if.valid && ibuffer_tmp_if.ready;
								if (1) begin : g_uop
									localparam _bbase_3904D_output_if = _gv_w_1 + 0;
									localparam _param_3904D_INSTANCE_ID = "";
									localparam _param_3904D_WARP_ID = w;
									if (1) begin : uop_sequencer
										reg _sv2v_0;
										localparam INSTANCE_ID = _param_3904D_INSTANCE_ID;
										localparam WARP_ID = _param_3904D_WARP_ID;
										wire clk;
										wire reset;
										localparam _mbase_output_if = _bbase_3904D_output_if;
										localparam VX_gpu_pkg_UOP_PACKLD = 0;
										localparam VX_gpu_pkg_UOP_TCU = 1;
										localparam VX_gpu_pkg_UOP_MAX = 1;
										localparam UOP_SEL_W = 1;
										wire [0:0] uop_in_valid;
										localparam VX_gpu_pkg_XLENB = 4;
										localparam VX_gpu_pkg_XLENB_W = 2;
										localparam VX_gpu_pkg_BYTESEL_BITS = 4;
										localparam VX_gpu_pkg_EX_SFU = 2;
										localparam VX_gpu_pkg_EX_FPU = 3;
										localparam VX_gpu_pkg_EX_TCU = 3;
										localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
										localparam VX_gpu_pkg_EX_BITS = 2;
										localparam VX_gpu_pkg_INST_OP_BITS = 4;
										localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
										localparam VX_gpu_pkg_NCTA_BITS = 2;
										localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
										localparam VX_gpu_pkg_REG_TYPES = 2;
										localparam VX_gpu_pkg_RV_REGS = 32;
										localparam VX_gpu_pkg_NUM_REGS = 64;
										localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
										localparam VX_gpu_pkg_NUM_SRC_OPDS = 3;
										localparam VX_gpu_pkg_NUM_XREGS = 2;
										localparam VX_gpu_pkg_NW_BITS = 2;
										localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
										localparam VX_gpu_pkg_PC_BITS = 32;
										localparam VX_gpu_pkg_UUID_WIDTH = 44;
										localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
										localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
										localparam VX_gpu_pkg_INST_FMT_BITS = 2;
										localparam VX_gpu_pkg_INST_FRM_BITS = 3;
										wire [152:0] uop_out_data [0:0];
										localparam VX_gpu_pkg_UOP_CTR_W = 8;
										wire [7:0] uop_out_count [0:0];
										reg [7:0] uop_ctr;
										reg uop_active;
										reg uop_done;
										reg [0:0] sel_idx_r;
										reg [7:0] last_ctr_r;
										reg [152:0] uop_data;
										wire [0:0] sel_idx_n;
										wire is_uop_input;
										VX_priority_encoder #(
											.N(VX_gpu_pkg_UOP_MAX),
											.REVERSE(1)
										) priority_enc(
											.data_in(uop_in_valid),
											.onehot_out(),
											.index_out(sel_idx_n),
											.valid_out(is_uop_input)
										);
										reg [152:0] uop_in_data;
										function automatic [43:0] VX_gpu_pkg_get_uop_uuid;
											input reg [43:0] uuid;
											input reg [7:0] uop_idx;
											reg [31:0] uuid_lo;
											begin
												uuid_lo = {uop_idx[0+:VX_gpu_pkg_UOP_CTR_W], uuid[0+:24]};
												VX_gpu_pkg_get_uop_uuid = {uuid[43:32], uuid_lo};
											end
										endfunction
										always @(*) begin
											if (_sv2v_0)
												;
											uop_in_data = vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer.g_bufs[_gv_w_1].ibuffer_tmp_if.data;
											uop_in_data[152-:44] = VX_gpu_pkg_get_uop_uuid(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer.g_bufs[_gv_w_1].ibuffer_tmp_if.data[152-:44], uop_ctr);
										end
										wire uop_start = (vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer.g_bufs[_gv_w_1].ibuffer_tmp_if.valid && is_uop_input) && ~uop_active;
										wire uop_next = uop_active && vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer_if[_mbase_output_if].ready;
										always @(posedge clk)
											if (reset) begin
												uop_ctr <= 1'sb0;
												sel_idx_r <= 1'sb0;
												last_ctr_r <= 1'sb0;
												uop_active <= 1'b0;
												uop_done <= 1'b0;
											end
											else if (uop_start) begin
												uop_active <= 1'b1;
												uop_ctr <= 8'sd1;
												sel_idx_r <= sel_idx_n;
												last_ctr_r <= uop_out_count[sel_idx_n] - 8'sd1;
												uop_data <= uop_out_data[sel_idx_n];
												uop_done <= uop_out_count[sel_idx_n] == 8'sd1;
											end
											else if (uop_next) begin
												uop_active <= ~uop_done;
												uop_ctr <= (uop_done ? {8 {1'sb0}} : uop_ctr + 8'sd1);
												uop_data <= uop_out_data[sel_idx_r];
												uop_done <= uop_ctr == last_ctr_r;
											end
										wire [0:0] uop_in_start;
										genvar _gv_i_113;
										for (_gv_i_113 = 0; _gv_i_113 < VX_gpu_pkg_UOP_MAX; _gv_i_113 = _gv_i_113 + 1) begin : g_start
											localparam i = _gv_i_113;
											assign uop_in_start[i] = uop_start && uop_in_valid[i];
										end
										wire [0:0] uop_in_next;
										genvar _gv_i_114;
										for (_gv_i_114 = 0; _gv_i_114 < VX_gpu_pkg_UOP_MAX; _gv_i_114 = _gv_i_114 + 1) begin : g_next
											localparam i = _gv_i_114;
											assign uop_in_next[i] = uop_next && uop_in_valid[i];
										end
										localparam VX_gpu_pkg_EX_LSU = 1;
										assign uop_in_valid[VX_gpu_pkg_UOP_PACKLD] = (uop_in_data[68-:2] == VX_gpu_pkg_EX_LSU) && (uop_in_data[53-:2] != 0);
										VX_uop_packld uop_packld(
											.clk(clk),
											.reset(reset),
											.ibuf_in(uop_in_data),
											.start(uop_in_start[VX_gpu_pkg_UOP_PACKLD]),
											.advance(uop_in_next[VX_gpu_pkg_UOP_PACKLD]),
											.uop_idx(uop_ctr),
											.ibuf_out(uop_out_data[VX_gpu_pkg_UOP_PACKLD]),
											.uop_count(uop_out_count[VX_gpu_pkg_UOP_PACKLD])
										);
										wire uop_hold = is_uop_input && ~uop_active;
										assign vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer_if[_mbase_output_if].valid = uop_active || (vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer.g_bufs[_gv_w_1].ibuffer_tmp_if.valid && ~uop_hold);
										always @(*) begin
											if (_sv2v_0)
												;
											if (uop_active)
												vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer_if[_mbase_output_if].data = uop_data;
											else
												vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer_if[_mbase_output_if].data = vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer.g_bufs[_gv_w_1].ibuffer_tmp_if.data;
										end
										assign vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer.g_bufs[_gv_w_1].ibuffer_tmp_if.ready = vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer_if[_mbase_output_if].ready && (uop_active ? uop_done : ~uop_hold);
										initial _sv2v_0 = 0;
									end
									assign uop_sequencer.clk = clk;
									assign uop_sequencer.reset = reset;
								end
							end
						end
						assign ibuffer.clk = clk;
						assign ibuffer.reset = reset;
						localparam _bbase_B0E74_writeback_if = _gv_issue_id_1 + 0;
						localparam _bbase_B0E74_ibuffer_if = 0;
						localparam _param_B0E74_INSTANCE_ID = "";
						localparam _param_B0E74_ISSUE_ID = ISSUE_ID;
						if (1) begin : scoreboard
							localparam INSTANCE_ID = _param_B0E74_INSTANCE_ID;
							localparam ISSUE_ID = _param_B0E74_ISSUE_ID;
							wire clk;
							wire reset;
							localparam VX_gpu_pkg_EX_SFU = 2;
							localparam VX_gpu_pkg_EX_FPU = 3;
							localparam VX_gpu_pkg_EX_TCU = 3;
							localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
							wire [3:0] dispatch_ready;
							localparam _mbase_writeback_if = _bbase_B0E74_writeback_if;
							localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
							localparam _mbase_ibuffer_if = 0;
							localparam VX_gpu_pkg_NUM_SRC_OPDS = 3;
							localparam NUM_OPDS = 4;
							localparam VX_gpu_pkg_XLENB = 4;
							localparam VX_gpu_pkg_XLENB_W = 2;
							localparam VX_gpu_pkg_BYTESEL_BITS = 4;
							localparam VX_gpu_pkg_EX_BITS = 2;
							localparam VX_gpu_pkg_INST_OP_BITS = 4;
							localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
							localparam VX_gpu_pkg_NCTA_BITS = 2;
							localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
							localparam VX_gpu_pkg_REG_TYPES = 2;
							localparam VX_gpu_pkg_RV_REGS = 32;
							localparam VX_gpu_pkg_NUM_REGS = 64;
							localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
							localparam VX_gpu_pkg_NUM_XREGS = 2;
							localparam VX_gpu_pkg_NW_BITS = 2;
							localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
							localparam VX_gpu_pkg_PC_BITS = 32;
							localparam VX_gpu_pkg_UUID_WIDTH = 44;
							localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
							localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
							localparam VX_gpu_pkg_INST_FMT_BITS = 2;
							localparam VX_gpu_pkg_INST_FRM_BITS = 3;
							localparam IN_DATAW = 153;
							localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
							localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
							localparam OUT_DATAW = 147;
							localparam OUT_BUF = 3;
							genvar _arr_02C31;
							for (_arr_02C31 = 0; _arr_02C31 <= 3; _arr_02C31 = _arr_02C31 + 1) begin : staging_if
								wire valid;
								localparam VX_gpu_pkg_XLENB = 4;
								localparam VX_gpu_pkg_XLENB_W = 2;
								localparam VX_gpu_pkg_BYTESEL_BITS = 4;
								localparam VX_gpu_pkg_EX_SFU = 2;
								localparam VX_gpu_pkg_EX_FPU = 3;
								localparam VX_gpu_pkg_EX_TCU = 3;
								localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
								localparam VX_gpu_pkg_EX_BITS = 2;
								localparam VX_gpu_pkg_INST_OP_BITS = 4;
								localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
								localparam VX_gpu_pkg_NCTA_BITS = 2;
								localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
								localparam VX_gpu_pkg_REG_TYPES = 2;
								localparam VX_gpu_pkg_RV_REGS = 32;
								localparam VX_gpu_pkg_NUM_REGS = 64;
								localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
								localparam VX_gpu_pkg_NUM_SRC_OPDS = 3;
								localparam VX_gpu_pkg_NUM_XREGS = 2;
								localparam VX_gpu_pkg_NW_BITS = 2;
								localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
								localparam VX_gpu_pkg_PC_BITS = 32;
								localparam VX_gpu_pkg_UUID_WIDTH = 44;
								localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
								localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
								localparam VX_gpu_pkg_INST_FMT_BITS = 2;
								localparam VX_gpu_pkg_INST_FRM_BITS = 3;
								wire [152:0] data;
								wire ready;
							end
							wire [3:0] operands_ready;
							genvar _gv_w_3;
							for (_gv_w_3 = 0; _gv_w_3 < VX_gpu_pkg_PER_ISSUE_WARPS; _gv_w_3 = _gv_w_3 + 1) begin : g_stanging_bufs
								localparam w = _gv_w_3;
								VX_pipe_buffer #(.DATAW(IN_DATAW)) stanging_buf(
									.clk(clk),
									.reset(reset),
									.valid_in(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer_if[w + _mbase_ibuffer_if].valid),
									.data_in(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer_if[w + _mbase_ibuffer_if].data),
									.ready_in(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer_if[w + _mbase_ibuffer_if].ready),
									.valid_out(staging_if[w].valid),
									.data_out(staging_if[w].data),
									.ready_out(staging_if[w].ready)
								);
							end
							genvar _gv_w_4;
							localparam VX_gpu_pkg_REG_TYPE_BITS = 1;
							localparam VX_gpu_pkg_RV_REGS_BITS = 5;
							function automatic [4:0] VX_gpu_pkg_get_reg_idx;
								input reg [5:0] reg_num;
								VX_gpu_pkg_get_reg_idx = reg_num[4:0];
							endfunction
							function automatic [0:0] VX_gpu_pkg_get_reg_type;
								input reg [5:0] reg_num;
								VX_gpu_pkg_get_reg_type = sv2v_cast_1(reg_num >> VX_gpu_pkg_RV_REGS_BITS);
							endfunction
							for (_gv_w_4 = 0; _gv_w_4 < VX_gpu_pkg_PER_ISSUE_WARPS; _gv_w_4 = _gv_w_4 + 1) begin : g_scoreboard
								localparam w = _gv_w_4;
								reg [63:0] inuse_regs;
								reg [63:0] inuse_regs_n;
								reg [1:0] inuse_xregs;
								reg [1:0] inuse_xregs_n;
								wire [3:0] operands_busy;
								wire ibuffer_fire = vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer_if[w + _mbase_ibuffer_if].valid && vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer_if[w + _mbase_ibuffer_if].ready;
								wire staging_fire = staging_if[w].valid && staging_if[w].ready;
								wire writeback_fire = (vortex_core_wrap.core.writeback_if[_mbase_writeback_if].valid && (vortex_core_wrap.core.writeback_if[_mbase_writeback_if].data[195-:2] == sv2v_cast_2_signed(w))) && vortex_core_wrap.core.writeback_if[_mbase_writeback_if].data[0];
								wire [23:0] ibf_opds;
								wire [23:0] stg_opds;
								assign ibf_opds = {vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer_if[w + _mbase_ibuffer_if].data[7-:6], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer_if[w + _mbase_ibuffer_if].data[13-:6], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer_if[w + _mbase_ibuffer_if].data[19-:6], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer_if[w + _mbase_ibuffer_if].data[29-:6]};
								assign stg_opds = {staging_if[w].data[7-:6], staging_if[w].data[13-:6], staging_if[w].data[19-:6], staging_if[w].data[29-:6]};
								wire [3:0] ibf_used_rs = {vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer_if[w + _mbase_ibuffer_if].data[32-:3], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer_if[w + _mbase_ibuffer_if].data[37]};
								wire [3:0] stg_used_rs = {staging_if[w].data[32-:3], staging_if[w].data[37]};
								wire [1:0] ibf_xregs_mask = vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer_if[w + _mbase_ibuffer_if].data[36-:2] | vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.ibuffer_if[w + _mbase_ibuffer_if].data[34-:2];
								wire [1:0] stg_xregs_mask = staging_if[w].data[36-:2] | staging_if[w].data[34-:2];
								wire [255:0] ibf_opd_mask;
								wire [255:0] stg_opd_mask;
								genvar _gv_i_107;
								for (_gv_i_107 = 0; _gv_i_107 < NUM_OPDS; _gv_i_107 = _gv_i_107 + 1) begin : g_opd_masks
									localparam i = _gv_i_107;
									genvar _gv_j_9;
									for (_gv_j_9 = 0; _gv_j_9 < VX_gpu_pkg_REG_TYPES; _gv_j_9 = _gv_j_9 + 1) begin : g_j
										localparam j = _gv_j_9;
										assign ibf_opd_mask[((i * 2) + j) * 32+:32] = (1 << VX_gpu_pkg_get_reg_idx(ibf_opds[i * 6+:6])) & {VX_gpu_pkg_RV_REGS {ibf_used_rs[i] && (VX_gpu_pkg_get_reg_type(ibf_opds[i * 6+:6]) == j)}};
										assign stg_opd_mask[((i * 2) + j) * 32+:32] = (1 << VX_gpu_pkg_get_reg_idx(stg_opds[i * 6+:6])) & {VX_gpu_pkg_RV_REGS {stg_used_rs[i] && (VX_gpu_pkg_get_reg_type(stg_opds[i * 6+:6]) == j)}};
									end
								end
								reg [63:0] wb_inuse_regs;
								reg [1:0] wb_inuse_xregs;
								always @(*) begin
									wb_inuse_regs = inuse_regs;
									wb_inuse_xregs = inuse_xregs;
									if (writeback_fire) begin
										if (vortex_core_wrap.core.writeback_if[_mbase_writeback_if].data[154])
											wb_inuse_regs[vortex_core_wrap.core.writeback_if[_mbase_writeback_if].data[151-:6]] = 0;
										wb_inuse_xregs = wb_inuse_xregs & ~vortex_core_wrap.core.writeback_if[_mbase_writeback_if].data[153-:2];
									end
								end
								always @(*) begin
									inuse_regs_n = wb_inuse_regs;
									inuse_xregs_n = wb_inuse_xregs;
									if (staging_fire) begin
										if (staging_if[w].data[37])
											inuse_regs_n = inuse_regs_n | stg_opd_mask[0+:64];
										inuse_xregs_n = inuse_xregs_n | staging_if[w].data[34-:2];
									end
								end
								wire [63:0] in_use_mask;
								wire [1:0] rd_resv_hit;
								genvar _gv_i_108;
								for (_gv_i_108 = 0; _gv_i_108 < VX_gpu_pkg_REG_TYPES; _gv_i_108 = _gv_i_108 + 1) begin : g_in_use_mask
									localparam i = _gv_i_108;
									wire [31:0] ibf_reg_mask = ((ibf_opd_mask[(0 + i) * 32+:32] | ibf_opd_mask[(2 + i) * 32+:32]) | ibf_opd_mask[(4 + i) * 32+:32]) | ibf_opd_mask[(6 + i) * 32+:32];
									wire [31:0] stg_reg_mask = ((stg_opd_mask[(0 + i) * 32+:32] | stg_opd_mask[(2 + i) * 32+:32]) | stg_opd_mask[(4 + i) * 32+:32]) | stg_opd_mask[(6 + i) * 32+:32];
									wire [31:0] regs_mask = (ibuffer_fire ? ibf_reg_mask : stg_reg_mask);
									assign in_use_mask[i * 32+:32] = wb_inuse_regs[i * VX_gpu_pkg_RV_REGS+:VX_gpu_pkg_RV_REGS] & regs_mask;
									assign rd_resv_hit[i] = |(stg_opd_mask[(0 + i) * 32+:32] & regs_mask);
								end
								wire [1:0] regs_busy;
								genvar _gv_i_109;
								for (_gv_i_109 = 0; _gv_i_109 < VX_gpu_pkg_REG_TYPES; _gv_i_109 = _gv_i_109 + 1) begin : g_regs_busy
									localparam i = _gv_i_109;
									assign regs_busy[i] = in_use_mask[i * 32+:32] != 0;
								end
								genvar _gv_i_110;
								for (_gv_i_110 = 0; _gv_i_110 < NUM_OPDS; _gv_i_110 = _gv_i_110 + 1) begin : g_operands_busy
									localparam i = _gv_i_110;
									wire [0:0] rtype = VX_gpu_pkg_get_reg_type(stg_opds[i * 6+:6]);
									assign operands_busy[i] = (in_use_mask[rtype * 32+:32] & stg_opd_mask[((i * 2) + rtype) * 32+:32]) != 0;
								end
								wire [1:0] xregs_mask = (ibuffer_fire ? ibf_xregs_mask : stg_xregs_mask);
								wire [1:0] xregs_busy = wb_inuse_xregs & xregs_mask;
								wire rd_resv_conflict = (staging_fire && staging_if[w].data[37]) && |rd_resv_hit;
								wire x_resv_conflict = staging_fire && |(staging_if[w].data[34-:2] & xregs_mask);
								reg operands_ready_r;
								always @(posedge clk) begin
									if (reset) begin
										inuse_regs <= 1'sb0;
										inuse_xregs <= 1'sb0;
									end
									else begin
										inuse_regs <= inuse_regs_n;
										inuse_xregs <= inuse_xregs_n;
									end
									operands_ready_r <= (((regs_busy == 0) && !rd_resv_conflict) && (xregs_busy == 0)) && !x_resv_conflict;
								end
								assign operands_ready[w] = operands_ready_r;
							end
							wire [3:0] arb_valid_in;
							wire [3:0] arb_suppress;
							wire [587:0] arb_data_in;
							wire [3:0] arb_ready_in;
							reg [3:0] fu_locked;
							wire [3:0] fu_lock_block;
							genvar _gv_w_5;
							for (_gv_w_5 = 0; _gv_w_5 < VX_gpu_pkg_PER_ISSUE_WARPS; _gv_w_5 = _gv_w_5 + 1) begin : g_fu_lock_block
								localparam w = _gv_w_5;
								wire [1:0] w_ex = staging_if[w].data[68-:2];
								assign fu_lock_block[w] = fu_locked[w_ex] && staging_if[w].data[1];
							end
							genvar _gv_w_6;
							for (_gv_w_6 = 0; _gv_w_6 < VX_gpu_pkg_PER_ISSUE_WARPS; _gv_w_6 = _gv_w_6 + 1) begin : g_arb_data_in
								localparam w = _gv_w_6;
								assign arb_valid_in[w] = (staging_if[w].valid && operands_ready[w]) && ~fu_lock_block[w];
								assign arb_suppress[w] = ~dispatch_ready[staging_if[w].data[68-:2]];
								assign arb_data_in[w * 147+:147] = {staging_if[w].data[152-:44], staging_if[w].data[106-:2], staging_if[w].data[104-:4], staging_if[w].data[100-:32], staging_if[w].data[68-:2], staging_if[w].data[66-:4], staging_if[w].data[62-:25], staging_if[w].data[37], staging_if[w].data[34-:2], staging_if[w].data[32-:3], staging_if[w].data[29-:6], staging_if[w].data[23-:4], staging_if[w].data[19-:6], staging_if[w].data[13-:6], staging_if[w].data[7-:6]};
								assign staging_if[w].ready = arb_ready_in[w] && operands_ready[w];
							end
							localparam LOG_NUM_REQS = 2;
							wire any_unsuppressed = |(arb_valid_in & ~arb_suppress);
							wire [3:0] eff_suppress = (any_unsuppressed ? arb_suppress : {4 {1'sb0}});
							wire arb_valid;
							wire [1:0] arb_index;
							wire [3:0] arb_onehot;
							wire arb_ready;
							VX_gto_arbiter #(.NUM_REQS(VX_gpu_pkg_PER_ISSUE_WARPS)) out_arb(
								.clk(clk),
								.reset(reset),
								.requests(arb_valid_in),
								.suppress(eff_suppress),
								.grant_valid(arb_valid),
								.grant_index(arb_index),
								.grant_onehot(arb_onehot),
								.grant_ready(arb_ready)
							);
							wire valid_out_w;
							wire [146:0] data_out_w;
							wire ready_out_w;
							assign valid_out_w = arb_valid;
							assign data_out_w = arb_data_in[arb_index * 147+:147];
							genvar _gv_i_111;
							for (_gv_i_111 = 0; _gv_i_111 < VX_gpu_pkg_PER_ISSUE_WARPS; _gv_i_111 = _gv_i_111 + 1) begin : g_arb_ready_in
								localparam i = _gv_i_111;
								assign arb_ready_in[i] = ready_out_w && arb_onehot[i];
							end
							assign arb_ready = ready_out_w;
							wire issue_fire = valid_out_w && ready_out_w;
							wire [7:0] staging_ex_vec;
							wire [3:0] staging_fu_lock_vec;
							wire [3:0] staging_fu_unlock_vec;
							genvar _gv_w_7;
							for (_gv_w_7 = 0; _gv_w_7 < VX_gpu_pkg_PER_ISSUE_WARPS; _gv_w_7 = _gv_w_7 + 1) begin : g_staging_fu_lock
								localparam w = _gv_w_7;
								assign staging_ex_vec[w * 2+:2] = staging_if[w].data[68-:2];
								assign staging_fu_lock_vec[w] = staging_if[w].data[1];
								assign staging_fu_unlock_vec[w] = staging_if[w].data[0];
							end
							wire issue_fu_lock = staging_fu_lock_vec[arb_index];
							wire issue_fu_unlock = staging_fu_unlock_vec[arb_index];
							wire [1:0] issue_ex = staging_ex_vec[arb_index * 2+:2];
							always @(posedge clk)
								if (reset)
									fu_locked <= 1'sb0;
								else if (issue_fire) begin
									if (issue_fu_lock && ~issue_fu_unlock)
										fu_locked[issue_ex] <= 1'b1;
									else if (~issue_fu_lock && issue_fu_unlock)
										fu_locked[issue_ex] <= 1'b0;
								end
							VX_elastic_buffer #(
								.DATAW(149),
								.SIZE(2),
								.OUT_REG(1),
								.LUTRAM(1'd0)
							) out_buf(
								.clk(clk),
								.reset(reset),
								.valid_in(valid_out_w),
								.ready_in(ready_out_w),
								.data_in({arb_index, data_out_w}),
								.data_out({vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.data[104-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.data[148-:44], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.data[102-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.data[100-:4], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.data[96-:32], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.data[64-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.data[62-:4], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.data[58-:25], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.data[33], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.data[32-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.data[30-:3], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.data[27-:6], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.data[21-:4], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.data[17-:6], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.data[11-:6], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.data[5-:6]}),
								.valid_out(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.valid),
								.ready_out(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.ready)
							);
						end
						assign scoreboard.clk = clk;
						assign scoreboard.reset = reset;
						assign scoreboard.dispatch_ready = dispatch_ready;
						localparam _bbase_0C0FE_writeback_if = _gv_issue_id_1 + 0;
						localparam _param_0C0FE_INSTANCE_ID = "";
						localparam _param_0C0FE_ISSUE_ID = ISSUE_ID;
						if (1) begin : operands
							localparam INSTANCE_ID = _param_0C0FE_INSTANCE_ID;
							localparam ISSUE_ID = _param_0C0FE_ISSUE_ID;
							wire clk;
							wire reset;
							localparam _mbase_writeback_if = _bbase_0C0FE_writeback_if;
							localparam VX_gpu_pkg_XLENB = 4;
							localparam VX_gpu_pkg_XLENB_W = 2;
							localparam VX_gpu_pkg_BYTESEL_BITS = 4;
							localparam VX_gpu_pkg_EX_SFU = 2;
							localparam VX_gpu_pkg_EX_FPU = 3;
							localparam VX_gpu_pkg_EX_TCU = 3;
							localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
							localparam VX_gpu_pkg_EX_BITS = 2;
							localparam VX_gpu_pkg_INST_OP_BITS = 4;
							localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
							localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
							localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
							localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
							localparam VX_gpu_pkg_NCTA_BITS = 2;
							localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
							localparam VX_gpu_pkg_REG_TYPES = 2;
							localparam VX_gpu_pkg_RV_REGS = 32;
							localparam VX_gpu_pkg_NUM_REGS = 64;
							localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
							localparam VX_gpu_pkg_NUM_XREGS = 2;
							localparam VX_gpu_pkg_PC_BITS = 32;
							localparam VX_gpu_pkg_SIMD_COUNT = 1;
							localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
							localparam VX_gpu_pkg_SIMD_IDX_W = 1;
							localparam VX_gpu_pkg_UUID_WIDTH = 44;
							localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
							localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
							localparam VX_gpu_pkg_INST_FMT_BITS = 2;
							localparam VX_gpu_pkg_INST_FRM_BITS = 3;
							localparam OUT_DATAW = 515;
							localparam OUT_ARB_STICKY = 1'd0;
							genvar _arr_D9104;
							for (_arr_D9104 = 0; _arr_D9104 <= 0; _arr_D9104 = _arr_D9104 + 1) begin : per_opc_operands_if
								wire valid;
								localparam VX_gpu_pkg_XLENB = 4;
								localparam VX_gpu_pkg_XLENB_W = 2;
								localparam VX_gpu_pkg_BYTESEL_BITS = 4;
								localparam VX_gpu_pkg_EX_SFU = 2;
								localparam VX_gpu_pkg_EX_FPU = 3;
								localparam VX_gpu_pkg_EX_TCU = 3;
								localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
								localparam VX_gpu_pkg_EX_BITS = 2;
								localparam VX_gpu_pkg_INST_OP_BITS = 4;
								localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
								localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
								localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
								localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
								localparam VX_gpu_pkg_NCTA_BITS = 2;
								localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
								localparam VX_gpu_pkg_REG_TYPES = 2;
								localparam VX_gpu_pkg_RV_REGS = 32;
								localparam VX_gpu_pkg_NUM_REGS = 64;
								localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
								localparam VX_gpu_pkg_NUM_XREGS = 2;
								localparam VX_gpu_pkg_PC_BITS = 32;
								localparam VX_gpu_pkg_SIMD_COUNT = 1;
								localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
								localparam VX_gpu_pkg_SIMD_IDX_W = 1;
								localparam VX_gpu_pkg_UUID_WIDTH = 44;
								localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
								localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
								localparam VX_gpu_pkg_INST_FMT_BITS = 2;
								localparam VX_gpu_pkg_INST_FRM_BITS = 3;
								wire [514:0] data;
								wire ready;
							end
							localparam VX_gpu_pkg_NUM_OPCS_BITS = 0;
							localparam VX_gpu_pkg_NUM_OPCS_W = 1;
							wire [0:0] sb_opc;
							wire [0:0] wb_opc;
							if (1) begin : g_wis_opc
								assign sb_opc = 0;
								assign wb_opc = 0;
							end
							wire [0:0] scoreboard_ready_in;
							assign vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.ready = scoreboard_ready_in[sb_opc];
							genvar _gv_i_99;
							for (_gv_i_99 = 0; _gv_i_99 < 1; _gv_i_99 = _gv_i_99 + 1) begin : g_collectors
								localparam i = _gv_i_99;
								if (1) begin : opc_scoreboard_if
									wire valid;
									localparam VX_gpu_pkg_XLENB = 4;
									localparam VX_gpu_pkg_XLENB_W = 2;
									localparam VX_gpu_pkg_BYTESEL_BITS = 4;
									localparam VX_gpu_pkg_EX_SFU = 2;
									localparam VX_gpu_pkg_EX_FPU = 3;
									localparam VX_gpu_pkg_EX_TCU = 3;
									localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
									localparam VX_gpu_pkg_EX_BITS = 2;
									localparam VX_gpu_pkg_INST_OP_BITS = 4;
									localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
									localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
									localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
									localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
									localparam VX_gpu_pkg_NCTA_BITS = 2;
									localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
									localparam VX_gpu_pkg_REG_TYPES = 2;
									localparam VX_gpu_pkg_RV_REGS = 32;
									localparam VX_gpu_pkg_NUM_REGS = 64;
									localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
									localparam VX_gpu_pkg_NUM_SRC_OPDS = 3;
									localparam VX_gpu_pkg_NUM_XREGS = 2;
									localparam VX_gpu_pkg_PC_BITS = 32;
									localparam VX_gpu_pkg_UUID_WIDTH = 44;
									localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
									localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
									localparam VX_gpu_pkg_INST_FMT_BITS = 2;
									localparam VX_gpu_pkg_INST_FRM_BITS = 3;
									wire [148:0] data;
									wire ready;
								end
								assign opc_scoreboard_if.valid = vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.valid && (sb_opc == i);
								assign opc_scoreboard_if.data = vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.scoreboard_if.data;
								assign scoreboard_ready_in[i] = opc_scoreboard_if.ready;
								if (1) begin : opc_writeback_if
									wire valid;
									localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
									localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
									localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
									localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
									localparam VX_gpu_pkg_NCTA_BITS = 2;
									localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
									localparam VX_gpu_pkg_REG_TYPES = 2;
									localparam VX_gpu_pkg_RV_REGS = 32;
									localparam VX_gpu_pkg_NUM_REGS = 64;
									localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
									localparam VX_gpu_pkg_NUM_XREGS = 2;
									localparam VX_gpu_pkg_PC_BITS = 32;
									localparam VX_gpu_pkg_SIMD_COUNT = 1;
									localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
									localparam VX_gpu_pkg_SIMD_IDX_W = 1;
									localparam VX_gpu_pkg_UUID_WIDTH = 44;
									localparam VX_gpu_pkg_XLENB = 4;
									wire [239:0] data;
								end
								assign opc_writeback_if.valid = (vortex_core_wrap.core.writeback_if[_mbase_writeback_if].valid && vortex_core_wrap.core.writeback_if[_mbase_writeback_if].data[154]) && (wb_opc == i);
								assign opc_writeback_if.data = vortex_core_wrap.core.writeback_if[_mbase_writeback_if].data;
								localparam _bbase_204B2_operands_if = _gv_i_99;
								localparam _param_204B2_INSTANCE_ID = "";
								localparam _param_204B2_NUM_BANKS = 4;
								localparam _param_204B2_OUT_BUF = 3;
								if (1) begin : opc_unit
									localparam INSTANCE_ID = _param_204B2_INSTANCE_ID;
									localparam NUM_BANKS = _param_204B2_NUM_BANKS;
									localparam OUT_BUF = _param_204B2_OUT_BUF;
									wire clk;
									wire reset;
									localparam _mbase_operands_if = _bbase_204B2_operands_if;
									localparam VX_gpu_pkg_NUM_SRC_OPDS = 3;
									localparam VX_gpu_pkg_SRC_OPD_BITS = 2;
									localparam VX_gpu_pkg_SRC_OPD_WIDTH = VX_gpu_pkg_SRC_OPD_BITS;
									localparam REQ_SEL_WIDTH = VX_gpu_pkg_SRC_OPD_WIDTH;
									localparam BANK_SEL_BITS = 2;
									localparam BANK_SEL_WIDTH = BANK_SEL_BITS;
									localparam BANK_DATA_WIDTH = 128;
									localparam BANK_DATA_SIZE = 16;
									localparam VX_gpu_pkg_REG_TYPES = 2;
									localparam VX_gpu_pkg_RV_REGS = 32;
									localparam VX_gpu_pkg_NUM_REGS = 64;
									localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
									localparam VX_gpu_pkg_PER_OPC_WARPS = 4;
									localparam VX_gpu_pkg_SIMD_COUNT = 1;
									localparam BANK_SIZE = 64;
									localparam BANK_ADDR_WIDTH = 6;
									localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
									localparam REG_REM_BITS = 4;
									localparam VX_gpu_pkg_XLENB = 4;
									localparam VX_gpu_pkg_XLENB_W = 2;
									localparam VX_gpu_pkg_BYTESEL_BITS = 4;
									localparam VX_gpu_pkg_EX_SFU = 2;
									localparam VX_gpu_pkg_EX_FPU = 3;
									localparam VX_gpu_pkg_EX_TCU = 3;
									localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
									localparam VX_gpu_pkg_EX_BITS = 2;
									localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
									localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
									localparam VX_gpu_pkg_INST_OP_BITS = 4;
									localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
									localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
									localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
									localparam VX_gpu_pkg_NCTA_BITS = 2;
									localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
									localparam VX_gpu_pkg_NUM_XREGS = 2;
									localparam VX_gpu_pkg_PC_BITS = 32;
									localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
									localparam VX_gpu_pkg_SIMD_IDX_W = 1;
									localparam VX_gpu_pkg_UUID_WIDTH = 44;
									localparam META_DATAW = 131;
									localparam VX_gpu_pkg_INST_FMT_BITS = 2;
									localparam VX_gpu_pkg_INST_FRM_BITS = 3;
									localparam OUT_DATAW = 515;
									wire [2:0] src_valid;
									wire [2:0] req_valid_in;
									wire [2:0] req_ready_in;
									wire [11:0] req_addr_in;
									wire [5:0] req_bank_idx;
									wire [3:0] gpr_rd_valid;
									wire [3:0] gpr_rd_ready;
									wire [3:0] gpr_rd_valid_st1;
									wire [3:0] gpr_rd_valid_st2;
									wire [15:0] gpr_rd_reg;
									wire [15:0] gpr_rd_reg_st1;
									wire [511:0] gpr_rd_data_st2;
									wire [7:0] gpr_rd_opd;
									wire [7:0] gpr_rd_opd_st1;
									wire [7:0] gpr_rd_opd_st2;
									wire [3:0] simd_out;
									wire [0:0] simd_pid;
									wire simd_sop;
									wire simd_eop;
									wire pipe_ready_in;
									wire pipe_valid_st1;
									wire pipe_ready_st1;
									wire pipe_valid_st2;
									wire pipe_ready_st2;
									wire [130:0] pipe_mdata;
									wire [130:0] pipe_mdata_st1;
									wire [130:0] pipe_mdata_st2;
									reg [383:0] opd_buffer_st2;
									reg [383:0] opd_buffer_n_st2;
									reg [2:0] opd_fetched_st1;
									reg has_collision;
									wire has_collision_st1;
									wire [17:0] src_regs;
									assign src_regs = {vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.data[5-:6], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.data[11-:6], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.data[17-:6]};
									genvar _gv_i_95;
									for (_gv_i_95 = 0; _gv_i_95 < VX_gpu_pkg_NUM_SRC_OPDS; _gv_i_95 = _gv_i_95 + 1) begin : g_gpr_rd_reg
										localparam i = _gv_i_95;
										assign req_addr_in[i * 4+:4] = src_regs[(i * 6) + 5-:REG_REM_BITS];
									end
									genvar _gv_i_96;
									for (_gv_i_96 = 0; _gv_i_96 < VX_gpu_pkg_NUM_SRC_OPDS; _gv_i_96 = _gv_i_96 + 1) begin : g_req_bank_idx
										localparam i = _gv_i_96;
										if (1) begin : g_bn
											assign req_bank_idx[i * 2+:2] = src_regs[(i * 6) + 1-:2];
										end
									end
									genvar _gv_i_97;
									for (_gv_i_97 = 0; _gv_i_97 < VX_gpu_pkg_NUM_SRC_OPDS; _gv_i_97 = _gv_i_97 + 1) begin : g_src_valid
										localparam i = _gv_i_97;
										assign src_valid[i] = (vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.data[28 + i] && (src_regs[i * 6+:6] != 0)) && ~opd_fetched_st1[i];
									end
									assign req_valid_in = {VX_gpu_pkg_NUM_SRC_OPDS {vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.valid}} & src_valid;
									VX_stream_xbar #(
										.NUM_INPUTS(VX_gpu_pkg_NUM_SRC_OPDS),
										.NUM_OUTPUTS(NUM_BANKS),
										.DATAW(REG_REM_BITS),
										.ARBITER("P"),
										.OUT_BUF(0)
									) req_xbar(
										.clk(clk),
										.reset(reset),
										.collisions(),
										.valid_in(req_valid_in),
										.data_in(req_addr_in),
										.sel_in(req_bank_idx),
										.ready_in(req_ready_in),
										.valid_out(gpr_rd_valid),
										.data_out(gpr_rd_reg),
										.sel_out(gpr_rd_opd),
										.ready_out(gpr_rd_ready)
									);
									assign gpr_rd_ready = {NUM_BANKS {pipe_ready_in}};
									always @(*) begin
										has_collision = 0;
										begin : sv2v_autoblock_5
											integer i;
											for (i = 0; i < VX_gpu_pkg_NUM_SRC_OPDS; i = i + 1)
												begin : sv2v_autoblock_6
													integer j;
													for (j = 1; j < (VX_gpu_pkg_NUM_SRC_OPDS - i); j = j + 1)
														has_collision = has_collision | ((src_valid[i] && src_valid[j + i]) && (req_bank_idx[i * 2+:2] == req_bank_idx[(j + i) * 2+:2]));
												end
										end
									end
									wire opd_last_fetch = pipe_ready_in && ~has_collision;
									VX_nz_iterator #(
										.DATAW(4),
										.N(VX_gpu_pkg_SIMD_COUNT)
									) simd_iter(
										.clk(clk),
										.reset(reset),
										.valid_in(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.valid),
										.data_in(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.data[100-:4]),
										.next(opd_last_fetch),
										.valid_out(),
										.data_out(simd_out),
										.pid(simd_pid),
										.sop(simd_sop),
										.eop(simd_eop)
									);
									assign pipe_mdata = {vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.data[148-:44], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.data[104-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.data[102-:2], simd_pid, simd_out, vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.data[96-:32], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.data[33], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.data[32-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.data[64-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.data[62-:4], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.data[58-:25], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.data[27-:6], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.data[21-:4], simd_sop, simd_eop};
									assign vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.ready = opd_last_fetch && simd_eop;
									wire pipe_fire_st1 = pipe_valid_st1 && pipe_ready_st1;
									wire pipe_fire_st2 = pipe_valid_st2 && pipe_ready_st2;
									VX_pipe_buffer #(
										.DATAW(160),
										.RESETW(1)
									) pipe_reg1(
										.clk(clk),
										.reset(reset),
										.valid_in(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_scoreboard_if.valid),
										.ready_in(pipe_ready_in),
										.data_in({gpr_rd_valid, pipe_mdata, has_collision, gpr_rd_reg, gpr_rd_opd}),
										.data_out({gpr_rd_valid_st1, pipe_mdata_st1, has_collision_st1, gpr_rd_reg_st1, gpr_rd_opd_st1}),
										.valid_out(pipe_valid_st1),
										.ready_out(pipe_ready_st1)
									);
									wire [2:0] req_fire_in = req_valid_in & req_ready_in;
									always @(posedge clk)
										if (reset || opd_last_fetch)
											opd_fetched_st1 <= 1'sb0;
										else
											opd_fetched_st1 <= opd_fetched_st1 | req_fire_in;
									wire pipe_valid2_st1 = pipe_valid_st1 && ~has_collision_st1;
									VX_pipe_buffer #(
										.DATAW(143),
										.RESETW(1)
									) pipe_reg2(
										.clk(clk),
										.reset(reset),
										.valid_in(pipe_valid2_st1),
										.ready_in(pipe_ready_st1),
										.data_in({gpr_rd_valid_st1, gpr_rd_opd_st1, pipe_mdata_st1}),
										.data_out({gpr_rd_valid_st2, gpr_rd_opd_st2, pipe_mdata_st2}),
										.valid_out(pipe_valid_st2),
										.ready_out(pipe_ready_st2)
									);
									always @(*) begin
										opd_buffer_n_st2 = opd_buffer_st2;
										begin : sv2v_autoblock_7
											integer b;
											for (b = 0; b < NUM_BANKS; b = b + 1)
												if (gpr_rd_valid_st2[b])
													opd_buffer_n_st2[gpr_rd_opd_st2[b * 2+:2] * 128+:128] = gpr_rd_data_st2[32 * (b * 4)+:128];
										end
									end
									always @(posedge clk)
										if (reset || pipe_fire_st2)
											opd_buffer_st2 <= 1'sb0;
										else
											opd_buffer_st2 <= opd_buffer_n_st2;
									wire [5:0] gpr_wr_addr;
									localparam VX_gpu_pkg_PER_OPC_NW_BITS = 2;
									localparam VX_gpu_pkg_PER_OPC_NW_W = VX_gpu_pkg_PER_OPC_NW_BITS;
									if (1) begin : g_gpr_wr_addr
										if (1) begin : genblk1
											assign gpr_wr_addr = {vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_writeback_if.data[195-:VX_gpu_pkg_PER_OPC_NW_W], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_writeback_if.data[151-:REG_REM_BITS]};
										end
									end
									wire [1:0] gpr_wr_bank_idx;
									if (1) begin : g_gpr_wr_bank_idx_bn
										assign gpr_wr_bank_idx = vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_writeback_if.data[147:146];
									end
									wire [15:0] gpr_wr_byteen;
									genvar _gv_i_98;
									for (_gv_i_98 = 0; _gv_i_98 < 4; _gv_i_98 = _gv_i_98 + 1) begin : g_gpr_wr_byteen
										localparam i = _gv_i_98;
										assign gpr_wr_byteen[i * VX_gpu_pkg_XLENB+:VX_gpu_pkg_XLENB] = vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_writeback_if.data[130 + (i * 4)+:4];
									end
									genvar _gv_b_1;
									for (_gv_b_1 = 0; _gv_b_1 < NUM_BANKS; _gv_b_1 = _gv_b_1 + 1) begin : g_gpr_rams
										localparam b = _gv_b_1;
										wire gpr_wr_enabled;
										if (1) begin : g_gpr_wr_enabled_bn
											assign gpr_wr_enabled = vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_writeback_if.valid && (gpr_wr_bank_idx == sv2v_cast_2_signed(b));
										end
										wire [5:0] gpr_rd_addr;
										if (1) begin : g_gpr_rd_addr
											if (1) begin : genblk1
												assign gpr_rd_addr = {pipe_mdata_st1[86-:VX_gpu_pkg_PER_OPC_NW_W], gpr_rd_reg_st1[b * 4+:4]};
											end
										end
										VX_dp_ram #(
											.DATAW(BANK_DATA_WIDTH),
											.SIZE(BANK_SIZE),
											.WRENW(BANK_DATA_SIZE),
											.OUT_REG(1),
											.RDW_MODE("R")
										) gpr_ram(
											.clk(clk),
											.reset(reset),
											.read(pipe_fire_st1 && gpr_rd_valid_st1[b]),
											.wren(gpr_wr_byteen),
											.write(gpr_wr_enabled),
											.waddr(gpr_wr_addr),
											.wdata(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.g_collectors[_gv_i_99].opc_writeback_if.data[129-:128]),
											.raddr(gpr_rd_addr),
											.rdata(gpr_rd_data_st2[32 * (b * 4)+:128])
										);
									end
									VX_elastic_buffer #(
										.DATAW(OUT_DATAW),
										.SIZE(2),
										.OUT_REG(1)
									) out_buf(
										.clk(clk),
										.reset(reset),
										.valid_in(pipe_valid_st2),
										.ready_in(pipe_ready_st2),
										.data_in({pipe_mdata_st2[130:2], opd_buffer_n_st2, pipe_mdata_st2[1:0]}),
										.data_out({vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].data[514-:44], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].data[470-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].data[468-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].data[466], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].data[465-:4], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].data[461-:32], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].data[398], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].data[397-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].data[429-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].data[427-:4], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].data[423-:25], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].data[395-:6], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].data[389-:4], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].data[129-:128], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].data[257-:128], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].data[385-:128], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].data[1], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].data[0]}),
										.valid_out(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].valid),
										.ready_out(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands.per_opc_operands_if[_mbase_operands_if].ready)
									);
								end
								assign opc_unit.clk = clk;
								assign opc_unit.reset = reset;
							end
							wire [0:0] per_opc_operands_valid;
							wire [514:0] per_opc_operands_data;
							wire [0:0] per_opc_operands_ready;
							genvar _gv_i_100;
							for (_gv_i_100 = 0; _gv_i_100 < 1; _gv_i_100 = _gv_i_100 + 1) begin : genblk3
								localparam i = _gv_i_100;
								assign per_opc_operands_valid[i] = per_opc_operands_if[i].valid;
								assign per_opc_operands_data[i * 515+:515] = per_opc_operands_if[i].data;
								assign per_opc_operands_if[i].ready = per_opc_operands_ready[i];
							end
							VX_stream_arb #(
								.NUM_INPUTS(1),
								.NUM_OUTPUTS(1),
								.DATAW(OUT_DATAW),
								.ARBITER("R"),
								.STICKY(OUT_ARB_STICKY),
								.OUT_BUF(0)
							) output_arb(
								.clk(clk),
								.reset(reset),
								.valid_in(per_opc_operands_valid),
								.data_in(per_opc_operands_data),
								.ready_in(per_opc_operands_ready),
								.valid_out(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.valid),
								.data_out(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data),
								.ready_out(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.ready),
								.sel_out()
							);
						end
						assign operands.clk = clk;
						assign operands.reset = reset;
						localparam _bbase_A927E_dispatch_if = 0;
						localparam _param_A927E_INSTANCE_ID = "";
						localparam _param_A927E_ISSUE_ID = ISSUE_ID;
						if (1) begin : dispatcher
							reg _sv2v_0;
							localparam INSTANCE_ID = _param_A927E_INSTANCE_ID;
							localparam ISSUE_ID = _param_A927E_ISSUE_ID;
							wire clk;
							wire reset;
							localparam VX_gpu_pkg_EX_SFU = 2;
							localparam VX_gpu_pkg_EX_FPU = 3;
							localparam VX_gpu_pkg_EX_TCU = 3;
							localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
							wire [3:0] dispatch_ready;
							localparam _mbase_dispatch_if = 0;
							localparam VX_gpu_pkg_XLENB = 4;
							localparam VX_gpu_pkg_XLENB_W = 2;
							localparam VX_gpu_pkg_BYTESEL_BITS = 4;
							localparam VX_gpu_pkg_INST_OP_BITS = 4;
							localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
							localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
							localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
							localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
							localparam VX_gpu_pkg_NCTA_BITS = 2;
							localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
							localparam VX_gpu_pkg_REG_TYPES = 2;
							localparam VX_gpu_pkg_RV_REGS = 32;
							localparam VX_gpu_pkg_NUM_REGS = 64;
							localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
							localparam VX_gpu_pkg_NUM_XREGS = 2;
							localparam VX_gpu_pkg_PC_BITS = 32;
							localparam VX_gpu_pkg_SIMD_COUNT = 1;
							localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
							localparam VX_gpu_pkg_SIMD_IDX_W = 1;
							localparam VX_gpu_pkg_UUID_WIDTH = 44;
							localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
							localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
							localparam VX_gpu_pkg_INST_FMT_BITS = 2;
							localparam VX_gpu_pkg_INST_FRM_BITS = 3;
							localparam OUT_DATAW = 513;
							wire [3:0] operands_ready_in;
							assign vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.ready = operands_ready_in[vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[429-:2]];
							assign dispatch_ready = operands_ready_in;
							genvar _gv_i_69;
							localparam VX_gpu_pkg_EX_BITS = 2;
							localparam VX_gpu_pkg_EX_LSU = 1;
							for (_gv_i_69 = 0; _gv_i_69 < VX_gpu_pkg_NUM_EX_UNITS; _gv_i_69 = _gv_i_69 + 1) begin : g_buffers
								localparam i = _gv_i_69;
								if (i != VX_gpu_pkg_EX_LSU) begin : g_non_lsu
									VX_elastic_buffer #(
										.DATAW(OUT_DATAW),
										.SIZE(2),
										.OUT_REG(1)
									) buffer(
										.clk(clk),
										.reset(reset),
										.valid_in(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.valid && (vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[429-:2] == sv2v_cast_2_signed(i))),
										.ready_in(operands_ready_in[i]),
										.data_in({vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[514-:44], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[470-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[468-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[466], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[465-:4], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[461-:32], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[398], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[397-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[395-:6], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[389-:4], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[427-:4], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[423-:25], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[385-:128], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[257-:128], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[129-:128], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[1], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[0]}),
										.data_out(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].per_issue_dispatch_if[i + _mbase_dispatch_if].data),
										.valid_out(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].per_issue_dispatch_if[i + _mbase_dispatch_if].valid),
										.ready_out(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].per_issue_dispatch_if[i + _mbase_dispatch_if].ready)
									);
								end
							end
							wire [127:0] eff_rs1_data;
							reg [24:0] eff_op_args;
							wire is_pack_lsu = vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[414-:2] != 2'b00;
							wire [1:0] pld_uop_idx = vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[400:399];
							genvar _gv_j_4;
							for (_gv_j_4 = 0; _gv_j_4 < 4; _gv_j_4 = _gv_j_4 + 1) begin : g_eff_rs1
								localparam j = _gv_j_4;
								wire [31:0] stride_off = ({32 {pld_uop_idx[0]}} & (vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[130 + (j * 32)+:32] << 0)) + ({32 {pld_uop_idx[1]}} & (vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[130 + (j * 32)+:32] << 1));
								assign eff_rs1_data[j * 32+:32] = (is_pack_lsu ? vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[258 + (j * 32)+:32] + stride_off : vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[258 + (j * 32)+:32]);
							end
							always @(*) begin
								if (_sv2v_0)
									;
								eff_op_args = vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[423-:25];
								if (is_pack_lsu)
									eff_op_args[11-:12] = 1'sb0;
							end
							VX_elastic_buffer #(
								.DATAW(OUT_DATAW),
								.SIZE(2),
								.OUT_REG(1)
							) lsu_buffer(
								.clk(clk),
								.reset(reset),
								.valid_in(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.valid && (vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[429-:2] == sv2v_cast_2_signed(VX_gpu_pkg_EX_LSU))),
								.ready_in(operands_ready_in[VX_gpu_pkg_EX_LSU]),
								.data_in({vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[514-:44], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[470-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[468-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[466], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[465-:4], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[461-:32], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[398], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[397-:2], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[395-:6], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[389-:4], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[427-:4], eff_op_args, eff_rs1_data, vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[257-:128], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[129-:128], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[1], vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].issue_slice.operands_if.data[0]}),
								.data_out(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].per_issue_dispatch_if[1].data),
								.valid_out(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].per_issue_dispatch_if[1].valid),
								.ready_out(vortex_core_wrap.core.issue.g_slices[_gv_issue_id_1].per_issue_dispatch_if[1].ready)
							);
							initial _sv2v_0 = 0;
						end
						assign dispatcher.clk = clk;
						assign dispatcher.reset = reset;
						assign dispatch_ready = dispatcher.dispatch_ready;
						wire scoreboard_fire = scoreboard_if.valid && scoreboard_if.ready;
						assign warp_issued = scoreboard_fire;
						assign warp_issued_wis = scoreboard_if.data[104-:2];
					end
					assign issue_slice.clk = clk;
					assign issue_slice.reset = reset;
					assign issued_warps[issue_id] = issue_slice.warp_issued;
					assign issued_warp_wis[issue_id * 2+:2] = issue_slice.warp_issued_wis;
					genvar _gv_ex_id_1;
					for (_gv_ex_id_1 = 0; _gv_ex_id_1 < VX_gpu_pkg_NUM_EX_UNITS; _gv_ex_id_1 = _gv_ex_id_1 + 1) begin : g_dispatch_if
						localparam ex_id = _gv_ex_id_1;
						assign vortex_core_wrap.core.dispatch_if[((ex_id * 1) + issue_id) + _mbase_dispatch_if].valid = per_issue_dispatch_if[ex_id].valid;
						assign vortex_core_wrap.core.dispatch_if[((ex_id * 1) + issue_id) + _mbase_dispatch_if].data = per_issue_dispatch_if[ex_id].data;
						assign per_issue_dispatch_if[ex_id].ready = vortex_core_wrap.core.dispatch_if[((ex_id * 1) + issue_id) + _mbase_dispatch_if].ready;
					end
				end
				genvar _gv_i_71;
				for (_gv_i_71 = 0; _gv_i_71 < 1; _gv_i_71 = _gv_i_71 + 1) begin : g_issue_sched
					localparam i = _gv_i_71;
					wire issued_r;
					wire [1:0] issued_wis_r;
					VX_pipe_register #(
						.DATAW(1),
						.RESETW(1),
						.DEPTH(1)
					) __buffer_ex95(
						.clk(clk),
						.reset(reset),
						.enable(1'b1),
						.data_in(issued_warps[i]),
						.data_out(issued_r)
					);
					VX_pipe_register #(
						.DATAW(2),
						.RESETW(2),
						.DEPTH(1)
					) __buffer_ex96(
						.clk(clk),
						.reset(reset),
						.enable(1'b1),
						.data_in(issued_warp_wis[i * 2+:2]),
						.data_out(issued_wis_r)
					);
					assign vortex_core_wrap.core.issue_sched_if[i + _mbase_issue_sched_if].valid = issued_r;
					assign vortex_core_wrap.core.issue_sched_if[i + _mbase_issue_sched_if].wis = issued_wis_r;
				end
			end
			assign issue.clk = clk;
			assign issue.reset = reset;
			localparam _bbase_5E3AF_lsu_client_if = 0;
			localparam _bbase_5E3AF_dispatch_if = 0;
			localparam _bbase_5E3AF_commit_if = 0;
			localparam _bbase_5E3AF_branch_ctl_if = 0;
			localparam _param_5E3AF_INSTANCE_ID = "";
			localparam _param_5E3AF_CORE_ID = CORE_ID;
			if (1) begin : execute
				localparam INSTANCE_ID = _param_5E3AF_INSTANCE_ID;
				localparam CORE_ID = _param_5E3AF_CORE_ID;
				wire clk;
				wire reset;
				localparam _mbase_lsu_client_if = 0;
				localparam VX_gpu_pkg_EX_SFU = 2;
				localparam VX_gpu_pkg_EX_FPU = 3;
				localparam VX_gpu_pkg_EX_TCU = 3;
				localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
				localparam _mbase_dispatch_if = 0;
				localparam _mbase_commit_if = 0;
				localparam _mbase_branch_ctl_if = 0;
				genvar _arr_7D224;
				for (_arr_7D224 = 0; _arr_7D224 <= 0; _arr_7D224 = _arr_7D224 + 1) begin : fpu_csr_if
					wire write_enable;
					localparam VX_gpu_pkg_NW_BITS = 2;
					localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
					wire [1:0] write_wid;
					wire [4:0] write_fflags;
					wire [1:0] read_wid;
					localparam VX_gpu_pkg_INST_FRM_BITS = 3;
					wire [2:0] read_frm;
				end
				localparam VX_gpu_pkg_EX_ALU = 0;
				localparam _bbase_E25F5_dispatch_if = 0;
				localparam _bbase_E25F5_commit_if = 0;
				localparam _bbase_E25F5_branch_ctl_if = 0;
				localparam _param_E25F5_INSTANCE_ID = "";
				if (1) begin : alu_unit
					localparam INSTANCE_ID = _param_E25F5_INSTANCE_ID;
					wire clk;
					wire reset;
					localparam _mbase_dispatch_if = _bbase_E25F5_dispatch_if;
					localparam _mbase_commit_if = _bbase_E25F5_commit_if;
					localparam _mbase_branch_ctl_if = 0;
					localparam BLOCK_SIZE = 1;
					localparam NUM_LANES = 4;
					localparam PARTIAL_BW = 1'd0;
					localparam PE_COUNT = 2;
					localparam PE_SEL_BITS = 1;
					localparam PE_IDX_INT = 0;
					localparam PE_IDX_MDV = 1;
					localparam VX_gpu_pkg_INST_OP_BITS = 4;
					localparam VX_gpu_pkg_XLENB = 4;
					localparam VX_gpu_pkg_XLENB_W = 2;
					localparam VX_gpu_pkg_BYTESEL_BITS = 4;
					localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
					localparam VX_gpu_pkg_NCTA_BITS = 2;
					localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
					localparam VX_gpu_pkg_REG_TYPES = 2;
					localparam VX_gpu_pkg_RV_REGS = 32;
					localparam VX_gpu_pkg_NUM_REGS = 64;
					localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
					localparam VX_gpu_pkg_NUM_XREGS = 2;
					localparam VX_gpu_pkg_NW_BITS = 2;
					localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
					localparam VX_gpu_pkg_PC_BITS = 32;
					localparam VX_gpu_pkg_UUID_WIDTH = 44;
					localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
					localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
					localparam VX_gpu_pkg_INST_FMT_BITS = 2;
					localparam VX_gpu_pkg_INST_FRM_BITS = 3;
					genvar _arr_BC53E;
					for (_arr_BC53E = 0; _arr_BC53E <= 0; _arr_BC53E = _arr_BC53E + 1) begin : per_block_execute_if
						wire valid;
						wire [512:0] data;
						wire ready;
					end
					genvar _arr_19541;
					for (_arr_19541 = 0; _arr_19541 <= 0; _arr_19541 = _arr_19541 + 1) begin : per_block_result_if
						wire valid;
						wire [227:0] data;
						wire ready;
					end
					localparam _bbase_9C05E_dispatch_if = 0;
					localparam _bbase_9C05E_execute_if = 0;
					localparam _param_9C05E_BLOCK_SIZE = BLOCK_SIZE;
					localparam _param_9C05E_NUM_LANES = NUM_LANES;
					localparam _param_9C05E_OUT_BUF = (PARTIAL_BW ? 3 : 0);
					if (1) begin : lane_dispatch
						localparam BLOCK_SIZE = _param_9C05E_BLOCK_SIZE;
						localparam NUM_LANES = _param_9C05E_NUM_LANES;
						localparam OUT_BUF = _param_9C05E_OUT_BUF;
						localparam MAX_FANOUT = 8;
						wire clk;
						wire reset;
						localparam _mbase_dispatch_if = _bbase_9C05E_dispatch_if;
						localparam _mbase_execute_if = 0;
						localparam VX_gpu_pkg_XLENB = 4;
						localparam VX_gpu_pkg_XLENB_W = 2;
						localparam VX_gpu_pkg_BYTESEL_BITS = 4;
						localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
						localparam VX_gpu_pkg_NCTA_BITS = 2;
						localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
						localparam VX_gpu_pkg_REG_TYPES = 2;
						localparam VX_gpu_pkg_RV_REGS = 32;
						localparam VX_gpu_pkg_NUM_REGS = 64;
						localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
						localparam VX_gpu_pkg_NUM_XREGS = 2;
						localparam VX_gpu_pkg_NW_BITS = 2;
						localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
						localparam VX_gpu_pkg_PC_BITS = 32;
						localparam VX_gpu_pkg_UUID_WIDTH = 44;
						localparam VX_gpu_pkg_INST_OP_BITS = 4;
						localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
						localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
						localparam VX_gpu_pkg_INST_FMT_BITS = 2;
						localparam VX_gpu_pkg_INST_FRM_BITS = 3;
						localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
						localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
						localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
						localparam VX_gpu_pkg_SIMD_COUNT = 1;
						localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
						localparam VX_gpu_pkg_SIMD_IDX_W = 1;
						localparam IN_DATAW = 513;
						localparam OUT_DATAW = 513;
						localparam BLOCK_SIZE_W = 1;
						localparam NUM_PACKETS = 1;
						localparam LPID_BITS = 0;
						localparam LPID_WIDTH = 1;
						localparam GPID_BITS = 0;
						localparam GPID_WIDTH = 1;
						localparam BATCH_COUNT = 1;
						localparam BATCH_COUNT_W = 1;
						localparam ISSUE_W = 1;
						localparam FANOUT_ENABLE = 1'd0;
						localparam DATA_IN_TMASK_OFF = 460;
						localparam DATA_IN_OPDS_OFF = 2;
						wire [0:0] dispatch_valid;
						wire [512:0] dispatch_data;
						wire [0:0] dispatch_ready;
						genvar _gv_i_74;
						for (_gv_i_74 = 0; _gv_i_74 < 1; _gv_i_74 = _gv_i_74 + 1) begin : g_dispatch_data
							localparam i = _gv_i_74;
							assign dispatch_valid[i] = vortex_core_wrap.core.dispatch_if[i + _mbase_dispatch_if].valid;
							assign dispatch_data[i * IN_DATAW+:IN_DATAW] = vortex_core_wrap.core.dispatch_if[i + _mbase_dispatch_if].data;
							assign vortex_core_wrap.core.dispatch_if[i + _mbase_dispatch_if].ready = dispatch_ready[i];
						end
						wire [0:0] block_ready;
						wire [3:0] block_tmask;
						wire [383:0] block_rsdata;
						wire [0:0] block_pid;
						wire [0:0] block_sop;
						wire [0:0] block_eop;
						wire [0:0] block_done;
						wire batch_done = &block_done;
						wire [0:0] batch_idx;
						if (1) begin : g_batch_idx_0
							assign batch_idx = 0;
						end
						wire [0:0] issue_indices;
						genvar _gv_block_idx_3;
						for (_gv_block_idx_3 = 0; _gv_block_idx_3 < BLOCK_SIZE; _gv_block_idx_3 = _gv_block_idx_3 + 1) begin : g_issue_indices
							localparam block_idx = _gv_block_idx_3;
							assign issue_indices[block_idx+:1] = sv2v_cast_1(batch_idx * BLOCK_SIZE) + sv2v_cast_1_signed(block_idx);
						end
						genvar _gv_block_idx_4;
						localparam VX_gpu_pkg_ISSUE_ISW_BITS = 0;
						localparam VX_gpu_pkg_ISSUE_ISW_W = 1;
						localparam VX_gpu_pkg_NUM_SRC_OPDS = 3;
						function automatic [1:0] VX_gpu_pkg_wis_to_wid;
							input reg [1:0] wis;
							input reg [0:0] isw;
							VX_gpu_pkg_wis_to_wid = wis;
						endfunction
						for (_gv_block_idx_4 = 0; _gv_block_idx_4 < BLOCK_SIZE; _gv_block_idx_4 = _gv_block_idx_4 + 1) begin : g_blocks
							localparam block_idx = _gv_block_idx_4;
							wire [0:0] issue_idx = issue_indices[block_idx+:1];
							wire [1:0] dispatch_wis = dispatch_data[(issue_idx * IN_DATAW) + 467+:VX_gpu_pkg_ISSUE_WIS_W];
							wire [1:0] dispatch_cta_id = dispatch_data[(issue_idx * IN_DATAW) + 465+:VX_gpu_pkg_NCTA_WIDTH];
							wire [0:0] dispatch_sid = dispatch_data[(issue_idx * IN_DATAW) + 464+:VX_gpu_pkg_SIMD_IDX_W];
							wire dispatch_sop = dispatch_data[(issue_idx * IN_DATAW) + 1];
							wire dispatch_eop = dispatch_data[issue_idx * IN_DATAW];
							wire [3:0] dispatch_tmask;
							wire [383:0] dispatch_rsdata;
							assign dispatch_tmask = dispatch_data[(issue_idx * IN_DATAW) + DATA_IN_TMASK_OFF+:4];
							assign dispatch_rsdata[0+:128] = dispatch_data[(issue_idx * IN_DATAW) + 258+:128];
							assign dispatch_rsdata[128+:128] = dispatch_data[(issue_idx * IN_DATAW) + 130+:128];
							assign dispatch_rsdata[256+:128] = dispatch_data[(issue_idx * IN_DATAW) + 2+:128];
							wire valid_p;
							wire ready_p;
							if (1) begin : g_full_simd
								assign valid_p = dispatch_valid[issue_idx];
								assign block_tmask[block_idx * 4+:4] = dispatch_tmask;
								assign block_rsdata[32 * (4 * (block_idx * 3))+:384] = dispatch_rsdata;
								assign block_pid[block_idx+:1] = 0;
								assign block_sop[block_idx] = 1;
								assign block_eop[block_idx] = 1;
								assign block_ready[block_idx] = ready_p;
								assign block_done[block_idx] = ready_p || ~valid_p;
							end
							wire [0:0] isw;
							if (1) begin : g_isw
								assign isw = block_idx;
							end
							wire [1:0] block_wid = VX_gpu_pkg_wis_to_wid(dispatch_wis, isw);
							wire [0:0] warp_pid = block_pid[block_idx+:1] + sv2v_cast_1(dispatch_sid * NUM_PACKETS);
							wire warp_sop = block_sop[block_idx] && dispatch_sop;
							wire warp_eop = block_eop[block_idx] && dispatch_eop;
							VX_elastic_buffer #(
								.DATAW(OUT_DATAW),
								.SIZE(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : 2)),
								.OUT_REG(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : (OUT_BUF & 7) - 2))
							) buf_out(
								.clk(clk),
								.reset(reset),
								.valid_in(valid_p),
								.ready_in(ready_p),
								.data_in({dispatch_data[(issue_idx * IN_DATAW) + 512-:VX_gpu_pkg_UUID_WIDTH], block_wid, dispatch_cta_id, block_tmask[block_idx * 4+:4], warp_pid, warp_sop, warp_eop, dispatch_data[(issue_idx * IN_DATAW) + 459-:74], block_rsdata[32 * ((block_idx * 3) * 4)+:128], block_rsdata[32 * (((block_idx * 3) + 1) * 4)+:128], block_rsdata[32 * (((block_idx * 3) + 2) * 4)+:128]}),
								.data_out(vortex_core_wrap.core.execute.alu_unit.per_block_execute_if[block_idx + _mbase_execute_if].data),
								.valid_out(vortex_core_wrap.core.execute.alu_unit.per_block_execute_if[block_idx + _mbase_execute_if].valid),
								.ready_out(vortex_core_wrap.core.execute.alu_unit.per_block_execute_if[block_idx + _mbase_execute_if].ready)
							);
						end
						reg [0:0] ready_in;
						always @(*) begin
							ready_in = 0;
							begin : sv2v_autoblock_8
								integer block_idx;
								for (block_idx = 0; block_idx < BLOCK_SIZE; block_idx = block_idx + 1)
									ready_in[issue_indices[block_idx+:1]] = block_ready[block_idx] && block_eop[block_idx];
							end
						end
						assign dispatch_ready = ready_in;
					end
					assign lane_dispatch.clk = clk;
					assign lane_dispatch.reset = reset;
					genvar _gv_block_idx_1;
					localparam VX_gpu_pkg_ALU_TYPE_MULDIV = 2;
					for (_gv_block_idx_1 = 0; _gv_block_idx_1 < BLOCK_SIZE; _gv_block_idx_1 = _gv_block_idx_1 + 1) begin : g_blocks
						localparam block_idx = _gv_block_idx_1;
						genvar _arr_83131;
						for (_arr_83131 = 0; _arr_83131 <= 1; _arr_83131 = _arr_83131 + 1) begin : pe_execute_if
							wire valid;
							wire [512:0] data;
							wire ready;
						end
						genvar _arr_4269E;
						for (_arr_4269E = 0; _arr_4269E <= 1; _arr_4269E = _arr_4269E + 1) begin : pe_result_if
							wire valid;
							wire [227:0] data;
							wire ready;
						end
						reg [0:0] pe_select;
						always @(*) begin
							pe_select = PE_IDX_INT;
							if (per_block_execute_if[block_idx].data[405-:2] == VX_gpu_pkg_ALU_TYPE_MULDIV)
								pe_select = PE_IDX_MDV;
						end
						localparam _bbase_EBE19_execute_in_if = _gv_block_idx_1;
						localparam _bbase_EBE19_result_out_if = _gv_block_idx_1;
						localparam _bbase_EBE19_execute_out_if = 0;
						localparam _bbase_EBE19_result_in_if = 0;
						localparam _param_EBE19_PE_COUNT = PE_COUNT;
						localparam _param_EBE19_NUM_LANES = NUM_LANES;
						localparam _param_EBE19_ARBITER = "R";
						localparam _param_EBE19_REQ_OUT_BUF = 0;
						localparam _param_EBE19_RSP_OUT_BUF = (PARTIAL_BW ? 1 : 3);
						if (1) begin : pe_switch
							localparam PE_COUNT = _param_EBE19_PE_COUNT;
							localparam NUM_LANES = _param_EBE19_NUM_LANES;
							localparam REQ_OUT_BUF = _param_EBE19_REQ_OUT_BUF;
							localparam RSP_OUT_BUF = _param_EBE19_RSP_OUT_BUF;
							localparam ARBITER = _param_EBE19_ARBITER;
							localparam PE_SEL_BITS = 1;
							wire clk;
							wire reset;
							wire [0:0] pe_sel;
							localparam _mbase_execute_in_if = _bbase_EBE19_execute_in_if;
							localparam _mbase_result_out_if = _bbase_EBE19_result_out_if;
							localparam _mbase_execute_out_if = 0;
							localparam _mbase_result_in_if = 0;
							localparam VX_gpu_pkg_XLENB = 4;
							localparam VX_gpu_pkg_XLENB_W = 2;
							localparam VX_gpu_pkg_BYTESEL_BITS = 4;
							localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
							localparam VX_gpu_pkg_NCTA_BITS = 2;
							localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
							localparam VX_gpu_pkg_REG_TYPES = 2;
							localparam VX_gpu_pkg_RV_REGS = 32;
							localparam VX_gpu_pkg_NUM_REGS = 64;
							localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
							localparam VX_gpu_pkg_NUM_XREGS = 2;
							localparam VX_gpu_pkg_NW_BITS = 2;
							localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
							localparam VX_gpu_pkg_PC_BITS = 32;
							localparam VX_gpu_pkg_UUID_WIDTH = 44;
							localparam VX_gpu_pkg_INST_OP_BITS = 4;
							localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
							localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
							localparam VX_gpu_pkg_INST_FMT_BITS = 2;
							localparam VX_gpu_pkg_INST_FRM_BITS = 3;
							localparam REQ_DATAW = 513;
							localparam RSP_DATAW = 228;
							wire [1:0] pe_req_valid;
							wire [1025:0] pe_req_data;
							wire [1:0] pe_req_ready;
							VX_stream_switch #(
								.DATAW(REQ_DATAW),
								.NUM_INPUTS(1),
								.NUM_OUTPUTS(PE_COUNT),
								.OUT_BUF(REQ_OUT_BUF)
							) req_switch(
								.clk(clk),
								.reset(reset),
								.sel_in(pe_sel),
								.valid_in(vortex_core_wrap.core.execute.alu_unit.per_block_execute_if[_mbase_execute_in_if].valid),
								.ready_in(vortex_core_wrap.core.execute.alu_unit.per_block_execute_if[_mbase_execute_in_if].ready),
								.data_in(vortex_core_wrap.core.execute.alu_unit.per_block_execute_if[_mbase_execute_in_if].data),
								.data_out(pe_req_data),
								.valid_out(pe_req_valid),
								.ready_out(pe_req_ready)
							);
							genvar _gv_i_101;
							for (_gv_i_101 = 0; _gv_i_101 < PE_COUNT; _gv_i_101 = _gv_i_101 + 1) begin : g_execute_out_if
								localparam i = _gv_i_101;
								assign vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[i + _mbase_execute_out_if].valid = pe_req_valid[i];
								assign vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[i + _mbase_execute_out_if].data = pe_req_data[i * 513+:513];
								assign pe_req_ready[i] = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[i + _mbase_execute_out_if].ready;
							end
							wire [1:0] pe_rsp_valid;
							wire [455:0] pe_rsp_data;
							wire [1:0] pe_rsp_ready;
							genvar _gv_i_102;
							for (_gv_i_102 = 0; _gv_i_102 < PE_COUNT; _gv_i_102 = _gv_i_102 + 1) begin : g_result_in_if
								localparam i = _gv_i_102;
								assign pe_rsp_valid[i] = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_result_if[i + _mbase_result_in_if].valid;
								assign pe_rsp_data[i * 228+:228] = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_result_if[i + _mbase_result_in_if].data;
								assign vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_result_if[i + _mbase_result_in_if].ready = pe_rsp_ready[i];
							end
							VX_stream_arb #(
								.NUM_INPUTS(PE_COUNT),
								.DATAW(RSP_DATAW),
								.ARBITER(ARBITER),
								.OUT_BUF(RSP_OUT_BUF)
							) rsp_arb(
								.clk(clk),
								.reset(reset),
								.valid_in(pe_rsp_valid),
								.ready_in(pe_rsp_ready),
								.data_in(pe_rsp_data),
								.data_out(vortex_core_wrap.core.execute.alu_unit.per_block_result_if[_mbase_result_out_if].data),
								.valid_out(vortex_core_wrap.core.execute.alu_unit.per_block_result_if[_mbase_result_out_if].valid),
								.ready_out(vortex_core_wrap.core.execute.alu_unit.per_block_result_if[_mbase_result_out_if].ready),
								.sel_out()
							);
						end
						assign pe_switch.clk = clk;
						assign pe_switch.reset = reset;
						assign pe_switch.pe_sel = pe_select;
						localparam _bbase_BD9C7_execute_if = PE_IDX_INT;
						localparam _bbase_BD9C7_branch_ctl_if = _gv_block_idx_1 + _mbase_branch_ctl_if;
						localparam _bbase_BD9C7_result_if = PE_IDX_INT;
						localparam _param_BD9C7_INSTANCE_ID = "";
						localparam _param_BD9C7_BLOCK_IDX = block_idx;
						localparam _param_BD9C7_NUM_LANES = NUM_LANES;
						if (1) begin : alu_int
							localparam INSTANCE_ID = _param_BD9C7_INSTANCE_ID;
							localparam BLOCK_IDX = _param_BD9C7_BLOCK_IDX;
							localparam NUM_LANES = _param_BD9C7_NUM_LANES;
							wire clk;
							wire reset;
							localparam _mbase_execute_if = _bbase_BD9C7_execute_if;
							localparam _mbase_result_if = _bbase_BD9C7_result_if;
							localparam _mbase_branch_ctl_if = _bbase_BD9C7_branch_ctl_if;
							localparam LANE_BITS = 2;
							localparam LANE_WIDTH = LANE_BITS;
							localparam SHIFT_IMM_BITS = 5;
							wire [127:0] add_result;
							wire [131:0] sub_result;
							reg [127:0] shr_zic_result;
							reg [127:0] msc_result;
							wire [127:0] add_result_w;
							wire [127:0] sub_result_w;
							wire [127:0] shr_result_w;
							reg [127:0] msc_result_w;
							reg [127:0] vote_result;
							wire [127:0] shfl_result;
							reg [127:0] alu_result;
							wire [127:0] alu_result_r;
							wire is_alu_w = 0;
							localparam VX_gpu_pkg_INST_ALU_BITS = 4;
							wire [3:0] alu_op = sv2v_cast_4(vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[412-:4]);
							localparam VX_gpu_pkg_INST_BR_BITS = 4;
							wire [3:0] br_op = sv2v_cast_4(vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[412-:4]);
							localparam VX_gpu_pkg_ALU_TYPE_BRANCH = 1;
							wire is_br_op = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[405-:2] == VX_gpu_pkg_ALU_TYPE_BRANCH;
							localparam VX_gpu_pkg_ALU_TYPE_ARITH = 0;
							wire is_alu_op = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[405-:2] == VX_gpu_pkg_ALU_TYPE_ARITH;
							function automatic VX_gpu_pkg_inst_alu_is_sub;
								input reg [3:0] op;
								VX_gpu_pkg_inst_alu_is_sub = op[1];
							endfunction
							wire is_sub_op = VX_gpu_pkg_inst_alu_is_sub(alu_op);
							function automatic VX_gpu_pkg_inst_alu_signed;
								input reg [3:0] op;
								VX_gpu_pkg_inst_alu_signed = op[0];
							endfunction
							wire is_signed = VX_gpu_pkg_inst_alu_signed(alu_op);
							function automatic [1:0] VX_gpu_pkg_inst_alu_class;
								input reg [3:0] op;
								VX_gpu_pkg_inst_alu_class = op[3:2];
							endfunction
							function automatic [1:0] VX_gpu_pkg_inst_br_class;
								input reg [3:0] op;
								VX_gpu_pkg_inst_br_class = {1'b0, ~op[3]};
							endfunction
							wire [1:0] op_class = (is_br_op ? VX_gpu_pkg_inst_br_class(alu_op) : VX_gpu_pkg_inst_alu_class(alu_op));
							wire [127:0] alu_in1 = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[383-:128];
							wire [127:0] alu_in2 = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[255-:128];
							wire [1:0] wg_src_offset = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[385:384];
							localparam VX_gpu_pkg_INST_BR_JAL = 4'b1000;
							wire is_br_jal_op = is_br_op && (br_op <= VX_gpu_pkg_INST_BR_JAL);
							localparam VX_gpu_pkg_INST_ALU_AUIPC = 4'b0011;
							localparam VX_gpu_pkg_INST_ALU_LUI = 4'b0010;
							wire is_lui_op = is_alu_op && ((alu_op == VX_gpu_pkg_INST_ALU_LUI) || (alu_op == VX_gpu_pkg_INST_ALU_AUIPC));
							wire [31:0] lui_imm32 = {vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[403-:20], 12'd0};
							wire [20:0] br_imm21 = {vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[403-:20], 1'b0};
							wire [31:0] alu_imm = {{13 {vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[403]}}, vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[402:384]};
							wire [31:0] lui_imm = {lui_imm32[31], lui_imm32[30:0]};
							wire [31:0] br_imm = {{12 {br_imm21[20]}}, br_imm21[19:0]};
							wire [31:0] add_imm = (is_lui_op ? lui_imm : (is_br_jal_op ? br_imm : alu_imm));
							localparam VX_gpu_pkg_PC_BITS = 32;
							function automatic [31:0] VX_gpu_pkg_to_fullPC;
								input reg [31:0] pc;
								VX_gpu_pkg_to_fullPC = pc;
							endfunction
							wire [127:0] add_in1_PC = (vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[0].data[408] ? {NUM_LANES {VX_gpu_pkg_to_fullPC(vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[457-:32])}} : alu_in1);
							wire [127:0] add_in2_imm = (vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[0].data[407] ? {NUM_LANES {add_imm}} : alu_in2);
							wire [127:0] sub_in2_imm = (vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[0].data[407] && ~is_br_op ? {NUM_LANES {alu_imm}} : alu_in2);
							wire [127:0] alu_in2_imm = (vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[0].data[407] ? {NUM_LANES {alu_imm}} : alu_in2);
							genvar _gv_i_43;
							for (_gv_i_43 = 0; _gv_i_43 < NUM_LANES; _gv_i_43 = _gv_i_43 + 1) begin : g_add_result
								localparam i = _gv_i_43;
								assign add_result[i * 32+:32] = add_in1_PC[i * 32+:32] + add_in2_imm[i * 32+:32];
								assign add_result_w[i * 32+:32] = sv2v_cast_32_signed($signed(alu_in1[(i * 32) + 31-:32] + alu_in2_imm[(i * 32) + 31-:32]));
							end
							genvar _gv_i_44;
							for (_gv_i_44 = 0; _gv_i_44 < NUM_LANES; _gv_i_44 = _gv_i_44 + 1) begin : g_sub_result
								localparam i = _gv_i_44;
								wire [32:0] sub_in1 = {is_signed & alu_in1[(i * 32) + 31], alu_in1[i * 32+:32]};
								wire [32:0] sub_in2 = {is_signed & sub_in2_imm[(i * 32) + 31], sub_in2_imm[i * 32+:32]};
								assign sub_result[i * 33+:33] = sub_in1 - sub_in2;
								assign sub_result_w[i * 32+:32] = sv2v_cast_32_signed($signed(alu_in1[(i * 32) + 31-:32] - alu_in2_imm[(i * 32) + 31-:32]));
							end
							genvar _gv_i_45;
							for (_gv_i_45 = 0; _gv_i_45 < NUM_LANES; _gv_i_45 = _gv_i_45 + 1) begin : g_shr_result
								localparam i = _gv_i_45;
								wire [32:0] shr_in1 = {is_signed && alu_in1[(i * 32) + 31], alu_in1[i * 32+:32]};
								always @(*)
									case (alu_op[1:0])
										2'b10, 2'b11: shr_zic_result[i * 32+:32] = alu_in1[i * 32+:32] & {32 {alu_op[0] ^ |alu_in2[i * 32+:32]}};
										default: shr_zic_result[i * 32+:32] = sv2v_cast_32_signed($signed(shr_in1) >>> alu_in2_imm[(i * 32) + 4-:5]);
									endcase
								wire [32:0] shr_in1_w = {is_signed && alu_in1[(i * 32) + 31], alu_in1[(i * 32) + 31-:32]};
								wire [31:0] shr_res_w = sv2v_cast_32_signed($signed(shr_in1_w) >>> alu_in2_imm[(i * 32) + 4-:5]);
								assign shr_result_w[i * 32+:32] = sv2v_cast_32_signed($signed(shr_res_w));
							end
							genvar _gv_i_46;
							for (_gv_i_46 = 0; _gv_i_46 < NUM_LANES; _gv_i_46 = _gv_i_46 + 1) begin : g_msc_result
								localparam i = _gv_i_46;
								always @(*)
									case (alu_op[1:0])
										2'b00: msc_result[i * 32+:32] = alu_in1[i * 32+:32] & alu_in2_imm[i * 32+:32];
										2'b01: msc_result[i * 32+:32] = alu_in1[i * 32+:32] | alu_in2_imm[i * 32+:32];
										2'b10: msc_result[i * 32+:32] = alu_in1[i * 32+:32] ^ alu_in2_imm[i * 32+:32];
										2'b11: msc_result[i * 32+:32] = alu_in1[i * 32+:32] << alu_in2_imm[(i * 32) + 4-:5];
									endcase
								wire [32:1] sv2v_tmp_DB37F;
								assign sv2v_tmp_DB37F = sv2v_cast_32_signed($signed(alu_in1[(i * 32) + 31-:32] << alu_in2_imm[(i * 32) + 4-:5]));
								always @(*) msc_result_w[i * 32+:32] = sv2v_tmp_DB37F;
							end
							wire [3:0] vote_true;
							wire [3:0] vote_false;
							genvar _gv_i_47;
							for (_gv_i_47 = 0; _gv_i_47 < NUM_LANES; _gv_i_47 = _gv_i_47 + 1) begin : g_vote_calc
								localparam i = _gv_i_47;
								wire pred = alu_in1[i * 32];
								assign vote_true[i] = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[461 + i] && pred;
								assign vote_false[i] = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[461 + i] && ~pred;
							end
							wire has_vote_true = |vote_true;
							wire has_vote_false = |vote_false;
							wire vote_all = ~has_vote_false;
							wire vote_any = has_vote_true;
							wire vote_none = ~has_vote_true;
							wire vote_uni = vote_all || vote_none;
							genvar _gv_i_48;
							localparam VX_gpu_pkg_INST_VOTE_ALL = 2'b00;
							localparam VX_gpu_pkg_INST_VOTE_ANY = 2'b01;
							localparam VX_gpu_pkg_INST_VOTE_BAL = 2'b11;
							localparam VX_gpu_pkg_INST_VOTE_UNI = 2'b10;
							for (_gv_i_48 = 0; _gv_i_48 < NUM_LANES; _gv_i_48 = _gv_i_48 + 1) begin : g_vote_result
								localparam i = _gv_i_48;
								always @(*)
									case (alu_op[1:0])
										VX_gpu_pkg_INST_VOTE_ALL: vote_result[i * 32+:32] = sv2v_cast_32(vote_all);
										VX_gpu_pkg_INST_VOTE_ANY: vote_result[i * 32+:32] = sv2v_cast_32(vote_any);
										VX_gpu_pkg_INST_VOTE_UNI: vote_result[i * 32+:32] = sv2v_cast_32(vote_uni);
										VX_gpu_pkg_INST_VOTE_BAL: vote_result[i * 32+:32] = sv2v_cast_32(vote_true);
									endcase
							end
							wire [127:0] wgather_result;
							if (1) begin : g_wgather
								wire [127:0] alu_in3 = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[127-:128];
								genvar _gv_i_49;
								for (_gv_i_49 = 0; _gv_i_49 < NUM_LANES; _gv_i_49 = _gv_i_49 + 1) begin : g_i
									localparam i = _gv_i_49;
									wire [1:0] group_base = sv2v_cast_2_signed(i) & ~2'sd3;
									wire [1:0] src_lane = group_base | wg_src_offset;
									wire [1:0] offset = sv2v_cast_2_signed(i) - wg_src_offset;
									assign wgather_result[i * 32+:32] = (offset == 2'd1 ? alu_in1[src_lane * 32+:32] : (offset == 2'd2 ? alu_in2[src_lane * 32+:32] : (offset == 2'd3 ? alu_in3[src_lane * 32+:32] : 32'sd0)));
								end
							end
							localparam VX_gpu_pkg_INST_SHFL_BFLY = 2'b10;
							localparam VX_gpu_pkg_INST_SHFL_DOWN = 2'b01;
							localparam VX_gpu_pkg_INST_SHFL_IDX = 2'b11;
							localparam VX_gpu_pkg_INST_SHFL_UP = 2'b00;
							if (1) begin : g_shfl
								genvar _gv_i_50;
								for (_gv_i_50 = 0; _gv_i_50 < NUM_LANES; _gv_i_50 = _gv_i_50 + 1) begin : g_i
									localparam i = _gv_i_50;
									wire [1:0] bval = alu_in2[i * 32+:LANE_BITS];
									wire [1:0] cval = alu_in2[(i * 32) + 6+:LANE_BITS];
									wire [1:0] mask = alu_in2[(i * 32) + 12+:LANE_BITS];
									wire [1:0] minLane = sv2v_cast_2_signed(i) & mask;
									wire [1:0] maxLane = minLane | (cval & ~mask);
									wire [LANE_BITS:0] lane_up = sv2v_cast_2_signed(i) - bval;
									wire [LANE_BITS:0] lane_down = sv2v_cast_2_signed(i) + bval;
									wire [1:0] lane_bfly = sv2v_cast_2_signed(i) ^ bval;
									wire [1:0] lane_idx = minLane | (bval & ~mask);
									reg [1:0] lane;
									always @(*) begin
										lane = sv2v_cast_2_signed(i);
										case (alu_op[1:0])
											VX_gpu_pkg_INST_SHFL_UP:
												if ($signed(lane_up) >= $signed({1'b0, minLane}))
													lane = lane_up[1:0];
											VX_gpu_pkg_INST_SHFL_DOWN:
												if (lane_down <= {1'b0, maxLane})
													lane = lane_down[1:0];
											VX_gpu_pkg_INST_SHFL_BFLY:
												if (lane_bfly <= maxLane)
													lane = lane_bfly;
											VX_gpu_pkg_INST_SHFL_IDX:
												if (lane_idx <= maxLane)
													lane = lane_idx;
										endcase
									end
									assign shfl_result[i * 32+:32] = (vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[0].data[461 + lane] ? alu_in1[lane * 32+:32] : alu_in1[i * 32+:32]);
								end
							end
							genvar _gv_i_51;
							localparam VX_gpu_pkg_ALU_TYPE_OTHER = 3;
							for (_gv_i_51 = 0; _gv_i_51 < NUM_LANES; _gv_i_51 = _gv_i_51 + 1) begin : g_alu_result
								localparam i = _gv_i_51;
								wire [31:0] slt_br_result = sv2v_cast_32({is_br_op && ~(|sub_result[(i * 33) + 31-:32]), sub_result[(i * 33) + 32]});
								wire [31:0] sub_slt_br_result = (is_sub_op && ~is_br_op ? sub_result[(i * 33) + 31-:32] : slt_br_result);
								always @(*)
									if (vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[405-:2] == VX_gpu_pkg_ALU_TYPE_OTHER)
										case (alu_op[3:2])
											2'b00: alu_result[i * 32+:32] = vote_result[i * 32+:32];
											2'b01: alu_result[i * 32+:32] = shfl_result[i * 32+:32];
											2'b10: alu_result[i * 32+:32] = wgather_result[i * 32+:32];
											default: alu_result[i * 32+:32] = vote_result[i * 32+:32];
										endcase
									else
										case ({is_alu_w, op_class})
											3'b000: alu_result[i * 32+:32] = add_result[i * 32+:32];
											3'b001: alu_result[i * 32+:32] = sub_slt_br_result;
											3'b010: alu_result[i * 32+:32] = shr_zic_result[i * 32+:32];
											3'b011: alu_result[i * 32+:32] = msc_result[i * 32+:32];
											3'b100: alu_result[i * 32+:32] = add_result_w[i * 32+:32];
											3'b101: alu_result[i * 32+:32] = sub_result_w[i * 32+:32];
											3'b110: alu_result[i * 32+:32] = shr_result_w[i * 32+:32];
											3'b111: alu_result[i * 32+:32] = msc_result_w[i * 32+:32];
										endcase
							end
							wire [3:0] br_op_r;
							wire [31:0] cbr_dest;
							wire [31:0] cbr_dest_r;
							wire [1:0] last_tid;
							wire [1:0] last_tid_r;
							wire is_br_op_r;
							function automatic [31:0] VX_gpu_pkg_from_fullPC;
								input reg [31:0] pc;
								VX_gpu_pkg_from_fullPC = pc;
							endfunction
							assign cbr_dest = VX_gpu_pkg_from_fullPC(add_result[0+:32]);
							if (1) begin : g_last_tid
								VX_priority_encoder #(
									.N(NUM_LANES),
									.REVERSE(1)
								) last_tid_sel(
									.data_in(vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[464-:4]),
									.index_out(last_tid),
									.onehot_out(),
									.valid_out()
								);
							end
							wire [3:0] wg_src_mask;
							genvar _gv_k_2;
							for (_gv_k_2 = 0; _gv_k_2 < NUM_LANES; _gv_k_2 = _gv_k_2 + 1) begin : g_wg_src_mask
								localparam k = _gv_k_2;
								assign wg_src_mask[k] = sv2v_cast_2_signed(k) == wg_src_offset;
							end
							localparam VX_gpu_pkg_XLENB = 4;
							localparam VX_gpu_pkg_XLENB_W = 2;
							localparam VX_gpu_pkg_BYTESEL_BITS = 4;
							localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
							localparam VX_gpu_pkg_NCTA_BITS = 2;
							localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
							localparam VX_gpu_pkg_REG_TYPES = 2;
							localparam VX_gpu_pkg_RV_REGS = 32;
							localparam VX_gpu_pkg_NUM_REGS = 64;
							localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
							localparam VX_gpu_pkg_NUM_XREGS = 2;
							localparam VX_gpu_pkg_NW_BITS = 2;
							localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
							localparam VX_gpu_pkg_UUID_WIDTH = 44;
							reg [99:0] alu_hdr_in;
							always @(*) begin
								alu_hdr_in = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[512-:100];
								if ((vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[405-:2] == VX_gpu_pkg_ALU_TYPE_OTHER) && alu_op[3])
									alu_hdr_in[51-:4] = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[464-:4] & ~wg_src_mask;
							end
							VX_elastic_buffer #(.DATAW(267)) rsp_buf(
								.clk(clk),
								.reset(reset),
								.valid_in(vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].valid),
								.ready_in(vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].ready),
								.data_in({alu_hdr_in, alu_result, cbr_dest, is_br_op, br_op, last_tid}),
								.data_out({vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_result_if[_mbase_result_if].data[227-:100], alu_result_r, cbr_dest_r, is_br_op_r, br_op_r, last_tid_r}),
								.valid_out(vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_result_if[_mbase_result_if].valid),
								.ready_out(vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_result_if[_mbase_result_if].ready)
							);
							function automatic VX_gpu_pkg_inst_br_is_neg;
								input reg [3:0] op;
								VX_gpu_pkg_inst_br_is_neg = op[1];
							endfunction
							wire is_br_neg = VX_gpu_pkg_inst_br_is_neg(br_op_r);
							function automatic VX_gpu_pkg_inst_br_is_less;
								input reg [3:0] op;
								VX_gpu_pkg_inst_br_is_less = op[2];
							endfunction
							wire is_br_less = VX_gpu_pkg_inst_br_is_less(br_op_r);
							function automatic VX_gpu_pkg_inst_br_is_static;
								input reg [3:0] op;
								VX_gpu_pkg_inst_br_is_static = op[3];
							endfunction
							wire is_br_static = VX_gpu_pkg_inst_br_is_static(br_op_r);
							localparam VX_gpu_pkg_INST_BR_EBREAK = 4'b1011;
							localparam VX_gpu_pkg_INST_BR_ECALL = 4'b1010;
							wire is_trap_entry = is_br_op_r && ((br_op_r == VX_gpu_pkg_INST_BR_ECALL) || (br_op_r == VX_gpu_pkg_INST_BR_EBREAK));
							localparam VX_gpu_pkg_INST_BR_MRET = 4'b1110;
							localparam VX_gpu_pkg_INST_BR_SRET = 4'b1101;
							localparam VX_gpu_pkg_INST_BR_URET = 4'b1100;
							wire is_mret_op = is_br_op_r && (((br_op_r == VX_gpu_pkg_INST_BR_MRET) || (br_op_r == VX_gpu_pkg_INST_BR_SRET)) || (br_op_r == VX_gpu_pkg_INST_BR_URET));
							wire [3:0] br_trap_cause = (br_op_r == VX_gpu_pkg_INST_BR_EBREAK ? 4'd3 : 4'd11);
							wire [31:0] br_result = alu_result_r[last_tid_r * 32+:32];
							wire is_less = br_result[0];
							wire is_equal = br_result[1];
							wire result_fire = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_result_if[_mbase_result_if].valid && vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_result_if[_mbase_result_if].ready;
							wire br_enable = (result_fire && is_br_op_r) && vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_result_if[_mbase_result_if].data[173];
							wire br_taken = ((is_br_less ? is_less : is_equal) ^ is_br_neg) | is_br_static;
							wire [31:0] br_dest = (is_trap_entry ? vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_result_if[_mbase_result_if].data[172-:32] : (is_br_static ? VX_gpu_pkg_from_fullPC(br_result) : cbr_dest_r));
							wire [1:0] br_wid;
							if (1) begin : genblk12
								assign br_wid = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_result_if[_mbase_result_if].data[183-:2];
							end
							VX_pipe_register #(
								.DATAW(42),
								.RESETW(1)
							) branch_reg(
								.clk(clk),
								.reset(reset),
								.enable(1'b1),
								.data_in({br_enable, br_wid, br_taken, br_dest, is_trap_entry, is_mret_op, br_trap_cause}),
								.data_out({vortex_core_wrap.core.branch_ctl_if[_mbase_branch_ctl_if].valid, vortex_core_wrap.core.branch_ctl_if[_mbase_branch_ctl_if].wid, vortex_core_wrap.core.branch_ctl_if[_mbase_branch_ctl_if].taken, vortex_core_wrap.core.branch_ctl_if[_mbase_branch_ctl_if].dest, vortex_core_wrap.core.branch_ctl_if[_mbase_branch_ctl_if].is_trap, vortex_core_wrap.core.branch_ctl_if[_mbase_branch_ctl_if].is_mret, vortex_core_wrap.core.branch_ctl_if[_mbase_branch_ctl_if].trap_cause})
							);
							wire [31:0] current_pc = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_result_if[_mbase_result_if].data[172-:32];
							genvar _gv_i_52;
							for (_gv_i_52 = 0; _gv_i_52 < NUM_LANES; _gv_i_52 = _gv_i_52 + 1) begin : g_result
								localparam i = _gv_i_52;
								wire [31:0] PC_next = VX_gpu_pkg_to_fullPC(current_pc) + 32'sd4;
								assign vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_result_if[_mbase_result_if].data[0 + (i * 32)+:32] = (is_br_op_r && is_br_static ? PC_next : alu_result_r[i * 32+:32]);
							end
						end
						assign alu_int.clk = clk;
						assign alu_int.reset = reset;
						localparam _bbase_C4E61_execute_if = PE_IDX_MDV;
						localparam _bbase_C4E61_result_if = PE_IDX_MDV;
						localparam _param_C4E61_INSTANCE_ID = "";
						localparam _param_C4E61_NUM_LANES = NUM_LANES;
						if (1) begin : muldiv_unit
							localparam INSTANCE_ID = _param_C4E61_INSTANCE_ID;
							localparam NUM_LANES = _param_C4E61_NUM_LANES;
							wire clk;
							wire reset;
							localparam _mbase_execute_if = _bbase_C4E61_execute_if;
							localparam _mbase_result_if = _bbase_C4E61_result_if;
							localparam VX_gpu_pkg_XLENB = 4;
							localparam VX_gpu_pkg_XLENB_W = 2;
							localparam VX_gpu_pkg_BYTESEL_BITS = 4;
							localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
							localparam VX_gpu_pkg_NCTA_BITS = 2;
							localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
							localparam VX_gpu_pkg_REG_TYPES = 2;
							localparam VX_gpu_pkg_RV_REGS = 32;
							localparam VX_gpu_pkg_NUM_REGS = 64;
							localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
							localparam VX_gpu_pkg_NUM_XREGS = 2;
							localparam VX_gpu_pkg_NW_BITS = 2;
							localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
							localparam VX_gpu_pkg_PC_BITS = 32;
							localparam VX_gpu_pkg_UUID_WIDTH = 44;
							localparam TAG_WIDTH = 100;
							localparam VX_gpu_pkg_INST_M_BITS = 3;
							wire [2:0] muldiv_op = sv2v_cast_3(vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[412-:4]);
							function automatic VX_gpu_pkg_inst_m_is_mulx;
								input reg [2:0] op;
								VX_gpu_pkg_inst_m_is_mulx = ~op[2];
							endfunction
							wire is_mulx_op = VX_gpu_pkg_inst_m_is_mulx(muldiv_op);
							function automatic VX_gpu_pkg_inst_m_signed;
								input reg [2:0] op;
								VX_gpu_pkg_inst_m_signed = ~op[0];
							endfunction
							wire is_signed_op = VX_gpu_pkg_inst_m_signed(muldiv_op);
							wire is_alu_w = 0;
							wire [127:0] mul_result_out;
							wire [99:0] mul_hdr_out;
							wire mul_valid_in = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].valid && is_mulx_op;
							wire mul_ready_in;
							wire mul_valid_out;
							wire mul_ready_out;
							function automatic VX_gpu_pkg_inst_m_is_mulh;
								input reg [2:0] op;
								VX_gpu_pkg_inst_m_is_mulh = op[1:0] != 0;
							endfunction
							wire is_mulh_in = VX_gpu_pkg_inst_m_is_mulh(muldiv_op);
							function automatic VX_gpu_pkg_inst_m_signed_a;
								input reg [2:0] op;
								VX_gpu_pkg_inst_m_signed_a = op[1:0] != 1;
							endfunction
							wire is_signed_mul_a = VX_gpu_pkg_inst_m_signed_a(muldiv_op);
							wire is_signed_mul_b = is_signed_op;
							wire [263:0] mul_result_tmp;
							wire is_mulh_out;
							wire is_mul_w_out;
							genvar _gv_i_53;
							for (_gv_i_53 = 0; _gv_i_53 < NUM_LANES; _gv_i_53 = _gv_i_53 + 1) begin : g_multiplier
								localparam i = _gv_i_53;
								wire [32:0] mul_in1 = {is_signed_mul_a && vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[256 + ((i * 32) + 31)], vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[256 + (i * 32)+:32]};
								wire [32:0] mul_in2 = {is_signed_mul_b && vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[128 + ((i * 32) + 31)], vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[128 + (i * 32)+:32]};
								VX_multiplier #(
									.A_WIDTH(33),
									.B_WIDTH(33),
									.R_WIDTH(66),
									.SIGNED(1),
									.LATENCY(3)
								) multiplier(
									.clk(clk),
									.enable(mul_ready_in),
									.dataa(mul_in1),
									.datab(mul_in2),
									.result(mul_result_tmp[i * 66+:66])
								);
							end
							VX_shift_register #(
								.DATAW(103),
								.DEPTH(3),
								.RESETW(1)
							) mul_shift_reg(
								.clk(clk),
								.reset(reset),
								.enable(mul_ready_in),
								.data_in({mul_valid_in, vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[512-:100], is_mulh_in, is_alu_w}),
								.data_out({mul_valid_out, mul_hdr_out, is_mulh_out, is_mul_w_out})
							);
							assign mul_ready_in = mul_ready_out || ~mul_valid_out;
							genvar _gv_i_54;
							for (_gv_i_54 = 0; _gv_i_54 < NUM_LANES; _gv_i_54 = _gv_i_54 + 1) begin : g_mul_result_out
								localparam i = _gv_i_54;
								assign mul_result_out[i * 32+:32] = (is_mulh_out ? mul_result_tmp[(i * 66) + 63-:32] : mul_result_tmp[(i * 66) + 31-:32]);
							end
							wire [127:0] div_result_out;
							wire [99:0] div_hdr_out;
							function automatic VX_gpu_pkg_inst_m_is_rem;
								input reg [2:0] op;
								VX_gpu_pkg_inst_m_is_rem = op[1];
							endfunction
							wire is_rem_op = VX_gpu_pkg_inst_m_is_rem(muldiv_op);
							wire div_valid_in = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].valid && ~is_mulx_op;
							wire div_ready_in;
							wire div_valid_out;
							wire div_ready_out;
							wire [127:0] div_in1;
							wire [127:0] div_in2;
							genvar _gv_i_55;
							for (_gv_i_55 = 0; _gv_i_55 < NUM_LANES; _gv_i_55 = _gv_i_55 + 1) begin : g_div_in
								localparam i = _gv_i_55;
								assign div_in1[i * 32+:32] = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[256 + (i * 32)+:32];
								assign div_in2[i * 32+:32] = vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[128 + (i * 32)+:32];
							end
							wire [127:0] div_quotient;
							wire [127:0] div_remainder;
							wire is_rem_op_out;
							wire is_div_w_out;
							wire div_strode;
							wire div_busy;
							VX_elastic_adapter div_elastic_adapter(
								.clk(clk),
								.reset(reset),
								.valid_in(div_valid_in),
								.ready_in(div_ready_in),
								.valid_out(div_valid_out),
								.ready_out(div_ready_out),
								.strobe(div_strode),
								.busy(div_busy)
							);
							VX_serial_div #(
								.WIDTHN(32),
								.WIDTHD(32),
								.WIDTHQ(32),
								.WIDTHR(32),
								.LANES(NUM_LANES)
							) serial_div(
								.clk(clk),
								.reset(reset),
								.strobe(div_strode),
								.busy(div_busy),
								.is_signed(is_signed_op),
								.numer(div_in1),
								.denom(div_in2),
								.quotient(div_quotient),
								.remainder(div_remainder)
							);
							reg [101:0] div_tag_r;
							always @(posedge clk)
								if (div_valid_in && div_ready_in)
									div_tag_r <= {vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].data[512-:100], is_rem_op, is_alu_w};
							assign {div_hdr_out, is_rem_op_out, is_div_w_out} = div_tag_r;
							genvar _gv_i_56;
							for (_gv_i_56 = 0; _gv_i_56 < NUM_LANES; _gv_i_56 = _gv_i_56 + 1) begin : g_div_result_out
								localparam i = _gv_i_56;
								assign div_result_out[i * 32+:32] = (is_rem_op_out ? div_remainder[i * 32+:32] : div_quotient[i * 32+:32]);
							end
							assign vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_execute_if[_mbase_execute_if].ready = (is_mulx_op ? mul_ready_in : div_ready_in);
							VX_stream_arb #(
								.NUM_INPUTS(2),
								.DATAW(228),
								.ARBITER("P"),
								.OUT_BUF(2)
							) rsp_buf(
								.clk(clk),
								.reset(reset),
								.valid_in({div_valid_out, mul_valid_out}),
								.ready_in({div_ready_out, mul_ready_out}),
								.data_in({div_hdr_out, div_result_out, mul_hdr_out, mul_result_out}),
								.data_out(vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_result_if[_mbase_result_if].data),
								.valid_out(vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_result_if[_mbase_result_if].valid),
								.ready_out(vortex_core_wrap.core.execute.alu_unit.g_blocks[_gv_block_idx_1].pe_result_if[_mbase_result_if].ready),
								.sel_out()
							);
						end
						assign muldiv_unit.clk = clk;
						assign muldiv_unit.reset = reset;
					end
					localparam _bbase_02972_result_if = 0;
					localparam _bbase_02972_commit_if = 0;
					localparam _param_02972_BLOCK_SIZE = BLOCK_SIZE;
					localparam _param_02972_NUM_LANES = NUM_LANES;
					localparam _param_02972_OUT_BUF = (PARTIAL_BW ? 3 : 0);
					if (1) begin : lane_gather
						localparam BLOCK_SIZE = _param_02972_BLOCK_SIZE;
						localparam NUM_LANES = _param_02972_NUM_LANES;
						localparam OUT_BUF = _param_02972_OUT_BUF;
						wire clk;
						wire reset;
						localparam _mbase_result_if = 0;
						localparam _mbase_commit_if = _bbase_02972_commit_if;
						localparam VX_gpu_pkg_XLENB = 4;
						localparam VX_gpu_pkg_XLENB_W = 2;
						localparam VX_gpu_pkg_BYTESEL_BITS = 4;
						localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
						localparam VX_gpu_pkg_NCTA_BITS = 2;
						localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
						localparam VX_gpu_pkg_REG_TYPES = 2;
						localparam VX_gpu_pkg_RV_REGS = 32;
						localparam VX_gpu_pkg_NUM_REGS = 64;
						localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
						localparam VX_gpu_pkg_NUM_XREGS = 2;
						localparam VX_gpu_pkg_NW_BITS = 2;
						localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
						localparam VX_gpu_pkg_PC_BITS = 32;
						localparam VX_gpu_pkg_UUID_WIDTH = 44;
						localparam VX_gpu_pkg_INST_OP_BITS = 4;
						localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
						localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
						localparam VX_gpu_pkg_INST_FMT_BITS = 2;
						localparam VX_gpu_pkg_INST_FRM_BITS = 3;
						localparam BLOCK_SIZE_W = 1;
						localparam NUM_PACKETS = 1;
						localparam LPID_BITS = 0;
						localparam LPID_WIDTH = 1;
						localparam DATAW = 228;
						localparam DATA_WIS_OFF = 182;
						wire [0:0] result_in_valid;
						wire [227:0] result_in_data;
						wire [0:0] result_in_ready;
						localparam VX_gpu_pkg_ISSUE_ISW_BITS = 0;
						localparam VX_gpu_pkg_ISSUE_ISW_W = 1;
						wire [0:0] result_in_isw;
						genvar _gv_i_77;
						for (_gv_i_77 = 0; _gv_i_77 < BLOCK_SIZE; _gv_i_77 = _gv_i_77 + 1) begin : g_commit_in
							localparam i = _gv_i_77;
							assign result_in_valid[i] = vortex_core_wrap.core.execute.alu_unit.per_block_result_if[i + _mbase_result_if].valid;
							assign result_in_data[i * DATAW+:DATAW] = vortex_core_wrap.core.execute.alu_unit.per_block_result_if[i + _mbase_result_if].data;
							assign vortex_core_wrap.core.execute.alu_unit.per_block_result_if[i + _mbase_result_if].ready = result_in_ready[i];
							if (1) begin : g_result_in_isw_full
								assign result_in_isw[i+:1] = sv2v_cast_1_signed(i);
							end
						end
						reg [0:0] result_out_valid;
						reg [227:0] result_out_data;
						wire [0:0] result_out_ready;
						always @(*) begin
							result_out_valid = 1'sb0;
							begin : sv2v_autoblock_9
								integer i;
								for (i = 0; i < 1; i = i + 1)
									result_out_data[i * DATAW+:DATAW] = 1'sbx;
							end
							begin : sv2v_autoblock_10
								integer i;
								for (i = 0; i < BLOCK_SIZE; i = i + 1)
									begin
										result_out_valid[result_in_isw[i+:1]] = result_in_valid[i];
										result_out_data[result_in_isw[i+:1] * DATAW+:DATAW] = result_in_data[i * DATAW+:DATAW];
									end
							end
						end
						genvar _gv_i_78;
						for (_gv_i_78 = 0; _gv_i_78 < BLOCK_SIZE; _gv_i_78 = _gv_i_78 + 1) begin : g_result_in_ready
							localparam i = _gv_i_78;
							assign result_in_ready[i] = result_out_ready[result_in_isw[i+:1]];
						end
						genvar _gv_i_79;
						localparam VX_gpu_pkg_SIMD_COUNT = 1;
						localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
						localparam VX_gpu_pkg_SIMD_IDX_W = 1;
						for (_gv_i_79 = 0; _gv_i_79 < 1; _gv_i_79 = _gv_i_79 + 1) begin : g_out_bufs
							localparam i = _gv_i_79;
							if (1) begin : result_tmp_if
								wire valid;
								wire [227:0] data;
								wire ready;
							end
							VX_elastic_buffer #(
								.DATAW(DATAW),
								.SIZE(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : 2)),
								.OUT_REG(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : (OUT_BUF & 7) - 2))
							) out_buf(
								.clk(clk),
								.reset(reset),
								.valid_in(result_out_valid[i]),
								.ready_in(result_out_ready[i]),
								.data_in(result_out_data[i * DATAW+:DATAW]),
								.data_out(result_tmp_if.data),
								.valid_out(result_tmp_if.valid),
								.ready_out(result_tmp_if.ready)
							);
							wire [0:0] commit_sid_w;
							wire [3:0] commit_tmask_w;
							wire [127:0] commit_data_w;
							if (1) begin : g_no_lpid
								assign commit_sid_w = sv2v_cast_1(result_tmp_if.data[175-:1]);
								assign commit_tmask_w = result_tmp_if.data[179-:4];
								assign commit_data_w = result_tmp_if.data[127-:128];
							end
							assign vortex_core_wrap.core.commit_if[i + _mbase_commit_if].valid = result_tmp_if.valid;
							assign vortex_core_wrap.core.commit_if[i + _mbase_commit_if].data = {result_tmp_if.data[227-:44], result_tmp_if.data[183-:2], result_tmp_if.data[181-:2], commit_sid_w, commit_tmask_w, result_tmp_if.data[172-:32], result_tmp_if.data[140], result_tmp_if.data[139-:2], result_tmp_if.data[137-:6], result_tmp_if.data[131-:VX_gpu_pkg_BYTESEL_BITS], commit_data_w, result_tmp_if.data[174], result_tmp_if.data[173]};
							assign result_tmp_if.ready = vortex_core_wrap.core.commit_if[i + _mbase_commit_if].ready;
						end
					end
					assign lane_gather.clk = clk;
					assign lane_gather.reset = reset;
				end
				assign alu_unit.clk = clk;
				assign alu_unit.reset = reset;
				localparam VX_gpu_pkg_EX_LSU = 1;
				localparam _bbase_7F4B8_dispatch_if = 1;
				localparam _bbase_7F4B8_commit_if = 1;
				localparam _bbase_7F4B8_per_block_client_if = 0;
				localparam _param_7F4B8_INSTANCE_ID = "";
				localparam _param_7F4B8_CORE_ID = CORE_ID;
				if (1) begin : lsu_unit
					localparam INSTANCE_ID = _param_7F4B8_INSTANCE_ID;
					localparam CORE_ID = _param_7F4B8_CORE_ID;
					wire clk;
					wire reset;
					localparam _mbase_dispatch_if = _bbase_7F4B8_dispatch_if;
					localparam _mbase_commit_if = _bbase_7F4B8_commit_if;
					localparam _mbase_per_block_client_if = 0;
					localparam BLOCK_SIZE = 1;
					localparam NUM_LANES = 4;
					localparam VX_gpu_pkg_INST_OP_BITS = 4;
					localparam VX_gpu_pkg_XLENB = 4;
					localparam VX_gpu_pkg_XLENB_W = 2;
					localparam VX_gpu_pkg_BYTESEL_BITS = 4;
					localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
					localparam VX_gpu_pkg_NCTA_BITS = 2;
					localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
					localparam VX_gpu_pkg_REG_TYPES = 2;
					localparam VX_gpu_pkg_RV_REGS = 32;
					localparam VX_gpu_pkg_NUM_REGS = 64;
					localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
					localparam VX_gpu_pkg_NUM_XREGS = 2;
					localparam VX_gpu_pkg_NW_BITS = 2;
					localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
					localparam VX_gpu_pkg_PC_BITS = 32;
					localparam VX_gpu_pkg_UUID_WIDTH = 44;
					localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
					localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
					localparam VX_gpu_pkg_INST_FMT_BITS = 2;
					localparam VX_gpu_pkg_INST_FRM_BITS = 3;
					genvar _arr_751A6;
					for (_arr_751A6 = 0; _arr_751A6 <= 0; _arr_751A6 = _arr_751A6 + 1) begin : per_block_execute_if
						wire valid;
						wire [512:0] data;
						wire ready;
					end
					localparam _bbase_43CAD_dispatch_if = 1;
					localparam _bbase_43CAD_execute_if = 0;
					localparam _param_43CAD_BLOCK_SIZE = BLOCK_SIZE;
					localparam _param_43CAD_NUM_LANES = NUM_LANES;
					localparam _param_43CAD_OUT_BUF = 3;
					if (1) begin : lane_dispatch
						localparam BLOCK_SIZE = _param_43CAD_BLOCK_SIZE;
						localparam NUM_LANES = _param_43CAD_NUM_LANES;
						localparam OUT_BUF = _param_43CAD_OUT_BUF;
						localparam MAX_FANOUT = 8;
						wire clk;
						wire reset;
						localparam _mbase_dispatch_if = _bbase_43CAD_dispatch_if;
						localparam _mbase_execute_if = 0;
						localparam VX_gpu_pkg_XLENB = 4;
						localparam VX_gpu_pkg_XLENB_W = 2;
						localparam VX_gpu_pkg_BYTESEL_BITS = 4;
						localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
						localparam VX_gpu_pkg_NCTA_BITS = 2;
						localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
						localparam VX_gpu_pkg_REG_TYPES = 2;
						localparam VX_gpu_pkg_RV_REGS = 32;
						localparam VX_gpu_pkg_NUM_REGS = 64;
						localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
						localparam VX_gpu_pkg_NUM_XREGS = 2;
						localparam VX_gpu_pkg_NW_BITS = 2;
						localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
						localparam VX_gpu_pkg_PC_BITS = 32;
						localparam VX_gpu_pkg_UUID_WIDTH = 44;
						localparam VX_gpu_pkg_INST_OP_BITS = 4;
						localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
						localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
						localparam VX_gpu_pkg_INST_FMT_BITS = 2;
						localparam VX_gpu_pkg_INST_FRM_BITS = 3;
						localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
						localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
						localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
						localparam VX_gpu_pkg_SIMD_COUNT = 1;
						localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
						localparam VX_gpu_pkg_SIMD_IDX_W = 1;
						localparam IN_DATAW = 513;
						localparam OUT_DATAW = 513;
						localparam BLOCK_SIZE_W = 1;
						localparam NUM_PACKETS = 1;
						localparam LPID_BITS = 0;
						localparam LPID_WIDTH = 1;
						localparam GPID_BITS = 0;
						localparam GPID_WIDTH = 1;
						localparam BATCH_COUNT = 1;
						localparam BATCH_COUNT_W = 1;
						localparam ISSUE_W = 1;
						localparam FANOUT_ENABLE = 1'd0;
						localparam DATA_IN_TMASK_OFF = 460;
						localparam DATA_IN_OPDS_OFF = 2;
						wire [0:0] dispatch_valid;
						wire [512:0] dispatch_data;
						wire [0:0] dispatch_ready;
						genvar _gv_i_74;
						for (_gv_i_74 = 0; _gv_i_74 < 1; _gv_i_74 = _gv_i_74 + 1) begin : g_dispatch_data
							localparam i = _gv_i_74;
							assign dispatch_valid[i] = vortex_core_wrap.core.dispatch_if[i + _mbase_dispatch_if].valid;
							assign dispatch_data[i * IN_DATAW+:IN_DATAW] = vortex_core_wrap.core.dispatch_if[i + _mbase_dispatch_if].data;
							assign vortex_core_wrap.core.dispatch_if[i + _mbase_dispatch_if].ready = dispatch_ready[i];
						end
						wire [0:0] block_ready;
						wire [3:0] block_tmask;
						wire [383:0] block_rsdata;
						wire [0:0] block_pid;
						wire [0:0] block_sop;
						wire [0:0] block_eop;
						wire [0:0] block_done;
						wire batch_done = &block_done;
						wire [0:0] batch_idx;
						if (1) begin : g_batch_idx_0
							assign batch_idx = 0;
						end
						wire [0:0] issue_indices;
						genvar _gv_block_idx_3;
						for (_gv_block_idx_3 = 0; _gv_block_idx_3 < BLOCK_SIZE; _gv_block_idx_3 = _gv_block_idx_3 + 1) begin : g_issue_indices
							localparam block_idx = _gv_block_idx_3;
							assign issue_indices[block_idx+:1] = sv2v_cast_1(batch_idx * BLOCK_SIZE) + sv2v_cast_1_signed(block_idx);
						end
						genvar _gv_block_idx_4;
						localparam VX_gpu_pkg_ISSUE_ISW_BITS = 0;
						localparam VX_gpu_pkg_ISSUE_ISW_W = 1;
						localparam VX_gpu_pkg_NUM_SRC_OPDS = 3;
						function automatic [1:0] VX_gpu_pkg_wis_to_wid;
							input reg [1:0] wis;
							input reg [0:0] isw;
							VX_gpu_pkg_wis_to_wid = wis;
						endfunction
						for (_gv_block_idx_4 = 0; _gv_block_idx_4 < BLOCK_SIZE; _gv_block_idx_4 = _gv_block_idx_4 + 1) begin : g_blocks
							localparam block_idx = _gv_block_idx_4;
							wire [0:0] issue_idx = issue_indices[block_idx+:1];
							wire [1:0] dispatch_wis = dispatch_data[(issue_idx * IN_DATAW) + 467+:VX_gpu_pkg_ISSUE_WIS_W];
							wire [1:0] dispatch_cta_id = dispatch_data[(issue_idx * IN_DATAW) + 465+:VX_gpu_pkg_NCTA_WIDTH];
							wire [0:0] dispatch_sid = dispatch_data[(issue_idx * IN_DATAW) + 464+:VX_gpu_pkg_SIMD_IDX_W];
							wire dispatch_sop = dispatch_data[(issue_idx * IN_DATAW) + 1];
							wire dispatch_eop = dispatch_data[issue_idx * IN_DATAW];
							wire [3:0] dispatch_tmask;
							wire [383:0] dispatch_rsdata;
							assign dispatch_tmask = dispatch_data[(issue_idx * IN_DATAW) + DATA_IN_TMASK_OFF+:4];
							assign dispatch_rsdata[0+:128] = dispatch_data[(issue_idx * IN_DATAW) + 258+:128];
							assign dispatch_rsdata[128+:128] = dispatch_data[(issue_idx * IN_DATAW) + 130+:128];
							assign dispatch_rsdata[256+:128] = dispatch_data[(issue_idx * IN_DATAW) + 2+:128];
							wire valid_p;
							wire ready_p;
							if (1) begin : g_full_simd
								assign valid_p = dispatch_valid[issue_idx];
								assign block_tmask[block_idx * 4+:4] = dispatch_tmask;
								assign block_rsdata[32 * (4 * (block_idx * 3))+:384] = dispatch_rsdata;
								assign block_pid[block_idx+:1] = 0;
								assign block_sop[block_idx] = 1;
								assign block_eop[block_idx] = 1;
								assign block_ready[block_idx] = ready_p;
								assign block_done[block_idx] = ready_p || ~valid_p;
							end
							wire [0:0] isw;
							if (1) begin : g_isw
								assign isw = block_idx;
							end
							wire [1:0] block_wid = VX_gpu_pkg_wis_to_wid(dispatch_wis, isw);
							wire [0:0] warp_pid = block_pid[block_idx+:1] + sv2v_cast_1(dispatch_sid * NUM_PACKETS);
							wire warp_sop = block_sop[block_idx] && dispatch_sop;
							wire warp_eop = block_eop[block_idx] && dispatch_eop;
							VX_elastic_buffer #(
								.DATAW(OUT_DATAW),
								.SIZE(2),
								.OUT_REG(1)
							) buf_out(
								.clk(clk),
								.reset(reset),
								.valid_in(valid_p),
								.ready_in(ready_p),
								.data_in({dispatch_data[(issue_idx * IN_DATAW) + 512-:VX_gpu_pkg_UUID_WIDTH], block_wid, dispatch_cta_id, block_tmask[block_idx * 4+:4], warp_pid, warp_sop, warp_eop, dispatch_data[(issue_idx * IN_DATAW) + 459-:74], block_rsdata[32 * ((block_idx * 3) * 4)+:128], block_rsdata[32 * (((block_idx * 3) + 1) * 4)+:128], block_rsdata[32 * (((block_idx * 3) + 2) * 4)+:128]}),
								.data_out(vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[block_idx + _mbase_execute_if].data),
								.valid_out(vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[block_idx + _mbase_execute_if].valid),
								.ready_out(vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[block_idx + _mbase_execute_if].ready)
							);
						end
						reg [0:0] ready_in;
						always @(*) begin
							ready_in = 0;
							begin : sv2v_autoblock_11
								integer block_idx;
								for (block_idx = 0; block_idx < BLOCK_SIZE; block_idx = block_idx + 1)
									ready_in[issue_indices[block_idx+:1]] = block_ready[block_idx] && block_eop[block_idx];
							end
						end
						assign dispatch_ready = ready_in;
					end
					assign lane_dispatch.clk = clk;
					assign lane_dispatch.reset = reset;
					genvar _arr_119E4;
					for (_arr_119E4 = 0; _arr_119E4 <= 0; _arr_119E4 = _arr_119E4 + 1) begin : per_block_result_if
						wire valid;
						wire [227:0] data;
						wire ready;
					end
					genvar _gv_block_idx_5;
					for (_gv_block_idx_5 = 0; _gv_block_idx_5 < BLOCK_SIZE; _gv_block_idx_5 = _gv_block_idx_5 + 1) begin : g_blocks
						localparam block_idx = _gv_block_idx_5;
						localparam _bbase_81680_execute_if = _gv_block_idx_5;
						localparam _bbase_81680_result_if = _gv_block_idx_5;
						localparam _bbase_81680_client_if = _gv_block_idx_5 + _mbase_per_block_client_if;
						localparam _param_81680_INSTANCE_ID = "";
						localparam _param_81680_CORE_ID = CORE_ID;
						if (1) begin : lsu_slice
							localparam INSTANCE_ID = _param_81680_INSTANCE_ID;
							localparam CORE_ID = _param_81680_CORE_ID;
							wire clk;
							wire reset;
							localparam _mbase_execute_if = _bbase_81680_execute_if;
							localparam _mbase_result_if = _bbase_81680_result_if;
							localparam _mbase_client_if = _bbase_81680_client_if;
							localparam NUM_LANES = 4;
							localparam PID_BITS = 0;
							localparam LSUQ_SIZEW = 1;
							localparam VX_gpu_pkg_XLENB = 4;
							localparam VX_gpu_pkg_LSU_WORD_SIZE = VX_gpu_pkg_XLENB;
							localparam REQ_ASHIFT = 2;
							localparam MEM_ASHIFT = 6;
							localparam MEM_ADDRW = 26;
							localparam VX_gpu_pkg_INST_LSU_BITS = 4;
							localparam VX_gpu_pkg_XLENB_W = 2;
							localparam VX_gpu_pkg_BYTESEL_BITS = 4;
							localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
							localparam VX_gpu_pkg_NCTA_BITS = 2;
							localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
							localparam VX_gpu_pkg_REG_TYPES = 2;
							localparam VX_gpu_pkg_RV_REGS = 32;
							localparam VX_gpu_pkg_NUM_REGS = 64;
							localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
							localparam VX_gpu_pkg_NUM_XREGS = 2;
							localparam VX_gpu_pkg_NW_BITS = 2;
							localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
							localparam VX_gpu_pkg_PC_BITS = 32;
							localparam VX_gpu_pkg_UUID_WIDTH = 44;
							localparam TAG_WIDTH = 114;
							if (1) begin : result_rsp_if
								wire valid;
								wire [227:0] data;
								wire ready;
							end
							if (1) begin : result_no_rsp_if
								wire valid;
								wire [227:0] data;
								wire ready;
							end
							wire req_is_fence;
							wire rsp_is_fence;
							wire [127:0] full_addr;
							genvar _gv_i_83;
							for (_gv_i_83 = 0; _gv_i_83 < NUM_LANES; _gv_i_83 = _gv_i_83 + 1) begin : g_full_addr
								localparam i = _gv_i_83;
								assign full_addr[i * 32+:32] = vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].data[256 + (i * 32)+:32] + {{21 {vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].data[395]}}, vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].data[394:384]};
							end
							localparam VX_gpu_pkg_NC_BITS = 0;
							localparam VX_gpu_pkg_NT_BITS = 2;
							localparam VX_gpu_pkg_HART_ID_BITS = 4;
							localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
							wire [51:0] mem_req_attr_struct;
							localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
							wire [51:0] mem_req_attr;
							genvar _gv_i_84;
							for (_gv_i_84 = 0; _gv_i_84 < NUM_LANES; _gv_i_84 = _gv_i_84 + 1) begin : g_mem_req_attr
								localparam i = _gv_i_84;
								wire [25:0] block_addr = full_addr[(i * 32) + MEM_ASHIFT+:MEM_ADDRW];
								wire [25:0] io_addr_start = sv2v_cast_26_signed(32'sd64 >> MEM_ASHIFT);
								wire [25:0] io_addr_end = sv2v_cast_26_signed(32'sd65536 >> MEM_ASHIFT);
								assign mem_req_attr_struct[i * 13] = req_is_fence;
								assign mem_req_attr_struct[(i * 13) + 1] = (block_addr >= io_addr_start) && (block_addr < io_addr_end);
								wire [25:0] lmem_addr_start = sv2v_cast_26(32'hffff0000 >> MEM_ASHIFT);
								wire [25:0] lmem_addr_end = sv2v_cast_26((32'hffff0000 + 32'sd16384) >> MEM_ASHIFT);
								assign mem_req_attr_struct[(i * 13) + 2] = (block_addr >= lmem_addr_start) && (block_addr < lmem_addr_end);
								assign mem_req_attr_struct[(i * 13) + 12-:10] = 1'sb0;
								assign mem_req_attr[i * 13+:13] = mem_req_attr_struct[i * 13+:13];
							end
							wire mem_req_valid;
							wire [3:0] mem_req_mask;
							wire mem_req_rw;
							localparam VX_gpu_pkg_LSU_ADDR_WIDTH = 30;
							wire [119:0] mem_req_addr;
							wire [15:0] mem_req_byteen;
							reg [127:0] mem_req_data;
							wire [113:0] mem_req_tag;
							wire mem_req_ready;
							wire mem_rsp_valid;
							wire [3:0] mem_rsp_mask;
							wire [127:0] mem_rsp_data;
							wire [113:0] mem_rsp_tag;
							wire mem_rsp_sop;
							wire mem_rsp_eop;
							wire mem_rsp_ready;
							wire mem_req_fire = mem_req_valid && mem_req_ready;
							wire mem_rsp_fire = mem_rsp_valid && mem_rsp_ready;
							wire mem_rsp_sop_pkt;
							wire mem_rsp_eop_pkt;
							wire no_rsp_buf_valid;
							wire no_rsp_buf_ready;
							wire [0:0] pkt_waddr;
							wire [0:0] pkt_raddr;
							reg fence_lock;
							function automatic VX_gpu_pkg_inst_lsu_is_fence;
								input reg [3:0] op;
								VX_gpu_pkg_inst_lsu_is_fence = op[3:2] == 3;
							endfunction
							assign req_is_fence = VX_gpu_pkg_inst_lsu_is_fence(vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].data[412-:4]);
							always @(posedge clk)
								if (reset)
									fence_lock <= 0;
								else begin
									if ((mem_req_fire && req_is_fence) && vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].data[458])
										fence_lock <= 1;
									if ((mem_rsp_fire && rsp_is_fence) && mem_rsp_eop_pkt)
										fence_lock <= 0;
								end
							wire req_skip = req_is_fence && ~vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].data[458];
							wire no_rsp_buf_enable = (mem_req_rw && ~vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].data[425]) || req_skip;
							assign mem_req_valid = ((vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].valid && ~req_skip) && ~(no_rsp_buf_enable && ~no_rsp_buf_ready)) && ~fence_lock;
							assign no_rsp_buf_valid = ((vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].valid && no_rsp_buf_enable) && (req_skip || mem_req_ready)) && ~fence_lock;
							assign vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].ready = ((mem_req_ready || req_skip) && ~(no_rsp_buf_enable && ~no_rsp_buf_ready)) && ~fence_lock;
							assign mem_req_mask = vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].data[464-:4];
							assign mem_req_rw = vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].data[397];
							wire [7:0] req_align;
							genvar _gv_i_85;
							for (_gv_i_85 = 0; _gv_i_85 < NUM_LANES; _gv_i_85 = _gv_i_85 + 1) begin : g_mem_req_addr
								localparam i = _gv_i_85;
								assign req_align[i * 2+:2] = full_addr[(i * 32) + 1-:2];
								assign mem_req_addr[i * 30+:30] = full_addr[(i * 32) + 31-:30];
							end
							genvar _gv_i_86;
							function automatic [1:0] VX_gpu_pkg_inst_lsu_wsize;
								input reg [3:0] op;
								VX_gpu_pkg_inst_lsu_wsize = op[1:0];
							endfunction
							for (_gv_i_86 = 0; _gv_i_86 < NUM_LANES; _gv_i_86 = _gv_i_86 + 1) begin : g_mem_req_byteen_w
								localparam i = _gv_i_86;
								reg [3:0] mem_req_byteen_w;
								always @(*) begin
									mem_req_byteen_w = 1'sb0;
									case (VX_gpu_pkg_inst_lsu_wsize(vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].data[412-:4]))
										0: mem_req_byteen_w[req_align[i * 2+:2]] = 1'b1;
										1: begin
											mem_req_byteen_w[{req_align[(i * 2) + 1-:1], 1'b0}] = 1'b1;
											mem_req_byteen_w[{req_align[(i * 2) + 1-:1], 1'b1}] = 1'b1;
										end
										default: mem_req_byteen_w = {VX_gpu_pkg_LSU_WORD_SIZE {1'b1}};
									endcase
								end
								assign mem_req_byteen[i * 4+:4] = mem_req_byteen_w;
							end
							genvar _gv_i_87;
							for (_gv_i_87 = 0; _gv_i_87 < NUM_LANES; _gv_i_87 = _gv_i_87 + 1) begin : g_missalign
								localparam i = _gv_i_87;
								wire lsu_req_fire = vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].valid && vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].ready;
							end
							genvar _gv_i_88;
							for (_gv_i_88 = 0; _gv_i_88 < NUM_LANES; _gv_i_88 = _gv_i_88 + 1) begin : g_mem_req_data
								localparam i = _gv_i_88;
								always @(*) begin
									mem_req_data[i * 32+:32] = vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].data[128 + (i * 32)+:32];
									case (req_align[i * 2+:2])
										1: mem_req_data[(i * 32) + 31-:24] = vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].data[128 + ((i * 32) + 23)-:24];
										2: mem_req_data[(i * 32) + 31-:16] = vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].data[128 + ((i * 32) + 15)-:16];
										3: mem_req_data[(i * 32) + 31-:8] = vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].data[128 + ((i * 32) + 7)-:8];
										default:
											;
									endcase
								end
							end
							if (1) begin : g_no_pid
								assign pkt_waddr = 0;
								assign mem_rsp_sop_pkt = mem_rsp_sop;
								assign mem_rsp_eop_pkt = mem_rsp_eop;
							end
							assign mem_req_tag = {vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].data[512-:100], vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].data[412-:4], req_align, pkt_waddr, req_is_fence};
							assign vortex_core_wrap.core.lsu_client_if[_mbase_client_if].req_valid = mem_req_valid;
							assign vortex_core_wrap.core.lsu_client_if[_mbase_client_if].req_data[434] = mem_req_rw;
							assign vortex_core_wrap.core.lsu_client_if[_mbase_client_if].req_data[433-:4] = mem_req_mask;
							assign vortex_core_wrap.core.lsu_client_if[_mbase_client_if].req_data[429-:16] = mem_req_byteen;
							assign vortex_core_wrap.core.lsu_client_if[_mbase_client_if].req_data[413-:120] = mem_req_addr;
							assign vortex_core_wrap.core.lsu_client_if[_mbase_client_if].req_data[293-:52] = mem_req_attr;
							assign vortex_core_wrap.core.lsu_client_if[_mbase_client_if].req_data[241-:128] = mem_req_data;
							assign vortex_core_wrap.core.lsu_client_if[_mbase_client_if].req_data[113-:114] = mem_req_tag;
							assign mem_req_ready = vortex_core_wrap.core.lsu_client_if[_mbase_client_if].req_ready;
							assign mem_rsp_valid = vortex_core_wrap.core.lsu_client_if[_mbase_client_if].rsp_valid;
							assign mem_rsp_mask = vortex_core_wrap.core.lsu_client_if[_mbase_client_if].rsp_data[247-:4];
							assign mem_rsp_data = vortex_core_wrap.core.lsu_client_if[_mbase_client_if].rsp_data[243-:128];
							assign mem_rsp_tag = vortex_core_wrap.core.lsu_client_if[_mbase_client_if].rsp_data[115-:114];
							assign mem_rsp_sop = vortex_core_wrap.core.lsu_client_if[_mbase_client_if].rsp_data[1];
							assign mem_rsp_eop = vortex_core_wrap.core.lsu_client_if[_mbase_client_if].rsp_data[0];
							assign vortex_core_wrap.core.lsu_client_if[_mbase_client_if].rsp_ready = mem_rsp_ready;
							wire [99:0] rsp_hdr;
							wire [3:0] rsp_op_type;
							wire [7:0] rsp_align;
							assign {rsp_hdr, rsp_op_type, rsp_align, pkt_raddr, rsp_is_fence} = mem_rsp_tag;
							reg [127:0] rsp_data;
							genvar _gv_i_89;
							localparam VX_gpu_pkg_LSU_FMT_B = 3'b000;
							localparam VX_gpu_pkg_LSU_FMT_BU = 3'b100;
							localparam VX_gpu_pkg_LSU_FMT_H = 3'b001;
							localparam VX_gpu_pkg_LSU_FMT_HU = 3'b101;
							localparam VX_gpu_pkg_LSU_FMT_W = 3'b010;
							function automatic [2:0] VX_gpu_pkg_inst_lsu_fmt;
								input reg [3:0] op;
								VX_gpu_pkg_inst_lsu_fmt = op[2:0];
							endfunction
							for (_gv_i_89 = 0; _gv_i_89 < NUM_LANES; _gv_i_89 = _gv_i_89 + 1) begin : g_rsp_data
								localparam i = _gv_i_89;
								wire [31:0] rsp_data32 = mem_rsp_data[i * 32+:32];
								wire [15:0] rsp_data16 = (rsp_align[(i * 2) + 1] ? rsp_data32[31:16] : rsp_data32[15:0]);
								wire [7:0] rsp_data8 = (rsp_align[i * 2] ? rsp_data16[15:8] : rsp_data16[7:0]);
								always @(*)
									case (VX_gpu_pkg_inst_lsu_fmt(rsp_op_type))
										VX_gpu_pkg_LSU_FMT_B: rsp_data[i * 32+:32] = sv2v_cast_32_signed($signed(rsp_data8));
										VX_gpu_pkg_LSU_FMT_H: rsp_data[i * 32+:32] = sv2v_cast_32_signed($signed(rsp_data16));
										VX_gpu_pkg_LSU_FMT_BU: rsp_data[i * 32+:32] = sv2v_cast_32($unsigned(rsp_data8));
										VX_gpu_pkg_LSU_FMT_HU: rsp_data[i * 32+:32] = sv2v_cast_32($unsigned(rsp_data16));
										VX_gpu_pkg_LSU_FMT_W: rsp_data[i * 32+:32] = sv2v_cast_32_signed($signed(rsp_data32));
										default: rsp_data[i * 32+:32] = 1'sbx;
									endcase
							end
							reg [99:0] rsp_hdr2;
							always @(*) begin
								rsp_hdr2 = rsp_hdr;
								rsp_hdr2[51-:4] = mem_rsp_mask;
								rsp_hdr2[46] = mem_rsp_sop_pkt;
								rsp_hdr2[45] = mem_rsp_eop_pkt;
							end
							VX_elastic_buffer #(
								.DATAW(228),
								.SIZE(2)
							) rsp_buf(
								.clk(clk),
								.reset(reset),
								.valid_in(mem_rsp_valid),
								.ready_in(mem_rsp_ready),
								.data_in({rsp_hdr2, rsp_data}),
								.data_out(result_rsp_if.data),
								.valid_out(result_rsp_if.valid),
								.ready_out(result_rsp_if.ready)
							);
							VX_elastic_buffer #(
								.DATAW(100),
								.SIZE(2)
							) no_rsp_buf(
								.clk(clk),
								.reset(reset),
								.valid_in(no_rsp_buf_valid),
								.ready_in(no_rsp_buf_ready),
								.data_in(vortex_core_wrap.core.execute.lsu_unit.per_block_execute_if[_mbase_execute_if].data[512-:100]),
								.data_out(result_no_rsp_if.data[227-:100]),
								.valid_out(result_no_rsp_if.valid),
								.ready_out(result_no_rsp_if.ready)
							);
							assign result_no_rsp_if.data[127-:128] = result_rsp_if.data[127-:128];
							VX_stream_arb #(
								.NUM_INPUTS(2),
								.DATAW(228),
								.ARBITER("P"),
								.OUT_BUF(3)
							) rsp_arb(
								.clk(clk),
								.reset(reset),
								.valid_in({result_no_rsp_if.valid, result_rsp_if.valid}),
								.ready_in({result_no_rsp_if.ready, result_rsp_if.ready}),
								.data_in({result_no_rsp_if.data, result_rsp_if.data}),
								.data_out(vortex_core_wrap.core.execute.lsu_unit.per_block_result_if[_mbase_result_if].data),
								.valid_out(vortex_core_wrap.core.execute.lsu_unit.per_block_result_if[_mbase_result_if].valid),
								.ready_out(vortex_core_wrap.core.execute.lsu_unit.per_block_result_if[_mbase_result_if].ready),
								.sel_out()
							);
						end
						assign lsu_slice.clk = clk;
						assign lsu_slice.reset = reset;
					end
					localparam _bbase_96A80_result_if = 0;
					localparam _bbase_96A80_commit_if = 1;
					localparam _param_96A80_BLOCK_SIZE = BLOCK_SIZE;
					localparam _param_96A80_NUM_LANES = NUM_LANES;
					localparam _param_96A80_OUT_BUF = 3;
					if (1) begin : lane_gather
						localparam BLOCK_SIZE = _param_96A80_BLOCK_SIZE;
						localparam NUM_LANES = _param_96A80_NUM_LANES;
						localparam OUT_BUF = _param_96A80_OUT_BUF;
						wire clk;
						wire reset;
						localparam _mbase_result_if = 0;
						localparam _mbase_commit_if = _bbase_96A80_commit_if;
						localparam VX_gpu_pkg_XLENB = 4;
						localparam VX_gpu_pkg_XLENB_W = 2;
						localparam VX_gpu_pkg_BYTESEL_BITS = 4;
						localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
						localparam VX_gpu_pkg_NCTA_BITS = 2;
						localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
						localparam VX_gpu_pkg_REG_TYPES = 2;
						localparam VX_gpu_pkg_RV_REGS = 32;
						localparam VX_gpu_pkg_NUM_REGS = 64;
						localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
						localparam VX_gpu_pkg_NUM_XREGS = 2;
						localparam VX_gpu_pkg_NW_BITS = 2;
						localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
						localparam VX_gpu_pkg_PC_BITS = 32;
						localparam VX_gpu_pkg_UUID_WIDTH = 44;
						localparam VX_gpu_pkg_INST_OP_BITS = 4;
						localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
						localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
						localparam VX_gpu_pkg_INST_FMT_BITS = 2;
						localparam VX_gpu_pkg_INST_FRM_BITS = 3;
						localparam BLOCK_SIZE_W = 1;
						localparam NUM_PACKETS = 1;
						localparam LPID_BITS = 0;
						localparam LPID_WIDTH = 1;
						localparam DATAW = 228;
						localparam DATA_WIS_OFF = 182;
						wire [0:0] result_in_valid;
						wire [227:0] result_in_data;
						wire [0:0] result_in_ready;
						localparam VX_gpu_pkg_ISSUE_ISW_BITS = 0;
						localparam VX_gpu_pkg_ISSUE_ISW_W = 1;
						wire [0:0] result_in_isw;
						genvar _gv_i_77;
						for (_gv_i_77 = 0; _gv_i_77 < BLOCK_SIZE; _gv_i_77 = _gv_i_77 + 1) begin : g_commit_in
							localparam i = _gv_i_77;
							assign result_in_valid[i] = vortex_core_wrap.core.execute.lsu_unit.per_block_result_if[i + _mbase_result_if].valid;
							assign result_in_data[i * DATAW+:DATAW] = vortex_core_wrap.core.execute.lsu_unit.per_block_result_if[i + _mbase_result_if].data;
							assign vortex_core_wrap.core.execute.lsu_unit.per_block_result_if[i + _mbase_result_if].ready = result_in_ready[i];
							if (1) begin : g_result_in_isw_full
								assign result_in_isw[i+:1] = sv2v_cast_1_signed(i);
							end
						end
						reg [0:0] result_out_valid;
						reg [227:0] result_out_data;
						wire [0:0] result_out_ready;
						always @(*) begin
							result_out_valid = 1'sb0;
							begin : sv2v_autoblock_12
								integer i;
								for (i = 0; i < 1; i = i + 1)
									result_out_data[i * DATAW+:DATAW] = 1'sbx;
							end
							begin : sv2v_autoblock_13
								integer i;
								for (i = 0; i < BLOCK_SIZE; i = i + 1)
									begin
										result_out_valid[result_in_isw[i+:1]] = result_in_valid[i];
										result_out_data[result_in_isw[i+:1] * DATAW+:DATAW] = result_in_data[i * DATAW+:DATAW];
									end
							end
						end
						genvar _gv_i_78;
						for (_gv_i_78 = 0; _gv_i_78 < BLOCK_SIZE; _gv_i_78 = _gv_i_78 + 1) begin : g_result_in_ready
							localparam i = _gv_i_78;
							assign result_in_ready[i] = result_out_ready[result_in_isw[i+:1]];
						end
						genvar _gv_i_79;
						localparam VX_gpu_pkg_SIMD_COUNT = 1;
						localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
						localparam VX_gpu_pkg_SIMD_IDX_W = 1;
						for (_gv_i_79 = 0; _gv_i_79 < 1; _gv_i_79 = _gv_i_79 + 1) begin : g_out_bufs
							localparam i = _gv_i_79;
							if (1) begin : result_tmp_if
								wire valid;
								wire [227:0] data;
								wire ready;
							end
							VX_elastic_buffer #(
								.DATAW(DATAW),
								.SIZE(2),
								.OUT_REG(1)
							) out_buf(
								.clk(clk),
								.reset(reset),
								.valid_in(result_out_valid[i]),
								.ready_in(result_out_ready[i]),
								.data_in(result_out_data[i * DATAW+:DATAW]),
								.data_out(result_tmp_if.data),
								.valid_out(result_tmp_if.valid),
								.ready_out(result_tmp_if.ready)
							);
							wire [0:0] commit_sid_w;
							wire [3:0] commit_tmask_w;
							wire [127:0] commit_data_w;
							if (1) begin : g_no_lpid
								assign commit_sid_w = sv2v_cast_1(result_tmp_if.data[175-:1]);
								assign commit_tmask_w = result_tmp_if.data[179-:4];
								assign commit_data_w = result_tmp_if.data[127-:128];
							end
							assign vortex_core_wrap.core.commit_if[i + _mbase_commit_if].valid = result_tmp_if.valid;
							assign vortex_core_wrap.core.commit_if[i + _mbase_commit_if].data = {result_tmp_if.data[227-:44], result_tmp_if.data[183-:2], result_tmp_if.data[181-:2], commit_sid_w, commit_tmask_w, result_tmp_if.data[172-:32], result_tmp_if.data[140], result_tmp_if.data[139-:2], result_tmp_if.data[137-:6], result_tmp_if.data[131-:VX_gpu_pkg_BYTESEL_BITS], commit_data_w, result_tmp_if.data[174], result_tmp_if.data[173]};
							assign result_tmp_if.ready = vortex_core_wrap.core.commit_if[i + _mbase_commit_if].ready;
						end
					end
					assign lane_gather.clk = clk;
					assign lane_gather.reset = reset;
				end
				assign lsu_unit.clk = clk;
				assign lsu_unit.reset = reset;
				localparam _bbase_073BB_dispatch_if = 3;
				localparam _bbase_073BB_commit_if = 3;
				localparam _bbase_073BB_fpu_csr_if = 0;
				localparam _param_073BB_INSTANCE_ID = "";
				if (1) begin : fpu_unit
					reg _sv2v_0;
					localparam INSTANCE_ID = _param_073BB_INSTANCE_ID;
					wire clk;
					wire reset;
					localparam _mbase_dispatch_if = _bbase_073BB_dispatch_if;
					localparam _mbase_commit_if = _bbase_073BB_commit_if;
					localparam _mbase_fpu_csr_if = 0;
					localparam BLOCK_SIZE = 1;
					localparam NUM_LANES = 4;
					localparam PID_BITS = 0;
					localparam TAG_WIDTH = 1;
					localparam PARTIAL_BW = 1'd0;
					localparam VX_gpu_pkg_XLENB = 4;
					localparam VX_gpu_pkg_XLENB_W = 2;
					localparam VX_gpu_pkg_BYTESEL_BITS = 4;
					localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
					localparam VX_gpu_pkg_NCTA_BITS = 2;
					localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
					localparam VX_gpu_pkg_REG_TYPES = 2;
					localparam VX_gpu_pkg_RV_REGS = 32;
					localparam VX_gpu_pkg_NUM_REGS = 64;
					localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
					localparam VX_gpu_pkg_NUM_XREGS = 2;
					localparam VX_gpu_pkg_NW_BITS = 2;
					localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
					localparam VX_gpu_pkg_PC_BITS = 32;
					localparam VX_gpu_pkg_UUID_WIDTH = 44;
					localparam VX_gpu_pkg_INST_OP_BITS = 4;
					localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
					localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
					localparam VX_gpu_pkg_INST_FMT_BITS = 2;
					localparam VX_gpu_pkg_INST_FRM_BITS = 3;
					genvar _arr_414B0;
					for (_arr_414B0 = 0; _arr_414B0 <= 0; _arr_414B0 = _arr_414B0 + 1) begin : per_block_execute_if
						wire valid;
						wire [512:0] data;
						wire ready;
					end
					localparam _bbase_147AA_dispatch_if = 3;
					localparam _bbase_147AA_execute_if = 0;
					localparam _param_147AA_BLOCK_SIZE = BLOCK_SIZE;
					localparam _param_147AA_NUM_LANES = NUM_LANES;
					localparam _param_147AA_OUT_BUF = (PARTIAL_BW ? 3 : 0);
					if (1) begin : lane_dispatch
						localparam BLOCK_SIZE = _param_147AA_BLOCK_SIZE;
						localparam NUM_LANES = _param_147AA_NUM_LANES;
						localparam OUT_BUF = _param_147AA_OUT_BUF;
						localparam MAX_FANOUT = 8;
						wire clk;
						wire reset;
						localparam _mbase_dispatch_if = _bbase_147AA_dispatch_if;
						localparam _mbase_execute_if = 0;
						localparam VX_gpu_pkg_XLENB = 4;
						localparam VX_gpu_pkg_XLENB_W = 2;
						localparam VX_gpu_pkg_BYTESEL_BITS = 4;
						localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
						localparam VX_gpu_pkg_NCTA_BITS = 2;
						localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
						localparam VX_gpu_pkg_REG_TYPES = 2;
						localparam VX_gpu_pkg_RV_REGS = 32;
						localparam VX_gpu_pkg_NUM_REGS = 64;
						localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
						localparam VX_gpu_pkg_NUM_XREGS = 2;
						localparam VX_gpu_pkg_NW_BITS = 2;
						localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
						localparam VX_gpu_pkg_PC_BITS = 32;
						localparam VX_gpu_pkg_UUID_WIDTH = 44;
						localparam VX_gpu_pkg_INST_OP_BITS = 4;
						localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
						localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
						localparam VX_gpu_pkg_INST_FMT_BITS = 2;
						localparam VX_gpu_pkg_INST_FRM_BITS = 3;
						localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
						localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
						localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
						localparam VX_gpu_pkg_SIMD_COUNT = 1;
						localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
						localparam VX_gpu_pkg_SIMD_IDX_W = 1;
						localparam IN_DATAW = 513;
						localparam OUT_DATAW = 513;
						localparam BLOCK_SIZE_W = 1;
						localparam NUM_PACKETS = 1;
						localparam LPID_BITS = 0;
						localparam LPID_WIDTH = 1;
						localparam GPID_BITS = 0;
						localparam GPID_WIDTH = 1;
						localparam BATCH_COUNT = 1;
						localparam BATCH_COUNT_W = 1;
						localparam ISSUE_W = 1;
						localparam FANOUT_ENABLE = 1'd0;
						localparam DATA_IN_TMASK_OFF = 460;
						localparam DATA_IN_OPDS_OFF = 2;
						wire [0:0] dispatch_valid;
						wire [512:0] dispatch_data;
						wire [0:0] dispatch_ready;
						genvar _gv_i_74;
						for (_gv_i_74 = 0; _gv_i_74 < 1; _gv_i_74 = _gv_i_74 + 1) begin : g_dispatch_data
							localparam i = _gv_i_74;
							assign dispatch_valid[i] = vortex_core_wrap.core.dispatch_if[i + _mbase_dispatch_if].valid;
							assign dispatch_data[i * IN_DATAW+:IN_DATAW] = vortex_core_wrap.core.dispatch_if[i + _mbase_dispatch_if].data;
							assign vortex_core_wrap.core.dispatch_if[i + _mbase_dispatch_if].ready = dispatch_ready[i];
						end
						wire [0:0] block_ready;
						wire [3:0] block_tmask;
						wire [383:0] block_rsdata;
						wire [0:0] block_pid;
						wire [0:0] block_sop;
						wire [0:0] block_eop;
						wire [0:0] block_done;
						wire batch_done = &block_done;
						wire [0:0] batch_idx;
						if (1) begin : g_batch_idx_0
							assign batch_idx = 0;
						end
						wire [0:0] issue_indices;
						genvar _gv_block_idx_3;
						for (_gv_block_idx_3 = 0; _gv_block_idx_3 < BLOCK_SIZE; _gv_block_idx_3 = _gv_block_idx_3 + 1) begin : g_issue_indices
							localparam block_idx = _gv_block_idx_3;
							assign issue_indices[block_idx+:1] = sv2v_cast_1(batch_idx * BLOCK_SIZE) + sv2v_cast_1_signed(block_idx);
						end
						genvar _gv_block_idx_4;
						localparam VX_gpu_pkg_ISSUE_ISW_BITS = 0;
						localparam VX_gpu_pkg_ISSUE_ISW_W = 1;
						localparam VX_gpu_pkg_NUM_SRC_OPDS = 3;
						function automatic [1:0] VX_gpu_pkg_wis_to_wid;
							input reg [1:0] wis;
							input reg [0:0] isw;
							VX_gpu_pkg_wis_to_wid = wis;
						endfunction
						for (_gv_block_idx_4 = 0; _gv_block_idx_4 < BLOCK_SIZE; _gv_block_idx_4 = _gv_block_idx_4 + 1) begin : g_blocks
							localparam block_idx = _gv_block_idx_4;
							wire [0:0] issue_idx = issue_indices[block_idx+:1];
							wire [1:0] dispatch_wis = dispatch_data[(issue_idx * IN_DATAW) + 467+:VX_gpu_pkg_ISSUE_WIS_W];
							wire [1:0] dispatch_cta_id = dispatch_data[(issue_idx * IN_DATAW) + 465+:VX_gpu_pkg_NCTA_WIDTH];
							wire [0:0] dispatch_sid = dispatch_data[(issue_idx * IN_DATAW) + 464+:VX_gpu_pkg_SIMD_IDX_W];
							wire dispatch_sop = dispatch_data[(issue_idx * IN_DATAW) + 1];
							wire dispatch_eop = dispatch_data[issue_idx * IN_DATAW];
							wire [3:0] dispatch_tmask;
							wire [383:0] dispatch_rsdata;
							assign dispatch_tmask = dispatch_data[(issue_idx * IN_DATAW) + DATA_IN_TMASK_OFF+:4];
							assign dispatch_rsdata[0+:128] = dispatch_data[(issue_idx * IN_DATAW) + 258+:128];
							assign dispatch_rsdata[128+:128] = dispatch_data[(issue_idx * IN_DATAW) + 130+:128];
							assign dispatch_rsdata[256+:128] = dispatch_data[(issue_idx * IN_DATAW) + 2+:128];
							wire valid_p;
							wire ready_p;
							if (1) begin : g_full_simd
								assign valid_p = dispatch_valid[issue_idx];
								assign block_tmask[block_idx * 4+:4] = dispatch_tmask;
								assign block_rsdata[32 * (4 * (block_idx * 3))+:384] = dispatch_rsdata;
								assign block_pid[block_idx+:1] = 0;
								assign block_sop[block_idx] = 1;
								assign block_eop[block_idx] = 1;
								assign block_ready[block_idx] = ready_p;
								assign block_done[block_idx] = ready_p || ~valid_p;
							end
							wire [0:0] isw;
							if (1) begin : g_isw
								assign isw = block_idx;
							end
							wire [1:0] block_wid = VX_gpu_pkg_wis_to_wid(dispatch_wis, isw);
							wire [0:0] warp_pid = block_pid[block_idx+:1] + sv2v_cast_1(dispatch_sid * NUM_PACKETS);
							wire warp_sop = block_sop[block_idx] && dispatch_sop;
							wire warp_eop = block_eop[block_idx] && dispatch_eop;
							VX_elastic_buffer #(
								.DATAW(OUT_DATAW),
								.SIZE(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : 2)),
								.OUT_REG(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : (OUT_BUF & 7) - 2))
							) buf_out(
								.clk(clk),
								.reset(reset),
								.valid_in(valid_p),
								.ready_in(ready_p),
								.data_in({dispatch_data[(issue_idx * IN_DATAW) + 512-:VX_gpu_pkg_UUID_WIDTH], block_wid, dispatch_cta_id, block_tmask[block_idx * 4+:4], warp_pid, warp_sop, warp_eop, dispatch_data[(issue_idx * IN_DATAW) + 459-:74], block_rsdata[32 * ((block_idx * 3) * 4)+:128], block_rsdata[32 * (((block_idx * 3) + 1) * 4)+:128], block_rsdata[32 * (((block_idx * 3) + 2) * 4)+:128]}),
								.data_out(vortex_core_wrap.core.execute.fpu_unit.per_block_execute_if[block_idx + _mbase_execute_if].data),
								.valid_out(vortex_core_wrap.core.execute.fpu_unit.per_block_execute_if[block_idx + _mbase_execute_if].valid),
								.ready_out(vortex_core_wrap.core.execute.fpu_unit.per_block_execute_if[block_idx + _mbase_execute_if].ready)
							);
						end
						reg [0:0] ready_in;
						always @(*) begin
							ready_in = 0;
							begin : sv2v_autoblock_14
								integer block_idx;
								for (block_idx = 0; block_idx < BLOCK_SIZE; block_idx = block_idx + 1)
									ready_in[issue_indices[block_idx+:1]] = block_ready[block_idx] && block_eop[block_idx];
							end
						end
						assign dispatch_ready = ready_in;
					end
					assign lane_dispatch.clk = clk;
					assign lane_dispatch.reset = reset;
					genvar _arr_0F2E1;
					for (_arr_0F2E1 = 0; _arr_0F2E1 <= 0; _arr_0F2E1 = _arr_0F2E1 + 1) begin : per_block_result_if
						wire valid;
						wire [227:0] data;
						wire ready;
					end
					genvar _gv_block_idx_6;
					localparam VX_gpu_pkg_INST_FPU_MISC = 4'b1110;
					localparam VX_gpu_pkg_INST_FRM_DYN = 3'b111;
					for (_gv_block_idx_6 = 0; _gv_block_idx_6 < BLOCK_SIZE; _gv_block_idx_6 = _gv_block_idx_6 + 1) begin : g_blocks
						localparam block_idx = _gv_block_idx_6;
						wire fpu_req_valid;
						wire fpu_req_ready;
						wire fpu_rsp_valid;
						wire fpu_rsp_ready;
						wire [127:0] fpu_rsp_result;
						wire [4:0] fpu_rsp_fflags;
						wire fpu_rsp_has_fflags;
						wire [99:0] fpu_hdr;
						reg [99:0] fpu_hdr_wb;
						reg [99:0] fpu_hdr_store;
						always @(*) begin
							if (_sv2v_0)
								;
							fpu_hdr_store = per_block_execute_if[block_idx].data[512-:100];
							fpu_hdr_store[12] = 1'b0;
						end
						always @(*) begin
							if (_sv2v_0)
								;
							fpu_hdr_wb = fpu_hdr;
							fpu_hdr_wb[12] = 1'b1;
						end
						wire [0:0] fpu_req_tag;
						wire [0:0] fpu_rsp_tag;
						wire mdata_full;
						wire [1:0] fpu_fmt = per_block_execute_if[block_idx].data[385-:VX_gpu_pkg_INST_FMT_BITS];
						wire [2:0] fpu_frm = per_block_execute_if[block_idx].data[388-:3];
						wire execute_fire = per_block_execute_if[block_idx].valid && per_block_execute_if[block_idx].ready;
						wire fpu_rsp_fire = fpu_rsp_valid && fpu_rsp_ready;
						VX_index_buffer #(
							.DATAW(100),
							.SIZE(2)
						) tag_store(
							.clk(clk),
							.reset(reset),
							.acquire_en(execute_fire),
							.write_addr(fpu_req_tag),
							.write_data(fpu_hdr_store),
							.read_data(fpu_hdr),
							.read_addr(fpu_rsp_tag),
							.release_en(fpu_rsp_fire),
							.full(mdata_full),
							.empty()
						);
						wire [2:0] fpu_req_frm;
						if (1) begin : genblk1
							assign vortex_core_wrap.core.execute.fpu_csr_if[block_idx + _mbase_fpu_csr_if].read_wid = per_block_execute_if[block_idx].data[468-:2];
						end
						assign fpu_req_frm = ((per_block_execute_if[block_idx].data[412-:4] != VX_gpu_pkg_INST_FPU_MISC) && (fpu_frm == VX_gpu_pkg_INST_FRM_DYN) ? vortex_core_wrap.core.execute.fpu_csr_if[block_idx + _mbase_fpu_csr_if].read_frm : fpu_frm);
						assign fpu_req_valid = per_block_execute_if[block_idx].valid && ~mdata_full;
						assign per_block_execute_if[block_idx].ready = fpu_req_ready && ~mdata_full;
						VX_fpu_dsp #(
							.NUM_LANES(NUM_LANES),
							.TAG_WIDTH(TAG_WIDTH),
							.OUT_BUF((PARTIAL_BW ? 1 : 3))
						) fpu_dsp(
							.clk(clk),
							.reset(reset),
							.valid_in(fpu_req_valid),
							.mask_in(per_block_execute_if[block_idx].data[464-:4]),
							.op_type(per_block_execute_if[block_idx].data[412-:4]),
							.fmt(fpu_fmt),
							.frm(fpu_req_frm),
							.dataa(per_block_execute_if[block_idx].data[383-:128]),
							.datab(per_block_execute_if[block_idx].data[255-:128]),
							.datac(per_block_execute_if[block_idx].data[127-:128]),
							.tag_in(fpu_req_tag),
							.ready_in(fpu_req_ready),
							.valid_out(fpu_rsp_valid),
							.result(fpu_rsp_result),
							.has_fflags(fpu_rsp_has_fflags),
							.fflags(fpu_rsp_fflags),
							.tag_out(fpu_rsp_tag),
							.ready_out(fpu_rsp_ready)
						);
						wire [4:0] fpu_rsp_fflags_q;
						if (1) begin : g_fflags_no_pid
							assign fpu_rsp_fflags_q = fpu_rsp_fflags;
						end
						if (1) begin : fpu_csr_tmp_if
							wire write_enable;
							localparam VX_gpu_pkg_NW_BITS = 2;
							localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
							wire [1:0] write_wid;
							wire [4:0] write_fflags;
							wire [1:0] read_wid;
							localparam VX_gpu_pkg_INST_FRM_BITS = 3;
							wire [2:0] read_frm;
						end
						assign fpu_csr_tmp_if.write_enable = (fpu_rsp_fire && fpu_hdr[45]) && fpu_rsp_has_fflags;
						if (1) begin : genblk3
							assign fpu_csr_tmp_if.write_wid = fpu_hdr[55-:2];
						end
						assign fpu_csr_tmp_if.write_fflags = fpu_rsp_fflags_q;
						VX_pipe_register #(
							.DATAW(8),
							.RESETW(1)
						) fpu_csr_reg(
							.clk(clk),
							.reset(reset),
							.enable(1'b1),
							.data_in({fpu_csr_tmp_if.write_enable, fpu_csr_tmp_if.write_wid, fpu_csr_tmp_if.write_fflags}),
							.data_out({vortex_core_wrap.core.execute.fpu_csr_if[block_idx + _mbase_fpu_csr_if].write_enable, vortex_core_wrap.core.execute.fpu_csr_if[block_idx + _mbase_fpu_csr_if].write_wid, vortex_core_wrap.core.execute.fpu_csr_if[block_idx + _mbase_fpu_csr_if].write_fflags})
						);
						VX_elastic_buffer #(
							.DATAW(228),
							.SIZE(0)
						) rsp_buf(
							.clk(clk),
							.reset(reset),
							.valid_in(fpu_rsp_valid),
							.ready_in(fpu_rsp_ready),
							.data_in({fpu_hdr_wb, fpu_rsp_result}),
							.data_out(per_block_result_if[block_idx].data),
							.valid_out(per_block_result_if[block_idx].valid),
							.ready_out(per_block_result_if[block_idx].ready)
						);
					end
					localparam _bbase_71D3D_result_if = 0;
					localparam _bbase_71D3D_commit_if = 3;
					localparam _param_71D3D_BLOCK_SIZE = BLOCK_SIZE;
					localparam _param_71D3D_NUM_LANES = NUM_LANES;
					localparam _param_71D3D_OUT_BUF = (PARTIAL_BW ? 3 : 0);
					if (1) begin : lane_gather
						localparam BLOCK_SIZE = _param_71D3D_BLOCK_SIZE;
						localparam NUM_LANES = _param_71D3D_NUM_LANES;
						localparam OUT_BUF = _param_71D3D_OUT_BUF;
						wire clk;
						wire reset;
						localparam _mbase_result_if = 0;
						localparam _mbase_commit_if = _bbase_71D3D_commit_if;
						localparam VX_gpu_pkg_XLENB = 4;
						localparam VX_gpu_pkg_XLENB_W = 2;
						localparam VX_gpu_pkg_BYTESEL_BITS = 4;
						localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
						localparam VX_gpu_pkg_NCTA_BITS = 2;
						localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
						localparam VX_gpu_pkg_REG_TYPES = 2;
						localparam VX_gpu_pkg_RV_REGS = 32;
						localparam VX_gpu_pkg_NUM_REGS = 64;
						localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
						localparam VX_gpu_pkg_NUM_XREGS = 2;
						localparam VX_gpu_pkg_NW_BITS = 2;
						localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
						localparam VX_gpu_pkg_PC_BITS = 32;
						localparam VX_gpu_pkg_UUID_WIDTH = 44;
						localparam VX_gpu_pkg_INST_OP_BITS = 4;
						localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
						localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
						localparam VX_gpu_pkg_INST_FMT_BITS = 2;
						localparam VX_gpu_pkg_INST_FRM_BITS = 3;
						localparam BLOCK_SIZE_W = 1;
						localparam NUM_PACKETS = 1;
						localparam LPID_BITS = 0;
						localparam LPID_WIDTH = 1;
						localparam DATAW = 228;
						localparam DATA_WIS_OFF = 182;
						wire [0:0] result_in_valid;
						wire [227:0] result_in_data;
						wire [0:0] result_in_ready;
						localparam VX_gpu_pkg_ISSUE_ISW_BITS = 0;
						localparam VX_gpu_pkg_ISSUE_ISW_W = 1;
						wire [0:0] result_in_isw;
						genvar _gv_i_77;
						for (_gv_i_77 = 0; _gv_i_77 < BLOCK_SIZE; _gv_i_77 = _gv_i_77 + 1) begin : g_commit_in
							localparam i = _gv_i_77;
							assign result_in_valid[i] = vortex_core_wrap.core.execute.fpu_unit.per_block_result_if[i + _mbase_result_if].valid;
							assign result_in_data[i * DATAW+:DATAW] = vortex_core_wrap.core.execute.fpu_unit.per_block_result_if[i + _mbase_result_if].data;
							assign vortex_core_wrap.core.execute.fpu_unit.per_block_result_if[i + _mbase_result_if].ready = result_in_ready[i];
							if (1) begin : g_result_in_isw_full
								assign result_in_isw[i+:1] = sv2v_cast_1_signed(i);
							end
						end
						reg [0:0] result_out_valid;
						reg [227:0] result_out_data;
						wire [0:0] result_out_ready;
						always @(*) begin
							result_out_valid = 1'sb0;
							begin : sv2v_autoblock_15
								integer i;
								for (i = 0; i < 1; i = i + 1)
									result_out_data[i * DATAW+:DATAW] = 1'sbx;
							end
							begin : sv2v_autoblock_16
								integer i;
								for (i = 0; i < BLOCK_SIZE; i = i + 1)
									begin
										result_out_valid[result_in_isw[i+:1]] = result_in_valid[i];
										result_out_data[result_in_isw[i+:1] * DATAW+:DATAW] = result_in_data[i * DATAW+:DATAW];
									end
							end
						end
						genvar _gv_i_78;
						for (_gv_i_78 = 0; _gv_i_78 < BLOCK_SIZE; _gv_i_78 = _gv_i_78 + 1) begin : g_result_in_ready
							localparam i = _gv_i_78;
							assign result_in_ready[i] = result_out_ready[result_in_isw[i+:1]];
						end
						genvar _gv_i_79;
						localparam VX_gpu_pkg_SIMD_COUNT = 1;
						localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
						localparam VX_gpu_pkg_SIMD_IDX_W = 1;
						for (_gv_i_79 = 0; _gv_i_79 < 1; _gv_i_79 = _gv_i_79 + 1) begin : g_out_bufs
							localparam i = _gv_i_79;
							if (1) begin : result_tmp_if
								wire valid;
								wire [227:0] data;
								wire ready;
							end
							VX_elastic_buffer #(
								.DATAW(DATAW),
								.SIZE(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : 2)),
								.OUT_REG(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : (OUT_BUF & 7) - 2))
							) out_buf(
								.clk(clk),
								.reset(reset),
								.valid_in(result_out_valid[i]),
								.ready_in(result_out_ready[i]),
								.data_in(result_out_data[i * DATAW+:DATAW]),
								.data_out(result_tmp_if.data),
								.valid_out(result_tmp_if.valid),
								.ready_out(result_tmp_if.ready)
							);
							wire [0:0] commit_sid_w;
							wire [3:0] commit_tmask_w;
							wire [127:0] commit_data_w;
							if (1) begin : g_no_lpid
								assign commit_sid_w = sv2v_cast_1(result_tmp_if.data[175-:1]);
								assign commit_tmask_w = result_tmp_if.data[179-:4];
								assign commit_data_w = result_tmp_if.data[127-:128];
							end
							assign vortex_core_wrap.core.commit_if[i + _mbase_commit_if].valid = result_tmp_if.valid;
							assign vortex_core_wrap.core.commit_if[i + _mbase_commit_if].data = {result_tmp_if.data[227-:44], result_tmp_if.data[183-:2], result_tmp_if.data[181-:2], commit_sid_w, commit_tmask_w, result_tmp_if.data[172-:32], result_tmp_if.data[140], result_tmp_if.data[139-:2], result_tmp_if.data[137-:6], result_tmp_if.data[131-:VX_gpu_pkg_BYTESEL_BITS], commit_data_w, result_tmp_if.data[174], result_tmp_if.data[173]};
							assign result_tmp_if.ready = vortex_core_wrap.core.commit_if[i + _mbase_commit_if].ready;
						end
					end
					assign lane_gather.clk = clk;
					assign lane_gather.reset = reset;
					initial _sv2v_0 = 0;
				end
				assign fpu_unit.clk = clk;
				assign fpu_unit.reset = reset;
				localparam _bbase_F444A_dispatch_if = 2;
				localparam _bbase_F444A_commit_if = 2;
				localparam _bbase_F444A_fpu_csr_if = 0;
				localparam _param_F444A_INSTANCE_ID = "";
				localparam _param_F444A_CORE_ID = CORE_ID;
				if (1) begin : sfu_unit
					localparam INSTANCE_ID = _param_F444A_INSTANCE_ID;
					localparam CORE_ID = _param_F444A_CORE_ID;
					wire clk;
					wire reset;
					localparam _mbase_dispatch_if = _bbase_F444A_dispatch_if;
					localparam _mbase_fpu_csr_if = 0;
					localparam _mbase_commit_if = _bbase_F444A_commit_if;
					localparam BLOCK_SIZE = 1;
					localparam NUM_LANES = 4;
					localparam PE_COUNT = 2;
					localparam PE_SEL_BITS = 1;
					localparam PE_IDX_WCTL = 0;
					localparam PE_IDX_CSRS = 1;
					localparam VX_gpu_pkg_INST_OP_BITS = 4;
					localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
					localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
					localparam VX_gpu_pkg_INST_FMT_BITS = 2;
					localparam VX_gpu_pkg_INST_FRM_BITS = 3;
					localparam VX_gpu_pkg_XLENB = 4;
					localparam VX_gpu_pkg_XLENB_W = 2;
					localparam VX_gpu_pkg_BYTESEL_BITS = 4;
					localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
					localparam VX_gpu_pkg_NCTA_BITS = 2;
					localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
					localparam VX_gpu_pkg_REG_TYPES = 2;
					localparam VX_gpu_pkg_RV_REGS = 32;
					localparam VX_gpu_pkg_NUM_REGS = 64;
					localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
					localparam VX_gpu_pkg_NUM_XREGS = 2;
					localparam VX_gpu_pkg_NW_BITS = 2;
					localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
					localparam VX_gpu_pkg_PC_BITS = 32;
					localparam VX_gpu_pkg_UUID_WIDTH = 44;
					genvar _arr_46AD4;
					for (_arr_46AD4 = 0; _arr_46AD4 <= 0; _arr_46AD4 = _arr_46AD4 + 1) begin : per_block_execute_if
						wire valid;
						wire [512:0] data;
						wire ready;
					end
					genvar _arr_D7CE2;
					for (_arr_D7CE2 = 0; _arr_D7CE2 <= 0; _arr_D7CE2 = _arr_D7CE2 + 1) begin : per_block_result_if
						wire valid;
						wire [227:0] data;
						wire ready;
					end
					localparam _bbase_25CCE_dispatch_if = 2;
					localparam _bbase_25CCE_execute_if = 0;
					localparam _param_25CCE_BLOCK_SIZE = BLOCK_SIZE;
					localparam _param_25CCE_NUM_LANES = NUM_LANES;
					localparam _param_25CCE_OUT_BUF = 3;
					if (1) begin : lane_dispatch
						localparam BLOCK_SIZE = _param_25CCE_BLOCK_SIZE;
						localparam NUM_LANES = _param_25CCE_NUM_LANES;
						localparam OUT_BUF = _param_25CCE_OUT_BUF;
						localparam MAX_FANOUT = 8;
						wire clk;
						wire reset;
						localparam _mbase_dispatch_if = _bbase_25CCE_dispatch_if;
						localparam _mbase_execute_if = 0;
						localparam VX_gpu_pkg_XLENB = 4;
						localparam VX_gpu_pkg_XLENB_W = 2;
						localparam VX_gpu_pkg_BYTESEL_BITS = 4;
						localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
						localparam VX_gpu_pkg_NCTA_BITS = 2;
						localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
						localparam VX_gpu_pkg_REG_TYPES = 2;
						localparam VX_gpu_pkg_RV_REGS = 32;
						localparam VX_gpu_pkg_NUM_REGS = 64;
						localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
						localparam VX_gpu_pkg_NUM_XREGS = 2;
						localparam VX_gpu_pkg_NW_BITS = 2;
						localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
						localparam VX_gpu_pkg_PC_BITS = 32;
						localparam VX_gpu_pkg_UUID_WIDTH = 44;
						localparam VX_gpu_pkg_INST_OP_BITS = 4;
						localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
						localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
						localparam VX_gpu_pkg_INST_FMT_BITS = 2;
						localparam VX_gpu_pkg_INST_FRM_BITS = 3;
						localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
						localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
						localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
						localparam VX_gpu_pkg_SIMD_COUNT = 1;
						localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
						localparam VX_gpu_pkg_SIMD_IDX_W = 1;
						localparam IN_DATAW = 513;
						localparam OUT_DATAW = 513;
						localparam BLOCK_SIZE_W = 1;
						localparam NUM_PACKETS = 1;
						localparam LPID_BITS = 0;
						localparam LPID_WIDTH = 1;
						localparam GPID_BITS = 0;
						localparam GPID_WIDTH = 1;
						localparam BATCH_COUNT = 1;
						localparam BATCH_COUNT_W = 1;
						localparam ISSUE_W = 1;
						localparam FANOUT_ENABLE = 1'd0;
						localparam DATA_IN_TMASK_OFF = 460;
						localparam DATA_IN_OPDS_OFF = 2;
						wire [0:0] dispatch_valid;
						wire [512:0] dispatch_data;
						wire [0:0] dispatch_ready;
						genvar _gv_i_74;
						for (_gv_i_74 = 0; _gv_i_74 < 1; _gv_i_74 = _gv_i_74 + 1) begin : g_dispatch_data
							localparam i = _gv_i_74;
							assign dispatch_valid[i] = vortex_core_wrap.core.dispatch_if[i + _mbase_dispatch_if].valid;
							assign dispatch_data[i * IN_DATAW+:IN_DATAW] = vortex_core_wrap.core.dispatch_if[i + _mbase_dispatch_if].data;
							assign vortex_core_wrap.core.dispatch_if[i + _mbase_dispatch_if].ready = dispatch_ready[i];
						end
						wire [0:0] block_ready;
						wire [3:0] block_tmask;
						wire [383:0] block_rsdata;
						wire [0:0] block_pid;
						wire [0:0] block_sop;
						wire [0:0] block_eop;
						wire [0:0] block_done;
						wire batch_done = &block_done;
						wire [0:0] batch_idx;
						if (1) begin : g_batch_idx_0
							assign batch_idx = 0;
						end
						wire [0:0] issue_indices;
						genvar _gv_block_idx_3;
						for (_gv_block_idx_3 = 0; _gv_block_idx_3 < BLOCK_SIZE; _gv_block_idx_3 = _gv_block_idx_3 + 1) begin : g_issue_indices
							localparam block_idx = _gv_block_idx_3;
							assign issue_indices[block_idx+:1] = sv2v_cast_1(batch_idx * BLOCK_SIZE) + sv2v_cast_1_signed(block_idx);
						end
						genvar _gv_block_idx_4;
						localparam VX_gpu_pkg_ISSUE_ISW_BITS = 0;
						localparam VX_gpu_pkg_ISSUE_ISW_W = 1;
						localparam VX_gpu_pkg_NUM_SRC_OPDS = 3;
						function automatic [1:0] VX_gpu_pkg_wis_to_wid;
							input reg [1:0] wis;
							input reg [0:0] isw;
							VX_gpu_pkg_wis_to_wid = wis;
						endfunction
						for (_gv_block_idx_4 = 0; _gv_block_idx_4 < BLOCK_SIZE; _gv_block_idx_4 = _gv_block_idx_4 + 1) begin : g_blocks
							localparam block_idx = _gv_block_idx_4;
							wire [0:0] issue_idx = issue_indices[block_idx+:1];
							wire [1:0] dispatch_wis = dispatch_data[(issue_idx * IN_DATAW) + 467+:VX_gpu_pkg_ISSUE_WIS_W];
							wire [1:0] dispatch_cta_id = dispatch_data[(issue_idx * IN_DATAW) + 465+:VX_gpu_pkg_NCTA_WIDTH];
							wire [0:0] dispatch_sid = dispatch_data[(issue_idx * IN_DATAW) + 464+:VX_gpu_pkg_SIMD_IDX_W];
							wire dispatch_sop = dispatch_data[(issue_idx * IN_DATAW) + 1];
							wire dispatch_eop = dispatch_data[issue_idx * IN_DATAW];
							wire [3:0] dispatch_tmask;
							wire [383:0] dispatch_rsdata;
							assign dispatch_tmask = dispatch_data[(issue_idx * IN_DATAW) + DATA_IN_TMASK_OFF+:4];
							assign dispatch_rsdata[0+:128] = dispatch_data[(issue_idx * IN_DATAW) + 258+:128];
							assign dispatch_rsdata[128+:128] = dispatch_data[(issue_idx * IN_DATAW) + 130+:128];
							assign dispatch_rsdata[256+:128] = dispatch_data[(issue_idx * IN_DATAW) + 2+:128];
							wire valid_p;
							wire ready_p;
							if (1) begin : g_full_simd
								assign valid_p = dispatch_valid[issue_idx];
								assign block_tmask[block_idx * 4+:4] = dispatch_tmask;
								assign block_rsdata[32 * (4 * (block_idx * 3))+:384] = dispatch_rsdata;
								assign block_pid[block_idx+:1] = 0;
								assign block_sop[block_idx] = 1;
								assign block_eop[block_idx] = 1;
								assign block_ready[block_idx] = ready_p;
								assign block_done[block_idx] = ready_p || ~valid_p;
							end
							wire [0:0] isw;
							if (1) begin : g_isw
								assign isw = block_idx;
							end
							wire [1:0] block_wid = VX_gpu_pkg_wis_to_wid(dispatch_wis, isw);
							wire [0:0] warp_pid = block_pid[block_idx+:1] + sv2v_cast_1(dispatch_sid * NUM_PACKETS);
							wire warp_sop = block_sop[block_idx] && dispatch_sop;
							wire warp_eop = block_eop[block_idx] && dispatch_eop;
							VX_elastic_buffer #(
								.DATAW(OUT_DATAW),
								.SIZE(2),
								.OUT_REG(1)
							) buf_out(
								.clk(clk),
								.reset(reset),
								.valid_in(valid_p),
								.ready_in(ready_p),
								.data_in({dispatch_data[(issue_idx * IN_DATAW) + 512-:VX_gpu_pkg_UUID_WIDTH], block_wid, dispatch_cta_id, block_tmask[block_idx * 4+:4], warp_pid, warp_sop, warp_eop, dispatch_data[(issue_idx * IN_DATAW) + 459-:74], block_rsdata[32 * ((block_idx * 3) * 4)+:128], block_rsdata[32 * (((block_idx * 3) + 1) * 4)+:128], block_rsdata[32 * (((block_idx * 3) + 2) * 4)+:128]}),
								.data_out(vortex_core_wrap.core.execute.sfu_unit.per_block_execute_if[block_idx + _mbase_execute_if].data),
								.valid_out(vortex_core_wrap.core.execute.sfu_unit.per_block_execute_if[block_idx + _mbase_execute_if].valid),
								.ready_out(vortex_core_wrap.core.execute.sfu_unit.per_block_execute_if[block_idx + _mbase_execute_if].ready)
							);
						end
						reg [0:0] ready_in;
						always @(*) begin
							ready_in = 0;
							begin : sv2v_autoblock_17
								integer block_idx;
								for (block_idx = 0; block_idx < BLOCK_SIZE; block_idx = block_idx + 1)
									ready_in[issue_indices[block_idx+:1]] = block_ready[block_idx] && block_eop[block_idx];
							end
						end
						assign dispatch_ready = ready_in;
					end
					assign lane_dispatch.clk = clk;
					assign lane_dispatch.reset = reset;
					genvar _arr_36EF0;
					for (_arr_36EF0 = 0; _arr_36EF0 <= 1; _arr_36EF0 = _arr_36EF0 + 1) begin : pe_execute_if
						wire valid;
						wire [512:0] data;
						wire ready;
					end
					genvar _arr_8E047;
					for (_arr_8E047 = 0; _arr_8E047 <= 1; _arr_8E047 = _arr_8E047 + 1) begin : pe_result_if
						wire valid;
						wire [227:0] data;
						wire ready;
					end
					reg [0:0] pe_select;
					localparam VX_gpu_pkg_INST_SFU_BITS = 4;
					function automatic VX_gpu_pkg_inst_sfu_is_csr;
						input reg [3:0] op;
						VX_gpu_pkg_inst_sfu_is_csr = (op >= 6) && (op <= 8);
					endfunction
					always @(*) begin
						pe_select = sv2v_cast_1_signed(PE_IDX_WCTL);
						if (VX_gpu_pkg_inst_sfu_is_csr(per_block_execute_if[0].data[412-:4]))
							pe_select = sv2v_cast_1_signed(PE_IDX_CSRS);
					end
					localparam _bbase_22B0F_execute_in_if = 0;
					localparam _bbase_22B0F_result_out_if = 0;
					localparam _bbase_22B0F_execute_out_if = 0;
					localparam _bbase_22B0F_result_in_if = 0;
					localparam _param_22B0F_PE_COUNT = PE_COUNT;
					localparam _param_22B0F_NUM_LANES = NUM_LANES;
					localparam _param_22B0F_ARBITER = "R";
					localparam _param_22B0F_REQ_OUT_BUF = 0;
					localparam _param_22B0F_RSP_OUT_BUF = 3;
					if (1) begin : pe_switch
						localparam PE_COUNT = _param_22B0F_PE_COUNT;
						localparam NUM_LANES = _param_22B0F_NUM_LANES;
						localparam REQ_OUT_BUF = _param_22B0F_REQ_OUT_BUF;
						localparam RSP_OUT_BUF = _param_22B0F_RSP_OUT_BUF;
						localparam ARBITER = _param_22B0F_ARBITER;
						localparam PE_SEL_BITS = 1;
						wire clk;
						wire reset;
						wire [0:0] pe_sel;
						localparam _mbase_execute_in_if = _bbase_22B0F_execute_in_if;
						localparam _mbase_result_out_if = _bbase_22B0F_result_out_if;
						localparam _mbase_execute_out_if = 0;
						localparam _mbase_result_in_if = 0;
						localparam VX_gpu_pkg_XLENB = 4;
						localparam VX_gpu_pkg_XLENB_W = 2;
						localparam VX_gpu_pkg_BYTESEL_BITS = 4;
						localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
						localparam VX_gpu_pkg_NCTA_BITS = 2;
						localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
						localparam VX_gpu_pkg_REG_TYPES = 2;
						localparam VX_gpu_pkg_RV_REGS = 32;
						localparam VX_gpu_pkg_NUM_REGS = 64;
						localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
						localparam VX_gpu_pkg_NUM_XREGS = 2;
						localparam VX_gpu_pkg_NW_BITS = 2;
						localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
						localparam VX_gpu_pkg_PC_BITS = 32;
						localparam VX_gpu_pkg_UUID_WIDTH = 44;
						localparam VX_gpu_pkg_INST_OP_BITS = 4;
						localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
						localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
						localparam VX_gpu_pkg_INST_FMT_BITS = 2;
						localparam VX_gpu_pkg_INST_FRM_BITS = 3;
						localparam REQ_DATAW = 513;
						localparam RSP_DATAW = 228;
						wire [1:0] pe_req_valid;
						wire [1025:0] pe_req_data;
						wire [1:0] pe_req_ready;
						VX_stream_switch #(
							.DATAW(REQ_DATAW),
							.NUM_INPUTS(1),
							.NUM_OUTPUTS(PE_COUNT),
							.OUT_BUF(REQ_OUT_BUF)
						) req_switch(
							.clk(clk),
							.reset(reset),
							.sel_in(pe_sel),
							.valid_in(vortex_core_wrap.core.execute.sfu_unit.per_block_execute_if[_mbase_execute_in_if].valid),
							.ready_in(vortex_core_wrap.core.execute.sfu_unit.per_block_execute_if[_mbase_execute_in_if].ready),
							.data_in(vortex_core_wrap.core.execute.sfu_unit.per_block_execute_if[_mbase_execute_in_if].data),
							.data_out(pe_req_data),
							.valid_out(pe_req_valid),
							.ready_out(pe_req_ready)
						);
						genvar _gv_i_101;
						for (_gv_i_101 = 0; _gv_i_101 < PE_COUNT; _gv_i_101 = _gv_i_101 + 1) begin : g_execute_out_if
							localparam i = _gv_i_101;
							assign vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[i + _mbase_execute_out_if].valid = pe_req_valid[i];
							assign vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[i + _mbase_execute_out_if].data = pe_req_data[i * REQ_DATAW+:REQ_DATAW];
							assign pe_req_ready[i] = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[i + _mbase_execute_out_if].ready;
						end
						wire [1:0] pe_rsp_valid;
						wire [455:0] pe_rsp_data;
						wire [1:0] pe_rsp_ready;
						genvar _gv_i_102;
						for (_gv_i_102 = 0; _gv_i_102 < PE_COUNT; _gv_i_102 = _gv_i_102 + 1) begin : g_result_in_if
							localparam i = _gv_i_102;
							assign pe_rsp_valid[i] = vortex_core_wrap.core.execute.sfu_unit.pe_result_if[i + _mbase_result_in_if].valid;
							assign pe_rsp_data[i * RSP_DATAW+:RSP_DATAW] = vortex_core_wrap.core.execute.sfu_unit.pe_result_if[i + _mbase_result_in_if].data;
							assign vortex_core_wrap.core.execute.sfu_unit.pe_result_if[i + _mbase_result_in_if].ready = pe_rsp_ready[i];
						end
						VX_stream_arb #(
							.NUM_INPUTS(PE_COUNT),
							.DATAW(RSP_DATAW),
							.ARBITER(ARBITER),
							.OUT_BUF(RSP_OUT_BUF)
						) rsp_arb(
							.clk(clk),
							.reset(reset),
							.valid_in(pe_rsp_valid),
							.ready_in(pe_rsp_ready),
							.data_in(pe_rsp_data),
							.data_out(vortex_core_wrap.core.execute.sfu_unit.per_block_result_if[_mbase_result_out_if].data),
							.valid_out(vortex_core_wrap.core.execute.sfu_unit.per_block_result_if[_mbase_result_out_if].valid),
							.ready_out(vortex_core_wrap.core.execute.sfu_unit.per_block_result_if[_mbase_result_out_if].ready),
							.sel_out()
						);
					end
					assign pe_switch.clk = clk;
					assign pe_switch.reset = reset;
					assign pe_switch.pe_sel = pe_select;
					if (1) begin : txbar_bus_if
						wire valid;
						localparam VX_gpu_pkg_NB_BITS = 3;
						localparam VX_gpu_pkg_NW_BITS = 2;
						localparam VX_gpu_pkg_BAR_ADDR_BITS = 5;
						localparam VX_gpu_pkg_BAR_ADDR_W = VX_gpu_pkg_BAR_ADDR_BITS;
						wire [5:0] data;
						wire ready;
					end
					localparam _bbase_B09A9_execute_if = PE_IDX_WCTL;
					localparam _bbase_B09A9_result_if = PE_IDX_WCTL;
					localparam _param_B09A9_INSTANCE_ID = "";
					localparam _param_B09A9_NUM_LANES = NUM_LANES;
					if (1) begin : wctl_unit
						localparam INSTANCE_ID = _param_B09A9_INSTANCE_ID;
						localparam NUM_LANES = _param_B09A9_NUM_LANES;
						wire clk;
						wire reset;
						localparam _mbase_execute_if = _bbase_B09A9_execute_if;
						localparam _mbase_result_if = _bbase_B09A9_result_if;
						localparam LANE_BITS = 2;
						localparam PID_BITS = 0;
						localparam VX_gpu_pkg_NC_BITS = 0;
						localparam VX_gpu_pkg_NC_WIDTH = 1;
						localparam VX_gpu_pkg_NW_BITS = 2;
						localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
						localparam VX_gpu_pkg_BAR_SIZE_W = 5;
						localparam VX_gpu_pkg_NB_BITS = 3;
						localparam VX_gpu_pkg_NB_WIDTH = VX_gpu_pkg_NB_BITS;
						localparam VX_gpu_pkg_DV_STACK_SIZE = 3;
						localparam VX_gpu_pkg_DV_STACK_SIZEW = 2;
						localparam VX_gpu_pkg_PC_BITS = 32;
						localparam WCTL_WIDTH = 100;
						wire [3:0] tmc;
						wire [35:0] wspawn;
						wire [40:0] split;
						wire [5:0] sjoin;
						wire [12:0] bar;
						localparam VX_gpu_pkg_INST_SFU_WSPAWN = 4'h1;
						wire is_wspawn = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[412-:4] == VX_gpu_pkg_INST_SFU_WSPAWN;
						localparam VX_gpu_pkg_INST_SFU_TMC = 4'h0;
						wire is_tmc = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[412-:4] == VX_gpu_pkg_INST_SFU_TMC;
						localparam VX_gpu_pkg_INST_SFU_PRED = 4'h5;
						wire is_pred = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[412-:4] == VX_gpu_pkg_INST_SFU_PRED;
						localparam VX_gpu_pkg_INST_SFU_SPLIT = 4'h2;
						wire is_split = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[412-:4] == VX_gpu_pkg_INST_SFU_SPLIT;
						localparam VX_gpu_pkg_INST_SFU_JOIN = 4'h3;
						wire is_join = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[412-:4] == VX_gpu_pkg_INST_SFU_JOIN;
						localparam VX_gpu_pkg_INST_SFU_BAR = 4'h4;
						wire is_bar = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[412-:4] == VX_gpu_pkg_INST_SFU_BAR;
						localparam VX_gpu_pkg_INST_SFU_WSYNC = 4'ha;
						wire is_wsync = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[412-:4] == VX_gpu_pkg_INST_SFU_WSYNC;
						wire wctl_valid;
						wire wspawn_valid;
						wire tmc_valid;
						wire split_valid;
						wire sjoin_valid;
						wire bar_valid;
						wire wsync_valid;
						wire [1:0] last_tid;
						if (1) begin : g_last_tid
							VX_priority_encoder #(
								.N(NUM_LANES),
								.REVERSE(1)
							) last_tid_select(
								.data_in(vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[464-:4]),
								.index_out(last_tid),
								.onehot_out(),
								.valid_out()
							);
						end
						wire [31:0] rs1_data = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[256 + (last_tid * 32)+:32];
						wire [31:0] rs2_data = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[128 + (last_tid * 32)+:32];
						wire not_pred = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[386];
						wire [3:0] taken;
						genvar _gv_i_115;
						for (_gv_i_115 = 0; _gv_i_115 < NUM_LANES; _gv_i_115 = _gv_i_115 + 1) begin : g_taken
							localparam i = _gv_i_115;
							assign taken[i] = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[256 + (i * 32)] ^ not_pred;
						end
						wire [3:0] then_tmask;
						wire [3:0] else_tmask;
						if (1) begin : g_no_pid
							assign then_tmask = taken & vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[464-:4];
							assign else_tmask = ~taken & vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[464-:4];
						end
						wire has_then = then_tmask != 0;
						wire has_else = else_tmask != 0;
						wire [3:0] pred_mask = (has_then ? then_tmask : rs2_data[3:0]);
						assign tmc_valid = wctl_valid && (is_tmc || is_pred);
						assign tmc[3-:4] = (is_pred ? pred_mask : rs1_data[3:0]);
						wire [2:0] then_tmask_cnt;
						wire [2:0] else_tmask_cnt;
						VX_popcount #(
							.N(4),
							.MODEL(1)
						) __pop_count_ex117(
							.data_in(then_tmask),
							.data_out(then_tmask_cnt)
						);
						VX_popcount #(
							.N(4),
							.MODEL(1)
						) __pop_count_ex118(
							.data_in(else_tmask),
							.data_out(else_tmask_cnt)
						);
						wire then_first = then_tmask_cnt <= else_tmask_cnt;
						wire [3:0] taken_tmask = (then_first ? then_tmask : else_tmask);
						wire [3:0] ntaken_tmask = (then_first ? else_tmask : then_tmask);
						assign split_valid = wctl_valid && is_split;
						assign split[40] = has_then && has_else;
						assign split[39-:4] = taken_tmask;
						assign split[35-:4] = ntaken_tmask;
						function automatic [31:0] VX_gpu_pkg_from_fullPC;
							input reg [31:0] pc;
							VX_gpu_pkg_from_fullPC = pc;
						endfunction
						assign split[31-:VX_gpu_pkg_PC_BITS] = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[457-:32] + VX_gpu_pkg_from_fullPC(32'sd4);
						assign sjoin_valid = wctl_valid && is_join;
						assign sjoin[5-:4] = then_tmask | else_tmask;
						assign sjoin[1-:VX_gpu_pkg_DV_STACK_SIZEW] = rs1_data[1:0];
						localparam VX_gpu_pkg_BAR_ADDR_BITS = 5;
						localparam VX_gpu_pkg_BAR_ADDR_W = VX_gpu_pkg_BAR_ADDR_BITS;
						wire [4:0] wctl_bar_addr;
						localparam VX_gpu_pkg_BAR_ID_SHIFT = 8;
						if (1) begin : genblk4
							assign wctl_bar_addr = {rs1_data[1:0], rs1_data[VX_gpu_pkg_BAR_ID_SHIFT+:VX_gpu_pkg_NB_BITS]};
						end
						wire wctl_bar_enable = wctl_valid && is_bar;
						wire is_tx_expect = (wctl_bar_enable && vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[384]) && rs2_data[31];
						assign bar_valid = wctl_bar_enable || vortex_core_wrap.core.execute.sfu_unit.txbar_bus_if.valid;
						assign bar[12-:3] = rs1_data[VX_gpu_pkg_BAR_ID_SHIFT+:VX_gpu_pkg_NB_BITS];
						assign bar[9] = (vortex_core_wrap.core.execute.sfu_unit.txbar_bus_if.valid && ~wctl_bar_enable) || is_tx_expect;
						assign bar[6] = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[385];
						assign bar[8] = wctl_bar_enable && rs1_data[31];
						assign bar[7] = (vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[384] && ~rs2_data[31]) || vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[385];
						assign bar[5] = (is_tx_expect ? 1'b1 : (wctl_bar_enable ? rs2_data[0] : ~vortex_core_wrap.core.execute.sfu_unit.txbar_bus_if.data[0]));
						assign bar[4-:VX_gpu_pkg_BAR_SIZE_W] = rs2_data[4:0] - 5'sd1;
						assign vortex_core_wrap.core.execute.sfu_unit.txbar_bus_if.ready = ~wctl_bar_enable;
						wire [3:0] wspawn_wmask;
						genvar _gv_i_116;
						for (_gv_i_116 = 0; _gv_i_116 < 4; _gv_i_116 = _gv_i_116 + 1) begin : g_wspawn_wmask
							localparam i = _gv_i_116;
							assign wspawn_wmask[i] = (i < rs1_data[VX_gpu_pkg_NW_BITS:0]) && (i != vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[468-:2]);
						end
						assign wspawn_valid = wctl_valid && is_wspawn;
						assign wspawn[35-:4] = wspawn_wmask;
						assign wspawn[31-:VX_gpu_pkg_PC_BITS] = VX_gpu_pkg_from_fullPC(rs2_data);
						assign vortex_core_wrap.core.warp_ctl_if.dvstack_wid = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[468-:2];
						assign vortex_core_wrap.core.warp_ctl_if.bar_addr = (wctl_bar_enable ? wctl_bar_addr : vortex_core_wrap.core.execute.sfu_unit.txbar_bus_if.data[5-:5]);
						wire wsync_drain = (vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].valid && is_wsync) && !vortex_core_wrap.core.warp_ctl_if.warp_pending_alm_empty[vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[468-:2]];
						wire bar_drain = (vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].valid && is_bar) && !vortex_core_wrap.core.warp_ctl_if.lsu_sched_drained;
						wire execute_fire = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].valid && vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].ready;
						assign wctl_valid = execute_fire && vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[458];
						assign wsync_valid = wctl_valid && is_wsync;
						VX_pipe_register #(
							.DATAW(108),
							.RESETW(1)
						) wctl_reg(
							.clk(clk),
							.reset(reset),
							.enable(1'b1),
							.data_in({tmc_valid, wspawn_valid, split_valid, sjoin_valid, bar_valid, wsync_valid, vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[468-:2], tmc, wspawn, split, sjoin, bar}),
							.data_out({vortex_core_wrap.core.warp_ctl_if.tmc_valid, vortex_core_wrap.core.warp_ctl_if.wspawn_valid, vortex_core_wrap.core.warp_ctl_if.split_valid, vortex_core_wrap.core.warp_ctl_if.sjoin_valid, vortex_core_wrap.core.warp_ctl_if.bar_valid, vortex_core_wrap.core.warp_ctl_if.wsync_valid, vortex_core_wrap.core.warp_ctl_if.wid, vortex_core_wrap.core.warp_ctl_if.tmc, vortex_core_wrap.core.warp_ctl_if.wspawn, vortex_core_wrap.core.warp_ctl_if.split, vortex_core_wrap.core.warp_ctl_if.sjoin, vortex_core_wrap.core.warp_ctl_if.bar})
						);
						wire [1:0] dvstack_ptr_r;
						wire bar_rsp_valid = is_bar && vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[384];
						wire bar_rsp_valid_r;
						wire bar_phase_r;
						wire rsp_buf_ready;
						localparam VX_gpu_pkg_XLENB = 4;
						localparam VX_gpu_pkg_XLENB_W = 2;
						localparam VX_gpu_pkg_BYTESEL_BITS = 4;
						localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
						localparam VX_gpu_pkg_NCTA_BITS = 2;
						localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
						localparam VX_gpu_pkg_REG_TYPES = 2;
						localparam VX_gpu_pkg_RV_REGS = 32;
						localparam VX_gpu_pkg_NUM_REGS = 64;
						localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
						localparam VX_gpu_pkg_NUM_XREGS = 2;
						localparam VX_gpu_pkg_UUID_WIDTH = 44;
						VX_elastic_buffer #(
							.DATAW(104),
							.SIZE(2)
						) rsp_buf(
							.clk(clk),
							.reset(reset),
							.valid_in((vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].valid && !wsync_drain) && !bar_drain),
							.ready_in(rsp_buf_ready),
							.data_in({vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[512-:100], vortex_core_wrap.core.warp_ctl_if.dvstack_ptr, vortex_core_wrap.core.warp_ctl_if.bar_phase, bar_rsp_valid}),
							.data_out({vortex_core_wrap.core.execute.sfu_unit.pe_result_if[_mbase_result_if].data[227-:100], dvstack_ptr_r, bar_phase_r, bar_rsp_valid_r}),
							.valid_out(vortex_core_wrap.core.execute.sfu_unit.pe_result_if[_mbase_result_if].valid),
							.ready_out(vortex_core_wrap.core.execute.sfu_unit.pe_result_if[_mbase_result_if].ready)
						);
						assign vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].ready = (rsp_buf_ready && !wsync_drain) && !bar_drain;
						genvar _gv_i_117;
						for (_gv_i_117 = 0; _gv_i_117 < NUM_LANES; _gv_i_117 = _gv_i_117 + 1) begin : g_result_if
							localparam i = _gv_i_117;
							assign vortex_core_wrap.core.execute.sfu_unit.pe_result_if[_mbase_result_if].data[0 + (i * 32)+:32] = (bar_rsp_valid_r ? sv2v_cast_32(bar_phase_r) : sv2v_cast_32(dvstack_ptr_r));
						end
					end
					assign wctl_unit.clk = clk;
					assign wctl_unit.reset = reset;
					localparam _bbase_76F6B_execute_if = PE_IDX_CSRS;
					localparam _bbase_76F6B_fpu_csr_if = 0;
					localparam _bbase_76F6B_result_if = PE_IDX_CSRS;
					localparam _param_76F6B_INSTANCE_ID = "";
					localparam _param_76F6B_CORE_ID = CORE_ID;
					localparam _param_76F6B_NUM_LANES = NUM_LANES;
					if (1) begin : csr_unit
						localparam INSTANCE_ID = _param_76F6B_INSTANCE_ID;
						localparam CORE_ID = _param_76F6B_CORE_ID;
						localparam NUM_LANES = _param_76F6B_NUM_LANES;
						wire clk;
						wire reset;
						localparam _mbase_fpu_csr_if = 0;
						localparam _mbase_execute_if = _bbase_76F6B_execute_if;
						localparam _mbase_result_if = _bbase_76F6B_result_if;
						localparam PID_BITS = 0;
						reg [127:0] csr_read_data;
						reg [31:0] csr_write_data;
						wire [31:0] csr_read_data_ro;
						wire [31:0] csr_read_data_rw;
						wire [31:0] csr_req_data;
						reg csr_rd_enable;
						wire csr_wr_enable;
						wire csr_req_ready;
						wire [11:0] csr_addr = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[400-:12];
						localparam VX_gpu_pkg_RV_REGS_BITS = 5;
						wire [4:0] csr_imm = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[388-:5];
						localparam CTA_READ_LATENCY = 2'd1;
						reg [1:0] cta_read_wait_r;
						always @(posedge clk)
							if (reset)
								cta_read_wait_r <= 2'd0;
							else if (vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].valid && vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].ready)
								cta_read_wait_r <= 2'd0;
							else if (vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].valid) begin
								if (cta_read_wait_r != CTA_READ_LATENCY)
									cta_read_wait_r <= cta_read_wait_r + 2'd1;
							end
							else
								cta_read_wait_r <= 2'd0;
						wire cta_read_done = cta_read_wait_r == CTA_READ_LATENCY;
						wire csr_req_valid = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].valid && cta_read_done;
						assign vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].ready = csr_req_ready && cta_read_done;
						wire [11:0] csr_read_addr = (csr_req_valid ? csr_addr : vortex_core_wrap.core.dcr_csr_if.addr);
						wire [7:0] mpm_class = (csr_req_valid ? 0 : vortex_core_wrap.core.dcr_csr_if.mpm_class);
						assign vortex_core_wrap.core.dcr_csr_if.ready = ~csr_req_valid;
						localparam VX_gpu_pkg_VX_DCR_DATA_WIDTH = 32;
						assign vortex_core_wrap.core.dcr_csr_if.value = csr_read_data_ro;
						wire [127:0] rs1_data;
						genvar _gv_i_63;
						for (_gv_i_63 = 0; _gv_i_63 < NUM_LANES; _gv_i_63 = _gv_i_63 + 1) begin : g_rs1_data
							localparam i = _gv_i_63;
							assign rs1_data[i * 32+:32] = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[256 + (i * 32)+:32];
						end
						localparam VX_gpu_pkg_INST_SFU_CSRRW = 4'h6;
						wire csr_write_enable = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[412-:4] == VX_gpu_pkg_INST_SFU_CSRRW;
						localparam _bbase_F3C4F_fpu_csr_if = 0;
						localparam _param_F3C4F_INSTANCE_ID = INSTANCE_ID;
						localparam _param_F3C4F_CORE_ID = CORE_ID;
						if (1) begin : csr_data
							localparam INSTANCE_ID = _param_F3C4F_INSTANCE_ID;
							localparam CORE_ID = _param_F3C4F_CORE_ID;
							wire clk;
							wire reset;
							wire [7:0] mpm_class;
							localparam _mbase_fpu_csr_if = 0;
							wire read_enable;
							localparam VX_gpu_pkg_UUID_WIDTH = 44;
							wire [43:0] read_uuid;
							localparam VX_gpu_pkg_NW_BITS = 2;
							localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
							wire [1:0] read_wid;
							localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
							localparam VX_gpu_pkg_NCTA_BITS = 2;
							localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
							wire [1:0] read_cta_id;
							wire [11:0] read_addr;
							wire [31:0] read_data_ro;
							wire [31:0] read_data_rw;
							wire write_enable;
							wire [43:0] write_uuid;
							wire [1:0] write_wid;
							wire [11:0] write_addr;
							wire [31:0] write_data;
							wire [31:0] __cta_param = vortex_core_wrap.core.sched_csr_if.cta_csrs[95-:32];
							assign vortex_core_wrap.core.sched_csr_if.csr_wr_valid = write_enable && (write_addr == 12'h340);
							assign vortex_core_wrap.core.sched_csr_if.csr_wr_wid = write_wid;
							assign vortex_core_wrap.core.sched_csr_if.csr_wr_data = write_data;
							wire is_trap_csr = ((((write_addr == 12'h300) || (write_addr == 12'h305)) || (write_addr == 12'h341)) || (write_addr == 12'h342)) || (write_addr == 12'h343);
							assign vortex_core_wrap.core.sched_csr_if.trap_csr_wr_valid = write_enable && is_trap_csr;
							assign vortex_core_wrap.core.sched_csr_if.trap_csr_wr_addr = write_addr;
							assign vortex_core_wrap.core.sched_csr_if.trap_csr_wr_data = write_data;
							localparam VX_gpu_pkg_INST_FRM_BITS = 3;
							reg [31:0] fcsr;
							reg [31:0] fcsr_n;
							wire [0:0] fpu_write_enable;
							wire [1:0] fpu_write_wid;
							wire [4:0] fpu_write_fflags;
							genvar _gv_i_61;
							for (_gv_i_61 = 0; _gv_i_61 < 1; _gv_i_61 = _gv_i_61 + 1) begin : g_fpu_write
								localparam i = _gv_i_61;
								assign fpu_write_enable[i] = vortex_core_wrap.core.execute.fpu_csr_if[i + _mbase_fpu_csr_if].write_enable;
								assign fpu_write_wid[i * 2+:2] = vortex_core_wrap.core.execute.fpu_csr_if[i + _mbase_fpu_csr_if].write_wid;
								assign fpu_write_fflags[i * 5+:5] = vortex_core_wrap.core.execute.fpu_csr_if[i + _mbase_fpu_csr_if].write_fflags;
							end
							always @(*) begin
								fcsr_n = fcsr;
								begin : sv2v_autoblock_18
									integer i;
									for (i = 0; i < 1; i = i + 1)
										if (fpu_write_enable[i])
											fcsr_n[(fpu_write_wid[i * 2+:2] * 8) + 4-:5] = fcsr[(fpu_write_wid[i * 2+:2] * 8) + 4-:5] | fpu_write_fflags[i * 5+:5];
								end
								if (write_enable)
									case (write_addr)
										12'h001: fcsr_n[(write_wid * 8) + 4-:5] = write_data[4:0];
										12'h002: fcsr_n[(write_wid * 8) + 7-:3] = write_data[2:0];
										12'h003: fcsr_n[write_wid * 8+:8] = write_data[7:0];
										default:
											;
									endcase
							end
							genvar _gv_i_62;
							for (_gv_i_62 = 0; _gv_i_62 < 1; _gv_i_62 = _gv_i_62 + 1) begin : g_fpu_csr_read_frm
								localparam i = _gv_i_62;
								assign vortex_core_wrap.core.execute.fpu_csr_if[i + _mbase_fpu_csr_if].read_frm = fcsr[(vortex_core_wrap.core.execute.fpu_csr_if[i + _mbase_fpu_csr_if].read_wid * 8) + 7-:3];
							end
							always @(posedge clk)
								if (reset)
									fcsr <= 1'sb0;
								else
									fcsr <= fcsr_n;
							always @(posedge clk)
								if (write_enable)
									case (write_addr)
										12'h001, 12'h002, 12'h003, 12'h180, 12'h300, 12'h744, 12'h302, 12'h303, 12'h304, 12'h305, 12'h341, 12'h342, 12'h343, 12'h3a0, 12'h3b0, 12'h340:
											;
										default:
											;
									endcase
							assign vortex_core_wrap.core.sched_csr_if.csr_rd_wid = read_wid;
							assign vortex_core_wrap.core.sched_csr_if.csr_rd_cta_id = read_cta_id;
							reg [31:0] read_data_ro_w;
							reg [31:0] read_data_rw_w;
							reg read_addr_valid_w;
							localparam VX_gpu_pkg_PC_BITS = 32;
							function automatic [31:0] VX_gpu_pkg_to_fullPC;
								input reg [31:0] pc;
								VX_gpu_pkg_to_fullPC = pc;
							endfunction
							always @(*) begin
								read_data_ro_w = 1'sb0;
								read_data_rw_w = 1'sb0;
								read_addr_valid_w = 1;
								case (read_addr)
									12'hf11: read_data_ro_w = 32'sd0;
									12'hf12: read_data_ro_w = 32'sd0;
									12'hf13: read_data_ro_w = 32'sd0;
									12'h301: read_data_ro_w = 32'h40901120;
									12'h001: read_data_rw_w = sv2v_cast_32(fcsr[(read_wid * 8) + 4-:5]);
									12'h002: read_data_rw_w = sv2v_cast_32(fcsr[(read_wid * 8) + 7-:3]);
									12'h003: read_data_rw_w = sv2v_cast_32(fcsr[read_wid * 8+:8]);
									12'h340: read_data_rw_w = vortex_core_wrap.core.sched_csr_if.mscratch;
									12'hcd0: read_data_rw_w = sv2v_cast_32(vortex_core_wrap.core.sched_csr_if.cta_csrs[341-:2]);
									12'hcd1: read_data_rw_w = sv2v_cast_32(vortex_core_wrap.core.sched_csr_if.cta_csrs[339-:2]);
									12'hcd2: read_data_rw_w = sv2v_cast_32(vortex_core_wrap.core.sched_csr_if.cta_csrs[337-:3]);
									12'hcd6: read_data_rw_w = vortex_core_wrap.core.sched_csr_if.cta_csrs[239+:32];
									12'hcd7: read_data_rw_w = vortex_core_wrap.core.sched_csr_if.cta_csrs[271+:32];
									12'hcd8: read_data_rw_w = vortex_core_wrap.core.sched_csr_if.cta_csrs[303+:32];
									12'hcd9: read_data_rw_w = sv2v_cast_32(vortex_core_wrap.core.sched_csr_if.cta_csrs[224+:5]);
									12'hcda: read_data_rw_w = sv2v_cast_32(vortex_core_wrap.core.sched_csr_if.cta_csrs[229+:5]);
									12'hcdb: read_data_rw_w = sv2v_cast_32(vortex_core_wrap.core.sched_csr_if.cta_csrs[234+:5]);
									12'hcdc: read_data_rw_w = vortex_core_wrap.core.sched_csr_if.cta_csrs[128+:32];
									12'hcdd: read_data_rw_w = vortex_core_wrap.core.sched_csr_if.cta_csrs[160+:32];
									12'hcde: read_data_rw_w = vortex_core_wrap.core.sched_csr_if.cta_csrs[192+:32];
									12'hcdf: read_data_rw_w = vortex_core_wrap.core.sched_csr_if.cta_csrs[63-:32];
									12'hce0: read_data_rw_w = vortex_core_wrap.core.sched_csr_if.cta_csrs[31-:32];
									12'hce1: read_data_rw_w = VX_gpu_pkg_to_fullPC(vortex_core_wrap.core.sched_csr_if.cta_csrs[127-:32]);
									12'hcc1: read_data_ro_w = sv2v_cast_32(read_wid);
									12'hcc2: read_data_ro_w = CORE_ID;
									12'hcc4: read_data_ro_w = sv2v_cast_32(vortex_core_wrap.core.sched_csr_if.thread_masks[read_wid * 4+:4]);
									12'hcc3: read_data_ro_w = sv2v_cast_32(vortex_core_wrap.core.sched_csr_if.active_warps);
									12'hfc0: read_data_ro_w = 32'sd4;
									12'hfc1: read_data_ro_w = 32'sd4;
									12'hfc2: read_data_ro_w = 32'sd1;
									12'hfc3: read_data_ro_w = 32'hffff0000;
									12'hfc4: read_data_ro_w = 32'sd8;
									12'hb00: read_data_ro_w = vortex_core_wrap.core.sched_csr_if.cycles[31:0];
									12'hb00 + 12'h080: read_data_ro_w = sv2v_cast_32(vortex_core_wrap.core.sched_csr_if.cycles[43:32]);
									12'hb02: read_data_ro_w = vortex_core_wrap.core.sched_csr_if.instret[31:0];
									12'hb02 + 12'h080: read_data_ro_w = sv2v_cast_32(vortex_core_wrap.core.sched_csr_if.instret[43:32]);
									12'hb01: read_data_ro_w = 1'sbx;
									12'hb81: read_data_ro_w = 1'sbx;
									12'h180, 12'h744, 12'h302, 12'h303, 12'h304, 12'h3a0, 12'h3b0: read_data_ro_w = 32'sd0;
									12'h300: read_data_rw_w = vortex_core_wrap.core.sched_csr_if.csr_mstatus;
									12'h305: read_data_rw_w = vortex_core_wrap.core.sched_csr_if.csr_mtvec;
									12'h341: read_data_rw_w = vortex_core_wrap.core.sched_csr_if.csr_mepc;
									12'h342: read_data_rw_w = vortex_core_wrap.core.sched_csr_if.csr_mcause;
									12'h343: read_data_rw_w = vortex_core_wrap.core.sched_csr_if.csr_mtval;
									default: begin
										read_addr_valid_w = 0;
										if (((read_addr >= 12'hb03) && (read_addr < 2851)) || ((read_addr >= 12'hb83) && (read_addr < 2979)))
											read_addr_valid_w = 1;
									end
								endcase
								if (!read_addr_valid_w) begin
									read_data_ro_w = 1'sb0;
									read_data_rw_w = 1'sb0;
								end
							end
							assign read_data_ro = read_data_ro_w;
							assign read_data_rw = read_data_rw_w;
						end
						assign csr_data.clk = clk;
						assign csr_data.reset = reset;
						assign csr_data.mpm_class = mpm_class;
						assign csr_data.read_enable = csr_req_valid && csr_rd_enable;
						assign csr_data.read_uuid = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[512-:44];
						assign csr_data.read_wid = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[468-:2];
						assign csr_data.read_cta_id = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[466-:2];
						assign csr_data.read_addr = csr_read_addr;
						assign csr_read_data_ro = csr_data.read_data_ro;
						assign csr_read_data_rw = csr_data.read_data_rw;
						assign csr_data.write_enable = csr_req_valid && csr_wr_enable;
						assign csr_data.write_uuid = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[512-:44];
						assign csr_data.write_wid = vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[468-:2];
						assign csr_data.write_addr = csr_addr;
						assign csr_data.write_data = csr_write_data;
						wire [127:0] wtid;
						wire [127:0] gtid;
						genvar _gv_i_64;
						for (_gv_i_64 = 0; _gv_i_64 < NUM_LANES; _gv_i_64 = _gv_i_64 + 1) begin : g_wtid
							localparam i = _gv_i_64;
							if (1) begin : g_no_pid
								assign wtid[i * 32+:32] = i;
							end
						end
						genvar _gv_i_65;
						localparam VX_gpu_pkg_NT_BITS = 2;
						localparam VX_gpu_pkg_NW_BITS = 2;
						for (_gv_i_65 = 0; _gv_i_65 < NUM_LANES; _gv_i_65 = _gv_i_65 + 1) begin : g_gtid
							localparam i = _gv_i_65;
							assign gtid[i * 32+:32] = (0 + (sv2v_cast_32(vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[468-:2]) << VX_gpu_pkg_NT_BITS)) + wtid[i * 32+:32];
						end
						wire [127:0] cta_tid_x;
						wire [127:0] cta_tid_y;
						wire [127:0] cta_tid_z;
						genvar _gv_i_66;
						localparam VX_gpu_pkg_NT_WIDTH = VX_gpu_pkg_NT_BITS;
						for (_gv_i_66 = 0; _gv_i_66 < NUM_LANES; _gv_i_66 = _gv_i_66 + 1) begin : g_cta_tid
							localparam i = _gv_i_66;
							wire [1:0] lane_idx = sv2v_cast_2_signed(i);
							assign cta_tid_x[i * 32+:32] = sv2v_cast_32(vortex_core_wrap.core.sched_csr_if.cta_tid[(lane_idx * 3) * 4+:4]);
							assign cta_tid_y[i * 32+:32] = sv2v_cast_32(vortex_core_wrap.core.sched_csr_if.cta_tid[((lane_idx * 3) + 1) * 4+:4]);
							assign cta_tid_z[i * 32+:32] = sv2v_cast_32(vortex_core_wrap.core.sched_csr_if.cta_tid[((lane_idx * 3) + 2) * 4+:4]);
						end
						always @(*) begin
							csr_rd_enable = 0;
							case (csr_addr)
								12'hcc0: csr_read_data = wtid;
								12'hf14: csr_read_data = gtid;
								12'hcd3: csr_read_data = cta_tid_x;
								12'hcd4: csr_read_data = cta_tid_y;
								12'hcd5: csr_read_data = cta_tid_z;
								default: begin
									csr_read_data = {NUM_LANES {csr_read_data_ro | csr_read_data_rw}};
									csr_rd_enable = 1;
								end
							endcase
						end
						assign csr_req_data = (vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[401] ? sv2v_cast_32(csr_imm) : rs1_data[0+:32]);
						assign csr_wr_enable = csr_write_enable || |csr_req_data;
						localparam VX_gpu_pkg_INST_SFU_CSRRS = 4'h7;
						always @(*)
							case (vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[412-:4])
								VX_gpu_pkg_INST_SFU_CSRRW: csr_write_data = csr_req_data;
								VX_gpu_pkg_INST_SFU_CSRRS: csr_write_data = csr_read_data_rw | csr_req_data;
								default: csr_write_data = csr_read_data_rw & ~csr_req_data;
							endcase
						localparam VX_gpu_pkg_XLENB = 4;
						localparam VX_gpu_pkg_XLENB_W = 2;
						localparam VX_gpu_pkg_BYTESEL_BITS = 4;
						localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
						localparam VX_gpu_pkg_NCTA_BITS = 2;
						localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
						localparam VX_gpu_pkg_REG_TYPES = 2;
						localparam VX_gpu_pkg_RV_REGS = 32;
						localparam VX_gpu_pkg_NUM_REGS = 64;
						localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
						localparam VX_gpu_pkg_NUM_XREGS = 2;
						localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
						localparam VX_gpu_pkg_PC_BITS = 32;
						localparam VX_gpu_pkg_UUID_WIDTH = 44;
						VX_elastic_buffer #(
							.DATAW(228),
							.SIZE(2)
						) rsp_buf(
							.clk(clk),
							.reset(reset),
							.valid_in(csr_req_valid),
							.ready_in(csr_req_ready),
							.data_in({vortex_core_wrap.core.execute.sfu_unit.pe_execute_if[_mbase_execute_if].data[512-:100], csr_read_data}),
							.data_out(vortex_core_wrap.core.execute.sfu_unit.pe_result_if[_mbase_result_if].data),
							.valid_out(vortex_core_wrap.core.execute.sfu_unit.pe_result_if[_mbase_result_if].valid),
							.ready_out(vortex_core_wrap.core.execute.sfu_unit.pe_result_if[_mbase_result_if].ready)
						);
					end
					assign csr_unit.clk = clk;
					assign csr_unit.reset = reset;
					assign txbar_bus_if.valid = 1'b0;
					assign txbar_bus_if.data = 1'sbx;
					localparam _bbase_F8D15_result_if = 0;
					localparam _bbase_F8D15_commit_if = 2;
					localparam _param_F8D15_BLOCK_SIZE = BLOCK_SIZE;
					localparam _param_F8D15_NUM_LANES = NUM_LANES;
					localparam _param_F8D15_OUT_BUF = 3;
					if (1) begin : lane_gather
						localparam BLOCK_SIZE = _param_F8D15_BLOCK_SIZE;
						localparam NUM_LANES = _param_F8D15_NUM_LANES;
						localparam OUT_BUF = _param_F8D15_OUT_BUF;
						wire clk;
						wire reset;
						localparam _mbase_result_if = 0;
						localparam _mbase_commit_if = _bbase_F8D15_commit_if;
						localparam VX_gpu_pkg_XLENB = 4;
						localparam VX_gpu_pkg_XLENB_W = 2;
						localparam VX_gpu_pkg_BYTESEL_BITS = 4;
						localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
						localparam VX_gpu_pkg_NCTA_BITS = 2;
						localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
						localparam VX_gpu_pkg_REG_TYPES = 2;
						localparam VX_gpu_pkg_RV_REGS = 32;
						localparam VX_gpu_pkg_NUM_REGS = 64;
						localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
						localparam VX_gpu_pkg_NUM_XREGS = 2;
						localparam VX_gpu_pkg_NW_BITS = 2;
						localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
						localparam VX_gpu_pkg_PC_BITS = 32;
						localparam VX_gpu_pkg_UUID_WIDTH = 44;
						localparam VX_gpu_pkg_INST_OP_BITS = 4;
						localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
						localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
						localparam VX_gpu_pkg_INST_FMT_BITS = 2;
						localparam VX_gpu_pkg_INST_FRM_BITS = 3;
						localparam BLOCK_SIZE_W = 1;
						localparam NUM_PACKETS = 1;
						localparam LPID_BITS = 0;
						localparam LPID_WIDTH = 1;
						localparam DATAW = 228;
						localparam DATA_WIS_OFF = 182;
						wire [0:0] result_in_valid;
						wire [227:0] result_in_data;
						wire [0:0] result_in_ready;
						localparam VX_gpu_pkg_ISSUE_ISW_BITS = 0;
						localparam VX_gpu_pkg_ISSUE_ISW_W = 1;
						wire [0:0] result_in_isw;
						genvar _gv_i_77;
						for (_gv_i_77 = 0; _gv_i_77 < BLOCK_SIZE; _gv_i_77 = _gv_i_77 + 1) begin : g_commit_in
							localparam i = _gv_i_77;
							assign result_in_valid[i] = vortex_core_wrap.core.execute.sfu_unit.per_block_result_if[i + _mbase_result_if].valid;
							assign result_in_data[i * DATAW+:DATAW] = vortex_core_wrap.core.execute.sfu_unit.per_block_result_if[i + _mbase_result_if].data;
							assign vortex_core_wrap.core.execute.sfu_unit.per_block_result_if[i + _mbase_result_if].ready = result_in_ready[i];
							if (1) begin : g_result_in_isw_full
								assign result_in_isw[i+:1] = sv2v_cast_1_signed(i);
							end
						end
						reg [0:0] result_out_valid;
						reg [227:0] result_out_data;
						wire [0:0] result_out_ready;
						always @(*) begin
							result_out_valid = 1'sb0;
							begin : sv2v_autoblock_19
								integer i;
								for (i = 0; i < 1; i = i + 1)
									result_out_data[i * DATAW+:DATAW] = 1'sbx;
							end
							begin : sv2v_autoblock_20
								integer i;
								for (i = 0; i < BLOCK_SIZE; i = i + 1)
									begin
										result_out_valid[result_in_isw[i+:1]] = result_in_valid[i];
										result_out_data[result_in_isw[i+:1] * DATAW+:DATAW] = result_in_data[i * DATAW+:DATAW];
									end
							end
						end
						genvar _gv_i_78;
						for (_gv_i_78 = 0; _gv_i_78 < BLOCK_SIZE; _gv_i_78 = _gv_i_78 + 1) begin : g_result_in_ready
							localparam i = _gv_i_78;
							assign result_in_ready[i] = result_out_ready[result_in_isw[i+:1]];
						end
						genvar _gv_i_79;
						localparam VX_gpu_pkg_SIMD_COUNT = 1;
						localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
						localparam VX_gpu_pkg_SIMD_IDX_W = 1;
						for (_gv_i_79 = 0; _gv_i_79 < 1; _gv_i_79 = _gv_i_79 + 1) begin : g_out_bufs
							localparam i = _gv_i_79;
							if (1) begin : result_tmp_if
								wire valid;
								wire [227:0] data;
								wire ready;
							end
							VX_elastic_buffer #(
								.DATAW(DATAW),
								.SIZE(2),
								.OUT_REG(1)
							) out_buf(
								.clk(clk),
								.reset(reset),
								.valid_in(result_out_valid[i]),
								.ready_in(result_out_ready[i]),
								.data_in(result_out_data[i * DATAW+:DATAW]),
								.data_out(result_tmp_if.data),
								.valid_out(result_tmp_if.valid),
								.ready_out(result_tmp_if.ready)
							);
							wire [0:0] commit_sid_w;
							wire [3:0] commit_tmask_w;
							wire [127:0] commit_data_w;
							if (1) begin : g_no_lpid
								assign commit_sid_w = sv2v_cast_1(result_tmp_if.data[175-:1]);
								assign commit_tmask_w = result_tmp_if.data[179-:4];
								assign commit_data_w = result_tmp_if.data[127-:128];
							end
							assign vortex_core_wrap.core.commit_if[i + _mbase_commit_if].valid = result_tmp_if.valid;
							assign vortex_core_wrap.core.commit_if[i + _mbase_commit_if].data = {result_tmp_if.data[227-:44], result_tmp_if.data[183-:2], result_tmp_if.data[181-:2], commit_sid_w, commit_tmask_w, result_tmp_if.data[172-:32], result_tmp_if.data[140], result_tmp_if.data[139-:2], result_tmp_if.data[137-:6], result_tmp_if.data[131-:VX_gpu_pkg_BYTESEL_BITS], commit_data_w, result_tmp_if.data[174], result_tmp_if.data[173]};
							assign result_tmp_if.ready = vortex_core_wrap.core.commit_if[i + _mbase_commit_if].ready;
						end
					end
					assign lane_gather.clk = clk;
					assign lane_gather.reset = reset;
				end
				assign sfu_unit.clk = clk;
				assign sfu_unit.reset = reset;
			end
			assign execute.clk = clk;
			assign execute.reset = reset;
			localparam _bbase_34073_commit_if = 0;
			localparam _bbase_34073_writeback_if = 0;
			localparam _param_34073_INSTANCE_ID = "";
			if (1) begin : commit
				reg _sv2v_0;
				localparam INSTANCE_ID = _param_34073_INSTANCE_ID;
				wire clk;
				wire reset;
				localparam VX_gpu_pkg_EX_SFU = 2;
				localparam VX_gpu_pkg_EX_FPU = 3;
				localparam VX_gpu_pkg_EX_TCU = 3;
				localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
				localparam _mbase_commit_if = 0;
				localparam _mbase_writeback_if = 0;
				localparam VX_gpu_pkg_XLENB = 4;
				localparam VX_gpu_pkg_XLENB_W = 2;
				localparam VX_gpu_pkg_BYTESEL_BITS = 4;
				localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
				localparam VX_gpu_pkg_NCTA_BITS = 2;
				localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
				localparam VX_gpu_pkg_REG_TYPES = 2;
				localparam VX_gpu_pkg_RV_REGS = 32;
				localparam VX_gpu_pkg_NUM_REGS = 64;
				localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
				localparam VX_gpu_pkg_NUM_XREGS = 2;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
				localparam VX_gpu_pkg_PC_BITS = 32;
				localparam VX_gpu_pkg_SIMD_COUNT = 1;
				localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
				localparam VX_gpu_pkg_SIMD_IDX_W = 1;
				localparam VX_gpu_pkg_UUID_WIDTH = 44;
				localparam OUT_DATAW = 228;
				genvar _arr_A3DB1;
				for (_arr_A3DB1 = 0; _arr_A3DB1 <= 0; _arr_A3DB1 = _arr_A3DB1 + 1) begin : commit_arb_if
					wire valid;
					localparam VX_gpu_pkg_XLENB = 4;
					localparam VX_gpu_pkg_XLENB_W = 2;
					localparam VX_gpu_pkg_BYTESEL_BITS = 4;
					localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
					localparam VX_gpu_pkg_NCTA_BITS = 2;
					localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
					localparam VX_gpu_pkg_REG_TYPES = 2;
					localparam VX_gpu_pkg_RV_REGS = 32;
					localparam VX_gpu_pkg_NUM_REGS = 64;
					localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
					localparam VX_gpu_pkg_NUM_XREGS = 2;
					localparam VX_gpu_pkg_NW_BITS = 2;
					localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
					localparam VX_gpu_pkg_PC_BITS = 32;
					localparam VX_gpu_pkg_SIMD_COUNT = 1;
					localparam VX_gpu_pkg_SIMD_IDX_BITS = 0;
					localparam VX_gpu_pkg_SIMD_IDX_W = 1;
					localparam VX_gpu_pkg_UUID_WIDTH = 44;
					wire [227:0] data;
					wire ready;
				end
				wire [0:0] committed_warps;
				genvar _gv_i_57;
				for (_gv_i_57 = 0; _gv_i_57 < 1; _gv_i_57 = _gv_i_57 + 1) begin : g_commit_arbs
					localparam i = _gv_i_57;
					wire [3:0] valid_in;
					wire [911:0] data_in;
					wire [3:0] ready_in;
					genvar _gv_j_3;
					for (_gv_j_3 = 0; _gv_j_3 < VX_gpu_pkg_NUM_EX_UNITS; _gv_j_3 = _gv_j_3 + 1) begin : g_data_in
						localparam j = _gv_j_3;
						assign valid_in[j] = vortex_core_wrap.core.commit_if[((j * 1) + i) + _mbase_commit_if].valid;
						assign data_in[j * OUT_DATAW+:OUT_DATAW] = vortex_core_wrap.core.commit_if[((j * 1) + i) + _mbase_commit_if].data;
						assign vortex_core_wrap.core.commit_if[((j * 1) + i) + _mbase_commit_if].ready = ready_in[j];
					end
					VX_stream_arb #(
						.NUM_INPUTS(VX_gpu_pkg_NUM_EX_UNITS),
						.DATAW(OUT_DATAW),
						.ARBITER("P"),
						.OUT_BUF(1)
					) commit_arb(
						.clk(clk),
						.reset(reset),
						.valid_in(valid_in),
						.ready_in(ready_in),
						.data_in(data_in),
						.data_out(commit_arb_if[i].data),
						.valid_out(commit_arb_if[i].valid),
						.ready_out(commit_arb_if[i].ready),
						.sel_out()
					);
					wire commit_arb_fire = commit_arb_if[i].valid && commit_arb_if[i].ready;
					assign committed_warps[i] = commit_arb_fire && commit_arb_if[i].data[0];
				end
				wire [1:0] committed_slot_wid;
				genvar _gv_i_58;
				for (_gv_i_58 = 0; _gv_i_58 < 1; _gv_i_58 = _gv_i_58 + 1) begin : g_committed_wid
					localparam i = _gv_i_58;
					assign committed_slot_wid[i * 2+:2] = commit_arb_if[i].data[183-:2];
				end
				reg [3:0] committed_warp_mask;
				wire [3:0] committed_warp_mask_r;
				always @(*) begin
					if (_sv2v_0)
						;
					committed_warp_mask = 1'sb0;
					begin : sv2v_autoblock_21
						integer i;
						for (i = 0; i < 1; i = i + 1)
							if (committed_warps[i])
								committed_warp_mask[committed_slot_wid[i * 2+:2]] = 1'b1;
					end
				end
				VX_pipe_register #(
					.DATAW(4),
					.RESETW(4),
					.DEPTH(1)
				) __buffer_ex86(
					.clk(clk),
					.reset(reset),
					.enable(1'b1),
					.data_in(committed_warp_mask),
					.data_out(committed_warp_mask_r)
				);
				assign vortex_core_wrap.core.commit_sched_if.committed_warps = committed_warp_mask_r;
				genvar _gv_i_59;
				localparam VX_gpu_pkg_ISSUE_ISW_BITS = 0;
				localparam VX_gpu_pkg_PER_ISSUE_WARPS = 4;
				localparam VX_gpu_pkg_ISSUE_WIS_BITS = 2;
				localparam VX_gpu_pkg_ISSUE_WIS_W = VX_gpu_pkg_ISSUE_WIS_BITS;
				function automatic [1:0] VX_gpu_pkg_wid_to_wis;
					input reg [1:0] wid;
					VX_gpu_pkg_wid_to_wis = wid >> VX_gpu_pkg_ISSUE_ISW_BITS;
				endfunction
				for (_gv_i_59 = 0; _gv_i_59 < 1; _gv_i_59 = _gv_i_59 + 1) begin : g_writeback
					localparam i = _gv_i_59;
					wire [1:0] bytesel_size = commit_arb_if[i].data[133-:VX_gpu_pkg_XLENB_W];
					wire [1:0] bytesel_off = commit_arb_if[i].data[130+:VX_gpu_pkg_XLENB_W];
					wire [127:0] writeback_data;
					wire [15:0] writeback_byteen;
					wire [3:0] size_mask = (bytesel_size == 2'sd3 ? 4'sd15 : (bytesel_size == 2'sd2 ? 4'sd15 : (bytesel_size == 2'sd1 ? 4'sd15 : (bytesel_size == 2'sd0 ? 4'sd15 : (bytesel_size == 2'sd3 ? 4'sd15 : (bytesel_size == 2'sd2 ? 4'sd7 : (bytesel_size == 2'sd1 ? 4'sd3 : 4'sd1)))))));
					wire [3:0] base_byteen = size_mask << bytesel_off;
					genvar _gv_lane_1;
					for (_gv_lane_1 = 0; _gv_lane_1 < 4; _gv_lane_1 = _gv_lane_1 + 1) begin : g_bytesel
						localparam lane = _gv_lane_1;
						assign writeback_data[lane * 32+:32] = commit_arb_if[i].data[2 + (lane * 32)+:32] << (8 * bytesel_off);
						assign writeback_byteen[lane * 4+:4] = (commit_arb_if[i].data[175 + lane] ? base_byteen : {4 {1'sb0}});
					end
					assign vortex_core_wrap.core.writeback_if[i + _mbase_writeback_if].valid = commit_arb_if[i].valid;
					assign vortex_core_wrap.core.writeback_if[i + _mbase_writeback_if].data[239-:44] = commit_arb_if[i].data[227-:44];
					assign vortex_core_wrap.core.writeback_if[i + _mbase_writeback_if].data[195-:2] = VX_gpu_pkg_wid_to_wis(commit_arb_if[i].data[183-:2]);
					assign vortex_core_wrap.core.writeback_if[i + _mbase_writeback_if].data[193-:2] = commit_arb_if[i].data[181-:2];
					assign vortex_core_wrap.core.writeback_if[i + _mbase_writeback_if].data[191] = commit_arb_if[i].data[179];
					assign vortex_core_wrap.core.writeback_if[i + _mbase_writeback_if].data[186-:32] = commit_arb_if[i].data[174-:32];
					assign vortex_core_wrap.core.writeback_if[i + _mbase_writeback_if].data[190-:4] = commit_arb_if[i].data[178-:4];
					assign vortex_core_wrap.core.writeback_if[i + _mbase_writeback_if].data[154] = commit_arb_if[i].data[142];
					assign vortex_core_wrap.core.writeback_if[i + _mbase_writeback_if].data[153-:2] = commit_arb_if[i].data[141-:2];
					assign vortex_core_wrap.core.writeback_if[i + _mbase_writeback_if].data[151-:6] = commit_arb_if[i].data[139-:6];
					assign vortex_core_wrap.core.writeback_if[i + _mbase_writeback_if].data[145-:16] = writeback_byteen;
					assign vortex_core_wrap.core.writeback_if[i + _mbase_writeback_if].data[129-:128] = writeback_data;
					assign vortex_core_wrap.core.writeback_if[i + _mbase_writeback_if].data[1] = commit_arb_if[i].data[1];
					assign vortex_core_wrap.core.writeback_if[i + _mbase_writeback_if].data[0] = commit_arb_if[i].data[0];
					assign commit_arb_if[i].ready = 1;
				end
				initial _sv2v_0 = 0;
			end
			assign commit.clk = clk;
			assign commit.reset = reset;
			localparam LSU_SCHED_NUM_CLIENTS = 1;
			genvar _gv_block_idx_2;
			for (_gv_block_idx_2 = 0; _gv_block_idx_2 < 1; _gv_block_idx_2 = _gv_block_idx_2 + 1) begin : g_lsu_scheduler
				localparam block_idx = _gv_block_idx_2;
				genvar _arr_1BD15;
				for (_arr_1BD15 = 0; _arr_1BD15 <= 0; _arr_1BD15 = _arr_1BD15 + 1) begin : sched_client_if
					wire req_valid;
					localparam VX_gpu_pkg_XLENB = 4;
					localparam VX_gpu_pkg_LSU_WORD_SIZE = VX_gpu_pkg_XLENB;
					localparam VX_gpu_pkg_LSU_ADDR_WIDTH = 30;
					localparam VX_gpu_pkg_INST_LSU_BITS = 4;
					localparam VX_gpu_pkg_XLENB_W = 2;
					localparam VX_gpu_pkg_BYTESEL_BITS = 4;
					localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
					localparam VX_gpu_pkg_NCTA_BITS = 2;
					localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
					localparam VX_gpu_pkg_REG_TYPES = 2;
					localparam VX_gpu_pkg_RV_REGS = 32;
					localparam VX_gpu_pkg_NUM_REGS = 64;
					localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
					localparam VX_gpu_pkg_NUM_XREGS = 2;
					localparam VX_gpu_pkg_NW_BITS = 2;
					localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
					localparam VX_gpu_pkg_PC_BITS = 32;
					localparam VX_gpu_pkg_UUID_WIDTH = 44;
					localparam VX_gpu_pkg_LSU_CLIENT_TAG_WIDTH = 114;
					localparam VX_gpu_pkg_NC_BITS = 0;
					localparam VX_gpu_pkg_NT_BITS = 2;
					localparam VX_gpu_pkg_HART_ID_BITS = 4;
					localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
					localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
					wire [434:0] req_data;
					wire req_ready;
					wire rsp_valid;
					wire [247:0] rsp_data;
					wire rsp_ready;
				end
				assign sched_client_if[0].req_valid = lsu_client_if[block_idx].req_valid;
				assign sched_client_if[0].req_data = lsu_client_if[block_idx].req_data;
				assign lsu_client_if[block_idx].req_ready = sched_client_if[0].req_ready;
				assign lsu_client_if[block_idx].rsp_valid = sched_client_if[0].rsp_valid;
				assign lsu_client_if[block_idx].rsp_data = sched_client_if[0].rsp_data;
				assign sched_client_if[0].rsp_ready = lsu_client_if[block_idx].rsp_ready;
				localparam _bbase_A5C6A_client_if = 0;
				localparam _bbase_A5C6A_lsu_mem_if = _gv_block_idx_2;
				localparam _param_A5C6A_INSTANCE_ID = "";
				localparam _param_A5C6A_NUM_CLIENTS = LSU_SCHED_NUM_CLIENTS;
				localparam _param_A5C6A_NUM_LANES = 4;
				localparam _param_A5C6A_CORE_QUEUE_SIZE = 2;
				localparam _param_A5C6A_MEM_QUEUE_SIZE = 4;
				if (1) begin : lsu_scheduler
					reg _sv2v_0;
					localparam INSTANCE_ID = _param_A5C6A_INSTANCE_ID;
					localparam NUM_CLIENTS = _param_A5C6A_NUM_CLIENTS;
					localparam NUM_LANES = _param_A5C6A_NUM_LANES;
					localparam CORE_QUEUE_SIZE = _param_A5C6A_CORE_QUEUE_SIZE;
					localparam MEM_QUEUE_SIZE = _param_A5C6A_MEM_QUEUE_SIZE;
					wire clk;
					wire reset;
					localparam _mbase_client_if = 0;
					wire empty;
					localparam _mbase_lsu_mem_if = _bbase_A5C6A_lsu_mem_if;
					localparam CLIENT_ID_BITS = 0;
					localparam VX_gpu_pkg_INST_LSU_BITS = 4;
					localparam VX_gpu_pkg_XLENB = 4;
					localparam VX_gpu_pkg_LSU_WORD_SIZE = VX_gpu_pkg_XLENB;
					localparam VX_gpu_pkg_XLENB_W = 2;
					localparam VX_gpu_pkg_BYTESEL_BITS = 4;
					localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
					localparam VX_gpu_pkg_NCTA_BITS = 2;
					localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
					localparam VX_gpu_pkg_REG_TYPES = 2;
					localparam VX_gpu_pkg_RV_REGS = 32;
					localparam VX_gpu_pkg_NUM_REGS = 64;
					localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
					localparam VX_gpu_pkg_NUM_XREGS = 2;
					localparam VX_gpu_pkg_NW_BITS = 2;
					localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
					localparam VX_gpu_pkg_PC_BITS = 32;
					localparam VX_gpu_pkg_UUID_WIDTH = 44;
					localparam VX_gpu_pkg_LSU_CLIENT_TAG_WIDTH = 114;
					localparam SCHED_TAG_WIDTH = 114;
					wire sched_req_valid;
					wire sched_req_rw;
					wire [3:0] sched_req_mask;
					wire [15:0] sched_req_byteen;
					localparam VX_gpu_pkg_LSU_ADDR_WIDTH = 30;
					wire [119:0] sched_req_addr;
					localparam VX_gpu_pkg_NC_BITS = 0;
					localparam VX_gpu_pkg_NT_BITS = 2;
					localparam VX_gpu_pkg_HART_ID_BITS = 4;
					localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
					localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
					wire [51:0] sched_req_attr;
					wire [127:0] sched_req_data;
					wire [113:0] sched_req_tag;
					wire sched_req_ready;
					wire sched_rsp_valid;
					wire [3:0] sched_rsp_mask;
					wire [127:0] sched_rsp_data;
					wire [113:0] sched_rsp_tag;
					wire sched_rsp_sop;
					wire sched_rsp_eop;
					wire sched_rsp_ready;
					wire [0:0] cli_req_valid;
					wire [434:0] cli_req_data [0:0];
					wire [0:0] cli_req_ready;
					wire [0:0] cli_rsp_valid;
					wire [247:0] cli_rsp_data [0:0];
					wire [0:0] cli_rsp_ready;
					genvar _gv_i_80;
					for (_gv_i_80 = 0; _gv_i_80 < NUM_CLIENTS; _gv_i_80 = _gv_i_80 + 1) begin : g_cli_flat
						localparam i = _gv_i_80;
						assign cli_req_valid[i] = vortex_core_wrap.core.g_lsu_scheduler[_gv_block_idx_2].sched_client_if[i + _mbase_client_if].req_valid;
						assign cli_req_data[i] = vortex_core_wrap.core.g_lsu_scheduler[_gv_block_idx_2].sched_client_if[i + _mbase_client_if].req_data;
						assign vortex_core_wrap.core.g_lsu_scheduler[_gv_block_idx_2].sched_client_if[i + _mbase_client_if].req_ready = cli_req_ready[i];
						assign vortex_core_wrap.core.g_lsu_scheduler[_gv_block_idx_2].sched_client_if[i + _mbase_client_if].rsp_valid = cli_rsp_valid[i];
						assign vortex_core_wrap.core.g_lsu_scheduler[_gv_block_idx_2].sched_client_if[i + _mbase_client_if].rsp_data = cli_rsp_data[i];
						assign cli_rsp_ready[i] = vortex_core_wrap.core.g_lsu_scheduler[_gv_block_idx_2].sched_client_if[i + _mbase_client_if].rsp_ready;
					end
					if (1) begin : g_no_arb
						assign sched_req_valid = cli_req_valid[0];
						assign sched_req_rw = cli_req_data[0][434];
						assign sched_req_mask = cli_req_data[0][433-:4];
						assign sched_req_byteen = cli_req_data[0][429-:16];
						assign sched_req_addr = cli_req_data[0][413-:120];
						assign sched_req_attr = cli_req_data[0][293-:52];
						assign sched_req_data = cli_req_data[0][241-:128];
						assign sched_req_tag = cli_req_data[0][113-:114];
						assign cli_req_ready[0] = sched_req_ready;
						assign cli_rsp_valid[0] = sched_rsp_valid;
						assign cli_rsp_data[0][247-:4] = sched_rsp_mask;
						assign cli_rsp_data[0][243-:128] = sched_rsp_data;
						assign cli_rsp_data[0][115-:114] = sched_rsp_tag;
						assign cli_rsp_data[0][1] = sched_rsp_sop;
						assign cli_rsp_data[0][0] = sched_rsp_eop;
						assign sched_rsp_ready = cli_rsp_ready[0];
					end
					wire lsu_mem_req_valid;
					wire lsu_mem_req_rw;
					wire [3:0] lsu_mem_req_mask;
					wire [15:0] lsu_mem_req_byteen;
					wire [119:0] lsu_mem_req_addr;
					wire [51:0] lsu_mem_req_attr;
					wire [127:0] lsu_mem_req_data;
					localparam VX_gpu_pkg_LSU_MEM_BATCHES = 1;
					localparam VX_gpu_pkg_LSU_TAG_ID_BITS = 1;
					localparam VX_gpu_pkg_LSU_TAG_WIDTH = 45;
					wire [44:0] lsu_mem_req_tag;
					wire lsu_mem_req_ready;
					wire lsu_mem_rsp_valid;
					wire [3:0] lsu_mem_rsp_mask;
					wire [127:0] lsu_mem_rsp_data;
					wire [44:0] lsu_mem_rsp_tag;
					wire lsu_mem_rsp_ready;
					wire sched_req_queue_empty;
					VX_mem_scheduler #(
						.INSTANCE_ID(""),
						.CORE_REQS(NUM_LANES),
						.MEM_CHANNELS(NUM_LANES),
						.WORD_SIZE(VX_gpu_pkg_LSU_WORD_SIZE),
						.LINE_SIZE(VX_gpu_pkg_LSU_WORD_SIZE),
						.ADDR_WIDTH(VX_gpu_pkg_LSU_ADDR_WIDTH),
						.USER_WIDTH(VX_gpu_pkg_MEM_ATTR_WIDTH),
						.TAG_WIDTH(SCHED_TAG_WIDTH),
						.CORE_QUEUE_SIZE(CORE_QUEUE_SIZE),
						.MEM_QUEUE_SIZE(MEM_QUEUE_SIZE),
						.UUID_WIDTH(VX_gpu_pkg_UUID_WIDTH),
						.RSP_PARTIAL(1),
						.MEM_OUT_BUF(0),
						.CORE_OUT_BUF(0)
					) mem_scheduler(
						.clk(clk),
						.reset(reset),
						.core_req_valid(sched_req_valid),
						.core_req_rw(sched_req_rw),
						.core_req_mask(sched_req_mask),
						.core_req_byteen(sched_req_byteen),
						.core_req_addr(sched_req_addr),
						.core_req_user(sched_req_attr),
						.core_req_data(sched_req_data),
						.core_req_tag(sched_req_tag),
						.core_req_ready(sched_req_ready),
						.req_queue_empty(sched_req_queue_empty),
						.req_queue_rw_notify(),
						.core_rsp_valid(sched_rsp_valid),
						.core_rsp_mask(sched_rsp_mask),
						.core_rsp_data(sched_rsp_data),
						.core_rsp_tag(sched_rsp_tag),
						.core_rsp_sop(sched_rsp_sop),
						.core_rsp_eop(sched_rsp_eop),
						.core_rsp_ready(sched_rsp_ready),
						.mem_req_valid(lsu_mem_req_valid),
						.mem_req_rw(lsu_mem_req_rw),
						.mem_req_mask(lsu_mem_req_mask),
						.mem_req_byteen(lsu_mem_req_byteen),
						.mem_req_addr(lsu_mem_req_addr),
						.mem_req_user(lsu_mem_req_attr),
						.mem_req_data(lsu_mem_req_data),
						.mem_req_tag(lsu_mem_req_tag),
						.mem_req_ready(lsu_mem_req_ready),
						.mem_rsp_valid(lsu_mem_rsp_valid),
						.mem_rsp_mask(lsu_mem_rsp_mask),
						.mem_rsp_data(lsu_mem_rsp_data),
						.mem_rsp_tag(lsu_mem_rsp_tag),
						.mem_rsp_ready(lsu_mem_rsp_ready)
					);
					assign vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_mem_if].req_valid = lsu_mem_req_valid;
					assign vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_mem_if].req_data[365-:4] = lsu_mem_req_mask;
					assign vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_mem_if].req_data[361] = lsu_mem_req_rw;
					assign vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_mem_if].req_data[112-:16] = lsu_mem_req_byteen;
					assign vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_mem_if].req_data[360-:120] = lsu_mem_req_addr;
					assign vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_mem_if].req_data[96-:52] = lsu_mem_req_attr;
					assign vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_mem_if].req_data[240-:128] = lsu_mem_req_data;
					assign vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_mem_if].req_data[44-:_param_D2283_TAG_WIDTH] = lsu_mem_req_tag;
					assign lsu_mem_req_ready = vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_mem_if].req_ready;
					assign lsu_mem_rsp_valid = vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_mem_if].rsp_valid;
					assign lsu_mem_rsp_mask = vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_mem_if].rsp_data[176-:4];
					assign lsu_mem_rsp_data = vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_mem_if].rsp_data[172-:128];
					assign lsu_mem_rsp_tag = vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_mem_if].rsp_data[44-:_param_D2283_TAG_WIDTH];
					assign vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_mem_if].rsp_ready = lsu_mem_rsp_ready;
					assign empty = sched_req_queue_empty;
					initial _sv2v_0 = 0;
				end
				assign lsu_scheduler.clk = clk;
				assign lsu_scheduler.reset = reset;
				assign lsu_sched_empty[block_idx] = lsu_scheduler.empty;
			end
			localparam _bbase_B9F3F_lsu_mem_if = 0;
			localparam _bbase_B9F3F_dcache_bus_if = 0;
			localparam _param_B9F3F_INSTANCE_ID = INSTANCE_ID;
			if (1) begin : mem_unit
				localparam INSTANCE_ID = _param_B9F3F_INSTANCE_ID;
				wire clk;
				wire reset;
				localparam _mbase_lsu_mem_if = 0;
				localparam VX_gpu_pkg_DCACHE_WORD_SIZE = 16;
				localparam VX_gpu_pkg_XLENB = 4;
				localparam VX_gpu_pkg_LSU_WORD_SIZE = VX_gpu_pkg_XLENB;
				localparam VX_gpu_pkg_DCACHE_CHANNELS = 1;
				localparam VX_gpu_pkg_DCACHE_NUM_REQS = 1;
				localparam _mbase_dcache_bus_if = 0;
				localparam VX_gpu_pkg_LSU_MEM_BATCHES = 1;
				localparam VX_gpu_pkg_LSU_TAG_ID_BITS = 1;
				localparam VX_gpu_pkg_UUID_WIDTH = 44;
				localparam VX_gpu_pkg_LSU_TAG_WIDTH = 45;
				localparam _param_34737_NUM_LANES = 4;
				localparam _param_34737_DATA_SIZE = VX_gpu_pkg_LSU_WORD_SIZE;
				localparam _param_34737_TAG_WIDTH = VX_gpu_pkg_LSU_TAG_WIDTH;
				genvar _arr_34737;
				for (_arr_34737 = 0; _arr_34737 <= 0; _arr_34737 = _arr_34737 + 1) begin : lsu_dcache_if
					localparam NUM_LANES = _param_34737_NUM_LANES;
					localparam DATA_SIZE = _param_34737_DATA_SIZE;
					localparam TAG_WIDTH = _param_34737_TAG_WIDTH;
					localparam VX_gpu_pkg_NC_BITS = 0;
					localparam VX_gpu_pkg_NT_BITS = 2;
					localparam VX_gpu_pkg_NW_BITS = 2;
					localparam VX_gpu_pkg_HART_ID_BITS = 4;
					localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
					localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
					localparam USER_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
					localparam ADDR_WIDTH = 30;
					localparam VX_gpu_pkg_UUID_WIDTH = 44;
					wire req_valid;
					wire [365:0] req_data;
					wire req_ready;
					wire rsp_valid;
					wire [176:0] rsp_data;
					wire rsp_ready;
				end
				localparam LMEM_ADDR_WIDTH = 12;
				localparam _param_28C6D_NUM_LANES = 4;
				localparam _param_28C6D_DATA_SIZE = VX_gpu_pkg_LSU_WORD_SIZE;
				localparam _param_28C6D_TAG_WIDTH = VX_gpu_pkg_LSU_TAG_WIDTH;
				genvar _arr_28C6D;
				for (_arr_28C6D = 0; _arr_28C6D <= 0; _arr_28C6D = _arr_28C6D + 1) begin : lsu_lmem_if
					localparam NUM_LANES = _param_28C6D_NUM_LANES;
					localparam DATA_SIZE = _param_28C6D_DATA_SIZE;
					localparam TAG_WIDTH = _param_28C6D_TAG_WIDTH;
					localparam VX_gpu_pkg_NC_BITS = 0;
					localparam VX_gpu_pkg_NT_BITS = 2;
					localparam VX_gpu_pkg_NW_BITS = 2;
					localparam VX_gpu_pkg_HART_ID_BITS = 4;
					localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
					localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
					localparam USER_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
					localparam ADDR_WIDTH = 30;
					localparam VX_gpu_pkg_UUID_WIDTH = 44;
					wire req_valid;
					wire [365:0] req_data;
					wire req_ready;
					wire rsp_valid;
					wire [176:0] rsp_data;
					wire rsp_ready;
				end
				genvar _gv_i_90;
				for (_gv_i_90 = 0; _gv_i_90 < 1; _gv_i_90 = _gv_i_90 + 1) begin : g_lmem_switches
					localparam i = _gv_i_90;
					localparam _bbase_2A2C2_lsu_in_if = _gv_i_90 + _mbase_lsu_mem_if;
					localparam _bbase_2A2C2_global_out_if = _gv_i_90;
					localparam _bbase_2A2C2_local_out_if = _gv_i_90;
					localparam _param_2A2C2_GLOBAL_OUT_BUF = 1;
					localparam _param_2A2C2_LOCAL_OUT_BUF = 1;
					localparam _param_2A2C2_RSP_OUT_BUF = 1;
					localparam _param_2A2C2_ARBITER = "P";
					if (1) begin : lmem_switch
						reg _sv2v_0;
						localparam GLOBAL_OUT_BUF = _param_2A2C2_GLOBAL_OUT_BUF;
						localparam LOCAL_OUT_BUF = _param_2A2C2_LOCAL_OUT_BUF;
						localparam RSP_OUT_BUF = _param_2A2C2_RSP_OUT_BUF;
						localparam ARBITER = _param_2A2C2_ARBITER;
						wire clk;
						wire reset;
						localparam _mbase_lsu_in_if = _bbase_2A2C2_lsu_in_if;
						localparam _mbase_global_out_if = _bbase_2A2C2_global_out_if;
						localparam _mbase_local_out_if = _bbase_2A2C2_local_out_if;
						localparam VX_gpu_pkg_XLENB = 4;
						localparam VX_gpu_pkg_LSU_WORD_SIZE = VX_gpu_pkg_XLENB;
						localparam VX_gpu_pkg_LSU_ADDR_WIDTH = 30;
						localparam VX_gpu_pkg_LSU_MEM_BATCHES = 1;
						localparam VX_gpu_pkg_LSU_TAG_ID_BITS = 1;
						localparam VX_gpu_pkg_UUID_WIDTH = 44;
						localparam VX_gpu_pkg_LSU_TAG_WIDTH = 45;
						localparam VX_gpu_pkg_NC_BITS = 0;
						localparam VX_gpu_pkg_NT_BITS = 2;
						localparam VX_gpu_pkg_NW_BITS = 2;
						localparam VX_gpu_pkg_HART_ID_BITS = 4;
						localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
						localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
						localparam REQ_DATAW = 366;
						localparam RSP_DATAW = 177;
						wire [3:0] is_addr_local_mask;
						genvar _gv_i_236;
						localparam VX_gpu_pkg_MEM_ATTR_LOCAL_OFFS = 2;
						for (_gv_i_236 = 0; _gv_i_236 < 4; _gv_i_236 = _gv_i_236 + 1) begin : g_is_addr_local_mask
							localparam i = _gv_i_236;
							assign is_addr_local_mask[i] = vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_data[45 + ((i * 13) + VX_gpu_pkg_MEM_ATTR_LOCAL_OFFS)];
						end
						wire [3:0] global_mask = vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_data[365-:4] & ~is_addr_local_mask;
						wire [3:0] local_mask = vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_data[365-:4] & is_addr_local_mask;
						wire is_addr_global = |global_mask;
						wire is_addr_local = |local_mask;
						wire req_global_ready;
						wire req_local_ready;
						assign vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_ready = (!is_addr_global || req_global_ready) && (!is_addr_local || req_local_ready);
						VX_elastic_buffer #(
							.DATAW(REQ_DATAW),
							.SIZE(1),
							.OUT_REG(1)
						) req_global_buf(
							.clk(clk),
							.reset(reset),
							.valid_in(vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_valid && is_addr_global),
							.data_in({global_mask, vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_data[361], vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_data[360-:120], vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_data[240-:128], vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_data[112-:16], vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_data[96-:52], vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_data[44-:_param_D2283_TAG_WIDTH]}),
							.ready_in(req_global_ready),
							.valid_out(vortex_core_wrap.core.mem_unit.lsu_dcache_if[_mbase_global_out_if].req_valid),
							.data_out(vortex_core_wrap.core.mem_unit.lsu_dcache_if[_mbase_global_out_if].req_data),
							.ready_out(vortex_core_wrap.core.mem_unit.lsu_dcache_if[_mbase_global_out_if].req_ready)
						);
						wire [51:0] local_user;
						genvar _gv_i_237;
						for (_gv_i_237 = 0; _gv_i_237 < 4; _gv_i_237 = _gv_i_237 + 1) begin : g_local_user
							localparam i = _gv_i_237;
							reg [12:0] lane_clean;
							always @(*) begin
								if (_sv2v_0)
									;
								begin : sv2v_autoblock_22
									reg [12:0] sv2v_tmp_cast;
									sv2v_tmp_cast = vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_data[45 + (i * 13)+:13];
									lane_clean = sv2v_tmp_cast;
								end
								lane_clean[12-:10] = 1'sb0;
							end
							function automatic [12:0] sv2v_cast_928CB;
								input reg [12:0] inp;
								sv2v_cast_928CB = inp;
							endfunction
							assign local_user[i * 13+:13] = sv2v_cast_928CB(lane_clean);
						end
						VX_elastic_buffer #(
							.DATAW(REQ_DATAW),
							.SIZE(1),
							.OUT_REG(1)
						) req_local_buf(
							.clk(clk),
							.reset(reset),
							.valid_in(vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_valid && is_addr_local),
							.data_in({local_mask, vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_data[361], vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_data[360-:120], vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_data[240-:128], vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_data[112-:16], local_user, vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_data[44-:_param_D2283_TAG_WIDTH]}),
							.ready_in(req_local_ready),
							.valid_out(vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_local_out_if].req_valid),
							.data_out(vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_local_out_if].req_data),
							.ready_out(vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_local_out_if].req_ready)
						);
						genvar _gv_lane_2;
						localparam VX_gpu_pkg_MEM_ATTR_AMO_OFFS = 3;
						for (_gv_lane_2 = 0; _gv_lane_2 < 4; _gv_lane_2 = _gv_lane_2 + 1) begin : g_amo_lmem_assert
							localparam lane = _gv_lane_2;
							wire amo_local_lane = ((vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_valid && vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_data[362 + lane]) && vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_data[45 + ((lane * 13) + VX_gpu_pkg_MEM_ATTR_AMO_OFFS)]) && vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].req_data[45 + ((lane * 13) + VX_gpu_pkg_MEM_ATTR_LOCAL_OFFS)];
							always @(*) begin
								if (_sv2v_0)
									;
								if (amo_local_lane)
									;
							end
						end
						VX_stream_arb #(
							.NUM_INPUTS(2),
							.DATAW(RSP_DATAW),
							.ARBITER(ARBITER),
							.OUT_BUF(RSP_OUT_BUF)
						) rsp_arb(
							.clk(clk),
							.reset(reset),
							.valid_in({vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_local_out_if].rsp_valid, vortex_core_wrap.core.mem_unit.lsu_dcache_if[_mbase_global_out_if].rsp_valid}),
							.ready_in({vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_local_out_if].rsp_ready, vortex_core_wrap.core.mem_unit.lsu_dcache_if[_mbase_global_out_if].rsp_ready}),
							.data_in({vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_local_out_if].rsp_data, vortex_core_wrap.core.mem_unit.lsu_dcache_if[_mbase_global_out_if].rsp_data}),
							.data_out(vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].rsp_data),
							.valid_out(vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].rsp_valid),
							.ready_out(vortex_core_wrap.core.lsu_mem_if[_mbase_lsu_in_if].rsp_ready),
							.sel_out()
						);
						initial _sv2v_0 = 0;
					end
					assign lmem_switch.clk = clk;
					assign lmem_switch.reset = reset;
				end
				localparam VX_gpu_pkg_LSU_NUM_REQS = 4;
				localparam _param_77BF1_DATA_SIZE = VX_gpu_pkg_LSU_WORD_SIZE;
				localparam _param_77BF1_TAG_WIDTH = VX_gpu_pkg_LSU_TAG_WIDTH;
				genvar _arr_77BF1;
				for (_arr_77BF1 = 0; _arr_77BF1 <= 3; _arr_77BF1 = _arr_77BF1 + 1) begin : lmem_adapt_if
					localparam DATA_SIZE = _param_77BF1_DATA_SIZE;
					localparam VX_gpu_pkg_NC_BITS = 0;
					localparam VX_gpu_pkg_NT_BITS = 2;
					localparam VX_gpu_pkg_NW_BITS = 2;
					localparam VX_gpu_pkg_HART_ID_BITS = 4;
					localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
					localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
					localparam ATTR_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
					localparam VX_gpu_pkg_UUID_WIDTH = 44;
					localparam TAG_WIDTH = _param_77BF1_TAG_WIDTH;
					localparam ADDR_WIDTH = 30;
					wire req_valid;
					wire [124:0] req_data;
					wire req_ready;
					wire rsp_valid;
					wire [76:0] rsp_data;
					wire rsp_ready;
				end
				genvar _gv_i_91;
				for (_gv_i_91 = 0; _gv_i_91 < 1; _gv_i_91 = _gv_i_91 + 1) begin : g_lmem_adapters
					localparam i = _gv_i_91;
					localparam _param_15B1A_DATA_SIZE = VX_gpu_pkg_LSU_WORD_SIZE;
					localparam _param_15B1A_TAG_WIDTH = VX_gpu_pkg_LSU_TAG_WIDTH;
					genvar _arr_15B1A;
					for (_arr_15B1A = 0; _arr_15B1A <= 3; _arr_15B1A = _arr_15B1A + 1) begin : lmem_block_if
						localparam DATA_SIZE = _param_15B1A_DATA_SIZE;
						localparam VX_gpu_pkg_NC_BITS = 0;
						localparam VX_gpu_pkg_NT_BITS = 2;
						localparam VX_gpu_pkg_NW_BITS = 2;
						localparam VX_gpu_pkg_HART_ID_BITS = 4;
						localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
						localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
						localparam ATTR_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
						localparam VX_gpu_pkg_UUID_WIDTH = 44;
						localparam TAG_WIDTH = _param_15B1A_TAG_WIDTH;
						localparam ADDR_WIDTH = 30;
						wire req_valid;
						wire [124:0] req_data;
						wire req_ready;
						wire rsp_valid;
						wire [76:0] rsp_data;
						wire rsp_ready;
					end
					localparam _bbase_B51ED_lsu_mem_if = _gv_i_91;
					localparam _bbase_B51ED_mem_bus_if = 0;
					localparam _param_B51ED_NUM_LANES = 4;
					localparam _param_B51ED_DATA_SIZE = VX_gpu_pkg_LSU_WORD_SIZE;
					localparam _param_B51ED_TAG_WIDTH = VX_gpu_pkg_LSU_TAG_WIDTH;
					localparam _param_B51ED_TAG_SEL_BITS = 1;
					localparam _param_B51ED_ARBITER = "P";
					localparam _param_B51ED_REQ_OUT_BUF = 3;
					localparam _param_B51ED_RSP_OUT_BUF = 0;
					if (1) begin : lmem_adapter
						localparam NUM_LANES = _param_B51ED_NUM_LANES;
						localparam DATA_SIZE = _param_B51ED_DATA_SIZE;
						localparam TAG_WIDTH = _param_B51ED_TAG_WIDTH;
						localparam TAG_SEL_BITS = _param_B51ED_TAG_SEL_BITS;
						localparam ARBITER = _param_B51ED_ARBITER;
						localparam REQ_OUT_BUF = _param_B51ED_REQ_OUT_BUF;
						localparam RSP_OUT_BUF = _param_B51ED_RSP_OUT_BUF;
						wire clk;
						wire reset;
						localparam _mbase_lsu_mem_if = _bbase_B51ED_lsu_mem_if;
						localparam _mbase_mem_bus_if = 0;
						localparam REQ_ADDR_WIDTH = 30;
						localparam VX_gpu_pkg_NC_BITS = 0;
						localparam VX_gpu_pkg_NT_BITS = 2;
						localparam VX_gpu_pkg_NW_BITS = 2;
						localparam VX_gpu_pkg_HART_ID_BITS = 4;
						localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
						localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
						localparam REQ_DATA_WIDTH = 80;
						localparam RSP_DATA_WIDTH = 32;
						wire [319:0] req_data_in;
						wire [3:0] req_valid_out;
						wire [319:0] req_data_out;
						wire [179:0] req_tag_out;
						wire [3:0] req_ready_out;
						genvar _gv_i_246;
						for (_gv_i_246 = 0; _gv_i_246 < NUM_LANES; _gv_i_246 = _gv_i_246 + 1) begin : g_req_data_in
							localparam i = _gv_i_246;
							assign req_data_in[i * 80+:80] = {vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_lsu_mem_if].req_data[361], vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_lsu_mem_if].req_data[241 + (i * 30)+:30], vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_lsu_mem_if].req_data[113 + (i * 32)+:32], vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_lsu_mem_if].req_data[97 + (i * _param_28C6D_DATA_SIZE)+:_param_28C6D_DATA_SIZE], vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_lsu_mem_if].req_data[45 + (i * 13)+:13]};
						end
						VX_stream_unpack #(
							.NUM_REQS(NUM_LANES),
							.DATA_WIDTH(REQ_DATA_WIDTH),
							.TAG_WIDTH(TAG_WIDTH),
							.OUT_BUF(REQ_OUT_BUF)
						) stream_unpack(
							.clk(clk),
							.reset(reset),
							.valid_in(vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_lsu_mem_if].req_valid),
							.mask_in(vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_lsu_mem_if].req_data[365-:4]),
							.data_in(req_data_in),
							.tag_in(vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_lsu_mem_if].req_data[44-:_param_28C6D_TAG_WIDTH]),
							.ready_in(vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_lsu_mem_if].req_ready),
							.valid_out(req_valid_out),
							.data_out(req_data_out),
							.tag_out(req_tag_out),
							.ready_out(req_ready_out)
						);
						genvar _gv_i_247;
						for (_gv_i_247 = 0; _gv_i_247 < NUM_LANES; _gv_i_247 = _gv_i_247 + 1) begin : g_mem_bus_req
							localparam i = _gv_i_247;
							assign vortex_core_wrap.core.mem_unit.g_lmem_adapters[_gv_i_91].lmem_block_if[i + _mbase_mem_bus_if].req_valid = req_valid_out[i];
							assign {vortex_core_wrap.core.mem_unit.g_lmem_adapters[_gv_i_91].lmem_block_if[i + _mbase_mem_bus_if].req_data[124], vortex_core_wrap.core.mem_unit.g_lmem_adapters[_gv_i_91].lmem_block_if[i + _mbase_mem_bus_if].req_data[123-:30], vortex_core_wrap.core.mem_unit.g_lmem_adapters[_gv_i_91].lmem_block_if[i + _mbase_mem_bus_if].req_data[93-:32], vortex_core_wrap.core.mem_unit.g_lmem_adapters[_gv_i_91].lmem_block_if[i + _mbase_mem_bus_if].req_data[61-:4], vortex_core_wrap.core.mem_unit.g_lmem_adapters[_gv_i_91].lmem_block_if[i + _mbase_mem_bus_if].req_data[57-:13]} = req_data_out[i * 80+:80];
							assign vortex_core_wrap.core.mem_unit.g_lmem_adapters[_gv_i_91].lmem_block_if[i + _mbase_mem_bus_if].req_data[44-:VX_gpu_pkg_LSU_TAG_WIDTH] = req_tag_out[i * 45+:45];
							assign req_ready_out[i] = vortex_core_wrap.core.mem_unit.g_lmem_adapters[_gv_i_91].lmem_block_if[i + _mbase_mem_bus_if].req_ready;
						end
						wire [3:0] rsp_valid_out;
						wire [127:0] rsp_data_out;
						wire [179:0] rsp_tag_out;
						wire [3:0] rsp_ready_out;
						genvar _gv_i_248;
						for (_gv_i_248 = 0; _gv_i_248 < NUM_LANES; _gv_i_248 = _gv_i_248 + 1) begin : g_mem_bus_rsp
							localparam i = _gv_i_248;
							assign rsp_valid_out[i] = vortex_core_wrap.core.mem_unit.g_lmem_adapters[_gv_i_91].lmem_block_if[i + _mbase_mem_bus_if].rsp_valid;
							assign rsp_data_out[i * 32+:32] = vortex_core_wrap.core.mem_unit.g_lmem_adapters[_gv_i_91].lmem_block_if[i + _mbase_mem_bus_if].rsp_data[76-:32];
							assign rsp_tag_out[i * 45+:45] = vortex_core_wrap.core.mem_unit.g_lmem_adapters[_gv_i_91].lmem_block_if[i + _mbase_mem_bus_if].rsp_data[44-:VX_gpu_pkg_LSU_TAG_WIDTH];
							assign vortex_core_wrap.core.mem_unit.g_lmem_adapters[_gv_i_91].lmem_block_if[i + _mbase_mem_bus_if].rsp_ready = rsp_ready_out[i];
						end
						VX_stream_pack #(
							.NUM_REQS(NUM_LANES),
							.DATA_WIDTH(RSP_DATA_WIDTH),
							.TAG_WIDTH(TAG_WIDTH),
							.TAG_SEL_BITS(TAG_SEL_BITS),
							.ARBITER(ARBITER),
							.OUT_BUF(RSP_OUT_BUF)
						) stream_pack(
							.clk(clk),
							.reset(reset),
							.valid_in(rsp_valid_out),
							.data_in(rsp_data_out),
							.tag_in(rsp_tag_out),
							.ready_in(rsp_ready_out),
							.valid_out(vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_lsu_mem_if].rsp_valid),
							.mask_out(vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_lsu_mem_if].rsp_data[176-:4]),
							.data_out(vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_lsu_mem_if].rsp_data[172-:128]),
							.tag_out(vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_lsu_mem_if].rsp_data[44-:_param_28C6D_TAG_WIDTH]),
							.ready_out(vortex_core_wrap.core.mem_unit.lsu_lmem_if[_mbase_lsu_mem_if].rsp_ready)
						);
					end
					assign lmem_adapter.clk = clk;
					assign lmem_adapter.reset = reset;
					genvar _gv_j_6;
					for (_gv_j_6 = 0; _gv_j_6 < 4; _gv_j_6 = _gv_j_6 + 1) begin : g_lmem_adapt_if
						localparam j = _gv_j_6;
						assign lmem_adapt_if[(i * 4) + j].req_valid = lmem_block_if[j].req_valid;
						assign lmem_adapt_if[(i * 4) + j].req_data = lmem_block_if[j].req_data;
						assign lmem_block_if[j].req_ready = lmem_adapt_if[(i * 4) + j].req_ready;
						assign lmem_block_if[j].rsp_valid = lmem_adapt_if[(i * 4) + j].rsp_valid;
						assign lmem_block_if[j].rsp_data = lmem_adapt_if[(i * 4) + j].rsp_data;
						assign lmem_adapt_if[(i * 4) + j].rsp_ready = lmem_block_if[j].rsp_ready;
					end
				end
				localparam VX_gpu_pkg_LMEM_DMA_ADDR_WIDTH = 10;
				localparam VX_gpu_pkg_NB_BITS = 3;
				localparam VX_gpu_pkg_NW_BITS = 2;
				localparam VX_gpu_pkg_BAR_ADDR_BITS = 5;
				localparam VX_gpu_pkg_BAR_ADDR_W = VX_gpu_pkg_BAR_ADDR_BITS;
				localparam VX_gpu_pkg_DXA_LMEM_ATTR_W = 6;
				localparam VX_gpu_pkg_TCU_LMEM_ATTR_W = 1;
				localparam VX_gpu_pkg_LMEM_DMA_ATTR_W = VX_gpu_pkg_DXA_LMEM_ATTR_W;
				localparam VX_gpu_pkg_LMEM_DMA_DATA_SIZE = 16;
				localparam VX_gpu_pkg_DXA_LMEM_ENGINE_TAG_W = 45;
				localparam VX_gpu_pkg_NC_BITS = 0;
				localparam VX_gpu_pkg_DXA_LMEM_TAG_W = 45;
				localparam VX_gpu_pkg_DXA_LMEM_OUT_TAG_W = 45;
				localparam VX_gpu_pkg_LMEM_DMA_INPUTS = 0;
				localparam VX_gpu_pkg_TCU_LMEM_BLK_TAG_W = 45;
				localparam VX_gpu_pkg_TCU_LMEM_NUM_MASTERS = 2;
				localparam VX_gpu_pkg_TCU_LMEM_TAG_W = 46;
				localparam VX_gpu_pkg_LMEM_DMA_TAG_WIDTH = 46;
				localparam _param_51F23_DATA_SIZE = VX_gpu_pkg_LMEM_DMA_DATA_SIZE;
				localparam _param_51F23_TAG_WIDTH = VX_gpu_pkg_LMEM_DMA_TAG_WIDTH;
				localparam _param_51F23_ATTR_WIDTH = VX_gpu_pkg_LMEM_DMA_ATTR_W;
				localparam _param_51F23_ADDR_WIDTH = VX_gpu_pkg_LMEM_DMA_ADDR_WIDTH;
				if (1) begin : lmem_dma_if
					localparam DATA_SIZE = _param_51F23_DATA_SIZE;
					localparam VX_gpu_pkg_NC_BITS = 0;
					localparam VX_gpu_pkg_NT_BITS = 2;
					localparam VX_gpu_pkg_NW_BITS = 2;
					localparam VX_gpu_pkg_HART_ID_BITS = 4;
					localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
					localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
					localparam ATTR_WIDTH = _param_51F23_ATTR_WIDTH;
					localparam VX_gpu_pkg_UUID_WIDTH = 44;
					localparam TAG_WIDTH = _param_51F23_TAG_WIDTH;
					localparam ADDR_WIDTH = _param_51F23_ADDR_WIDTH;
					wire req_valid;
					wire [206:0] req_data;
					wire req_ready;
					wire rsp_valid;
					wire [173:0] rsp_data;
					wire rsp_ready;
				end
				localparam LMEM_DMA_IN_TAG_W = VX_gpu_pkg_TCU_LMEM_TAG_W;
				if (1) begin : g_no_lmem_dma
					assign lmem_dma_if.req_valid = 1'b0;
					assign lmem_dma_if.req_data = 1'sb0;
					assign lmem_dma_if.rsp_ready = 1'b0;
				end
				localparam VX_gpu_pkg_LMEM_DMA_EN = 1'd0;
				localparam _bbase_AAE21_lsu_bus_if = 0;
				localparam _param_AAE21_INSTANCE_ID = "";
				localparam _param_AAE21_SIZE = 16384;
				localparam _param_AAE21_NUM_REQS = VX_gpu_pkg_LSU_NUM_REQS;
				localparam _param_AAE21_NUM_BANKS = 4;
				localparam _param_AAE21_WORD_SIZE = VX_gpu_pkg_LSU_WORD_SIZE;
				localparam _param_AAE21_ADDR_WIDTH = LMEM_ADDR_WIDTH;
				localparam _param_AAE21_TAG_WIDTH = VX_gpu_pkg_LSU_TAG_WIDTH;
				localparam _param_AAE21_DMA_ENABLE = VX_gpu_pkg_LMEM_DMA_EN;
				localparam _param_AAE21_DMA_TAG_WIDTH = VX_gpu_pkg_LMEM_DMA_TAG_WIDTH;
				localparam _param_AAE21_OUT_BUF = 3;
				if (1) begin : local_mem
					localparam INSTANCE_ID = _param_AAE21_INSTANCE_ID;
					localparam SIZE = _param_AAE21_SIZE;
					localparam NUM_REQS = _param_AAE21_NUM_REQS;
					localparam NUM_BANKS = _param_AAE21_NUM_BANKS;
					localparam ADDR_WIDTH = _param_AAE21_ADDR_WIDTH;
					localparam WORD_SIZE = _param_AAE21_WORD_SIZE;
					localparam TAG_WIDTH = _param_AAE21_TAG_WIDTH;
					localparam DMA_ENABLE = _param_AAE21_DMA_ENABLE;
					localparam DMA_TAG_WIDTH = _param_AAE21_DMA_TAG_WIDTH;
					localparam OUT_BUF = _param_AAE21_OUT_BUF;
					wire clk;
					wire reset;
					localparam _mbase_lsu_bus_if = 0;
					localparam REQ_SEL_BITS = 2;
					localparam REQ_SEL_WIDTH = REQ_SEL_BITS;
					localparam WORD_WIDTH = 32;
					localparam NUM_WORDS = 4096;
					localparam WORDS_PER_BANK = 1024;
					localparam BANK_ADDR_WIDTH = 10;
					localparam BANK_SEL_BITS = 2;
					localparam BANK_SEL_WIDTH = BANK_SEL_BITS;
					localparam REQ_DATAW = 92;
					localparam RSP_DATAW = 77;
					wire [7:0] req_bank_idx;
					if (1) begin : g_req_bank_idx
						genvar _gv_i_238;
						for (_gv_i_238 = 0; _gv_i_238 < NUM_REQS; _gv_i_238 = _gv_i_238 + 1) begin : g_req_bank_idxs
							localparam i = _gv_i_238;
							assign req_bank_idx[i * 2+:2] = vortex_core_wrap.core.mem_unit.lmem_adapt_if[i + _mbase_lsu_bus_if].req_data[94+:BANK_SEL_BITS];
						end
					end
					wire [39:0] req_bank_addr;
					genvar _gv_i_239;
					for (_gv_i_239 = 0; _gv_i_239 < NUM_REQS; _gv_i_239 = _gv_i_239 + 1) begin : g_req_bank_addr
						localparam i = _gv_i_239;
						assign req_bank_addr[i * 10+:10] = vortex_core_wrap.core.mem_unit.lmem_adapt_if[i + _mbase_lsu_bus_if].req_data[96+:BANK_ADDR_WIDTH];
					end
					wire [3:0] per_bank_req_valid;
					wire [3:0] per_bank_req_rw;
					wire [39:0] per_bank_req_addr;
					wire [15:0] per_bank_req_byteen;
					wire [127:0] per_bank_req_data;
					wire [179:0] per_bank_req_tag;
					wire [7:0] per_bank_req_idx;
					wire [3:0] per_bank_req_ready;
					wire [367:0] per_bank_req_data_aos;
					wire [3:0] req_valid_in;
					wire [367:0] req_data_in;
					wire [3:0] req_ready_in;
					genvar _gv_i_240;
					for (_gv_i_240 = 0; _gv_i_240 < NUM_REQS; _gv_i_240 = _gv_i_240 + 1) begin : g_req_data_in
						localparam i = _gv_i_240;
						assign req_valid_in[i] = vortex_core_wrap.core.mem_unit.lmem_adapt_if[i + _mbase_lsu_bus_if].req_valid;
						assign req_data_in[i * 92+:92] = {vortex_core_wrap.core.mem_unit.lmem_adapt_if[i + _mbase_lsu_bus_if].req_data[124], req_bank_addr[i * 10+:10], vortex_core_wrap.core.mem_unit.lmem_adapt_if[i + _mbase_lsu_bus_if].req_data[93-:32], vortex_core_wrap.core.mem_unit.lmem_adapt_if[i + _mbase_lsu_bus_if].req_data[61-:4], vortex_core_wrap.core.mem_unit.lmem_adapt_if[i + _mbase_lsu_bus_if].req_data[44-:_param_77BF1_TAG_WIDTH]};
						assign vortex_core_wrap.core.mem_unit.lmem_adapt_if[i + _mbase_lsu_bus_if].req_ready = req_ready_in[i];
					end
					localparam VX_gpu_pkg_PERF_CTR_BITS = 44;
					VX_stream_xbar #(
						.NUM_INPUTS(NUM_REQS),
						.NUM_OUTPUTS(NUM_BANKS),
						.DATAW(REQ_DATAW),
						.PERF_CTR_BITS(VX_gpu_pkg_PERF_CTR_BITS),
						.ARBITER("P"),
						.OUT_BUF(3)
					) req_xbar(
						.clk(clk),
						.reset(reset),
						.collisions(),
						.valid_in(req_valid_in),
						.data_in(req_data_in),
						.sel_in(req_bank_idx),
						.ready_in(req_ready_in),
						.valid_out(per_bank_req_valid),
						.data_out(per_bank_req_data_aos),
						.sel_out(per_bank_req_idx),
						.ready_out(per_bank_req_ready)
					);
					genvar _gv_i_241;
					for (_gv_i_241 = 0; _gv_i_241 < NUM_BANKS; _gv_i_241 = _gv_i_241 + 1) begin : g_per_bank_req_data_soa
						localparam i = _gv_i_241;
						assign {per_bank_req_rw[i], per_bank_req_addr[i * 10+:10], per_bank_req_data[i * 32+:32], per_bank_req_byteen[i * 4+:4], per_bank_req_tag[i * 45+:45]} = per_bank_req_data_aos[i * 92+:92];
					end
					wire [3:0] per_bank_rsp_valid;
					wire [127:0] per_bank_rsp_data;
					wire [127:0] bank_lsu_rsp_data;
					wire [7:0] per_bank_rsp_idx;
					wire [179:0] per_bank_rsp_tag;
					wire [3:0] per_bank_rsp_ready;
					wire dma_rsp_buf_ready;
					if (DMA_ENABLE) begin : g_dma_enable
						assign vortex_core_wrap.core.mem_unit.lmem_dma_if.req_ready = vortex_core_wrap.core.mem_unit.lmem_dma_if.req_data[206] || dma_rsp_buf_ready;
						wire dma_rd_fire = (vortex_core_wrap.core.mem_unit.lmem_dma_if.req_valid && ~vortex_core_wrap.core.mem_unit.lmem_dma_if.req_data[206]) && dma_rsp_buf_ready;
						VX_pipe_buffer #(.DATAW(DMA_TAG_WIDTH)) dma_rsp_buf(
							.clk(clk),
							.reset(reset),
							.valid_in(dma_rd_fire),
							.ready_in(dma_rsp_buf_ready),
							.data_in(vortex_core_wrap.core.mem_unit.lmem_dma_if.req_data[45-:46]),
							.valid_out(vortex_core_wrap.core.mem_unit.lmem_dma_if.rsp_valid),
							.data_out(vortex_core_wrap.core.mem_unit.lmem_dma_if.rsp_data[45-:46]),
							.ready_out(vortex_core_wrap.core.mem_unit.lmem_dma_if.rsp_ready)
						);
						reg [127:0] dma_rsp_hold_data_r;
						reg dma_rsp_hold_valid_r;
						wire dma_rsp_consumed = vortex_core_wrap.core.mem_unit.lmem_dma_if.rsp_valid && vortex_core_wrap.core.mem_unit.lmem_dma_if.rsp_ready;
						always @(posedge clk)
							if (reset)
								dma_rsp_hold_valid_r <= 1'b0;
							else if (dma_rsp_consumed)
								dma_rsp_hold_valid_r <= 1'b0;
							else if (vortex_core_wrap.core.mem_unit.lmem_dma_if.rsp_valid && ~dma_rsp_hold_valid_r) begin
								dma_rsp_hold_data_r <= per_bank_rsp_data;
								dma_rsp_hold_valid_r <= 1'b1;
							end
						genvar _gv_i_242;
						for (_gv_i_242 = 0; _gv_i_242 < NUM_BANKS; _gv_i_242 = _gv_i_242 + 1) begin : g_dma_rsp_data
							localparam i = _gv_i_242;
							assign vortex_core_wrap.core.mem_unit.lmem_dma_if.rsp_data[46 + (i * WORD_WIDTH)+:WORD_WIDTH] = (dma_rsp_hold_valid_r ? dma_rsp_hold_data_r[i * 32+:32] : per_bank_rsp_data[i * 32+:32]);
						end
					end
					else begin : g_no_dma
						assign dma_rsp_buf_ready = 1'b0;
						assign vortex_core_wrap.core.mem_unit.lmem_dma_if.req_ready = 1'b0;
						assign vortex_core_wrap.core.mem_unit.lmem_dma_if.rsp_valid = 1'b0;
						assign vortex_core_wrap.core.mem_unit.lmem_dma_if.rsp_data = 1'sb0;
					end
					genvar _gv_i_243;
					for (_gv_i_243 = 0; _gv_i_243 < NUM_BANKS; _gv_i_243 = _gv_i_243 + 1) begin : g_data_store
						localparam i = _gv_i_243;
						wire bank_rsp_valid;
						wire bank_rsp_ready;
						wire dma_wr_b = 1'd0;
						wire dma_rd_b = 1'd0;
						wire dma_active = dma_wr_b | dma_rd_b;
						wire [9:0] bank_sram_addr;
						wire [31:0] bank_sram_wdata;
						wire [3:0] bank_sram_wren;
						assign bank_sram_addr = (dma_active ? sv2v_cast_10(vortex_core_wrap.core.mem_unit.lmem_dma_if.req_data[205-:10]) : per_bank_req_addr[i * 10+:10]);
						assign bank_sram_wdata = (dma_wr_b ? vortex_core_wrap.core.mem_unit.lmem_dma_if.req_data[68 + (i * WORD_WIDTH)+:WORD_WIDTH] : per_bank_req_data[i * 32+:32]);
						assign bank_sram_wren = (dma_wr_b ? vortex_core_wrap.core.mem_unit.lmem_dma_if.req_data[52 + (i * WORD_SIZE)+:WORD_SIZE] : per_bank_req_byteen[i * 4+:4]);
						wire lsu_active = per_bank_req_valid[i] && per_bank_req_ready[i];
						VX_sp_ram #(
							.DATAW(WORD_WIDTH),
							.SIZE(WORDS_PER_BANK),
							.WRENW(WORD_SIZE),
							.OUT_REG(1),
							.RDW_MODE("R")
						) lmem_store(
							.clk(clk),
							.reset(reset),
							.read(dma_rd_b || (lsu_active && ~per_bank_req_rw[i])),
							.write(dma_wr_b || (lsu_active && per_bank_req_rw[i])),
							.wren(bank_sram_wren),
							.addr(bank_sram_addr),
							.wdata(bank_sram_wdata),
							.rdata(per_bank_rsp_data[i * 32+:32])
						);
						reg [9:0] last_wr_addr;
						reg last_wr_valid;
						always @(posedge clk) begin
							if (reset)
								last_wr_valid <= 0;
							else
								last_wr_valid <= dma_wr_b || (lsu_active && per_bank_req_rw[i]);
							last_wr_addr <= bank_sram_addr;
						end
						wire is_rdw_hazard = (last_wr_valid && ~per_bank_req_rw[i]) && (per_bank_req_addr[i * 10+:10] == last_wr_addr);
						assign bank_rsp_valid = ((per_bank_req_valid[i] && ~dma_active) && ~per_bank_req_rw[i]) && ~is_rdw_hazard;
						assign per_bank_req_ready[i] = (~dma_active && (bank_rsp_ready || per_bank_req_rw[i])) && ~is_rdw_hazard;
						VX_pipe_buffer #(.DATAW(47)) bram_buf(
							.clk(clk),
							.reset(reset),
							.valid_in(bank_rsp_valid),
							.ready_in(bank_rsp_ready),
							.data_in({per_bank_req_idx[i * 2+:2], per_bank_req_tag[i * 45+:45]}),
							.data_out({per_bank_rsp_idx[i * 2+:2], per_bank_rsp_tag[i * 45+:45]}),
							.valid_out(per_bank_rsp_valid[i]),
							.ready_out(per_bank_rsp_ready[i])
						);
						reg [31:0] lsu_rsp_hold_data_r;
						reg lsu_rsp_hold_valid_r;
						always @(posedge clk)
							if (reset)
								lsu_rsp_hold_valid_r <= 1'b0;
							else if (per_bank_rsp_valid[i] && per_bank_rsp_ready[i])
								lsu_rsp_hold_valid_r <= 1'b0;
							else if (per_bank_rsp_valid[i] && ~lsu_rsp_hold_valid_r) begin
								lsu_rsp_hold_data_r <= per_bank_rsp_data[i * 32+:32];
								lsu_rsp_hold_valid_r <= 1'b1;
							end
						assign bank_lsu_rsp_data[i * 32+:32] = (lsu_rsp_hold_valid_r ? lsu_rsp_hold_data_r : per_bank_rsp_data[i * 32+:32]);
					end
					wire [307:0] per_bank_rsp_data_aos;
					genvar _gv_i_244;
					for (_gv_i_244 = 0; _gv_i_244 < NUM_BANKS; _gv_i_244 = _gv_i_244 + 1) begin : g_per_bank_rsp_data_aos
						localparam i = _gv_i_244;
						assign per_bank_rsp_data_aos[i * 77+:77] = {bank_lsu_rsp_data[i * 32+:32], per_bank_rsp_tag[i * 45+:45]};
					end
					wire [3:0] rsp_valid_out;
					wire [307:0] rsp_data_out;
					wire [3:0] rsp_ready_out;
					VX_stream_xbar #(
						.NUM_INPUTS(NUM_BANKS),
						.NUM_OUTPUTS(NUM_REQS),
						.DATAW(RSP_DATAW),
						.ARBITER("P"),
						.OUT_BUF(OUT_BUF)
					) rsp_xbar(
						.clk(clk),
						.reset(reset),
						.collisions(),
						.sel_in(per_bank_rsp_idx),
						.valid_in(per_bank_rsp_valid),
						.data_in(per_bank_rsp_data_aos),
						.ready_in(per_bank_rsp_ready),
						.valid_out(rsp_valid_out),
						.data_out(rsp_data_out),
						.ready_out(rsp_ready_out),
						.sel_out()
					);
					genvar _gv_i_245;
					for (_gv_i_245 = 0; _gv_i_245 < NUM_REQS; _gv_i_245 = _gv_i_245 + 1) begin : g_lsu_bus_if
						localparam i = _gv_i_245;
						assign vortex_core_wrap.core.mem_unit.lmem_adapt_if[i + _mbase_lsu_bus_if].rsp_valid = rsp_valid_out[i];
						assign vortex_core_wrap.core.mem_unit.lmem_adapt_if[i + _mbase_lsu_bus_if].rsp_data = rsp_data_out[i * 77+:77];
						assign rsp_ready_out[i] = vortex_core_wrap.core.mem_unit.lmem_adapt_if[i + _mbase_lsu_bus_if].rsp_ready;
					end
				end
				assign local_mem.clk = clk;
				assign local_mem.reset = reset;
				localparam VX_gpu_pkg_DCACHE_MERGED_REQS = 1;
				localparam VX_gpu_pkg_DCACHE_MEM_BATCHES = 1;
				localparam VX_gpu_pkg_DCACHE_TAG_ID_BITS = 2;
				localparam VX_gpu_pkg_DCACHE_CORE_TAG_WIDTH = 46;
				localparam _param_98565_NUM_LANES = VX_gpu_pkg_DCACHE_CHANNELS;
				localparam _param_98565_DATA_SIZE = VX_gpu_pkg_DCACHE_WORD_SIZE;
				localparam _param_98565_TAG_WIDTH = VX_gpu_pkg_DCACHE_CORE_TAG_WIDTH;
				genvar _arr_98565;
				for (_arr_98565 = 0; _arr_98565 <= 0; _arr_98565 = _arr_98565 + 1) begin : dcache_coalesced_if
					localparam NUM_LANES = _param_98565_NUM_LANES;
					localparam DATA_SIZE = _param_98565_DATA_SIZE;
					localparam TAG_WIDTH = _param_98565_TAG_WIDTH;
					localparam VX_gpu_pkg_NC_BITS = 0;
					localparam VX_gpu_pkg_NT_BITS = 2;
					localparam VX_gpu_pkg_NW_BITS = 2;
					localparam VX_gpu_pkg_HART_ID_BITS = 4;
					localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
					localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
					localparam USER_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
					localparam ADDR_WIDTH = 28;
					localparam VX_gpu_pkg_UUID_WIDTH = 44;
					wire req_valid;
					wire [232:0] req_data;
					wire req_ready;
					wire rsp_valid;
					wire [174:0] rsp_data;
					wire rsp_ready;
				end
				localparam VX_gpu_pkg_LSU_ADDR_WIDTH = 30;
				localparam VX_gpu_pkg_MEM_ATTR_AMO_OFFS = 3;
				localparam VX_gpu_pkg_NT_BITS = 2;
				localparam VX_gpu_pkg_HART_ID_BITS = 4;
				localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
				localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
				localparam VX_gpu_pkg_PERF_CTR_BITS = 44;
				if (1) begin : g_coalescing
					genvar _gv_i_92;
					for (_gv_i_92 = 0; _gv_i_92 < 1; _gv_i_92 = _gv_i_92 + 1) begin : g_coalescers
						localparam i = _gv_i_92;
						VX_mem_coalescer #(
							.INSTANCE_ID(""),
							.NUM_REQS(4),
							.DATA_IN_SIZE(VX_gpu_pkg_LSU_WORD_SIZE),
							.DATA_OUT_SIZE(VX_gpu_pkg_DCACHE_WORD_SIZE),
							.ADDR_WIDTH(VX_gpu_pkg_LSU_ADDR_WIDTH),
							.USER_WIDTH(VX_gpu_pkg_MEM_ATTR_WIDTH),
							.TAG_WIDTH(VX_gpu_pkg_LSU_TAG_WIDTH),
							.UUID_WIDTH(VX_gpu_pkg_UUID_WIDTH),
							.QUEUE_SIZE(4),
							.PERF_CTR_BITS(VX_gpu_pkg_PERF_CTR_BITS)
						) mem_coalescer(
							.clk(clk),
							.reset(reset),
							.misses(),
							.in_req_valid(lsu_dcache_if[i].req_valid),
							.in_req_mask(lsu_dcache_if[i].req_data[365-:4]),
							.in_req_rw(lsu_dcache_if[i].req_data[361]),
							.in_req_byteen(lsu_dcache_if[i].req_data[112-:16]),
							.in_req_addr(lsu_dcache_if[i].req_data[360-:120]),
							.in_req_user(lsu_dcache_if[i].req_data[96-:52]),
							.in_req_no_merge(lsu_dcache_if[i].req_data[48]),
							.in_req_data(lsu_dcache_if[i].req_data[240-:128]),
							.in_req_tag(lsu_dcache_if[i].req_data[44-:_param_34737_TAG_WIDTH]),
							.in_req_ready(lsu_dcache_if[i].req_ready),
							.in_rsp_valid(lsu_dcache_if[i].rsp_valid),
							.in_rsp_mask(lsu_dcache_if[i].rsp_data[176-:4]),
							.in_rsp_data(lsu_dcache_if[i].rsp_data[172-:128]),
							.in_rsp_tag(lsu_dcache_if[i].rsp_data[44-:_param_34737_TAG_WIDTH]),
							.in_rsp_ready(lsu_dcache_if[i].rsp_ready),
							.out_req_valid(dcache_coalesced_if[i].req_valid),
							.out_req_mask(dcache_coalesced_if[i].req_data[232-:1]),
							.out_req_rw(dcache_coalesced_if[i].req_data[231]),
							.out_req_byteen(dcache_coalesced_if[i].req_data[74-:16]),
							.out_req_addr(dcache_coalesced_if[i].req_data[230-:28]),
							.out_req_user(dcache_coalesced_if[i].req_data[58-:13]),
							.out_req_data(dcache_coalesced_if[i].req_data[202-:128]),
							.out_req_tag(dcache_coalesced_if[i].req_data[45-:_param_98565_TAG_WIDTH]),
							.out_req_ready(dcache_coalesced_if[i].req_ready),
							.out_rsp_valid(dcache_coalesced_if[i].rsp_valid),
							.out_rsp_mask(dcache_coalesced_if[i].rsp_data[174-:1]),
							.out_rsp_data(dcache_coalesced_if[i].rsp_data[173-:128]),
							.out_rsp_tag(dcache_coalesced_if[i].rsp_data[45-:_param_98565_TAG_WIDTH]),
							.out_rsp_ready(dcache_coalesced_if[i].rsp_ready)
						);
					end
				end
				genvar _gv_i_94;
				localparam VX_gpu_pkg_DCACHE_TAG_WIDTH_BASE = 47;
				for (_gv_i_94 = 0; _gv_i_94 < 1; _gv_i_94 = _gv_i_94 + 1) begin : g_dcache_adapters
					localparam i = _gv_i_94;
					localparam _param_3E257_DATA_SIZE = VX_gpu_pkg_DCACHE_WORD_SIZE;
					localparam _param_3E257_TAG_WIDTH = VX_gpu_pkg_DCACHE_CORE_TAG_WIDTH;
					genvar _arr_3E257;
					for (_arr_3E257 = 0; _arr_3E257 <= 0; _arr_3E257 = _arr_3E257 + 1) begin : dcache_bus_tmp_if
						localparam DATA_SIZE = _param_3E257_DATA_SIZE;
						localparam VX_gpu_pkg_NC_BITS = 0;
						localparam VX_gpu_pkg_NT_BITS = 2;
						localparam VX_gpu_pkg_NW_BITS = 2;
						localparam VX_gpu_pkg_HART_ID_BITS = 4;
						localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
						localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
						localparam ATTR_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
						localparam VX_gpu_pkg_UUID_WIDTH = 44;
						localparam TAG_WIDTH = _param_3E257_TAG_WIDTH;
						localparam ADDR_WIDTH = 28;
						wire req_valid;
						wire [231:0] req_data;
						wire req_ready;
						wire rsp_valid;
						wire [173:0] rsp_data;
						wire rsp_ready;
					end
					localparam _bbase_D0449_lsu_mem_if = _gv_i_94;
					localparam _bbase_D0449_mem_bus_if = 0;
					localparam _param_D0449_NUM_LANES = VX_gpu_pkg_DCACHE_CHANNELS;
					localparam _param_D0449_DATA_SIZE = VX_gpu_pkg_DCACHE_WORD_SIZE;
					localparam _param_D0449_TAG_WIDTH = VX_gpu_pkg_DCACHE_CORE_TAG_WIDTH;
					localparam _param_D0449_TAG_SEL_BITS = 2;
					localparam _param_D0449_ARBITER = "P";
					localparam _param_D0449_REQ_OUT_BUF = 0;
					localparam _param_D0449_RSP_OUT_BUF = 0;
					if (1) begin : dcache_adapter
						localparam NUM_LANES = _param_D0449_NUM_LANES;
						localparam DATA_SIZE = _param_D0449_DATA_SIZE;
						localparam TAG_WIDTH = _param_D0449_TAG_WIDTH;
						localparam TAG_SEL_BITS = _param_D0449_TAG_SEL_BITS;
						localparam ARBITER = _param_D0449_ARBITER;
						localparam REQ_OUT_BUF = _param_D0449_REQ_OUT_BUF;
						localparam RSP_OUT_BUF = _param_D0449_RSP_OUT_BUF;
						wire clk;
						wire reset;
						localparam _mbase_lsu_mem_if = _bbase_D0449_lsu_mem_if;
						localparam _mbase_mem_bus_if = 0;
						localparam REQ_ADDR_WIDTH = 28;
						localparam VX_gpu_pkg_NC_BITS = 0;
						localparam VX_gpu_pkg_NT_BITS = 2;
						localparam VX_gpu_pkg_NW_BITS = 2;
						localparam VX_gpu_pkg_HART_ID_BITS = 4;
						localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
						localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
						localparam REQ_DATA_WIDTH = 186;
						localparam RSP_DATA_WIDTH = 128;
						wire [185:0] req_data_in;
						wire [0:0] req_valid_out;
						wire [185:0] req_data_out;
						wire [45:0] req_tag_out;
						wire [0:0] req_ready_out;
						genvar _gv_i_246;
						for (_gv_i_246 = 0; _gv_i_246 < NUM_LANES; _gv_i_246 = _gv_i_246 + 1) begin : g_req_data_in
							localparam i = _gv_i_246;
							assign req_data_in[i * 186+:186] = {vortex_core_wrap.core.mem_unit.dcache_coalesced_if[_mbase_lsu_mem_if].req_data[231], vortex_core_wrap.core.mem_unit.dcache_coalesced_if[_mbase_lsu_mem_if].req_data[203 + (i * 28)+:28], vortex_core_wrap.core.mem_unit.dcache_coalesced_if[_mbase_lsu_mem_if].req_data[75 + (i * 128)+:128], vortex_core_wrap.core.mem_unit.dcache_coalesced_if[_mbase_lsu_mem_if].req_data[59 + (i * _param_98565_DATA_SIZE)+:_param_98565_DATA_SIZE], vortex_core_wrap.core.mem_unit.dcache_coalesced_if[_mbase_lsu_mem_if].req_data[46 + (i * 13)+:13]};
						end
						VX_stream_unpack #(
							.NUM_REQS(NUM_LANES),
							.DATA_WIDTH(REQ_DATA_WIDTH),
							.TAG_WIDTH(TAG_WIDTH),
							.OUT_BUF(REQ_OUT_BUF)
						) stream_unpack(
							.clk(clk),
							.reset(reset),
							.valid_in(vortex_core_wrap.core.mem_unit.dcache_coalesced_if[_mbase_lsu_mem_if].req_valid),
							.mask_in(vortex_core_wrap.core.mem_unit.dcache_coalesced_if[_mbase_lsu_mem_if].req_data[232-:1]),
							.data_in(req_data_in),
							.tag_in(vortex_core_wrap.core.mem_unit.dcache_coalesced_if[_mbase_lsu_mem_if].req_data[45-:_param_98565_TAG_WIDTH]),
							.ready_in(vortex_core_wrap.core.mem_unit.dcache_coalesced_if[_mbase_lsu_mem_if].req_ready),
							.valid_out(req_valid_out),
							.data_out(req_data_out),
							.tag_out(req_tag_out),
							.ready_out(req_ready_out)
						);
						genvar _gv_i_247;
						for (_gv_i_247 = 0; _gv_i_247 < NUM_LANES; _gv_i_247 = _gv_i_247 + 1) begin : g_mem_bus_req
							localparam i = _gv_i_247;
							assign vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].dcache_bus_tmp_if[i + _mbase_mem_bus_if].req_valid = req_valid_out[i];
							assign {vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].dcache_bus_tmp_if[i + _mbase_mem_bus_if].req_data[231], vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].dcache_bus_tmp_if[i + _mbase_mem_bus_if].req_data[230-:28], vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].dcache_bus_tmp_if[i + _mbase_mem_bus_if].req_data[202-:128], vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].dcache_bus_tmp_if[i + _mbase_mem_bus_if].req_data[74-:16], vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].dcache_bus_tmp_if[i + _mbase_mem_bus_if].req_data[58-:13]} = req_data_out[i * 186+:186];
							assign vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].dcache_bus_tmp_if[i + _mbase_mem_bus_if].req_data[45-:VX_gpu_pkg_DCACHE_CORE_TAG_WIDTH] = req_tag_out[i * 46+:46];
							assign req_ready_out[i] = vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].dcache_bus_tmp_if[i + _mbase_mem_bus_if].req_ready;
						end
						wire [0:0] rsp_valid_out;
						wire [127:0] rsp_data_out;
						wire [45:0] rsp_tag_out;
						wire [0:0] rsp_ready_out;
						genvar _gv_i_248;
						for (_gv_i_248 = 0; _gv_i_248 < NUM_LANES; _gv_i_248 = _gv_i_248 + 1) begin : g_mem_bus_rsp
							localparam i = _gv_i_248;
							assign rsp_valid_out[i] = vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].dcache_bus_tmp_if[i + _mbase_mem_bus_if].rsp_valid;
							assign rsp_data_out[i * 128+:128] = vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].dcache_bus_tmp_if[i + _mbase_mem_bus_if].rsp_data[173-:128];
							assign rsp_tag_out[i * 46+:46] = vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].dcache_bus_tmp_if[i + _mbase_mem_bus_if].rsp_data[45-:VX_gpu_pkg_DCACHE_CORE_TAG_WIDTH];
							assign vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].dcache_bus_tmp_if[i + _mbase_mem_bus_if].rsp_ready = rsp_ready_out[i];
						end
						VX_stream_pack #(
							.NUM_REQS(NUM_LANES),
							.DATA_WIDTH(RSP_DATA_WIDTH),
							.TAG_WIDTH(TAG_WIDTH),
							.TAG_SEL_BITS(TAG_SEL_BITS),
							.ARBITER(ARBITER),
							.OUT_BUF(RSP_OUT_BUF)
						) stream_pack(
							.clk(clk),
							.reset(reset),
							.valid_in(rsp_valid_out),
							.data_in(rsp_data_out),
							.tag_in(rsp_tag_out),
							.ready_in(rsp_ready_out),
							.valid_out(vortex_core_wrap.core.mem_unit.dcache_coalesced_if[_mbase_lsu_mem_if].rsp_valid),
							.mask_out(vortex_core_wrap.core.mem_unit.dcache_coalesced_if[_mbase_lsu_mem_if].rsp_data[174-:1]),
							.data_out(vortex_core_wrap.core.mem_unit.dcache_coalesced_if[_mbase_lsu_mem_if].rsp_data[173-:128]),
							.tag_out(vortex_core_wrap.core.mem_unit.dcache_coalesced_if[_mbase_lsu_mem_if].rsp_data[45-:_param_98565_TAG_WIDTH]),
							.ready_out(vortex_core_wrap.core.mem_unit.dcache_coalesced_if[_mbase_lsu_mem_if].rsp_ready)
						);
					end
					assign dcache_adapter.clk = clk;
					assign dcache_adapter.reset = reset;
					genvar _gv_j_7;
					for (_gv_j_7 = 0; _gv_j_7 < VX_gpu_pkg_DCACHE_CHANNELS; _gv_j_7 = _gv_j_7 + 1) begin : g_dcache_bus_if
						localparam j = _gv_j_7;
						if ((i == 0) && (j == 0)) begin : g_flush_port
							localparam _bbase_F303F_core_bus_if = _gv_j_7;
							localparam _bbase_F303F_cache_bus_if = 0;
							localparam _param_F303F_WORD_SIZE = VX_gpu_pkg_DCACHE_WORD_SIZE;
							localparam _param_F303F_TAG_WIDTH = VX_gpu_pkg_DCACHE_CORE_TAG_WIDTH;
							if (1) begin : dcr_flush
								localparam WORD_SIZE = _param_F303F_WORD_SIZE;
								localparam TAG_WIDTH = _param_F303F_TAG_WIDTH;
								wire clk;
								wire reset;
								localparam _mbase_core_bus_if = _bbase_F303F_core_bus_if;
								localparam _mbase_cache_bus_if = _bbase_F303F_cache_bus_if;
								localparam _param_7A368_DATA_SIZE = WORD_SIZE;
								localparam _param_7A368_TAG_WIDTH = TAG_WIDTH;
								if (1) begin : flush_bus_if
									localparam DATA_SIZE = _param_7A368_DATA_SIZE;
									localparam VX_gpu_pkg_NC_BITS = 0;
									localparam VX_gpu_pkg_NT_BITS = 2;
									localparam VX_gpu_pkg_NW_BITS = 2;
									localparam VX_gpu_pkg_HART_ID_BITS = 4;
									localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
									localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
									localparam ATTR_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
									localparam VX_gpu_pkg_UUID_WIDTH = 44;
									localparam TAG_WIDTH = _param_7A368_TAG_WIDTH;
									localparam ADDR_WIDTH = 28;
									wire req_valid;
									wire [231:0] req_data;
									wire req_ready;
									wire rsp_valid;
									wire [173:0] rsp_data;
									wire rsp_ready;
								end
								reg flush_inflight_r;
								reg flush_done_r;
								wire flush_req_fire = flush_bus_if.req_valid && flush_bus_if.req_ready;
								always @(posedge clk)
									if (reset) begin
										flush_inflight_r <= 1'b0;
										flush_done_r <= 1'b0;
									end
									else if (!vortex_core_wrap.core.dcr_flush_dcache_if.req) begin
										flush_inflight_r <= 1'b0;
										flush_done_r <= 1'b0;
									end
									else begin
										if (flush_req_fire)
											flush_inflight_r <= 1'b1;
										else if (flush_bus_if.rsp_valid)
											flush_inflight_r <= 1'b0;
										if (flush_bus_if.rsp_valid)
											flush_done_r <= 1'b1;
									end
								assign flush_bus_if.req_valid = (vortex_core_wrap.core.dcr_flush_dcache_if.req && !flush_inflight_r) && !flush_done_r;
								localparam VX_gpu_pkg_MEM_ATTR_FLUSH_OFFS = 0;
								localparam VX_gpu_pkg_NC_BITS = 0;
								localparam VX_gpu_pkg_NT_BITS = 2;
								localparam VX_gpu_pkg_NW_BITS = 2;
								localparam VX_gpu_pkg_HART_ID_BITS = 4;
								localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
								localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
								function automatic signed [12:0] sv2v_cast_928CB_signed;
									input reg signed [12:0] inp;
									sv2v_cast_928CB_signed = inp;
								endfunction
								function automatic [127:0] sv2v_cast_D9C15;
									input reg [127:0] inp;
									sv2v_cast_D9C15 = inp;
								endfunction
								function automatic [15:0] sv2v_cast_FAFA0;
									input reg [15:0] inp;
									sv2v_cast_FAFA0 = inp;
								endfunction
								function automatic [12:0] sv2v_cast_1F942;
									input reg [12:0] inp;
									sv2v_cast_1F942 = inp;
								endfunction
								function automatic [45:0] sv2v_cast_6D90B;
									input reg [45:0] inp;
									sv2v_cast_6D90B = inp;
								endfunction
								assign flush_bus_if.req_data = {29'b00000000000000000000000000000, sv2v_cast_D9C15(1'sb0), sv2v_cast_FAFA0(1'sb0), sv2v_cast_1F942(sv2v_cast_928CB_signed(1)), sv2v_cast_6D90B(1'sb0)};
								assign vortex_core_wrap.core.dcr_flush_dcache_if.done = flush_done_r;
								assign flush_bus_if.rsp_ready = 1'b1;
								localparam _param_BA7FF_DATA_SIZE = WORD_SIZE;
								localparam _param_BA7FF_TAG_WIDTH = TAG_WIDTH;
								genvar _arr_BA7FF;
								for (_arr_BA7FF = 0; _arr_BA7FF <= 1; _arr_BA7FF = _arr_BA7FF + 1) begin : dcache_arb_in_if
									localparam DATA_SIZE = _param_BA7FF_DATA_SIZE;
									localparam VX_gpu_pkg_NC_BITS = 0;
									localparam VX_gpu_pkg_NT_BITS = 2;
									localparam VX_gpu_pkg_NW_BITS = 2;
									localparam VX_gpu_pkg_HART_ID_BITS = 4;
									localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
									localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
									localparam ATTR_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
									localparam VX_gpu_pkg_UUID_WIDTH = 44;
									localparam TAG_WIDTH = _param_BA7FF_TAG_WIDTH;
									localparam ADDR_WIDTH = 28;
									wire req_valid;
									wire [231:0] req_data;
									wire req_ready;
									wire rsp_valid;
									wire [173:0] rsp_data;
									wire rsp_ready;
								end
								assign dcache_arb_in_if[0].req_valid = vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].dcache_bus_tmp_if[_mbase_core_bus_if].req_valid;
								assign dcache_arb_in_if[0].req_data = vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].dcache_bus_tmp_if[_mbase_core_bus_if].req_data;
								assign vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].dcache_bus_tmp_if[_mbase_core_bus_if].req_ready = dcache_arb_in_if[0].req_ready;
								assign vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].dcache_bus_tmp_if[_mbase_core_bus_if].rsp_valid = dcache_arb_in_if[0].rsp_valid;
								assign vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].dcache_bus_tmp_if[_mbase_core_bus_if].rsp_data = dcache_arb_in_if[0].rsp_data;
								assign dcache_arb_in_if[0].rsp_ready = vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].dcache_bus_tmp_if[_mbase_core_bus_if].rsp_ready;
								assign dcache_arb_in_if[1].req_valid = flush_bus_if.req_valid;
								assign dcache_arb_in_if[1].req_data = flush_bus_if.req_data;
								assign flush_bus_if.req_ready = dcache_arb_in_if[1].req_ready;
								assign flush_bus_if.rsp_valid = dcache_arb_in_if[1].rsp_valid;
								assign flush_bus_if.rsp_data = dcache_arb_in_if[1].rsp_data;
								assign dcache_arb_in_if[1].rsp_ready = flush_bus_if.rsp_ready;
								localparam _param_2AB3D_DATA_SIZE = WORD_SIZE;
								localparam _param_2AB3D_TAG_WIDTH = 47;
								genvar _arr_2AB3D;
								for (_arr_2AB3D = 0; _arr_2AB3D <= 0; _arr_2AB3D = _arr_2AB3D + 1) begin : dcache_arb_out_if
									localparam DATA_SIZE = _param_2AB3D_DATA_SIZE;
									localparam VX_gpu_pkg_NC_BITS = 0;
									localparam VX_gpu_pkg_NT_BITS = 2;
									localparam VX_gpu_pkg_NW_BITS = 2;
									localparam VX_gpu_pkg_HART_ID_BITS = 4;
									localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
									localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
									localparam ATTR_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
									localparam VX_gpu_pkg_UUID_WIDTH = 44;
									localparam TAG_WIDTH = _param_2AB3D_TAG_WIDTH;
									localparam ADDR_WIDTH = 28;
									wire req_valid;
									wire [232:0] req_data;
									wire req_ready;
									wire rsp_valid;
									wire [174:0] rsp_data;
									wire rsp_ready;
								end
								localparam _bbase_9497E_bus_in_if = 0;
								localparam _bbase_9497E_bus_out_if = 0;
								localparam _param_9497E_NUM_INPUTS = 2;
								localparam _param_9497E_NUM_OUTPUTS = 1;
								localparam _param_9497E_DATA_SIZE = WORD_SIZE;
								localparam _param_9497E_TAG_WIDTH = TAG_WIDTH;
								localparam _param_9497E_TAG_SEL_IDX = 0;
								localparam _param_9497E_ARBITER = "P";
								localparam _param_9497E_STICKY = 1;
								if (1) begin : dcache_flush_arb
									localparam NUM_INPUTS = _param_9497E_NUM_INPUTS;
									localparam NUM_OUTPUTS = _param_9497E_NUM_OUTPUTS;
									localparam DATA_SIZE = _param_9497E_DATA_SIZE;
									localparam TAG_WIDTH = _param_9497E_TAG_WIDTH;
									localparam TAG_SEL_IDX = _param_9497E_TAG_SEL_IDX;
									localparam REQ_OUT_BUF = 0;
									localparam RSP_OUT_BUF = 0;
									localparam ARBITER = _param_9497E_ARBITER;
									localparam STICKY = _param_9497E_STICKY;
									localparam ADDR_WIDTH = 28;
									localparam VX_gpu_pkg_NC_BITS = 0;
									localparam VX_gpu_pkg_NT_BITS = 2;
									localparam VX_gpu_pkg_NW_BITS = 2;
									localparam VX_gpu_pkg_HART_ID_BITS = 4;
									localparam VX_gpu_pkg_HART_ID_WIDTH = VX_gpu_pkg_HART_ID_BITS;
									localparam VX_gpu_pkg_MEM_ATTR_WIDTH = 13;
									localparam ATTR_WIDTH = VX_gpu_pkg_MEM_ATTR_WIDTH;
									wire clk;
									wire reset;
									localparam _mbase_bus_in_if = 0;
									localparam _mbase_bus_out_if = 0;
									localparam DATA_WIDTH = 128;
									localparam LOG_NUM_REQS = 1;
									localparam REQ_DATAW = 232;
									localparam RSP_DATAW = 174;
									localparam SEL_COUNT = NUM_OUTPUTS;
									wire [1:0] req_valid_in;
									wire [463:0] req_data_in;
									wire [1:0] req_ready_in;
									wire [0:0] req_valid_out;
									wire [231:0] req_data_out;
									wire [0:0] req_sel_out;
									wire [0:0] req_ready_out;
									genvar _gv_i_254;
									for (_gv_i_254 = 0; _gv_i_254 < NUM_INPUTS; _gv_i_254 = _gv_i_254 + 1) begin : g_req_data_in
										localparam i = _gv_i_254;
										assign req_valid_in[i] = vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].g_dcache_bus_if[_gv_j_7].g_flush_port.dcr_flush.dcache_arb_in_if[i + _mbase_bus_in_if].req_valid;
										assign req_data_in[i * 232+:232] = vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].g_dcache_bus_if[_gv_j_7].g_flush_port.dcr_flush.dcache_arb_in_if[i + _mbase_bus_in_if].req_data;
										assign vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].g_dcache_bus_if[_gv_j_7].g_flush_port.dcr_flush.dcache_arb_in_if[i + _mbase_bus_in_if].req_ready = req_ready_in[i];
									end
									VX_stream_arb #(
										.NUM_INPUTS(NUM_INPUTS),
										.NUM_OUTPUTS(NUM_OUTPUTS),
										.DATAW(REQ_DATAW),
										.ARBITER(ARBITER),
										.STICKY(STICKY),
										.OUT_BUF(REQ_OUT_BUF)
									) req_arb(
										.clk(clk),
										.reset(reset),
										.valid_in(req_valid_in),
										.ready_in(req_ready_in),
										.data_in(req_data_in),
										.data_out(req_data_out),
										.sel_out(req_sel_out),
										.valid_out(req_valid_out),
										.ready_out(req_ready_out)
									);
									genvar _gv_i_255;
									for (_gv_i_255 = 0; _gv_i_255 < NUM_OUTPUTS; _gv_i_255 = _gv_i_255 + 1) begin : g_bus_out_if
										localparam i = _gv_i_255;
										wire [45:0] req_tag_out;
										assign vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].g_dcache_bus_if[_gv_j_7].g_flush_port.dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].req_valid = req_valid_out[i];
										assign {vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].g_dcache_bus_if[_gv_j_7].g_flush_port.dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].req_data[232], vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].g_dcache_bus_if[_gv_j_7].g_flush_port.dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].req_data[231-:28], vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].g_dcache_bus_if[_gv_j_7].g_flush_port.dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].req_data[203-:128], vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].g_dcache_bus_if[_gv_j_7].g_flush_port.dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].req_data[75-:VX_gpu_pkg_DCACHE_WORD_SIZE], vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].g_dcache_bus_if[_gv_j_7].g_flush_port.dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].req_data[59-:13], req_tag_out} = req_data_out[i * 232+:232];
										assign req_ready_out[i] = vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].g_dcache_bus_if[_gv_j_7].g_flush_port.dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].req_ready;
										if (1) begin : g_req_tag_sel_out
											VX_bits_insert #(
												.N(TAG_WIDTH),
												.S(LOG_NUM_REQS),
												.POS(TAG_SEL_IDX)
											) bits_insert(
												.data_in(req_tag_out),
												.ins_in(req_sel_out[i+:1]),
												.data_out(vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].g_dcache_bus_if[_gv_j_7].g_flush_port.dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].req_data[46-:47])
											);
										end
									end
									wire [1:0] rsp_valid_out;
									wire [347:0] rsp_data_out;
									wire [1:0] rsp_ready_out;
									wire [0:0] rsp_valid_in;
									wire [173:0] rsp_data_in;
									wire [0:0] rsp_ready_in;
									if (1) begin : g_rsp_select
										wire [0:0] rsp_sel_in;
										genvar _gv_i_256;
										for (_gv_i_256 = 0; _gv_i_256 < NUM_OUTPUTS; _gv_i_256 = _gv_i_256 + 1) begin : g_rsp_data_in
											localparam i = _gv_i_256;
											wire [45:0] rsp_tag_out;
											VX_bits_remove #(
												.N(47),
												.S(LOG_NUM_REQS),
												.POS(TAG_SEL_IDX)
											) bits_remove(
												.data_in(vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].g_dcache_bus_if[_gv_j_7].g_flush_port.dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].rsp_data[46-:47]),
												.sel_out(rsp_sel_in[i+:1]),
												.data_out(rsp_tag_out)
											);
											assign rsp_valid_in[i] = vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].g_dcache_bus_if[_gv_j_7].g_flush_port.dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].rsp_valid;
											assign rsp_data_in[i * 174+:174] = {vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].g_dcache_bus_if[_gv_j_7].g_flush_port.dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].rsp_data[174-:128], rsp_tag_out};
											assign vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].g_dcache_bus_if[_gv_j_7].g_flush_port.dcr_flush.dcache_arb_out_if[i + _mbase_bus_out_if].rsp_ready = rsp_ready_in[i];
										end
										VX_stream_switch #(
											.NUM_INPUTS(NUM_OUTPUTS),
											.NUM_OUTPUTS(NUM_INPUTS),
											.DATAW(RSP_DATAW),
											.OUT_BUF(RSP_OUT_BUF)
										) rsp_switch(
											.clk(clk),
											.reset(reset),
											.sel_in(rsp_sel_in),
											.valid_in(rsp_valid_in),
											.ready_in(rsp_ready_in),
											.data_in(rsp_data_in),
											.data_out(rsp_data_out),
											.valid_out(rsp_valid_out),
											.ready_out(rsp_ready_out)
										);
									end
									genvar _gv_i_258;
									for (_gv_i_258 = 0; _gv_i_258 < NUM_INPUTS; _gv_i_258 = _gv_i_258 + 1) begin : g_output
										localparam i = _gv_i_258;
										assign vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].g_dcache_bus_if[_gv_j_7].g_flush_port.dcr_flush.dcache_arb_in_if[i + _mbase_bus_in_if].rsp_valid = rsp_valid_out[i];
										assign vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].g_dcache_bus_if[_gv_j_7].g_flush_port.dcr_flush.dcache_arb_in_if[i + _mbase_bus_in_if].rsp_data = rsp_data_out[i * 174+:174];
										assign rsp_ready_out[i] = vortex_core_wrap.core.mem_unit.g_dcache_adapters[_gv_i_94].g_dcache_bus_if[_gv_j_7].g_flush_port.dcr_flush.dcache_arb_in_if[i + _mbase_bus_in_if].rsp_ready;
									end
								end
								assign dcache_flush_arb.clk = clk;
								assign dcache_flush_arb.reset = reset;
								assign vortex_core_wrap.core.mmu_dcache_if[_mbase_cache_bus_if].req_valid = dcache_arb_out_if[0].req_valid;
								assign vortex_core_wrap.core.mmu_dcache_if[_mbase_cache_bus_if].req_data = dcache_arb_out_if[0].req_data;
								assign dcache_arb_out_if[0].req_ready = vortex_core_wrap.core.mmu_dcache_if[_mbase_cache_bus_if].req_ready;
								assign dcache_arb_out_if[0].rsp_valid = vortex_core_wrap.core.mmu_dcache_if[_mbase_cache_bus_if].rsp_valid;
								assign dcache_arb_out_if[0].rsp_data = vortex_core_wrap.core.mmu_dcache_if[_mbase_cache_bus_if].rsp_data;
								assign vortex_core_wrap.core.mmu_dcache_if[_mbase_cache_bus_if].rsp_ready = dcache_arb_out_if[0].rsp_ready;
							end
							assign dcr_flush.clk = clk;
							assign dcr_flush.reset = reset;
						end
						else begin : g_passthru_port
							assign vortex_core_wrap.core.mmu_dcache_if[((i * VX_gpu_pkg_DCACHE_CHANNELS) + j) + _mbase_dcache_bus_if].req_valid = dcache_bus_tmp_if[j].req_valid;
							assign vortex_core_wrap.core.mmu_dcache_if[((i * VX_gpu_pkg_DCACHE_CHANNELS) + j) + _mbase_dcache_bus_if].req_data[232] = dcache_bus_tmp_if[j].req_data[231];
							assign vortex_core_wrap.core.mmu_dcache_if[((i * VX_gpu_pkg_DCACHE_CHANNELS) + j) + _mbase_dcache_bus_if].req_data[231-:28] = dcache_bus_tmp_if[j].req_data[230-:28];
							assign vortex_core_wrap.core.mmu_dcache_if[((i * VX_gpu_pkg_DCACHE_CHANNELS) + j) + _mbase_dcache_bus_if].req_data[203-:128] = dcache_bus_tmp_if[j].req_data[202-:128];
							assign vortex_core_wrap.core.mmu_dcache_if[((i * VX_gpu_pkg_DCACHE_CHANNELS) + j) + _mbase_dcache_bus_if].req_data[75-:16] = dcache_bus_tmp_if[j].req_data[74-:16];
							assign vortex_core_wrap.core.mmu_dcache_if[((i * VX_gpu_pkg_DCACHE_CHANNELS) + j) + _mbase_dcache_bus_if].req_data[59-:13] = dcache_bus_tmp_if[j].req_data[58-:13];
							if (1) begin : genblk1
								if (1) begin : genblk1
									if (1) begin : genblk1
										assign vortex_core_wrap.core.mmu_dcache_if[((i * VX_gpu_pkg_DCACHE_CHANNELS) + j) + _mbase_dcache_bus_if].req_data[46-:_param_17854_TAG_WIDTH] = {1'b0, dcache_bus_tmp_if[j].req_data[45-:VX_gpu_pkg_DCACHE_CORE_TAG_WIDTH]};
									end
								end
							end
							assign dcache_bus_tmp_if[j].req_ready = vortex_core_wrap.core.mmu_dcache_if[((i * VX_gpu_pkg_DCACHE_CHANNELS) + j) + _mbase_dcache_bus_if].req_ready;
							assign dcache_bus_tmp_if[j].rsp_valid = vortex_core_wrap.core.mmu_dcache_if[((i * VX_gpu_pkg_DCACHE_CHANNELS) + j) + _mbase_dcache_bus_if].rsp_valid;
							assign dcache_bus_tmp_if[j].rsp_data[173-:128] = vortex_core_wrap.core.mmu_dcache_if[((i * VX_gpu_pkg_DCACHE_CHANNELS) + j) + _mbase_dcache_bus_if].rsp_data[174-:128];
							if (1) begin : genblk2
								if (1) begin : genblk1
									if (1) begin : genblk1
										assign dcache_bus_tmp_if[j].rsp_data[45-:VX_gpu_pkg_DCACHE_CORE_TAG_WIDTH] = vortex_core_wrap.core.mmu_dcache_if[((i * VX_gpu_pkg_DCACHE_CHANNELS) + j) + _mbase_dcache_bus_if].rsp_data[45:0];
									end
								end
							end
							assign vortex_core_wrap.core.mmu_dcache_if[((i * VX_gpu_pkg_DCACHE_CHANNELS) + j) + _mbase_dcache_bus_if].rsp_ready = dcache_bus_tmp_if[j].rsp_ready;
						end
					end
				end
			end
			assign mem_unit.clk = clk;
			assign mem_unit.reset = reset;
			genvar _gv_i_60;
			for (_gv_i_60 = 0; _gv_i_60 < VX_gpu_pkg_DCACHE_NUM_REQS; _gv_i_60 = _gv_i_60 + 1) begin : g_dcache_no_vm
				localparam i = _gv_i_60;
				assign vortex_core_wrap.dcache_bus_if[i + _mbase_dcache_bus_if].req_valid = mmu_dcache_if[i].req_valid;
				assign vortex_core_wrap.dcache_bus_if[i + _mbase_dcache_bus_if].req_data = mmu_dcache_if[i].req_data;
				assign mmu_dcache_if[i].req_ready = vortex_core_wrap.dcache_bus_if[i + _mbase_dcache_bus_if].req_ready;
				assign mmu_dcache_if[i].rsp_valid = vortex_core_wrap.dcache_bus_if[i + _mbase_dcache_bus_if].rsp_valid;
				assign mmu_dcache_if[i].rsp_data = vortex_core_wrap.dcache_bus_if[i + _mbase_dcache_bus_if].rsp_data;
				assign vortex_core_wrap.dcache_bus_if[i + _mbase_dcache_bus_if].rsp_ready = mmu_dcache_if[i].rsp_ready;
			end
			assign vortex_core_wrap.icache_bus_if.req_valid = mmu_icache_if[0].req_valid;
			assign vortex_core_wrap.icache_bus_if.req_data = mmu_icache_if[0].req_data;
			assign mmu_icache_if[0].req_ready = vortex_core_wrap.icache_bus_if.req_ready;
			assign mmu_icache_if[0].rsp_valid = vortex_core_wrap.icache_bus_if.rsp_valid;
			assign mmu_icache_if[0].rsp_data = vortex_core_wrap.icache_bus_if.rsp_data;
			assign vortex_core_wrap.icache_bus_if.rsp_ready = mmu_icache_if[0].rsp_ready;
			assign busy = (sched_busy || dcr_busy) || ~(&lsu_sched_empty);
			assign warp_ctl_if.lsu_sched_drained = &lsu_sched_empty;
		end
	endgenerate
	assign core.clk = clk;
	assign core.reset = reset;
	assign busy = core.busy;
endmodule
module VX_ipdom_stack (
	clk,
	reset,
	wid,
	d_val,
	rd_ptr,
	push,
	pop,
	q_val,
	q_idx,
	wr_ptr,
	empty,
	full
);
	parameter WIDTH = 1;
	parameter DEPTH = 1;
	parameter ADDRW = (DEPTH > 1 ? $clog2(DEPTH) : 1);
	input wire clk;
	input wire reset;
	localparam VX_gpu_pkg_NW_BITS = 2;
	localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
	input wire [1:0] wid;
	input wire [WIDTH - 1:0] d_val;
	input wire [ADDRW - 1:0] rd_ptr;
	input wire push;
	input wire pop;
	output wire [WIDTH - 1:0] q_val;
	output wire q_idx;
	output wire [(4 * ADDRW) - 1:0] wr_ptr;
	output wire empty;
	output wire full;
	localparam BRAM_DATAW = 1 + WIDTH;
	localparam BRAM_SIZE = DEPTH * 4;
	localparam BRAW_ADDRW = (BRAM_SIZE > 1 ? $clog2(BRAM_SIZE) : 1);
	wire [(4 * ADDRW) - 1:0] wr_ptr_w;
	wire [3:0] empty_w;
	wire [3:0] full_w;
	genvar _gv_i_70;
	function automatic signed [ADDRW - 1:0] sv2v_cast_12D70_signed;
		input reg signed [ADDRW - 1:0] inp;
		sv2v_cast_12D70_signed = inp;
	endfunction
	function automatic [ADDRW - 1:0] sv2v_cast_12D70;
		input reg [ADDRW - 1:0] inp;
		sv2v_cast_12D70 = inp;
	endfunction
	generate
		for (_gv_i_70 = 0; _gv_i_70 < 4; _gv_i_70 = _gv_i_70 + 1) begin : g_addressing
			localparam i = _gv_i_70;
			reg [ADDRW - 1:0] wr_ptr_r;
			reg empty_r;
			reg full_r;
			wire push_s = push && (wid == i);
			wire pop_s = pop && (wid == i);
			always @(posedge clk)
				if (reset) begin
					wr_ptr_r <= 1'sb0;
					empty_r <= 1;
					full_r <= 0;
				end
				else if (push_s) begin
					wr_ptr_r <= wr_ptr_r + sv2v_cast_12D70_signed(1);
					empty_r <= 0;
					full_r <= sv2v_cast_12D70_signed(DEPTH - 1) == wr_ptr_r;
				end
				else if (pop_s) begin
					wr_ptr_r <= wr_ptr_r - sv2v_cast_12D70(q_idx);
					empty_r <= (rd_ptr == 0) && q_idx;
					full_r <= 0;
				end
			assign wr_ptr_w[i * ADDRW+:ADDRW] = wr_ptr_r;
			assign empty_w[i] = empty_r;
			assign full_w[i] = full_r;
		end
	endgenerate
	wire [BRAW_ADDRW - 1:0] raddr;
	wire [BRAW_ADDRW - 1:0] waddr;
	generate
		if ((DEPTH > 1) && 1'd1) begin : g_DW
			assign waddr = (push ? {wr_ptr_w[wid * ADDRW+:ADDRW], wid} : {rd_ptr, wid});
			assign raddr = {rd_ptr, wid};
		end
		else if (DEPTH > 1) begin : g_D
			assign waddr = (push ? wr_ptr_w : rd_ptr);
			assign raddr = rd_ptr;
		end
		else begin : g_W
			assign waddr = wid;
			assign raddr = wid;
		end
	endgenerate
	VX_dp_ram #(
		.DATAW(BRAM_DATAW),
		.SIZE(BRAM_SIZE),
		.RDW_MODE("R"),
		.RADDR_REG(1)
	) ipdom_store(
		.clk(clk),
		.reset(reset),
		.read(pop),
		.write(push || pop),
		.wren(1'b1),
		.waddr(waddr),
		.raddr(raddr),
		.wdata((push ? {1'b0, d_val} : {1'b1, q_val})),
		.rdata({q_idx, q_val})
	);
	assign wr_ptr = wr_ptr_w;
	assign empty = empty_w[wid];
	assign full = full_w[wid];
endmodule
module VX_split_join (
	clk,
	reset,
	split_valid,
	sjoin_valid,
	wid,
	split,
	sjoin,
	stack_wid,
	join_valid,
	join_is_dvg,
	join_is_else,
	join_wid,
	join_tmask,
	join_pc,
	stack_ptr
);
	parameter INSTANCE_ID = "";
	parameter OUT_REG = 0;
	input wire clk;
	input wire reset;
	input wire split_valid;
	input wire sjoin_valid;
	localparam VX_gpu_pkg_NW_BITS = 2;
	localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
	input wire [1:0] wid;
	localparam VX_gpu_pkg_PC_BITS = 32;
	input wire [40:0] split;
	localparam VX_gpu_pkg_DV_STACK_SIZE = 3;
	localparam VX_gpu_pkg_DV_STACK_SIZEW = 2;
	input wire [5:0] sjoin;
	input wire [1:0] stack_wid;
	output wire join_valid;
	output wire join_is_dvg;
	output wire join_is_else;
	output wire [1:0] join_wid;
	output wire [3:0] join_tmask;
	output wire [31:0] join_pc;
	output wire [1:0] stack_ptr;
	localparam VX_gpu_pkg_NT_BITS = 2;
	generate
		if (1) begin : g_enable
			wire [7:0] ipdom_wr_ptr;
			wire [3:0] orig_tmask;
			wire [31:0] next_pc;
			wire ipdom_idx;
			wire [35:0] ipdom_val = {split[39-:4] | split[35-:4], split[31-:VX_gpu_pkg_PC_BITS]};
			wire sjoin_is_dvg = sjoin[1-:VX_gpu_pkg_DV_STACK_SIZEW] != ipdom_wr_ptr[wid * 2+:2];
			VX_ipdom_stack #(
				.WIDTH(36),
				.DEPTH(VX_gpu_pkg_DV_STACK_SIZE)
			) ipdom_stack(
				.clk(clk),
				.reset(reset),
				.wid(wid),
				.d_val(ipdom_val),
				.push(split_valid && split[40]),
				.pop(sjoin_valid && sjoin_is_dvg),
				.rd_ptr(sjoin[1-:VX_gpu_pkg_DV_STACK_SIZEW]),
				.q_val({orig_tmask, next_pc}),
				.q_idx(ipdom_idx),
				.wr_ptr(ipdom_wr_ptr),
				.empty(),
				.full()
			);
			wire [3:0] join_tmask_n = (ipdom_idx ? orig_tmask : ~sjoin[5-:4] & orig_tmask);
			VX_pipe_register #(
				.DATAW(41),
				.RESETW(1),
				.DEPTH(OUT_REG)
			) pipe_reg(
				.clk(clk),
				.reset(reset),
				.enable(1'b1),
				.data_in({sjoin_valid, wid, sjoin_is_dvg, ~ipdom_idx, join_tmask_n, next_pc}),
				.data_out({join_valid, join_wid, join_is_dvg, join_is_else, join_tmask, join_pc})
			);
			assign stack_ptr = ipdom_wr_ptr[stack_wid * 2+:2];
		end
	endgenerate
endmodule
module VX_uop_packld (
	clk,
	reset,
	ibuf_in,
	ibuf_out,
	start,
	advance,
	uop_idx,
	uop_count
);
	reg _sv2v_0;
	input clk;
	input reset;
	localparam VX_gpu_pkg_XLENB = 4;
	localparam VX_gpu_pkg_XLENB_W = 2;
	localparam VX_gpu_pkg_BYTESEL_BITS = 4;
	localparam VX_gpu_pkg_EX_SFU = 2;
	localparam VX_gpu_pkg_EX_FPU = 3;
	localparam VX_gpu_pkg_EX_TCU = 3;
	localparam VX_gpu_pkg_NUM_EX_UNITS = 4;
	localparam VX_gpu_pkg_EX_BITS = 2;
	localparam VX_gpu_pkg_INST_OP_BITS = 4;
	localparam VX_gpu_pkg_NUM_CTA_MAX = 4;
	localparam VX_gpu_pkg_NCTA_BITS = 2;
	localparam VX_gpu_pkg_NCTA_WIDTH = VX_gpu_pkg_NCTA_BITS;
	localparam VX_gpu_pkg_REG_TYPES = 2;
	localparam VX_gpu_pkg_RV_REGS = 32;
	localparam VX_gpu_pkg_NUM_REGS = 64;
	localparam VX_gpu_pkg_NUM_REGS_BITS = 6;
	localparam VX_gpu_pkg_NUM_SRC_OPDS = 3;
	localparam VX_gpu_pkg_NUM_XREGS = 2;
	localparam VX_gpu_pkg_NW_BITS = 2;
	localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
	localparam VX_gpu_pkg_PC_BITS = 32;
	localparam VX_gpu_pkg_UUID_WIDTH = 44;
	localparam VX_gpu_pkg_ALU_TYPE_BITS = 2;
	localparam VX_gpu_pkg_INST_ARGS_BITS = 25;
	localparam VX_gpu_pkg_INST_FMT_BITS = 2;
	localparam VX_gpu_pkg_INST_FRM_BITS = 3;
	input wire [152:0] ibuf_in;
	output wire [152:0] ibuf_out;
	input wire start;
	input wire advance;
	localparam VX_gpu_pkg_UOP_CTR_W = 8;
	input wire [7:0] uop_idx;
	output wire [7:0] uop_count;
	wire is_packlh = ibuf_in[53-:2] == 2'b10;
	assign uop_count = (is_packlh ? 8'sd2 : 8'sd4);
	wire [1:0] idx2 = uop_idx[1:0];
	wire [1:0] byte_size = (is_packlh ? 1'sb1 : 1'sb0);
	function automatic [1:0] sv2v_cast_2;
		input reg [1:0] inp;
		sv2v_cast_2 = inp;
	endfunction
	wire [1:0] byte_off = (is_packlh ? sv2v_cast_2({idx2[0], 1'b0}) : idx2);
	reg [152:0] ibuf_r;
	always @(*) begin
		if (_sv2v_0)
			;
		ibuf_r = ibuf_in;
		ibuf_r[49-:12] = {10'd0, idx2};
		ibuf_r[23-:4] = {byte_size, byte_off};
	end
	assign ibuf_out = ibuf_r;
	initial _sv2v_0 = 0;
endmodule
module VX_uuid_gen (
	clk,
	reset,
	incr,
	wid,
	uuid
);
	parameter CORE_ID = 0;
	input wire clk;
	input wire reset;
	input wire incr;
	localparam VX_gpu_pkg_NW_BITS = 2;
	localparam VX_gpu_pkg_NW_WIDTH = VX_gpu_pkg_NW_BITS;
	input wire [1:0] wid;
	localparam VX_gpu_pkg_UUID_WIDTH = 44;
	output wire [43:0] uuid;
	localparam GNW_WIDTH = 12;
	reg [31:0] uuid_cntrs [0:3];
	reg [3:0] has_uuid_cntrs;
	always @(posedge clk) begin
		if (reset)
			has_uuid_cntrs <= 1'sb0;
		else if (incr)
			has_uuid_cntrs[wid] <= 1;
		if (incr)
			uuid_cntrs[wid] <= (has_uuid_cntrs[wid] ? uuid_cntrs[wid] + 1 : 1);
	end
	function automatic signed [11:0] sv2v_cast_12_signed;
		input reg signed [11:0] inp;
		sv2v_cast_12_signed = inp;
	endfunction
	function automatic [11:0] sv2v_cast_12;
		input reg [11:0] inp;
		sv2v_cast_12 = inp;
	endfunction
	wire [11:0] g_wid = (sv2v_cast_12_signed(CORE_ID) << VX_gpu_pkg_NW_BITS) + sv2v_cast_12(wid);
	assign uuid = {g_wid, (has_uuid_cntrs[wid] ? uuid_cntrs[wid] : 0)};
endmodule
module VX_fcvt_unit (
	clk,
	reset,
	enable,
	mask,
	frm,
	is_itof,
	is_ftoi,
	is_f2f,
	is_signed,
	is_int64,
	src_fmt,
	dst_fmt,
	dataa,
	result,
	fflags
);
	reg _sv2v_0;
	parameter LATENCY = 5;
	parameter FLEN = 32;
	parameter OUT_REG = 0;
	input wire clk;
	input wire reset;
	input wire enable;
	input wire mask;
	localparam VX_gpu_pkg_INST_FRM_BITS = 3;
	input wire [2:0] frm;
	input wire is_itof;
	input wire is_ftoi;
	input wire is_f2f;
	input wire is_signed;
	input wire is_int64;
	input wire src_fmt;
	input wire dst_fmt;
	input wire [31:0] dataa;
	output wire [31:0] result;
	output wire [4:0] fflags;
	localparam F32_EXP = 8;
	localparam F32_MAN = 23;
	localparam F32_BIAS = 127;
	localparam F64_EXP = 11;
	localparam F64_MAN = 52;
	localparam F64_BIAS = 1023;
	localparam HAS_D = FLEN >= 64;
	localparam SUPER_MAN = (HAS_D ? F64_MAN : F32_MAN);
	localparam SUPER_EXP = (HAS_D ? F64_EXP : F32_EXP);
	localparam S_MAN_WIDTH = ((1 + SUPER_MAN) > 32 ? 1 + SUPER_MAN : 32);
	localparam S_EXP_WIDTH = (5 > (SUPER_EXP + 2) ? 5 : SUPER_EXP + 2) + 2;
	localparam LZC_RESULT_WIDTH = $clog2(S_MAN_WIDTH);
	wire src_is_d = HAS_D & src_fmt;
	wire dst_is_d = HAS_D & dst_fmt;
	wire f2f = HAS_D & is_f2f;
	reg [LATENCY - 1:0] mask_pipe;
	always @(posedge clk)
		if (reset)
			mask_pipe <= 1'sb0;
		else if (enable)
			mask_pipe <= {mask_pipe[LATENCY - 2:0], mask};
	localparam STG2_CYC = LATENCY - 5;
	wire stg2_mask = (STG2_CYC == 0 ? mask : mask_pipe[STG2_CYC - 1]);
	function automatic [63:0] sv2v_cast_64;
		input reg [63:0] inp;
		sv2v_cast_64 = inp;
	endfunction
	wire [63:0] safe_dataa = sv2v_cast_64(dataa);
	wire input_fp_sgn = (src_is_d ? safe_dataa[63] : safe_dataa[31]);
	wire [6:0] fclass32;
	VX_fp_classifier #(
		.EXP_BITS(F32_EXP),
		.MAN_BITS(F32_MAN)
	) fp_classifier32(
		.exp_i(safe_dataa[F32_MAN+:F32_EXP]),
		.man_i(safe_dataa[22:0]),
		.clss_o(fclass32)
	);
	wire [6:0] fclass;
	generate
		if (HAS_D) begin : g_classify_d
			wire [6:0] fclass64;
			VX_fp_classifier #(
				.EXP_BITS(F64_EXP),
				.MAN_BITS(F64_MAN)
			) fp_classifier64(
				.exp_i(safe_dataa[F64_MAN+:F64_EXP]),
				.man_i(safe_dataa[51:0]),
				.clss_o(fclass64)
			);
			assign fclass = (src_is_d ? fclass64 : fclass32);
		end
		else begin : g_classify_s
			assign fclass = fclass32;
		end
	endgenerate
	function automatic [S_MAN_WIDTH - 1:0] sv2v_cast_84ECA;
		input reg [S_MAN_WIDTH - 1:0] inp;
		sv2v_cast_84ECA = inp;
	endfunction
	wire [S_MAN_WIDTH - 1:0] fp_unpacked_mant = (src_is_d ? sv2v_cast_84ECA({fclass[6], safe_dataa[51:0]}) : sv2v_cast_84ECA({fclass[6], safe_dataa[22:0]}));
	function automatic signed [S_EXP_WIDTH - 1:0] sv2v_cast_45C94_signed;
		input reg signed [S_EXP_WIDTH - 1:0] inp;
		sv2v_cast_45C94_signed = inp;
	endfunction
	wire signed [S_EXP_WIDTH - 1:0] src_bias_s = (src_is_d ? sv2v_cast_45C94_signed(F64_BIAS) : sv2v_cast_45C94_signed(F32_BIAS));
	wire [SUPER_EXP - 1:0] src_exp_raw;
	function automatic [SUPER_EXP - 1:0] sv2v_cast_A3A09;
		input reg [SUPER_EXP - 1:0] inp;
		sv2v_cast_A3A09 = inp;
	endfunction
	generate
		if (HAS_D) begin : g_srcexp_d
			assign src_exp_raw = (src_is_d ? safe_dataa[F64_MAN+:F64_EXP] : sv2v_cast_A3A09(safe_dataa[F32_MAN+:F32_EXP]));
		end
		else begin : g_srcexp_s
			assign src_exp_raw = safe_dataa[F32_MAN+:F32_EXP];
		end
	endgenerate
	wire i_sign = safe_dataa[(is_int64 ? 31 : 31)] && is_signed;
	wire [31:0] i_mag_raw = (i_sign ? -dataa : dataa);
	wire [31:0] i_mag = (is_int64 ? i_mag_raw : i_mag_raw[31:0]);
	reg [S_MAN_WIDTH - 1:0] unpacked_mant_s0;
	reg signed [S_EXP_WIDTH - 1:0] unpacked_exp_s0;
	wire input_sign_s0 = (is_itof ? i_sign : input_fp_sgn);
	function automatic [S_EXP_WIDTH - 1:0] sv2v_cast_45C94;
		input reg [S_EXP_WIDTH - 1:0] inp;
		sv2v_cast_45C94 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		if (is_itof) begin
			unpacked_mant_s0 = sv2v_cast_84ECA(i_mag);
			unpacked_exp_s0 = sv2v_cast_45C94_signed(31);
		end
		else begin
			unpacked_mant_s0 = fp_unpacked_mant;
			unpacked_exp_s0 = (sv2v_cast_45C94(src_exp_raw) - src_bias_s) + sv2v_cast_45C94({1'b0, fclass[4]});
		end
	end
	wire is_itof_s1;
	wire is_ftoi_s1;
	wire is_f2f_s1;
	wire is_signed_s1;
	wire is_int64_s1;
	wire input_sign_s1;
	wire src_d_s1;
	wire dst_d_s1;
	wire [2:0] frm_s1;
	wire [6:0] fclass_s1;
	wire [S_MAN_WIDTH - 1:0] unpacked_mant_s1;
	wire signed [S_EXP_WIDTH - 1:0] unpacked_exp_s1;
	VX_pipe_register #(
		.DATAW((18 + S_MAN_WIDTH) + S_EXP_WIDTH),
		.DEPTH(LATENCY > 5)
	) pipe_reg1(
		.clk(clk),
		.reset(reset),
		.enable(enable && mask),
		.data_in({is_itof, is_ftoi, f2f, is_signed, is_int64, src_is_d, dst_is_d, input_sign_s0, frm, fclass, unpacked_mant_s0, unpacked_exp_s0}),
		.data_out({is_itof_s1, is_ftoi_s1, is_f2f_s1, is_signed_s1, is_int64_s1, src_d_s1, dst_d_s1, input_sign_s1, frm_s1, fclass_s1, unpacked_mant_s1, unpacked_exp_s1})
	);
	wire [LZC_RESULT_WIDTH - 1:0] renorm_shamt_s1;
	wire mant_is_nonzero_s1;
	VX_lzc #(.N(S_MAN_WIDTH)) lzc(
		.data_in(unpacked_mant_s1),
		.data_out(renorm_shamt_s1),
		.valid_out(mant_is_nonzero_s1)
	);
	wire mant_is_zero_s1 = ~mant_is_nonzero_s1;
	wire is_itof_s2;
	wire is_ftoi_s2;
	wire is_f2f_s2;
	wire is_signed_s2;
	wire is_int64_s2;
	wire input_sign_s2;
	wire mant_is_zero_s2;
	wire src_d_s2;
	wire dst_d_s2;
	wire [2:0] frm_s2;
	wire [6:0] fclass_s2;
	wire [S_MAN_WIDTH - 1:0] unpacked_mant_s2;
	wire signed [S_EXP_WIDTH - 1:0] unpacked_exp_s2;
	wire [LZC_RESULT_WIDTH - 1:0] renorm_shamt_s2;
	VX_pipe_register #(
		.DATAW(((19 + S_MAN_WIDTH) + S_EXP_WIDTH) + LZC_RESULT_WIDTH),
		.DEPTH(LATENCY > 4)
	) pipe_reg2(
		.clk(clk),
		.reset(reset),
		.enable(enable && stg2_mask),
		.data_in({is_itof_s1, is_ftoi_s1, is_f2f_s1, is_signed_s1, is_int64_s1, input_sign_s1, mant_is_zero_s1, src_d_s1, dst_d_s1, frm_s1, fclass_s1, unpacked_mant_s1, unpacked_exp_s1, renorm_shamt_s1}),
		.data_out({is_itof_s2, is_ftoi_s2, is_f2f_s2, is_signed_s2, is_int64_s2, input_sign_s2, mant_is_zero_s2, src_d_s2, dst_d_s2, frm_s2, fclass_s2, unpacked_mant_s2, unpacked_exp_s2, renorm_shamt_s2})
	);
	wire [S_EXP_WIDTH - 1:0] fp_mant_offset_s2 = sv2v_cast_45C94_signed(S_MAN_WIDTH - 1) - (src_d_s2 ? sv2v_cast_45C94_signed(F64_MAN) : sv2v_cast_45C94_signed(F32_MAN));
	wire [S_MAN_WIDTH - 1:0] norm_mant_s2 = unpacked_mant_s2 << renorm_shamt_s2;
	wire signed [S_EXP_WIDTH - 1:0] norm_exp_s2 = (unpacked_exp_s2 - sv2v_cast_45C94({1'b0, renorm_shamt_s2})) + (is_itof_s2 ? sv2v_cast_45C94_signed(0) : fp_mant_offset_s2);
	wire is_itof_s3;
	wire is_ftoi_s3;
	wire is_f2f_s3;
	wire is_signed_s3;
	wire is_int64_s3;
	wire input_sign_s3;
	wire mant_is_zero_s3;
	wire src_d_s3;
	wire dst_d_s3;
	wire [2:0] frm_s3;
	wire [6:0] fclass_s3;
	wire [S_MAN_WIDTH - 1:0] norm_mant_s3;
	wire signed [S_EXP_WIDTH - 1:0] norm_exp_s3;
	wire signed [S_EXP_WIDTH - 1:0] unpacked_exp_s3;
	VX_pipe_register #(
		.DATAW((19 + S_MAN_WIDTH) + (2 * S_EXP_WIDTH)),
		.DEPTH(LATENCY > 3)
	) pipe_reg3(
		.clk(clk),
		.reset(reset),
		.enable(enable && mask_pipe[LATENCY - 5]),
		.data_in({is_itof_s2, is_ftoi_s2, is_f2f_s2, is_signed_s2, is_int64_s2, input_sign_s2, mant_is_zero_s2, src_d_s2, dst_d_s2, frm_s2, fclass_s2, norm_mant_s2, norm_exp_s2, unpacked_exp_s2}),
		.data_out({is_itof_s3, is_ftoi_s3, is_f2f_s3, is_signed_s3, is_int64_s3, input_sign_s3, mant_is_zero_s3, src_d_s3, dst_d_s3, frm_s3, fclass_s3, norm_mant_s3, norm_exp_s3, unpacked_exp_s3})
	);
	wire signed [S_EXP_WIDTH - 1:0] f2i_shamt_s3 = sv2v_cast_45C94_signed(S_MAN_WIDTH - 1) - unpacked_exp_s3;
	wire signed [S_EXP_WIDTH - 1:0] dst_bias_s3 = (dst_d_s3 ? sv2v_cast_45C94_signed(F64_BIAS) : sv2v_cast_45C94_signed(F32_BIAS));
	wire signed [S_EXP_WIDTH - 1:0] dst_exp_s3 = norm_exp_s3 + dst_bias_s3;
	wire f2f_narrow_s3 = (((is_f2f_s3 & ~dst_d_s3) & ~fclass_s3[2]) & ~fclass_s3[3]) & ~fclass_s3[5];
	wire f2f_uf_s3 = f2f_narrow_s3 & (dst_exp_s3 <= 0);
	wire f2f_of_s3 = f2f_narrow_s3 & (dst_exp_s3 >= sv2v_cast_45C94_signed(255));
	wire signed [S_EXP_WIDTH - 1:0] denorm_sh_s3 = sv2v_cast_45C94_signed(1) - dst_exp_s3;
	reg [S_EXP_WIDTH - 1:0] align_shamt_s3;
	always @(*) begin
		if (_sv2v_0)
			;
		if (is_ftoi_s3)
			align_shamt_s3 = (f2i_shamt_s3 > sv2v_cast_45C94_signed(S_MAN_WIDTH + 1) ? sv2v_cast_45C94_signed(S_MAN_WIDTH + 1) : (f2i_shamt_s3 < 0 ? {S_EXP_WIDTH {1'sb0}} : f2i_shamt_s3));
		else if (f2f_uf_s3)
			align_shamt_s3 = (denorm_sh_s3 > sv2v_cast_45C94_signed(S_MAN_WIDTH + 1) ? sv2v_cast_45C94_signed(S_MAN_WIDTH + 1) : denorm_sh_s3);
		else
			align_shamt_s3 = 1'sb0;
	end
	function automatic signed [SUPER_EXP - 1:0] sv2v_cast_A3A09_signed;
		input reg signed [SUPER_EXP - 1:0] inp;
		sv2v_cast_A3A09_signed = inp;
	endfunction
	wire [SUPER_EXP - 1:0] final_exp_s3 = sv2v_cast_A3A09_signed(dst_exp_s3);
	wire is_itof_s4;
	wire is_ftoi_s4;
	wire is_f2f_s4;
	wire is_signed_s4;
	wire is_int64_s4;
	wire input_sign_s4;
	wire mant_is_zero_s4;
	wire src_d_s4;
	wire dst_d_s4;
	wire f2f_uf_s4;
	wire f2f_of_s4;
	wire [2:0] frm_s4;
	wire [6:0] fclass_s4;
	wire [S_MAN_WIDTH - 1:0] norm_mant_s4;
	wire [S_EXP_WIDTH - 1:0] align_shamt_s4;
	wire [SUPER_EXP - 1:0] final_exp_s4;
	VX_pipe_register #(
		.DATAW(((21 + S_MAN_WIDTH) + S_EXP_WIDTH) + SUPER_EXP),
		.DEPTH(LATENCY > 2)
	) pipe_reg4(
		.clk(clk),
		.reset(reset),
		.enable(enable && mask_pipe[LATENCY - 4]),
		.data_in({is_itof_s3, is_ftoi_s3, is_f2f_s3, is_signed_s3, is_int64_s3, input_sign_s3, mant_is_zero_s3, src_d_s3, dst_d_s3, f2f_uf_s3, f2f_of_s3, frm_s3, fclass_s3, norm_mant_s3, align_shamt_s3, final_exp_s3}),
		.data_out({is_itof_s4, is_ftoi_s4, is_f2f_s4, is_signed_s4, is_int64_s4, input_sign_s4, mant_is_zero_s4, src_d_s4, dst_d_s4, f2f_uf_s4, f2f_of_s4, frm_s4, fclass_s4, norm_mant_s4, align_shamt_s4, final_exp_s4})
	);
	wire [2 * S_MAN_WIDTH:0] aligned_mant_full_s4 = {norm_mant_s4, {S_MAN_WIDTH + 1 {1'b0}}} >> align_shamt_s4;
	wire [S_MAN_WIDTH - 1:0] aligned_mant_s4 = aligned_mant_full_s4[2 * S_MAN_WIDTH:S_MAN_WIDTH + 1];
	wire guard_bit_s4 = aligned_mant_full_s4[S_MAN_WIDTH];
	wire round_bit_s4 = aligned_mant_full_s4[S_MAN_WIDTH - 1];
	wire sticky_bit_s4 = |aligned_mant_full_s4[S_MAN_WIDTH - 2:0];
	function automatic signed [5:0] sv2v_cast_6_signed;
		input reg signed [5:0] inp;
		sv2v_cast_6_signed = inp;
	endfunction
	wire [5:0] dst_man_w_s4 = (dst_d_s4 ? sv2v_cast_6_signed(F64_MAN) : sv2v_cast_6_signed(F32_MAN));
	function automatic signed [6:0] sv2v_cast_7_signed;
		input reg signed [6:0] inp;
		sv2v_cast_7_signed = inp;
	endfunction
	function automatic [6:0] sv2v_cast_7;
		input reg [6:0] inp;
		sv2v_cast_7 = inp;
	endfunction
	wire [6:0] fp_trunc_sh_s4 = sv2v_cast_7_signed(S_MAN_WIDTH - 1) - sv2v_cast_7(dst_man_w_s4);
	wire [S_MAN_WIDTH - 1:0] fp_trunc_s4 = aligned_mant_s4 >> fp_trunc_sh_s4;
	function automatic [LZC_RESULT_WIDTH - 1:0] sv2v_cast_45A10;
		input reg [LZC_RESULT_WIDTH - 1:0] inp;
		sv2v_cast_45A10 = inp;
	endfunction
	wire fp_guard_s4 = aligned_mant_s4[sv2v_cast_45A10(fp_trunc_sh_s4 - 7'd1)];
	function automatic signed [S_MAN_WIDTH - 1:0] sv2v_cast_84ECA_signed;
		input reg signed [S_MAN_WIDTH - 1:0] inp;
		sv2v_cast_84ECA_signed = inp;
	endfunction
	wire [S_MAN_WIDTH - 1:0] fp_sticky_mask_s4 = (sv2v_cast_84ECA_signed(1) << (fp_trunc_sh_s4 - 7'd1)) - 1;
	wire sticky_red_s4 = ((|(aligned_mant_s4 & fp_sticky_mask_s4) | guard_bit_s4) | round_bit_s4) | sticky_bit_s4;
	reg [1:0] round_sticky_bits_s4;
	reg [S_MAN_WIDTH - 1:0] pre_round_abs_s4;
	always @(*) begin
		if (_sv2v_0)
			;
		if (is_ftoi_s4) begin
			round_sticky_bits_s4 = {round_bit_s4, sticky_bit_s4};
			pre_round_abs_s4 = aligned_mant_s4;
		end
		else begin
			round_sticky_bits_s4 = {fp_guard_s4, sticky_red_s4};
			pre_round_abs_s4 = fp_trunc_s4;
		end
	end
	wire is_itof_s5;
	wire is_ftoi_s5;
	wire is_f2f_s5;
	wire is_signed_s5;
	wire is_int64_s5;
	wire input_sign_s5;
	wire mant_is_zero_s5;
	wire src_d_s5;
	wire dst_d_s5;
	wire f2f_uf_s5;
	wire f2f_of_s5;
	wire [2:0] frm_s5;
	wire [6:0] fclass_s5;
	wire [1:0] round_sticky_bits_s5;
	wire [S_MAN_WIDTH - 1:0] pre_round_abs_s5;
	wire [SUPER_EXP - 1:0] final_exp_s5;
	VX_pipe_register #(
		.DATAW((23 + S_MAN_WIDTH) + SUPER_EXP),
		.DEPTH(LATENCY > 1)
	) pipe_reg5(
		.clk(clk),
		.reset(reset),
		.enable(enable && mask_pipe[LATENCY - 3]),
		.data_in({is_itof_s4, is_ftoi_s4, is_f2f_s4, is_signed_s4, is_int64_s4, input_sign_s4, mant_is_zero_s4, src_d_s4, dst_d_s4, f2f_uf_s4, f2f_of_s4, frm_s4, fclass_s4, round_sticky_bits_s4, pre_round_abs_s4, final_exp_s4}),
		.data_out({is_itof_s5, is_ftoi_s5, is_f2f_s5, is_signed_s5, is_int64_s5, input_sign_s5, mant_is_zero_s5, src_d_s5, dst_d_s5, f2f_uf_s5, f2f_of_s5, frm_s5, fclass_s5, round_sticky_bits_s5, pre_round_abs_s5, final_exp_s5})
	);
	wire [S_MAN_WIDTH - 1:0] rounded_abs_s5;
	wire rounded_sign_s5;
	VX_fp_rounding #(.DAT_WIDTH(S_MAN_WIDTH)) fp_rounding(
		.abs_value_i(pre_round_abs_s5),
		.sign_i(input_sign_s5),
		.round_sticky_bits_i(round_sticky_bits_s5),
		.rnd_mode_i(frm_s5),
		.effective_subtraction_i(1'b0),
		.abs_rounded_o(rounded_abs_s5),
		.sign_o(rounded_sign_s5),
		.exact_zero_o()
	);
	wire [63:0] safe_rounded_abs = sv2v_cast_64(rounded_abs_s5);
	function automatic [15:0] sv2v_cast_16;
		input reg [15:0] inp;
		sv2v_cast_16 = inp;
	endfunction
	wire [15:0] final_exp_16 = sv2v_cast_16(final_exp_s5);
	wire [15:0] safe_dst_exp = (mant_is_zero_s5 | f2f_uf_s5 ? 16'h0000 : final_exp_16);
	wire [63:0] abs_xlen_64 = sv2v_cast_64(rounded_abs_s5[31:0]);
	wire [63:0] safe_int_res = (rounded_sign_s5 ? -abs_xlen_64 : abs_xlen_64);
	wire [31:0] int_32_res = safe_int_res[31:0];
	wire [63:0] int_64_res = safe_int_res;
	wire f32_man_ovf = rounded_abs_s5[24];
	function automatic [7:0] sv2v_cast_8;
		input reg [7:0] inp;
		sv2v_cast_8 = inp;
	endfunction
	wire [7:0] fp32_exp = safe_dst_exp[7:0] + sv2v_cast_8(f32_man_ovf);
	wire [22:0] fp32_man = (f32_man_ovf ? {23 {1'sb0}} : safe_rounded_abs[22:0]);
	wire [31:0] fp_32_res = {rounded_sign_s5, fp32_exp, fp32_man};
	wire [31:0] f32_boxed = fp_32_res;
	wire [31:0] fp_dst_res;
	wire f2f_nv_s5;
	wire f2f_nx_s5;
	function automatic [10:0] sv2v_cast_11;
		input reg [10:0] inp;
		sv2v_cast_11 = inp;
	endfunction
	function automatic [31:0] sv2v_cast_32;
		input reg [31:0] inp;
		sv2v_cast_32 = inp;
	endfunction
	generate
		if (HAS_D) begin : g_fp_pack_d
			wire f64_man_ovf = rounded_abs_s5[53];
			wire [10:0] fp64_exp = safe_dst_exp[10:0] + sv2v_cast_11(f64_man_ovf);
			wire [51:0] fp64_man = (f64_man_ovf ? {52 {1'sb0}} : safe_rounded_abs[51:0]);
			wire [63:0] fp_64_res = {rounded_sign_s5, fp64_exp, fp64_man};
			wire [31:0] f2f_qnan_32 = 32'h7fc00000;
			wire [31:0] f2f_inf_32 = {rounded_sign_s5, 31'h7f800000};
			wire [63:0] f2f_qnan_64 = 64'h7ff8000000000000;
			wire [63:0] f2f_inf_64 = {rounded_sign_s5, 63'h7ff0000000000000};
			wire [63:0] f2f_zero_64 = {input_sign_s5, 63'd0};
			wire [31:0] normal_dst = (dst_d_s5 ? sv2v_cast_32(fp_64_res) : f32_boxed);
			wire is_nan_src = is_f2f_s5 & fclass_s5[2];
			wire is_inf_src = is_f2f_s5 & fclass_s5[3];
			wire is_zero_src = is_f2f_s5 & fclass_s5[5];
			reg [31:0] dst_r;
			always @(*) begin
				if (_sv2v_0)
					;
				if (is_nan_src)
					dst_r = (dst_d_s5 ? sv2v_cast_32(f2f_qnan_64) : f2f_qnan_32);
				else if (is_inf_src)
					dst_r = (dst_d_s5 ? sv2v_cast_32(f2f_inf_64) : f2f_inf_32);
				else if (is_zero_src)
					dst_r = (dst_d_s5 ? sv2v_cast_32(f2f_zero_64) : sv2v_cast_32({input_sign_s5, 31'd0}));
				else if (f2f_of_s5)
					dst_r = f2f_inf_32;
				else
					dst_r = normal_dst;
			end
			assign fp_dst_res = dst_r;
			assign f2f_nv_s5 = is_f2f_s5 & fclass_s5[0];
			assign f2f_nx_s5 = (((is_f2f_s5 & ~fclass_s5[2]) & ~fclass_s5[3]) & ~fclass_s5[5]) & |round_sticky_bits_s5;
		end
		else begin : g_fp_pack_s
			assign fp_dst_res = f32_boxed;
			assign f2f_nv_s5 = 1'b0;
			assign f2f_nx_s5 = 1'b0;
		end
	endgenerate
	wire use_neg_sat_s5 = fclass_s5[3] && input_sign_s5;
	wire [31:0] nan_inf_32 = (use_neg_sat_s5 ? (is_signed_s5 ? 32'h80000000 : 32'h00000000) : (is_signed_s5 ? 32'h7fffffff : 32'hffffffff));
	wire [63:0] nan_inf_64 = (use_neg_sat_s5 ? (is_signed_s5 ? 64'h8000000000000000 : 64'h0000000000000000) : (is_signed_s5 ? 64'h7fffffffffffffff : 64'hffffffffffffffff));
	wire f2i_s32_pos_ovf = ((is_signed_s5 && !is_int64_s5) && !input_sign_s5) && |rounded_abs_s5[S_MAN_WIDTH - 1:31];
	wire f2i_s32_neg_ovf = ((is_signed_s5 && !is_int64_s5) && input_sign_s5) && (rounded_abs_s5 > sv2v_cast_84ECA(32'h80000000));
	wire f2i_u32_neg_ovf = ((!is_signed_s5 && !is_int64_s5) && rounded_sign_s5) && |rounded_abs_s5;
	wire f2i_s64_pos_ovf;
	wire f2i_s64_neg_ovf;
	wire f2i_u64_neg_ovf;
	generate
		if (1) begin : g_f2i_no64ovf
			assign f2i_s64_pos_ovf = 1'b0;
			assign f2i_s64_neg_ovf = 1'b0;
			assign f2i_u64_neg_ovf = 1'b0;
		end
	endgenerate
	reg [63:0] res_val_64;
	reg [31:0] res_val_32;
	reg [4:0] final_fflags_s5;
	always @(*) begin
		if (_sv2v_0)
			;
		final_fflags_s5 = 1'sb0;
		res_val_64 = 1'sb0;
		res_val_32 = 1'sb0;
		if (is_ftoi_s5) begin
			if (fclass_s5[2] || fclass_s5[3]) begin
				final_fflags_s5[4] = 1'b1;
				res_val_64 = (is_int64_s5 ? nan_inf_64 : {{32 {nan_inf_32[31]}}, nan_inf_32});
				res_val_32 = nan_inf_32;
			end
			else if (f2i_s32_pos_ovf) begin
				final_fflags_s5[4] = 1'b1;
				res_val_64 = 64'h000000007fffffff;
				res_val_32 = 32'h7fffffff;
			end
			else if (f2i_s32_neg_ovf) begin
				final_fflags_s5[4] = 1'b1;
				res_val_64 = {{32 {1'b1}}, 32'h80000000};
				res_val_32 = 32'h80000000;
			end
			else if (f2i_u32_neg_ovf) begin
				final_fflags_s5[4] = 1'b1;
				res_val_64 = 1'sb0;
				res_val_32 = 1'sb0;
			end
			else if (f2i_s64_pos_ovf) begin
				final_fflags_s5[4] = 1'b1;
				res_val_64 = 64'h7fffffffffffffff;
				res_val_32 = 32'h7fffffff;
			end
			else if (f2i_s64_neg_ovf) begin
				final_fflags_s5[4] = 1'b1;
				res_val_64 = 64'h8000000000000000;
				res_val_32 = 32'h80000000;
			end
			else if (f2i_u64_neg_ovf) begin
				final_fflags_s5[4] = 1'b1;
				res_val_64 = 1'sb0;
				res_val_32 = 1'sb0;
			end
			else begin
				res_val_64 = (is_int64_s5 ? int_64_res : {{32 {int_32_res[31]}}, int_32_res});
				res_val_32 = int_32_res;
				final_fflags_s5[0] = |round_sticky_bits_s5;
			end
		end
		else begin
			res_val_64 = sv2v_cast_64(fp_dst_res);
			res_val_32 = fp_dst_res[31:0];
			final_fflags_s5[4] = f2f_nv_s5;
			final_fflags_s5[2] = f2f_of_s5;
			final_fflags_s5[1] = f2f_uf_s5 & |round_sticky_bits_s5;
			final_fflags_s5[0] = (is_f2f_s5 ? (f2f_nx_s5 | f2f_of_s5) | (f2f_uf_s5 & |round_sticky_bits_s5) : |round_sticky_bits_s5);
		end
	end
	wire [31:0] final_result_s5;
	generate
		if (1) begin : g_out_x32
			assign final_result_s5 = res_val_32;
		end
	endgenerate
	VX_pipe_register #(
		.DATAW(37),
		.DEPTH(OUT_REG)
	) pipe_reg_out(
		.clk(clk),
		.reset(reset),
		.enable(enable && mask_pipe[LATENCY - 2]),
		.data_in({final_result_s5, final_fflags_s5}),
		.data_out({result, fflags})
	);
	initial _sv2v_0 = 0;
endmodule
module VX_fdivsqrt_unit (
	clk,
	reset,
	enable,
	mask,
	fmt,
	frm,
	dataa,
	datab,
	is_sqrt,
	result,
	fflags
);
	parameter LATENCY = 17;
	parameter FLEN = 32;
	input wire clk;
	input wire reset;
	input wire enable;
	input wire mask;
	localparam VX_gpu_pkg_INST_FMT_BITS = 2;
	input wire [1:0] fmt;
	localparam VX_gpu_pkg_INST_FRM_BITS = 3;
	input wire [2:0] frm;
	input wire [FLEN - 1:0] dataa;
	input wire [FLEN - 1:0] datab;
	input wire is_sqrt;
	output wire [FLEN - 1:0] result;
	output wire [4:0] fflags;
	localparam HAS_D = FLEN >= 64;
	wire is_d = (HAS_D ? fmt[0] : 1'b0);
	localparam SUPER_MAN = (HAS_D ? 52 : 23);
	localparam SUPER_SIG = SUPER_MAN + 1;
	localparam PRE_LATENCY = 1;
	localparam INI_LATENCY = 1;
	localparam CONV_LATENCY = 1;
	localparam NRM_LATENCY = 1;
	localparam SCALE_DIV = 5;
	localparam SCALE_SQRT = ((SUPER_SIG % 2) == 1 ? 5 : 4);
	localparam W_BITS = (SUPER_SIG + SCALE_DIV) + 1;
	localparam CS_BITS = W_BITS + 1;
	localparam NR_BITS = (SUPER_SIG + 2) + ((SUPER_SIG + 2) % 2);
	localparam NR_STAGES = NR_BITS / 2;
	localparam EXP_W = (HAS_D ? 14 : 10);
	localparam SQRT_LEAD = (SUPER_SIG + SCALE_SQRT) - 1;
	reg [LATENCY - 1:0] mask_pipe;
	always @(posedge clk)
		if (reset)
			mask_pipe <= 1'sb0;
		else if (enable)
			mask_pipe <= {mask_pipe[LATENCY - 2:0], mask};
	wire valid_ini = mask_pipe[0];
	wire valid_conv = mask_pipe[(2 + NR_STAGES) - 1];
	wire valid_nrm = mask_pipe[((2 + NR_STAGES) + CONV_LATENCY) - 1];
	localparam EXC_LO = 0;
	localparam FRM_LO = 5;
	localparam SGN_LO = 8;
	localparam EXP_LO = 9;
	localparam QI_LO = EXP_LO + EXP_W;
	localparam QB_LO = QI_LO + 1;
	localparam DS_LO = QB_LO + NR_BITS;
	localparam W_LO = DS_LO + W_BITS;
	localparam WC_LO = W_LO + CS_BITS;
	localparam NRO_LO = WC_LO + CS_BITS;
	localparam SQ_LO = NRO_LO + 1;
	localparam ISD_LO = SQ_LO + 1;
	localparam STAGE_W = ISD_LO + 1;
	function automatic signed [EXP_W - 1:0] sv2v_cast_6889D_signed;
		input reg signed [EXP_W - 1:0] inp;
		sv2v_cast_6889D_signed = inp;
	endfunction
	wire [EXP_W - 1:0] BIAS = (is_d ? sv2v_cast_6889D_signed(1023) : sv2v_cast_6889D_signed(127));
	wire s_a = (is_d ? dataa[FLEN - 1] : dataa[31]);
	wire s_b = (is_d ? datab[FLEN - 1] : datab[31]);
	wire ea_allones;
	wire eb_allones;
	wire ea_zero;
	wire eb_zero;
	wire ma_nz;
	wire mb_nz;
	wire ma_q;
	wire mb_q;
	wire [SUPER_SIG - 1:0] siga_ljn;
	wire [SUPER_SIG - 1:0] sigb_ljn;
	wire signed [EXP_W - 1:0] exp_a;
	wire signed [EXP_W - 1:0] exp_b;
	wire f32a_z = (dataa[30:23] == 8'd0) && (dataa[22:0] == 23'd0);
	wire f32a_sub = (dataa[30:23] == 8'd0) && (dataa[22:0] != 23'd0);
	wire f32b_z = (datab[30:23] == 8'd0) && (datab[22:0] == 23'd0);
	wire f32b_sub = (datab[30:23] == 8'd0) && (datab[22:0] != 23'd0);
	wire [23:0] f32a_sig = {~(f32a_z | f32a_sub), dataa[22:0]};
	wire [23:0] f32b_sig = {~(f32b_z | f32b_sub), datab[22:0]};
	wire [4:0] f32a_lzc;
	wire [4:0] f32b_lzc;
	wire f32a_lvld;
	wire f32b_lvld;
	VX_lzc #(.N(24)) lz_f32a(
		.data_in(f32a_sig),
		.data_out(f32a_lzc),
		.valid_out(f32a_lvld)
	);
	VX_lzc #(.N(24)) lz_f32b(
		.data_in(f32b_sig),
		.data_out(f32b_lzc),
		.valid_out(f32b_lvld)
	);
	wire [23:0] f32a_norm = (f32a_sub ? f32a_sig << f32a_lzc : f32a_sig);
	wire [23:0] f32b_norm = (f32b_sub ? f32b_sig << f32b_lzc : f32b_sig);
	function automatic [EXP_W - 1:0] sv2v_cast_6889D;
		input reg [EXP_W - 1:0] inp;
		sv2v_cast_6889D = inp;
	endfunction
	wire signed [EXP_W - 1:0] f32a_exp = (f32a_sub ? sv2v_cast_6889D_signed(1) - sv2v_cast_6889D(f32a_lzc) : (f32a_z ? {(EXP_W >= EXP_W ? EXP_W : EXP_W) {1'sb0}} : sv2v_cast_6889D(dataa[30:23])));
	wire signed [EXP_W - 1:0] f32b_exp = (f32b_sub ? sv2v_cast_6889D_signed(1) - sv2v_cast_6889D(f32b_lzc) : (f32b_z ? {(EXP_W >= EXP_W ? EXP_W : EXP_W) {1'sb0}} : sv2v_cast_6889D(datab[30:23])));
	generate
		if (HAS_D) begin : g_unpack_d
			wire f64a_z = (dataa[62:52] == 11'd0) && (dataa[51:0] == 52'd0);
			wire f64a_sub = (dataa[62:52] == 11'd0) && (dataa[51:0] != 52'd0);
			wire f64b_z = (datab[62:52] == 11'd0) && (datab[51:0] == 52'd0);
			wire f64b_sub = (datab[62:52] == 11'd0) && (datab[51:0] != 52'd0);
			wire [52:0] f64a_sig = {~(f64a_z | f64a_sub), dataa[51:0]};
			wire [52:0] f64b_sig = {~(f64b_z | f64b_sub), datab[51:0]};
			wire [5:0] f64a_lzc;
			wire [5:0] f64b_lzc;
			wire f64a_lvld;
			wire f64b_lvld;
			VX_lzc #(.N(53)) lz_f64a(
				.data_in(f64a_sig),
				.data_out(f64a_lzc),
				.valid_out(f64a_lvld)
			);
			VX_lzc #(.N(53)) lz_f64b(
				.data_in(f64b_sig),
				.data_out(f64b_lzc),
				.valid_out(f64b_lvld)
			);
			wire [52:0] f64a_norm = (f64a_sub ? f64a_sig << f64a_lzc : f64a_sig);
			wire [52:0] f64b_norm = (f64b_sub ? f64b_sig << f64b_lzc : f64b_sig);
			wire signed [EXP_W - 1:0] f64a_exp = (f64a_sub ? sv2v_cast_6889D_signed(1) - sv2v_cast_6889D(f64a_lzc) : (f64a_z ? {(EXP_W >= EXP_W ? EXP_W : EXP_W) {1'sb0}} : sv2v_cast_6889D(dataa[62:52])));
			wire signed [EXP_W - 1:0] f64b_exp = (f64b_sub ? sv2v_cast_6889D_signed(1) - sv2v_cast_6889D(f64b_lzc) : (f64b_z ? {(EXP_W >= EXP_W ? EXP_W : EXP_W) {1'sb0}} : sv2v_cast_6889D(datab[62:52])));
			assign ea_allones = (is_d ? &dataa[62:52] : &dataa[30:23]);
			assign eb_allones = (is_d ? &datab[62:52] : &datab[30:23]);
			assign ea_zero = (is_d ? f64a_z : f32a_z);
			assign eb_zero = (is_d ? f64b_z : f32b_z);
			assign ma_nz = (is_d ? |dataa[51:0] : |dataa[22:0]);
			assign mb_nz = (is_d ? |datab[51:0] : |datab[22:0]);
			assign ma_q = (is_d ? dataa[51] : dataa[22]);
			assign mb_q = (is_d ? datab[51] : datab[22]);
			assign siga_ljn = (is_d ? f64a_norm : {f32a_norm, {SUPER_SIG - 24 {1'b0}}});
			assign sigb_ljn = (is_d ? f64b_norm : {f32b_norm, {SUPER_SIG - 24 {1'b0}}});
			assign exp_a = (is_d ? f64a_exp : f32a_exp);
			assign exp_b = (is_d ? f64b_exp : f32b_exp);
		end
		else begin : g_unpack_s
			assign ea_allones = &dataa[30:23];
			assign eb_allones = &datab[30:23];
			assign ea_zero = f32a_z;
			assign eb_zero = f32b_z;
			assign ma_nz = |dataa[22:0];
			assign mb_nz = |datab[22:0];
			assign ma_q = dataa[22];
			assign mb_q = datab[22];
			assign siga_ljn = f32a_norm;
			assign sigb_ljn = f32b_norm;
			assign exp_a = f32a_exp;
			assign exp_b = f32b_exp;
		end
	endgenerate
	wire nan_a = ea_allones & ma_nz;
	wire nan_b = eb_allones & mb_nz;
	wire inf_a = ea_allones & ~ma_nz;
	wire inf_b = eb_allones & ~mb_nz;
	wire zero_a = ea_zero & ~ma_nz;
	wire zero_b = eb_zero & ~mb_nz;
	wire snan_a = nan_a & ~ma_q;
	wire snan_b = nan_b & ~mb_q;
	wire sign_r0_div = s_a ^ s_b;
	wire signed [EXP_W - 1:0] exp_r0_div = (exp_a - exp_b) + BIAS;
	wire nv0_div = ((snan_a | snan_b) | (zero_a & zero_b)) | (inf_a & inf_b);
	wire dz0_div = ((zero_b & ~nan_a) & ~nan_b) & ~zero_a;
	wire rnan_div = (nan_a | nan_b) | nv0_div;
	wire rinf_div = (inf_a | zero_b) & ~rnan_div;
	wire rzro_div = (zero_a | inf_b) & ~rnan_div;
	wire [4:0] exc0_div = {rnan_div, rinf_div, rzro_div, dz0_div, nv0_div};
	wire signed [EXP_W - 1:0] exp_r0_sqrt = ($signed(exp_a) + BIAS) >>> 1;
	wire nv0_sq = snan_a | ((s_a & ~nan_a) & ~zero_a);
	wire rnan_sq = nan_a | nv0_sq;
	wire rinf_sq = inf_a & ~rnan_sq;
	wire rzro_sq = zero_a & ~rnan_sq;
	wire [4:0] exc0_sq = {rnan_sq, rinf_sq, rzro_sq, 1'b0, nv0_sq};
	wire sign_r0_sq = zero_a & s_a;
	wire ea_lsb_sq;
	generate
		if (HAS_D) begin : g_ealsb_d
			assign ea_lsb_sq = (is_d ? dataa[52] : dataa[23]);
		end
		else begin : g_ealsb_s
			assign ea_lsb_sq = dataa[23];
		end
	endgenerate
	wire is_scale2_sq = ~ea_lsb_sq;
	wire [2:0] top3_man = siga_ljn[SUPER_SIG - 2-:3];
	wire nr_offset0_sq = is_scale2_sq & |top3_man;
	wire [SUPER_MAN - 1:0] man_a = siga_ljn[SUPER_MAN - 1:0];
	function automatic [W_BITS - 1:0] sv2v_cast_397C7;
		input reg [W_BITS - 1:0] inp;
		sv2v_cast_397C7 = inp;
	endfunction
	wire [W_BITS - 1:0] manSC1 = sv2v_cast_397C7(man_a) << (SCALE_SQRT + 1);
	function automatic signed [W_BITS - 1:0] sv2v_cast_397C7_signed;
		input reg signed [W_BITS - 1:0] inp;
		sv2v_cast_397C7_signed = inp;
	endfunction
	wire [W_BITS - 1:0] S0_sq = (nr_offset0_sq ? sv2v_cast_397C7_signed(3) << (SQRT_LEAD - 1) : sv2v_cast_397C7_signed(1) << SQRT_LEAD);
	wire [W_BITS - 1:0] W0_sq = (!is_scale2_sq ? sv2v_cast_397C7(man_a) << SCALE_SQRT : (!nr_offset0_sq ? (sv2v_cast_397C7_signed(1) << SQRT_LEAD) + manSC1 : manSC1 - (sv2v_cast_397C7_signed(1) << ((SUPER_SIG + SCALE_SQRT) - 3))));
	localparam INI_SIG_LO = 0;
	localparam INI_SIGB_LO = INI_SIG_LO + SUPER_SIG;
	localparam INI_EXPD_LO = INI_SIGB_LO + SUPER_SIG;
	localparam INI_EXPS_LO = INI_EXPD_LO + EXP_W;
	localparam INI_SGND_LO = INI_EXPS_LO + EXP_W;
	localparam INI_SGNS_LO = INI_SGND_LO + 1;
	localparam INI_NRO_LO = INI_SGNS_LO + 1;
	localparam INI_W0SQ_LO = INI_NRO_LO + 1;
	localparam INI_S0SQ_LO = INI_W0SQ_LO + W_BITS;
	localparam INI_EXCDV_LO = INI_S0SQ_LO + W_BITS;
	localparam INI_EXCSQ_LO = INI_EXCDV_LO + 5;
	localparam INI_FRM_LO = INI_EXCSQ_LO + 5;
	localparam INI_SQRT_LO = INI_FRM_LO + VX_gpu_pkg_INST_FRM_BITS;
	localparam INI_ISD_LO = INI_SQRT_LO + 1;
	localparam INI_W = INI_ISD_LO + 1;
	wire [INI_W - 1:0] ini_in;
	assign ini_in[INI_SIG_LO+:SUPER_SIG] = siga_ljn;
	assign ini_in[INI_SIGB_LO+:SUPER_SIG] = sigb_ljn;
	assign ini_in[INI_EXPD_LO+:EXP_W] = exp_r0_div;
	assign ini_in[INI_EXPS_LO+:EXP_W] = exp_r0_sqrt;
	assign ini_in[INI_SGND_LO] = sign_r0_div;
	assign ini_in[INI_SGNS_LO] = sign_r0_sq;
	assign ini_in[INI_NRO_LO] = nr_offset0_sq;
	assign ini_in[INI_W0SQ_LO+:W_BITS] = W0_sq;
	assign ini_in[INI_S0SQ_LO+:W_BITS] = S0_sq;
	assign ini_in[INI_EXCDV_LO+:5] = exc0_div;
	assign ini_in[INI_EXCSQ_LO+:5] = exc0_sq;
	assign ini_in[INI_FRM_LO+:VX_gpu_pkg_INST_FRM_BITS] = frm;
	assign ini_in[INI_SQRT_LO] = is_sqrt;
	assign ini_in[INI_ISD_LO] = is_d;
	wire [INI_W - 1:0] ini_out;
	VX_pipe_register #(
		.DATAW(INI_W),
		.DEPTH(1)
	) pre_reg(
		.clk(clk),
		.reset(reset),
		.enable(enable && mask),
		.data_in(ini_in),
		.data_out(ini_out)
	);
	wire [SUPER_SIG - 1:0] i_sig_a = ini_out[INI_SIG_LO+:SUPER_SIG];
	wire [SUPER_SIG - 1:0] i_sig_b = ini_out[INI_SIGB_LO+:SUPER_SIG];
	wire [EXP_W - 1:0] i_exp_div = ini_out[INI_EXPD_LO+:EXP_W];
	wire [EXP_W - 1:0] i_exp_sq = ini_out[INI_EXPS_LO+:EXP_W];
	wire i_sgn_div = ini_out[INI_SGND_LO];
	wire i_sgn_sq = ini_out[INI_SGNS_LO];
	wire i_nro_sq = ini_out[INI_NRO_LO];
	wire [W_BITS - 1:0] i_W0_sq = ini_out[INI_W0SQ_LO+:W_BITS];
	wire [W_BITS - 1:0] i_S0_sq = ini_out[INI_S0SQ_LO+:W_BITS];
	wire [4:0] i_exc_div = ini_out[INI_EXCDV_LO+:5];
	wire [4:0] i_exc_sq = ini_out[INI_EXCSQ_LO+:5];
	wire [2:0] i_frm = ini_out[INI_FRM_LO+:VX_gpu_pkg_INST_FRM_BITS];
	wire i_sqrt = ini_out[INI_SQRT_LO];
	wire i_isd = ini_out[INI_ISD_LO];
	wire [W_BITS - 1:0] i_D0_div = {1'b0, i_sig_b, {SCALE_DIV {1'b0}}};
	wire i_q_int0_div = i_sig_a >= i_sig_b;
	wire [SUPER_SIG - 1:0] i_pre_diff = i_sig_a - (i_q_int0_div ? i_sig_b : {SUPER_SIG {1'b0}});
	wire [W_BITS - 1:0] i_W0_div = {1'b0, i_pre_diff, {SCALE_DIV {1'b0}}};
	wire [STAGE_W - 1:0] srt_stage [0:NR_STAGES];
	wire [STAGE_W - 1:0] pre_in;
	assign pre_in[W_LO+:CS_BITS] = (i_sqrt ? {1'b0, i_W0_sq} : {1'b0, i_W0_div});
	assign pre_in[WC_LO+:CS_BITS] = 1'sb0;
	assign pre_in[DS_LO+:W_BITS] = (i_sqrt ? i_S0_sq : i_D0_div);
	assign pre_in[QB_LO+:NR_BITS] = {NR_BITS {1'b0}};
	assign pre_in[QI_LO] = (i_sqrt ? 1'b1 : i_q_int0_div);
	assign pre_in[EXP_LO+:EXP_W] = (i_sqrt ? i_exp_sq : i_exp_div);
	assign pre_in[SGN_LO] = (i_sqrt ? i_sgn_sq : i_sgn_div);
	assign pre_in[FRM_LO+:VX_gpu_pkg_INST_FRM_BITS] = i_frm;
	assign pre_in[EXC_LO+:5] = (i_sqrt ? i_exc_sq : i_exc_div);
	assign pre_in[NRO_LO] = (i_sqrt ? i_nro_sq : 1'b0);
	assign pre_in[SQ_LO] = i_sqrt;
	assign pre_in[ISD_LO] = i_isd;
	VX_pipe_register #(
		.DATAW(STAGE_W),
		.DEPTH(1)
	) ini_reg(
		.clk(clk),
		.reset(reset),
		.enable(enable && valid_ini),
		.data_in(pre_in),
		.data_out(srt_stage[0])
	);
	genvar _gv_k_3;
	generate
		for (_gv_k_3 = 0; _gv_k_3 < NR_STAGES; _gv_k_3 = _gv_k_3 + 1) begin : g_srt
			localparam k = _gv_k_3;
			localparam [W_BITS - 1:0] ULP_A_NRO0 = sv2v_cast_397C7_signed(1) << (((SUPER_SIG + SCALE_SQRT) - 2) - (2 * k));
			localparam [W_BITS - 1:0] ULP_B_NRO0 = sv2v_cast_397C7_signed(1) << (((SUPER_SIG + SCALE_SQRT) - 3) - (2 * k));
			localparam [W_BITS - 1:0] ULP_A_NRO1 = sv2v_cast_397C7_signed(1) << (((SUPER_SIG + SCALE_SQRT) - 3) - (2 * k));
			localparam [W_BITS - 1:0] ULP_B_NRO1 = sv2v_cast_397C7_signed(1) << (((SUPER_SIG + SCALE_SQRT) - 4) - (2 * k));
			wire [CS_BITS - 1:0] Ws_in = srt_stage[k][W_LO+:CS_BITS];
			wire [CS_BITS - 1:0] Wc_in = srt_stage[k][WC_LO+:CS_BITS];
			wire [W_BITS - 1:0] DS_in = srt_stage[k][DS_LO+:W_BITS];
			wire [NR_BITS - 1:0] qb_in = srt_stage[k][QB_LO+:NR_BITS];
			wire qi_in = srt_stage[k][QI_LO];
			wire [EXP_W - 1:0] exp_in = srt_stage[k][EXP_LO+:EXP_W];
			wire sgn_in = srt_stage[k][SGN_LO];
			wire [2:0] frm_in = srt_stage[k][FRM_LO+:VX_gpu_pkg_INST_FRM_BITS];
			wire [4:0] exc_in = srt_stage[k][EXC_LO+:5];
			wire nro_in = srt_stage[k][NRO_LO];
			wire sq_in = srt_stage[k][SQ_LO];
			wire isd_in = srt_stage[k][ISD_LO];
			wire [W_BITS - 1:0] ulp_a = (nro_in ? ULP_A_NRO1 : ULP_A_NRO0);
			wire [W_BITS - 1:0] ulp_b = (nro_in ? ULP_B_NRO1 : ULP_B_NRO0);
			wire [W_BITS - 1:0] D_S_a30 = (sq_in ? (nro_in ? DS_in : {DS_in[W_BITS - 2:0], 1'b0}) : DS_in);
			wire [W_BITS - 1:0] D_ulp_a = (sq_in ? (nro_in ? ulp_a >> 1 : ulp_a) : {W_BITS {1'sb0}});
			wire [W_BITS - 1:0] val_a_add = D_S_a30 - D_ulp_a;
			wire [W_BITS - 1:0] val_a_neg = D_S_a30 + D_ulp_a;
			wire [W_BITS - 1:0] DS_a_plus = DS_in + ulp_a;
			wire [W_BITS - 1:0] DS_a_minus = DS_in - ulp_a;
			wire [CS_BITS:0] W_a_sum = {1'b0, Ws_in} + {1'b0, Wc_in};
			wire q_a = ~W_a_sum[CS_BITS - 1];
			wire [CS_BITS - 1:0] X_a = (q_a ? {1'b1, ~val_a_neg} : {1'b0, val_a_add});
			wire [CS_BITS - 1:0] W2s_a = {Ws_in[CS_BITS - 2:0], q_a};
			wire [CS_BITS - 1:0] W2c_a = {Wc_in[CS_BITS - 2:0], 1'b0};
			wire [CS_BITS - 1:0] Ws_a = (W2s_a ^ W2c_a) ^ X_a;
			wire [W_BITS - 1:0] Wca_raw = ((W2s_a[W_BITS - 1:0] & W2c_a[W_BITS - 1:0]) | (W2c_a[W_BITS - 1:0] & X_a[W_BITS - 1:0])) | (W2s_a[W_BITS - 1:0] & X_a[W_BITS - 1:0]);
			wire [CS_BITS - 1:0] Wc_a = {Wca_raw, 1'b0};
			wire [W_BITS - 1:0] DS_a = (sq_in ? (q_a ? DS_a_plus : DS_a_minus) : DS_in);
			wire [W_BITS - 1:0] D_S_b30 = (sq_in ? (nro_in ? DS_a : {DS_a[W_BITS - 2:0], 1'b0}) : DS_a);
			wire [W_BITS - 1:0] D_ulp_b = (sq_in ? (nro_in ? ulp_b >> 1 : ulp_b) : {W_BITS {1'sb0}});
			wire [W_BITS - 1:0] val_b_add = D_S_b30 - D_ulp_b;
			wire [W_BITS - 1:0] val_b_neg = D_S_b30 + D_ulp_b;
			wire [W_BITS - 1:0] DS_b_plus = DS_a + ulp_b;
			wire [W_BITS - 1:0] DS_b_minus = DS_a - ulp_b;
			wire [CS_BITS:0] W_b_sum = {1'b0, Ws_a} + {1'b0, Wc_a};
			wire q_b = ~W_b_sum[CS_BITS - 1];
			wire [CS_BITS - 1:0] X_b = (q_b ? {1'b1, ~val_b_neg} : {1'b0, val_b_add});
			wire [CS_BITS - 1:0] W2s_b = {Ws_a[CS_BITS - 2:0], q_b};
			wire [CS_BITS - 1:0] W2c_b = {Wc_a[CS_BITS - 2:0], 1'b0};
			wire [CS_BITS - 1:0] Ws_b = (W2s_b ^ W2c_b) ^ X_b;
			wire [W_BITS - 1:0] Wcb_raw = ((W2s_b[W_BITS - 1:0] & W2c_b[W_BITS - 1:0]) | (W2c_b[W_BITS - 1:0] & X_b[W_BITS - 1:0])) | (W2s_b[W_BITS - 1:0] & X_b[W_BITS - 1:0]);
			wire [CS_BITS - 1:0] Wc_b = {Wcb_raw, 1'b0};
			wire [W_BITS - 1:0] DS_b = (sq_in ? (q_b ? DS_b_plus : DS_b_minus) : DS_a);
			wire [NR_BITS - 1:0] qb_new = {qb_in[NR_BITS - 3:0], q_a, q_b};
			wire [STAGE_W - 1:0] s_out;
			assign s_out[W_LO+:CS_BITS] = Ws_b;
			assign s_out[WC_LO+:CS_BITS] = Wc_b;
			assign s_out[DS_LO+:W_BITS] = DS_b;
			assign s_out[QB_LO+:NR_BITS] = qb_new;
			assign s_out[QI_LO] = qi_in;
			assign s_out[EXP_LO+:EXP_W] = exp_in;
			assign s_out[SGN_LO] = sgn_in;
			assign s_out[FRM_LO+:VX_gpu_pkg_INST_FRM_BITS] = frm_in;
			assign s_out[EXC_LO+:5] = exc_in;
			assign s_out[NRO_LO] = nro_in;
			assign s_out[SQ_LO] = sq_in;
			assign s_out[ISD_LO] = isd_in;
			VX_pipe_register #(
				.DATAW(STAGE_W),
				.DEPTH(1)
			) srt_reg(
				.clk(clk),
				.reset(reset),
				.enable(enable && mask_pipe[1 + k]),
				.data_in(s_out),
				.data_out(srt_stage[k + 1])
			);
		end
	endgenerate
	wire [CS_BITS - 1:0] Ws_cv = srt_stage[NR_STAGES][W_LO+:CS_BITS];
	wire [CS_BITS - 1:0] Wc_cv = srt_stage[NR_STAGES][WC_LO+:CS_BITS];
	wire [W_BITS - 1:0] DS_cv = srt_stage[NR_STAGES][DS_LO+:W_BITS];
	wire [NR_BITS - 1:0] qb_cv = srt_stage[NR_STAGES][QB_LO+:NR_BITS];
	wire qi_cv = srt_stage[NR_STAGES][QI_LO];
	wire [EXP_W - 1:0] exp_cv = srt_stage[NR_STAGES][EXP_LO+:EXP_W];
	wire sgn_cv = srt_stage[NR_STAGES][SGN_LO];
	wire [2:0] frm_cv = srt_stage[NR_STAGES][FRM_LO+:VX_gpu_pkg_INST_FRM_BITS];
	wire [4:0] exc_cv = srt_stage[NR_STAGES][EXC_LO+:5];
	wire nro_cv = srt_stage[NR_STAGES][NRO_LO];
	wire sq_cv = srt_stage[NR_STAGES][SQ_LO];
	wire isd_cv = srt_stage[NR_STAGES][ISD_LO];
	wire signed [CS_BITS:0] W_cv_sum = $signed(Ws_cv) + $signed(Wc_cv);
	wire [W_BITS - 1:0] W_cv = W_cv_sum[W_BITS - 1:0];
	wire [NR_BITS:0] Q_frac = {qb_cv, 1'b0} - {1'b0, {NR_BITS {1'b1}}};
	wire [NR_BITS:0] Q_tot = {qi_cv, Q_frac[NR_BITS - 1:0]};
	wire W_neg_div = W_cv[W_BITS - 1];
	wire [NR_BITS:0] Q_corr = (W_neg_div ? Q_tot - 1'b1 : Q_tot);
	wire [W_BITS - 1:0] W_corr_div = (W_neg_div ? W_cv + DS_cv : W_cv);
	wire sticky_div_r = W_corr_div != {W_BITS {1'sb0}};
	wire [NR_BITS:0] Q_rnd = (qi_cv ? Q_corr : {Q_corr[NR_BITS - 1:0], 1'b0});
	wire signed [EXP_W - 1:0] exp_res_div = $signed(exp_cv) - (qi_cv ? {EXP_W {1'sb0}} : sv2v_cast_6889D_signed(1));
	wire [SUPER_SIG - 1:0] man_div_d = Q_rnd[NR_BITS-:SUPER_SIG];
	wire guard_div_d = Q_rnd[NR_BITS - SUPER_SIG];
	wire round_div_d = Q_rnd[(NR_BITS - SUPER_SIG) - 1];
	wire sticky_div_d = |Q_rnd[(NR_BITS - SUPER_SIG) - 2:0] | sticky_div_r;
	wire [23:0] man_div_s = Q_rnd[NR_BITS-:24];
	wire guard_div_s = Q_rnd[NR_BITS - 24];
	wire round_div_s = Q_rnd[NR_BITS - 25];
	wire sticky_div_s = |Q_rnd[NR_BITS - 26:0] | sticky_div_r;
	wire W_neg_sq = W_cv[W_BITS - 1];
	wire [W_BITS - 1:0] ulp_last = (nro_cv ? sv2v_cast_397C7_signed(1) : sv2v_cast_397C7_signed(2));
	wire [W_BITS - 1:0] S_corr = (W_neg_sq ? DS_cv - ulp_last : DS_cv);
	wire [W_BITS:0] W_cv_sx = {W_cv[W_BITS - 1], W_cv};
	wire [W_BITS:0] W_D_sq = (nro_cv ? {1'b0, DS_cv} - {1'b0, ulp_last} : {DS_cv, 1'b0} - {1'b0, ulp_last});
	wire [W_BITS:0] W_corr_sq31 = (W_neg_sq ? W_cv_sx + W_D_sq : W_cv_sx);
	wire sticky_sq_w = W_corr_sq31[W_BITS - 1:0] != {W_BITS * 1 {1'sb0}};
	wire [SUPER_SIG - 1:0] man_sq_d = S_corr[SQRT_LEAD-:SUPER_SIG];
	wire guard_sq_d = S_corr[SQRT_LEAD - SUPER_SIG];
	wire round_sq_d = S_corr[(SQRT_LEAD - SUPER_SIG) - 1];
	wire sticky_sq_d = |S_corr[(SQRT_LEAD - SUPER_SIG) - 2:0] | sticky_sq_w;
	wire [23:0] man_sq_s = S_corr[SQRT_LEAD-:24];
	wire guard_sq_s = S_corr[SQRT_LEAD - 24];
	wire round_sq_s = S_corr[SQRT_LEAD - 25];
	wire sticky_sq_s = |S_corr[SQRT_LEAD - 26:0] | sticky_sq_w;
	wire signed [EXP_W - 1:0] exp_res_sq = $signed(exp_cv);
	wire act_s = HAS_D && !isd_cv;
	function automatic [SUPER_SIG - 1:0] sv2v_cast_A433B;
		input reg [SUPER_SIG - 1:0] inp;
		sv2v_cast_A433B = inp;
	endfunction
	wire [SUPER_SIG - 1:0] man_div = (act_s ? sv2v_cast_A433B(man_div_s) : man_div_d);
	wire [SUPER_SIG - 1:0] man_sq = (act_s ? sv2v_cast_A433B(man_sq_s) : man_sq_d);
	wire guard_div = (act_s ? guard_div_s : guard_div_d);
	wire round_div = (act_s ? round_div_s : round_div_d);
	wire sticky_div = (act_s ? sticky_div_s : sticky_div_d);
	wire guard_sq = (act_s ? guard_sq_s : guard_sq_d);
	wire round_sq = (act_s ? round_sq_s : round_sq_d);
	wire sticky_sq = (act_s ? sticky_sq_s : sticky_sq_d);
	wire [SUPER_SIG - 1:0] man_cv_out = (sq_cv ? man_sq : man_div);
	wire guard_cv_out = (sq_cv ? guard_sq : guard_div);
	wire round_cv_out = (sq_cv ? round_sq : round_div);
	wire sticky_cv_out = (sq_cv ? sticky_sq : sticky_div);
	wire signed [EXP_W - 1:0] exp_res = (sq_cv ? exp_res_sq : exp_res_div);
	localparam CONV_W = ((((SUPER_SIG + 3) + EXP_W) + 1) + VX_gpu_pkg_INST_FRM_BITS) + 6;
	wire [CONV_W - 1:0] conv_in = {man_cv_out, guard_cv_out, round_cv_out, sticky_cv_out, exp_res, sgn_cv, frm_cv, exc_cv, isd_cv};
	wire [CONV_W - 1:0] conv_out;
	VX_pipe_register #(
		.DATAW(CONV_W),
		.DEPTH(1)
	) conv_reg(
		.clk(clk),
		.reset(reset),
		.enable(enable && valid_conv),
		.data_in(conv_in),
		.data_out(conv_out)
	);
	wire [SUPER_SIG - 1:0] s_man;
	wire s_guard;
	wire s_round;
	wire s_sticky;
	wire [EXP_W - 1:0] s_exp_bits;
	wire s_sign;
	wire [2:0] s_frm;
	wire [4:0] s_exc;
	wire s_isd;
	assign {s_man, s_guard, s_round, s_sticky, s_exp_bits, s_sign, s_frm, s_exc, s_isd} = conv_out;
	wire signed [EXP_W - 1:0] s_exp = $signed(s_exp_bits);
	wire act_d = (HAS_D ? s_isd : 1'b0);
	wire [SUPER_SIG - 1:0] abs_rounded;
	wire round_sign;
	wire exact_zero;
	VX_fp_rounding #(.DAT_WIDTH(SUPER_SIG)) u_rnd(
		.abs_value_i(s_man),
		.sign_i(s_sign),
		.round_sticky_bits_i({s_guard, s_round | s_sticky}),
		.rnd_mode_i(s_frm),
		.effective_subtraction_i(1'b0),
		.abs_rounded_o(abs_rounded),
		.sign_o(round_sign),
		.exact_zero_o(exact_zero)
	);
	wire round_carry;
	generate
		if (HAS_D) begin : g_rcarry_d
			wire round_carry_d = (abs_rounded == {SUPER_SIG {1'sb0}}) & (s_man != {SUPER_SIG {1'sb0}});
			wire round_carry_s = abs_rounded[24];
			assign round_carry = (act_d ? round_carry_d : round_carry_s);
		end
		else begin : g_rcarry_s
			assign round_carry = (abs_rounded == {SUPER_SIG {1'sb0}}) & (s_man != {SUPER_SIG {1'sb0}});
		end
	endgenerate
	wire signed [EXP_W - 1:0] fin_exp = s_exp + (round_carry ? sv2v_cast_6889D_signed(1) : {EXP_W {1'sb0}});
	wire [SUPER_MAN - 1:0] fin_man_d = (round_carry ? {SUPER_MAN * 1 {1'sb0}} : abs_rounded[SUPER_MAN - 1:0]);
	wire [22:0] fin_man_s = (round_carry ? 23'd0 : abs_rounded[22:0]);
	wire is_nan = s_exc[4];
	wire is_inf = s_exc[3];
	wire is_zero = s_exc[2];
	wire dz_flag = s_exc[1];
	wire nv_flag = s_exc[0];
	wire [EXP_W - 1:0] act_allones = (act_d ? sv2v_cast_6889D_signed(2047) : sv2v_cast_6889D_signed(255));
	wire of_flag = ((fin_exp >= $signed(act_allones)) & ~is_nan) & ~is_inf;
	wire uf_flag = ((((fin_exp <= {EXP_W {1'sb0}}) & ~is_nan) & ~is_inf) & ~is_zero) & ~exact_zero;
	wire nx_flag = (((s_guard | s_round) | s_sticky) & ~is_nan) & ~is_inf;
	wire [31:0] nan_s = 32'h7fc00000;
	wire [31:0] inf_s = {round_sign, 31'h7f800000};
	wire [31:0] zero_s = {round_sign, 31'd0};
	wire [31:0] norm_s = {round_sign, fin_exp[7:0], fin_man_s};
	reg [31:0] res_s;
	always @(*)
		if (is_nan)
			res_s = nan_s;
		else if (is_inf | of_flag)
			res_s = inf_s;
		else if ((is_zero | exact_zero) | uf_flag)
			res_s = zero_s;
		else
			res_s = norm_s;
	wire [FLEN - 1:0] nrm_result;
	function automatic [FLEN - 1:0] sv2v_cast_9086B;
		input reg [FLEN - 1:0] inp;
		sv2v_cast_9086B = inp;
	endfunction
	generate
		if (HAS_D) begin : g_pack_d
			wire [63:0] nan_d = 64'h7ff8000000000000;
			wire [63:0] inf_d = {round_sign, 63'h7ff0000000000000};
			wire [63:0] zero_d = {round_sign, 63'd0};
			wire [63:0] norm_d = {round_sign, fin_exp[10:0], fin_man_d};
			reg [63:0] res_d;
			always @(*)
				if (is_nan)
					res_d = nan_d;
				else if (is_inf | of_flag)
					res_d = inf_d;
				else if ((is_zero | exact_zero) | uf_flag)
					res_d = zero_d;
				else
					res_d = norm_d;
			assign nrm_result = (act_d ? sv2v_cast_9086B(res_d) : {{FLEN - 32 {1'b1}}, res_s});
		end
		else begin : g_pack_s
			assign nrm_result = sv2v_cast_9086B(res_s);
		end
	endgenerate
	wire [4:0] nrm_fflags;
	assign nrm_fflags[4] = nv_flag;
	assign nrm_fflags[3] = dz_flag;
	assign nrm_fflags[2] = of_flag;
	assign nrm_fflags[1] = uf_flag;
	assign nrm_fflags[0] = (nx_flag | of_flag) | uf_flag;
	VX_pipe_register #(
		.DATAW(FLEN + 5),
		.DEPTH(1)
	) nrm_reg(
		.clk(clk),
		.reset(reset),
		.enable(enable && valid_nrm),
		.data_in({nrm_result, nrm_fflags}),
		.data_out({result, fflags})
	);
endmodule
module VX_fma_unit (
	clk,
	reset,
	enable,
	mask,
	op_type,
	fmt,
	frm,
	dataa,
	datab,
	datac,
	result,
	fflags
);
	reg _sv2v_0;
	parameter LATENCY = 6;
	parameter MAN_BITS = 23;
	parameter EXP_BITS = 8;
	parameter USE_DSP = 0;
	input wire clk;
	input wire reset;
	input wire enable;
	input wire mask;
	localparam VX_gpu_pkg_INST_FPU_BITS = 4;
	input wire [3:0] op_type;
	localparam VX_gpu_pkg_INST_FMT_BITS = 2;
	input wire [1:0] fmt;
	localparam VX_gpu_pkg_INST_FRM_BITS = 3;
	input wire [2:0] frm;
	input wire [MAN_BITS + EXP_BITS:0] dataa;
	input wire [MAN_BITS + EXP_BITS:0] datab;
	input wire [MAN_BITS + EXP_BITS:0] datac;
	output wire [MAN_BITS + EXP_BITS:0] result;
	output wire [4:0] fflags;
	localparam INI_LATENCY = 1;
	localparam ALN_LATENCY = ((MAN_BITS + 1) > 24 ? 2 : 1);
	localparam ACC_LATENCY = 1;
	localparam NRM_LATENCY = 1;
	localparam RND_LATENCY = 1;
	localparam MUL_LATENCY = ((((LATENCY - INI_LATENCY) - ALN_LATENCY) - ACC_LATENCY) - NRM_LATENCY) - RND_LATENCY;
	reg [LATENCY - 1:0] mask_pipe;
	always @(posedge clk)
		if (reset)
			mask_pipe <= 1'sb0;
		else if (enable)
			mask_pipe <= {mask_pipe[LATENCY - 2:0], mask};
	wire valid_alnf = mask_pipe[((INI_LATENCY + MUL_LATENCY) + ALN_LATENCY) - 2];
	wire valid_acc = mask_pipe[((INI_LATENCY + MUL_LATENCY) + ALN_LATENCY) - 1];
	wire valid_nrm = mask_pipe[(((INI_LATENCY + MUL_LATENCY) + ALN_LATENCY) + ACC_LATENCY) - 1];
	wire valid_rnd = mask_pipe[((((INI_LATENCY + MUL_LATENCY) + ALN_LATENCY) + ACC_LATENCY) + NRM_LATENCY) - 1];
	localparam FLOAT_BITS = (1 + EXP_BITS) + MAN_BITS;
	localparam EXP_IWIDTH = EXP_BITS + 2;
	localparam EXP_BIAS = (1 << (EXP_BITS - 1)) - 1;
	localparam EXP_MAX = (1 << EXP_BITS) - 1;
	localparam SIG_BITS = MAN_BITS + 1;
	localparam PROD_BITS = 2 * SIG_BITS;
	localparam ALN_BITS = PROD_BITS + 3;
	localparam ACC_BITS = ALN_BITS + 1;
	localparam LZC_BITS = (ACC_BITS > 1 ? $clog2(ACC_BITS) : 1);
	localparam NORM_WIN_BITS = MAN_BITS + 4;
	wire is_sub = fmt[1];
	localparam VX_gpu_pkg_INST_FPU_NMADD = 4'b0011;
	wire is_nmadd = op_type == VX_gpu_pkg_INST_FPU_NMADD;
	localparam VX_gpu_pkg_INST_FPU_MUL = 4'b0001;
	wire is_mul = op_type == VX_gpu_pkg_INST_FPU_MUL;
	localparam VX_gpu_pkg_INST_FPU_ADD = 4'b0000;
	wire is_add = op_type == VX_gpu_pkg_INST_FPU_ADD;
	wire s_prod_neg = is_nmadd;
	wire s_c_neg = is_sub ^ is_nmadd;
	wire [FLOAT_BITS - 1:0] op_a = dataa;
	function automatic signed [EXP_BITS - 1:0] sv2v_cast_DBE99_signed;
		input reg signed [EXP_BITS - 1:0] inp;
		sv2v_cast_DBE99_signed = inp;
	endfunction
	wire [FLOAT_BITS - 1:0] op_b = (is_add ? {1'b0, sv2v_cast_DBE99_signed(EXP_BIAS), {MAN_BITS {1'b0}}} : datab);
	wire [FLOAT_BITS - 1:0] op_c = (is_add ? datab : datac);
	wire s_a0 = op_a[FLOAT_BITS - 1] ^ s_prod_neg;
	wire s_b0 = op_b[FLOAT_BITS - 1];
	wire s_c0 = (is_mul ? 1'b0 : op_c[FLOAT_BITS - 1] ^ s_c_neg);
	wire [EXP_BITS - 1:0] e_a0 = op_a[FLOAT_BITS - 2:MAN_BITS];
	wire [EXP_BITS - 1:0] e_b0 = op_b[FLOAT_BITS - 2:MAN_BITS];
	wire [EXP_BITS - 1:0] e_c0 = (is_mul ? {EXP_BITS {1'b0}} : op_c[FLOAT_BITS - 2:MAN_BITS]);
	wire [MAN_BITS - 1:0] m_a0 = op_a[MAN_BITS - 1:0];
	wire [MAN_BITS - 1:0] m_b0 = op_b[MAN_BITS - 1:0];
	wire [MAN_BITS - 1:0] m_c0 = (is_mul ? {MAN_BITS {1'b0}} : op_c[MAN_BITS - 1:0]);
	wire [6:0] clss_a0;
	wire [6:0] clss_b0;
	wire [6:0] clss_c0;
	VX_fp_classifier #(
		.MAN_BITS(MAN_BITS),
		.EXP_BITS(EXP_BITS)
	) cls_a0(
		.exp_i(e_a0),
		.man_i(m_a0),
		.clss_o(clss_a0)
	);
	VX_fp_classifier #(
		.MAN_BITS(MAN_BITS),
		.EXP_BITS(EXP_BITS)
	) cls_b0(
		.exp_i(e_b0),
		.man_i(m_b0),
		.clss_o(clss_b0)
	);
	VX_fp_classifier #(
		.MAN_BITS(MAN_BITS),
		.EXP_BITS(EXP_BITS)
	) cls_c0(
		.exp_i(e_c0),
		.man_i(m_c0),
		.clss_o(clss_c0)
	);
	wire [SIG_BITS - 1:0] sig_a = {clss_a0[6], m_a0};
	wire [SIG_BITS - 1:0] sig_b = {clss_b0[6], m_b0};
	wire [SIG_BITS - 1:0] sig_c = {clss_c0[6], m_c0};
	function automatic signed [EXP_IWIDTH - 1:0] sv2v_cast_83A4C_signed;
		input reg signed [EXP_IWIDTH - 1:0] inp;
		sv2v_cast_83A4C_signed = inp;
	endfunction
	function automatic [EXP_IWIDTH - 1:0] sv2v_cast_83A4C;
		input reg [EXP_IWIDTH - 1:0] inp;
		sv2v_cast_83A4C = inp;
	endfunction
	wire signed [EXP_IWIDTH - 1:0] exp_a = (clss_a0[4] ? sv2v_cast_83A4C_signed(1) : (clss_a0[6] ? sv2v_cast_83A4C(e_a0) : sv2v_cast_83A4C_signed(0)));
	wire signed [EXP_IWIDTH - 1:0] exp_b = (clss_b0[4] ? sv2v_cast_83A4C_signed(1) : (clss_b0[6] ? sv2v_cast_83A4C(e_b0) : sv2v_cast_83A4C_signed(0)));
	wire signed [EXP_IWIDTH - 1:0] exp_c = (clss_c0[4] ? sv2v_cast_83A4C_signed(1) : (clss_c0[6] ? sv2v_cast_83A4C(e_c0) : sv2v_cast_83A4C_signed(0)));
	wire s_prod0 = s_a0 ^ s_b0;
	wire signed [EXP_IWIDTH - 1:0] exp_prod0 = (clss_a0[5] | clss_b0[5] ? sv2v_cast_83A4C_signed(0) : (exp_a + exp_b) - $signed(sv2v_cast_83A4C_signed(EXP_BIAS)));
	wire inf_a = clss_a0[3];
	wire inf_b = clss_b0[3];
	wire inf_c = clss_c0[3];
	wire nan_a = clss_a0[2];
	wire nan_b = clss_b0[2];
	wire nan_c = clss_c0[2];
	wire snan_a = clss_a0[0];
	wire snan_b = clss_b0[0];
	wire snan_c = clss_c0[0];
	wire nv_inf_zero = (inf_a & clss_b0[5]) | (clss_a0[5] & inf_b);
	wire nv_snan = (snan_a | snan_b) | snan_c;
	wire prod_is_inf = ((inf_a | inf_b) & ~nan_a) & ~nan_b;
	wire nv_inf_inf = (prod_is_inf & inf_c) & (s_prod0 != s_c0);
	wire early_nv = (nv_snan | nv_inf_zero) | nv_inf_inf;
	wire any_nan = (nan_a | nan_b) | nan_c;
	wire result_nan = any_nan | early_nv;
	wire result_inf = ((prod_is_inf | inf_c) & ~result_nan) & ~nv_inf_inf;
	wire result_inf_sign = (prod_is_inf ? s_prod0 : s_c0);
	wire [3:0] exc0 = {result_nan, result_inf, result_inf_sign, early_nv};
	localparam INI_DATAW = (((((3 * SIG_BITS) + EXP_IWIDTH) + EXP_IWIDTH) + 2) + VX_gpu_pkg_INST_FRM_BITS) + 4;
	wire [INI_DATAW - 1:0] s0_data;
	VX_pipe_register #(
		.DATAW(INI_DATAW),
		.DEPTH(INI_LATENCY)
	) pipe_ini(
		.clk(clk),
		.reset(reset),
		.enable(enable && mask),
		.data_in({sig_a, sig_b, sig_c, exp_prod0, exp_c, s_prod0, s_c0, frm, exc0}),
		.data_out(s0_data)
	);
	wire [SIG_BITS - 1:0] r1_sig_a;
	wire [SIG_BITS - 1:0] r1_sig_b;
	wire [SIG_BITS - 1:0] r1_sig_c;
	wire signed [EXP_IWIDTH - 1:0] r1_exp_prod;
	wire signed [EXP_IWIDTH - 1:0] r1_exp_c;
	wire r1_s_prod;
	wire r1_s_c;
	wire [2:0] r1_frm;
	wire [3:0] r1_exc;
	assign {r1_sig_a, r1_sig_b, r1_sig_c, r1_exp_prod, r1_exp_c, r1_s_prod, r1_s_c, r1_frm, r1_exc} = s0_data;
	wire [PROD_BITS - 1:0] s1_prod;
	localparam SPLIT_MUL = ((USE_DSP != 0) && (SIG_BITS > 24)) && (MUL_LATENCY >= 2);
	function automatic [PROD_BITS - 1:0] sv2v_cast_551D1;
		input reg [PROD_BITS - 1:0] inp;
		sv2v_cast_551D1 = inp;
	endfunction
	generate
		if (SPLIT_MUL) begin : g_mul_dsp_split
			localparam BL_W = SIG_BITS - (SIG_BITS / 2);
			localparam BH_W = SIG_BITS / 2;
			(* use_dsp = "yes" *) wire [(SIG_BITS + BL_W) - 1:0] pp_lo = r1_sig_a * r1_sig_b[BL_W - 1:0];
			(* use_dsp = "yes" *) wire [(SIG_BITS + BH_W) - 1:0] pp_hi = r1_sig_a * r1_sig_b[SIG_BITS - 1:BL_W];
			reg [(SIG_BITS + BL_W) - 1:0] pp_lo_q;
			reg [(SIG_BITS + BH_W) - 1:0] pp_hi_q;
			always @(posedge clk)
				if (enable) begin
					pp_lo_q <= pp_lo;
					pp_hi_q <= pp_hi;
				end
			reg [PROD_BITS - 1:0] prod_q;
			always @(posedge clk)
				if (enable)
					prod_q <= sv2v_cast_551D1(pp_lo_q) + (sv2v_cast_551D1(pp_hi_q) << BL_W);
			VX_pipe_register #(
				.DATAW(PROD_BITS),
				.DEPTH(MUL_LATENCY - 2)
			) pm(
				.clk(clk),
				.reset(reset),
				.enable(enable),
				.data_in(prod_q),
				.data_out(s1_prod)
			);
		end
		else if (USE_DSP) begin : g_mul_dsp
			(* use_dsp = "yes" *) wire [PROD_BITS - 1:0] dsp_prod = sv2v_cast_551D1(r1_sig_a) * sv2v_cast_551D1(r1_sig_b);
			VX_pipe_register #(
				.DATAW(PROD_BITS),
				.DEPTH(MUL_LATENCY)
			) pm(
				.clk(clk),
				.reset(reset),
				.enable(enable),
				.data_in(dsp_prod),
				.data_out(s1_prod)
			);
		end
		else if ((MUL_LATENCY < 3) && (SIG_BITS <= 24)) begin : g_mul_wallace
			wire [PROD_BITS - 1:0] wal_prod;
			VX_wallace_mul #(
				.N(SIG_BITS),
				.P(PROD_BITS),
				.CPA_KS(!(PROD_BITS <= 27))
			) u_mul(
				.a(r1_sig_a),
				.b(r1_sig_b),
				.p(wal_prod)
			);
			VX_pipe_register #(
				.DATAW(PROD_BITS),
				.DEPTH(MUL_LATENCY)
			) pm(
				.clk(clk),
				.reset(reset),
				.enable(enable),
				.data_in(wal_prod),
				.data_out(s1_prod)
			);
		end
		else begin : g_mul_infer
			wire [PROD_BITS - 1:0] inf_prod = sv2v_cast_551D1(r1_sig_a) * sv2v_cast_551D1(r1_sig_b);
			VX_pipe_register #(
				.DATAW(PROD_BITS),
				.DEPTH(MUL_LATENCY)
			) pm(
				.clk(clk),
				.reset(reset),
				.enable(enable),
				.data_in(inf_prod),
				.data_out(s1_prod)
			);
		end
	endgenerate
	localparam SIDE_W = (((((EXP_IWIDTH + 1) + SIG_BITS) + EXP_IWIDTH) + 1) + VX_gpu_pkg_INST_FRM_BITS) + 4;
	wire signed [EXP_IWIDTH - 1:0] s1_exp_prod;
	wire s1_s_prod;
	wire [SIG_BITS - 1:0] s1_sig_c;
	wire signed [EXP_IWIDTH - 1:0] s1_exp_c;
	wire s1_s_c;
	wire [2:0] s1_frm;
	wire [3:0] s1_exc;
	wire [SIDE_W - 1:0] s1_side;
	VX_pipe_register #(
		.DATAW(SIDE_W),
		.DEPTH(MUL_LATENCY)
	) pipe_side(
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.data_in({r1_exp_prod, r1_s_prod, r1_sig_c, r1_exp_c, r1_s_c, r1_frm, r1_exc}),
		.data_out(s1_side)
	);
	assign {s1_exp_prod, s1_s_prod, s1_sig_c, s1_exp_c, s1_s_c, s1_frm, s1_exc} = s1_side;
	wire s1_eff_sub = s1_s_prod ^ s1_s_c;
	wire prod_ge_c = s1_exp_prod >= s1_exp_c;
	wire signed [EXP_IWIDTH - 1:0] s1_max_exp = (prod_ge_c ? s1_exp_prod : s1_exp_c);
	localparam SHIFT_BITS = ((ALN_BITS + 1) > 1 ? $clog2(ALN_BITS + 1) : 1);
	localparam FINE_BITS = 4;
	wire signed [EXP_IWIDTH - 1:0] exp_diff = (prod_ge_c ? s1_exp_prod - s1_exp_c : s1_exp_c - s1_exp_prod);
	function automatic signed [SHIFT_BITS - 1:0] sv2v_cast_86A44_signed;
		input reg signed [SHIFT_BITS - 1:0] inp;
		sv2v_cast_86A44_signed = inp;
	endfunction
	wire [SHIFT_BITS - 1:0] shift_amt = (exp_diff > $signed(sv2v_cast_83A4C_signed(ALN_BITS)) ? sv2v_cast_86A44_signed(ALN_BITS) : sv2v_cast_86A44_signed(exp_diff));
	wire [ALN_BITS - 1:0] prod_aligned_full = {s1_prod, {ALN_BITS - PROD_BITS {1'b0}}};
	wire [ALN_BITS - 1:0] c_aligned_full = {1'b0, s1_sig_c, {(ALN_BITS - SIG_BITS) - 1 {1'b0}}};
	wire [ALN_BITS - 1:0] shift_in = (prod_ge_c ? c_aligned_full : prod_aligned_full);
	wire [ALN_BITS - 1:0] fixed_op = (prod_ge_c ? prod_aligned_full : c_aligned_full);
	wire [ALN_BITS - 1:0] aln_prod;
	wire [ALN_BITS - 1:0] aln_c;
	wire aln_sticky;
	wire aln_eff_sub;
	wire aln_s_prod;
	wire aln_s_c;
	wire signed [EXP_IWIDTH - 1:0] aln_max_exp;
	wire [2:0] aln_frm;
	wire [3:0] aln_exc;
	generate
		if (ALN_LATENCY == 2) begin : g_align_split
			wire valid_aln = mask_pipe[(INI_LATENCY + MUL_LATENCY) - 1];
			wire [SHIFT_BITS - 1:0] coarse_amt = {shift_amt[SHIFT_BITS - 1:FINE_BITS], {FINE_BITS {1'b0}}};
			wire [(2 * ALN_BITS) - 1:0] shift_ext = {shift_in, {ALN_BITS {1'b0}}};
			wire [(2 * ALN_BITS) - 1:0] coarse_sh = shift_ext >> coarse_amt;
			localparam ALN1_DATAW = ((((((2 * ALN_BITS) + FINE_BITS) + ALN_BITS) + 4) + EXP_IWIDTH) + VX_gpu_pkg_INST_FRM_BITS) + 4;
			wire [ALN1_DATAW - 1:0] aln1_data;
			VX_pipe_register #(
				.DATAW(ALN1_DATAW),
				.DEPTH(1)
			) pipe_aln1(
				.clk(clk),
				.reset(reset),
				.enable(enable && valid_aln),
				.data_in({coarse_sh, shift_amt[3:0], fixed_op, prod_ge_c, s1_eff_sub, s1_s_prod, s1_s_c, s1_max_exp, s1_frm, s1_exc}),
				.data_out(aln1_data)
			);
			wire [(2 * ALN_BITS) - 1:0] a1_coarse;
			wire [3:0] a1_fine;
			wire [ALN_BITS - 1:0] a1_fixed;
			wire a1_prod_ge_c;
			wire a1_eff_sub;
			wire a1_s_prod;
			wire a1_s_c;
			wire signed [EXP_IWIDTH - 1:0] a1_max_exp;
			wire [2:0] a1_frm;
			wire [3:0] a1_exc;
			assign {a1_coarse, a1_fine, a1_fixed, a1_prod_ge_c, a1_eff_sub, a1_s_prod, a1_s_c, a1_max_exp, a1_frm, a1_exc} = aln1_data;
			wire [(2 * ALN_BITS) - 1:0] fine_sh = a1_coarse >> a1_fine;
			wire [ALN_BITS - 1:0] shift_out = fine_sh[(2 * ALN_BITS) - 1:ALN_BITS];
			assign aln_sticky = |fine_sh[ALN_BITS - 1:0];
			assign aln_prod = (a1_prod_ge_c ? a1_fixed : shift_out);
			assign aln_c = (a1_prod_ge_c ? shift_out : a1_fixed);
			assign aln_eff_sub = a1_eff_sub;
			assign aln_s_prod = a1_s_prod;
			assign aln_s_c = a1_s_c;
			assign aln_max_exp = a1_max_exp;
			assign aln_frm = a1_frm;
			assign aln_exc = a1_exc;
		end
		else begin : g_align_single
			wire [(2 * ALN_BITS) - 1:0] shift_ext = {shift_in, {ALN_BITS {1'b0}}};
			wire [(2 * ALN_BITS) - 1:0] full_sh = shift_ext >> shift_amt;
			wire [ALN_BITS - 1:0] shift_out = full_sh[(2 * ALN_BITS) - 1:ALN_BITS];
			assign aln_sticky = |full_sh[ALN_BITS - 1:0];
			assign aln_prod = (prod_ge_c ? fixed_op : shift_out);
			assign aln_c = (prod_ge_c ? shift_out : fixed_op);
			assign aln_eff_sub = s1_eff_sub;
			assign aln_s_prod = s1_s_prod;
			assign aln_s_c = s1_s_c;
			assign aln_max_exp = s1_max_exp;
			assign aln_frm = s1_frm;
			assign aln_exc = s1_exc;
		end
	endgenerate
	localparam ALN_DATAW = ((((ALN_BITS + ALN_BITS) + 4) + EXP_IWIDTH) + VX_gpu_pkg_INST_FRM_BITS) + 4;
	wire [ALN_DATAW - 1:0] s2_data;
	VX_pipe_register #(
		.DATAW(ALN_DATAW),
		.DEPTH(1)
	) pipe_aln(
		.clk(clk),
		.reset(reset),
		.enable(enable && valid_alnf),
		.data_in({aln_prod, aln_c, aln_sticky, aln_eff_sub, aln_s_prod, aln_s_c, aln_max_exp, aln_frm, aln_exc}),
		.data_out(s2_data)
	);
	wire [ALN_BITS - 1:0] s2_aln_prod;
	wire [ALN_BITS - 1:0] s2_aln_c;
	wire s2_sticky;
	wire s2_eff_sub;
	wire s2_s_prod;
	wire s2_s_c;
	wire signed [EXP_IWIDTH - 1:0] s2_max_exp;
	wire [2:0] s2_frm;
	wire [3:0] s2_exc;
	assign {s2_aln_prod, s2_aln_c, s2_sticky, s2_eff_sub, s2_s_prod, s2_s_c, s2_max_exp, s2_frm, s2_exc} = s2_data;
	wire prod_gte_c = s2_aln_prod >= s2_aln_c;
	wire [ACC_BITS - 1:0] add_result = {1'b0, s2_aln_prod} + {1'b0, s2_aln_c};
	wire [ACC_BITS - 1:0] sub_ab = {1'b0, s2_aln_prod} - {1'b0, s2_aln_c};
	wire [ACC_BITS - 1:0] acc_sum;
	wire acc_sign;
	function automatic signed [ACC_BITS - 1:0] sv2v_cast_08730_signed;
		input reg signed [ACC_BITS - 1:0] inp;
		sv2v_cast_08730_signed = inp;
	endfunction
	assign acc_sum = (s2_eff_sub ? (prod_gte_c ? sub_ab : ~sub_ab + sv2v_cast_08730_signed(1)) : add_result);
	assign acc_sign = (s2_eff_sub ? (prod_gte_c ? s2_s_prod : s2_s_c) : s2_s_prod);
	wire [LZC_BITS - 1:0] lzc_count;
	wire lzc_valid;
	VX_lzc #(.N(ACC_BITS)) lzc_inst(
		.data_in(acc_sum),
		.data_out(lzc_count),
		.valid_out(lzc_valid)
	);
	function automatic signed [LZC_BITS - 1:0] sv2v_cast_78FD0_signed;
		input reg signed [LZC_BITS - 1:0] inp;
		sv2v_cast_78FD0_signed = inp;
	endfunction
	wire [LZC_BITS - 1:0] lzc_predict = (lzc_valid ? lzc_count : sv2v_cast_78FD0_signed(ACC_BITS));
	wire acc_sticky = s2_sticky;
	localparam ACC_DATAW = ((((ACC_BITS + 3) + LZC_BITS) + EXP_IWIDTH) + VX_gpu_pkg_INST_FRM_BITS) + 4;
	wire [ACC_DATAW - 1:0] s3_data;
	VX_pipe_register #(
		.DATAW(ACC_DATAW),
		.DEPTH(ACC_LATENCY)
	) pipe_acc(
		.clk(clk),
		.reset(reset),
		.enable(enable && valid_acc),
		.data_in({acc_sum, acc_sign, acc_sticky, s2_eff_sub, lzc_predict, s2_max_exp, s2_frm, s2_exc}),
		.data_out(s3_data)
	);
	wire [ACC_BITS - 1:0] s3_sum;
	wire s3_sign;
	wire s3_sticky;
	wire s3_eff_sub;
	wire [LZC_BITS - 1:0] s3_lzc_pred;
	wire signed [EXP_IWIDTH - 1:0] s3_max_exp;
	wire [2:0] s3_frm;
	wire [3:0] s3_exc;
	assign {s3_sum, s3_sign, s3_sticky, s3_eff_sub, s3_lzc_pred, s3_max_exp, s3_frm, s3_exc} = s3_data;
	wire zero_sum = ~|s3_sum;
	wire [ACC_BITS:0] sum_ext = {1'b0, s3_sum};
	wire [ACC_BITS:0] shifted_raw = sum_ext << s3_lzc_pred;
	wire overshift = shifted_raw[ACC_BITS];
	wire [NORM_WIN_BITS - 1:0] norm_window = (overshift ? shifted_raw[ACC_BITS-:NORM_WIN_BITS] : shifted_raw[ACC_BITS - 1-:NORM_WIN_BITS]);
	localparam EXP_ADJ = 2;
	wire signed [EXP_IWIDTH - 1:0] nrm_exp_base = (s3_max_exp - $signed(sv2v_cast_83A4C(s3_lzc_pred))) + $signed(sv2v_cast_83A4C_signed(EXP_ADJ));
	wire signed [EXP_IWIDTH - 1:0] nrm_exp_plus1 = nrm_exp_base + $signed(sv2v_cast_83A4C_signed(1));
	wire signed [EXP_IWIDTH - 1:0] nrm_exp_plus2 = nrm_exp_base + $signed(sv2v_cast_83A4C_signed(2));
	localparam STICK_IDX = MAN_BITS + 2;
	wire sticky_below = (overshift ? |shifted_raw[STICK_IDX:0] : |shifted_raw[STICK_IDX - 1:0]);
	localparam NRM_DATAW = (((NORM_WIN_BITS + 6) + (3 * EXP_IWIDTH)) + VX_gpu_pkg_INST_FRM_BITS) + 4;
	wire [NRM_DATAW - 1:0] s4_data;
	VX_pipe_register #(
		.DATAW(NRM_DATAW),
		.DEPTH(NRM_LATENCY)
	) pipe_nrm(
		.clk(clk),
		.reset(reset),
		.enable(enable && valid_nrm),
		.data_in({norm_window, overshift, sticky_below, s3_sticky, s3_sign, s3_eff_sub, zero_sum, nrm_exp_base, nrm_exp_plus1, nrm_exp_plus2, s3_frm, s3_exc}),
		.data_out(s4_data)
	);
	wire [NORM_WIN_BITS - 1:0] r5_window;
	wire r5_overshift;
	wire r5_sticky_below;
	wire r5_sticky_acc;
	wire r5_sign;
	wire r5_eff_sub;
	wire r5_zero_sum;
	wire signed [EXP_IWIDTH - 1:0] r5_exp_base;
	wire signed [EXP_IWIDTH - 1:0] r5_exp_plus1;
	wire signed [EXP_IWIDTH - 1:0] r5_exp_plus2;
	wire [2:0] r5_frm;
	wire [3:0] r5_exc;
	assign {r5_window, r5_overshift, r5_sticky_below, r5_sticky_acc, r5_sign, r5_eff_sub, r5_zero_sum, r5_exp_base, r5_exp_plus1, r5_exp_plus2, r5_frm, r5_exc} = s4_data;
	wire [MAN_BITS:0] rnd_man = r5_window[NORM_WIN_BITS - 1:3];
	wire guard_bit = r5_window[2];
	wire round_bit = r5_window[1];
	wire sticky_sum = (r5_window[0] | r5_sticky_below) | r5_sticky_acc;
	function automatic signed [((MAN_BITS + 0) >= 0 ? MAN_BITS + 1 : 1 - (MAN_BITS + 0)) - 1:0] sv2v_cast_50E85_signed;
		input reg signed [((MAN_BITS + 0) >= 0 ? MAN_BITS + 1 : 1 - (MAN_BITS + 0)) - 1:0] inp;
		sv2v_cast_50E85_signed = inp;
	endfunction
	wire [MAN_BITS:0] man_inc = rnd_man + sv2v_cast_50E85_signed(1);
	reg round_up;
	wire [1:0] round_sticky_bits = {guard_bit, round_bit | sticky_sum};
	localparam VX_gpu_pkg_INST_FRM_RDN = 3'b010;
	localparam VX_gpu_pkg_INST_FRM_RMM = 3'b100;
	localparam VX_gpu_pkg_INST_FRM_RNE = 3'b000;
	localparam VX_gpu_pkg_INST_FRM_RTZ = 3'b001;
	localparam VX_gpu_pkg_INST_FRM_RUP = 3'b011;
	always @(*)
		case (r5_frm)
			VX_gpu_pkg_INST_FRM_RNE:
				case (round_sticky_bits)
					2'b00, 2'b01: round_up = 1'b0;
					2'b10: round_up = rnd_man[0];
					2'b11: round_up = 1'b1;
				endcase
			VX_gpu_pkg_INST_FRM_RTZ: round_up = 1'b0;
			VX_gpu_pkg_INST_FRM_RDN: round_up = |round_sticky_bits & r5_sign;
			VX_gpu_pkg_INST_FRM_RUP: round_up = |round_sticky_bits & ~r5_sign;
			VX_gpu_pkg_INST_FRM_RMM: round_up = round_sticky_bits[1];
			default: round_up = 1'bx;
		endcase
	wire [MAN_BITS:0] abs_rounded = (round_up ? man_inc : rnd_man);
	wire round_carry = round_up & (&rnd_man);
	wire [MAN_BITS - 1:0] final_man = (round_carry ? abs_rounded[MAN_BITS:1] : abs_rounded[MAN_BITS - 1:0]);
	wire exact_zero = (rnd_man == {(MAN_BITS >= 0 ? MAN_BITS + 1 : 1 - MAN_BITS) {1'sb0}}) && (round_sticky_bits == {2 {1'sb0}});
	wire round_sign = (exact_zero && r5_eff_sub ? r5_frm == VX_gpu_pkg_INST_FRM_RDN : r5_sign);
	reg signed [EXP_IWIDTH - 1:0] final_exp_s;
	always @(*) begin
		if (_sv2v_0)
			;
		case ({r5_overshift, round_carry})
			2'b00: final_exp_s = r5_exp_base;
			2'b01: final_exp_s = r5_exp_plus1;
			2'b10: final_exp_s = r5_exp_plus1;
			2'b11: final_exp_s = r5_exp_plus2;
		endcase
	end
	wire is_nan_result = r5_exc[3];
	wire is_inf_result = r5_exc[2];
	wire inf_sign_result = r5_exc[1];
	wire nv_flag = r5_exc[0];
	wire of_flag = ((final_exp_s >= $signed(sv2v_cast_83A4C_signed(EXP_MAX))) & ~is_nan_result) & ~is_inf_result;
	wire uf_flag = ((((final_exp_s <= $signed(sv2v_cast_83A4C_signed(0))) & ~is_nan_result) & ~is_inf_result) & ~r5_zero_sum) & ~exact_zero;
	wire nx_flag = (((guard_bit | round_bit) | sticky_sum) & ~is_nan_result) & ~is_inf_result;
	reg [FLOAT_BITS - 1:0] rnd_result;
	always @(*) begin
		if (_sv2v_0)
			;
		if (is_nan_result)
			rnd_result = {1'b0, {EXP_BITS {1'b1}}, 1'b1, {MAN_BITS - 1 {1'b0}}};
		else if (is_inf_result)
			rnd_result = {inf_sign_result, {EXP_BITS {1'b1}}, {MAN_BITS {1'b0}}};
		else if (of_flag)
			rnd_result = {round_sign, {EXP_BITS {1'b1}}, {MAN_BITS {1'b0}}};
		else if ((r5_zero_sum | exact_zero) | uf_flag)
			rnd_result = {round_sign, {FLOAT_BITS - 1 {1'b0}}};
		else
			rnd_result = {round_sign, final_exp_s[EXP_BITS - 1:0], final_man};
	end
	wire [4:0] rnd_fflags;
	assign rnd_fflags[4] = nv_flag;
	assign rnd_fflags[3] = 1'b0;
	assign rnd_fflags[2] = of_flag;
	assign rnd_fflags[1] = uf_flag;
	assign rnd_fflags[0] = (nx_flag | of_flag) | uf_flag;
	VX_pipe_register #(
		.DATAW(FLOAT_BITS + 5),
		.DEPTH(RND_LATENCY)
	) pipe_rnd(
		.clk(clk),
		.reset(reset),
		.enable(enable && valid_rnd),
		.data_in({rnd_result, rnd_fflags}),
		.data_out({result, fflags})
	);
	initial _sv2v_0 = 0;
endmodule
module VX_fncp_unit (
	clk,
	reset,
	enable,
	mask,
	op_type,
	fmt,
	frm,
	dataa,
	datab,
	result,
	fflags
);
	parameter LATENCY = 1;
	parameter FLEN = 32;
	parameter OUT_REG = 0;
	input wire clk;
	input wire reset;
	input wire enable;
	input wire mask;
	localparam VX_gpu_pkg_INST_FPU_BITS = 4;
	input wire [3:0] op_type;
	localparam VX_gpu_pkg_INST_FMT_BITS = 2;
	input wire [1:0] fmt;
	localparam VX_gpu_pkg_INST_FRM_BITS = 3;
	input wire [2:0] frm;
	input wire [FLEN - 1:0] dataa;
	input wire [FLEN - 1:0] datab;
	output wire [31:0] result;
	output wire [4:0] fflags;
	localparam F32_EXP = 8;
	localparam F32_MAN = 23;
	localparam F64_EXP = 11;
	localparam F64_MAN = 52;
	localparam HAS_D = FLEN >= 64;
	wire is_d = (HAS_D ? fmt[0] : 1'b0);
	localparam [31:0] F32_CANON_QNAN = 32'h7fc00000;
	wire a32_boxed;
	wire b32_boxed;
	generate
		if (HAS_D) begin : g_box_chk
			assign a32_boxed = &dataa[FLEN - 1:32];
			assign b32_boxed = &datab[FLEN - 1:32];
		end
		else begin : g_no_box_chk
			assign a32_boxed = 1'b1;
			assign b32_boxed = 1'b1;
		end
	endgenerate
	wire [31:0] a32_op = (a32_boxed ? dataa[31:0] : F32_CANON_QNAN);
	wire [31:0] b32_op = (b32_boxed ? datab[31:0] : F32_CANON_QNAN);
	reg [LATENCY - 1:0] mask_pipe;
	always @(posedge clk)
		if (reset)
			mask_pipe <= 1'sb0;
		else if (enable)
			mask_pipe <= {mask_pipe[LATENCY - 2:0], mask};
	localparam NEG_INF = 32'h00000001;
	localparam NEG_NORM = 32'h00000002;
	localparam NEG_SUBNORM = 32'h00000004;
	localparam NEG_ZERO = 32'h00000008;
	localparam POS_ZERO = 32'h00000010;
	localparam POS_SUBNORM = 32'h00000020;
	localparam POS_NORM = 32'h00000040;
	localparam POS_INF = 32'h00000080;
	localparam QUT_NAN = 32'h00000200;
	wire a32_sign = a32_op[31];
	wire b32_sign = b32_op[31];
	wire [7:0] a32_exp = a32_op[30:23];
	wire [22:0] a32_man = a32_op[22:0];
	wire [6:0] a32_class;
	wire [6:0] b32_class;
	VX_fp_classifier #(
		.EXP_BITS(F32_EXP),
		.MAN_BITS(F32_MAN)
	) fp_class_a32(
		.exp_i(a32_exp),
		.man_i(a32_man),
		.clss_o(a32_class)
	);
	VX_fp_classifier #(
		.EXP_BITS(F32_EXP),
		.MAN_BITS(F32_MAN)
	) fp_class_b32(
		.exp_i(b32_op[30:23]),
		.man_i(b32_op[22:0]),
		.clss_o(b32_class)
	);
	wire a32_smaller = (a32_op < b32_op) ^ (a32_sign || b32_sign);
	wire ab32_equal = (a32_op == b32_op) || (a32_class[5] && b32_class[5]);
	wire a_sign_sel;
	wire b_sign_sel;
	wire [6:0] a_class_sel;
	wire [6:0] b_class_sel;
	wire a_smaller_sel;
	wire ab_equal_sel;
	generate
		if (HAS_D) begin : g_d_order
			wire a64_sign = dataa[63];
			wire b64_sign = datab[63];
			wire [6:0] a64_class;
			wire [6:0] b64_class;
			VX_fp_classifier #(
				.EXP_BITS(F64_EXP),
				.MAN_BITS(F64_MAN)
			) fp_class_a64(
				.exp_i(dataa[62:52]),
				.man_i(dataa[51:0]),
				.clss_o(a64_class)
			);
			VX_fp_classifier #(
				.EXP_BITS(F64_EXP),
				.MAN_BITS(F64_MAN)
			) fp_class_b64(
				.exp_i(datab[62:52]),
				.man_i(datab[51:0]),
				.clss_o(b64_class)
			);
			wire a64_smaller = (dataa < datab) ^ (a64_sign || b64_sign);
			wire ab64_equal = (dataa == datab) || (a64_class[5] && b64_class[5]);
			assign a_sign_sel = (is_d ? a64_sign : a32_sign);
			assign b_sign_sel = (is_d ? b64_sign : b32_sign);
			assign a_class_sel = (is_d ? a64_class : a32_class);
			assign b_class_sel = (is_d ? b64_class : b32_class);
			assign a_smaller_sel = (is_d ? a64_smaller : a32_smaller);
			assign ab_equal_sel = (is_d ? ab64_equal : ab32_equal);
		end
		else begin : g_no_d
			assign a_sign_sel = a32_sign;
			assign b_sign_sel = b32_sign;
			assign a_class_sel = a32_class;
			assign b_class_sel = b32_class;
			assign a_smaller_sel = a32_smaller;
			assign ab_equal_sel = ab32_equal;
		end
	endgenerate
	wire [3:0] op_mod_s0;
	wire [FLEN - 1:0] dataa_s0;
	wire [FLEN - 1:0] datab_s0;
	wire a_sign_s0;
	wire b_sign_s0;
	wire [6:0] a_fclass_s0;
	wire [6:0] b_fclass_s0;
	wire a_smaller_s0;
	wire ab_equal_s0;
	wire is_d_s0;
	wire a32_boxed_s0;
	localparam VX_gpu_pkg_INST_FPU_CMP = 4'b1100;
	wire [3:0] op_mod = {op_type == VX_gpu_pkg_INST_FPU_CMP, frm};
	VX_pipe_register #(
		.DATAW((4 + (2 * FLEN)) + 20),
		.DEPTH(LATENCY > 0)
	) pipe_reg0(
		.clk(clk),
		.reset(reset),
		.enable(enable && mask),
		.data_in({op_mod, dataa, datab, a_sign_sel, b_sign_sel, a_class_sel, b_class_sel, a_smaller_sel, ab_equal_sel, is_d, a32_boxed}),
		.data_out({op_mod_s0, dataa_s0, datab_s0, a_sign_s0, b_sign_s0, a_fclass_s0, b_fclass_s0, a_smaller_s0, ab_equal_s0, is_d_s0, a32_boxed_s0})
	);
	wire [FLEN - 1:0] canon_qnan;
	function automatic [FLEN - 1:0] sv2v_cast_9086B;
		input reg [FLEN - 1:0] inp;
		sv2v_cast_9086B = inp;
	endfunction
	generate
		if (HAS_D) begin : g_qnan_d
			assign canon_qnan = (is_d_s0 ? {1'b0, {F64_EXP {1'b1}}, 1'b1, {51 {1'b0}}} : sv2v_cast_9086B(32'h7fc00000));
		end
		else begin : g_qnan_s
			assign canon_qnan = sv2v_cast_9086B(32'h7fc00000);
		end
	endgenerate
	reg [31:0] fclass_mask_s0;
	always @(*)
		if (a_fclass_s0[6])
			fclass_mask_s0 = (a_sign_s0 ? NEG_NORM : POS_NORM);
		else if (a_fclass_s0[3])
			fclass_mask_s0 = (a_sign_s0 ? NEG_INF : POS_INF);
		else if (a_fclass_s0[5])
			fclass_mask_s0 = (a_sign_s0 ? NEG_ZERO : POS_ZERO);
		else if (a_fclass_s0[4])
			fclass_mask_s0 = (a_sign_s0 ? NEG_SUBNORM : POS_SUBNORM);
		else if (a_fclass_s0[2])
			fclass_mask_s0 = {22'h000000, a_fclass_s0[1], a_fclass_s0[0], 8'h00};
		else
			fclass_mask_s0 = QUT_NAN;
	reg [FLEN - 1:0] fminmax_res_s0;
	always @(*)
		if (a_fclass_s0[2] && b_fclass_s0[2])
			fminmax_res_s0 = canon_qnan;
		else if (a_fclass_s0[2])
			fminmax_res_s0 = datab_s0;
		else if (b_fclass_s0[2])
			fminmax_res_s0 = dataa_s0;
		else
			fminmax_res_s0 = (op_mod_s0[0] ^ a_smaller_s0 ? dataa_s0 : datab_s0);
	reg [FLEN - 1:0] fsgnj_res_s0;
	reg sgnj_sign;
	always @(*)
		case (op_mod_s0[1:0])
			0: sgnj_sign = b_sign_s0;
			1: sgnj_sign = ~b_sign_s0;
			default: sgnj_sign = a_sign_s0 ^ b_sign_s0;
		endcase
	wire [30:0] sgnj_a_payload = (a32_boxed_s0 ? dataa_s0[30:0] : F32_CANON_QNAN[30:0]);
	generate
		if (HAS_D) begin : g_sgnj_d
			wire [FLEN:1] sv2v_tmp_8DF32;
			assign sv2v_tmp_8DF32 = (is_d_s0 ? {sgnj_sign, dataa_s0[62:0]} : sv2v_cast_9086B({sgnj_sign, sgnj_a_payload}));
			always @(*) fsgnj_res_s0 = sv2v_tmp_8DF32;
		end
		else begin : g_sgnj_s
			wire [FLEN:1] sv2v_tmp_83BD9;
			assign sv2v_tmp_83BD9 = {sgnj_sign, sgnj_a_payload};
			always @(*) fsgnj_res_s0 = sv2v_tmp_83BD9;
		end
	endgenerate
	reg fcmp_res_s0;
	reg fcmp_fflags_NV_s0;
	always @(*)
		case (op_mod_s0[1:0])
			0:
				if (a_fclass_s0[2] || b_fclass_s0[2]) begin
					fcmp_res_s0 = 0;
					fcmp_fflags_NV_s0 = 1;
				end
				else begin
					fcmp_res_s0 = a_smaller_s0 | ab_equal_s0;
					fcmp_fflags_NV_s0 = 0;
				end
			1:
				if (a_fclass_s0[2] || b_fclass_s0[2]) begin
					fcmp_res_s0 = 0;
					fcmp_fflags_NV_s0 = 1;
				end
				else begin
					fcmp_res_s0 = a_smaller_s0 & ~ab_equal_s0;
					fcmp_fflags_NV_s0 = 0;
				end
			2:
				if (a_fclass_s0[2] || b_fclass_s0[2]) begin
					fcmp_res_s0 = 0;
					fcmp_fflags_NV_s0 = a_fclass_s0[0] | b_fclass_s0[0];
				end
				else begin
					fcmp_res_s0 = ab_equal_s0;
					fcmp_fflags_NV_s0 = 0;
				end
			default: begin
				fcmp_res_s0 = 1'sbx;
				fcmp_fflags_NV_s0 = 1'sbx;
			end
		endcase
	reg [FLEN - 1:0] result_s0;
	reg fflags_NV_s0;
	always @(*)
		case (op_mod_s0[2:0])
			0, 1, 2: begin
				result_s0 = (op_mod_s0[3] ? sv2v_cast_9086B(fcmp_res_s0) : fsgnj_res_s0);
				fflags_NV_s0 = fcmp_fflags_NV_s0;
			end
			3: begin
				result_s0 = sv2v_cast_9086B(fclass_mask_s0);
				fflags_NV_s0 = 0;
			end
			4, 5: begin
				result_s0 = dataa_s0;
				fflags_NV_s0 = 0;
			end
			6, 7: begin
				result_s0 = fminmax_res_s0;
				fflags_NV_s0 = a_fclass_s0[0] | b_fclass_s0[0];
			end
		endcase
	wire [31:0] result_xlen_s0;
	generate
		if (1) begin : g_no_result_ext
			assign result_xlen_s0 = result_s0;
		end
	endgenerate
	wire fflags_NV;
	VX_pipe_register #(
		.DATAW(33),
		.DEPTH(OUT_REG)
	) pipe_reg1(
		.clk(clk),
		.reset(reset),
		.enable(enable && mask_pipe[LATENCY - 2]),
		.data_in({result_xlen_s0, fflags_NV_s0}),
		.data_out({result, fflags_NV})
	);
	assign fflags = {fflags_NV, 4'b0000};
endmodule
module VX_fp_classifier (
	exp_i,
	man_i,
	clss_o
);
	parameter MAN_BITS = 23;
	parameter EXP_BITS = 8;
	input [EXP_BITS - 1:0] exp_i;
	input [MAN_BITS - 1:0] man_i;
	output wire [6:0] clss_o;
	wire is_normal = (exp_i != {EXP_BITS {1'sb0}}) && (exp_i != {EXP_BITS {1'sb1}});
	wire is_zero = (exp_i == {EXP_BITS {1'sb0}}) && (man_i == {MAN_BITS {1'sb0}});
	wire is_subnormal = (exp_i == {EXP_BITS {1'sb0}}) && (man_i != {MAN_BITS {1'sb0}});
	wire is_inf = (exp_i == {EXP_BITS {1'sb1}}) && (man_i == {MAN_BITS {1'sb0}});
	wire is_nan = (exp_i == {EXP_BITS {1'sb1}}) && (man_i != {MAN_BITS {1'sb0}});
	wire is_signaling = is_nan && ~man_i[MAN_BITS - 1];
	wire is_quiet = is_nan && ~is_signaling;
	assign clss_o[6] = is_normal;
	assign clss_o[5] = is_zero;
	assign clss_o[4] = is_subnormal;
	assign clss_o[3] = is_inf;
	assign clss_o[2] = is_nan;
	assign clss_o[1] = is_quiet;
	assign clss_o[0] = is_signaling;
endmodule
module VX_fp_rounding (
	abs_value_i,
	sign_i,
	round_sticky_bits_i,
	rnd_mode_i,
	effective_subtraction_i,
	abs_rounded_o,
	sign_o,
	exact_zero_o
);
	parameter DAT_WIDTH = 2;
	input wire [DAT_WIDTH - 1:0] abs_value_i;
	input wire sign_i;
	input wire [1:0] round_sticky_bits_i;
	input wire [2:0] rnd_mode_i;
	input wire effective_subtraction_i;
	output wire [DAT_WIDTH - 1:0] abs_rounded_o;
	output wire sign_o;
	output wire exact_zero_o;
	reg round_up;
	localparam VX_gpu_pkg_INST_FRM_RDN = 3'b010;
	localparam VX_gpu_pkg_INST_FRM_RMM = 3'b100;
	localparam VX_gpu_pkg_INST_FRM_RNE = 3'b000;
	localparam VX_gpu_pkg_INST_FRM_RTZ = 3'b001;
	localparam VX_gpu_pkg_INST_FRM_RUP = 3'b011;
	always @(*)
		case (rnd_mode_i)
			VX_gpu_pkg_INST_FRM_RNE:
				case (round_sticky_bits_i)
					2'b00, 2'b01: round_up = 1'b0;
					2'b10: round_up = abs_value_i[0];
					2'b11: round_up = 1'b1;
				endcase
			VX_gpu_pkg_INST_FRM_RTZ: round_up = 1'b0;
			VX_gpu_pkg_INST_FRM_RDN: round_up = |round_sticky_bits_i & sign_i;
			VX_gpu_pkg_INST_FRM_RUP: round_up = |round_sticky_bits_i & ~sign_i;
			VX_gpu_pkg_INST_FRM_RMM: round_up = round_sticky_bits_i[1];
			default: round_up = 1'bx;
		endcase
	function automatic [DAT_WIDTH - 1:0] sv2v_cast_A1DF5;
		input reg [DAT_WIDTH - 1:0] inp;
		sv2v_cast_A1DF5 = inp;
	endfunction
	assign abs_rounded_o = abs_value_i + sv2v_cast_A1DF5(round_up);
	assign exact_zero_o = (abs_value_i == 0) && (round_sticky_bits_i == 0);
	assign sign_o = (exact_zero_o && effective_subtraction_i ? rnd_mode_i == VX_gpu_pkg_INST_FRM_RDN : sign_i);
endmodule
module VX_fpu_dsp (
	clk,
	reset,
	valid_in,
	ready_in,
	mask_in,
	tag_in,
	op_type,
	fmt,
	frm,
	dataa,
	datab,
	datac,
	result,
	has_fflags,
	fflags,
	tag_out,
	ready_out,
	valid_out
);
	parameter NUM_LANES = 4;
	parameter TAG_WIDTH = 4;
	parameter OUT_BUF = 0;
	input wire clk;
	input wire reset;
	input wire valid_in;
	output wire ready_in;
	input wire [NUM_LANES - 1:0] mask_in;
	input wire [TAG_WIDTH - 1:0] tag_in;
	localparam VX_gpu_pkg_INST_FPU_BITS = 4;
	input wire [3:0] op_type;
	localparam VX_gpu_pkg_INST_FMT_BITS = 2;
	input wire [1:0] fmt;
	localparam VX_gpu_pkg_INST_FRM_BITS = 3;
	input wire [2:0] frm;
	input wire [(NUM_LANES * 32) - 1:0] dataa;
	input wire [(NUM_LANES * 32) - 1:0] datab;
	input wire [(NUM_LANES * 32) - 1:0] datac;
	output wire [(NUM_LANES * 32) - 1:0] result;
	output wire has_fflags;
	output wire [4:0] fflags;
	output wire [TAG_WIDTH - 1:0] tag_out;
	input wire ready_out;
	output wire valid_out;
	localparam FPU_FMA = 0;
	localparam FPU_DIVSQRT = 1;
	localparam FPU_CVT = 2;
	localparam FPU_NCP = 3;
	localparam NUM_FPCORES = 4;
	localparam FPCORES_BITS = 2;
	localparam NUM_PES_FMA = ((NUM_LANES / 1) > 0 ? NUM_LANES / 1 : 1);
	localparam NUM_PES_DIV = ((NUM_LANES / 1) > 0 ? NUM_LANES / 1 : 1);
	localparam NUM_PES_SQRT = ((NUM_LANES / 1) > 0 ? NUM_LANES / 1 : 1);
	localparam NUM_PES_CVT = ((NUM_LANES / 1) > 0 ? NUM_LANES / 1 : 1);
	localparam NUM_PES_NCP = ((NUM_LANES / 1) > 0 ? NUM_LANES / 1 : 1);
	localparam CVT_LATENCY = 5;
	localparam REQ_DATAW = ((((NUM_LANES + TAG_WIDTH) + VX_gpu_pkg_INST_FPU_BITS) + VX_gpu_pkg_INST_FMT_BITS) + VX_gpu_pkg_INST_FRM_BITS) + (3 * (NUM_LANES * 32));
	localparam RSP_DATAW = ((NUM_LANES * 32) + 6) + TAG_WIDTH;
	wire [3:0] per_core_valid_in;
	wire [(4 * REQ_DATAW) - 1:0] per_core_data_in;
	wire [3:0] per_core_ready_in;
	wire [(4 * NUM_LANES) - 1:0] per_core_mask_in;
	wire [(4 * TAG_WIDTH) - 1:0] per_core_tag_in;
	wire [15:0] per_core_op_type;
	wire [7:0] per_core_fmt;
	wire [11:0] per_core_frm;
	wire [((4 * NUM_LANES) * 32) - 1:0] per_core_dataa;
	wire [((4 * NUM_LANES) * 32) - 1:0] per_core_datab;
	wire [((4 * NUM_LANES) * 32) - 1:0] per_core_datac;
	wire [3:0] per_core_valid_out;
	wire [((4 * NUM_LANES) * 32) - 1:0] per_core_result;
	wire [(4 * TAG_WIDTH) - 1:0] per_core_tag_out;
	wire [3:0] per_core_has_fflags;
	wire [19:0] per_core_fflags;
	wire [3:0] per_core_ready_out;
	localparam VX_gpu_pkg_INST_FPU_F2F = 4'b1101;
	function automatic signed [1:0] sv2v_cast_2_signed;
		input reg signed [1:0] inp;
		sv2v_cast_2_signed = inp;
	endfunction
	wire [1:0] core_select = (op_type == VX_gpu_pkg_INST_FPU_F2F ? sv2v_cast_2_signed(FPU_CVT) : op_type[3:2]);
	VX_stream_switch #(
		.DATAW(REQ_DATAW),
		.NUM_INPUTS(1),
		.NUM_OUTPUTS(NUM_FPCORES)
	) req_switch(
		.clk(clk),
		.reset(reset),
		.sel_in(core_select),
		.valid_in(valid_in),
		.ready_in(ready_in),
		.data_in({mask_in, tag_in, fmt, frm, dataa, datab, datac, op_type}),
		.data_out(per_core_data_in),
		.valid_out(per_core_valid_in),
		.ready_out(per_core_ready_in)
	);
	genvar _gv_i_118;
	generate
		for (_gv_i_118 = 0; _gv_i_118 < NUM_FPCORES; _gv_i_118 = _gv_i_118 + 1) begin : g_per_core_data_in
			localparam i = _gv_i_118;
			assign {per_core_mask_in[i * NUM_LANES+:NUM_LANES], per_core_tag_in[i * TAG_WIDTH+:TAG_WIDTH], per_core_fmt[i * 2+:2], per_core_frm[i * 3+:3], per_core_dataa[32 * (i * NUM_LANES)+:32 * NUM_LANES], per_core_datab[32 * (i * NUM_LANES)+:32 * NUM_LANES], per_core_datac[32 * (i * NUM_LANES)+:32 * NUM_LANES], per_core_op_type[i * 4+:4]} = per_core_data_in[i * REQ_DATAW+:REQ_DATAW];
		end
		if (1) begin : g_fma
			wire [NUM_LANES - 1:0] mask_out;
			wire [(NUM_LANES * 37) - 1:0] data_out;
			wire pe_enable;
			wire [NUM_PES_FMA - 1:0] pe_mask_out;
			wire [(NUM_PES_FMA * 96) - 1:0] pe_data_in;
			wire [8:0] pe_shared;
			wire [(NUM_PES_FMA * 37) - 1:0] pe_data_out;
			wire [(NUM_LANES * 96) - 1:0] lane_data;
			genvar _gv_i_119;
			for (_gv_i_119 = 0; _gv_i_119 < NUM_LANES; _gv_i_119 = _gv_i_119 + 1) begin : g_lane_data
				localparam i = _gv_i_119;
				assign lane_data[i * 96+:96] = {per_core_datac[(0 + i) * 32+:32], per_core_datab[(0 + i) * 32+:32], per_core_dataa[(0 + i) * 32+:32]};
			end
			VX_pe_serializer #(
				.NUM_LANES(NUM_LANES),
				.NUM_PES(NUM_PES_FMA),
				.LATENCY(8),
				.DATA_IN_WIDTH(96),
				.DATA_OUT_WIDTH(37),
				.SHARED_WIDTH(9),
				.TAG_WIDTH(TAG_WIDTH),
				.PE_REG(0),
				.OUT_BUF(2)
			) pe_ser(
				.clk(clk),
				.reset(reset),
				.valid_in(per_core_valid_in[FPU_FMA]),
				.mask_in(per_core_mask_in[0+:NUM_LANES]),
				.data_in(lane_data),
				.shared_in({per_core_op_type[0+:4], per_core_fmt[0+:2], per_core_frm[0+:3]}),
				.tag_in(per_core_tag_in[0+:TAG_WIDTH]),
				.ready_in(per_core_ready_in[FPU_FMA]),
				.pe_enable(pe_enable),
				.pe_mask_out(pe_mask_out),
				.pe_data_out(pe_data_in),
				.pe_shared_out(pe_shared),
				.pe_data_in(pe_data_out),
				.valid_out(per_core_valid_out[FPU_FMA]),
				.mask_out(mask_out),
				.data_out(data_out),
				.tag_out(per_core_tag_out[0+:TAG_WIDTH]),
				.ready_out(per_core_ready_out[FPU_FMA])
			);
			wire [(NUM_LANES * 5) - 1:0] fflags_lanes;
			genvar _gv_i_120;
			for (_gv_i_120 = 0; _gv_i_120 < NUM_LANES; _gv_i_120 = _gv_i_120 + 1) begin : g_result
				localparam i = _gv_i_120;
				assign per_core_result[(0 + i) * 32+:32] = data_out[i * 37+:32];
				assign fflags_lanes[i * 5+:5] = data_out[(i * 37) + 32+:5];
			end
			wire is_d_in = 1'd0 & pe_shared[3];
			wire is_d_fma;
			if (1) begin : g_isd_s
				assign is_d_fma = 1'b0;
			end
			genvar _gv_i_121;
			for (_gv_i_121 = 0; _gv_i_121 < NUM_PES_FMA; _gv_i_121 = _gv_i_121 + 1) begin : g_units
				localparam i = _gv_i_121;
				wire [31:0] res32;
				wire [4:0] ff32;
				VX_fma_unit #(
					.LATENCY(8),
					.MAN_BITS(23),
					.EXP_BITS(8),
					.USE_DSP(0)
				) fma32(
					.clk(clk),
					.reset(reset),
					.enable(pe_enable),
					.mask(pe_mask_out[i]),
					.op_type(pe_shared[5+:VX_gpu_pkg_INST_FPU_BITS]),
					.fmt(pe_shared[VX_gpu_pkg_INST_FRM_BITS+:VX_gpu_pkg_INST_FMT_BITS]),
					.frm(pe_shared[0+:VX_gpu_pkg_INST_FRM_BITS]),
					.dataa(pe_data_in[i * 96+:32]),
					.datab(pe_data_in[(i * 96) + 32+:32]),
					.datac(pe_data_in[(i * 96) + 64+:32]),
					.result(res32),
					.fflags(ff32)
				);
				if (1) begin : g_fma_s
					if (1) begin : g_no_box
						assign pe_data_out[i * 37+:32] = res32;
					end
					assign pe_data_out[(i * 37) + 32+:5] = ff32;
				end
			end
			assign per_core_has_fflags[FPU_FMA] = 1;
			wire [4:0] merged_fflags;
			reg [4:0] __merged_fflags;
			always @(*) begin
				__merged_fflags = 1'sb0;
				begin : sv2v_autoblock_1
					integer __i;
					for (__i = 0; __i < NUM_LANES; __i = __i + 1)
						if (mask_out[__i]) begin
							__merged_fflags[0] = __merged_fflags[0] | fflags_lanes[__i * 5];
							__merged_fflags[1] = __merged_fflags[1] | fflags_lanes[(__i * 5) + 1];
							__merged_fflags[2] = __merged_fflags[2] | fflags_lanes[(__i * 5) + 2];
							__merged_fflags[3] = __merged_fflags[3] | fflags_lanes[(__i * 5) + 3];
							__merged_fflags[4] = __merged_fflags[4] | fflags_lanes[(__i * 5) + 4];
						end
				end
			end
			assign merged_fflags = __merged_fflags;
			assign per_core_fflags[0+:5] = merged_fflags;
		end
		if (1) begin : g_fdivsqrt
			localparam PATH_REQ_DATAW = (((NUM_LANES + TAG_WIDTH) + VX_gpu_pkg_INST_FMT_BITS) + VX_gpu_pkg_INST_FRM_BITS) + (2 * (NUM_LANES * 32));
			localparam PATH_RSP_DATAW = ((NUM_LANES * 32) + 6) + TAG_WIDTH;
			wire is_sqrt = per_core_op_type[4];
			wire [1:0] path_valid_in;
			wire [(2 * PATH_REQ_DATAW) - 1:0] path_data_in;
			wire [1:0] path_ready_in;
			wire [(2 * NUM_LANES) - 1:0] path_mask;
			wire [(2 * TAG_WIDTH) - 1:0] path_tag;
			wire [3:0] path_fmt;
			wire [5:0] path_frm;
			wire [((2 * NUM_LANES) * 32) - 1:0] path_dataa;
			wire [((2 * NUM_LANES) * 32) - 1:0] path_datab;
			VX_stream_switch #(
				.DATAW(PATH_REQ_DATAW),
				.NUM_INPUTS(1),
				.NUM_OUTPUTS(2),
				.OUT_BUF(0)
			) req_switch(
				.clk(clk),
				.reset(reset),
				.sel_in(is_sqrt),
				.valid_in(per_core_valid_in[FPU_DIVSQRT]),
				.ready_in(per_core_ready_in[FPU_DIVSQRT]),
				.data_in({per_core_mask_in[FPU_DIVSQRT * NUM_LANES+:NUM_LANES], per_core_tag_in[FPU_DIVSQRT * TAG_WIDTH+:TAG_WIDTH], per_core_fmt[2+:2], per_core_frm[3+:3], per_core_dataa[32 * (FPU_DIVSQRT * NUM_LANES)+:32 * NUM_LANES], per_core_datab[32 * (FPU_DIVSQRT * NUM_LANES)+:32 * NUM_LANES]}),
				.data_out(path_data_in),
				.valid_out(path_valid_in),
				.ready_out(path_ready_in)
			);
			genvar _gv_i_122;
			for (_gv_i_122 = 0; _gv_i_122 < 2; _gv_i_122 = _gv_i_122 + 1) begin : g_unpack
				localparam i = _gv_i_122;
				assign {path_mask[i * NUM_LANES+:NUM_LANES], path_tag[i * TAG_WIDTH+:TAG_WIDTH], path_fmt[i * 2+:2], path_frm[i * 3+:3], path_dataa[32 * (i * NUM_LANES)+:32 * NUM_LANES], path_datab[32 * (i * NUM_LANES)+:32 * NUM_LANES]} = path_data_in[i * PATH_REQ_DATAW+:PATH_REQ_DATAW];
			end
			wire [1:0] path_valid_out;
			wire [(2 * PATH_RSP_DATAW) - 1:0] path_data_out;
			wire [1:0] path_ready_out;
			wire [TAG_WIDTH - 1:0] div_tag_out;
			wire [NUM_LANES - 1:0] div_mask_out;
			wire [(NUM_LANES * 37) - 1:0] div_data_out;
			wire div_pe_enable;
			wire [NUM_PES_DIV - 1:0] div_pe_mask_out;
			wire [(NUM_PES_DIV * 64) - 1:0] div_pe_data_in;
			wire [4:0] div_pe_shared;
			wire [(NUM_PES_DIV * 37) - 1:0] div_pe_data_out;
			wire [(NUM_LANES * 64) - 1:0] div_lane_data;
			genvar _gv_i_123;
			for (_gv_i_123 = 0; _gv_i_123 < NUM_LANES; _gv_i_123 = _gv_i_123 + 1) begin : g_div_lane_data
				localparam i = _gv_i_123;
				assign div_lane_data[i * 64+:64] = {path_datab[(0 + i) * 32+:32], path_dataa[(0 + i) * 32+:32]};
			end
			VX_pe_serializer #(
				.NUM_LANES(NUM_LANES),
				.NUM_PES(NUM_PES_DIV),
				.LATENCY(17),
				.DATA_IN_WIDTH(64),
				.DATA_OUT_WIDTH(37),
				.SHARED_WIDTH(5),
				.TAG_WIDTH(TAG_WIDTH),
				.PE_REG(0),
				.OUT_BUF(2)
			) div_pe_ser(
				.clk(clk),
				.reset(reset),
				.valid_in(path_valid_in[0]),
				.mask_in(path_mask[0+:NUM_LANES]),
				.data_in(div_lane_data),
				.shared_in({path_fmt[0+:2], path_frm[0+:3]}),
				.tag_in(path_tag[0+:TAG_WIDTH]),
				.ready_in(path_ready_in[0]),
				.pe_enable(div_pe_enable),
				.pe_mask_out(div_pe_mask_out),
				.pe_data_out(div_pe_data_in),
				.pe_shared_out(div_pe_shared),
				.pe_data_in(div_pe_data_out),
				.valid_out(path_valid_out[0]),
				.mask_out(div_mask_out),
				.data_out(div_data_out),
				.tag_out(div_tag_out),
				.ready_out(path_ready_out[0])
			);
			wire [(NUM_LANES * 5) - 1:0] div_fflags_lanes;
			wire [(NUM_LANES * 32) - 1:0] div_result;
			genvar _gv_i_124;
			for (_gv_i_124 = 0; _gv_i_124 < NUM_LANES; _gv_i_124 = _gv_i_124 + 1) begin : g_div_result
				localparam i = _gv_i_124;
				assign div_result[i * 32+:32] = div_data_out[i * 37+:32];
				assign div_fflags_lanes[i * 5+:5] = div_data_out[(i * 37) + 32+:5];
			end
			wire div_has_fflags;
			genvar _gv_i_125;
			for (_gv_i_125 = 0; _gv_i_125 < NUM_PES_DIV; _gv_i_125 = _gv_i_125 + 1) begin : g_div_units
				localparam i = _gv_i_125;
				VX_fdivsqrt_unit #(
					.LATENCY(17),
					.FLEN(32)
				) fdiv_unit(
					.clk(clk),
					.reset(reset),
					.enable(div_pe_enable),
					.mask(div_pe_mask_out[i]),
					.fmt(div_pe_shared[VX_gpu_pkg_INST_FRM_BITS+:VX_gpu_pkg_INST_FMT_BITS]),
					.frm(div_pe_shared[0+:VX_gpu_pkg_INST_FRM_BITS]),
					.dataa(div_pe_data_in[i * 64+:32]),
					.datab(div_pe_data_in[(i * 64) + 32+:32]),
					.is_sqrt(1'b0),
					.result(div_pe_data_out[i * 37+:32]),
					.fflags(div_pe_data_out[(i * 37) + 32+:5])
				);
			end
			assign div_has_fflags = 1;
			wire [4:0] div_merged_fflags;
			reg [4:0] __div_merged_fflags;
			always @(*) begin
				__div_merged_fflags = 1'sb0;
				begin : sv2v_autoblock_2
					integer __i;
					for (__i = 0; __i < NUM_LANES; __i = __i + 1)
						if (div_mask_out[__i]) begin
							__div_merged_fflags[0] = __div_merged_fflags[0] | div_fflags_lanes[__i * 5];
							__div_merged_fflags[1] = __div_merged_fflags[1] | div_fflags_lanes[(__i * 5) + 1];
							__div_merged_fflags[2] = __div_merged_fflags[2] | div_fflags_lanes[(__i * 5) + 2];
							__div_merged_fflags[3] = __div_merged_fflags[3] | div_fflags_lanes[(__i * 5) + 3];
							__div_merged_fflags[4] = __div_merged_fflags[4] | div_fflags_lanes[(__i * 5) + 4];
						end
				end
			end
			assign div_merged_fflags = __div_merged_fflags;
			assign path_data_out[0+:PATH_RSP_DATAW] = {div_result, div_has_fflags, div_merged_fflags, div_tag_out};
			wire [TAG_WIDTH - 1:0] sqrt_tag_out;
			wire [NUM_LANES - 1:0] sqrt_mask_out;
			wire [(NUM_LANES * 37) - 1:0] sqrt_data_out;
			wire sqrt_pe_enable;
			wire [NUM_PES_SQRT - 1:0] sqrt_pe_mask_out;
			wire [(NUM_PES_SQRT * 32) - 1:0] sqrt_pe_data_in;
			wire [4:0] sqrt_pe_shared;
			wire [(NUM_PES_SQRT * 37) - 1:0] sqrt_pe_data_out;
			VX_pe_serializer #(
				.NUM_LANES(NUM_LANES),
				.NUM_PES(NUM_PES_SQRT),
				.LATENCY(17),
				.DATA_IN_WIDTH(32),
				.DATA_OUT_WIDTH(37),
				.SHARED_WIDTH(5),
				.TAG_WIDTH(TAG_WIDTH),
				.PE_REG(0),
				.OUT_BUF(2)
			) sqrt_pe_ser(
				.clk(clk),
				.reset(reset),
				.valid_in(path_valid_in[1]),
				.mask_in(path_mask[NUM_LANES+:NUM_LANES]),
				.data_in(path_dataa[32 * NUM_LANES+:32 * NUM_LANES]),
				.shared_in({path_fmt[2+:2], path_frm[3+:3]}),
				.tag_in(path_tag[TAG_WIDTH+:TAG_WIDTH]),
				.ready_in(path_ready_in[1]),
				.pe_enable(sqrt_pe_enable),
				.pe_mask_out(sqrt_pe_mask_out),
				.pe_data_out(sqrt_pe_data_in),
				.pe_shared_out(sqrt_pe_shared),
				.pe_data_in(sqrt_pe_data_out),
				.valid_out(path_valid_out[1]),
				.mask_out(sqrt_mask_out),
				.data_out(sqrt_data_out),
				.tag_out(sqrt_tag_out),
				.ready_out(path_ready_out[1])
			);
			wire [(NUM_LANES * 5) - 1:0] sqrt_fflags_lanes;
			wire [(NUM_LANES * 32) - 1:0] sqrt_result;
			genvar _gv_i_126;
			for (_gv_i_126 = 0; _gv_i_126 < NUM_LANES; _gv_i_126 = _gv_i_126 + 1) begin : g_sqrt_result
				localparam i = _gv_i_126;
				assign sqrt_result[i * 32+:32] = sqrt_data_out[i * 37+:32];
				assign sqrt_fflags_lanes[i * 5+:5] = sqrt_data_out[(i * 37) + 32+:5];
			end
			wire sqrt_has_fflags;
			genvar _gv_i_127;
			for (_gv_i_127 = 0; _gv_i_127 < NUM_PES_SQRT; _gv_i_127 = _gv_i_127 + 1) begin : g_sqrt_units
				localparam i = _gv_i_127;
				VX_fdivsqrt_unit #(
					.LATENCY(17),
					.FLEN(32)
				) fsqrt_unit(
					.clk(clk),
					.reset(reset),
					.enable(sqrt_pe_enable),
					.mask(sqrt_pe_mask_out[i]),
					.fmt(sqrt_pe_shared[VX_gpu_pkg_INST_FRM_BITS+:VX_gpu_pkg_INST_FMT_BITS]),
					.frm(sqrt_pe_shared[0+:VX_gpu_pkg_INST_FRM_BITS]),
					.dataa(sqrt_pe_data_in[i * 32+:32]),
					.datab(32'b00000000000000000000000000000000),
					.is_sqrt(1'b1),
					.result(sqrt_pe_data_out[i * 37+:32]),
					.fflags(sqrt_pe_data_out[(i * 37) + 32+:5])
				);
			end
			assign sqrt_has_fflags = 1;
			wire [4:0] sqrt_merged_fflags;
			reg [4:0] __sqrt_merged_fflags;
			always @(*) begin
				__sqrt_merged_fflags = 1'sb0;
				begin : sv2v_autoblock_3
					integer __i;
					for (__i = 0; __i < NUM_LANES; __i = __i + 1)
						if (sqrt_mask_out[__i]) begin
							__sqrt_merged_fflags[0] = __sqrt_merged_fflags[0] | sqrt_fflags_lanes[__i * 5];
							__sqrt_merged_fflags[1] = __sqrt_merged_fflags[1] | sqrt_fflags_lanes[(__i * 5) + 1];
							__sqrt_merged_fflags[2] = __sqrt_merged_fflags[2] | sqrt_fflags_lanes[(__i * 5) + 2];
							__sqrt_merged_fflags[3] = __sqrt_merged_fflags[3] | sqrt_fflags_lanes[(__i * 5) + 3];
							__sqrt_merged_fflags[4] = __sqrt_merged_fflags[4] | sqrt_fflags_lanes[(__i * 5) + 4];
						end
				end
			end
			assign sqrt_merged_fflags = __sqrt_merged_fflags;
			assign path_data_out[PATH_RSP_DATAW+:PATH_RSP_DATAW] = {sqrt_result, sqrt_has_fflags, sqrt_merged_fflags, sqrt_tag_out};
			VX_stream_arb #(
				.NUM_INPUTS(2),
				.DATAW(PATH_RSP_DATAW),
				.ARBITER("P"),
				.OUT_BUF(0)
			) rsp_arb(
				.clk(clk),
				.reset(reset),
				.valid_in(path_valid_out),
				.ready_in(path_ready_out),
				.data_in(path_data_out),
				.data_out({per_core_result[32 * (FPU_DIVSQRT * NUM_LANES)+:32 * NUM_LANES], per_core_has_fflags[FPU_DIVSQRT], per_core_fflags[5+:5], per_core_tag_out[FPU_DIVSQRT * TAG_WIDTH+:TAG_WIDTH]}),
				.valid_out(per_core_valid_out[FPU_DIVSQRT]),
				.ready_out(per_core_ready_out[FPU_DIVSQRT]),
				.sel_out()
			);
		end
		if (1) begin : g_cvt
			wire [NUM_LANES - 1:0] mask_out;
			wire [(NUM_LANES * 37) - 1:0] data_out;
			wire pe_enable;
			wire [NUM_PES_CVT - 1:0] pe_mask_out;
			wire [(NUM_PES_CVT * 32) - 1:0] pe_data_in;
			wire [8:0] pe_shared;
			wire [(NUM_PES_CVT * 37) - 1:0] pe_data_out;
			VX_pe_serializer #(
				.NUM_LANES(NUM_LANES),
				.NUM_PES(NUM_PES_CVT),
				.LATENCY(CVT_LATENCY),
				.DATA_IN_WIDTH(32),
				.DATA_OUT_WIDTH(37),
				.SHARED_WIDTH(9),
				.TAG_WIDTH(TAG_WIDTH),
				.PE_REG(0),
				.OUT_BUF(2)
			) pe_ser(
				.clk(clk),
				.reset(reset),
				.valid_in(per_core_valid_in[FPU_CVT]),
				.mask_in(per_core_mask_in[FPU_CVT * NUM_LANES+:NUM_LANES]),
				.data_in(per_core_dataa[32 * (FPU_CVT * NUM_LANES)+:32 * NUM_LANES]),
				.shared_in({per_core_op_type[8+:4], per_core_fmt[4+:2], per_core_frm[6+:3]}),
				.tag_in(per_core_tag_in[FPU_CVT * TAG_WIDTH+:TAG_WIDTH]),
				.ready_in(per_core_ready_in[FPU_CVT]),
				.pe_enable(pe_enable),
				.pe_mask_out(pe_mask_out),
				.pe_data_out(pe_data_in),
				.pe_shared_out(pe_shared),
				.pe_data_in(pe_data_out),
				.valid_out(per_core_valid_out[FPU_CVT]),
				.mask_out(mask_out),
				.data_out(data_out),
				.tag_out(per_core_tag_out[FPU_CVT * TAG_WIDTH+:TAG_WIDTH]),
				.ready_out(per_core_ready_out[FPU_CVT])
			);
			wire [(NUM_LANES * 5) - 1:0] fflags_lanes;
			genvar _gv_i_128;
			for (_gv_i_128 = 0; _gv_i_128 < NUM_LANES; _gv_i_128 = _gv_i_128 + 1) begin : g_result
				localparam i = _gv_i_128;
				assign per_core_result[((FPU_CVT * NUM_LANES) + i) * 32+:32] = data_out[i * 37+:32];
				assign fflags_lanes[i * 5+:5] = data_out[(i * 37) + 32+:5];
			end
			genvar _gv_i_129;
			for (_gv_i_129 = 0; _gv_i_129 < NUM_PES_CVT; _gv_i_129 = _gv_i_129 + 1) begin : g_units
				localparam i = _gv_i_129;
				wire [2:0] pe_frm = pe_shared[0+:VX_gpu_pkg_INST_FRM_BITS];
				wire [1:0] pe_fmt = pe_shared[VX_gpu_pkg_INST_FRM_BITS+:VX_gpu_pkg_INST_FMT_BITS];
				wire [3:0] pe_op = pe_shared[5+:VX_gpu_pkg_INST_FPU_BITS];
				wire is_f2f = pe_op == VX_gpu_pkg_INST_FPU_F2F;
				wire is_itof = pe_op[1] & ~is_f2f;
				wire is_ftoi = ~pe_op[1] & ~is_f2f;
				wire is_signed = ~pe_op[0];
				wire is_int64 = pe_fmt[1];
				wire src_fmt = (is_f2f ? ~pe_fmt[0] : pe_fmt[0]);
				wire dst_fmt = pe_fmt[0];
				VX_fcvt_unit #(
					.LATENCY(CVT_LATENCY),
					.FLEN(32),
					.OUT_REG(1)
				) fcvt_unit(
					.clk(clk),
					.reset(reset),
					.enable(pe_enable),
					.mask(pe_mask_out[i]),
					.frm(pe_frm),
					.is_itof(is_itof),
					.is_ftoi(is_ftoi),
					.is_f2f(is_f2f),
					.is_signed(is_signed),
					.is_int64(is_int64),
					.src_fmt(src_fmt),
					.dst_fmt(dst_fmt),
					.dataa(pe_data_in[i * 32+:32]),
					.result(pe_data_out[i * 37+:32]),
					.fflags(pe_data_out[(i * 37) + 32+:5])
				);
			end
			assign per_core_has_fflags[FPU_CVT] = 1;
			wire [4:0] merged_fflags;
			reg [4:0] __merged_fflags;
			always @(*) begin
				__merged_fflags = 1'sb0;
				begin : sv2v_autoblock_4
					integer __i;
					for (__i = 0; __i < NUM_LANES; __i = __i + 1)
						if (mask_out[__i]) begin
							__merged_fflags[0] = __merged_fflags[0] | fflags_lanes[__i * 5];
							__merged_fflags[1] = __merged_fflags[1] | fflags_lanes[(__i * 5) + 1];
							__merged_fflags[2] = __merged_fflags[2] | fflags_lanes[(__i * 5) + 2];
							__merged_fflags[3] = __merged_fflags[3] | fflags_lanes[(__i * 5) + 3];
							__merged_fflags[4] = __merged_fflags[4] | fflags_lanes[(__i * 5) + 4];
						end
				end
			end
			assign merged_fflags = __merged_fflags;
			assign per_core_fflags[10+:5] = merged_fflags;
		end
		if (1) begin : g_ncp
			wire [NUM_LANES - 1:0] mask_out;
			wire [(NUM_LANES * 37) - 1:0] data_out;
			wire pe_enable;
			wire [NUM_PES_NCP - 1:0] pe_mask_out;
			wire [(NUM_PES_NCP * 64) - 1:0] pe_data_in;
			wire [8:0] pe_shared;
			wire [(NUM_PES_NCP * 37) - 1:0] pe_data_out;
			wire [(NUM_LANES * 64) - 1:0] lane_data;
			genvar _gv_i_130;
			for (_gv_i_130 = 0; _gv_i_130 < NUM_LANES; _gv_i_130 = _gv_i_130 + 1) begin : g_lane_data
				localparam i = _gv_i_130;
				assign lane_data[i * 64+:64] = {per_core_datab[((FPU_NCP * NUM_LANES) + i) * 32+:32], per_core_dataa[((FPU_NCP * NUM_LANES) + i) * 32+:32]};
			end
			VX_pe_serializer #(
				.NUM_LANES(NUM_LANES),
				.NUM_PES(NUM_PES_NCP),
				.LATENCY(2),
				.DATA_IN_WIDTH(64),
				.DATA_OUT_WIDTH(37),
				.SHARED_WIDTH(9),
				.TAG_WIDTH(TAG_WIDTH),
				.PE_REG(0),
				.OUT_BUF(2)
			) pe_ser(
				.clk(clk),
				.reset(reset),
				.valid_in(per_core_valid_in[FPU_NCP]),
				.mask_in(per_core_mask_in[FPU_NCP * NUM_LANES+:NUM_LANES]),
				.data_in(lane_data),
				.shared_in({per_core_op_type[12+:4], per_core_fmt[6+:2], per_core_frm[9+:3]}),
				.tag_in(per_core_tag_in[FPU_NCP * TAG_WIDTH+:TAG_WIDTH]),
				.ready_in(per_core_ready_in[FPU_NCP]),
				.pe_enable(pe_enable),
				.pe_mask_out(pe_mask_out),
				.pe_data_out(pe_data_in),
				.pe_shared_out(pe_shared),
				.pe_data_in(pe_data_out),
				.valid_out(per_core_valid_out[FPU_NCP]),
				.mask_out(mask_out),
				.data_out(data_out),
				.tag_out(per_core_tag_out[FPU_NCP * TAG_WIDTH+:TAG_WIDTH]),
				.ready_out(per_core_ready_out[FPU_NCP])
			);
			wire [(NUM_LANES * 5) - 1:0] fflags_lanes;
			genvar _gv_i_131;
			for (_gv_i_131 = 0; _gv_i_131 < NUM_LANES; _gv_i_131 = _gv_i_131 + 1) begin : g_result
				localparam i = _gv_i_131;
				assign per_core_result[((FPU_NCP * NUM_LANES) + i) * 32+:32] = data_out[i * 37+:32];
				assign fflags_lanes[i * 5+:5] = data_out[(i * 37) + 32+:5];
			end
			genvar _gv_i_132;
			for (_gv_i_132 = 0; _gv_i_132 < NUM_PES_NCP; _gv_i_132 = _gv_i_132 + 1) begin : g_units
				localparam i = _gv_i_132;
				VX_fncp_unit #(
					.LATENCY(2),
					.FLEN(32),
					.OUT_REG(1)
				) fncp_unit(
					.clk(clk),
					.reset(reset),
					.enable(pe_enable),
					.mask(pe_mask_out[i]),
					.frm(pe_shared[0+:VX_gpu_pkg_INST_FRM_BITS]),
					.fmt(pe_shared[VX_gpu_pkg_INST_FRM_BITS+:VX_gpu_pkg_INST_FMT_BITS]),
					.op_type(pe_shared[5+:VX_gpu_pkg_INST_FPU_BITS]),
					.dataa(pe_data_in[i * 64+:32]),
					.datab(pe_data_in[(i * 64) + 32+:32]),
					.result(pe_data_out[i * 37+:32]),
					.fflags(pe_data_out[(i * 37) + 32+:5])
				);
			end
			assign per_core_has_fflags[FPU_NCP] = 1;
			wire [4:0] merged_fflags;
			reg [4:0] __merged_fflags;
			always @(*) begin
				__merged_fflags = 1'sb0;
				begin : sv2v_autoblock_5
					integer __i;
					for (__i = 0; __i < NUM_LANES; __i = __i + 1)
						if (mask_out[__i]) begin
							__merged_fflags[0] = __merged_fflags[0] | fflags_lanes[__i * 5];
							__merged_fflags[1] = __merged_fflags[1] | fflags_lanes[(__i * 5) + 1];
							__merged_fflags[2] = __merged_fflags[2] | fflags_lanes[(__i * 5) + 2];
							__merged_fflags[3] = __merged_fflags[3] | fflags_lanes[(__i * 5) + 3];
							__merged_fflags[4] = __merged_fflags[4] | fflags_lanes[(__i * 5) + 4];
						end
				end
			end
			assign merged_fflags = __merged_fflags;
			assign per_core_fflags[15+:5] = merged_fflags;
		end
	endgenerate
	reg [(4 * RSP_DATAW) - 1:0] per_core_data_out;
	always @(*) begin : sv2v_autoblock_6
		integer i;
		for (i = 0; i < NUM_FPCORES; i = i + 1)
			per_core_data_out[i * RSP_DATAW+:RSP_DATAW] = {per_core_result[32 * (i * NUM_LANES)+:32 * NUM_LANES], per_core_has_fflags[i], per_core_fflags[i * 5+:5], per_core_tag_out[i * TAG_WIDTH+:TAG_WIDTH]};
	end
	VX_stream_arb #(
		.NUM_INPUTS(NUM_FPCORES),
		.DATAW(RSP_DATAW),
		.ARBITER("R"),
		.OUT_BUF(OUT_BUF)
	) rsp_arb(
		.clk(clk),
		.reset(reset),
		.valid_in(per_core_valid_out),
		.ready_in(per_core_ready_out),
		.data_in(per_core_data_out),
		.data_out({result, has_fflags, fflags, tag_out}),
		.valid_out(valid_out),
		.ready_out(ready_out),
		.sel_out()
	);
endmodule
module VX_allocator (
	clk,
	reset,
	acquire_en,
	acquire_addr,
	release_en,
	release_addr,
	empty,
	full
);
	parameter SIZE = 1;
	parameter ADDRW = (SIZE > 1 ? $clog2(SIZE) : 1);
	input wire clk;
	input wire reset;
	input wire acquire_en;
	output wire [ADDRW - 1:0] acquire_addr;
	input wire release_en;
	input wire [ADDRW - 1:0] release_addr;
	output wire empty;
	output wire full;
	reg [SIZE - 1:0] free_slots;
	reg [SIZE - 1:0] free_slots_n;
	reg [ADDRW - 1:0] acquire_addr_r;
	reg empty_r;
	reg full_r;
	wire [ADDRW - 1:0] free_index;
	wire free_valid;
	always @(*) begin
		free_slots_n = free_slots;
		if (release_en)
			free_slots_n[release_addr] = 1;
		if (acquire_en)
			free_slots_n[acquire_addr_r] = 0;
	end
	VX_priority_encoder #(.N(SIZE)) free_slots_sel(
		.data_in(free_slots_n),
		.index_out(free_index),
		.valid_out(free_valid),
		.onehot_out()
	);
	function automatic [ADDRW - 1:0] sv2v_cast_12D70;
		input reg [ADDRW - 1:0] inp;
		sv2v_cast_12D70 = inp;
	endfunction
	always @(posedge clk)
		if (reset) begin
			acquire_addr_r <= sv2v_cast_12D70(1'b0);
			free_slots <= {SIZE {1'b1}};
			empty_r <= 1'b1;
			full_r <= 1'b0;
		end
		else begin
			if (release_en)
				;
			if (acquire_en)
				;
			if (acquire_en || (release_en && full_r))
				acquire_addr_r <= free_index;
			free_slots <= free_slots_n;
			empty_r <= &free_slots_n;
			full_r <= ~free_valid;
		end
	assign acquire_addr = acquire_addr_r;
	assign empty = empty_r;
	assign full = full_r;
endmodule
module VX_bits_insert (
	data_in,
	ins_in,
	data_out
);
	parameter N = 1;
	parameter S = 1;
	parameter POS = 0;
	input wire [N - 1:0] data_in;
	input wire [(S > 0 ? S : 1) - 1:0] ins_in;
	output wire [(N + S) - 1:0] data_out;
	generate
		if (S == 0) begin : g_passthru
			assign data_out = data_in;
		end
		else begin : g_insert
			if (POS == 0) begin : g_pos_0
				assign data_out = {data_in, ins_in};
			end
			else if (POS == N) begin : g_pos_N
				assign data_out = {ins_in, data_in};
			end
			else begin : g_pos
				assign data_out = {data_in[N - 1:POS], ins_in, data_in[POS - 1:0]};
			end
		end
	endgenerate
endmodule
module VX_bits_remove (
	data_in,
	sel_out,
	data_out
);
	parameter N = 2;
	parameter S = 1;
	parameter POS = 0;
	input wire [N - 1:0] data_in;
	output wire [(S > 0 ? S : 1) - 1:0] sel_out;
	output wire [(N - S) - 1:0] data_out;
	generate
		if (S == 0) begin : g_passthru
			assign sel_out = 0;
			assign data_out = data_in;
		end
		else if (POS == 0) begin : g_pos_0
			assign sel_out = data_in[0+:S];
			assign data_out = data_in[N - 1:S];
		end
		else if ((POS + S) == N) begin : g_pos_N
			assign sel_out = data_in[POS+:S];
			assign data_out = data_in[POS - 1:0];
		end
		else begin : g_pos
			assign sel_out = data_in[POS+:S];
			assign data_out = {data_in[N - 1:POS + S], data_in[POS - 1:0]};
		end
	endgenerate
endmodule
module FullAdder (
	a,
	b,
	cin,
	sum,
	cout
);
	input wire a;
	input wire b;
	input wire cin;
	output wire sum;
	output wire cout;
	assign sum = (a ^ b) ^ cin;
	assign cout = (a & b) | ((a ^ b) & cin);
endmodule
module VX_csa_32 (
	a,
	b,
	c,
	sum,
	carry
);
	parameter N = 3;
	parameter WIDTH_O = N + 2;
	input wire [N - 1:0] a;
	input wire [N - 1:0] b;
	input wire [N - 1:0] c;
	output wire [WIDTH_O - 1:0] sum;
	output wire [WIDTH_O - 1:0] carry;
	wire [N - 1:0] sum_int;
	wire [N - 1:0] carry_int;
	genvar _gv_i_147;
	generate
		for (_gv_i_147 = 0; _gv_i_147 < N; _gv_i_147 = _gv_i_147 + 1) begin : g_compress_3_2
			localparam i = _gv_i_147;
			FullAdder FA(
				.a(a[i]),
				.b(b[i]),
				.cin(c[i]),
				.sum(sum_int[i]),
				.cout(carry_int[i])
			);
		end
	endgenerate
	function automatic [WIDTH_O - 1:0] sv2v_cast_66789;
		input reg [WIDTH_O - 1:0] inp;
		sv2v_cast_66789 = inp;
	endfunction
	assign sum = sv2v_cast_66789(sum_int);
	assign carry = sv2v_cast_66789({1'b0, carry_int, 1'b0});
endmodule
module counter_5to3 (
	x1,
	x2,
	x3,
	x4,
	cin,
	sum,
	carry,
	cout
);
	input wire x1;
	input wire x2;
	input wire x3;
	input wire x4;
	input wire cin;
	output wire sum;
	output wire carry;
	output wire cout;
	wire s1 = (x1 ^ x2) ^ x3;
	assign cout = ((x1 & x2) | (x2 & x3)) | (x1 & x3);
	assign sum = (s1 ^ x4) ^ cin;
	assign carry = ((s1 & x4) | (x4 & cin)) | (s1 & cin);
endmodule
module VX_csa_42 (
	a,
	b,
	c,
	d,
	sum,
	carry
);
	parameter N = 4;
	parameter WIDTH_O = N + 2;
	input wire [N - 1:0] a;
	input wire [N - 1:0] b;
	input wire [N - 1:0] c;
	input wire [N - 1:0] d;
	output wire [WIDTH_O - 1:0] sum;
	output wire [WIDTH_O - 1:0] carry;
	wire [N - 1:0] sum_int;
	wire [N:0] cin;
	wire [N - 1:0] cout;
	wire [N - 1:0] carry_int;
	assign cin[0] = 1'b0;
	genvar _gv_i_148;
	generate
		for (_gv_i_148 = 0; _gv_i_148 < N; _gv_i_148 = _gv_i_148 + 1) begin : g_compress_4_2
			localparam i = _gv_i_148;
			counter_5to3 u_counter_5to3(
				.x1(a[i]),
				.x2(b[i]),
				.x3(c[i]),
				.x4(d[i]),
				.cin(cin[i]),
				.sum(sum_int[i]),
				.carry(carry_int[i]),
				.cout(cout[i])
			);
			assign cin[i + 1] = cout[i];
		end
	endgenerate
	wire [1:0] carry_temp;
	function automatic [WIDTH_O - 1:0] sv2v_cast_66789;
		input reg [WIDTH_O - 1:0] inp;
		sv2v_cast_66789 = inp;
	endfunction
	assign sum = sv2v_cast_66789(sum_int);
	assign carry_temp = {carry_int[N - 1] & cin[N], carry_int[N - 1] ^ cin[N]};
	assign carry = sv2v_cast_66789({carry_temp, carry_int[N - 2:0], 1'b0});
endmodule
module VX_csa_block (
	operands,
	sum,
	carry
);
	parameter N = 4;
	parameter W = 8;
	parameter S = W + $clog2(N);
	input wire [(N * W) - 1:0] operands;
	output wire [S - 1:0] sum;
	output wire [S - 1:0] carry;
	function automatic integer calc_4to2_levels;
		input integer n;
		integer remaining;
		integer levels_4to2;
		begin
			remaining = n;
			levels_4to2 = 0;
			while (remaining >= 4) begin
				levels_4to2 = levels_4to2 + 1;
				remaining = remaining - 2;
			end
			calc_4to2_levels = levels_4to2;
		end
	endfunction
	localparam LEVELS_4TO2 = calc_4to2_levels(N);
	localparam TOTAL_LEVELS = LEVELS_4TO2 + ((N - (LEVELS_4TO2 * 2)) == 3 ? 1 : 0);
	localparam WN_CALC = (W + TOTAL_LEVELS) + 2;
	localparam WN = (WN_CALC > S ? WN_CALC : S);
	wire [WN - 1:0] St [0:TOTAL_LEVELS];
	wire [WN - 1:0] Ct [0:TOTAL_LEVELS];
	function automatic [WN - 1:0] sv2v_cast_30DC1;
		input reg [WN - 1:0] inp;
		sv2v_cast_30DC1 = inp;
	endfunction
	assign St[0] = sv2v_cast_30DC1(operands[0+:W]);
	assign Ct[0] = sv2v_cast_30DC1(operands[W+:W]);
	genvar _gv_i_151;
	generate
		for (_gv_i_151 = 0; _gv_i_151 < LEVELS_4TO2; _gv_i_151 = _gv_i_151 + 1) begin : g_4to2_levels
			localparam i = _gv_i_151;
			localparam WI = W + i;
			localparam WO = WI + 2;
			localparam OP_A_IDX = 2 + (i * 2);
			localparam OP_B_IDX = 3 + (i * 2);
			wire [WO - 1:0] st;
			wire [WO - 1:0] ct;
			function automatic [WI - 1:0] sv2v_cast_BC15F;
				input reg [WI - 1:0] inp;
				sv2v_cast_BC15F = inp;
			endfunction
			VX_csa_42 #(
				.N(WI),
				.WIDTH_O(WO)
			) csa_42(
				.a(sv2v_cast_BC15F(St[i])),
				.b(sv2v_cast_BC15F(Ct[i])),
				.c(sv2v_cast_BC15F(operands[OP_A_IDX * W+:W])),
				.d(sv2v_cast_BC15F(operands[OP_B_IDX * W+:W])),
				.sum(st),
				.carry(ct)
			);
			assign St[i + 1] = sv2v_cast_30DC1(st);
			assign Ct[i + 1] = sv2v_cast_30DC1(ct);
		end
		if ((N - (LEVELS_4TO2 * 2)) == 3) begin : g_final_3to2
			localparam FINAL_OP_IDX = 2 + (LEVELS_4TO2 * 2);
			localparam WI = W + LEVELS_4TO2;
			localparam WO = WI + 2;
			wire [WO - 1:0] st;
			wire [WO - 1:0] ct;
			function automatic [WI - 1:0] sv2v_cast_BC15F;
				input reg [WI - 1:0] inp;
				sv2v_cast_BC15F = inp;
			endfunction
			VX_csa_32 #(
				.N(WI),
				.WIDTH_O(WO)
			) csa_32(
				.a(sv2v_cast_BC15F(St[LEVELS_4TO2])),
				.b(sv2v_cast_BC15F(Ct[LEVELS_4TO2])),
				.c(sv2v_cast_BC15F(operands[FINAL_OP_IDX * W+:W])),
				.sum(st),
				.carry(ct)
			);
			assign St[LEVELS_4TO2 + 1] = sv2v_cast_30DC1(st);
			assign Ct[LEVELS_4TO2 + 1] = sv2v_cast_30DC1(ct);
		end
		else begin : g_no_final_3to2
			if (LEVELS_4TO2 < TOTAL_LEVELS) begin : g_pass_through
				assign St[LEVELS_4TO2 + 1] = St[LEVELS_4TO2];
				assign Ct[LEVELS_4TO2 + 1] = Ct[LEVELS_4TO2];
			end
		end
	endgenerate
	assign sum = St[TOTAL_LEVELS][S - 1:0];
	assign carry = Ct[TOTAL_LEVELS][S - 1:0];
endmodule
module VX_csa_tree (
	operands,
	sum,
	carry
);
	parameter N = 16;
	parameter W = 8;
	parameter K = 6;
	parameter BAL = 1;
	parameter S = W + $clog2(N);
	input wire [(N * W) - 1:0] operands;
	output wire [S - 1:0] sum;
	output wire [S - 1:0] carry;
	localparam CLUSTER_W = (K == 1 ? W : (W + K) + 2);
	localparam NUM_CLUSTERS = (K == 1 ? N : ((N + K) - 1) / K);
	localparam TOP_N = (K == 1 ? N : NUM_CLUSTERS * 2);
	function automatic integer next_lev_ragged;
		input integer n_in;
		integer n_rem;
		begin
			n_rem = n_in % 4;
			next_lev_ragged = (n_rem == 3 ? ((n_in / 4) * 2) + 2 : ((n_in / 4) * 2) + n_rem);
		end
	endfunction
	function automatic integer next_lev_balanced;
		input integer n_in;
		integer n_rem;
		reg [1:0] _sv2v_jump;
		begin
			n_rem = n_in % 4;
			_sv2v_jump = 2'b00;
			if (n_in <= 3) begin
				next_lev_balanced = (n_rem == 3 ? 2 : n_rem);
				_sv2v_jump = 2'b11;
			end
			if (_sv2v_jump == 2'b00) begin
				if (n_rem == 0) begin
					next_lev_balanced = (n_in / 4) * 2;
					_sv2v_jump = 2'b11;
				end
				if (_sv2v_jump == 2'b00) begin
					if ((n_rem == 1) || (n_rem == 2)) begin
						next_lev_balanced = (((n_in / 4) - 1) * 2) + 4;
						_sv2v_jump = 2'b11;
					end
					if (_sv2v_jump == 2'b00) begin
						next_lev_balanced = ((n_in / 4) * 2) + 2;
						_sv2v_jump = 2'b11;
					end
				end
			end
		end
	endfunction
	function automatic integer get_next_sz;
		input integer n;
		input integer use_bal;
		get_next_sz = (use_bal != 0 ? next_lev_balanced(n) : next_lev_ragged(n));
	endfunction
	function automatic integer calc_depth;
		input integer n_in;
		integer d;
		integer count;
		begin
			d = 0;
			count = n_in;
			while (count > 2) begin
				count = get_next_sz(count, BAL);
				d = d + 1;
			end
			calc_depth = d;
		end
	endfunction
	function automatic integer get_cnt_at_lev;
		input integer l;
		input integer start_n;
		integer c;
		begin
			c = start_n;
			begin : sv2v_autoblock_1
				integer k;
				for (k = 0; k < l; k = k + 1)
					c = get_next_sz(c, BAL);
			end
			get_cnt_at_lev = c;
		end
	endfunction
	wire [(TOP_N * CLUSTER_W) - 1:0] tree_inputs;
	function automatic [CLUSTER_W - 1:0] sv2v_cast_894FA;
		input reg [CLUSTER_W - 1:0] inp;
		sv2v_cast_894FA = inp;
	endfunction
	generate
		if (K == 1) begin : g_no_cluster
			genvar _gv_i_152;
			for (_gv_i_152 = 0; _gv_i_152 < N; _gv_i_152 = _gv_i_152 + 1) begin : g_map
				localparam i = _gv_i_152;
				assign tree_inputs[i * CLUSTER_W+:CLUSTER_W] = sv2v_cast_894FA(operands[i * W+:W]);
			end
		end
		else begin : g_do_cluster
			genvar _gv_i_153;
			for (_gv_i_153 = 0; _gv_i_153 < NUM_CLUSTERS; _gv_i_153 = _gv_i_153 + 1) begin : g_clusters
				localparam i = _gv_i_153;
				localparam C_SIZE = (i == (NUM_CLUSTERS - 1) ? N - (i * K) : K);
				if (C_SIZE == 1) begin : g_c1
					assign tree_inputs[(2 * i) * CLUSTER_W+:CLUSTER_W] = sv2v_cast_894FA(operands[(i * K) * W+:W]);
					assign tree_inputs[((2 * i) + 1) * CLUSTER_W+:CLUSTER_W] = 1'sb0;
				end
				else begin : g_lin
					wire [CLUSTER_W - 1:0] s_loc;
					wire [CLUSTER_W - 1:0] c_loc;
					wire [(C_SIZE * W) - 1:0] sub_ops;
					genvar _gv_j_10;
					for (_gv_j_10 = 0; _gv_j_10 < C_SIZE; _gv_j_10 = _gv_j_10 + 1) begin : g_slice
						localparam j = _gv_j_10;
						assign sub_ops[j * W+:W] = operands[((i * K) + j) * W+:W];
					end
					VX_csa_block #(
						.N(C_SIZE),
						.W(W),
						.S(CLUSTER_W)
					) cluster_linear(
						.operands(sub_ops),
						.sum(s_loc),
						.carry(c_loc)
					);
					assign tree_inputs[(2 * i) * CLUSTER_W+:CLUSTER_W] = s_loc;
					assign tree_inputs[((2 * i) + 1) * CLUSTER_W+:CLUSTER_W] = c_loc;
				end
			end
		end
	endgenerate
	localparam DEPTH = calc_depth(TOP_N);
	localparam MAX_WN = (CLUSTER_W + (DEPTH * 2)) + 4;
	localparam WN = (S < MAX_WN ? S : MAX_WN);
	wire [WN - 1:0] tree_sig [0:DEPTH + 0][0:TOP_N - 1];
	genvar _gv_i_154;
	function automatic [WN - 1:0] sv2v_cast_30DC1;
		input reg [WN - 1:0] inp;
		sv2v_cast_30DC1 = inp;
	endfunction
	generate
		for (_gv_i_154 = 0; _gv_i_154 < TOP_N; _gv_i_154 = _gv_i_154 + 1) begin : g_init_l0
			localparam i = _gv_i_154;
			assign tree_sig[0][i] = sv2v_cast_30DC1(tree_inputs[i * CLUSTER_W+:CLUSTER_W]);
		end
	endgenerate
	genvar _gv_lev_2;
	generate
		for (_gv_lev_2 = 0; _gv_lev_2 < DEPTH; _gv_lev_2 = _gv_lev_2 + 1) begin : g_levels
			localparam lev = _gv_lev_2;
			localparam integer NUM_IN = get_cnt_at_lev(lev, TOP_N);
			localparam integer WI = CLUSTER_W + (lev * 2);
			localparam integer WO = WI + 2;
			if (BAL == 1) begin : g_balanced
				localparam integer N_42 = NUM_IN / 4;
				localparam integer REM = NUM_IN % 4;
				localparam integer CORE = ((REM == 1) || (REM == 2) ? N_42 - 1 : N_42);
				genvar _gv_i_155;
				for (_gv_i_155 = 0; _gv_i_155 < CORE; _gv_i_155 = _gv_i_155 + 1) begin : g_core
					localparam i = _gv_i_155;
					wire [WO - 1:0] s;
					wire [WO - 1:0] c;
					function automatic [WI - 1:0] sv2v_cast_BC15F;
						input reg [WI - 1:0] inp;
						sv2v_cast_BC15F = inp;
					endfunction
					VX_csa_42 #(
						.N(WI),
						.WIDTH_O(WO)
					) csa(
						.a(sv2v_cast_BC15F(tree_sig[lev][(i * 4) + 0])),
						.b(sv2v_cast_BC15F(tree_sig[lev][(i * 4) + 1])),
						.c(sv2v_cast_BC15F(tree_sig[lev][(i * 4) + 2])),
						.d(sv2v_cast_BC15F(tree_sig[lev][(i * 4) + 3])),
						.sum(s),
						.carry(c)
					);
					assign tree_sig[lev + 1][(i * 2) + 0] = sv2v_cast_30DC1(s);
					assign tree_sig[lev + 1][(i * 2) + 1] = sv2v_cast_30DC1(c);
				end
				if (REM == 1) begin : g_r1
					localparam B = CORE * 4;
					localparam OB = CORE * 2;
					wire [WO - 1:0] s;
					wire [WO - 1:0] c;
					function automatic [WI - 1:0] sv2v_cast_BC15F;
						input reg [WI - 1:0] inp;
						sv2v_cast_BC15F = inp;
					endfunction
					VX_csa_32 #(
						.N(WI),
						.WIDTH_O(WO)
					) c32(
						.a(sv2v_cast_BC15F(tree_sig[lev][B])),
						.b(sv2v_cast_BC15F(tree_sig[lev][B + 1])),
						.c(sv2v_cast_BC15F(tree_sig[lev][B + 2])),
						.sum(s),
						.carry(c)
					);
					assign tree_sig[lev + 1][OB + 0] = sv2v_cast_30DC1(s);
					assign tree_sig[lev + 1][OB + 1] = sv2v_cast_30DC1(c);
					assign tree_sig[lev + 1][OB + 2] = tree_sig[lev][B + 3];
					assign tree_sig[lev + 1][OB + 3] = tree_sig[lev][B + 4];
				end
				else if (REM == 2) begin : g_r2
					localparam B = CORE * 4;
					localparam OB = CORE * 2;
					wire [WO - 1:0] s1;
					wire [WO - 1:0] c1;
					wire [WO - 1:0] s2;
					wire [WO - 1:0] c2;
					function automatic [WI - 1:0] sv2v_cast_BC15F;
						input reg [WI - 1:0] inp;
						sv2v_cast_BC15F = inp;
					endfunction
					VX_csa_32 #(
						.N(WI),
						.WIDTH_O(WO)
					) cA(
						.a(sv2v_cast_BC15F(tree_sig[lev][B])),
						.b(sv2v_cast_BC15F(tree_sig[lev][B + 1])),
						.c(sv2v_cast_BC15F(tree_sig[lev][B + 2])),
						.sum(s1),
						.carry(c1)
					);
					VX_csa_32 #(
						.N(WI),
						.WIDTH_O(WO)
					) cB(
						.a(sv2v_cast_BC15F(tree_sig[lev][B + 3])),
						.b(sv2v_cast_BC15F(tree_sig[lev][B + 4])),
						.c(sv2v_cast_BC15F(tree_sig[lev][B + 5])),
						.sum(s2),
						.carry(c2)
					);
					assign tree_sig[lev + 1][OB + 0] = sv2v_cast_30DC1(s1);
					assign tree_sig[lev + 1][OB + 1] = sv2v_cast_30DC1(c1);
					assign tree_sig[lev + 1][OB + 2] = sv2v_cast_30DC1(s2);
					assign tree_sig[lev + 1][OB + 3] = sv2v_cast_30DC1(c2);
				end
				else if (REM == 3) begin : g_r3
					localparam B = CORE * 4;
					localparam OB = CORE * 2;
					wire [WO - 1:0] s;
					wire [WO - 1:0] c;
					function automatic [WI - 1:0] sv2v_cast_BC15F;
						input reg [WI - 1:0] inp;
						sv2v_cast_BC15F = inp;
					endfunction
					VX_csa_32 #(
						.N(WI),
						.WIDTH_O(WO)
					) c32(
						.a(sv2v_cast_BC15F(tree_sig[lev][B])),
						.b(sv2v_cast_BC15F(tree_sig[lev][B + 1])),
						.c(sv2v_cast_BC15F(tree_sig[lev][B + 2])),
						.sum(s),
						.carry(c)
					);
					assign tree_sig[lev + 1][OB + 0] = sv2v_cast_30DC1(s);
					assign tree_sig[lev + 1][OB + 1] = sv2v_cast_30DC1(c);
				end
			end
			else begin : g_ragged
				localparam integer N_42 = NUM_IN / 4;
				localparam integer REM = NUM_IN % 4;
				genvar _gv_i_156;
				for (_gv_i_156 = 0; _gv_i_156 < N_42; _gv_i_156 = _gv_i_156 + 1) begin : g_csa42
					localparam i = _gv_i_156;
					wire [WO - 1:0] s;
					wire [WO - 1:0] c;
					function automatic [WI - 1:0] sv2v_cast_BC15F;
						input reg [WI - 1:0] inp;
						sv2v_cast_BC15F = inp;
					endfunction
					VX_csa_42 #(
						.N(WI),
						.WIDTH_O(WO)
					) csa(
						.a(sv2v_cast_BC15F(tree_sig[lev][(i * 4) + 0])),
						.b(sv2v_cast_BC15F(tree_sig[lev][(i * 4) + 1])),
						.c(sv2v_cast_BC15F(tree_sig[lev][(i * 4) + 2])),
						.d(sv2v_cast_BC15F(tree_sig[lev][(i * 4) + 3])),
						.sum(s),
						.carry(c)
					);
					assign tree_sig[lev + 1][(i * 2) + 0] = sv2v_cast_30DC1(s);
					assign tree_sig[lev + 1][(i * 2) + 1] = sv2v_cast_30DC1(c);
				end
				if (REM == 3) begin : g_rem3
					wire [WO - 1:0] s;
					wire [WO - 1:0] c;
					function automatic [WI - 1:0] sv2v_cast_BC15F;
						input reg [WI - 1:0] inp;
						sv2v_cast_BC15F = inp;
					endfunction
					VX_csa_32 #(
						.N(WI),
						.WIDTH_O(WO)
					) c32(
						.a(sv2v_cast_BC15F(tree_sig[lev][N_42 * 4])),
						.b(sv2v_cast_BC15F(tree_sig[lev][(N_42 * 4) + 1])),
						.c(sv2v_cast_BC15F(tree_sig[lev][(N_42 * 4) + 2])),
						.sum(s),
						.carry(c)
					);
					assign tree_sig[lev + 1][N_42 * 2] = sv2v_cast_30DC1(s);
					assign tree_sig[lev + 1][(N_42 * 2) + 1] = sv2v_cast_30DC1(c);
				end
				else begin : g_pass
					genvar _gv_p_1;
					for (_gv_p_1 = 0; _gv_p_1 < REM; _gv_p_1 = _gv_p_1 + 1) begin : g_rem
						localparam p = _gv_p_1;
						assign tree_sig[lev + 1][(N_42 * 2) + p] = tree_sig[lev][(N_42 * 4) + p];
					end
				end
			end
		end
	endgenerate
	function automatic [S - 1:0] sv2v_cast_3253E;
		input reg [S - 1:0] inp;
		sv2v_cast_3253E = inp;
	endfunction
	assign sum = sv2v_cast_3253E(tree_sig[DEPTH][0]);
	assign carry = (get_cnt_at_lev(DEPTH, TOP_N) > 1 ? sv2v_cast_3253E(tree_sig[DEPTH][1]) : {S {1'sb0}});
endmodule
module VX_cyclic_arbiter (
	clk,
	reset,
	requests,
	grant_index,
	grant_onehot,
	grant_valid,
	grant_ready
);
	parameter NUM_REQS = 1;
	parameter STICKY = 0;
	parameter LOG_NUM_REQS = (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1);
	input wire clk;
	input wire reset;
	input wire [NUM_REQS - 1:0] requests;
	output wire [LOG_NUM_REQS - 1:0] grant_index;
	output wire [NUM_REQS - 1:0] grant_onehot;
	output wire grant_valid;
	input wire grant_ready;
	function automatic signed [LOG_NUM_REQS - 1:0] sv2v_cast_B273C_signed;
		input reg signed [LOG_NUM_REQS - 1:0] inp;
		sv2v_cast_B273C_signed = inp;
	endfunction
	generate
		if (NUM_REQS == 1) begin : g_passthru
			assign grant_index = 1'sb0;
			assign grant_onehot = requests;
			assign grant_valid = requests[0];
		end
		else begin : g_arbiter
			localparam IS_POW2 = (1 << LOG_NUM_REQS) == NUM_REQS;
			wire [LOG_NUM_REQS - 1:0] grant_index_um;
			wire [NUM_REQS - 1:0] grant_onehot_w;
			wire [NUM_REQS - 1:0] grant_onehot_um;
			reg [LOG_NUM_REQS - 1:0] grant_index_r;
			reg [NUM_REQS - 1:0] prev_grant;
			always @(posedge clk)
				if (reset)
					prev_grant <= 1'sb0;
				else if (grant_valid && grant_ready)
					prev_grant <= grant_onehot;
			wire retain_grant = (STICKY != 0) && |(prev_grant & requests);
			wire [NUM_REQS - 1:0] requests_w = (retain_grant ? prev_grant : requests);
			always @(posedge clk)
				if (reset)
					grant_index_r <= 1'sb0;
				else if ((grant_valid && grant_ready) && ~retain_grant) begin
					if (!IS_POW2 && (grant_index == sv2v_cast_B273C_signed(NUM_REQS - 1)))
						grant_index_r <= 1'sb0;
					else
						grant_index_r <= grant_index + sv2v_cast_B273C_signed(1);
				end
			wire grant_valid_w;
			VX_priority_encoder #(.N(NUM_REQS)) grant_sel(
				.data_in(requests_w),
				.onehot_out(grant_onehot_um),
				.index_out(grant_index_um),
				.valid_out(grant_valid_w)
			);
			VX_demux #(
				.DATAW(1),
				.N(NUM_REQS)
			) grant_decoder(
				.sel_in(grant_index_r),
				.data_in(1'b1),
				.data_out(grant_onehot_w)
			);
			wire is_hit = requests[grant_index_r] && ~retain_grant;
			assign grant_index = (is_hit ? grant_index_r : grant_index_um);
			assign grant_onehot = (is_hit ? grant_onehot_w : grant_onehot_um);
			assign grant_valid = (STICKY != 0 ? |requests : grant_valid_w);
		end
	endgenerate
endmodule
module VX_demux (
	sel_in,
	data_in,
	data_out
);
	parameter DATAW = 1;
	parameter N = 0;
	parameter MODEL = 0;
	parameter LN = (N > 1 ? $clog2(N) : 1);
	input wire [LN - 1:0] sel_in;
	input wire [DATAW - 1:0] data_in;
	output wire [(N * DATAW) - 1:0] data_out;
	function automatic [(N * DATAW) - 1:0] sv2v_cast_5AC87;
		input reg [(N * DATAW) - 1:0] inp;
		sv2v_cast_5AC87 = inp;
	endfunction
	generate
		if (N > 1) begin : g_demux
			reg [(N * DATAW) - 1:0] shift;
			if (MODEL == 1) begin : g_model1
				always @(*) begin
					shift = 1'sb0;
					shift[sel_in * DATAW+:DATAW] = {DATAW {1'b1}};
				end
			end
			else begin : g_model0
				wire [N * DATAW:1] sv2v_tmp_0DAE3;
				assign sv2v_tmp_0DAE3 = sv2v_cast_5AC87({DATAW {1'b1}}) << (sel_in * DATAW);
				always @(*) shift = sv2v_tmp_0DAE3;
			end
			assign data_out = {N {data_in}} & shift;
		end
		else begin : g_passthru
			assign data_out = data_in;
		end
	endgenerate
endmodule
module VX_dp_ram (
	clk,
	reset,
	read,
	write,
	wren,
	waddr,
	wdata,
	raddr,
	rdata
);
	parameter DATAW = 1;
	parameter SIZE = 1;
	parameter WRENW = 1;
	parameter OUT_REG = 0;
	parameter LUTRAM = 0;
	parameter RDW_MODE = "W";
	parameter RADDR_REG = 0;
	parameter RADDR_RESET = 0;
	parameter RDW_ASSERT = 0;
	parameter RESET_RAM = 0;
	parameter INIT_ENABLE = 0;
	parameter INIT_FILE = "";
	parameter [DATAW - 1:0] INIT_VALUE = 0;
	parameter ADDRW = (SIZE > 1 ? $clog2(SIZE) : 1);
	input wire clk;
	input wire reset;
	input wire read;
	input wire write;
	input wire [WRENW - 1:0] wren;
	input wire [ADDRW - 1:0] waddr;
	input wire [DATAW - 1:0] wdata;
	input wire [ADDRW - 1:0] raddr;
	output wire [DATAW - 1:0] rdata;
	localparam WSELW = DATAW / WRENW;
	localparam FORCE_BRAM = !LUTRAM && ((((SIZE >= 64) || (DATAW >= 16)) || ((SIZE * DATAW) >= 512)) && ((SIZE * DATAW) >= 64));
	generate
		if (1) begin : g_no_asic
			if (OUT_REG) begin : g_sync
				if (FORCE_BRAM) begin : g_bram
					if (RDW_MODE == "W") begin : g_write_first
						if (WRENW != 1) begin : g_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_1
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [ADDRW - 1:0] raddr_r;
							always @(posedge clk) begin
								if (write) begin : sv2v_autoblock_2
									integer i;
									for (i = 0; i < WRENW; i = i + 1)
										if (wren[i])
											ram[waddr][i * WSELW+:WSELW] <= wdata[i * WSELW+:WSELW];
								end
								if (read)
									raddr_r <= raddr;
							end
							assign rdata = ram[raddr_r];
						end
						else begin : g_no_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_3
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [ADDRW - 1:0] raddr_r;
							always @(posedge clk) begin
								if (write)
									ram[waddr] <= wdata;
								if (read)
									raddr_r <= raddr;
							end
							assign rdata = ram[raddr_r];
						end
					end
					else if (RDW_MODE == "R") begin : g_read_first
						if (WRENW != 1) begin : g_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_4
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [DATAW - 1:0] rdata_r;
							always @(posedge clk) begin
								if (write) begin : sv2v_autoblock_5
									integer i;
									for (i = 0; i < WRENW; i = i + 1)
										if (wren[i])
											ram[waddr][i * WSELW+:WSELW] <= wdata[i * WSELW+:WSELW];
								end
								if (read)
									rdata_r <= ram[raddr];
							end
							assign rdata = rdata_r;
						end
						else begin : g_no_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_6
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [DATAW - 1:0] rdata_r;
							always @(posedge clk) begin
								if (write)
									ram[waddr] <= wdata;
								if (read)
									rdata_r <= ram[raddr];
							end
							assign rdata = rdata_r;
						end
					end
				end
				else begin : g_auto
					if (RDW_MODE == "W") begin : g_write_first
						if (WRENW != 1) begin : g_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_7
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [ADDRW - 1:0] raddr_r;
							always @(posedge clk) begin
								if (write) begin : sv2v_autoblock_8
									integer i;
									for (i = 0; i < WRENW; i = i + 1)
										if (wren[i])
											ram[waddr][i * WSELW+:WSELW] <= wdata[i * WSELW+:WSELW];
								end
								if (read)
									raddr_r <= raddr;
							end
							assign rdata = ram[raddr_r];
						end
						else begin : g_no_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_9
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [ADDRW - 1:0] raddr_r;
							always @(posedge clk) begin
								if (write)
									ram[waddr] <= wdata;
								if (read)
									raddr_r <= raddr;
							end
							assign rdata = ram[raddr_r];
						end
					end
					else if (RDW_MODE == "R") begin : g_read_first
						if (WRENW != 1) begin : g_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_10
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [DATAW - 1:0] rdata_r;
							always @(posedge clk) begin
								if (write) begin : sv2v_autoblock_11
									integer i;
									for (i = 0; i < WRENW; i = i + 1)
										if (wren[i])
											ram[waddr][i * WSELW+:WSELW] <= wdata[i * WSELW+:WSELW];
								end
								if (read)
									rdata_r <= ram[raddr];
							end
							assign rdata = rdata_r;
						end
						else begin : g_no_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_12
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [DATAW - 1:0] rdata_r;
							always @(posedge clk) begin
								if (write)
									ram[waddr] <= wdata;
								if (read)
									rdata_r <= ram[raddr];
							end
							assign rdata = rdata_r;
						end
					end
				end
			end
			else begin : g_async
				if (FORCE_BRAM) begin : g_bram
					if (RDW_MODE == "W") begin : g_write_first
						if (WRENW != 1) begin : g_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_13
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							always @(posedge clk)
								if (write) begin : sv2v_autoblock_14
									integer i;
									for (i = 0; i < WRENW; i = i + 1)
										if (wren[i])
											ram[waddr][i * WSELW+:WSELW] <= wdata[i * WSELW+:WSELW];
								end
							assign rdata = ram[raddr];
						end
						else begin : g_no_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_15
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							always @(posedge clk)
								if (write)
									ram[waddr] <= wdata;
							assign rdata = ram[raddr];
						end
					end
					else begin : g_read_first
						if (WRENW != 1) begin : g_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_16
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							always @(posedge clk)
								if (write) begin : sv2v_autoblock_17
									integer i;
									for (i = 0; i < WRENW; i = i + 1)
										if (wren[i])
											ram[waddr][i * WSELW+:WSELW] <= wdata[i * WSELW+:WSELW];
								end
							assign rdata = ram[raddr];
						end
						else begin : g_no_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_18
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							always @(posedge clk)
								if (write)
									ram[waddr] <= wdata;
							assign rdata = ram[raddr];
						end
					end
				end
				else begin : g_auto
					if (RDW_MODE == "W") begin : g_write_first
						if (WRENW != 1) begin : g_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_19
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							always @(posedge clk)
								if (write) begin : sv2v_autoblock_20
									integer i;
									for (i = 0; i < WRENW; i = i + 1)
										if (wren[i])
											ram[waddr][i * WSELW+:WSELW] <= wdata[i * WSELW+:WSELW];
								end
							assign rdata = ram[raddr];
						end
						else begin : g_no_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_21
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							always @(posedge clk)
								if (write)
									ram[waddr] <= wdata;
							assign rdata = ram[raddr];
						end
					end
					else begin : g_read_first
						if (WRENW != 1) begin : g_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_22
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							always @(posedge clk)
								if (write) begin : sv2v_autoblock_23
									integer i;
									for (i = 0; i < WRENW; i = i + 1)
										if (wren[i])
											ram[waddr][i * WSELW+:WSELW] <= wdata[i * WSELW+:WSELW];
								end
							assign rdata = ram[raddr];
						end
						else begin : g_no_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_24
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							always @(posedge clk)
								if (write)
									ram[waddr] <= wdata;
							assign rdata = ram[raddr];
						end
					end
				end
			end
		end
	endgenerate
endmodule
module VX_elastic_adapter (
	clk,
	reset,
	valid_in,
	ready_in,
	ready_out,
	valid_out,
	busy,
	strobe
);
	input wire clk;
	input wire reset;
	input wire valid_in;
	output wire ready_in;
	input wire ready_out;
	output wire valid_out;
	input wire busy;
	output wire strobe;
	wire push = valid_in && ready_in;
	wire pop = valid_out && ready_out;
	reg loaded;
	always @(posedge clk)
		if (reset)
			loaded <= 0;
		else begin
			if (push)
				loaded <= 1;
			if (pop)
				loaded <= 0;
		end
	assign ready_in = ~loaded;
	assign valid_out = loaded && ~busy;
	assign strobe = push;
endmodule
module VX_elastic_buffer (
	clk,
	reset,
	valid_in,
	ready_in,
	data_in,
	data_out,
	ready_out,
	valid_out
);
	parameter DATAW = 1;
	parameter SIZE = 1;
	parameter OUT_REG = 0;
	parameter LUTRAM = 0;
	input wire clk;
	input wire reset;
	input wire valid_in;
	output wire ready_in;
	input wire [DATAW - 1:0] data_in;
	output wire [DATAW - 1:0] data_out;
	input wire ready_out;
	output wire valid_out;
	generate
		if (SIZE == 0) begin : g_passthru
			assign valid_out = valid_in;
			assign data_out = data_in;
			assign ready_in = ready_out;
		end
		else if (SIZE == 1) begin : g_eb1
			VX_pipe_buffer #(
				.DATAW(DATAW),
				.DEPTH((OUT_REG > 1 ? OUT_REG : 1))
			) pipe_buffer(
				.clk(clk),
				.reset(reset),
				.valid_in(valid_in),
				.data_in(data_in),
				.ready_in(ready_in),
				.valid_out(valid_out),
				.data_out(data_out),
				.ready_out(ready_out)
			);
		end
		else if ((SIZE == 2) && (LUTRAM == 0)) begin : g_eb2
			wire valid_out_t;
			wire [DATAW - 1:0] data_out_t;
			wire ready_out_t;
			VX_stream_buffer #(
				.DATAW(DATAW),
				.OUT_REG(OUT_REG == 1)
			) stream_buffer(
				.clk(clk),
				.reset(reset),
				.valid_in(valid_in),
				.data_in(data_in),
				.ready_in(ready_in),
				.valid_out(valid_out_t),
				.data_out(data_out_t),
				.ready_out(ready_out_t)
			);
			VX_pipe_buffer #(
				.DATAW(DATAW),
				.DEPTH((OUT_REG > 1 ? OUT_REG - 1 : 0))
			) out_buf(
				.clk(clk),
				.reset(reset),
				.valid_in(valid_out_t),
				.data_in(data_out_t),
				.ready_in(ready_out_t),
				.valid_out(valid_out),
				.data_out(data_out),
				.ready_out(ready_out)
			);
		end
		else begin : g_ebN
			wire empty;
			wire full;
			wire [DATAW - 1:0] data_out_t;
			wire ready_out_t;
			wire valid_out_t = ~empty;
			wire push = valid_in && ready_in;
			wire pop = valid_out_t && ready_out_t;
			VX_fifo_queue #(
				.DATAW(DATAW),
				.DEPTH(SIZE),
				.OUT_REG(OUT_REG == 1),
				.LUTRAM(LUTRAM)
			) fifo_queue(
				.clk(clk),
				.reset(reset),
				.push(push),
				.pop(pop),
				.data_in(data_in),
				.data_out(data_out_t),
				.empty(empty),
				.full(full),
				.alm_empty(),
				.alm_full(),
				.size()
			);
			assign ready_in = ~full;
			VX_pipe_buffer #(
				.DATAW(DATAW),
				.DEPTH((OUT_REG > 1 ? OUT_REG - 1 : 0))
			) out_buf(
				.clk(clk),
				.reset(reset),
				.valid_in(valid_out_t),
				.data_in(data_out_t),
				.ready_in(ready_out_t),
				.valid_out(valid_out),
				.data_out(data_out),
				.ready_out(ready_out)
			);
		end
	endgenerate
endmodule
module VX_fifo_queue (
	clk,
	reset,
	push,
	pop,
	data_in,
	data_out,
	empty,
	alm_empty,
	full,
	alm_full,
	size
);
	parameter DATAW = 32;
	parameter DEPTH = 32;
	parameter ALM_FULL = DEPTH - 1;
	parameter ALM_EMPTY = 1;
	parameter OUT_REG = 0;
	parameter LUTRAM = 0;
	parameter SIZEW = $clog2(DEPTH + 1);
	input wire clk;
	input wire reset;
	input wire push;
	input wire pop;
	input wire [DATAW - 1:0] data_in;
	output wire [DATAW - 1:0] data_out;
	output wire empty;
	output wire alm_empty;
	output wire full;
	output wire alm_full;
	output wire [SIZEW - 1:0] size;
	VX_pending_size #(
		.SIZE(DEPTH),
		.ALM_EMPTY(ALM_EMPTY),
		.ALM_FULL(ALM_FULL)
	) pending_size(
		.clk(clk),
		.reset(reset),
		.incr(push),
		.decr(pop),
		.empty(empty),
		.full(full),
		.alm_empty(alm_empty),
		.alm_full(alm_full),
		.size(size)
	);
	generate
		if (DEPTH == 1) begin : g_depth_1
			reg [DATAW - 1:0] head_r;
			always @(posedge clk)
				if (push)
					head_r <= data_in;
			assign data_out = head_r;
		end
		else begin : g_depth_n
			localparam ADDRW = $clog2(DEPTH);
			wire [DATAW - 1:0] data_out_w;
			reg [ADDRW - 1:0] rd_ptr_r;
			reg [ADDRW - 1:0] wr_ptr_r;
			always @(posedge clk)
				if (reset) begin
					wr_ptr_r <= 1'sb0;
					rd_ptr_r <= (OUT_REG != 0 ? 1 : 0);
				end
				else begin
					begin : sv2v_autoblock_1
						reg [ADDRW - 1:0] sv2v_tmp_cast;
						sv2v_tmp_cast = push;
						wr_ptr_r <= wr_ptr_r + sv2v_tmp_cast;
					end
					begin : sv2v_autoblock_2
						reg [ADDRW - 1:0] sv2v_tmp_cast_1;
						sv2v_tmp_cast_1 = pop;
						rd_ptr_r <= rd_ptr_r + sv2v_tmp_cast_1;
					end
				end
			VX_dp_ram #(
				.DATAW(DATAW),
				.SIZE(DEPTH),
				.LUTRAM(LUTRAM),
				.RDW_MODE("W"),
				.RADDR_REG(1),
				.RADDR_RESET(1)
			) dp_ram(
				.clk(clk),
				.reset(reset),
				.read(1'b1),
				.write(push),
				.wren(1'b1),
				.raddr(rd_ptr_r),
				.waddr(wr_ptr_r),
				.wdata(data_in),
				.rdata(data_out_w)
			);
			if (OUT_REG != 0) begin : g_out_reg
				reg [DATAW - 1:0] data_out_r;
				function automatic signed [ADDRW - 1:0] sv2v_cast_12D70_signed;
					input reg signed [ADDRW - 1:0] inp;
					sv2v_cast_12D70_signed = inp;
				endfunction
				wire going_empty = (ALM_EMPTY == 1 ? alm_empty : size[ADDRW - 1:0] == sv2v_cast_12D70_signed(1));
				wire bypass = push && (empty || (going_empty && pop));
				always @(posedge clk)
					if (bypass)
						data_out_r <= data_in;
					else if (pop)
						data_out_r <= data_out_w;
				assign data_out = data_out_r;
			end
			else begin : g_no_out_reg
				assign data_out = data_out_w;
			end
		end
	endgenerate
endmodule
module VX_find_first (
	data_in,
	valid_in,
	data_out,
	valid_out
);
	parameter N = 1;
	parameter DATAW = 1;
	parameter REVERSE = 0;
	input wire [(N * DATAW) - 1:0] data_in;
	input wire [N - 1:0] valid_in;
	output wire [DATAW - 1:0] data_out;
	output wire valid_out;
	localparam LOGN = $clog2(N);
	localparam TL = (1 << LOGN) - 1;
	localparam TN = (1 << (LOGN + 1)) - 1;
	wire s_n [0:TN - 1];
	wire [DATAW - 1:0] d_n [0:TN - 1];
	genvar _gv_i_158;
	generate
		for (_gv_i_158 = 0; _gv_i_158 < N; _gv_i_158 = _gv_i_158 + 1) begin : g_fill
			localparam i = _gv_i_158;
			assign s_n[TL + i] = (REVERSE ? valid_in[(N - 1) - i] : valid_in[i]);
			assign d_n[TL + i] = (REVERSE ? data_in[((N - 1) - i) * DATAW+:DATAW] : data_in[i * DATAW+:DATAW]);
		end
		if (TL < (TN - N)) begin : g_padding
			genvar _gv_i_159;
			for (_gv_i_159 = TL + N; _gv_i_159 < TN; _gv_i_159 = _gv_i_159 + 1) begin : g_i
				localparam i = _gv_i_159;
				assign s_n[i] = 0;
				assign d_n[i] = 1'sb0;
			end
		end
	endgenerate
	genvar _gv_j_11;
	generate
		for (_gv_j_11 = 0; _gv_j_11 < LOGN; _gv_j_11 = _gv_j_11 + 1) begin : g_scan
			localparam j = _gv_j_11;
			localparam I = 1 << j;
			genvar _gv_i_160;
			for (_gv_i_160 = 0; _gv_i_160 < I; _gv_i_160 = _gv_i_160 + 1) begin : g_i
				localparam i = _gv_i_160;
				localparam K = (I + i) - 1;
				assign s_n[K] = s_n[(2 * K) + 2] | s_n[(2 * K) + 1];
				assign d_n[K] = (s_n[(2 * K) + 1] ? d_n[(2 * K) + 1] : d_n[(2 * K) + 2]);
			end
		end
	endgenerate
	assign valid_out = s_n[0];
	assign data_out = d_n[0];
endmodule
module VX_generic_arbiter (
	clk,
	reset,
	requests,
	grant_index,
	grant_onehot,
	grant_valid,
	grant_ready
);
	parameter NUM_REQS = 1;
	parameter TYPE = "P";
	parameter STICKY = 0;
	parameter LOG_NUM_REQS = (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1);
	input wire clk;
	input wire reset;
	input wire [NUM_REQS - 1:0] requests;
	output wire [LOG_NUM_REQS - 1:0] grant_index;
	output wire [NUM_REQS - 1:0] grant_onehot;
	output wire grant_valid;
	input wire grant_ready;
	generate
		if (TYPE == "P") begin : g_priority
			VX_priority_arbiter #(
				.NUM_REQS(NUM_REQS),
				.STICKY(STICKY)
			) priority_arbiter(
				.clk(clk),
				.reset(reset),
				.requests(requests),
				.grant_valid(grant_valid),
				.grant_index(grant_index),
				.grant_onehot(grant_onehot),
				.grant_ready(grant_ready)
			);
		end
		else if (TYPE == "R") begin : g_round_robin
			VX_rr_arbiter #(
				.NUM_REQS(NUM_REQS),
				.STICKY(STICKY)
			) rr_arbiter(
				.clk(clk),
				.reset(reset),
				.requests(requests),
				.grant_valid(grant_valid),
				.grant_index(grant_index),
				.grant_onehot(grant_onehot),
				.grant_ready(grant_ready)
			);
		end
		else if (TYPE == "M") begin : g_matrix
			VX_matrix_arbiter #(
				.NUM_REQS(NUM_REQS),
				.STICKY(STICKY)
			) matrix_arbiter(
				.clk(clk),
				.reset(reset),
				.requests(requests),
				.grant_valid(grant_valid),
				.grant_index(grant_index),
				.grant_onehot(grant_onehot),
				.grant_ready(grant_ready)
			);
		end
		else if (TYPE == "C") begin : g_cyclic
			VX_cyclic_arbiter #(
				.NUM_REQS(NUM_REQS),
				.STICKY(STICKY)
			) cyclic_arbiter(
				.clk(clk),
				.reset(reset),
				.requests(requests),
				.grant_valid(grant_valid),
				.grant_index(grant_index),
				.grant_onehot(grant_onehot),
				.grant_ready(grant_ready)
			);
		end
		else if (TYPE == "G") begin : g_gto
			VX_gto_arbiter #(.NUM_REQS(NUM_REQS)) gto_arbiter(
				.clk(clk),
				.reset(reset),
				.requests(requests),
				.suppress({NUM_REQS {1'b0}}),
				.grant_valid(grant_valid),
				.grant_index(grant_index),
				.grant_onehot(grant_onehot),
				.grant_ready(grant_ready)
			);
		end
	endgenerate
endmodule
module VX_gto_arbiter (
	clk,
	reset,
	requests,
	suppress,
	grant_index,
	grant_onehot,
	grant_valid,
	grant_ready
);
	parameter NUM_REQS = 1;
	parameter LOG_NUM_REQS = (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1);
	input wire clk;
	input wire reset;
	input wire [NUM_REQS - 1:0] requests;
	input wire [NUM_REQS - 1:0] suppress;
	output wire [LOG_NUM_REQS - 1:0] grant_index;
	output wire [NUM_REQS - 1:0] grant_onehot;
	output wire grant_valid;
	input wire grant_ready;
	generate
		if (NUM_REQS == 1) begin : g_passthru
			assign grant_index = 1'sb0;
			assign grant_onehot = requests;
			assign grant_valid = requests[0] && ~suppress[0];
		end
		else begin : g_arbiter
			wire [NUM_REQS - 1:0] eff_requests = requests & ~suppress;
			reg [NUM_REQS - 1:0] prev_grant;
			always @(posedge clk)
				if (reset)
					prev_grant <= 1'sb0;
				else if (grant_valid && grant_ready)
					prev_grant <= grant_onehot;
			wire retain_grant = |(prev_grant & eff_requests);
			wire grant_fire = grant_valid && grant_ready;
			reg [NUM_REQS - 1:0] rank_matrix [0:NUM_REQS - 1];
			wire [NUM_REQS - 1:0] outranks [0:NUM_REQS - 1];
			genvar _gv_i_161;
			for (_gv_i_161 = 0; _gv_i_161 < NUM_REQS; _gv_i_161 = _gv_i_161 + 1) begin : g_outranks
				localparam i = _gv_i_161;
				genvar _gv_j_12;
				for (_gv_j_12 = 0; _gv_j_12 < NUM_REQS; _gv_j_12 = _gv_j_12 + 1) begin : g_col
					localparam j = _gv_j_12;
					assign outranks[i][j] = (i < j ? rank_matrix[i][j] : (i > j ? ~rank_matrix[j][i] : 1'b0));
				end
			end
			wire [NUM_REQS - 1:0] oldest_onehot;
			genvar _gv_i_162;
			for (_gv_i_162 = 0; _gv_i_162 < NUM_REQS; _gv_i_162 = _gv_i_162 + 1) begin : g_oldest
				localparam i = _gv_i_162;
				wire [NUM_REQS - 1:0] dominates;
				genvar _gv_j_13;
				for (_gv_j_13 = 0; _gv_j_13 < NUM_REQS; _gv_j_13 = _gv_j_13 + 1) begin : g_dom
					localparam j = _gv_j_13;
					assign dominates[j] = (i == j ? 1'b1 : outranks[i][j] | ~eff_requests[j]);
				end
				assign oldest_onehot[i] = eff_requests[i] && &dominates;
			end
			integer mr;
			integer mc;
			always @(posedge clk)
				if (reset) begin
					for (mr = 0; mr < NUM_REQS; mr = mr + 1)
						for (mc = 0; mc < NUM_REQS; mc = mc + 1)
							if (mr < mc)
								rank_matrix[mr][mc] <= 1'b1;
				end
				else if (grant_fire) begin
					for (mr = 0; mr < NUM_REQS; mr = mr + 1)
						for (mc = 0; mc < NUM_REQS; mc = mc + 1)
							if (mr < mc) begin
								if (grant_onehot[mr])
									rank_matrix[mr][mc] <= 1'b0;
								else if (grant_onehot[mc])
									rank_matrix[mr][mc] <= 1'b1;
							end
				end
			assign grant_valid = |eff_requests;
			assign grant_onehot = (retain_grant ? prev_grant : oldest_onehot);
			genvar _gv_k_4;
			for (_gv_k_4 = 0; _gv_k_4 < LOG_NUM_REQS; _gv_k_4 = _gv_k_4 + 1) begin : g_grant_index
				localparam k = _gv_k_4;
				wire [NUM_REQS - 1:0] kbits;
				genvar _gv_i_163;
				for (_gv_i_163 = 0; _gv_i_163 < NUM_REQS; _gv_i_163 = _gv_i_163 + 1) begin : g_kbit
					localparam i = _gv_i_163;
					assign kbits[i] = (((i >> k) & 1) != 0 ? grant_onehot[i] : 1'b0);
				end
				assign grant_index[k] = |kbits;
			end
		end
	endgenerate
endmodule
module VX_index_buffer (
	clk,
	reset,
	write_addr,
	write_data,
	acquire_en,
	read_addr,
	read_data,
	release_en,
	empty,
	full
);
	parameter DATAW = 1;
	parameter SIZE = 1;
	parameter LUTRAM = 0;
	parameter ADDRW = (SIZE > 1 ? $clog2(SIZE) : 1);
	input wire clk;
	input wire reset;
	output wire [ADDRW - 1:0] write_addr;
	input wire [DATAW - 1:0] write_data;
	input wire acquire_en;
	input wire [ADDRW - 1:0] read_addr;
	output wire [DATAW - 1:0] read_data;
	input wire release_en;
	output wire empty;
	output wire full;
	VX_allocator #(.SIZE(SIZE)) allocator(
		.clk(clk),
		.reset(reset),
		.acquire_en(acquire_en),
		.acquire_addr(write_addr),
		.release_en(release_en),
		.release_addr(read_addr),
		.empty(empty),
		.full(full)
	);
	VX_dp_ram #(
		.DATAW(DATAW),
		.SIZE(SIZE),
		.LUTRAM(LUTRAM),
		.RDW_MODE("W")
	) data_table(
		.clk(clk),
		.reset(reset),
		.read(1'b1),
		.write(acquire_en),
		.wren(1'b1),
		.waddr(write_addr),
		.wdata(write_data),
		.raddr(read_addr),
		.rdata(read_data)
	);
endmodule
module VX_ks_adder (
	dataa,
	datab,
	cin,
	sum,
	cout
);
	parameter N = 16;
	parameter BYPASS = 0;
	input wire [N - 1:0] dataa;
	input wire [N - 1:0] datab;
	input wire cin;
	output wire [N - 1:0] sum;
	output wire cout;
	function automatic [N - 1:0] sv2v_cast_C31AD;
		input reg [N - 1:0] inp;
		sv2v_cast_C31AD = inp;
	endfunction
	generate
		if (BYPASS) begin : g_bypass
			assign {cout, sum} = (dataa + datab) + sv2v_cast_C31AD(cin);
		end
		else begin : g_KS
			localparam LEVELS = $clog2(N);
			wire [N - 1:0] G [0:LEVELS + 0];
			wire [N - 1:0] P [0:LEVELS + 0];
			genvar _gv_i_164;
			for (_gv_i_164 = 0; _gv_i_164 < N; _gv_i_164 = _gv_i_164 + 1) begin : g_initial_gp
				localparam i = _gv_i_164;
				assign G[0][i] = dataa[i] & datab[i];
				assign P[0][i] = dataa[i] ^ datab[i];
			end
			genvar _gv_k_5;
			for (_gv_k_5 = 1; _gv_k_5 <= LEVELS; _gv_k_5 = _gv_k_5 + 1) begin : g_ks_levels
				localparam k = _gv_k_5;
				localparam STEP = 1 << (k - 1);
				genvar _gv_i_165;
				for (_gv_i_165 = 0; _gv_i_165 < N; _gv_i_165 = _gv_i_165 + 1) begin : g_ks_nodes
					localparam i = _gv_i_165;
					if (i >= STEP) begin : g_compute_gp
						assign G[k][i] = G[k - 1][i] | (P[k - 1][i] & G[k - 1][i - STEP]);
						assign P[k][i] = P[k - 1][i] & P[k - 1][i - STEP];
					end
					else begin : g_passthrough_gp
						assign G[k][i] = G[k - 1][i];
						assign P[k][i] = P[k - 1][i];
					end
				end
			end
			assign sum[0] = P[0][0] ^ cin;
			genvar _gv_i_166;
			for (_gv_i_166 = 1; _gv_i_166 < N; _gv_i_166 = _gv_i_166 + 1) begin : g_sum
				localparam i = _gv_i_166;
				wire carry_in_i = G[LEVELS][i - 1] | (P[LEVELS][i - 1] & cin);
				assign sum[i] = P[0][i] ^ carry_in_i;
			end
			assign cout = G[LEVELS][N - 1] | (P[LEVELS][N - 1] & cin);
		end
	endgenerate
endmodule
module VX_lzc (
	data_in,
	data_out,
	valid_out
);
	parameter N = 2;
	parameter REVERSE = 0;
	parameter LOGN = (N > 1 ? $clog2(N) : 1);
	input wire [N - 1:0] data_in;
	output wire [LOGN - 1:0] data_out;
	output wire valid_out;
	function automatic signed [LOGN - 1:0] sv2v_cast_86F14_signed;
		input reg signed [LOGN - 1:0] inp;
		sv2v_cast_86F14_signed = inp;
	endfunction
	generate
		if (N == 1) begin : g_passthru
			assign data_out = 1'sb0;
			assign valid_out = data_in;
		end
		else begin : g_lzc
			wire [(N * LOGN) - 1:0] indices;
			genvar _gv_i_167;
			for (_gv_i_167 = 0; _gv_i_167 < N; _gv_i_167 = _gv_i_167 + 1) begin : g_indices
				localparam i = _gv_i_167;
				assign indices[i * LOGN+:LOGN] = (REVERSE ? sv2v_cast_86F14_signed(i) : sv2v_cast_86F14_signed((N - 1) - i));
			end
			VX_find_first #(
				.N(N),
				.DATAW(LOGN),
				.REVERSE(!REVERSE)
			) find_first(
				.valid_in(data_in),
				.data_in(indices),
				.data_out(data_out),
				.valid_out(valid_out)
			);
		end
	endgenerate
endmodule
module VX_matrix_arbiter (
	clk,
	reset,
	requests,
	grant_index,
	grant_onehot,
	grant_valid,
	grant_ready
);
	parameter NUM_REQS = 1;
	parameter STICKY = 0;
	parameter LOG_NUM_REQS = (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1);
	input wire clk;
	input wire reset;
	input wire [NUM_REQS - 1:0] requests;
	output wire [LOG_NUM_REQS - 1:0] grant_index;
	output wire [NUM_REQS - 1:0] grant_onehot;
	output wire grant_valid;
	input wire grant_ready;
	generate
		if (NUM_REQS == 1) begin : g_passthru
			assign grant_index = 1'sb0;
			assign grant_onehot = requests;
			assign grant_valid = requests[0];
		end
		else begin : g_arbiter
			reg [NUM_REQS - 1:1] state [NUM_REQS - 1:0];
			wire [NUM_REQS - 1:0] pri [NUM_REQS - 1:0];
			wire [NUM_REQS - 1:0] grant;
			reg [NUM_REQS - 1:0] prev_grant;
			always @(posedge clk)
				if (reset)
					prev_grant <= 1'sb0;
				else if (grant_valid && grant_ready)
					prev_grant <= grant_onehot;
			wire retain_grant = (STICKY != 0) && |(prev_grant & requests);
			wire [NUM_REQS - 1:0] grant_w = (retain_grant ? prev_grant : grant);
			genvar _gv_r_1;
			for (_gv_r_1 = 0; _gv_r_1 < NUM_REQS; _gv_r_1 = _gv_r_1 + 1) begin : g_pri_r
				localparam r = _gv_r_1;
				genvar _gv_c_1;
				for (_gv_c_1 = 0; _gv_c_1 < NUM_REQS; _gv_c_1 = _gv_c_1 + 1) begin : g_pri_c
					localparam c = _gv_c_1;
					if (r > c) begin : g_row
						assign pri[r][c] = requests[c] && state[c][r];
					end
					else if (r < c) begin : g_col
						assign pri[r][c] = requests[c] && !state[r][c];
					end
					else begin : g_equal
						assign pri[r][c] = 0;
					end
				end
			end
			genvar _gv_r_2;
			for (_gv_r_2 = 0; _gv_r_2 < NUM_REQS; _gv_r_2 = _gv_r_2 + 1) begin : g_grant
				localparam r = _gv_r_2;
				assign grant[r] = requests[r] && ~(|pri[r]);
			end
			genvar _gv_r_3;
			for (_gv_r_3 = 0; _gv_r_3 < NUM_REQS; _gv_r_3 = _gv_r_3 + 1) begin : g_state_r
				localparam r = _gv_r_3;
				genvar _gv_c_2;
				for (_gv_c_2 = r + 1; _gv_c_2 < NUM_REQS; _gv_c_2 = _gv_c_2 + 1) begin : g_state_c
					localparam c = _gv_c_2;
					always @(posedge clk)
						if (reset)
							state[r][c] <= 1'sb0;
						else if ((grant_valid && grant_ready) && ~retain_grant)
							state[r][c] <= (state[r][c] || grant[c]) && ~grant[r];
				end
			end
			assign grant_onehot = grant_w;
			wire grant_valid_w;
			VX_onehot_encoder #(.N(NUM_REQS)) encoder(
				.data_in(grant_w),
				.data_out(grant_index),
				.valid_out(grant_valid_w)
			);
			assign grant_valid = (STICKY != 0 ? |requests : grant_valid_w);
		end
	endgenerate
endmodule
module VX_mem_coalescer (
	clk,
	reset,
	misses,
	in_req_valid,
	in_req_rw,
	in_req_mask,
	in_req_byteen,
	in_req_addr,
	in_req_user,
	in_req_data,
	in_req_no_merge,
	in_req_tag,
	in_req_ready,
	in_rsp_valid,
	in_rsp_mask,
	in_rsp_data,
	in_rsp_tag,
	in_rsp_ready,
	out_req_valid,
	out_req_rw,
	out_req_mask,
	out_req_byteen,
	out_req_addr,
	out_req_user,
	out_req_data,
	out_req_tag,
	out_req_ready,
	out_rsp_valid,
	out_rsp_mask,
	out_rsp_data,
	out_rsp_tag,
	out_rsp_ready
);
	parameter INSTANCE_ID = "";
	parameter NUM_REQS = 1;
	parameter ADDR_WIDTH = 32;
	parameter USER_WIDTH = 0;
	parameter DATA_IN_SIZE = 4;
	parameter DATA_OUT_SIZE = 64;
	parameter TAG_WIDTH = 8;
	parameter UUID_WIDTH = 0;
	parameter QUEUE_SIZE = 8;
	parameter PERF_CTR_BITS = $clog2(NUM_REQS + 1);
	parameter DATA_IN_WIDTH = DATA_IN_SIZE * 8;
	parameter DATA_OUT_WIDTH = DATA_OUT_SIZE * 8;
	parameter DATA_RATIO = DATA_OUT_SIZE / DATA_IN_SIZE;
	parameter DATA_RATIO_W = (DATA_RATIO > 1 ? $clog2(DATA_RATIO) : 1);
	parameter OUT_REQS = NUM_REQS / DATA_RATIO;
	parameter OUT_ADDR_WIDTH = ADDR_WIDTH - DATA_RATIO_W;
	parameter QUEUE_ADDRW = $clog2(QUEUE_SIZE);
	parameter OUT_TAG_WIDTH = UUID_WIDTH + QUEUE_ADDRW;
	input wire clk;
	input wire reset;
	output wire [PERF_CTR_BITS - 1:0] misses;
	input wire in_req_valid;
	input wire in_req_rw;
	input wire [NUM_REQS - 1:0] in_req_mask;
	input wire [(NUM_REQS * DATA_IN_SIZE) - 1:0] in_req_byteen;
	input wire [(NUM_REQS * ADDR_WIDTH) - 1:0] in_req_addr;
	input wire [(NUM_REQS * (USER_WIDTH > 0 ? USER_WIDTH : 1)) - 1:0] in_req_user;
	input wire [(NUM_REQS * DATA_IN_WIDTH) - 1:0] in_req_data;
	input wire in_req_no_merge;
	input wire [TAG_WIDTH - 1:0] in_req_tag;
	output wire in_req_ready;
	output wire in_rsp_valid;
	output wire [NUM_REQS - 1:0] in_rsp_mask;
	output wire [(NUM_REQS * DATA_IN_WIDTH) - 1:0] in_rsp_data;
	output wire [TAG_WIDTH - 1:0] in_rsp_tag;
	input wire in_rsp_ready;
	output wire out_req_valid;
	output wire out_req_rw;
	output wire [OUT_REQS - 1:0] out_req_mask;
	output wire [(OUT_REQS * DATA_OUT_SIZE) - 1:0] out_req_byteen;
	output wire [(OUT_REQS * OUT_ADDR_WIDTH) - 1:0] out_req_addr;
	output wire [(OUT_REQS * (USER_WIDTH > 0 ? USER_WIDTH : 1)) - 1:0] out_req_user;
	output wire [(OUT_REQS * DATA_OUT_WIDTH) - 1:0] out_req_data;
	output wire [OUT_TAG_WIDTH - 1:0] out_req_tag;
	input wire out_req_ready;
	input wire out_rsp_valid;
	input wire [OUT_REQS - 1:0] out_rsp_mask;
	input wire [(OUT_REQS * DATA_OUT_WIDTH) - 1:0] out_rsp_data;
	input wire [OUT_TAG_WIDTH - 1:0] out_rsp_tag;
	output wire out_rsp_ready;
	localparam TAG_ID_WIDTH = TAG_WIDTH - UUID_WIDTH;
	localparam IBUF_DATA_WIDTH = (TAG_ID_WIDTH + NUM_REQS) + (NUM_REQS * DATA_RATIO_W);
	localparam STATE_WAIT = 0;
	localparam STATE_SEND = 1;
	wire state_r;
	reg state_n;
	wire out_req_valid_r;
	reg out_req_valid_n;
	wire out_req_rw_r;
	reg out_req_rw_n;
	wire [OUT_REQS - 1:0] out_req_mask_r;
	reg [OUT_REQS - 1:0] out_req_mask_n;
	wire [(OUT_REQS * OUT_ADDR_WIDTH) - 1:0] out_req_addr_r;
	reg [(OUT_REQS * OUT_ADDR_WIDTH) - 1:0] out_req_addr_n;
	wire [(OUT_REQS * (USER_WIDTH > 0 ? USER_WIDTH : 1)) - 1:0] out_req_user_r;
	reg [(OUT_REQS * (USER_WIDTH > 0 ? USER_WIDTH : 1)) - 1:0] out_req_user_n;
	wire [((OUT_REQS * DATA_RATIO) * DATA_IN_SIZE) - 1:0] out_req_byteen_r;
	reg [((OUT_REQS * DATA_RATIO) * DATA_IN_SIZE) - 1:0] out_req_byteen_n;
	wire [((OUT_REQS * DATA_RATIO) * DATA_IN_WIDTH) - 1:0] out_req_data_r;
	reg [((OUT_REQS * DATA_RATIO) * DATA_IN_WIDTH) - 1:0] out_req_data_n;
	wire [OUT_TAG_WIDTH - 1:0] out_req_tag_r;
	reg [OUT_TAG_WIDTH - 1:0] out_req_tag_n;
	reg in_req_ready_n;
	wire ibuf_push;
	wire ibuf_pop;
	wire [QUEUE_ADDRW - 1:0] ibuf_waddr;
	wire [QUEUE_ADDRW - 1:0] ibuf_raddr;
	wire ibuf_full;
	wire ibuf_empty;
	wire [IBUF_DATA_WIDTH - 1:0] ibuf_din;
	wire [IBUF_DATA_WIDTH - 1:0] ibuf_dout;
	wire [OUT_REQS - 1:0] batch_valid_r;
	wire [OUT_REQS - 1:0] batch_valid_n;
	wire [(OUT_REQS * OUT_ADDR_WIDTH) - 1:0] seed_addr_r;
	wire [(OUT_REQS * OUT_ADDR_WIDTH) - 1:0] seed_addr_n;
	wire [(OUT_REQS * (USER_WIDTH > 0 ? USER_WIDTH : 1)) - 1:0] seed_user_r;
	wire [(OUT_REQS * (USER_WIDTH > 0 ? USER_WIDTH : 1)) - 1:0] seed_user_n;
	wire [NUM_REQS - 1:0] addr_matches_r;
	wire [NUM_REQS - 1:0] addr_matches_n;
	wire [NUM_REQS - 1:0] req_rem_mask_r;
	reg [NUM_REQS - 1:0] req_rem_mask_n;
	wire [(NUM_REQS * DATA_RATIO_W) - 1:0] in_addr_offset;
	genvar _gv_i_175;
	generate
		for (_gv_i_175 = 0; _gv_i_175 < NUM_REQS; _gv_i_175 = _gv_i_175 + 1) begin : g_in_addr_offset
			localparam i = _gv_i_175;
			assign in_addr_offset[i * DATA_RATIO_W+:DATA_RATIO_W] = in_req_addr[(i * ADDR_WIDTH) + (DATA_RATIO_W - 1)-:DATA_RATIO_W];
		end
	endgenerate
	genvar _gv_i_176;
	function automatic signed [DATA_RATIO_W - 1:0] sv2v_cast_02C68_signed;
		input reg signed [DATA_RATIO_W - 1:0] inp;
		sv2v_cast_02C68_signed = inp;
	endfunction
	generate
		for (_gv_i_176 = 0; _gv_i_176 < OUT_REQS; _gv_i_176 = _gv_i_176 + 1) begin : g_seed_gen
			localparam i = _gv_i_176;
			wire [DATA_RATIO - 1:0] batch_mask;
			wire [DATA_RATIO_W - 1:0] batch_idx;
			assign batch_mask = in_req_mask[i * DATA_RATIO+:DATA_RATIO] & req_rem_mask_r[i * DATA_RATIO+:DATA_RATIO];
			VX_priority_encoder #(.N(DATA_RATIO)) batch_sel(
				.data_in(batch_mask),
				.index_out(batch_idx),
				.valid_out(batch_valid_n[i]),
				.onehot_out()
			);
			wire [(DATA_RATIO * OUT_ADDR_WIDTH) - 1:0] addr_base;
			genvar _gv_j_14;
			for (_gv_j_14 = 0; _gv_j_14 < DATA_RATIO; _gv_j_14 = _gv_j_14 + 1) begin : g_addr_base
				localparam j = _gv_j_14;
				assign addr_base[j * OUT_ADDR_WIDTH+:OUT_ADDR_WIDTH] = in_req_addr[(((DATA_RATIO * i) + j) * ADDR_WIDTH) + ((ADDR_WIDTH - 1) >= DATA_RATIO_W ? ADDR_WIDTH - 1 : ((ADDR_WIDTH - 1) + ((ADDR_WIDTH - 1) >= DATA_RATIO_W ? ((ADDR_WIDTH - 1) - DATA_RATIO_W) + 1 : (DATA_RATIO_W - (ADDR_WIDTH - 1)) + 1)) - 1)-:((ADDR_WIDTH - 1) >= DATA_RATIO_W ? ((ADDR_WIDTH - 1) - DATA_RATIO_W) + 1 : (DATA_RATIO_W - (ADDR_WIDTH - 1)) + 1)];
			end
			wire [(DATA_RATIO * (USER_WIDTH > 0 ? USER_WIDTH : 1)) - 1:0] req_user;
			genvar _gv_j_15;
			for (_gv_j_15 = 0; _gv_j_15 < DATA_RATIO; _gv_j_15 = _gv_j_15 + 1) begin : g_req_user
				localparam j = _gv_j_15;
				assign req_user[j * (USER_WIDTH > 0 ? USER_WIDTH : 1)+:(USER_WIDTH > 0 ? USER_WIDTH : 1)] = in_req_user[((DATA_RATIO * i) + j) * (USER_WIDTH > 0 ? USER_WIDTH : 1)+:(USER_WIDTH > 0 ? USER_WIDTH : 1)];
			end
			assign seed_addr_n[i * OUT_ADDR_WIDTH+:OUT_ADDR_WIDTH] = addr_base[batch_idx * OUT_ADDR_WIDTH+:OUT_ADDR_WIDTH];
			assign seed_user_n[i * (USER_WIDTH > 0 ? USER_WIDTH : 1)+:(USER_WIDTH > 0 ? USER_WIDTH : 1)] = req_user[batch_idx * (USER_WIDTH > 0 ? USER_WIDTH : 1)+:(USER_WIDTH > 0 ? USER_WIDTH : 1)];
			genvar _gv_j_16;
			for (_gv_j_16 = 0; _gv_j_16 < DATA_RATIO; _gv_j_16 = _gv_j_16 + 1) begin : g_addr_matches_n
				localparam j = _gv_j_16;
				assign addr_matches_n[(i * DATA_RATIO) + j] = (addr_base[j * OUT_ADDR_WIDTH+:OUT_ADDR_WIDTH] == seed_addr_n[i * OUT_ADDR_WIDTH+:OUT_ADDR_WIDTH]) && (~in_req_no_merge || (sv2v_cast_02C68_signed(j) == batch_idx));
			end
		end
	endgenerate
	wire [NUM_REQS - 1:0] current_pmask = in_req_mask & addr_matches_r;
	wire [((OUT_REQS * DATA_RATIO) * DATA_IN_SIZE) - 1:0] req_byteen_merged;
	wire [((OUT_REQS * DATA_RATIO) * DATA_IN_WIDTH) - 1:0] req_data_merged;
	genvar _gv_i_177;
	generate
		for (_gv_i_177 = 0; _gv_i_177 < OUT_REQS; _gv_i_177 = _gv_i_177 + 1) begin : g_data_merged
			localparam i = _gv_i_177;
			reg [(DATA_RATIO * DATA_IN_SIZE) - 1:0] byteen_merged;
			reg [(DATA_RATIO * DATA_IN_WIDTH) - 1:0] data_merged;
			always @(*) begin
				byteen_merged = 1'sb0;
				data_merged = 1'sbx;
				begin : sv2v_autoblock_1
					integer j;
					for (j = 0; j < DATA_RATIO; j = j + 1)
						begin : sv2v_autoblock_2
							integer k;
							for (k = 0; k < DATA_IN_SIZE; k = k + 1)
								if (current_pmask[(i * DATA_RATIO) + j] && in_req_byteen[(((DATA_RATIO * i) + j) * DATA_IN_SIZE) + k]) begin
									byteen_merged[(in_addr_offset[((DATA_RATIO * i) + j) * DATA_RATIO_W+:DATA_RATIO_W] * DATA_IN_SIZE) + k] = 1'b1;
									data_merged[(in_addr_offset[((DATA_RATIO * i) + j) * DATA_RATIO_W+:DATA_RATIO_W] * DATA_IN_WIDTH) + (k * 8)+:8] = in_req_data[(((DATA_RATIO * i) + j) * DATA_IN_WIDTH) + (k * 8)+:8];
								end
						end
				end
			end
			assign req_byteen_merged[DATA_IN_SIZE * (i * DATA_RATIO)+:DATA_IN_SIZE * DATA_RATIO] = byteen_merged;
			assign req_data_merged[DATA_IN_WIDTH * (i * DATA_RATIO)+:DATA_IN_WIDTH * DATA_RATIO] = data_merged;
		end
	endgenerate
	wire is_last_batch = ~(|((in_req_mask & ~addr_matches_r) & req_rem_mask_r));
	wire out_req_fire = out_req_valid && out_req_ready;
	always @(*) begin
		state_n = state_r;
		out_req_valid_n = out_req_valid_r;
		out_req_mask_n = out_req_mask_r;
		out_req_rw_n = out_req_rw_r;
		out_req_addr_n = out_req_addr_r;
		out_req_user_n = out_req_user_r;
		out_req_byteen_n = out_req_byteen_r;
		out_req_data_n = out_req_data_r;
		out_req_tag_n = out_req_tag_r;
		req_rem_mask_n = req_rem_mask_r;
		in_req_ready_n = 0;
		case (state_r)
			STATE_WAIT: begin
				if (out_req_fire)
					out_req_valid_n = 0;
				if ((in_req_valid && ~out_req_valid_n) && ~ibuf_full)
					state_n = STATE_SEND;
			end
			default: begin
				state_n = STATE_WAIT;
				out_req_valid_n = 1;
				out_req_mask_n = batch_valid_r;
				out_req_rw_n = in_req_rw;
				out_req_addr_n = seed_addr_r;
				out_req_user_n = seed_user_r;
				out_req_byteen_n = req_byteen_merged;
				out_req_data_n = req_data_merged;
				out_req_tag_n = {in_req_tag[TAG_WIDTH - 1-:UUID_WIDTH], ibuf_waddr};
				req_rem_mask_n = (is_last_batch ? {NUM_REQS {1'sb1}} : req_rem_mask_r & ~current_pmask);
				in_req_ready_n = is_last_batch;
			end
		endcase
	end
	VX_pipe_register #(
		.DATAW(((((1 + NUM_REQS) + 2) + NUM_REQS) + (OUT_REQS * ((((((2 + OUT_ADDR_WIDTH) + (USER_WIDTH > 0 ? USER_WIDTH : 1)) + OUT_ADDR_WIDTH) + (USER_WIDTH > 0 ? USER_WIDTH : 1)) + DATA_OUT_SIZE) + DATA_OUT_WIDTH))) + OUT_TAG_WIDTH),
		.RESETW((1 + NUM_REQS) + 1),
		.INIT_VALUE({1'b0, {NUM_REQS {1'b1}}, 1'b0})
	) pipe_reg(
		.clk(clk),
		.reset(reset),
		.enable(1'b1),
		.data_in({state_n, req_rem_mask_n, out_req_valid_n, out_req_rw_n, addr_matches_n, batch_valid_n, out_req_mask_n, seed_addr_n, seed_user_n, out_req_addr_n, out_req_user_n, out_req_byteen_n, out_req_data_n, out_req_tag_n}),
		.data_out({state_r, req_rem_mask_r, out_req_valid_r, out_req_rw_r, addr_matches_r, batch_valid_r, out_req_mask_r, seed_addr_r, seed_user_r, out_req_addr_r, out_req_user_r, out_req_byteen_r, out_req_data_r, out_req_tag_r})
	);
	wire out_rsp_fire = out_rsp_valid && out_rsp_ready;
	wire out_rsp_eop;
	wire req_sent = state_r == STATE_SEND;
	assign ibuf_push = req_sent && ~in_req_rw;
	assign ibuf_pop = out_rsp_fire && out_rsp_eop;
	assign ibuf_raddr = out_rsp_tag[QUEUE_ADDRW - 1:0];
	wire [TAG_ID_WIDTH - 1:0] ibuf_din_tag = in_req_tag[TAG_ID_WIDTH - 1:0];
	wire [(NUM_REQS * DATA_RATIO_W) - 1:0] ibuf_din_offset = in_addr_offset;
	wire [NUM_REQS - 1:0] ibuf_din_pmask = current_pmask;
	assign ibuf_din = {ibuf_din_tag, ibuf_din_pmask, ibuf_din_offset};
	VX_index_buffer #(
		.DATAW(IBUF_DATA_WIDTH),
		.SIZE(QUEUE_SIZE)
	) req_ibuf(
		.clk(clk),
		.reset(reset),
		.acquire_en(ibuf_push),
		.write_addr(ibuf_waddr),
		.write_data(ibuf_din),
		.read_data(ibuf_dout),
		.read_addr(ibuf_raddr),
		.release_en(ibuf_pop),
		.full(ibuf_full),
		.empty(ibuf_empty)
	);
	assign out_req_valid = out_req_valid_r;
	assign out_req_rw = out_req_rw_r;
	assign out_req_mask = out_req_mask_r;
	assign out_req_byteen = out_req_byteen_r;
	assign out_req_addr = out_req_addr_r;
	generate
		if (USER_WIDTH != 0) begin : g_out_req_user
			assign out_req_user = out_req_user_r;
		end
		else begin : g_out_req_user_0
			assign out_req_user = 1'sb0;
		end
	endgenerate
	assign out_req_data = out_req_data_r;
	assign out_req_tag = out_req_tag_r;
	assign in_req_ready = in_req_ready_n;
	reg [(QUEUE_SIZE * OUT_REQS) - 1:0] rsp_rem_mask;
	wire [OUT_REQS - 1:0] rsp_rem_mask_n = rsp_rem_mask[ibuf_raddr * OUT_REQS+:OUT_REQS] & ~out_rsp_mask;
	assign out_rsp_eop = ~(|rsp_rem_mask_n);
	always @(posedge clk) begin
		if (ibuf_push)
			rsp_rem_mask[ibuf_waddr * OUT_REQS+:OUT_REQS] <= batch_valid_r;
		if (out_rsp_fire)
			rsp_rem_mask[ibuf_raddr * OUT_REQS+:OUT_REQS] <= rsp_rem_mask_n;
	end
	wire [(NUM_REQS * DATA_RATIO_W) - 1:0] ibuf_dout_offset;
	wire [NUM_REQS - 1:0] ibuf_dout_pmask;
	wire [TAG_ID_WIDTH - 1:0] ibuf_dout_tag;
	assign {ibuf_dout_tag, ibuf_dout_pmask, ibuf_dout_offset} = ibuf_dout;
	wire [(NUM_REQS * DATA_IN_WIDTH) - 1:0] in_rsp_data_n;
	genvar _gv_i_178;
	generate
		for (_gv_i_178 = 0; _gv_i_178 < OUT_REQS; _gv_i_178 = _gv_i_178 + 1) begin : g_in_rsp_data_n
			localparam i = _gv_i_178;
			genvar _gv_j_17;
			for (_gv_j_17 = 0; _gv_j_17 < DATA_RATIO; _gv_j_17 = _gv_j_17 + 1) begin : g_j
				localparam j = _gv_j_17;
				assign in_rsp_data_n[((i * DATA_RATIO) + j) * DATA_IN_WIDTH+:DATA_IN_WIDTH] = out_rsp_data[(i * DATA_OUT_WIDTH) + (ibuf_dout_offset[((i * DATA_RATIO) + j) * DATA_RATIO_W+:DATA_RATIO_W] * DATA_IN_WIDTH)+:DATA_IN_WIDTH];
			end
		end
	endgenerate
	wire [NUM_REQS - 1:0] in_rsp_mask_n;
	genvar _gv_i_179;
	generate
		for (_gv_i_179 = 0; _gv_i_179 < OUT_REQS; _gv_i_179 = _gv_i_179 + 1) begin : g_in_rsp_mask_n
			localparam i = _gv_i_179;
			genvar _gv_j_18;
			for (_gv_j_18 = 0; _gv_j_18 < DATA_RATIO; _gv_j_18 = _gv_j_18 + 1) begin : g_j
				localparam j = _gv_j_18;
				assign in_rsp_mask_n[(i * DATA_RATIO) + j] = out_rsp_mask[i] && ibuf_dout_pmask[(i * DATA_RATIO) + j];
			end
		end
	endgenerate
	assign in_rsp_valid = out_rsp_valid;
	assign in_rsp_mask = in_rsp_mask_n;
	assign in_rsp_data = in_rsp_data_n;
	assign in_rsp_tag = {out_rsp_tag[OUT_TAG_WIDTH - 1-:UUID_WIDTH], ibuf_dout_tag};
	assign out_rsp_ready = in_rsp_ready;
	reg [PERF_CTR_BITS - 1:0] misses_r;
	wire partial_transfer = out_req_fire && (req_rem_mask_r != {NUM_REQS {1'sb1}});
	function automatic [PERF_CTR_BITS - 1:0] sv2v_cast_184FC;
		input reg [PERF_CTR_BITS - 1:0] inp;
		sv2v_cast_184FC = inp;
	endfunction
	always @(posedge clk)
		if (reset)
			misses_r <= 1'sb0;
		else
			misses_r <= misses_r + sv2v_cast_184FC(partial_transfer);
	assign misses = misses_r;
endmodule
module VX_mem_scheduler (
	clk,
	reset,
	core_req_valid,
	core_req_rw,
	core_req_mask,
	core_req_byteen,
	core_req_addr,
	core_req_user,
	core_req_data,
	core_req_tag,
	core_req_ready,
	req_queue_empty,
	req_queue_rw_notify,
	core_rsp_valid,
	core_rsp_mask,
	core_rsp_data,
	core_rsp_tag,
	core_rsp_sop,
	core_rsp_eop,
	core_rsp_ready,
	mem_req_valid,
	mem_req_rw,
	mem_req_mask,
	mem_req_byteen,
	mem_req_addr,
	mem_req_user,
	mem_req_data,
	mem_req_tag,
	mem_req_ready,
	mem_rsp_valid,
	mem_rsp_mask,
	mem_rsp_data,
	mem_rsp_tag,
	mem_rsp_ready
);
	parameter INSTANCE_ID = "";
	parameter CORE_REQS = 1;
	parameter MEM_CHANNELS = 1;
	parameter WORD_SIZE = 4;
	parameter LINE_SIZE = WORD_SIZE;
	parameter ADDR_WIDTH = 32 - $clog2(WORD_SIZE);
	parameter USER_WIDTH = 0;
	parameter TAG_WIDTH = 8;
	parameter UUID_WIDTH = 0;
	parameter CORE_QUEUE_SIZE = 8;
	parameter MEM_QUEUE_SIZE = CORE_QUEUE_SIZE;
	parameter RSP_PARTIAL = 0;
	parameter CORE_OUT_BUF = 0;
	parameter MEM_OUT_BUF = 0;
	parameter WORD_WIDTH = WORD_SIZE * 8;
	parameter LINE_WIDTH = LINE_SIZE * 8;
	parameter COALESCE_ENABLE = (CORE_REQS > 1) && (LINE_SIZE != WORD_SIZE);
	parameter PER_LINE_REQS = LINE_SIZE / WORD_SIZE;
	parameter MERGED_REQS = CORE_REQS / PER_LINE_REQS;
	parameter MEM_BATCHES = ((MERGED_REQS + MEM_CHANNELS) - 1) / MEM_CHANNELS;
	parameter MEM_BATCH_BITS = $clog2(MEM_BATCHES);
	parameter MEM_QUEUE_ADDRW = $clog2((COALESCE_ENABLE ? MEM_QUEUE_SIZE : CORE_QUEUE_SIZE));
	parameter MEM_ADDR_WIDTH = ADDR_WIDTH - $clog2(PER_LINE_REQS);
	parameter MEM_TAG_WIDTH = (UUID_WIDTH + MEM_QUEUE_ADDRW) + MEM_BATCH_BITS;
	parameter CORE_QUEUE_ADDRW = $clog2(CORE_QUEUE_SIZE);
	input wire clk;
	input wire reset;
	input wire core_req_valid;
	input wire core_req_rw;
	input wire [CORE_REQS - 1:0] core_req_mask;
	input wire [(CORE_REQS * WORD_SIZE) - 1:0] core_req_byteen;
	input wire [(CORE_REQS * ADDR_WIDTH) - 1:0] core_req_addr;
	input wire [(CORE_REQS * (USER_WIDTH > 0 ? USER_WIDTH : 1)) - 1:0] core_req_user;
	input wire [(CORE_REQS * WORD_WIDTH) - 1:0] core_req_data;
	input wire [TAG_WIDTH - 1:0] core_req_tag;
	output wire core_req_ready;
	output wire req_queue_empty;
	output wire req_queue_rw_notify;
	output wire core_rsp_valid;
	output wire [CORE_REQS - 1:0] core_rsp_mask;
	output wire [(CORE_REQS * WORD_WIDTH) - 1:0] core_rsp_data;
	output wire [TAG_WIDTH - 1:0] core_rsp_tag;
	output wire core_rsp_sop;
	output wire core_rsp_eop;
	input wire core_rsp_ready;
	output wire mem_req_valid;
	output wire mem_req_rw;
	output wire [MEM_CHANNELS - 1:0] mem_req_mask;
	output wire [(MEM_CHANNELS * LINE_SIZE) - 1:0] mem_req_byteen;
	output wire [(MEM_CHANNELS * MEM_ADDR_WIDTH) - 1:0] mem_req_addr;
	output wire [(MEM_CHANNELS * (USER_WIDTH > 0 ? USER_WIDTH : 1)) - 1:0] mem_req_user;
	output wire [(MEM_CHANNELS * LINE_WIDTH) - 1:0] mem_req_data;
	output wire [MEM_TAG_WIDTH - 1:0] mem_req_tag;
	input wire mem_req_ready;
	input wire mem_rsp_valid;
	input wire [MEM_CHANNELS - 1:0] mem_rsp_mask;
	input wire [(MEM_CHANNELS * LINE_WIDTH) - 1:0] mem_rsp_data;
	input wire [MEM_TAG_WIDTH - 1:0] mem_rsp_tag;
	output wire mem_rsp_ready;
	localparam BATCH_SEL_WIDTH = (MEM_BATCH_BITS > 0 ? MEM_BATCH_BITS : 1);
	localparam STALL_TIMEOUT = 10000000;
	localparam TAG_ID_WIDTH = TAG_WIDTH - UUID_WIDTH;
	localparam REQQ_TAG_WIDTH = UUID_WIDTH + CORE_QUEUE_ADDRW;
	localparam MERGED_TAG_WIDTH = UUID_WIDTH + MEM_QUEUE_ADDRW;
	localparam CORE_CHANNELS = (COALESCE_ENABLE ? CORE_REQS : MEM_CHANNELS);
	localparam CORE_BATCHES = (COALESCE_ENABLE ? 1 : MEM_BATCHES);
	localparam CORE_BATCH_BITS = $clog2(CORE_BATCHES);
	wire ibuf_push;
	wire ibuf_pop;
	wire [CORE_QUEUE_ADDRW - 1:0] ibuf_waddr;
	wire [CORE_QUEUE_ADDRW - 1:0] ibuf_raddr;
	wire ibuf_full;
	wire ibuf_empty;
	wire [TAG_ID_WIDTH - 1:0] ibuf_din;
	wire [TAG_ID_WIDTH - 1:0] ibuf_dout;
	wire reqq_valid;
	wire [CORE_REQS - 1:0] reqq_mask;
	wire reqq_rw;
	wire [(CORE_REQS * WORD_SIZE) - 1:0] reqq_byteen;
	wire [(CORE_REQS * ADDR_WIDTH) - 1:0] reqq_addr;
	wire [(CORE_REQS * (USER_WIDTH > 0 ? USER_WIDTH : 1)) - 1:0] reqq_user;
	wire [(CORE_REQS * WORD_WIDTH) - 1:0] reqq_data;
	wire [REQQ_TAG_WIDTH - 1:0] reqq_tag;
	wire reqq_ready;
	wire reqq_valid_s;
	wire [MERGED_REQS - 1:0] reqq_mask_s;
	wire reqq_rw_s;
	wire [(MERGED_REQS * LINE_SIZE) - 1:0] reqq_byteen_s;
	wire [(MERGED_REQS * MEM_ADDR_WIDTH) - 1:0] reqq_addr_s;
	wire [(MERGED_REQS * (USER_WIDTH > 0 ? USER_WIDTH : 1)) - 1:0] reqq_user_s;
	wire [(MERGED_REQS * LINE_WIDTH) - 1:0] reqq_data_s;
	wire [MERGED_TAG_WIDTH - 1:0] reqq_tag_s;
	wire reqq_ready_s;
	wire mem_req_valid_s;
	wire [MEM_CHANNELS - 1:0] mem_req_mask_s;
	wire mem_req_rw_s;
	wire [(MEM_CHANNELS * LINE_SIZE) - 1:0] mem_req_byteen_s;
	wire [(MEM_CHANNELS * MEM_ADDR_WIDTH) - 1:0] mem_req_addr_s;
	wire [(MEM_CHANNELS * (USER_WIDTH > 0 ? USER_WIDTH : 1)) - 1:0] mem_req_user_s;
	wire [(MEM_CHANNELS * LINE_WIDTH) - 1:0] mem_req_data_s;
	wire [MEM_TAG_WIDTH - 1:0] mem_req_tag_s;
	wire mem_req_ready_s;
	wire mem_rsp_valid_s;
	wire [CORE_CHANNELS - 1:0] mem_rsp_mask_s;
	wire [(CORE_CHANNELS * WORD_WIDTH) - 1:0] mem_rsp_data_s;
	wire [MEM_TAG_WIDTH - 1:0] mem_rsp_tag_s;
	wire mem_rsp_ready_s;
	wire crsp_valid;
	wire [CORE_REQS - 1:0] crsp_mask;
	wire [(CORE_REQS * WORD_WIDTH) - 1:0] crsp_data;
	wire [TAG_WIDTH - 1:0] crsp_tag;
	wire crsp_sop;
	wire crsp_eop;
	wire crsp_ready;
	wire req_sent_all;
	wire ibuf_ready = core_req_rw || ~ibuf_full;
	wire reqq_valid_in = core_req_valid && ibuf_ready;
	wire reqq_ready_in;
	wire [REQQ_TAG_WIDTH - 1:0] reqq_tag_u;
	generate
		if (UUID_WIDTH != 0) begin : g_reqq_tag_u_uuid
			assign reqq_tag_u = {core_req_tag[TAG_WIDTH - 1-:UUID_WIDTH], ibuf_waddr};
		end
		else begin : g_reqq_tag_u
			assign reqq_tag_u = ibuf_waddr;
		end
	endgenerate
	VX_elastic_buffer #(
		.DATAW((1 + (CORE_REQS * ((((1 + WORD_SIZE) + ADDR_WIDTH) + (USER_WIDTH > 0 ? USER_WIDTH : 1)) + WORD_WIDTH))) + REQQ_TAG_WIDTH),
		.SIZE(CORE_QUEUE_SIZE),
		.OUT_REG(1)
	) req_queue(
		.clk(clk),
		.reset(reset),
		.valid_in(reqq_valid_in),
		.ready_in(reqq_ready_in),
		.data_in({core_req_rw, core_req_mask, core_req_byteen, core_req_addr, core_req_user, core_req_data, reqq_tag_u}),
		.data_out({reqq_rw, reqq_mask, reqq_byteen, reqq_addr, reqq_user, reqq_data, reqq_tag}),
		.valid_out(reqq_valid),
		.ready_out(reqq_ready)
	);
	assign core_req_ready = reqq_ready_in && ibuf_ready;
	assign req_queue_rw_notify = (reqq_valid && reqq_ready) && reqq_rw;
	assign req_queue_empty = !reqq_valid && ibuf_empty;
	wire core_req_fire = core_req_valid && core_req_ready;
	wire crsp_fire = crsp_valid && crsp_ready;
	assign ibuf_push = core_req_fire && ~core_req_rw;
	assign ibuf_pop = crsp_fire && crsp_eop;
	assign ibuf_raddr = mem_rsp_tag_s[CORE_BATCH_BITS+:CORE_QUEUE_ADDRW];
	assign ibuf_din = core_req_tag[TAG_ID_WIDTH - 1:0];
	VX_index_buffer #(
		.DATAW(TAG_ID_WIDTH),
		.SIZE(CORE_QUEUE_SIZE)
	) req_ibuf(
		.clk(clk),
		.reset(reset),
		.acquire_en(ibuf_push),
		.write_addr(ibuf_waddr),
		.write_data(ibuf_din),
		.read_data(ibuf_dout),
		.read_addr(ibuf_raddr),
		.release_en(ibuf_pop),
		.full(ibuf_full),
		.empty(ibuf_empty)
	);
	generate
		if (COALESCE_ENABLE) begin : g_coalescer
			localparam [0:0] sv2v_uu_coalescer_ext_in_req_no_merge_0 = 1'sb0;
			VX_mem_coalescer #(
				.INSTANCE_ID(""),
				.NUM_REQS(CORE_REQS),
				.DATA_IN_SIZE(WORD_SIZE),
				.DATA_OUT_SIZE(LINE_SIZE),
				.ADDR_WIDTH(ADDR_WIDTH),
				.USER_WIDTH(USER_WIDTH),
				.TAG_WIDTH(REQQ_TAG_WIDTH),
				.UUID_WIDTH(UUID_WIDTH),
				.QUEUE_SIZE(MEM_QUEUE_SIZE)
			) coalescer(
				.clk(clk),
				.reset(reset),
				.misses(),
				.in_req_valid(reqq_valid),
				.in_req_mask(reqq_mask),
				.in_req_rw(reqq_rw),
				.in_req_byteen(reqq_byteen),
				.in_req_addr(reqq_addr),
				.in_req_user(reqq_user),
				.in_req_no_merge(sv2v_uu_coalescer_ext_in_req_no_merge_0),
				.in_req_data(reqq_data),
				.in_req_tag(reqq_tag),
				.in_req_ready(reqq_ready),
				.in_rsp_valid(mem_rsp_valid_s),
				.in_rsp_mask(mem_rsp_mask_s),
				.in_rsp_data(mem_rsp_data_s),
				.in_rsp_tag(mem_rsp_tag_s),
				.in_rsp_ready(mem_rsp_ready_s),
				.out_req_valid(reqq_valid_s),
				.out_req_mask(reqq_mask_s),
				.out_req_rw(reqq_rw_s),
				.out_req_byteen(reqq_byteen_s),
				.out_req_addr(reqq_addr_s),
				.out_req_user(reqq_user_s),
				.out_req_data(reqq_data_s),
				.out_req_tag(reqq_tag_s),
				.out_req_ready(reqq_ready_s),
				.out_rsp_valid(mem_rsp_valid),
				.out_rsp_mask(mem_rsp_mask),
				.out_rsp_data(mem_rsp_data),
				.out_rsp_tag(mem_rsp_tag),
				.out_rsp_ready(mem_rsp_ready)
			);
		end
		else begin : g_no_coalescer
			assign reqq_valid_s = reqq_valid;
			assign reqq_mask_s = reqq_mask;
			assign reqq_rw_s = reqq_rw;
			assign reqq_byteen_s = reqq_byteen;
			assign reqq_addr_s = reqq_addr;
			assign reqq_user_s = reqq_user;
			assign reqq_data_s = reqq_data;
			assign reqq_tag_s = reqq_tag;
			assign reqq_ready = reqq_ready_s;
			assign mem_rsp_valid_s = mem_rsp_valid;
			assign mem_rsp_mask_s = mem_rsp_mask;
			assign mem_rsp_data_s = mem_rsp_data;
			assign mem_rsp_tag_s = mem_rsp_tag;
			assign mem_rsp_ready = mem_rsp_ready_s;
		end
	endgenerate
	wire [(MEM_BATCHES * MEM_CHANNELS) - 1:0] mem_req_mask_b;
	wire [((MEM_BATCHES * MEM_CHANNELS) * LINE_SIZE) - 1:0] mem_req_byteen_b;
	wire [((MEM_BATCHES * MEM_CHANNELS) * MEM_ADDR_WIDTH) - 1:0] mem_req_addr_b;
	wire [((MEM_BATCHES * MEM_CHANNELS) * (USER_WIDTH > 0 ? USER_WIDTH : 1)) - 1:0] mem_req_user_b;
	wire [((MEM_BATCHES * MEM_CHANNELS) * LINE_WIDTH) - 1:0] mem_req_data_b;
	wire [BATCH_SEL_WIDTH - 1:0] req_batch_idx;
	genvar _gv_i_180;
	generate
		for (_gv_i_180 = 0; _gv_i_180 < MEM_BATCHES; _gv_i_180 = _gv_i_180 + 1) begin : g_mem_req_data_b
			localparam i = _gv_i_180;
			genvar _gv_j_19;
			for (_gv_j_19 = 0; _gv_j_19 < MEM_CHANNELS; _gv_j_19 = _gv_j_19 + 1) begin : g_j
				localparam j = _gv_j_19;
				localparam r = (i * MEM_CHANNELS) + j;
				if (r < MERGED_REQS) begin : g_valid
					assign mem_req_mask_b[(i * MEM_CHANNELS) + j] = reqq_mask_s[r];
					assign mem_req_byteen_b[((i * MEM_CHANNELS) + j) * LINE_SIZE+:LINE_SIZE] = reqq_byteen_s[r * LINE_SIZE+:LINE_SIZE];
					assign mem_req_addr_b[((i * MEM_CHANNELS) + j) * MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH] = reqq_addr_s[r * MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
					assign mem_req_user_b[((i * MEM_CHANNELS) + j) * (USER_WIDTH > 0 ? USER_WIDTH : 1)+:(USER_WIDTH > 0 ? USER_WIDTH : 1)] = reqq_user_s[r * (USER_WIDTH > 0 ? USER_WIDTH : 1)+:(USER_WIDTH > 0 ? USER_WIDTH : 1)];
					assign mem_req_data_b[((i * MEM_CHANNELS) + j) * LINE_WIDTH+:LINE_WIDTH] = reqq_data_s[r * LINE_WIDTH+:LINE_WIDTH];
				end
				else begin : g_padding
					assign mem_req_mask_b[(i * MEM_CHANNELS) + j] = 0;
					assign mem_req_byteen_b[((i * MEM_CHANNELS) + j) * LINE_SIZE+:LINE_SIZE] = 1'sb0;
					assign mem_req_addr_b[((i * MEM_CHANNELS) + j) * MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH] = 1'sb0;
					assign mem_req_user_b[((i * MEM_CHANNELS) + j) * (USER_WIDTH > 0 ? USER_WIDTH : 1)+:(USER_WIDTH > 0 ? USER_WIDTH : 1)] = 1'sb0;
					assign mem_req_data_b[((i * MEM_CHANNELS) + j) * LINE_WIDTH+:LINE_WIDTH] = 1'sb0;
				end
			end
		end
	endgenerate
	assign mem_req_mask_s = mem_req_mask_b[req_batch_idx * MEM_CHANNELS+:MEM_CHANNELS];
	assign mem_req_rw_s = reqq_rw_s;
	assign mem_req_byteen_s = mem_req_byteen_b[LINE_SIZE * (req_batch_idx * MEM_CHANNELS)+:LINE_SIZE * MEM_CHANNELS];
	assign mem_req_addr_s = mem_req_addr_b[MEM_ADDR_WIDTH * (req_batch_idx * MEM_CHANNELS)+:MEM_ADDR_WIDTH * MEM_CHANNELS];
	assign mem_req_user_s = mem_req_user_b[(USER_WIDTH > 0 ? USER_WIDTH : 1) * (req_batch_idx * MEM_CHANNELS)+:(USER_WIDTH > 0 ? USER_WIDTH : 1) * MEM_CHANNELS];
	assign mem_req_data_s = mem_req_data_b[LINE_WIDTH * (req_batch_idx * MEM_CHANNELS)+:LINE_WIDTH * MEM_CHANNELS];
	function automatic signed [MEM_BATCH_BITS - 1:0] sv2v_cast_9A7F0_signed;
		input reg signed [MEM_BATCH_BITS - 1:0] inp;
		sv2v_cast_9A7F0_signed = inp;
	endfunction
	generate
		if (MEM_BATCHES != 1) begin : g_batch
			reg [MEM_BATCH_BITS - 1:0] req_batch_idx_r;
			wire is_degenerate_batch = ~(|mem_req_mask_s);
			wire mem_req_valid_b = reqq_valid_s && ~is_degenerate_batch;
			wire mem_req_ready_b = mem_req_ready_s || is_degenerate_batch;
			always @(posedge clk)
				if (reset)
					req_batch_idx_r <= 1'sb0;
				else if (reqq_valid_s && mem_req_ready_b) begin
					if (req_sent_all)
						req_batch_idx_r <= 1'sb0;
					else
						req_batch_idx_r <= req_batch_idx_r + sv2v_cast_9A7F0_signed(1);
				end
			wire [MEM_BATCHES - 1:0] req_batch_valids;
			wire [(MEM_BATCHES * MEM_BATCH_BITS) - 1:0] req_batch_idxs;
			wire [MEM_BATCH_BITS - 1:0] req_batch_idx_last;
			genvar _gv_i_181;
			for (_gv_i_181 = 0; _gv_i_181 < MEM_BATCHES; _gv_i_181 = _gv_i_181 + 1) begin : g_req_batch
				localparam i = _gv_i_181;
				assign req_batch_valids[i] = |mem_req_mask_b[i * MEM_CHANNELS+:MEM_CHANNELS];
				assign req_batch_idxs[i * MEM_BATCH_BITS+:MEM_BATCH_BITS] = sv2v_cast_9A7F0_signed(i);
			end
			VX_find_first #(
				.N(MEM_BATCHES),
				.DATAW(MEM_BATCH_BITS),
				.REVERSE(1)
			) find_last(
				.valid_in(req_batch_valids),
				.data_in(req_batch_idxs),
				.data_out(req_batch_idx_last),
				.valid_out()
			);
			assign mem_req_valid_s = mem_req_valid_b;
			assign req_batch_idx = req_batch_idx_r;
			assign req_sent_all = mem_req_ready_b && (req_batch_idx_r == req_batch_idx_last);
			assign mem_req_tag_s = {reqq_tag_s, req_batch_idx};
		end
		else begin : g_no_batch
			assign mem_req_valid_s = reqq_valid_s;
			assign req_batch_idx = 1'sb0;
			assign req_sent_all = mem_req_ready_s;
			assign mem_req_tag_s = reqq_tag_s;
		end
	endgenerate
	assign reqq_ready_s = req_sent_all;
	wire [(MEM_CHANNELS * (USER_WIDTH > 0 ? USER_WIDTH : 1)) - 1:0] mem_req_user_u;
	VX_elastic_buffer #(
		.DATAW(((MEM_CHANNELS + 1) + (MEM_CHANNELS * (((LINE_SIZE + MEM_ADDR_WIDTH) + (USER_WIDTH > 0 ? USER_WIDTH : 1)) + LINE_WIDTH))) + MEM_TAG_WIDTH),
		.SIZE(((MEM_OUT_BUF & 7) < 2 ? MEM_OUT_BUF & 7 : 2)),
		.OUT_REG(((MEM_OUT_BUF & 7) < 2 ? MEM_OUT_BUF & 7 : (MEM_OUT_BUF & 7) - 2))
	) mem_req_buf(
		.clk(clk),
		.reset(reset),
		.valid_in(mem_req_valid_s),
		.ready_in(mem_req_ready_s),
		.data_in({mem_req_mask_s, mem_req_rw_s, mem_req_byteen_s, mem_req_addr_s, mem_req_user_s, mem_req_data_s, mem_req_tag_s}),
		.data_out({mem_req_mask, mem_req_rw, mem_req_byteen, mem_req_addr, mem_req_user_u, mem_req_data, mem_req_tag}),
		.valid_out(mem_req_valid),
		.ready_out(mem_req_ready)
	);
	generate
		if (USER_WIDTH != 0) begin : g_mem_req_user
			assign mem_req_user = mem_req_user_u;
		end
		else begin : g_mem_req_user_0
			assign mem_req_user = 1'sb0;
		end
	endgenerate
	wire [BATCH_SEL_WIDTH - 1:0] rsp_batch_idx;
	generate
		if (CORE_BATCHES > 1) begin : g_rsp_batch_idx
			assign rsp_batch_idx = mem_rsp_tag_s[CORE_BATCH_BITS - 1:0];
		end
		else begin : g_rsp_batch_idx_0
			assign rsp_batch_idx = 1'sb0;
		end
	endgenerate
	function automatic signed [BATCH_SEL_WIDTH - 1:0] sv2v_cast_F44E4_signed;
		input reg signed [BATCH_SEL_WIDTH - 1:0] inp;
		sv2v_cast_F44E4_signed = inp;
	endfunction
	generate
		if (CORE_REQS == 1) begin : g_rsp_1
			assign crsp_valid = mem_rsp_valid_s;
			assign crsp_mask = mem_rsp_mask_s;
			assign crsp_sop = 1'b1;
			assign crsp_eop = 1'b1;
			assign crsp_data = mem_rsp_data_s;
			assign mem_rsp_ready_s = crsp_ready;
		end
		else begin : g_rsp_N
			reg [(CORE_QUEUE_SIZE * CORE_REQS) - 1:0] rsp_rem_mask;
			wire [CORE_REQS - 1:0] rsp_rem_mask_n;
			wire [CORE_REQS - 1:0] curr_mask;
			genvar _gv_r_4;
			for (_gv_r_4 = 0; _gv_r_4 < CORE_REQS; _gv_r_4 = _gv_r_4 + 1) begin : g_curr_mask
				localparam r = _gv_r_4;
				localparam i = r / CORE_CHANNELS;
				localparam j = r % CORE_CHANNELS;
				assign curr_mask[r] = (sv2v_cast_F44E4_signed(i) == rsp_batch_idx) && mem_rsp_mask_s[j];
			end
			assign rsp_rem_mask_n = rsp_rem_mask[ibuf_raddr * CORE_REQS+:CORE_REQS] & ~curr_mask;
			wire mem_rsp_fire_s = mem_rsp_valid_s && mem_rsp_ready_s;
			always @(posedge clk) begin
				if (ibuf_push)
					rsp_rem_mask[ibuf_waddr * CORE_REQS+:CORE_REQS] <= core_req_mask;
				if (mem_rsp_fire_s)
					rsp_rem_mask[ibuf_raddr * CORE_REQS+:CORE_REQS] <= rsp_rem_mask_n;
			end
			wire rsp_complete = ~(|rsp_rem_mask_n) || (CORE_REQS == 1);
			if (RSP_PARTIAL != 0) begin : g_rsp_partial
				reg [CORE_QUEUE_SIZE - 1:0] rsp_sop_r;
				always @(posedge clk) begin
					if (ibuf_push)
						rsp_sop_r[ibuf_waddr] <= 1;
					if (mem_rsp_fire_s)
						rsp_sop_r[ibuf_raddr] <= 0;
				end
				assign crsp_valid = mem_rsp_valid_s;
				assign crsp_mask = curr_mask;
				assign crsp_sop = rsp_sop_r[ibuf_raddr];
				genvar _gv_r_5;
				for (_gv_r_5 = 0; _gv_r_5 < CORE_REQS; _gv_r_5 = _gv_r_5 + 1) begin : g_crsp_data
					localparam r = _gv_r_5;
					localparam j = r % CORE_CHANNELS;
					assign crsp_data[r * WORD_WIDTH+:WORD_WIDTH] = mem_rsp_data_s[j * WORD_WIDTH+:WORD_WIDTH];
				end
				assign mem_rsp_ready_s = crsp_ready;
			end
			else begin : g_rsp_full
				wire [((CORE_CHANNELS * CORE_BATCHES) * WORD_WIDTH) - 1:0] rsp_store_n;
				reg [CORE_REQS - 1:0] rsp_orig_mask [CORE_QUEUE_SIZE - 1:0];
				genvar _gv_i_182;
				for (_gv_i_182 = 0; _gv_i_182 < CORE_CHANNELS; _gv_i_182 = _gv_i_182 + 1) begin : g_rsp_store
					localparam i = _gv_i_182;
					genvar _gv_j_20;
					for (_gv_j_20 = 0; _gv_j_20 < CORE_BATCHES; _gv_j_20 = _gv_j_20 + 1) begin : g_j
						localparam j = _gv_j_20;
						reg [WORD_WIDTH - 1:0] rsp_store [0:CORE_QUEUE_SIZE - 1];
						wire rsp_wren = (mem_rsp_fire_s && (sv2v_cast_F44E4_signed(j) == rsp_batch_idx)) && ((CORE_CHANNELS == 1) || mem_rsp_mask_s[i]);
						always @(posedge clk)
							if (rsp_wren)
								rsp_store[ibuf_raddr] <= mem_rsp_data_s[i * WORD_WIDTH+:WORD_WIDTH];
						assign rsp_store_n[((i * CORE_BATCHES) + j) * WORD_WIDTH+:WORD_WIDTH] = (rsp_wren ? mem_rsp_data_s[i * WORD_WIDTH+:WORD_WIDTH] : rsp_store[ibuf_raddr]);
					end
				end
				always @(posedge clk)
					if (ibuf_push)
						rsp_orig_mask[ibuf_waddr] <= core_req_mask;
				assign crsp_valid = mem_rsp_valid_s && rsp_complete;
				assign crsp_mask = rsp_orig_mask[ibuf_raddr];
				assign crsp_sop = 1'b1;
				genvar _gv_r_6;
				for (_gv_r_6 = 0; _gv_r_6 < CORE_REQS; _gv_r_6 = _gv_r_6 + 1) begin : g_crsp_data
					localparam r = _gv_r_6;
					localparam i = r / CORE_CHANNELS;
					localparam j = r % CORE_CHANNELS;
					assign crsp_data[r * WORD_WIDTH+:WORD_WIDTH] = rsp_store_n[((j * CORE_BATCHES) + i) * WORD_WIDTH+:WORD_WIDTH];
				end
				assign mem_rsp_ready_s = crsp_ready || ~rsp_complete;
			end
			assign crsp_eop = rsp_complete;
		end
		if (UUID_WIDTH != 0) begin : g_crsp_tag
			assign crsp_tag = {mem_rsp_tag_s[MEM_TAG_WIDTH - 1-:UUID_WIDTH], ibuf_dout};
		end
		else begin : g_crsp_tag_0
			assign crsp_tag = ibuf_dout;
		end
	endgenerate
	VX_elastic_buffer #(
		.DATAW(((CORE_REQS + 2) + (CORE_REQS * WORD_WIDTH)) + TAG_WIDTH),
		.SIZE(((CORE_OUT_BUF & 7) < 2 ? CORE_OUT_BUF & 7 : 2)),
		.OUT_REG(((CORE_OUT_BUF & 7) < 2 ? CORE_OUT_BUF & 7 : (CORE_OUT_BUF & 7) - 2))
	) rsp_buf(
		.clk(clk),
		.reset(reset),
		.valid_in(crsp_valid),
		.ready_in(crsp_ready),
		.data_in({crsp_mask, crsp_sop, crsp_eop, crsp_data, crsp_tag}),
		.data_out({core_rsp_mask, core_rsp_sop, core_rsp_eop, core_rsp_data, core_rsp_tag}),
		.valid_out(core_rsp_valid),
		.ready_out(core_rsp_ready)
	);
endmodule
module VX_multiplier (
	clk,
	enable,
	dataa,
	datab,
	result
);
	parameter A_WIDTH = 1;
	parameter B_WIDTH = A_WIDTH;
	parameter R_WIDTH = A_WIDTH + B_WIDTH;
	parameter SIGNED = 0;
	parameter LATENCY = 0;
	input wire clk;
	input wire enable;
	input wire [A_WIDTH - 1:0] dataa;
	input wire [B_WIDTH - 1:0] datab;
	output wire [R_WIDTH - 1:0] result;
	wire [R_WIDTH - 1:0] prod_w;
	function automatic [R_WIDTH - 1:0] sv2v_cast_18DBB;
		input reg [R_WIDTH - 1:0] inp;
		sv2v_cast_18DBB = inp;
	endfunction
	function automatic signed [R_WIDTH - 1:0] sv2v_cast_18DBB_signed;
		input reg signed [R_WIDTH - 1:0] inp;
		sv2v_cast_18DBB_signed = inp;
	endfunction
	generate
		if (SIGNED != 0) begin : g_prod_s
			assign prod_w = sv2v_cast_18DBB_signed($signed(dataa) * $signed(datab));
		end
		else begin : g_prod_u
			assign prod_w = sv2v_cast_18DBB(dataa * datab);
		end
	endgenerate
	VX_pipe_register #(
		.DATAW(R_WIDTH),
		.DEPTH(LATENCY)
	) pipe_reg(
		.clk(clk),
		.enable(enable),
		.reset(1'b0),
		.data_in(prod_w),
		.data_out(result)
	);
endmodule
module VX_nz_iterator (
	clk,
	reset,
	valid_in,
	data_in,
	next,
	valid_out,
	data_out,
	pid,
	sop,
	eop
);
	parameter DATAW = 8;
	parameter KEYW = DATAW;
	parameter N = 4;
	parameter OUT_REG = 0;
	parameter LPID_WIDTH = (N > 1 ? $clog2(N) : 1);
	input wire clk;
	input wire reset;
	input wire valid_in;
	input wire [(N * DATAW) - 1:0] data_in;
	input wire next;
	output wire valid_out;
	output reg [DATAW - 1:0] data_out;
	output reg [LPID_WIDTH - 1:0] pid;
	output reg sop;
	output reg eop;
	function automatic signed [LPID_WIDTH - 1:0] sv2v_cast_E36B1_signed;
		input reg signed [LPID_WIDTH - 1:0] inp;
		sv2v_cast_E36B1_signed = inp;
	endfunction
	generate
		if (N > 1) begin : g_iterator
			reg [N - 1:0] sent_mask_p;
			wire [LPID_WIDTH - 1:0] start_p;
			wire [LPID_WIDTH - 1:0] end_p;
			wire [N - 1:0] packet_valids;
			genvar _gv_i_183;
			for (_gv_i_183 = 0; _gv_i_183 < N; _gv_i_183 = _gv_i_183 + 1) begin : g_packet_valids
				localparam i = _gv_i_183;
				assign packet_valids[i] = |data_in[(i * DATAW) + (KEYW - 1)-:KEYW];
			end
			wire [(N * LPID_WIDTH) - 1:0] packet_ids;
			genvar _gv_i_184;
			for (_gv_i_184 = 0; _gv_i_184 < N; _gv_i_184 = _gv_i_184 + 1) begin : g_packet_ids
				localparam i = _gv_i_184;
				assign packet_ids[i * LPID_WIDTH+:LPID_WIDTH] = sv2v_cast_E36B1_signed(i);
			end
			VX_find_first #(
				.N(N),
				.DATAW(LPID_WIDTH),
				.REVERSE(0)
			) find_first(
				.valid_in(packet_valids & ~sent_mask_p),
				.data_in(packet_ids),
				.data_out(start_p),
				.valid_out()
			);
			VX_find_first #(
				.N(N),
				.DATAW(LPID_WIDTH),
				.REVERSE(1)
			) find_last(
				.valid_in(packet_valids),
				.data_in(packet_ids),
				.data_out(end_p),
				.valid_out()
			);
			reg is_first_p;
			wire is_last_p = start_p == end_p;
			wire enable = valid_in && (~valid_out || next);
			always @(posedge clk)
				if (reset || (enable && (is_last_p || eop))) begin
					sent_mask_p <= 1'sb0;
					is_first_p <= 1;
				end
				else if (enable) begin
					sent_mask_p[start_p] <= 1;
					is_first_p <= 0;
				end
			wire [((1 + DATAW) + LPID_WIDTH) + 2:1] sv2v_tmp_pipe_reg_data_out;
			always @(*) {valid_out, data_out, pid, sop, eop} = sv2v_tmp_pipe_reg_data_out;
			VX_pipe_register #(
				.DATAW(((1 + DATAW) + LPID_WIDTH) + 2),
				.RESETW(1),
				.DEPTH(OUT_REG)
			) pipe_reg(
				.clk(clk),
				.reset(reset || (enable && eop)),
				.enable(enable),
				.data_in({valid_in, data_in[start_p * DATAW+:DATAW], start_p, is_first_p, is_last_p}),
				.data_out(sv2v_tmp_pipe_reg_data_out)
			);
		end
		else begin : g_passthru
			assign valid_out = valid_in;
			wire [DATAW:1] sv2v_tmp_64A3B;
			assign sv2v_tmp_64A3B = data_in[0+:DATAW];
			always @(*) data_out = sv2v_tmp_64A3B;
			wire [LPID_WIDTH:1] sv2v_tmp_A25DB;
			assign sv2v_tmp_A25DB = 0;
			always @(*) pid = sv2v_tmp_A25DB;
			wire [1:1] sv2v_tmp_20045;
			assign sv2v_tmp_20045 = 1;
			always @(*) sop = sv2v_tmp_20045;
			wire [1:1] sv2v_tmp_B5906;
			assign sv2v_tmp_B5906 = 1;
			always @(*) eop = sv2v_tmp_B5906;
		end
	endgenerate
endmodule
module VX_onehot_encoder (
	data_in,
	data_out,
	valid_out
);
	parameter N = 1;
	parameter REVERSE = 0;
	parameter MODEL = 1;
	parameter LN = (N > 1 ? $clog2(N) : 1);
	input wire [N - 1:0] data_in;
	output wire [LN - 1:0] data_out;
	output wire valid_out;
	function automatic signed [LN - 1:0] sv2v_cast_48EE1_signed;
		input reg signed [LN - 1:0] inp;
		sv2v_cast_48EE1_signed = inp;
	endfunction
	generate
		if (N == 1) begin : g_n1
			assign data_out = 0;
			assign valid_out = data_in;
		end
		else if (N == 2) begin : g_n2
			assign data_out = data_in[!REVERSE];
			assign valid_out = |data_in;
		end
		else if (MODEL == 1) begin : g_model1
			localparam M = 1 << LN;
			wire [M - 1:0] addr [0:LN - 1];
			wire [M - 1:0] v [0:LN + 0];
			function automatic [M - 1:0] sv2v_cast_8461E;
				input reg [M - 1:0] inp;
				sv2v_cast_8461E = inp;
			endfunction
			assign v[0] = (REVERSE ? sv2v_cast_8461E(data_in) << (M - N) : sv2v_cast_8461E(data_in));
			genvar _gv_lvl_1;
			for (_gv_lvl_1 = 1; _gv_lvl_1 < (LN + 1); _gv_lvl_1 = _gv_lvl_1 + 1) begin : g_scan_l
				localparam lvl = _gv_lvl_1;
				localparam SN = 1 << (LN - lvl);
				localparam SI = M / SN;
				genvar _gv_s_2;
				for (_gv_s_2 = 0; _gv_s_2 < SN; _gv_s_2 = _gv_s_2 + 1) begin : g_scan_s
					localparam s = _gv_s_2;
					wire [1:0] vs = {v[lvl - 1][(s * SI) + (SI >> 1)], v[lvl - 1][s * SI]};
					assign v[lvl][s * SI] = |vs;
					if (lvl == 1) begin : g_lvl_1
						assign addr[lvl - 1][s * SI+:lvl] = vs[!REVERSE];
					end
					else begin : g_lvl_n
						assign addr[lvl - 1][s * SI+:lvl] = {vs[!REVERSE], addr[lvl - 2][s * SI+:lvl - 1] | addr[lvl - 2][(s * SI) + (SI >> 1)+:lvl - 1]};
					end
				end
			end
			assign data_out = addr[LN - 1][LN - 1:0];
			assign valid_out = v[LN][0];
		end
		else if ((MODEL == 2) && (REVERSE == 0)) begin : g_model2
			genvar _gv_j_21;
			for (_gv_j_21 = 0; _gv_j_21 < LN; _gv_j_21 = _gv_j_21 + 1) begin : g_data_out
				localparam j = _gv_j_21;
				wire [N - 1:0] mask;
				genvar _gv_i_185;
				for (_gv_i_185 = 0; _gv_i_185 < N; _gv_i_185 = _gv_i_185 + 1) begin : g_mask
					localparam i = _gv_i_185;
					assign mask[i] = i[j];
				end
				assign data_out[j] = |(mask & data_in);
			end
			assign valid_out = |data_in;
		end
		else begin : g_model0
			reg [LN - 1:0] index_w;
			if (REVERSE != 0) begin : g_msb
				always @(*) begin
					index_w = 1'sbx;
					begin : sv2v_autoblock_1
						integer i;
						for (i = N - 1; i >= 0; i = i - 1)
							if (data_in[i])
								index_w = sv2v_cast_48EE1_signed((N - 1) - i);
					end
				end
			end
			else begin : g_lsb
				always @(*) begin
					index_w = 1'sbx;
					begin : sv2v_autoblock_2
						integer i;
						for (i = 0; i < N; i = i + 1)
							if (data_in[i])
								index_w = sv2v_cast_48EE1_signed(i);
					end
				end
			end
			assign data_out = index_w;
			assign valid_out = |data_in;
		end
	endgenerate
endmodule
module VX_pending_size (
	clk,
	reset,
	incr,
	decr,
	empty,
	alm_empty,
	full,
	alm_full,
	size
);
	parameter SIZE = 1;
	parameter INCRW = 1;
	parameter DECRW = 1;
	parameter ALM_FULL = SIZE - 1;
	parameter ALM_EMPTY = 1;
	parameter SIZEW = $clog2(SIZE + 1);
	input wire clk;
	input wire reset;
	input wire [INCRW - 1:0] incr;
	input wire [DECRW - 1:0] decr;
	output wire empty;
	output wire alm_empty;
	output wire full;
	output wire alm_full;
	output wire [SIZEW - 1:0] size;
	function automatic signed [SIZEW - 1:0] sv2v_cast_4F235_signed;
		input reg signed [SIZEW - 1:0] inp;
		sv2v_cast_4F235_signed = inp;
	endfunction
	generate
		if (SIZE == 1) begin : g_size_eq1
			reg size_r;
			always @(posedge clk)
				if (reset)
					size_r <= 1'sb0;
				else if (incr) begin
					if (~decr)
						size_r <= 1;
				end
				else if (decr)
					size_r <= 1'sb0;
			assign empty = size_r == 0;
			assign full = size_r != 0;
			assign alm_empty = 1'b1;
			assign alm_full = 1'b1;
			assign size = size_r;
		end
		else begin : g_size_gt1
			reg empty_r;
			reg alm_empty_r;
			reg full_r;
			reg alm_full_r;
			if ((INCRW != 1) || (DECRW != 1)) begin : g_wide_step
				localparam DELTAW = (SIZEW < ((INCRW > DECRW ? INCRW : DECRW) + 1) ? SIZEW : (INCRW > DECRW ? INCRW : DECRW) + 1);
				wire [SIZEW - 1:0] size_n;
				reg [SIZEW - 1:0] size_r;
				function automatic [DELTAW - 1:0] sv2v_cast_68316;
					input reg [DELTAW - 1:0] inp;
					sv2v_cast_68316 = inp;
				endfunction
				wire [DELTAW - 1:0] delta = sv2v_cast_68316(incr) - sv2v_cast_68316(decr);
				assign size_n = $signed(size_r) + sv2v_cast_4F235_signed($signed(delta));
				always @(posedge clk)
					if (reset) begin
						empty_r <= 1;
						full_r <= 0;
						alm_empty_r <= 1;
						alm_full_r <= 0;
						size_r <= 1'sb0;
					end
					else begin
						empty_r <= size_n == sv2v_cast_4F235_signed(0);
						full_r <= size_n == sv2v_cast_4F235_signed(SIZE);
						alm_empty_r <= size_n <= sv2v_cast_4F235_signed(ALM_EMPTY);
						alm_full_r <= size_n >= sv2v_cast_4F235_signed(ALM_FULL);
						size_r <= size_n;
					end
				assign size = size_r;
			end
			else begin : g_single_step
				localparam ADDRW = (SIZE > 1 ? $clog2(SIZE) : 1);
				reg [ADDRW - 1:0] used_r;
				function automatic signed [ADDRW - 1:0] sv2v_cast_12D70_signed;
					input reg signed [ADDRW - 1:0] inp;
					sv2v_cast_12D70_signed = inp;
				endfunction
				wire is_alm_empty = used_r == sv2v_cast_12D70_signed(ALM_EMPTY);
				wire is_alm_empty_n = used_r == sv2v_cast_12D70_signed(ALM_EMPTY + 1);
				wire is_alm_full = used_r == sv2v_cast_12D70_signed(ALM_FULL);
				wire is_alm_full_n = used_r == sv2v_cast_12D70_signed(ALM_FULL - 1);
				always @(posedge clk)
					if (reset) begin
						alm_empty_r <= 1;
						alm_full_r <= 0;
					end
					else if (incr) begin
						if (~decr) begin
							if (is_alm_empty)
								alm_empty_r <= 0;
							if (is_alm_full_n)
								alm_full_r <= 1;
						end
					end
					else if (decr) begin
						if (is_alm_full)
							alm_full_r <= 0;
						if (is_alm_empty_n)
							alm_empty_r <= 1;
					end
				if (SIZE > 2) begin : g_size_gt2
					function automatic signed [ADDRW - 1:0] sv2v_cast_12D70_signed;
						input reg signed [ADDRW - 1:0] inp;
						sv2v_cast_12D70_signed = inp;
					endfunction
					wire is_empty_n = used_r == sv2v_cast_12D70_signed(1);
					wire is_full_n = used_r == sv2v_cast_12D70_signed(SIZE - 1);
					wire [1:0] delta = {~incr & decr, incr ^ decr};
					always @(posedge clk)
						if (reset) begin
							empty_r <= 1;
							full_r <= 0;
							used_r <= 1'sb0;
						end
						else begin
							if (incr) begin
								if (~decr) begin
									empty_r <= 0;
									if (is_full_n)
										full_r <= 1;
								end
							end
							else if (decr) begin
								full_r <= 0;
								if (is_empty_n)
									empty_r <= 1;
							end
							begin : sv2v_autoblock_1
								reg signed [ADDRW - 1:0] sv2v_tmp_cast;
								sv2v_tmp_cast = $signed(delta);
								used_r <= $signed(used_r) + sv2v_tmp_cast;
							end
						end
				end
				else begin : g_size_eq2
					always @(posedge clk)
						if (reset) begin
							empty_r <= 1;
							full_r <= 0;
							used_r <= 1'sb0;
						end
						else begin
							empty_r <= (empty_r & ~incr) | ((~full_r & decr) & ~incr);
							full_r <= ((~empty_r & incr) & ~decr) | (full_r & ~(decr ^ incr));
							used_r <= used_r ^ (incr ^ decr);
						end
				end
				if (SIZE > 1) begin : g_sizeN
					if (SIZEW > ADDRW) begin : g_not_log2
						assign size = {full_r, used_r};
					end
					else begin : g_log2
						assign size = used_r;
					end
				end
				else begin : g_size1
					assign size = full_r;
				end
			end
			assign empty = empty_r;
			assign full = full_r;
			assign alm_empty = alm_empty_r;
			assign alm_full = alm_full_r;
		end
	endgenerate
endmodule
module VX_pe_serializer (
	clk,
	reset,
	valid_in,
	mask_in,
	data_in,
	shared_in,
	tag_in,
	ready_in,
	pe_enable,
	pe_mask_out,
	pe_data_out,
	pe_shared_out,
	pe_data_in,
	valid_out,
	mask_out,
	data_out,
	tag_out,
	ready_out
);
	parameter NUM_LANES = 1;
	parameter NUM_PES = 1;
	parameter LATENCY = 1;
	parameter DATA_IN_WIDTH = 1;
	parameter DATA_OUT_WIDTH = DATA_IN_WIDTH;
	parameter SHARED_WIDTH = 0;
	parameter TAG_WIDTH = 0;
	parameter PE_REG = 0;
	parameter OUT_BUF = 0;
	input wire clk;
	input wire reset;
	input wire valid_in;
	input wire [NUM_LANES - 1:0] mask_in;
	input wire [(NUM_LANES * DATA_IN_WIDTH) - 1:0] data_in;
	input wire [(SHARED_WIDTH > 0 ? SHARED_WIDTH : 1) - 1:0] shared_in;
	input wire [(TAG_WIDTH > 0 ? TAG_WIDTH : 1) - 1:0] tag_in;
	output wire ready_in;
	output wire pe_enable;
	output wire [NUM_PES - 1:0] pe_mask_out;
	output wire [(NUM_PES * DATA_IN_WIDTH) - 1:0] pe_data_out;
	output wire [(SHARED_WIDTH > 0 ? SHARED_WIDTH : 1) - 1:0] pe_shared_out;
	input wire [(NUM_PES * DATA_OUT_WIDTH) - 1:0] pe_data_in;
	output wire valid_out;
	output wire [NUM_LANES - 1:0] mask_out;
	output wire [(NUM_LANES * DATA_OUT_WIDTH) - 1:0] data_out;
	output wire [(TAG_WIDTH > 0 ? TAG_WIDTH : 1) - 1:0] tag_out;
	input wire ready_out;
	localparam SHARED_WIDTH_S = (SHARED_WIDTH > 0 ? SHARED_WIDTH : 1);
	localparam TAG_WIDTH_S = (TAG_WIDTH > 0 ? TAG_WIDTH : 1);
	wire valid_out_u;
	wire [NUM_LANES - 1:0] mask_out_u;
	wire [(NUM_LANES * DATA_OUT_WIDTH) - 1:0] data_out_u;
	wire [TAG_WIDTH_S - 1:0] tag_out_u;
	wire ready_out_u;
	wire [(NUM_PES * DATA_IN_WIDTH) - 1:0] pe_data_out_w;
	wire [NUM_PES - 1:0] pe_mask_out_w;
	wire pe_valid_in;
	wire [NUM_PES - 1:0] pe_mask_in_w;
	wire [TAG_WIDTH_S - 1:0] pe_tag_in;
	wire enable;
	VX_shift_register #(
		.DATAW((1 + NUM_PES) + TAG_WIDTH_S),
		.DEPTH(PE_REG + LATENCY),
		.RESETW(1)
	) shift_reg(
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.data_in({valid_in, pe_mask_out_w, tag_in}),
		.data_out({pe_valid_in, pe_mask_in_w, pe_tag_in})
	);
	VX_pipe_register #(
		.DATAW((NUM_PES * DATA_IN_WIDTH) + SHARED_WIDTH_S),
		.DEPTH(PE_REG)
	) pe_data_reg(
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.data_in({pe_data_out_w, shared_in}),
		.data_out({pe_data_out, pe_shared_out})
	);
	assign pe_enable = enable;
	assign pe_mask_out = pe_mask_out_w;
	generate
		if (NUM_LANES != NUM_PES) begin : g_serialize
			localparam BATCH_SIZE = NUM_LANES / NUM_PES;
			localparam BATCH_SIZEW = (BATCH_SIZE > 1 ? $clog2(BATCH_SIZE) : 1);
			reg [BATCH_SIZEW - 1:0] batch_in_idx;
			reg [BATCH_SIZEW - 1:0] batch_out_idx;
			reg batch_in_done;
			reg batch_out_done;
			genvar _gv_i_189;
			for (_gv_i_189 = 0; _gv_i_189 < NUM_PES; _gv_i_189 = _gv_i_189 + 1) begin : g_pe_data_out_w
				localparam i = _gv_i_189;
				assign pe_data_out_w[i * DATA_IN_WIDTH+:DATA_IN_WIDTH] = data_in[((batch_in_idx * NUM_PES) + i) * DATA_IN_WIDTH+:DATA_IN_WIDTH];
				assign pe_mask_out_w[i] = mask_in[(batch_in_idx * NUM_PES) + i];
			end
			always @(posedge clk)
				if (reset) begin
					batch_in_idx <= 1'sb0;
					batch_out_idx <= 1'sb0;
					batch_in_done <= 0;
					batch_out_done <= 0;
				end
				else if (enable) begin
					begin : sv2v_autoblock_1
						reg [BATCH_SIZEW - 1:0] sv2v_tmp_cast;
						sv2v_tmp_cast = valid_in;
						batch_in_idx <= batch_in_idx + sv2v_tmp_cast;
					end
					begin : sv2v_autoblock_2
						reg [BATCH_SIZEW - 1:0] sv2v_tmp_cast_1;
						sv2v_tmp_cast_1 = pe_valid_in;
						batch_out_idx <= batch_out_idx + sv2v_tmp_cast_1;
					end
					begin : sv2v_autoblock_3
						reg signed [BATCH_SIZEW - 1:0] sv2v_tmp_cast_2;
						sv2v_tmp_cast_2 = BATCH_SIZE - 2;
						batch_in_done <= valid_in && (batch_in_idx == sv2v_tmp_cast_2);
					end
					begin : sv2v_autoblock_4
						reg signed [BATCH_SIZEW - 1:0] sv2v_tmp_cast_3;
						sv2v_tmp_cast_3 = BATCH_SIZE - 2;
						batch_out_done <= pe_valid_in && (batch_out_idx == sv2v_tmp_cast_3);
					end
				end
			reg [(BATCH_SIZE * (NUM_PES * DATA_OUT_WIDTH)) - 1:0] data_out_r;
			reg [(BATCH_SIZE * (NUM_PES * DATA_OUT_WIDTH)) - 1:0] data_out_n;
			reg [(BATCH_SIZE * NUM_PES) - 1:0] mask_out_r;
			reg [(BATCH_SIZE * NUM_PES) - 1:0] mask_out_n;
			always @(*) begin
				data_out_n = data_out_r;
				mask_out_n = mask_out_r;
				if (pe_valid_in) begin
					data_out_n[batch_out_idx * (NUM_PES * DATA_OUT_WIDTH)+:NUM_PES * DATA_OUT_WIDTH] = pe_data_in;
					mask_out_n[batch_out_idx * NUM_PES+:NUM_PES] = pe_mask_in_w;
				end
			end
			always @(posedge clk) begin
				data_out_r <= data_out_n;
				mask_out_r <= mask_out_n;
			end
			assign enable = ready_out_u || ~valid_out_u;
			assign ready_in = enable && batch_in_done;
			assign valid_out_u = batch_out_done;
			assign data_out_u = data_out_n;
			assign mask_out_u = mask_out_n;
			assign tag_out_u = pe_tag_in;
		end
		else begin : g_passthru
			assign pe_data_out_w = data_in;
			assign pe_mask_out_w = mask_in;
			assign enable = ready_out_u || ~pe_valid_in;
			assign ready_in = enable;
			assign valid_out_u = pe_valid_in;
			assign data_out_u = pe_data_in;
			assign mask_out_u = pe_mask_in_w;
			assign tag_out_u = pe_tag_in;
		end
	endgenerate
	VX_elastic_buffer #(
		.DATAW(((NUM_LANES * DATA_OUT_WIDTH) + NUM_LANES) + TAG_WIDTH_S),
		.SIZE(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : 2)),
		.OUT_REG(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : (OUT_BUF & 7) - 2))
	) out_buf(
		.clk(clk),
		.reset(reset),
		.valid_in(valid_out_u),
		.ready_in(ready_out_u),
		.data_in({data_out_u, mask_out_u, tag_out_u}),
		.data_out({data_out, mask_out, tag_out}),
		.valid_out(valid_out),
		.ready_out(ready_out)
	);
endmodule
module VX_pipe_buffer (
	clk,
	reset,
	valid_in,
	ready_in,
	data_in,
	data_out,
	ready_out,
	valid_out
);
	parameter DATAW = 1;
	parameter RESETW = 0;
	parameter DEPTH = 1;
	input wire clk;
	input wire reset;
	input wire valid_in;
	output wire ready_in;
	input wire [DATAW - 1:0] data_in;
	output wire [DATAW - 1:0] data_out;
	input wire ready_out;
	output wire valid_out;
	generate
		if (DEPTH == 0) begin : g_passthru
			assign ready_in = ready_out;
			assign valid_out = valid_in;
			assign data_out = data_in;
		end
		else begin : g_register
			wire [DEPTH:0] valid;
			wire ready [0:DEPTH + 0];
			wire [(DEPTH >= 0 ? ((DEPTH + 1) * DATAW) - 1 : ((1 - DEPTH) * DATAW) + ((DEPTH * DATAW) - 1)):(DEPTH >= 0 ? 0 : DEPTH * DATAW)] data;
			assign valid[0] = valid_in;
			assign data[(DEPTH >= 0 ? 0 : DEPTH) * DATAW+:DATAW] = data_in;
			assign ready_in = ready[0];
			genvar _gv_i_190;
			for (_gv_i_190 = 0; _gv_i_190 < DEPTH; _gv_i_190 = _gv_i_190 + 1) begin : g_pipe_regs
				localparam i = _gv_i_190;
				assign ready[i] = ready[i + 1] || ~valid[i + 1];
				VX_pipe_register #(
					.DATAW(1 + DATAW),
					.RESETW(1 + RESETW)
				) pipe_register(
					.clk(clk),
					.reset(reset),
					.enable(ready[i]),
					.data_in({valid[i], data[(DEPTH >= 0 ? i : DEPTH - i) * DATAW+:DATAW]}),
					.data_out({valid[i + 1], data[(DEPTH >= 0 ? i + 1 : DEPTH - (i + 1)) * DATAW+:DATAW]})
				);
			end
			assign valid_out = valid[DEPTH];
			assign data_out = data[(DEPTH >= 0 ? DEPTH : DEPTH - DEPTH) * DATAW+:DATAW];
			assign ready[DEPTH] = ready_out;
		end
	endgenerate
endmodule
module VX_pipe_register (
	clk,
	reset,
	enable,
	data_in,
	data_out
);
	parameter DATAW = 1;
	parameter RESETW = 0;
	parameter DEPTH = 1;
	parameter [(RESETW > 0 ? RESETW : 1) - 1:0] INIT_VALUE = {(RESETW > 0 ? RESETW : 1) {1'b0}};
	input wire clk;
	input wire reset;
	input wire enable;
	input wire [DATAW - 1:0] data_in;
	output wire [DATAW - 1:0] data_out;
	generate
		if (DEPTH == 0) begin : g_passthru
			assign data_out = data_in;
		end
		else begin : g_pipe
			reg [(DEPTH * DATAW) - 1:0] pipe;
			if (RESETW == DATAW) begin : g_full_reset
				always @(posedge clk)
					if (reset)
						pipe <= {DEPTH {INIT_VALUE}};
					else if (enable) begin
						pipe[0+:DATAW] <= data_in;
						begin : sv2v_autoblock_1
							reg signed [31:0] i;
							for (i = 1; i < DEPTH; i = i + 1)
								pipe[i * DATAW+:DATAW] <= pipe[(i - 1) * DATAW+:DATAW];
						end
					end
			end
			else if (RESETW != 0) begin : g_partial_reset
				always @(posedge clk)
					if (reset) begin : sv2v_autoblock_2
						reg signed [31:0] i;
						for (i = 0; i < DEPTH; i = i + 1)
							pipe[(i * DATAW) + ((DATAW - 1) >= (DATAW - RESETW) ? DATAW - 1 : ((DATAW - 1) + ((DATAW - 1) >= (DATAW - RESETW) ? ((DATAW - 1) - (DATAW - RESETW)) + 1 : ((DATAW - RESETW) - (DATAW - 1)) + 1)) - 1)-:((DATAW - 1) >= (DATAW - RESETW) ? ((DATAW - 1) - (DATAW - RESETW)) + 1 : ((DATAW - RESETW) - (DATAW - 1)) + 1)] <= INIT_VALUE;
					end
					else if (enable) begin
						pipe[0 + ((DATAW - 1) >= (DATAW - RESETW) ? DATAW - 1 : ((DATAW - 1) + ((DATAW - 1) >= (DATAW - RESETW) ? ((DATAW - 1) - (DATAW - RESETW)) + 1 : ((DATAW - RESETW) - (DATAW - 1)) + 1)) - 1)-:((DATAW - 1) >= (DATAW - RESETW) ? ((DATAW - 1) - (DATAW - RESETW)) + 1 : ((DATAW - RESETW) - (DATAW - 1)) + 1)] <= data_in[DATAW - 1:DATAW - RESETW];
						begin : sv2v_autoblock_3
							reg signed [31:0] i;
							for (i = 1; i < DEPTH; i = i + 1)
								pipe[(i * DATAW) + ((DATAW - 1) >= (DATAW - RESETW) ? DATAW - 1 : ((DATAW - 1) + ((DATAW - 1) >= (DATAW - RESETW) ? ((DATAW - 1) - (DATAW - RESETW)) + 1 : ((DATAW - RESETW) - (DATAW - 1)) + 1)) - 1)-:((DATAW - 1) >= (DATAW - RESETW) ? ((DATAW - 1) - (DATAW - RESETW)) + 1 : ((DATAW - RESETW) - (DATAW - 1)) + 1)] <= pipe[((i - 1) * DATAW) + ((DATAW - 1) >= (DATAW - RESETW) ? DATAW - 1 : ((DATAW - 1) + ((DATAW - 1) >= (DATAW - RESETW) ? ((DATAW - 1) - (DATAW - RESETW)) + 1 : ((DATAW - RESETW) - (DATAW - 1)) + 1)) - 1)-:((DATAW - 1) >= (DATAW - RESETW) ? ((DATAW - 1) - (DATAW - RESETW)) + 1 : ((DATAW - RESETW) - (DATAW - 1)) + 1)];
						end
					end
				always @(posedge clk)
					if (enable) begin
						pipe[(DATAW - RESETW) - 1-:DATAW - RESETW] <= data_in[(DATAW - RESETW) - 1:0];
						begin : sv2v_autoblock_4
							reg signed [31:0] i;
							for (i = 1; i < DEPTH; i = i + 1)
								pipe[(i * DATAW) + ((DATAW - RESETW) - 1)-:DATAW - RESETW] <= pipe[((i - 1) * DATAW) + ((DATAW - RESETW) - 1)-:DATAW - RESETW];
						end
					end
			end
			else begin : g_no_reset
				always @(posedge clk)
					if (enable) begin
						pipe[0+:DATAW] <= data_in;
						begin : sv2v_autoblock_5
							reg signed [31:0] i;
							for (i = 1; i < DEPTH; i = i + 1)
								pipe[i * DATAW+:DATAW] <= pipe[(i - 1) * DATAW+:DATAW];
						end
					end
			end
			assign data_out = pipe[(DEPTH - 1) * DATAW+:DATAW];
		end
	endgenerate
endmodule
module VX_popcount63 (
	data_in,
	data_out
);
	input wire [5:0] data_in;
	output wire [2:0] data_out;
	reg [2:0] sum;
	always @(*)
		case (data_in)
			6'd0: sum = 3'd0;
			6'd1: sum = 3'd1;
			6'd2: sum = 3'd1;
			6'd3: sum = 3'd2;
			6'd4: sum = 3'd1;
			6'd5: sum = 3'd2;
			6'd6: sum = 3'd2;
			6'd7: sum = 3'd3;
			6'd8: sum = 3'd1;
			6'd9: sum = 3'd2;
			6'd10: sum = 3'd2;
			6'd11: sum = 3'd3;
			6'd12: sum = 3'd2;
			6'd13: sum = 3'd3;
			6'd14: sum = 3'd3;
			6'd15: sum = 3'd4;
			6'd16: sum = 3'd1;
			6'd17: sum = 3'd2;
			6'd18: sum = 3'd2;
			6'd19: sum = 3'd3;
			6'd20: sum = 3'd2;
			6'd21: sum = 3'd3;
			6'd22: sum = 3'd3;
			6'd23: sum = 3'd4;
			6'd24: sum = 3'd2;
			6'd25: sum = 3'd3;
			6'd26: sum = 3'd3;
			6'd27: sum = 3'd4;
			6'd28: sum = 3'd3;
			6'd29: sum = 3'd4;
			6'd30: sum = 3'd4;
			6'd31: sum = 3'd5;
			6'd32: sum = 3'd1;
			6'd33: sum = 3'd2;
			6'd34: sum = 3'd2;
			6'd35: sum = 3'd3;
			6'd36: sum = 3'd2;
			6'd37: sum = 3'd3;
			6'd38: sum = 3'd3;
			6'd39: sum = 3'd4;
			6'd40: sum = 3'd2;
			6'd41: sum = 3'd3;
			6'd42: sum = 3'd3;
			6'd43: sum = 3'd4;
			6'd44: sum = 3'd3;
			6'd45: sum = 3'd4;
			6'd46: sum = 3'd4;
			6'd47: sum = 3'd5;
			6'd48: sum = 3'd2;
			6'd49: sum = 3'd3;
			6'd50: sum = 3'd3;
			6'd51: sum = 3'd4;
			6'd52: sum = 3'd3;
			6'd53: sum = 3'd4;
			6'd54: sum = 3'd4;
			6'd55: sum = 3'd5;
			6'd56: sum = 3'd3;
			6'd57: sum = 3'd4;
			6'd58: sum = 3'd4;
			6'd59: sum = 3'd5;
			6'd60: sum = 3'd4;
			6'd61: sum = 3'd5;
			6'd62: sum = 3'd5;
			6'd63: sum = 3'd6;
		endcase
	assign data_out = sum;
endmodule
module VX_popcount32 (
	data_in,
	data_out
);
	input wire [2:0] data_in;
	output wire [1:0] data_out;
	reg [1:0] sum;
	always @(*)
		case (data_in)
			3'd0: sum = 2'd0;
			3'd1: sum = 2'd1;
			3'd2: sum = 2'd1;
			3'd3: sum = 2'd2;
			3'd4: sum = 2'd1;
			3'd5: sum = 2'd2;
			3'd6: sum = 2'd2;
			3'd7: sum = 2'd3;
		endcase
	assign data_out = sum;
endmodule
module VX_sum33 (
	data_in1,
	data_in2,
	data_out
);
	input wire [2:0] data_in1;
	input wire [2:0] data_in2;
	output wire [3:0] data_out;
	reg [3:0] sum;
	always @(*)
		case ({data_in1, data_in2})
			6'd0: sum = 4'd0;
			6'd1: sum = 4'd1;
			6'd2: sum = 4'd2;
			6'd3: sum = 4'd3;
			6'd4: sum = 4'd4;
			6'd5: sum = 4'd5;
			6'd6: sum = 4'd6;
			6'd7: sum = 4'd7;
			6'd8: sum = 4'd1;
			6'd9: sum = 4'd2;
			6'd10: sum = 4'd3;
			6'd11: sum = 4'd4;
			6'd12: sum = 4'd5;
			6'd13: sum = 4'd6;
			6'd14: sum = 4'd7;
			6'd15: sum = 4'd8;
			6'd16: sum = 4'd2;
			6'd17: sum = 4'd3;
			6'd18: sum = 4'd4;
			6'd19: sum = 4'd5;
			6'd20: sum = 4'd6;
			6'd21: sum = 4'd7;
			6'd22: sum = 4'd8;
			6'd23: sum = 4'd9;
			6'd24: sum = 4'd3;
			6'd25: sum = 4'd4;
			6'd26: sum = 4'd5;
			6'd27: sum = 4'd6;
			6'd28: sum = 4'd7;
			6'd29: sum = 4'd8;
			6'd30: sum = 4'd9;
			6'd31: sum = 4'd10;
			6'd32: sum = 4'd4;
			6'd33: sum = 4'd5;
			6'd34: sum = 4'd6;
			6'd35: sum = 4'd7;
			6'd36: sum = 4'd8;
			6'd37: sum = 4'd9;
			6'd38: sum = 4'd10;
			6'd39: sum = 4'd11;
			6'd40: sum = 4'd5;
			6'd41: sum = 4'd6;
			6'd42: sum = 4'd7;
			6'd43: sum = 4'd8;
			6'd44: sum = 4'd9;
			6'd45: sum = 4'd10;
			6'd46: sum = 4'd11;
			6'd47: sum = 4'd12;
			6'd48: sum = 4'd6;
			6'd49: sum = 4'd7;
			6'd50: sum = 4'd8;
			6'd51: sum = 4'd9;
			6'd52: sum = 4'd10;
			6'd53: sum = 4'd11;
			6'd54: sum = 4'd12;
			6'd55: sum = 4'd13;
			6'd56: sum = 4'd7;
			6'd57: sum = 4'd8;
			6'd58: sum = 4'd9;
			6'd59: sum = 4'd10;
			6'd60: sum = 4'd11;
			6'd61: sum = 4'd12;
			6'd62: sum = 4'd13;
			6'd63: sum = 4'd14;
		endcase
	assign data_out = sum;
endmodule
module VX_popcount (
	data_in,
	data_out
);
	parameter MODEL = 1;
	parameter N = 1;
	parameter M = $clog2(N + 1);
	input wire [N - 1:0] data_in;
	output wire [M - 1:0] data_out;
	function automatic [M - 1:0] sv2v_cast_8461E;
		input reg [M - 1:0] inp;
		sv2v_cast_8461E = inp;
	endfunction
	function automatic [1:0] sv2v_cast_2;
		input reg [1:0] inp;
		sv2v_cast_2 = inp;
	endfunction
	generate
		if (N == 1) begin : g_passthru
			assign data_out = data_in;
		end
		else if (N <= 3) begin : g_popcount3
			reg [2:0] t_in;
			wire [1:0] t_out;
			always @(*) begin
				t_in = 1'sb0;
				t_in[N - 1:0] = data_in;
			end
			VX_popcount32 pc32(
				.data_in(t_in),
				.data_out(t_out)
			);
			assign data_out = t_out[M - 1:0];
		end
		else if (N <= 6) begin : g_popcount6
			reg [5:0] t_in;
			wire [2:0] t_out;
			always @(*) begin
				t_in = 1'sb0;
				t_in[N - 1:0] = data_in;
			end
			VX_popcount63 pc63(
				.data_in(t_in),
				.data_out(t_out)
			);
			assign data_out = t_out[M - 1:0];
		end
		else if (N <= 9) begin : g_popcount9
			reg [8:0] t_in;
			wire [4:0] t1_out;
			wire [3:0] t2_out;
			always @(*) begin
				t_in = 1'sb0;
				t_in[N - 1:0] = data_in;
			end
			VX_popcount63 pc63(
				.data_in(t_in[5:0]),
				.data_out(t1_out[2:0])
			);
			VX_popcount32 pc32(
				.data_in(t_in[8:6]),
				.data_out(t1_out[4:3])
			);
			VX_sum33 sum33(
				.data_in1(t1_out[2:0]),
				.data_in2({1'b0, t1_out[4:3]}),
				.data_out(t2_out)
			);
			assign data_out = t2_out[M - 1:0];
		end
		else if (N <= 12) begin : g_popcount12
			reg [11:0] t_in;
			wire [5:0] t1_out;
			wire [3:0] t2_out;
			always @(*) begin
				t_in = 1'sb0;
				t_in[N - 1:0] = data_in;
			end
			VX_popcount63 pc63a(
				.data_in(t_in[5:0]),
				.data_out(t1_out[2:0])
			);
			VX_popcount63 pc63b(
				.data_in(t_in[11:6]),
				.data_out(t1_out[5:3])
			);
			VX_sum33 sum33(
				.data_in1(t1_out[2:0]),
				.data_in2(t1_out[5:3]),
				.data_out(t2_out)
			);
			assign data_out = t2_out[M - 1:0];
		end
		else if (N <= 18) begin : g_popcount18
			reg [17:0] t_in;
			wire [8:0] t1_out;
			wire [5:0] t2_out;
			always @(*) begin
				t_in = 1'sb0;
				t_in[N - 1:0] = data_in;
			end
			VX_popcount63 pc63a(
				.data_in(t_in[5:0]),
				.data_out(t1_out[2:0])
			);
			VX_popcount63 pc63b(
				.data_in(t_in[11:6]),
				.data_out(t1_out[5:3])
			);
			VX_popcount63 pc63c(
				.data_in(t_in[17:12]),
				.data_out(t1_out[8:6])
			);
			VX_popcount32 pc32a(
				.data_in({t1_out[0], t1_out[3], t1_out[6]}),
				.data_out(t2_out[1:0])
			);
			VX_popcount32 pc32b(
				.data_in({t1_out[1], t1_out[4], t1_out[7]}),
				.data_out(t2_out[3:2])
			);
			VX_popcount32 pc32c(
				.data_in({t1_out[2], t1_out[5], t1_out[8]}),
				.data_out(t2_out[5:4])
			);
			assign data_out = ({2'b00, t2_out[1:0]} + {1'b0, t2_out[3:2], 1'b0}) + {t2_out[5:4], 2'b00};
		end
		else if (MODEL == 1) begin : g_model1
			localparam PN = 1 << $clog2(N);
			localparam LOGPN = $clog2(PN);
			wire [M - 1:0] tmp [LOGPN - 1:0][PN - 1:0];
			genvar _gv_j_24;
			for (_gv_j_24 = 0; _gv_j_24 < LOGPN; _gv_j_24 = _gv_j_24 + 1) begin : genblk1
				localparam j = _gv_j_24;
				localparam D = j + 1;
				localparam Q = (D < LOGPN ? D + 1 : M);
				genvar _gv_i_191;
				for (_gv_i_191 = 0; _gv_i_191 < (1 << ((LOGPN - j) - 1)); _gv_i_191 = _gv_i_191 + 1) begin : genblk1
					localparam i = _gv_i_191;
					localparam l = i * 2;
					localparam r = (i * 2) + 1;
					wire [Q - 1:0] res;
					if (j == 0) begin : genblk1
						if (r < N) begin : genblk1
							assign res = data_in[l] + data_in[r];
						end
						else if (l < N) begin : genblk1
							assign res = sv2v_cast_2(data_in[l]);
						end
						else begin : genblk1
							assign res = 2'b00;
						end
					end
					else begin : genblk1
						function automatic [D - 1:0] sv2v_cast_25D6D;
							input reg [D - 1:0] inp;
							sv2v_cast_25D6D = inp;
						endfunction
						assign res = sv2v_cast_25D6D(tmp[j - 1][l]) + sv2v_cast_25D6D(tmp[j - 1][r]);
					end
					assign tmp[j][i] = sv2v_cast_8461E(res);
				end
			end
			assign data_out = tmp[LOGPN - 1][0];
		end
		else begin : g_model2
			reg [M - 1:0] cnt_w;
			always @(*) begin
				cnt_w = 1'sb0;
				begin : sv2v_autoblock_1
					integer i;
					for (i = 0; i < N; i = i + 1)
						cnt_w = cnt_w + sv2v_cast_8461E(data_in[i]);
				end
			end
			assign data_out = cnt_w;
		end
	endgenerate
endmodule
module VX_priority_arbiter (
	clk,
	reset,
	requests,
	grant_index,
	grant_onehot,
	grant_valid,
	grant_ready
);
	parameter NUM_REQS = 1;
	parameter STICKY = 0;
	parameter LOG_NUM_REQS = (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1);
	input wire clk;
	input wire reset;
	input wire [NUM_REQS - 1:0] requests;
	output wire [LOG_NUM_REQS - 1:0] grant_index;
	output wire [NUM_REQS - 1:0] grant_onehot;
	output wire grant_valid;
	input wire grant_ready;
	generate
		if (NUM_REQS == 1) begin : g_passthru
			assign grant_index = 1'sb0;
			assign grant_onehot = requests;
			assign grant_valid = requests[0];
		end
		else begin : g_encoder
			reg [NUM_REQS - 1:0] prev_grant;
			always @(posedge clk)
				if (reset)
					prev_grant <= 1'sb0;
				else if (grant_valid && grant_ready)
					prev_grant <= grant_onehot;
			wire retain_grant = (STICKY != 0) && |(prev_grant & requests);
			wire [NUM_REQS - 1:0] requests_w = (retain_grant ? prev_grant : requests);
			wire grant_valid_w;
			VX_priority_encoder #(.N(NUM_REQS)) grant_sel(
				.data_in(requests_w),
				.index_out(grant_index),
				.onehot_out(grant_onehot),
				.valid_out(grant_valid_w)
			);
			assign grant_valid = (STICKY != 0 ? |requests : grant_valid_w);
		end
	endgenerate
endmodule
module VX_priority_encoder (
	data_in,
	onehot_out,
	index_out,
	valid_out
);
	parameter N = 1;
	parameter REVERSE = 0;
	parameter MODEL = 1;
	parameter LN = (N > 1 ? $clog2(N) : 1);
	input wire [N - 1:0] data_in;
	output wire [N - 1:0] onehot_out;
	output wire [LN - 1:0] index_out;
	output wire valid_out;
	function automatic signed [LN - 1:0] sv2v_cast_48EE1_signed;
		input reg signed [LN - 1:0] inp;
		sv2v_cast_48EE1_signed = inp;
	endfunction
	function automatic signed [N - 1:0] sv2v_cast_C31AD_signed;
		input reg signed [N - 1:0] inp;
		sv2v_cast_C31AD_signed = inp;
	endfunction
	generate
		if (REVERSE) begin : g_msb
			if (N == 1) begin : g_n1
				assign onehot_out = data_in;
				assign index_out = 1'sb0;
				assign valid_out = data_in;
			end
			else if (N == 2) begin : g_n2
				assign onehot_out = {data_in[1], data_in[0] & ~data_in[1]};
				assign index_out = data_in[1];
				assign valid_out = |data_in;
			end
			else if (MODEL != 0) begin : g_model1
				wire [N - 1:0] higher_pri_regs;
				assign higher_pri_regs[N - 1] = 1'b0;
				genvar _gv_i_192;
				for (_gv_i_192 = N - 2; _gv_i_192 >= 0; _gv_i_192 = _gv_i_192 - 1) begin : g_higher_pri_regs
					localparam i = _gv_i_192;
					assign higher_pri_regs[i] = higher_pri_regs[i + 1] | data_in[i + 1];
				end
				assign onehot_out = data_in & ~higher_pri_regs;
				wire [(N * LN) - 1:0] indices;
				genvar _gv_i_193;
				for (_gv_i_193 = 0; _gv_i_193 < N; _gv_i_193 = _gv_i_193 + 1) begin : g_indices
					localparam i = _gv_i_193;
					assign indices[i * LN+:LN] = sv2v_cast_48EE1_signed(i);
				end
				VX_find_first #(
					.N(N),
					.DATAW(LN),
					.REVERSE(1)
				) find_first(
					.valid_in(data_in),
					.data_in(indices),
					.data_out(index_out),
					.valid_out(valid_out)
				);
			end
			else begin : g_model0
				reg [LN - 1:0] index_w;
				reg [N - 1:0] onehot_w;
				always @(*) begin
					index_w = 1'sbx;
					onehot_w = 1'sbx;
					begin : sv2v_autoblock_1
						integer i;
						for (i = 0; i < (N - 1); i = i + 1)
							if (data_in[i]) begin
								index_w = sv2v_cast_48EE1_signed(i);
								onehot_w = sv2v_cast_C31AD_signed(1) << i;
							end
					end
				end
				assign index_out = index_w;
				assign onehot_out = onehot_w;
				assign valid_out = |data_in;
			end
		end
		else begin : g_lsb
			if (N == 1) begin : g_n1
				assign onehot_out = data_in;
				assign index_out = 1'sb0;
				assign valid_out = data_in;
			end
			else if (N == 2) begin : g_n2
				assign onehot_out = {data_in[1] && ~data_in[0], data_in[0]};
				assign index_out = ~data_in[0];
				assign valid_out = |data_in;
			end
			else if (MODEL == 1) begin : g_model1
				wire [N - 1:0] higher_pri_regs;
				assign higher_pri_regs[0] = 1'b0;
				genvar _gv_i_194;
				for (_gv_i_194 = 1; _gv_i_194 < N; _gv_i_194 = _gv_i_194 + 1) begin : g_higher_pri_regs
					localparam i = _gv_i_194;
					assign higher_pri_regs[i] = higher_pri_regs[i - 1] | data_in[i - 1];
				end
				assign onehot_out[N - 1:0] = data_in[N - 1:0] & ~higher_pri_regs[N - 1:0];
				VX_lzc #(
					.N(N),
					.REVERSE(1)
				) lzc(
					.data_in(data_in),
					.data_out(index_out),
					.valid_out(valid_out)
				);
			end
			else if (MODEL == 2) begin : g_model2
				wire [N - 1:0] scan_lo;
				VX_scan #(
					.N(N),
					.OP("|")
				) scan(
					.data_in(data_in),
					.data_out(scan_lo)
				);
				assign onehot_out = scan_lo & {~scan_lo[N - 2:0], 1'b1};
				VX_lzc #(
					.N(N),
					.REVERSE(1)
				) lzc(
					.data_in(data_in),
					.data_out(index_out),
					.valid_out(valid_out)
				);
			end
			else if (MODEL == 3) begin : g_model3
				assign onehot_out = data_in & -data_in;
				VX_lzc #(
					.N(N),
					.REVERSE(1)
				) lzc(
					.data_in(data_in),
					.data_out(index_out),
					.valid_out(valid_out)
				);
			end
			else begin : g_model0
				reg [LN - 1:0] index_w;
				reg [N - 1:0] onehot_w;
				always @(*) begin
					index_w = 1'sbx;
					onehot_w = 1'sbx;
					begin : sv2v_autoblock_2
						integer i;
						for (i = N - 1; i >= 0; i = i - 1)
							if (data_in[i]) begin
								index_w = sv2v_cast_48EE1_signed(i);
								onehot_w = sv2v_cast_C31AD_signed(1) << i;
							end
					end
				end
				assign index_out = index_w;
				assign onehot_out = onehot_w;
				assign valid_out = |data_in;
			end
		end
	endgenerate
endmodule
module VX_reduce_tree (
	data_in,
	data_out
);
	parameter IN_W = 1;
	parameter OUT_W = IN_W;
	parameter N = 1;
	parameter OP = "+";
	input wire [(N * IN_W) - 1:0] data_in;
	output wire [OUT_W - 1:0] data_out;
	function automatic [OUT_W - 1:0] sv2v_cast_4A8C3;
		input reg [OUT_W - 1:0] inp;
		sv2v_cast_4A8C3 = inp;
	endfunction
	generate
		if (N == 1) begin : g_passthru
			assign data_out = sv2v_cast_4A8C3(data_in[0+:IN_W]);
		end
		else begin : g_reduce
			localparam signed [31:0] N_A = N / 2;
			localparam signed [31:0] N_B = N - N_A;
			wire [(N_A * IN_W) - 1:0] in_A;
			wire [(N_B * IN_W) - 1:0] in_B;
			wire [OUT_W - 1:0] out_A;
			wire [OUT_W - 1:0] out_B;
			genvar _gv_i_195;
			for (_gv_i_195 = 0; _gv_i_195 < N_A; _gv_i_195 = _gv_i_195 + 1) begin : g_in_A
				localparam i = _gv_i_195;
				assign in_A[i * IN_W+:IN_W] = data_in[i * IN_W+:IN_W];
			end
			genvar _gv_i_196;
			for (_gv_i_196 = 0; _gv_i_196 < N_B; _gv_i_196 = _gv_i_196 + 1) begin : g_in_B
				localparam i = _gv_i_196;
				assign in_B[i * IN_W+:IN_W] = data_in[(N_A + i) * IN_W+:IN_W];
			end
			VX_reduce_tree #(
				.IN_W(IN_W),
				.OUT_W(OUT_W),
				.N(N_A),
				.OP(OP)
			) reduce_A(
				.data_in(in_A),
				.data_out(out_A)
			);
			VX_reduce_tree #(
				.IN_W(IN_W),
				.OUT_W(OUT_W),
				.N(N_B),
				.OP(OP)
			) reduce_B(
				.data_in(in_B),
				.data_out(out_B)
			);
			if (OP == "+") begin : g_plus
				assign data_out = out_A + out_B;
			end
			else if (OP == "^") begin : g_xor
				assign data_out = out_A ^ out_B;
			end
			else if (OP == "&") begin : g_and
				assign data_out = out_A & out_B;
			end
			else if (OP == "|") begin : g_or
				assign data_out = out_A | out_B;
			end
		end
	endgenerate
endmodule
module VX_rr_arbiter (
	clk,
	reset,
	requests,
	grant_index,
	grant_onehot,
	grant_valid,
	grant_ready
);
	parameter NUM_REQS = 1;
	parameter MODEL = 1;
	parameter LOG_NUM_REQS = (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1);
	parameter STICKY = 0;
	parameter LUT_OPT = 0;
	input wire clk;
	input wire reset;
	input wire [NUM_REQS - 1:0] requests;
	output wire [LOG_NUM_REQS - 1:0] grant_index;
	output wire [NUM_REQS - 1:0] grant_onehot;
	output wire grant_valid;
	input wire grant_ready;
	function automatic signed [LOG_NUM_REQS - 1:0] sv2v_cast_B273C_signed;
		input reg signed [LOG_NUM_REQS - 1:0] inp;
		sv2v_cast_B273C_signed = inp;
	endfunction
	generate
		if (NUM_REQS == 1) begin : g_passthru
			assign grant_index = 1'sb0;
			assign grant_onehot = requests;
			assign grant_valid = requests[0];
		end
		else if (LUT_OPT && (NUM_REQS == 2)) begin : g_lut2
			reg [LOG_NUM_REQS - 1:0] grant_index_w;
			reg [NUM_REQS - 1:0] grant_onehot_w;
			reg [LOG_NUM_REQS - 1:0] state;
			always @(*)
				casez ({state, requests})
					3'b001, 3'b1z1: begin
						grant_onehot_w = 2'b01;
						grant_index_w = sv2v_cast_B273C_signed(0);
					end
					3'b01z, 3'b110: begin
						grant_onehot_w = 2'b10;
						grant_index_w = sv2v_cast_B273C_signed(1);
					end
					default: begin
						grant_onehot_w = 2'b00;
						grant_index_w = 1'sbx;
					end
				endcase
			always @(posedge clk)
				if (reset)
					state <= 1'sb0;
				else if (grant_valid && grant_ready)
					state <= grant_index_w;
			assign grant_index = grant_index_w;
			assign grant_onehot = grant_onehot_w;
			assign grant_valid = |requests;
		end
		else if (LUT_OPT && (NUM_REQS == 3)) begin : g_lut3
			reg [LOG_NUM_REQS - 1:0] grant_index_w;
			reg [NUM_REQS - 1:0] grant_onehot_w;
			reg [LOG_NUM_REQS - 1:0] state;
			always @(*)
				casez ({state, requests})
					5'b00001, 5'b010z1, 5'b10zz1: begin
						grant_onehot_w = 3'b001;
						grant_index_w = sv2v_cast_B273C_signed(0);
					end
					5'b00z1z, 5'b01010, 5'b10z10: begin
						grant_onehot_w = 3'b010;
						grant_index_w = sv2v_cast_B273C_signed(1);
					end
					5'b0010z, 5'b011zz, 5'b10100: begin
						grant_onehot_w = 3'b100;
						grant_index_w = sv2v_cast_B273C_signed(2);
					end
					default: begin
						grant_onehot_w = 3'b000;
						grant_index_w = 1'sbx;
					end
				endcase
			always @(posedge clk)
				if (reset)
					state <= 1'sb0;
				else if (grant_valid && grant_ready)
					state <= grant_index_w;
			assign grant_index = grant_index_w;
			assign grant_onehot = grant_onehot_w;
			assign grant_valid = |requests;
		end
		else if (LUT_OPT && (NUM_REQS == 4)) begin : g_lut4
			reg [LOG_NUM_REQS - 1:0] grant_index_w;
			reg [NUM_REQS - 1:0] grant_onehot_w;
			reg [LOG_NUM_REQS - 1:0] state;
			always @(*)
				casez ({state, requests})
					6'b000001, 6'b0100z1, 6'b100zz1, 6'b11zzz1: begin
						grant_onehot_w = 4'b0001;
						grant_index_w = sv2v_cast_B273C_signed(0);
					end
					6'b00zz1z, 6'b010010, 6'b100z10, 6'b11zz10: begin
						grant_onehot_w = 4'b0010;
						grant_index_w = sv2v_cast_B273C_signed(1);
					end
					6'b00z10z, 6'b01z1zz, 6'b100100, 6'b11z100: begin
						grant_onehot_w = 4'b0100;
						grant_index_w = sv2v_cast_B273C_signed(2);
					end
					6'b00100z, 6'b0110zz, 6'b101zzz, 6'b111000: begin
						grant_onehot_w = 4'b1000;
						grant_index_w = sv2v_cast_B273C_signed(3);
					end
					default: begin
						grant_onehot_w = 4'b0000;
						grant_index_w = 1'sbx;
					end
				endcase
			always @(posedge clk)
				if (reset)
					state <= 1'sb0;
				else if (grant_valid && grant_ready)
					state <= grant_index_w;
			assign grant_index = grant_index_w;
			assign grant_onehot = grant_onehot_w;
			assign grant_valid = |requests;
		end
		else if (LUT_OPT && (NUM_REQS == 5)) begin : g_lut5
			reg [LOG_NUM_REQS - 1:0] grant_index_w;
			reg [NUM_REQS - 1:0] grant_onehot_w;
			reg [LOG_NUM_REQS - 1:0] state;
			always @(*)
				casez ({state, requests})
					8'b00000001, 8'b001000z1, 8'b01000zz1, 8'b0110zzz1, 8'b100zzzz1: begin
						grant_onehot_w = 5'b00001;
						grant_index_w = sv2v_cast_B273C_signed(0);
					end
					8'b000zzz1z, 8'b00100010, 8'b01000z10, 8'b0110zz10, 8'b100zzz10: begin
						grant_onehot_w = 5'b00010;
						grant_index_w = sv2v_cast_B273C_signed(1);
					end
					8'b000zz10z, 8'b001zz1zz, 8'b01000100, 8'b0110z100, 8'b100zz100: begin
						grant_onehot_w = 5'b00100;
						grant_index_w = sv2v_cast_B273C_signed(2);
					end
					8'b000z100z, 8'b001z10zz, 8'b010z1zzz, 8'b01101000, 8'b100z1000: begin
						grant_onehot_w = 5'b01000;
						grant_index_w = sv2v_cast_B273C_signed(3);
					end
					8'b0001000z, 8'b001100zz, 8'b01010zzz, 8'b0111zzzz, 8'b10010000: begin
						grant_onehot_w = 5'b10000;
						grant_index_w = sv2v_cast_B273C_signed(4);
					end
					default: begin
						grant_onehot_w = 5'b00000;
						grant_index_w = 1'sbx;
					end
				endcase
			always @(posedge clk)
				if (reset)
					state <= 1'sb0;
				else if (grant_valid && grant_ready)
					state <= grant_index_w;
			assign grant_index = grant_index_w;
			assign grant_onehot = grant_onehot_w;
			assign grant_valid = |requests;
		end
		else if (LUT_OPT && (NUM_REQS == 6)) begin : g_lut6
			reg [LOG_NUM_REQS - 1:0] grant_index_w;
			reg [NUM_REQS - 1:0] grant_onehot_w;
			reg [LOG_NUM_REQS - 1:0] state;
			always @(*)
				casez ({state, requests})
					9'b000000001, 9'b0010000z1, 9'b010000zz1, 9'b01100zzz1, 9'b1000zzzz1, 9'b101zzzzz1: begin
						grant_onehot_w = 6'b000001;
						grant_index_w = sv2v_cast_B273C_signed(0);
					end
					9'b000zzzz1z, 9'b001000010, 9'b010000z10, 9'b01100zz10, 9'b1000zzz10, 9'b101zzzz10: begin
						grant_onehot_w = 6'b000010;
						grant_index_w = sv2v_cast_B273C_signed(1);
					end
					9'b000zzz10z, 9'b001zzz1zz, 9'b010000100, 9'b01100z100, 9'b1000zz100, 9'b101zzz100: begin
						grant_onehot_w = 6'b000100;
						grant_index_w = sv2v_cast_B273C_signed(2);
					end
					9'b000zz100z, 9'b001zz10zz, 9'b010zz1zzz, 9'b011001000, 9'b1000z1000, 9'b101zz1000: begin
						grant_onehot_w = 6'b001000;
						grant_index_w = sv2v_cast_B273C_signed(3);
					end
					9'b000z1000z, 9'b001z100zz, 9'b010z10zzz, 9'b011z1zzzz, 9'b100010000, 9'b101z10000: begin
						grant_onehot_w = 6'b010000;
						grant_index_w = sv2v_cast_B273C_signed(4);
					end
					9'b00010000z, 9'b0011000zz, 9'b010100zzz, 9'b01110zzzz, 9'b1001zzzzz, 9'b101100000: begin
						grant_onehot_w = 6'b100000;
						grant_index_w = sv2v_cast_B273C_signed(5);
					end
					default: begin
						grant_onehot_w = 6'b000000;
						grant_index_w = 1'sbx;
					end
				endcase
			always @(posedge clk)
				if (reset)
					state <= 1'sb0;
				else if (grant_valid && grant_ready)
					state <= grant_index_w;
			assign grant_index = grant_index_w;
			assign grant_onehot = grant_onehot_w;
			assign grant_valid = |requests;
		end
		else if (LUT_OPT && (NUM_REQS == 7)) begin : g_lut7
			reg [LOG_NUM_REQS - 1:0] grant_index_w;
			reg [NUM_REQS - 1:0] grant_onehot_w;
			reg [LOG_NUM_REQS - 1:0] state;
			always @(*)
				casez ({state, requests})
					10'b0000000001, 10'b00100000z1, 10'b0100000zz1, 10'b011000zzz1, 10'b100000zzz1, 10'b10100zzzz1, 10'b110zzzzzz1: begin
						grant_onehot_w = 7'b0000001;
						grant_index_w = sv2v_cast_B273C_signed(0);
					end
					10'b000zzzzz1z, 10'b0010000010, 10'b0100000z10, 10'b011000zz10, 10'b10000zzz10, 10'b1010zzzz10, 10'b110zzzzz10: begin
						grant_onehot_w = 7'b0000010;
						grant_index_w = sv2v_cast_B273C_signed(1);
					end
					10'b000zzzz10z, 10'b001zzzz1zz, 10'b0100000100, 10'b011000z100, 10'b10000zz100, 10'b1010zzz100, 10'b110zzzz100: begin
						grant_onehot_w = 7'b0000100;
						grant_index_w = sv2v_cast_B273C_signed(2);
					end
					10'b000zzz100z, 10'b001zzz10zz, 10'b010zzz1zzz, 10'b0110001000, 10'b10000z1000, 10'b1010zz1000, 10'b110zzz1000: begin
						grant_onehot_w = 7'b0001000;
						grant_index_w = sv2v_cast_B273C_signed(3);
					end
					10'b000zz1000z, 10'b001zz100zz, 10'b010zz10zzz, 10'b011zz1zzzz, 10'b1000010000, 10'b1010z10000, 10'b110zz10000: begin
						grant_onehot_w = 7'b0010000;
						grant_index_w = sv2v_cast_B273C_signed(4);
					end
					10'b000z10000z, 10'b001z1000zz, 10'b010z100zzz, 10'b011z10zzzz, 10'b100z1zzzzz, 10'b1010100000, 10'b110z100000: begin
						grant_onehot_w = 7'b0100000;
						grant_index_w = sv2v_cast_B273C_signed(5);
					end
					10'b000100000z, 10'b00110000zz, 10'b0101000zzz, 10'b011100zzzz, 10'b10010zzzzz, 10'b1011zzzzzz, 10'b1101000000: begin
						grant_onehot_w = 7'b1000000;
						grant_index_w = sv2v_cast_B273C_signed(6);
					end
					default: begin
						grant_onehot_w = 7'b0000000;
						grant_index_w = 1'sbx;
					end
				endcase
			always @(posedge clk)
				if (reset)
					state <= 1'sb0;
				else if (grant_valid && grant_ready)
					state <= grant_index_w;
			assign grant_index = grant_index_w;
			assign grant_onehot = grant_onehot_w;
			assign grant_valid = |requests;
		end
		else if (LUT_OPT && (NUM_REQS == 8)) begin : g_lut8
			reg [LOG_NUM_REQS - 1:0] grant_index_w;
			reg [NUM_REQS - 1:0] grant_onehot_w;
			reg [LOG_NUM_REQS - 1:0] state;
			always @(*)
				casez ({state, requests})
					11'b00000000001, 11'b001000000z1, 11'b01000000zz1, 11'b0110000zzz1, 11'b100000zzzz1, 11'b10100zzzzz1, 11'b1100zzzzzz1, 11'b111zzzzzzz1: begin
						grant_onehot_w = 8'b00000001;
						grant_index_w = sv2v_cast_B273C_signed(0);
					end
					11'b000zzzzzz1z, 11'b00100000010, 11'b01000000z10, 11'b0110000zz10, 11'b100000zzz10, 11'b10100zzzz10, 11'b1100zzzzz10, 11'b111zzzzzz10: begin
						grant_onehot_w = 8'b00000010;
						grant_index_w = sv2v_cast_B273C_signed(1);
					end
					11'b000zzzzz10z, 11'b001zzzzz1zz, 11'b01000000100, 11'b0110000z100, 11'b100000zz100, 11'b10100zzz100, 11'b1100zzzz100, 11'b111zzzzz100: begin
						grant_onehot_w = 8'b00000100;
						grant_index_w = sv2v_cast_B273C_signed(2);
					end
					11'b000zzzz100z, 11'b001zzzz10zz, 11'b010zzzz1zzz, 11'b01100001000, 11'b100000z1000, 11'b10100zz1000, 11'b1100zzz1000, 11'b111zzzz1000: begin
						grant_onehot_w = 8'b00001000;
						grant_index_w = sv2v_cast_B273C_signed(3);
					end
					11'b000zzz1000z, 11'b001zzz100zz, 11'b010zzz10zzz, 11'b011zzz1zzzz, 11'b10000010000, 11'b10100z10000, 11'b1100zz10000, 11'b111zzz10000: begin
						grant_onehot_w = 8'b00010000;
						grant_index_w = sv2v_cast_B273C_signed(4);
					end
					11'b000zz10000z, 11'b001zz1000zz, 11'b010zz100zzz, 11'b011zz10zzzz, 11'b100zz1zzzzz, 11'b10100100000, 11'b1100z100000, 11'b111zz100000: begin
						grant_onehot_w = 8'b00100000;
						grant_index_w = sv2v_cast_B273C_signed(5);
					end
					11'b000z100000z, 11'b001z10000zz, 11'b010z1000zzz, 11'b011z100zzzz, 11'b100z10zzzzz, 11'b101z1zzzzzz, 11'b11001000000, 11'b111z1000000: begin
						grant_onehot_w = 8'b01000000;
						grant_index_w = sv2v_cast_B273C_signed(6);
					end
					11'b0001000000z, 11'b001100000zz, 11'b01010000zzz, 11'b0111000zzzz, 11'b100100zzzzz, 11'b10110zzzzzz, 11'b1101zzzzzzz, 11'b11110000000: begin
						grant_onehot_w = 8'b10000000;
						grant_index_w = sv2v_cast_B273C_signed(7);
					end
					default: begin
						grant_onehot_w = 8'b00000000;
						grant_index_w = 1'sbx;
					end
				endcase
			always @(posedge clk)
				if (reset)
					state <= 1'sb0;
				else if (grant_valid && grant_ready)
					state <= grant_index_w;
			assign grant_index = grant_index_w;
			assign grant_onehot = grant_onehot_w;
			assign grant_valid = |requests;
		end
		else if (MODEL == 1) begin : g_model1
			wire [NUM_REQS - 1:0] masked_pri_reqs;
			wire [NUM_REQS - 1:0] unmasked_pri_reqs;
			reg [NUM_REQS - 1:0] reqs_mask;
			wire [NUM_REQS - 1:0] masked_reqs = requests & reqs_mask;
			assign masked_pri_reqs[0] = 1'b0;
			genvar _gv_i_199;
			for (_gv_i_199 = 1; _gv_i_199 < NUM_REQS; _gv_i_199 = _gv_i_199 + 1) begin : g_masked_pri_reqs
				localparam i = _gv_i_199;
				assign masked_pri_reqs[i] = masked_pri_reqs[i - 1] | masked_reqs[i - 1];
			end
			assign unmasked_pri_reqs[0] = 1'b0;
			genvar _gv_i_200;
			for (_gv_i_200 = 1; _gv_i_200 < NUM_REQS; _gv_i_200 = _gv_i_200 + 1) begin : g_unmasked_pri_reqs
				localparam i = _gv_i_200;
				assign unmasked_pri_reqs[i] = unmasked_pri_reqs[i - 1] | requests[i - 1];
			end
			wire [NUM_REQS - 1:0] grant_masked = masked_reqs & ~masked_pri_reqs;
			wire [NUM_REQS - 1:0] grant_unmasked = requests & ~unmasked_pri_reqs;
			wire has_masked_reqs = |masked_reqs;
			wire has_unmasked_reqs = |requests;
			reg [NUM_REQS - 1:0] prev_grant;
			always @(posedge clk)
				if (reset)
					prev_grant <= 1'sb0;
				else if (grant_valid && grant_ready)
					prev_grant <= grant_onehot;
			wire retain_grant = (STICKY != 0) && |(prev_grant & requests);
			wire [NUM_REQS - 1:0] grant = (has_masked_reqs ? grant_masked : grant_unmasked);
			wire [NUM_REQS - 1:0] grant_w = (retain_grant ? prev_grant : grant);
			assign grant_onehot = grant_w;
			always @(posedge clk)
				if (reset)
					reqs_mask <= {NUM_REQS {1'b1}};
				else if ((grant_valid && grant_ready) && ~retain_grant) begin
					if (has_masked_reqs)
						reqs_mask <= masked_pri_reqs;
					else if (has_unmasked_reqs)
						reqs_mask <= unmasked_pri_reqs;
				end
			wire grant_valid_w;
			VX_onehot_encoder #(.N(NUM_REQS)) onehot_encoder(
				.data_in(grant_w),
				.data_out(grant_index),
				.valid_out(grant_valid_w)
			);
			assign grant_valid = (STICKY != 0 ? |requests : grant_valid_w);
		end
		else if (MODEL == 2) begin : g_model2
			reg [(NUM_REQS * LOG_NUM_REQS) - 1:0] grant_table;
			reg [LOG_NUM_REQS - 1:0] state;
			genvar _gv_i_201;
			for (_gv_i_201 = 0; _gv_i_201 < NUM_REQS; _gv_i_201 = _gv_i_201 + 1) begin : g_grant_table
				localparam i = _gv_i_201;
				always @(*) begin
					grant_table[i * LOG_NUM_REQS+:LOG_NUM_REQS] = 1'sbx;
					begin : sv2v_autoblock_1
						integer j;
						for (j = NUM_REQS - 1; j >= 0; j = j - 1)
							if (requests[((i + j) + 1) % NUM_REQS])
								grant_table[i * LOG_NUM_REQS+:LOG_NUM_REQS] = sv2v_cast_B273C_signed(((i + j) + 1) % NUM_REQS);
					end
				end
			end
			always @(posedge clk)
				if (reset)
					state <= 0;
				else if (grant_valid && grant_ready)
					state <= grant_index;
			VX_demux #(
				.DATAW(1),
				.N(NUM_REQS)
			) grant_decoder(
				.sel_in(grant_index),
				.data_in(grant_valid),
				.data_out(grant_onehot)
			);
			assign grant_index = grant_table[state * LOG_NUM_REQS+:LOG_NUM_REQS];
			assign grant_valid = |requests;
		end
	endgenerate
endmodule
module VX_scan (
	data_in,
	data_out
);
	parameter N = 1;
	parameter OP = "^";
	parameter REVERSE = 0;
	input wire [N - 1:0] data_in;
	output wire [N - 1:0] data_out;
	localparam LOGN = $clog2(N);
	wire [(LOGN >= 0 ? ((LOGN + 1) * N) - 1 : ((1 - LOGN) * N) + ((LOGN * N) - 1)):(LOGN >= 0 ? 0 : LOGN * N)] t;
	generate
		if (REVERSE != 0) begin : g_data_in_reverse
			assign t[(LOGN >= 0 ? 0 : LOGN) * N+:N] = data_in;
		end
		else begin : g_data_in_no_reverse
			function automatic [N - 1:0] _sv2v_strm_892FF;
				input reg [(0 + N) - 1:0] inp;
				reg [(0 + N) - 1:0] _sv2v_strm_5EA55_inp;
				reg [(0 + N) - 1:0] _sv2v_strm_5EA55_out;
				integer _sv2v_strm_5EA55_idx;
				begin
					_sv2v_strm_5EA55_inp = {inp};
					for (_sv2v_strm_5EA55_idx = 0; _sv2v_strm_5EA55_idx <= ((0 + N) - 1); _sv2v_strm_5EA55_idx = _sv2v_strm_5EA55_idx + 1)
						_sv2v_strm_5EA55_out[((0 + N) - 1) - _sv2v_strm_5EA55_idx-:1] = _sv2v_strm_5EA55_inp[_sv2v_strm_5EA55_idx+:1];
					_sv2v_strm_892FF = ((0 + N) <= N ? _sv2v_strm_5EA55_out << (N - (0 + N)) : _sv2v_strm_5EA55_out >> ((0 + N) - N));
				end
			endfunction
			assign t[(LOGN >= 0 ? 0 : LOGN) * N+:N] = _sv2v_strm_892FF({data_in});
		end
	endgenerate
	function automatic [N - 1:0] sv2v_cast_C31AD;
		input reg [N - 1:0] inp;
		sv2v_cast_C31AD = inp;
	endfunction
	generate
		if ((N == 2) && (OP == "&")) begin : g_scan_n2_and
			assign t[(LOGN >= 0 ? LOGN : LOGN - LOGN) * N+:N] = {t[((LOGN >= 0 ? 0 : LOGN) * N) + 1], &t[((LOGN >= 0 ? 0 : LOGN) * N) + 1-:2]};
		end
		else if ((N == 3) && (OP == "&")) begin : g_scan_n3_and
			assign t[(LOGN >= 0 ? LOGN : LOGN - LOGN) * N+:N] = {t[((LOGN >= 0 ? 0 : LOGN) * N) + 2], &t[((LOGN >= 0 ? 0 : LOGN) * N) + 2-:2], &t[((LOGN >= 0 ? 0 : LOGN) * N) + 2-:3]};
		end
		else if ((N == 4) && (OP == "&")) begin : g_scan_n4_and
			assign t[(LOGN >= 0 ? LOGN : LOGN - LOGN) * N+:N] = {t[((LOGN >= 0 ? 0 : LOGN) * N) + 3], &t[((LOGN >= 0 ? 0 : LOGN) * N) + 3-:2], &t[((LOGN >= 0 ? 0 : LOGN) * N) + 3-:3], &t[((LOGN >= 0 ? 0 : LOGN) * N) + 3-:4]};
		end
		else begin : g_scan
			wire [N - 1:0] fill;
			genvar _gv_i_202;
			for (_gv_i_202 = 0; _gv_i_202 < LOGN; _gv_i_202 = _gv_i_202 + 1) begin : g_i
				localparam i = _gv_i_202;
				wire [N - 1:0] shifted = sv2v_cast_C31AD({fill, t[(LOGN >= 0 ? i : LOGN - i) * N+:N]} >> (1 << i));
				if (OP == "^") begin : g_xor
					assign fill = {N {1'b0}};
					assign t[(LOGN >= 0 ? i + 1 : LOGN - (i + 1)) * N+:N] = t[(LOGN >= 0 ? i : LOGN - i) * N+:N] ^ shifted;
				end
				else if (OP == "&") begin : g_and
					assign fill = {N {1'b1}};
					assign t[(LOGN >= 0 ? i + 1 : LOGN - (i + 1)) * N+:N] = t[(LOGN >= 0 ? i : LOGN - i) * N+:N] & shifted;
				end
				else if (OP == "|") begin : g_or
					assign fill = {N {1'b0}};
					assign t[(LOGN >= 0 ? i + 1 : LOGN - (i + 1)) * N+:N] = t[(LOGN >= 0 ? i : LOGN - i) * N+:N] | shifted;
				end
			end
		end
		if (REVERSE != 0) begin : g_data_out_reverse
			assign data_out = t[(LOGN >= 0 ? LOGN : LOGN - LOGN) * N+:N];
		end
		else begin : g_data_out
			genvar _gv_i_203;
			for (_gv_i_203 = 0; _gv_i_203 < N; _gv_i_203 = _gv_i_203 + 1) begin : g_i
				localparam i = _gv_i_203;
				assign data_out[i] = t[((LOGN >= 0 ? LOGN : LOGN - LOGN) * N) + ((N - 1) - i)];
			end
		end
	endgenerate
endmodule
module VX_serial_div (
	clk,
	reset,
	strobe,
	busy,
	is_signed,
	numer,
	denom,
	quotient,
	remainder
);
	parameter WIDTHN = 32;
	parameter WIDTHD = 32;
	parameter WIDTHQ = 32;
	parameter WIDTHR = 32;
	parameter LANES = 1;
	input wire clk;
	input wire reset;
	input wire strobe;
	output wire busy;
	input wire is_signed;
	input wire [(LANES * WIDTHN) - 1:0] numer;
	input wire [(LANES * WIDTHD) - 1:0] denom;
	output wire [(LANES * WIDTHQ) - 1:0] quotient;
	output wire [(LANES * WIDTHR) - 1:0] remainder;
	localparam MIN_ND = (WIDTHN < WIDTHD ? WIDTHN : WIDTHD);
	localparam CNTRW = $clog2(WIDTHN);
	reg [((WIDTHN + MIN_ND) >= 0 ? (LANES * ((WIDTHN + MIN_ND) + 1)) - 1 : (LANES * (1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) - 1)):((WIDTHN + MIN_ND) >= 0 ? 0 : (WIDTHN + MIN_ND) + 0)] working;
	reg [(LANES * WIDTHD) - 1:0] denom_r;
	wire [(LANES * WIDTHN) - 1:0] numer_qual;
	wire [(LANES * WIDTHD) - 1:0] denom_qual;
	wire [(WIDTHD >= 0 ? (LANES * (WIDTHD + 1)) - 1 : (LANES * (1 - WIDTHD)) + (WIDTHD - 1)):(WIDTHD >= 0 ? 0 : WIDTHD + 0)] sub_result;
	reg [LANES - 1:0] inv_quot;
	reg [LANES - 1:0] inv_rem;
	reg [CNTRW - 1:0] cntr;
	reg busy_r;
	genvar _gv_i_206;
	generate
		for (_gv_i_206 = 0; _gv_i_206 < LANES; _gv_i_206 = _gv_i_206 + 1) begin : g_setup
			localparam i = _gv_i_206;
			wire negate_numer = is_signed && numer[(i * WIDTHN) + (WIDTHN - 1)];
			wire negate_denom = is_signed && denom[(i * WIDTHD) + (WIDTHD - 1)];
			assign numer_qual[i * WIDTHN+:WIDTHN] = (negate_numer ? -$signed(numer[i * WIDTHN+:WIDTHN]) : numer[i * WIDTHN+:WIDTHN]);
			assign denom_qual[i * WIDTHD+:WIDTHD] = (negate_denom ? -$signed(denom[i * WIDTHD+:WIDTHD]) : denom[i * WIDTHD+:WIDTHD]);
			assign sub_result[(WIDTHD >= 0 ? 0 : WIDTHD) + (i * (WIDTHD >= 0 ? WIDTHD + 1 : 1 - WIDTHD))+:(WIDTHD >= 0 ? WIDTHD + 1 : 1 - WIDTHD)] = working[((WIDTHN + MIN_ND) >= 0 ? (i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? ((WIDTHN + MIN_ND) >= WIDTHN ? WIDTHN + MIN_ND : ((WIDTHN + MIN_ND) + ((WIDTHN + MIN_ND) >= WIDTHN ? ((WIDTHN + MIN_ND) - WIDTHN) + 1 : (WIDTHN - (WIDTHN + MIN_ND)) + 1)) - 1) : (WIDTHN + MIN_ND) - ((WIDTHN + MIN_ND) >= WIDTHN ? WIDTHN + MIN_ND : ((WIDTHN + MIN_ND) + ((WIDTHN + MIN_ND) >= WIDTHN ? ((WIDTHN + MIN_ND) - WIDTHN) + 1 : (WIDTHN - (WIDTHN + MIN_ND)) + 1)) - 1)) : (((i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? ((WIDTHN + MIN_ND) >= WIDTHN ? WIDTHN + MIN_ND : ((WIDTHN + MIN_ND) + ((WIDTHN + MIN_ND) >= WIDTHN ? ((WIDTHN + MIN_ND) - WIDTHN) + 1 : (WIDTHN - (WIDTHN + MIN_ND)) + 1)) - 1) : (WIDTHN + MIN_ND) - ((WIDTHN + MIN_ND) >= WIDTHN ? WIDTHN + MIN_ND : ((WIDTHN + MIN_ND) + ((WIDTHN + MIN_ND) >= WIDTHN ? ((WIDTHN + MIN_ND) - WIDTHN) + 1 : (WIDTHN - (WIDTHN + MIN_ND)) + 1)) - 1))) + ((WIDTHN + MIN_ND) >= WIDTHN ? ((WIDTHN + MIN_ND) - WIDTHN) + 1 : (WIDTHN - (WIDTHN + MIN_ND)) + 1)) - 1)-:((WIDTHN + MIN_ND) >= WIDTHN ? ((WIDTHN + MIN_ND) - WIDTHN) + 1 : (WIDTHN - (WIDTHN + MIN_ND)) + 1)] - denom_r[i * WIDTHD+:WIDTHD];
		end
	endgenerate
	function automatic signed [CNTRW - 1:0] sv2v_cast_DFD49_signed;
		input reg signed [CNTRW - 1:0] inp;
		sv2v_cast_DFD49_signed = inp;
	endfunction
	always @(posedge clk) begin
		if (reset)
			busy_r <= 0;
		else begin
			if (strobe)
				busy_r <= 1;
			if (busy && (cntr == 0))
				busy_r <= 0;
		end
		cntr <= cntr - sv2v_cast_DFD49_signed(1);
		if (strobe)
			cntr <= sv2v_cast_DFD49_signed(WIDTHN - 1);
	end
	genvar _gv_i_207;
	generate
		for (_gv_i_207 = 0; _gv_i_207 < LANES; _gv_i_207 = _gv_i_207 + 1) begin : g_div
			localparam i = _gv_i_207;
			always @(posedge clk)
				if (strobe) begin
					working[((WIDTHN + MIN_ND) >= 0 ? 0 : WIDTHN + MIN_ND) + (i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND)))+:((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))] <= {{WIDTHD {1'b0}}, numer_qual[i * WIDTHN+:WIDTHN], 1'b0};
					denom_r[i * WIDTHD+:WIDTHD] <= denom_qual[i * WIDTHD+:WIDTHD];
					inv_quot[i] <= ((denom[i * WIDTHD+:WIDTHD] != 0) && is_signed) && (numer[(i * WIDTHN) + 31] ^ denom[(i * WIDTHD) + 31]);
					inv_rem[i] <= is_signed && numer[(i * WIDTHN) + 31];
				end
				else if (busy_r)
					working[((WIDTHN + MIN_ND) >= 0 ? 0 : WIDTHN + MIN_ND) + (i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND)))+:((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))] <= (sub_result[(i * (WIDTHD >= 0 ? WIDTHD + 1 : 1 - WIDTHD)) + (WIDTHD >= 0 ? WIDTHD : WIDTHD - WIDTHD)] ? {working[((WIDTHN + MIN_ND) >= 0 ? (i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) - 1 : (WIDTHN + MIN_ND) - ((WIDTHN + MIN_ND) - 1)) : (((i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) - 1 : (WIDTHN + MIN_ND) - ((WIDTHN + MIN_ND) - 1))) + (WIDTHN + MIN_ND)) - 1)-:WIDTHN + MIN_ND], 1'b0} : {sub_result[(WIDTHD >= 0 ? (i * (WIDTHD >= 0 ? WIDTHD + 1 : 1 - WIDTHD)) + (WIDTHD >= 0 ? WIDTHD - 1 : WIDTHD - (WIDTHD - 1)) : (((i * (WIDTHD >= 0 ? WIDTHD + 1 : 1 - WIDTHD)) + (WIDTHD >= 0 ? WIDTHD - 1 : WIDTHD - (WIDTHD - 1))) + WIDTHD) - 1)-:WIDTHD], working[((WIDTHN + MIN_ND) >= 0 ? (i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? WIDTHN - 1 : (WIDTHN + MIN_ND) - (WIDTHN - 1)) : (((i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? WIDTHN - 1 : (WIDTHN + MIN_ND) - (WIDTHN - 1))) + WIDTHN) - 1)-:WIDTHN], 1'b1});
		end
	endgenerate
	genvar _gv_i_208;
	generate
		for (_gv_i_208 = 0; _gv_i_208 < LANES; _gv_i_208 = _gv_i_208 + 1) begin : g_output
			localparam i = _gv_i_208;
			wire [WIDTHQ - 1:0] q = working[((WIDTHN + MIN_ND) >= 0 ? (i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? WIDTHQ - 1 : (WIDTHN + MIN_ND) - (WIDTHQ - 1)) : (((i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? WIDTHQ - 1 : (WIDTHN + MIN_ND) - (WIDTHQ - 1))) + WIDTHQ) - 1)-:WIDTHQ];
			wire [WIDTHR - 1:0] r = working[((WIDTHN + MIN_ND) >= 0 ? (i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? ((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? WIDTHN + WIDTHR : ((WIDTHN + WIDTHR) + ((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? ((WIDTHN + WIDTHR) - (WIDTHN + 1)) + 1 : ((WIDTHN + 1) - (WIDTHN + WIDTHR)) + 1)) - 1) : (WIDTHN + MIN_ND) - ((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? WIDTHN + WIDTHR : ((WIDTHN + WIDTHR) + ((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? ((WIDTHN + WIDTHR) - (WIDTHN + 1)) + 1 : ((WIDTHN + 1) - (WIDTHN + WIDTHR)) + 1)) - 1)) : (((i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? ((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? WIDTHN + WIDTHR : ((WIDTHN + WIDTHR) + ((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? ((WIDTHN + WIDTHR) - (WIDTHN + 1)) + 1 : ((WIDTHN + 1) - (WIDTHN + WIDTHR)) + 1)) - 1) : (WIDTHN + MIN_ND) - ((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? WIDTHN + WIDTHR : ((WIDTHN + WIDTHR) + ((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? ((WIDTHN + WIDTHR) - (WIDTHN + 1)) + 1 : ((WIDTHN + 1) - (WIDTHN + WIDTHR)) + 1)) - 1))) + ((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? ((WIDTHN + WIDTHR) - (WIDTHN + 1)) + 1 : ((WIDTHN + 1) - (WIDTHN + WIDTHR)) + 1)) - 1)-:((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? ((WIDTHN + WIDTHR) - (WIDTHN + 1)) + 1 : ((WIDTHN + 1) - (WIDTHN + WIDTHR)) + 1)];
			assign quotient[i * WIDTHQ+:WIDTHQ] = (inv_quot[i] ? -$signed(q) : q);
			assign remainder[i * WIDTHR+:WIDTHR] = (inv_rem[i] ? -$signed(r) : r);
		end
	endgenerate
	assign busy = busy_r;
endmodule
module VX_shift_register (
	clk,
	reset,
	enable,
	data_in,
	data_out
);
	parameter DATAW = 1;
	parameter RESETW = 0;
	parameter DEPTH = 1;
	parameter NUM_TAPS = 1;
	parameter TAP_START = DEPTH - 1;
	parameter TAP_STRIDE = 1;
	parameter [(RESETW > 0 ? RESETW : 1) - 1:0] INIT_VALUE = {(RESETW > 0 ? RESETW : 1) {1'b0}};
	input wire clk;
	input wire reset;
	input wire enable;
	input wire [DATAW - 1:0] data_in;
	output wire [(NUM_TAPS * DATAW) - 1:0] data_out;
	generate
		if (DEPTH == 0) begin : g_passthru
			assign data_out = data_in;
		end
		else begin : g_shift
			reg [(DEPTH * DATAW) - 1:0] pipe;
			if (RESETW == DATAW) begin : g_full_reset
				always @(posedge clk)
					if (reset)
						pipe <= {DEPTH {INIT_VALUE}};
					else if (enable) begin
						pipe[0+:DATAW] <= data_in;
						begin : sv2v_autoblock_1
							reg signed [31:0] i;
							for (i = 1; i < DEPTH; i = i + 1)
								pipe[i * DATAW+:DATAW] <= pipe[(i - 1) * DATAW+:DATAW];
						end
					end
			end
			else if (RESETW != 0) begin : g_partial_reset
				always @(posedge clk)
					if (reset) begin : sv2v_autoblock_2
						reg signed [31:0] i;
						for (i = 0; i < DEPTH; i = i + 1)
							pipe[(i * DATAW) + ((DATAW - 1) >= (DATAW - RESETW) ? DATAW - 1 : ((DATAW - 1) + ((DATAW - 1) >= (DATAW - RESETW) ? ((DATAW - 1) - (DATAW - RESETW)) + 1 : ((DATAW - RESETW) - (DATAW - 1)) + 1)) - 1)-:((DATAW - 1) >= (DATAW - RESETW) ? ((DATAW - 1) - (DATAW - RESETW)) + 1 : ((DATAW - RESETW) - (DATAW - 1)) + 1)] <= INIT_VALUE;
					end
					else if (enable) begin
						pipe[0 + ((DATAW - 1) >= (DATAW - RESETW) ? DATAW - 1 : ((DATAW - 1) + ((DATAW - 1) >= (DATAW - RESETW) ? ((DATAW - 1) - (DATAW - RESETW)) + 1 : ((DATAW - RESETW) - (DATAW - 1)) + 1)) - 1)-:((DATAW - 1) >= (DATAW - RESETW) ? ((DATAW - 1) - (DATAW - RESETW)) + 1 : ((DATAW - RESETW) - (DATAW - 1)) + 1)] <= data_in[DATAW - 1:DATAW - RESETW];
						begin : sv2v_autoblock_3
							reg signed [31:0] i;
							for (i = 1; i < DEPTH; i = i + 1)
								pipe[(i * DATAW) + ((DATAW - 1) >= (DATAW - RESETW) ? DATAW - 1 : ((DATAW - 1) + ((DATAW - 1) >= (DATAW - RESETW) ? ((DATAW - 1) - (DATAW - RESETW)) + 1 : ((DATAW - RESETW) - (DATAW - 1)) + 1)) - 1)-:((DATAW - 1) >= (DATAW - RESETW) ? ((DATAW - 1) - (DATAW - RESETW)) + 1 : ((DATAW - RESETW) - (DATAW - 1)) + 1)] <= pipe[((i - 1) * DATAW) + ((DATAW - 1) >= (DATAW - RESETW) ? DATAW - 1 : ((DATAW - 1) + ((DATAW - 1) >= (DATAW - RESETW) ? ((DATAW - 1) - (DATAW - RESETW)) + 1 : ((DATAW - RESETW) - (DATAW - 1)) + 1)) - 1)-:((DATAW - 1) >= (DATAW - RESETW) ? ((DATAW - 1) - (DATAW - RESETW)) + 1 : ((DATAW - RESETW) - (DATAW - 1)) + 1)];
						end
					end
				always @(posedge clk)
					if (enable) begin
						pipe[(DATAW - RESETW) - 1-:DATAW - RESETW] <= data_in[(DATAW - RESETW) - 1:0];
						begin : sv2v_autoblock_4
							reg signed [31:0] i;
							for (i = 1; i < DEPTH; i = i + 1)
								pipe[(i * DATAW) + ((DATAW - RESETW) - 1)-:DATAW - RESETW] <= pipe[((i - 1) * DATAW) + ((DATAW - RESETW) - 1)-:DATAW - RESETW];
						end
					end
			end
			else begin : g_no_reset
				always @(posedge clk)
					if (enable) begin
						pipe[0+:DATAW] <= data_in;
						begin : sv2v_autoblock_5
							reg signed [31:0] i;
							for (i = 1; i < DEPTH; i = i + 1)
								pipe[i * DATAW+:DATAW] <= pipe[(i - 1) * DATAW+:DATAW];
						end
					end
			end
			genvar _gv_i_210;
			for (_gv_i_210 = 0; _gv_i_210 < NUM_TAPS; _gv_i_210 = _gv_i_210 + 1) begin : g_taps
				localparam i = _gv_i_210;
				assign data_out[i * DATAW+:DATAW] = pipe[((i * TAP_STRIDE) + TAP_START) * DATAW+:DATAW];
			end
		end
	endgenerate
endmodule
module VX_sp_ram (
	clk,
	reset,
	read,
	write,
	wren,
	addr,
	wdata,
	rdata
);
	parameter DATAW = 1;
	parameter SIZE = 1;
	parameter WRENW = 1;
	parameter OUT_REG = 0;
	parameter LUTRAM = 0;
	parameter RDW_MODE = "W";
	parameter RADDR_REG = 0;
	parameter RADDR_RESET = 0;
	parameter RDW_ASSERT = 0;
	parameter RESET_RAM = 0;
	parameter INIT_ENABLE = 0;
	parameter INIT_FILE = "";
	parameter [DATAW - 1:0] INIT_VALUE = 0;
	parameter ADDRW = (SIZE > 1 ? $clog2(SIZE) : 1);
	input wire clk;
	input wire reset;
	input wire read;
	input wire write;
	input wire [WRENW - 1:0] wren;
	input wire [ADDRW - 1:0] addr;
	input wire [DATAW - 1:0] wdata;
	output wire [DATAW - 1:0] rdata;
	localparam WSELW = DATAW / WRENW;
	localparam FORCE_BRAM = !LUTRAM && ((((SIZE >= 64) || (DATAW >= 16)) || ((SIZE * DATAW) >= 512)) && ((SIZE * DATAW) >= 64));
	generate
		if (1) begin : g_no_asic
			if (OUT_REG) begin : g_sync
				if (FORCE_BRAM) begin : g_bram
					if (RDW_MODE == "W") begin : g_write_first
						if (WRENW != 1) begin : g_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_1
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [ADDRW - 1:0] addr_r;
							always @(posedge clk) begin
								if (write) begin : sv2v_autoblock_2
									integer i;
									for (i = 0; i < WRENW; i = i + 1)
										if (wren[i])
											ram[addr][i * WSELW+:WSELW] <= wdata[i * WSELW+:WSELW];
								end
								if (read)
									addr_r <= addr;
							end
							assign rdata = ram[addr_r];
						end
						else begin : g_no_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_3
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [DATAW - 1:0] rdata_r;
							always @(posedge clk) begin
								if (write)
									ram[addr] <= wdata;
								if (read) begin
									if (write)
										rdata_r <= wdata;
									else
										rdata_r <= ram[addr];
								end
							end
							assign rdata = rdata_r;
						end
					end
					else if (RDW_MODE == "R") begin : g_read_first
						if (WRENW != 1) begin : g_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_4
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [DATAW - 1:0] rdata_r;
							always @(posedge clk) begin
								if (write) begin : sv2v_autoblock_5
									integer i;
									for (i = 0; i < WRENW; i = i + 1)
										if (wren[i])
											ram[addr][i * WSELW+:WSELW] <= wdata[i * WSELW+:WSELW];
								end
								if (read)
									rdata_r <= ram[addr];
							end
							assign rdata = rdata_r;
						end
						else begin : g_no_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_6
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [DATAW - 1:0] rdata_r;
							always @(posedge clk) begin
								if (write)
									ram[addr] <= wdata;
								if (read)
									rdata_r <= ram[addr];
							end
							assign rdata = rdata_r;
						end
					end
					else if (RDW_MODE == "N") begin : g_no_change
						if (WRENW != 1) begin : g_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_7
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [DATAW - 1:0] rdata_r;
							always @(posedge clk)
								if (write) begin : sv2v_autoblock_8
									integer i;
									for (i = 0; i < WRENW; i = i + 1)
										if (wren[i])
											ram[addr][i * WSELW+:WSELW] <= wdata[i * WSELW+:WSELW];
								end
								else if (read)
									rdata_r <= ram[addr];
							assign rdata = rdata_r;
						end
						else begin : g_no_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_9
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [DATAW - 1:0] rdata_r;
							always @(posedge clk)
								if (write)
									ram[addr] <= wdata;
								else if (read)
									rdata_r <= ram[addr];
							assign rdata = rdata_r;
						end
					end
				end
				else begin : g_auto
					if (RDW_MODE == "W") begin : g_write_first
						if (WRENW != 1) begin : g_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_10
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [ADDRW - 1:0] addr_r;
							always @(posedge clk) begin
								if (write) begin : sv2v_autoblock_11
									integer i;
									for (i = 0; i < WRENW; i = i + 1)
										if (wren[i])
											ram[addr][i * WSELW+:WSELW] <= wdata[i * WSELW+:WSELW];
								end
								if (read)
									addr_r <= addr;
							end
							assign rdata = ram[addr_r];
						end
						else begin : g_no_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_12
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [DATAW - 1:0] rdata_r;
							always @(posedge clk) begin
								if (write)
									ram[addr] <= wdata;
								if (read) begin
									if (write)
										rdata_r <= wdata;
									else
										rdata_r <= ram[addr];
								end
							end
							assign rdata = rdata_r;
						end
					end
					else if (RDW_MODE == "R") begin : g_read_first
						if (WRENW != 1) begin : g_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_13
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [DATAW - 1:0] rdata_r;
							always @(posedge clk) begin
								if (write) begin : sv2v_autoblock_14
									integer i;
									for (i = 0; i < WRENW; i = i + 1)
										if (wren[i])
											ram[addr][i * WSELW+:WSELW] <= wdata[i * WSELW+:WSELW];
								end
								if (read)
									rdata_r <= ram[addr];
							end
							assign rdata = rdata_r;
						end
						else begin : g_no_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_15
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [DATAW - 1:0] rdata_r;
							always @(posedge clk) begin
								if (write)
									ram[addr] <= wdata;
								if (read)
									rdata_r <= ram[addr];
							end
							assign rdata = rdata_r;
						end
					end
					else if (RDW_MODE == "N") begin : g_no_change
						if (WRENW != 1) begin : g_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_16
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [DATAW - 1:0] rdata_r;
							always @(posedge clk)
								if (write) begin : sv2v_autoblock_17
									integer i;
									for (i = 0; i < WRENW; i = i + 1)
										if (wren[i])
											ram[addr][i * WSELW+:WSELW] <= wdata[i * WSELW+:WSELW];
								end
								else if (read)
									rdata_r <= ram[addr];
							assign rdata = rdata_r;
						end
						else begin : g_no_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_18
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							reg [DATAW - 1:0] rdata_r;
							always @(posedge clk)
								if (write)
									ram[addr] <= wdata;
								else if (read)
									rdata_r <= ram[addr];
							assign rdata = rdata_r;
						end
					end
				end
			end
			else begin : g_async
				if (FORCE_BRAM) begin : g_bram
					if (RDW_MODE == "W") begin : g_write_first
						if (WRENW != 1) begin : g_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_19
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							always @(posedge clk)
								if (write) begin : sv2v_autoblock_20
									integer i;
									for (i = 0; i < WRENW; i = i + 1)
										if (wren[i])
											ram[addr][i * WSELW+:WSELW] <= wdata[i * WSELW+:WSELW];
								end
							assign rdata = ram[addr];
						end
						else begin : g_no_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_21
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							always @(posedge clk)
								if (write)
									ram[addr] <= wdata;
							assign rdata = ram[addr];
						end
					end
					else begin : g_read_first
						if (WRENW != 1) begin : g_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_22
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							always @(posedge clk)
								if (write) begin : sv2v_autoblock_23
									integer i;
									for (i = 0; i < WRENW; i = i + 1)
										if (wren[i])
											ram[addr][i * WSELW+:WSELW] <= wdata[i * WSELW+:WSELW];
								end
							assign rdata = ram[addr];
						end
						else begin : g_no_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_24
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							always @(posedge clk)
								if (write)
									ram[addr] <= wdata;
							assign rdata = ram[addr];
						end
					end
				end
				else begin : g_auto
					if (RDW_MODE == "W") begin : g_write_first
						if (WRENW != 1) begin : g_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_25
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							always @(posedge clk)
								if (write) begin : sv2v_autoblock_26
									integer i;
									for (i = 0; i < WRENW; i = i + 1)
										if (wren[i])
											ram[addr][i * WSELW+:WSELW] <= wdata[i * WSELW+:WSELW];
								end
							assign rdata = ram[addr];
						end
						else begin : g_no_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_27
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							always @(posedge clk)
								if (write)
									ram[addr] <= wdata;
							assign rdata = ram[addr];
						end
					end
					else begin : g_read_first
						if (WRENW != 1) begin : g_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_28
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							always @(posedge clk)
								if (write) begin : sv2v_autoblock_29
									integer i;
									for (i = 0; i < WRENW; i = i + 1)
										if (wren[i])
											ram[addr][i * WSELW+:WSELW] <= wdata[i * WSELW+:WSELW];
								end
							assign rdata = ram[addr];
						end
						else begin : g_no_wren
							reg [DATAW - 1:0] ram [0:SIZE - 1];
							if (INIT_ENABLE != 0) begin : g_init
								if (INIT_FILE != "") begin : g_file
									initial $readmemh(INIT_FILE, ram);
								end
								else begin : g_value
									initial begin : sv2v_autoblock_30
										integer i;
										for (i = 0; i < SIZE; i = i + 1)
											begin : g_i
												ram[i] = INIT_VALUE;
											end
									end
								end
							end
							always @(posedge clk)
								if (write)
									ram[addr] <= wdata;
							assign rdata = ram[addr];
						end
					end
				end
			end
		end
	endgenerate
endmodule
module VX_stream_arb (
	clk,
	reset,
	valid_in,
	data_in,
	ready_in,
	valid_out,
	data_out,
	ready_out,
	sel_out
);
	parameter NUM_INPUTS = 1;
	parameter NUM_OUTPUTS = 1;
	parameter DATAW = 1;
	parameter STICKY = 0;
	parameter ARBITER = "R";
	parameter MAX_FANOUT = 8;
	parameter OUT_BUF = 0;
	parameter NUM_REQS = (NUM_INPUTS > NUM_OUTPUTS ? ((NUM_INPUTS + NUM_OUTPUTS) - 1) / NUM_OUTPUTS : ((NUM_OUTPUTS + NUM_INPUTS) - 1) / NUM_INPUTS);
	parameter SEL_COUNT = (NUM_INPUTS < NUM_OUTPUTS ? NUM_INPUTS : NUM_OUTPUTS);
	parameter LOG_NUM_REQS = $clog2(NUM_REQS);
	parameter NUM_REQS_W = (LOG_NUM_REQS > 0 ? LOG_NUM_REQS : 1);
	input wire clk;
	input wire reset;
	input wire [NUM_INPUTS - 1:0] valid_in;
	input wire [(NUM_INPUTS * DATAW) - 1:0] data_in;
	output wire [NUM_INPUTS - 1:0] ready_in;
	output wire [NUM_OUTPUTS - 1:0] valid_out;
	output wire [(NUM_OUTPUTS * DATAW) - 1:0] data_out;
	input wire [NUM_OUTPUTS - 1:0] ready_out;
	output wire [(SEL_COUNT * NUM_REQS_W) - 1:0] sel_out;
	function automatic signed [NUM_REQS_W - 1:0] sv2v_cast_F3513_signed;
		input reg signed [NUM_REQS_W - 1:0] inp;
		sv2v_cast_F3513_signed = inp;
	endfunction
	generate
		if (NUM_INPUTS > NUM_OUTPUTS) begin : g_input_select
			if ((MAX_FANOUT != 0) && (NUM_REQS > (MAX_FANOUT + (MAX_FANOUT / 2)))) begin : g_fanout
				localparam NUM_SLICES = ((NUM_REQS + MAX_FANOUT) - 1) / MAX_FANOUT;
				localparam LOG_NUM_REQS2 = $clog2(MAX_FANOUT);
				localparam LOG_NUM_REQS3 = $clog2(NUM_SLICES);
				localparam DATAW2 = DATAW + LOG_NUM_REQS2;
				wire [(NUM_SLICES * NUM_OUTPUTS) - 1:0] valid_tmp;
				wire [((NUM_SLICES * NUM_OUTPUTS) * DATAW2) - 1:0] data_tmp;
				wire [(NUM_SLICES * NUM_OUTPUTS) - 1:0] ready_tmp;
				genvar _gv_s_3;
				for (_gv_s_3 = 0; _gv_s_3 < NUM_SLICES; _gv_s_3 = _gv_s_3 + 1) begin : g_slice_arbs
					localparam s = _gv_s_3;
					localparam SLICE_STRIDE = MAX_FANOUT * NUM_OUTPUTS;
					localparam SLICE_BEGIN = s * SLICE_STRIDE;
					localparam SLICE_END = ((SLICE_BEGIN + SLICE_STRIDE) < NUM_INPUTS ? SLICE_BEGIN + SLICE_STRIDE : NUM_INPUTS);
					localparam SLICE_SIZE = SLICE_END - SLICE_BEGIN;
					wire [(NUM_OUTPUTS * DATAW) - 1:0] data_tmp_u;
					wire [(NUM_OUTPUTS * LOG_NUM_REQS2) - 1:0] sel_tmp_u;
					VX_stream_arb #(
						.NUM_INPUTS(SLICE_SIZE),
						.NUM_OUTPUTS(NUM_OUTPUTS),
						.DATAW(DATAW),
						.ARBITER(ARBITER),
						.STICKY(STICKY),
						.MAX_FANOUT(MAX_FANOUT),
						.OUT_BUF(3)
					) fanout_slice_arb(
						.clk(clk),
						.reset(reset),
						.valid_in(valid_in[SLICE_END - 1:SLICE_BEGIN]),
						.data_in(data_in[DATAW * (((SLICE_END - 1) >= SLICE_BEGIN ? SLICE_END - 1 : ((SLICE_END - 1) + ((SLICE_END - 1) >= SLICE_BEGIN ? ((SLICE_END - 1) - SLICE_BEGIN) + 1 : (SLICE_BEGIN - (SLICE_END - 1)) + 1)) - 1) - (((SLICE_END - 1) >= SLICE_BEGIN ? ((SLICE_END - 1) - SLICE_BEGIN) + 1 : (SLICE_BEGIN - (SLICE_END - 1)) + 1) - 1))+:DATAW * ((SLICE_END - 1) >= SLICE_BEGIN ? ((SLICE_END - 1) - SLICE_BEGIN) + 1 : (SLICE_BEGIN - (SLICE_END - 1)) + 1)]),
						.ready_in(ready_in[SLICE_END - 1:SLICE_BEGIN]),
						.valid_out(valid_tmp[s * NUM_OUTPUTS+:NUM_OUTPUTS]),
						.data_out(data_tmp_u),
						.ready_out(ready_tmp[s * NUM_OUTPUTS+:NUM_OUTPUTS]),
						.sel_out(sel_tmp_u)
					);
					genvar _gv_o_1;
					for (_gv_o_1 = 0; _gv_o_1 < NUM_OUTPUTS; _gv_o_1 = _gv_o_1 + 1) begin : g_data_tmp
						localparam o = _gv_o_1;
						assign data_tmp[((s * NUM_OUTPUTS) + o) * DATAW2+:DATAW2] = {data_tmp_u[o * DATAW+:DATAW], sel_tmp_u[o * LOG_NUM_REQS2+:LOG_NUM_REQS2]};
					end
				end
				wire [(NUM_OUTPUTS * DATAW2) - 1:0] data_out_u;
				wire [(NUM_OUTPUTS * LOG_NUM_REQS3) - 1:0] sel_out_u;
				VX_stream_arb #(
					.NUM_INPUTS(NUM_SLICES * NUM_OUTPUTS),
					.NUM_OUTPUTS(NUM_OUTPUTS),
					.DATAW(DATAW2),
					.ARBITER(ARBITER),
					.STICKY(STICKY),
					.MAX_FANOUT(MAX_FANOUT),
					.OUT_BUF(OUT_BUF)
				) fanout_join_arb(
					.clk(clk),
					.reset(reset),
					.valid_in(valid_tmp),
					.ready_in(ready_tmp),
					.data_in(data_tmp),
					.data_out(data_out_u),
					.sel_out(sel_out_u),
					.valid_out(valid_out),
					.ready_out(ready_out)
				);
				genvar _gv_o_2;
				for (_gv_o_2 = 0; _gv_o_2 < NUM_OUTPUTS; _gv_o_2 = _gv_o_2 + 1) begin : g_data_out
					localparam o = _gv_o_2;
					assign sel_out[o * NUM_REQS_W+:NUM_REQS_W] = {sel_out_u[o * LOG_NUM_REQS3+:LOG_NUM_REQS3], data_out_u[(o * DATAW2) + (LOG_NUM_REQS2 - 1)-:LOG_NUM_REQS2]};
					assign data_out[o * DATAW+:DATAW] = data_out_u[(o * DATAW2) + ((DATAW2 - 1) >= LOG_NUM_REQS2 ? DATAW2 - 1 : ((DATAW2 - 1) + ((DATAW2 - 1) >= LOG_NUM_REQS2 ? ((DATAW2 - 1) - LOG_NUM_REQS2) + 1 : (LOG_NUM_REQS2 - (DATAW2 - 1)) + 1)) - 1)-:((DATAW2 - 1) >= LOG_NUM_REQS2 ? ((DATAW2 - 1) - LOG_NUM_REQS2) + 1 : (LOG_NUM_REQS2 - (DATAW2 - 1)) + 1)];
				end
			end
			else begin : g_arbiter
				wire [NUM_REQS - 1:0] arb_requests;
				wire arb_valid;
				wire [NUM_REQS_W - 1:0] arb_index;
				wire [NUM_REQS - 1:0] arb_onehot;
				wire arb_ready;
				genvar _gv_r_7;
				for (_gv_r_7 = 0; _gv_r_7 < NUM_REQS; _gv_r_7 = _gv_r_7 + 1) begin : g_requests
					localparam r = _gv_r_7;
					wire [NUM_OUTPUTS - 1:0] requests;
					genvar _gv_o_3;
					for (_gv_o_3 = 0; _gv_o_3 < NUM_OUTPUTS; _gv_o_3 = _gv_o_3 + 1) begin : g_o
						localparam o = _gv_o_3;
						localparam i = (r * NUM_OUTPUTS) + o;
						if (i < NUM_INPUTS) begin : g_req_valid
							assign requests[o] = valid_in[i];
						end
						else begin : g_req_pad
							assign requests[o] = 1'b0;
						end
					end
					assign arb_requests[r] = |requests;
				end
				VX_generic_arbiter #(
					.NUM_REQS(NUM_REQS),
					.TYPE(ARBITER),
					.STICKY(STICKY)
				) arbiter(
					.clk(clk),
					.reset(reset),
					.requests(arb_requests),
					.grant_valid(arb_valid),
					.grant_index(arb_index),
					.grant_onehot(arb_onehot),
					.grant_ready(arb_ready)
				);
				wire [NUM_OUTPUTS - 1:0] valid_out_w;
				wire [(NUM_OUTPUTS * DATAW) - 1:0] data_out_w;
				wire [NUM_OUTPUTS - 1:0] ready_out_w;
				genvar _gv_o_4;
				for (_gv_o_4 = 0; _gv_o_4 < NUM_OUTPUTS; _gv_o_4 = _gv_o_4 + 1) begin : g_data_out_w
					localparam o = _gv_o_4;
					wire [NUM_REQS - 1:0] valid_in_w;
					wire [(NUM_REQS * DATAW) - 1:0] data_in_w;
					genvar _gv_r_8;
					for (_gv_r_8 = 0; _gv_r_8 < NUM_REQS; _gv_r_8 = _gv_r_8 + 1) begin : g_r
						localparam r = _gv_r_8;
						localparam i = (r * NUM_OUTPUTS) + o;
						if (i < NUM_INPUTS) begin : g_valid
							assign valid_in_w[r] = valid_in[i];
							assign data_in_w[r * DATAW+:DATAW] = data_in[i * DATAW+:DATAW];
						end
						else begin : g_padding
							assign valid_in_w[r] = 0;
							assign data_in_w[r * DATAW+:DATAW] = 1'sb0;
						end
					end
					assign valid_out_w[o] = (NUM_OUTPUTS == 1 ? arb_valid : |(valid_in_w & arb_onehot));
					assign data_out_w[o * DATAW+:DATAW] = data_in_w[arb_index * DATAW+:DATAW];
				end
				genvar _gv_i_211;
				for (_gv_i_211 = 0; _gv_i_211 < NUM_INPUTS; _gv_i_211 = _gv_i_211 + 1) begin : g_ready_in
					localparam i = _gv_i_211;
					localparam o = i % NUM_OUTPUTS;
					localparam r = i / NUM_OUTPUTS;
					assign ready_in[i] = ready_out_w[o] && arb_onehot[r];
				end
				assign arb_ready = |ready_out_w;
				genvar _gv_o_5;
				for (_gv_o_5 = 0; _gv_o_5 < NUM_OUTPUTS; _gv_o_5 = _gv_o_5 + 1) begin : g_out_buf
					localparam o = _gv_o_5;
					VX_elastic_buffer #(
						.DATAW(LOG_NUM_REQS + DATAW),
						.SIZE(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : 2)),
						.OUT_REG(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : (OUT_BUF & 7) - 2)),
						.LUTRAM((OUT_BUF & 8) != 0)
					) out_buf(
						.clk(clk),
						.reset(reset),
						.valid_in(valid_out_w[o]),
						.ready_in(ready_out_w[o]),
						.data_in({arb_index, data_out_w[o * DATAW+:DATAW]}),
						.data_out({sel_out[o * NUM_REQS_W+:NUM_REQS_W], data_out[o * DATAW+:DATAW]}),
						.valid_out(valid_out[o]),
						.ready_out(ready_out[o])
					);
				end
			end
		end
		else if (NUM_INPUTS < NUM_OUTPUTS) begin : g_output_select
			if ((MAX_FANOUT != 0) && (NUM_REQS > (MAX_FANOUT + (MAX_FANOUT / 2)))) begin : g_fanout
				localparam NUM_SLICES = ((NUM_REQS + MAX_FANOUT) - 1) / MAX_FANOUT;
				localparam LOG_NUM_REQS2 = $clog2(MAX_FANOUT);
				localparam LOG_NUM_REQS3 = $clog2(NUM_SLICES);
				wire [(NUM_SLICES * NUM_INPUTS) - 1:0] valid_tmp;
				wire [((NUM_SLICES * NUM_INPUTS) * DATAW) - 1:0] data_tmp;
				wire [(NUM_SLICES * NUM_INPUTS) - 1:0] ready_tmp;
				wire [(NUM_INPUTS * LOG_NUM_REQS3) - 1:0] sel_tmp;
				VX_stream_arb #(
					.NUM_INPUTS(NUM_INPUTS),
					.NUM_OUTPUTS(NUM_SLICES * NUM_INPUTS),
					.DATAW(DATAW),
					.ARBITER(ARBITER),
					.STICKY(STICKY),
					.MAX_FANOUT(MAX_FANOUT),
					.OUT_BUF(3)
				) fanout_fork_arb(
					.clk(clk),
					.reset(reset),
					.valid_in(valid_in),
					.ready_in(ready_in),
					.data_in(data_in),
					.data_out(data_tmp),
					.valid_out(valid_tmp),
					.ready_out(ready_tmp),
					.sel_out(sel_tmp)
				);
				wire [((NUM_SLICES * NUM_INPUTS) * LOG_NUM_REQS2) - 1:0] sel_out_w;
				genvar _gv_s_4;
				for (_gv_s_4 = 0; _gv_s_4 < NUM_SLICES; _gv_s_4 = _gv_s_4 + 1) begin : g_slice_arbs
					localparam s = _gv_s_4;
					localparam SLICE_STRIDE = MAX_FANOUT * NUM_INPUTS;
					localparam SLICE_BEGIN = s * SLICE_STRIDE;
					localparam SLICE_END = ((SLICE_BEGIN + SLICE_STRIDE) < NUM_OUTPUTS ? SLICE_BEGIN + SLICE_STRIDE : NUM_OUTPUTS);
					localparam SLICE_SIZE = SLICE_END - SLICE_BEGIN;
					wire [(NUM_INPUTS * LOG_NUM_REQS2) - 1:0] sel_out_u;
					VX_stream_arb #(
						.NUM_INPUTS(NUM_INPUTS),
						.NUM_OUTPUTS(SLICE_SIZE),
						.DATAW(DATAW),
						.ARBITER(ARBITER),
						.STICKY(STICKY),
						.MAX_FANOUT(MAX_FANOUT),
						.OUT_BUF(OUT_BUF)
					) fanout_slice_arb(
						.clk(clk),
						.reset(reset),
						.valid_in(valid_tmp[s * NUM_INPUTS+:NUM_INPUTS]),
						.ready_in(ready_tmp[s * NUM_INPUTS+:NUM_INPUTS]),
						.data_in(data_tmp[DATAW * (s * NUM_INPUTS)+:DATAW * NUM_INPUTS]),
						.data_out(data_out[DATAW * (((SLICE_END - 1) >= SLICE_BEGIN ? SLICE_END - 1 : ((SLICE_END - 1) + ((SLICE_END - 1) >= SLICE_BEGIN ? ((SLICE_END - 1) - SLICE_BEGIN) + 1 : (SLICE_BEGIN - (SLICE_END - 1)) + 1)) - 1) - (((SLICE_END - 1) >= SLICE_BEGIN ? ((SLICE_END - 1) - SLICE_BEGIN) + 1 : (SLICE_BEGIN - (SLICE_END - 1)) + 1) - 1))+:DATAW * ((SLICE_END - 1) >= SLICE_BEGIN ? ((SLICE_END - 1) - SLICE_BEGIN) + 1 : (SLICE_BEGIN - (SLICE_END - 1)) + 1)]),
						.valid_out(valid_out[SLICE_END - 1:SLICE_BEGIN]),
						.ready_out(ready_out[SLICE_END - 1:SLICE_BEGIN]),
						.sel_out(sel_out_w[LOG_NUM_REQS2 * (s * NUM_INPUTS)+:LOG_NUM_REQS2 * NUM_INPUTS])
					);
				end
				genvar _gv_i_212;
				for (_gv_i_212 = 0; _gv_i_212 < NUM_INPUTS; _gv_i_212 = _gv_i_212 + 1) begin : g_sel_out
					localparam i = _gv_i_212;
					assign sel_out[i * NUM_REQS_W+:NUM_REQS_W] = {sel_tmp[i * LOG_NUM_REQS3+:LOG_NUM_REQS3], sel_out_w[((sel_tmp[i * LOG_NUM_REQS3+:LOG_NUM_REQS3] * NUM_INPUTS) + i) * LOG_NUM_REQS2+:LOG_NUM_REQS2]};
				end
			end
			else begin : g_arbiter
				wire [NUM_REQS - 1:0] arb_requests;
				wire arb_valid;
				wire [NUM_REQS_W - 1:0] arb_index;
				wire [NUM_REQS - 1:0] arb_onehot;
				wire arb_ready;
				genvar _gv_r_9;
				for (_gv_r_9 = 0; _gv_r_9 < NUM_REQS; _gv_r_9 = _gv_r_9 + 1) begin : g_requests
					localparam r = _gv_r_9;
					wire [NUM_INPUTS - 1:0] requests;
					genvar _gv_i_213;
					for (_gv_i_213 = 0; _gv_i_213 < NUM_INPUTS; _gv_i_213 = _gv_i_213 + 1) begin : g_i
						localparam i = _gv_i_213;
						localparam o = (r * NUM_INPUTS) + i;
						assign requests[i] = ready_out[o];
					end
					assign arb_requests[r] = |requests;
				end
				VX_generic_arbiter #(
					.NUM_REQS(NUM_REQS),
					.TYPE(ARBITER),
					.STICKY(STICKY)
				) arbiter(
					.clk(clk),
					.reset(reset),
					.requests(arb_requests),
					.grant_valid(arb_valid),
					.grant_index(arb_index),
					.grant_onehot(arb_onehot),
					.grant_ready(arb_ready)
				);
				wire [NUM_OUTPUTS - 1:0] valid_out_w;
				wire [(NUM_OUTPUTS * DATAW) - 1:0] data_out_w;
				wire [NUM_OUTPUTS - 1:0] ready_out_w;
				genvar _gv_o_6;
				for (_gv_o_6 = 0; _gv_o_6 < NUM_OUTPUTS; _gv_o_6 = _gv_o_6 + 1) begin : g_data_out_w
					localparam o = _gv_o_6;
					localparam i = o % NUM_INPUTS;
					localparam r = o / NUM_INPUTS;
					assign valid_out_w[o] = valid_in[i] && arb_onehot[r];
					assign data_out_w[o * DATAW+:DATAW] = data_in[i * DATAW+:DATAW];
				end
				genvar _gv_i_214;
				for (_gv_i_214 = 0; _gv_i_214 < NUM_INPUTS; _gv_i_214 = _gv_i_214 + 1) begin : g_ready_in
					localparam i = _gv_i_214;
					wire [NUM_REQS - 1:0] ready_out_s;
					genvar _gv_r_10;
					for (_gv_r_10 = 0; _gv_r_10 < NUM_REQS; _gv_r_10 = _gv_r_10 + 1) begin : g_r
						localparam r = _gv_r_10;
						localparam o = (r * NUM_INPUTS) + i;
						assign ready_out_s[r] = ready_out_w[o];
					end
					assign ready_in[i] = (NUM_INPUTS == 1 ? arb_valid : |(ready_out_s & arb_onehot));
				end
				assign arb_ready = |valid_in;
				genvar _gv_o_7;
				for (_gv_o_7 = 0; _gv_o_7 < NUM_OUTPUTS; _gv_o_7 = _gv_o_7 + 1) begin : g_out_buf
					localparam o = _gv_o_7;
					VX_elastic_buffer #(
						.DATAW(DATAW),
						.SIZE(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : 2)),
						.OUT_REG(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : (OUT_BUF & 7) - 2)),
						.LUTRAM((OUT_BUF & 8) != 0)
					) out_buf(
						.clk(clk),
						.reset(reset),
						.valid_in(valid_out_w[o]),
						.ready_in(ready_out_w[o]),
						.data_in(data_out_w[o * DATAW+:DATAW]),
						.data_out(data_out[o * DATAW+:DATAW]),
						.valid_out(valid_out[o]),
						.ready_out(ready_out[o])
					);
				end
				genvar _gv_i_215;
				for (_gv_i_215 = 0; _gv_i_215 < NUM_INPUTS; _gv_i_215 = _gv_i_215 + 1) begin : g_sel_out
					localparam i = _gv_i_215;
					assign sel_out[i * NUM_REQS_W+:NUM_REQS_W] = arb_index;
				end
			end
		end
		else begin : g_passthru
			genvar _gv_o_8;
			for (_gv_o_8 = 0; _gv_o_8 < NUM_OUTPUTS; _gv_o_8 = _gv_o_8 + 1) begin : g_out_buf
				localparam o = _gv_o_8;
				VX_elastic_buffer #(
					.DATAW(DATAW),
					.SIZE(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : 2)),
					.OUT_REG(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : (OUT_BUF & 7) - 2)),
					.LUTRAM((OUT_BUF & 8) != 0)
				) out_buf(
					.clk(clk),
					.reset(reset),
					.valid_in(valid_in[o]),
					.ready_in(ready_in[o]),
					.data_in(data_in[o * DATAW+:DATAW]),
					.data_out(data_out[o * DATAW+:DATAW]),
					.valid_out(valid_out[o]),
					.ready_out(ready_out[o])
				);
				assign sel_out[o * NUM_REQS_W+:NUM_REQS_W] = sv2v_cast_F3513_signed(0);
			end
		end
	endgenerate
endmodule
module VX_stream_buffer (
	clk,
	reset,
	valid_in,
	ready_in,
	data_in,
	data_out,
	ready_out,
	valid_out
);
	parameter DATAW = 1;
	parameter OUT_REG = 0;
	parameter PASSTHRU = 0;
	input wire clk;
	input wire reset;
	input wire valid_in;
	output wire ready_in;
	input wire [DATAW - 1:0] data_in;
	output wire [DATAW - 1:0] data_out;
	input wire ready_out;
	output wire valid_out;
	generate
		if (PASSTHRU != 0) begin : g_passthru
			assign ready_in = ready_out;
			assign valid_out = valid_in;
			assign data_out = data_in;
		end
		else begin : g_buffer
			reg [DATAW - 1:0] data_out_r;
			reg [DATAW - 1:0] buffer_r;
			reg valid_out_r;
			reg valid_in_r;
			wire fire_in = valid_in && ready_in;
			wire flow_out = ready_out || ~valid_out;
			always @(posedge clk)
				if (reset)
					valid_in_r <= 1'b1;
				else if (valid_in || flow_out)
					valid_in_r <= flow_out;
			always @(posedge clk)
				if (reset)
					valid_out_r <= 1'b0;
				else if (flow_out)
					valid_out_r <= valid_in || ~valid_in_r;
			if (OUT_REG != 0) begin : g_out_reg
				always @(posedge clk)
					if (fire_in)
						buffer_r <= data_in;
				always @(posedge clk)
					if (flow_out)
						data_out_r <= (valid_in_r ? data_in : buffer_r);
				assign data_out = data_out_r;
			end
			else begin : g_no_out_reg
				always @(posedge clk)
					if (fire_in)
						data_out_r <= data_in;
				always @(posedge clk)
					if (fire_in)
						buffer_r <= data_out_r;
				assign data_out = (valid_in_r ? data_out_r : buffer_r);
			end
			assign valid_out = valid_out_r;
			assign ready_in = valid_in_r;
		end
	endgenerate
endmodule
module VX_stream_pack (
	clk,
	reset,
	valid_in,
	data_in,
	tag_in,
	ready_in,
	valid_out,
	mask_out,
	data_out,
	tag_out,
	ready_out
);
	parameter NUM_REQS = 1;
	parameter DATA_WIDTH = 1;
	parameter TAG_WIDTH = 1;
	parameter TAG_SEL_BITS = 0;
	parameter ARBITER = "P";
	parameter OUT_BUF = 0;
	input wire clk;
	input wire reset;
	input wire [NUM_REQS - 1:0] valid_in;
	input wire [(NUM_REQS * DATA_WIDTH) - 1:0] data_in;
	input wire [(NUM_REQS * TAG_WIDTH) - 1:0] tag_in;
	output wire [NUM_REQS - 1:0] ready_in;
	output wire valid_out;
	output wire [NUM_REQS - 1:0] mask_out;
	output wire [(NUM_REQS * DATA_WIDTH) - 1:0] data_out;
	output wire [TAG_WIDTH - 1:0] tag_out;
	input wire ready_out;
	generate
		if (NUM_REQS > 1) begin : g_pack
			localparam LOG_NUM_REQS = $clog2(NUM_REQS);
			wire [LOG_NUM_REQS - 1:0] grant_index;
			wire grant_valid;
			wire grant_ready;
			VX_generic_arbiter #(
				.NUM_REQS(NUM_REQS),
				.TYPE(ARBITER)
			) arbiter(
				.clk(clk),
				.reset(reset),
				.requests(valid_in),
				.grant_valid(grant_valid),
				.grant_index(grant_index),
				.grant_onehot(),
				.grant_ready(grant_ready)
			);
			wire [TAG_WIDTH - 1:0] tag_sel = tag_in[grant_index * TAG_WIDTH+:TAG_WIDTH];
			wire [NUM_REQS - 1:0] tag_matches;
			genvar _gv_i_222;
			for (_gv_i_222 = 0; _gv_i_222 < NUM_REQS; _gv_i_222 = _gv_i_222 + 1) begin : g_tag_matches
				localparam i = _gv_i_222;
				assign tag_matches[i] = tag_in[(i * TAG_WIDTH) + (TAG_SEL_BITS - 1)-:TAG_SEL_BITS] == tag_sel[TAG_SEL_BITS - 1:0];
			end
			genvar _gv_i_223;
			for (_gv_i_223 = 0; _gv_i_223 < NUM_REQS; _gv_i_223 = _gv_i_223 + 1) begin : g_ready_in
				localparam i = _gv_i_223;
				assign ready_in[i] = grant_ready & tag_matches[i];
			end
			wire [NUM_REQS - 1:0] mask_sel = valid_in & tag_matches;
			VX_elastic_buffer #(
				.DATAW((NUM_REQS + TAG_WIDTH) + (NUM_REQS * DATA_WIDTH)),
				.SIZE(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : 2)),
				.OUT_REG(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : (OUT_BUF & 7) - 2))
			) out_buf(
				.clk(clk),
				.reset(reset),
				.valid_in(grant_valid),
				.data_in({mask_sel, tag_sel, data_in}),
				.ready_in(grant_ready),
				.valid_out(valid_out),
				.data_out({mask_out, tag_out, data_out}),
				.ready_out(ready_out)
			);
		end
		else begin : g_passthru
			assign valid_out = valid_in;
			assign mask_out = 1'b1;
			assign data_out = data_in;
			assign tag_out = tag_in;
			assign ready_in = ready_out;
		end
	endgenerate
endmodule
module VX_stream_switch (
	clk,
	reset,
	sel_in,
	valid_in,
	data_in,
	ready_in,
	valid_out,
	data_out,
	ready_out
);
	parameter NUM_INPUTS = 1;
	parameter NUM_OUTPUTS = 1;
	parameter DATAW = 1;
	parameter OUT_BUF = 0;
	parameter NUM_REQS = (NUM_INPUTS > NUM_OUTPUTS ? ((NUM_INPUTS + NUM_OUTPUTS) - 1) / NUM_OUTPUTS : ((NUM_OUTPUTS + NUM_INPUTS) - 1) / NUM_INPUTS);
	parameter SEL_COUNT = (NUM_INPUTS < NUM_OUTPUTS ? NUM_INPUTS : NUM_OUTPUTS);
	parameter LOG_NUM_REQS = $clog2(NUM_REQS);
	input wire clk;
	input wire reset;
	input wire [(SEL_COUNT * (LOG_NUM_REQS > 0 ? LOG_NUM_REQS : 1)) - 1:0] sel_in;
	input wire [NUM_INPUTS - 1:0] valid_in;
	input wire [(NUM_INPUTS * DATAW) - 1:0] data_in;
	output wire [NUM_INPUTS - 1:0] ready_in;
	output wire [NUM_OUTPUTS - 1:0] valid_out;
	output wire [(NUM_OUTPUTS * DATAW) - 1:0] data_out;
	input wire [NUM_OUTPUTS - 1:0] ready_out;
	wire [NUM_OUTPUTS - 1:0] valid_out_w;
	wire [(NUM_OUTPUTS * DATAW) - 1:0] data_out_w;
	wire [NUM_OUTPUTS - 1:0] ready_out_w;
	function automatic signed [LOG_NUM_REQS - 1:0] sv2v_cast_B273C_signed;
		input reg signed [LOG_NUM_REQS - 1:0] inp;
		sv2v_cast_B273C_signed = inp;
	endfunction
	generate
		if (NUM_INPUTS > NUM_OUTPUTS) begin : g_input_select
			genvar _gv_o_11;
			for (_gv_o_11 = 0; _gv_o_11 < NUM_OUTPUTS; _gv_o_11 = _gv_o_11 + 1) begin : g_out_buf
				localparam o = _gv_o_11;
				wire [NUM_REQS - 1:0] valid_in_w;
				wire [(NUM_REQS * DATAW) - 1:0] data_in_w;
				reg [NUM_REQS - 1:0] ready_in_w;
				genvar _gv_r_11;
				for (_gv_r_11 = 0; _gv_r_11 < NUM_REQS; _gv_r_11 = _gv_r_11 + 1) begin : g_r
					localparam r = _gv_r_11;
					localparam i = (r * NUM_OUTPUTS) + o;
					if (i < NUM_INPUTS) begin : g_valid
						assign valid_in_w[r] = valid_in[i];
						assign data_in_w[r * DATAW+:DATAW] = data_in[i * DATAW+:DATAW];
						assign ready_in[i] = ready_in_w[r];
					end
					else begin : g_padding
						assign valid_in_w[r] = 0;
						assign data_in_w[r * DATAW+:DATAW] = 1'sb0;
					end
				end
				assign valid_out_w[o] = valid_in_w[sel_in[o * (LOG_NUM_REQS > 0 ? LOG_NUM_REQS : 1)+:(LOG_NUM_REQS > 0 ? LOG_NUM_REQS : 1)]];
				assign data_out_w[o * DATAW+:DATAW] = data_in_w[sel_in[o * (LOG_NUM_REQS > 0 ? LOG_NUM_REQS : 1)+:(LOG_NUM_REQS > 0 ? LOG_NUM_REQS : 1)] * DATAW+:DATAW];
				always @(*) begin
					ready_in_w = 1'sb0;
					begin : sv2v_autoblock_1
						integer o;
						for (o = 0; o < NUM_OUTPUTS; o = o + 1)
							ready_in_w[sel_in[o * (LOG_NUM_REQS > 0 ? LOG_NUM_REQS : 1)+:(LOG_NUM_REQS > 0 ? LOG_NUM_REQS : 1)]] = ready_out_w[o];
					end
				end
			end
		end
		else if (NUM_OUTPUTS > NUM_INPUTS) begin : g_output_select
			genvar _gv_i_224;
			for (_gv_i_224 = 0; _gv_i_224 < NUM_INPUTS; _gv_i_224 = _gv_i_224 + 1) begin : g_out_buf
				localparam i = _gv_i_224;
				wire [NUM_REQS - 1:0] ready_out_s;
				genvar _gv_r_12;
				for (_gv_r_12 = 0; _gv_r_12 < NUM_REQS; _gv_r_12 = _gv_r_12 + 1) begin : g_r
					localparam r = _gv_r_12;
					localparam o = (r * NUM_INPUTS) + i;
					if (o < NUM_OUTPUTS) begin : g_valid
						assign valid_out_w[o] = valid_in[i] && (sel_in[i * (LOG_NUM_REQS > 0 ? LOG_NUM_REQS : 1)+:(LOG_NUM_REQS > 0 ? LOG_NUM_REQS : 1)] == sv2v_cast_B273C_signed(r));
						assign data_out_w[o * DATAW+:DATAW] = data_in[i * DATAW+:DATAW];
						assign ready_out_s[r] = ready_out_w[o];
					end
					else begin : g_padding
						assign ready_out_s[r] = 1'sb0;
					end
				end
				assign ready_in[i] = ready_out_s[sel_in[i * (LOG_NUM_REQS > 0 ? LOG_NUM_REQS : 1)+:(LOG_NUM_REQS > 0 ? LOG_NUM_REQS : 1)]];
			end
		end
		else begin : g_passthru
			genvar _gv_i_225;
			for (_gv_i_225 = 0; _gv_i_225 < NUM_OUTPUTS; _gv_i_225 = _gv_i_225 + 1) begin : g_out_buf
				localparam i = _gv_i_225;
				assign valid_out_w[i] = valid_in[i];
				assign data_out_w[i * DATAW+:DATAW] = data_in[i * DATAW+:DATAW];
				assign ready_in[i] = ready_out_w[i];
			end
		end
	endgenerate
	genvar _gv_o_12;
	generate
		for (_gv_o_12 = 0; _gv_o_12 < NUM_OUTPUTS; _gv_o_12 = _gv_o_12 + 1) begin : g_out_buf
			localparam o = _gv_o_12;
			VX_elastic_buffer #(
				.DATAW(DATAW),
				.SIZE(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : 2)),
				.OUT_REG(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : (OUT_BUF & 7) - 2))
			) out_buf(
				.clk(clk),
				.reset(reset),
				.valid_in(valid_out_w[o]),
				.data_in(data_out_w[o * DATAW+:DATAW]),
				.ready_in(ready_out_w[o]),
				.valid_out(valid_out[o]),
				.data_out(data_out[o * DATAW+:DATAW]),
				.ready_out(ready_out[o])
			);
		end
	endgenerate
endmodule
module VX_stream_unpack (
	clk,
	reset,
	valid_in,
	mask_in,
	data_in,
	tag_in,
	ready_in,
	valid_out,
	data_out,
	tag_out,
	ready_out
);
	parameter NUM_REQS = 1;
	parameter DATA_WIDTH = 1;
	parameter TAG_WIDTH = 1;
	parameter OUT_BUF = 0;
	input wire clk;
	input wire reset;
	input wire valid_in;
	input wire [NUM_REQS - 1:0] mask_in;
	input wire [(NUM_REQS * DATA_WIDTH) - 1:0] data_in;
	input wire [TAG_WIDTH - 1:0] tag_in;
	output wire ready_in;
	output wire [NUM_REQS - 1:0] valid_out;
	output wire [(NUM_REQS * DATA_WIDTH) - 1:0] data_out;
	output wire [(NUM_REQS * TAG_WIDTH) - 1:0] tag_out;
	input wire [NUM_REQS - 1:0] ready_out;
	generate
		if (NUM_REQS > 1) begin : g_unpack
			reg [NUM_REQS - 1:0] delivered_r;
			wire [NUM_REQS - 1:0] valid_in_w;
			wire [NUM_REQS - 1:0] ready_in_w;
			assign valid_in_w = ({NUM_REQS {valid_in}} & mask_in) & ~delivered_r;
			wire all_ready = &((~mask_in | delivered_r) | ready_in_w);
			always @(posedge clk)
				if (reset)
					delivered_r <= 1'sb0;
				else if (valid_in) begin
					if (all_ready)
						delivered_r <= 1'sb0;
					else
						delivered_r <= delivered_r | ready_in_w;
				end
			assign ready_in = all_ready;
			genvar _gv_i_226;
			for (_gv_i_226 = 0; _gv_i_226 < NUM_REQS; _gv_i_226 = _gv_i_226 + 1) begin : g_outbuf
				localparam i = _gv_i_226;
				VX_elastic_buffer #(
					.DATAW(DATA_WIDTH + TAG_WIDTH),
					.SIZE(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : 2)),
					.OUT_REG(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : (OUT_BUF & 7) - 2))
				) out_buf(
					.clk(clk),
					.reset(reset),
					.valid_in(valid_in_w[i]),
					.ready_in(ready_in_w[i]),
					.data_in({data_in[i * DATA_WIDTH+:DATA_WIDTH], tag_in}),
					.data_out({data_out[i * DATA_WIDTH+:DATA_WIDTH], tag_out[i * TAG_WIDTH+:TAG_WIDTH]}),
					.valid_out(valid_out[i]),
					.ready_out(ready_out[i])
				);
			end
		end
		else begin : g_passthru
			assign valid_out = valid_in;
			assign data_out = data_in;
			assign tag_out = tag_in;
			assign ready_in = ready_out;
		end
	endgenerate
endmodule
module VX_stream_xbar (
	clk,
	reset,
	valid_in,
	data_in,
	sel_in,
	ready_in,
	valid_out,
	data_out,
	sel_out,
	ready_out,
	collisions
);
	parameter NUM_INPUTS = 4;
	parameter NUM_OUTPUTS = 4;
	parameter DATAW = 4;
	parameter ARBITER = "R";
	parameter OUT_BUF = 0;
	parameter MAX_FANOUT = 8;
	parameter PERF_CTR_BITS = $clog2(NUM_INPUTS + 1);
	parameter IN_WIDTH = (NUM_INPUTS > 1 ? $clog2(NUM_INPUTS) : 1);
	parameter OUT_WIDTH = (NUM_OUTPUTS > 1 ? $clog2(NUM_OUTPUTS) : 1);
	input wire clk;
	input wire reset;
	input wire [NUM_INPUTS - 1:0] valid_in;
	input wire [(NUM_INPUTS * DATAW) - 1:0] data_in;
	input wire [(NUM_INPUTS * OUT_WIDTH) - 1:0] sel_in;
	output wire [NUM_INPUTS - 1:0] ready_in;
	output wire [NUM_OUTPUTS - 1:0] valid_out;
	output wire [(NUM_OUTPUTS * DATAW) - 1:0] data_out;
	output wire [(NUM_OUTPUTS * IN_WIDTH) - 1:0] sel_out;
	input wire [NUM_OUTPUTS - 1:0] ready_out;
	output wire [PERF_CTR_BITS - 1:0] collisions;
	generate
		if (NUM_INPUTS != 1) begin : g_multi_inputs
			if (NUM_OUTPUTS != 1) begin : g_multiple_outputs
				wire [(NUM_INPUTS * NUM_OUTPUTS) - 1:0] per_output_valid_in;
				wire [(NUM_OUTPUTS * NUM_INPUTS) - 1:0] per_output_valid_in_w;
				wire [(NUM_OUTPUTS * NUM_INPUTS) - 1:0] per_output_ready_in;
				wire [(NUM_INPUTS * NUM_OUTPUTS) - 1:0] per_output_ready_in_w;
				VX_transpose #(
					.N(NUM_OUTPUTS),
					.M(NUM_INPUTS)
				) rdy_in_transpose(
					.data_in(per_output_ready_in),
					.data_out(per_output_ready_in_w)
				);
				genvar _gv_i_227;
				for (_gv_i_227 = 0; _gv_i_227 < NUM_INPUTS; _gv_i_227 = _gv_i_227 + 1) begin : g_ready_in
					localparam i = _gv_i_227;
					assign ready_in[i] = |per_output_ready_in_w[i * NUM_OUTPUTS+:NUM_OUTPUTS];
				end
				genvar _gv_i_228;
				for (_gv_i_228 = 0; _gv_i_228 < NUM_INPUTS; _gv_i_228 = _gv_i_228 + 1) begin : g_sel_in_demux
					localparam i = _gv_i_228;
					VX_demux #(
						.DATAW(1),
						.N(NUM_OUTPUTS)
					) sel_in_demux(
						.sel_in(sel_in[i * OUT_WIDTH+:OUT_WIDTH]),
						.data_in(valid_in[i]),
						.data_out(per_output_valid_in[i * NUM_OUTPUTS+:NUM_OUTPUTS])
					);
				end
				VX_transpose #(
					.N(NUM_INPUTS),
					.M(NUM_OUTPUTS)
				) val_in_transpose(
					.data_in(per_output_valid_in),
					.data_out(per_output_valid_in_w)
				);
				genvar _gv_i_229;
				for (_gv_i_229 = 0; _gv_i_229 < NUM_OUTPUTS; _gv_i_229 = _gv_i_229 + 1) begin : g_xbar_arbs
					localparam i = _gv_i_229;
					VX_stream_arb #(
						.NUM_INPUTS(NUM_INPUTS),
						.NUM_OUTPUTS(1),
						.DATAW(DATAW),
						.ARBITER(ARBITER),
						.MAX_FANOUT(MAX_FANOUT),
						.OUT_BUF(OUT_BUF)
					) xbar_arb(
						.clk(clk),
						.reset(reset),
						.valid_in(per_output_valid_in_w[i * NUM_INPUTS+:NUM_INPUTS]),
						.data_in(data_in),
						.ready_in(per_output_ready_in[i * NUM_INPUTS+:NUM_INPUTS]),
						.valid_out(valid_out[i]),
						.data_out(data_out[i * DATAW+:DATAW]),
						.sel_out(sel_out[i * IN_WIDTH+:IN_WIDTH]),
						.ready_out(ready_out[i])
					);
				end
			end
			else begin : g_one_output
				VX_stream_arb #(
					.NUM_INPUTS(NUM_INPUTS),
					.NUM_OUTPUTS(1),
					.DATAW(DATAW),
					.ARBITER(ARBITER),
					.MAX_FANOUT(MAX_FANOUT),
					.OUT_BUF(OUT_BUF)
				) xbar_arb(
					.clk(clk),
					.reset(reset),
					.valid_in(valid_in),
					.data_in(data_in),
					.ready_in(ready_in),
					.valid_out(valid_out),
					.data_out(data_out),
					.sel_out(sel_out),
					.ready_out(ready_out)
				);
			end
		end
		else if (NUM_OUTPUTS != 1) begin : g_single_input
			wire [NUM_OUTPUTS - 1:0] valid_out_w;
			wire [NUM_OUTPUTS - 1:0] ready_out_w;
			wire [(NUM_OUTPUTS * DATAW) - 1:0] data_out_w;
			VX_demux #(
				.DATAW(1),
				.N(NUM_OUTPUTS)
			) sel_in_demux(
				.sel_in(sel_in[0+:OUT_WIDTH]),
				.data_in(valid_in[0]),
				.data_out(valid_out_w)
			);
			assign ready_in[0] = ready_out_w[sel_in[0+:OUT_WIDTH]];
			assign data_out_w = {NUM_OUTPUTS {data_in[0+:DATAW]}};
			genvar _gv_i_230;
			for (_gv_i_230 = 0; _gv_i_230 < NUM_OUTPUTS; _gv_i_230 = _gv_i_230 + 1) begin : g_out_buf
				localparam i = _gv_i_230;
				VX_elastic_buffer #(
					.DATAW(DATAW),
					.SIZE(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : 2)),
					.OUT_REG(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : (OUT_BUF & 7) - 2)),
					.LUTRAM((OUT_BUF & 8) != 0)
				) out_buf(
					.clk(clk),
					.reset(reset),
					.valid_in(valid_out_w[i]),
					.ready_in(ready_out_w[i]),
					.data_in(data_out_w[i * DATAW+:DATAW]),
					.data_out(data_out[i * DATAW+:DATAW]),
					.valid_out(valid_out[i]),
					.ready_out(ready_out[i])
				);
			end
			assign sel_out = 0;
		end
		else begin : g_passthru
			VX_elastic_buffer #(
				.DATAW(DATAW),
				.SIZE(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : 2)),
				.OUT_REG(((OUT_BUF & 7) < 2 ? OUT_BUF & 7 : (OUT_BUF & 7) - 2)),
				.LUTRAM((OUT_BUF & 8) != 0)
			) out_buf(
				.clk(clk),
				.reset(reset),
				.valid_in(valid_in),
				.ready_in(ready_in),
				.data_in(data_in),
				.data_out(data_out),
				.valid_out(valid_out),
				.ready_out(ready_out)
			);
			assign sel_out = 0;
		end
	endgenerate
	reg [NUM_INPUTS - 1:0] per_cycle_collision;
	reg [NUM_INPUTS - 1:0] per_cycle_collision_r;
	wire [$clog2(NUM_INPUTS + 1) - 1:0] collision_count;
	reg [PERF_CTR_BITS - 1:0] collisions_r;
	always @(*) begin
		per_cycle_collision = 1'sb0;
		begin : sv2v_autoblock_1
			integer i;
			for (i = 0; i < NUM_INPUTS; i = i + 1)
				begin : sv2v_autoblock_2
					integer j;
					for (j = i + 1; j < NUM_INPUTS; j = j + 1)
						per_cycle_collision[i] = per_cycle_collision[i] | (((valid_in[i] && valid_in[j]) && (sel_in[i * OUT_WIDTH+:OUT_WIDTH] == sel_in[j * OUT_WIDTH+:OUT_WIDTH])) && (ready_in[i] | ready_in[j]));
				end
		end
	end
	wire [NUM_INPUTS:1] sv2v_tmp___buffer_ex218_data_out;
	always @(*) per_cycle_collision_r = sv2v_tmp___buffer_ex218_data_out;
	VX_pipe_register #(
		.DATAW(NUM_INPUTS),
		.RESETW(NUM_INPUTS),
		.DEPTH(1)
	) __buffer_ex218(
		.clk(clk),
		.reset(reset),
		.enable(1'b1),
		.data_in(per_cycle_collision),
		.data_out(sv2v_tmp___buffer_ex218_data_out)
	);
	VX_popcount #(
		.N(NUM_INPUTS),
		.MODEL(1)
	) __pop_count_ex219(
		.data_in(per_cycle_collision_r),
		.data_out(collision_count)
	);
	function automatic [PERF_CTR_BITS - 1:0] sv2v_cast_184FC;
		input reg [PERF_CTR_BITS - 1:0] inp;
		sv2v_cast_184FC = inp;
	endfunction
	always @(posedge clk)
		if (reset)
			collisions_r <= 1'sb0;
		else
			collisions_r <= collisions_r + sv2v_cast_184FC(collision_count);
	assign collisions = collisions_r;
endmodule
module VX_transpose (
	data_in,
	data_out
);
	parameter DATAW = 1;
	parameter N = 1;
	parameter M = 1;
	input wire [((N * M) * DATAW) - 1:0] data_in;
	output wire [((M * N) * DATAW) - 1:0] data_out;
	genvar _gv_i_232;
	generate
		for (_gv_i_232 = 0; _gv_i_232 < N; _gv_i_232 = _gv_i_232 + 1) begin : g_i
			localparam i = _gv_i_232;
			genvar _gv_j_26;
			for (_gv_j_26 = 0; _gv_j_26 < M; _gv_j_26 = _gv_j_26 + 1) begin : g_j
				localparam j = _gv_j_26;
				assign data_out[((j * N) + i) * DATAW+:DATAW] = data_in[((i * M) + j) * DATAW+:DATAW];
			end
		end
	endgenerate
endmodule
module VX_wallace_mul (
	a,
	b,
	p
);
	parameter N = 8;
	parameter P = 2 * N;
	parameter CPA_KS = 1;
	input wire [N - 1:0] a;
	input wire [N - 1:0] b;
	output wire [P - 1:0] p;
	wire [(N * (2 * N)) - 1:0] pp;
	genvar _gv_g_1;
	generate
		for (_gv_g_1 = 0; _gv_g_1 < N; _gv_g_1 = _gv_g_1 + 1) begin : g_pp_loop
			localparam g = _gv_g_1;
			genvar _gv_h_1;
			for (_gv_h_1 = 0; _gv_h_1 < N; _gv_h_1 = _gv_h_1 + 1) begin : g_and_loop
				localparam h = _gv_h_1;
				assign pp[(g * (2 * N)) + (h + g)] = a[h] & b[g];
			end
			if (g != 0) begin : g_bit_fill
				assign pp[(g * (2 * N)) + (g - 1)-:g] = {g {1'b0}};
			end
			assign pp[(g * (2 * N)) + (((2 * N) - 1) >= (N + g) ? (2 * N) - 1 : (((2 * N) - 1) + (((2 * N) - 1) >= (N + g) ? (((2 * N) - 1) - (N + g)) + 1 : ((N + g) - ((2 * N) - 1)) + 1)) - 1)-:(((2 * N) - 1) >= (N + g) ? (((2 * N) - 1) - (N + g)) + 1 : ((N + g) - ((2 * N) - 1)) + 1)] = {N - g {1'b0}};
		end
	endgenerate
	wire [P - 1:0] sum_vec;
	wire [P - 1:0] carry_vec;
	VX_csa_tree #(
		.N(N),
		.W(2 * N),
		.S(P)
	) pp_acc(
		.operands(pp),
		.sum(sum_vec),
		.carry(carry_vec)
	);
	VX_ks_adder #(
		.N(P),
		.BYPASS(CPA_KS == 0)
	) final_add(
		.dataa(sum_vec),
		.datab(carry_vec),
		.cin(1'b0),
		.sum(p),
		.cout()
	);
endmodule