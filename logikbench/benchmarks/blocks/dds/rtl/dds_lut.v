//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
/******************************************************************************
 * dds_lut: quarter-wave sine ROM with quadrant symmetry.
 *
 * A single quarter-wave magnitude table (0..pi/2) is reconstructed into a
 * full-period signed sine via quadrant decode, and cosine is the same sample
 * a quarter period ahead. The ROM below is generated at build time (see
 * generation note in README); it is sized for AW=10, OW=12 and must be
 * regenerated if AW/OW change.
 ******************************************************************************/
module dds_lut
  #(parameter AW = 10,   // phase address bits (full period = 2^AW)
    parameter OW = 12)   // signed output width
  (
   input  wire [AW-1:0]        phase,
   output wire signed [OW-1:0] sine,
   output wire signed [OW-1:0] cosine
   );

   localparam NQ = (1 << (AW-2));   // quarter-wave entries

   // combinational quarter-wave ROM: idx (0..NQ-1) -> |sin| magnitude
   function [OW-1:0] qrom;
      input [AW-3:0] idx;
      begin
         case (idx)
            8'd0: qrom = 12'd0;
            8'd1: qrom = 12'd13;
            8'd2: qrom = 12'd25;
            8'd3: qrom = 12'd38;
            8'd4: qrom = 12'd50;
            8'd5: qrom = 12'd63;
            8'd6: qrom = 12'd75;
            8'd7: qrom = 12'd88;
            8'd8: qrom = 12'd100;
            8'd9: qrom = 12'd113;
            8'd10: qrom = 12'd126;
            8'd11: qrom = 12'd138;
            8'd12: qrom = 12'd151;
            8'd13: qrom = 12'd163;
            8'd14: qrom = 12'd176;
            8'd15: qrom = 12'd188;
            8'd16: qrom = 12'd201;
            8'd17: qrom = 12'd213;
            8'd18: qrom = 12'd226;
            8'd19: qrom = 12'd238;
            8'd20: qrom = 12'd251;
            8'd21: qrom = 12'd263;
            8'd22: qrom = 12'd275;
            8'd23: qrom = 12'd288;
            8'd24: qrom = 12'd300;
            8'd25: qrom = 12'd313;
            8'd26: qrom = 12'd325;
            8'd27: qrom = 12'd338;
            8'd28: qrom = 12'd350;
            8'd29: qrom = 12'd362;
            8'd30: qrom = 12'd375;
            8'd31: qrom = 12'd387;
            8'd32: qrom = 12'd399;
            8'd33: qrom = 12'd412;
            8'd34: qrom = 12'd424;
            8'd35: qrom = 12'd436;
            8'd36: qrom = 12'd449;
            8'd37: qrom = 12'd461;
            8'd38: qrom = 12'd473;
            8'd39: qrom = 12'd485;
            8'd40: qrom = 12'd497;
            8'd41: qrom = 12'd510;
            8'd42: qrom = 12'd522;
            8'd43: qrom = 12'd534;
            8'd44: qrom = 12'd546;
            8'd45: qrom = 12'd558;
            8'd46: qrom = 12'd570;
            8'd47: qrom = 12'd582;
            8'd48: qrom = 12'd594;
            8'd49: qrom = 12'd606;
            8'd50: qrom = 12'd618;
            8'd51: qrom = 12'd630;
            8'd52: qrom = 12'd642;
            8'd53: qrom = 12'd654;
            8'd54: qrom = 12'd666;
            8'd55: qrom = 12'd678;
            8'd56: qrom = 12'd690;
            8'd57: qrom = 12'd701;
            8'd58: qrom = 12'd713;
            8'd59: qrom = 12'd725;
            8'd60: qrom = 12'd737;
            8'd61: qrom = 12'd748;
            8'd62: qrom = 12'd760;
            8'd63: qrom = 12'd772;
            8'd64: qrom = 12'd783;
            8'd65: qrom = 12'd795;
            8'd66: qrom = 12'd807;
            8'd67: qrom = 12'd818;
            8'd68: qrom = 12'd830;
            8'd69: qrom = 12'd841;
            8'd70: qrom = 12'd852;
            8'd71: qrom = 12'd864;
            8'd72: qrom = 12'd875;
            8'd73: qrom = 12'd887;
            8'd74: qrom = 12'd898;
            8'd75: qrom = 12'd909;
            8'd76: qrom = 12'd920;
            8'd77: qrom = 12'd932;
            8'd78: qrom = 12'd943;
            8'd79: qrom = 12'd954;
            8'd80: qrom = 12'd965;
            8'd81: qrom = 12'd976;
            8'd82: qrom = 12'd987;
            8'd83: qrom = 12'd998;
            8'd84: qrom = 12'd1009;
            8'd85: qrom = 12'd1020;
            8'd86: qrom = 12'd1031;
            8'd87: qrom = 12'd1042;
            8'd88: qrom = 12'd1052;
            8'd89: qrom = 12'd1063;
            8'd90: qrom = 12'd1074;
            8'd91: qrom = 12'd1085;
            8'd92: qrom = 12'd1095;
            8'd93: qrom = 12'd1106;
            8'd94: qrom = 12'd1116;
            8'd95: qrom = 12'd1127;
            8'd96: qrom = 12'd1137;
            8'd97: qrom = 12'd1148;
            8'd98: qrom = 12'd1158;
            8'd99: qrom = 12'd1168;
            8'd100: qrom = 12'd1179;
            8'd101: qrom = 12'd1189;
            8'd102: qrom = 12'd1199;
            8'd103: qrom = 12'd1209;
            8'd104: qrom = 12'd1219;
            8'd105: qrom = 12'd1229;
            8'd106: qrom = 12'd1239;
            8'd107: qrom = 12'd1249;
            8'd108: qrom = 12'd1259;
            8'd109: qrom = 12'd1269;
            8'd110: qrom = 12'd1279;
            8'd111: qrom = 12'd1289;
            8'd112: qrom = 12'd1299;
            8'd113: qrom = 12'd1308;
            8'd114: qrom = 12'd1318;
            8'd115: qrom = 12'd1328;
            8'd116: qrom = 12'd1337;
            8'd117: qrom = 12'd1347;
            8'd118: qrom = 12'd1356;
            8'd119: qrom = 12'd1365;
            8'd120: qrom = 12'd1375;
            8'd121: qrom = 12'd1384;
            8'd122: qrom = 12'd1393;
            8'd123: qrom = 12'd1402;
            8'd124: qrom = 12'd1411;
            8'd125: qrom = 12'd1421;
            8'd126: qrom = 12'd1430;
            8'd127: qrom = 12'd1439;
            8'd128: qrom = 12'd1447;
            8'd129: qrom = 12'd1456;
            8'd130: qrom = 12'd1465;
            8'd131: qrom = 12'd1474;
            8'd132: qrom = 12'd1483;
            8'd133: qrom = 12'd1491;
            8'd134: qrom = 12'd1500;
            8'd135: qrom = 12'd1508;
            8'd136: qrom = 12'd1517;
            8'd137: qrom = 12'd1525;
            8'd138: qrom = 12'd1533;
            8'd139: qrom = 12'd1542;
            8'd140: qrom = 12'd1550;
            8'd141: qrom = 12'd1558;
            8'd142: qrom = 12'd1566;
            8'd143: qrom = 12'd1574;
            8'd144: qrom = 12'd1582;
            8'd145: qrom = 12'd1590;
            8'd146: qrom = 12'd1598;
            8'd147: qrom = 12'd1606;
            8'd148: qrom = 12'd1614;
            8'd149: qrom = 12'd1621;
            8'd150: qrom = 12'd1629;
            8'd151: qrom = 12'd1637;
            8'd152: qrom = 12'd1644;
            8'd153: qrom = 12'd1652;
            8'd154: qrom = 12'd1659;
            8'd155: qrom = 12'd1666;
            8'd156: qrom = 12'd1674;
            8'd157: qrom = 12'd1681;
            8'd158: qrom = 12'd1688;
            8'd159: qrom = 12'd1695;
            8'd160: qrom = 12'd1702;
            8'd161: qrom = 12'd1709;
            8'd162: qrom = 12'd1716;
            8'd163: qrom = 12'd1723;
            8'd164: qrom = 12'd1729;
            8'd165: qrom = 12'd1736;
            8'd166: qrom = 12'd1743;
            8'd167: qrom = 12'd1749;
            8'd168: qrom = 12'd1756;
            8'd169: qrom = 12'd1762;
            8'd170: qrom = 12'd1769;
            8'd171: qrom = 12'd1775;
            8'd172: qrom = 12'd1781;
            8'd173: qrom = 12'd1787;
            8'd174: qrom = 12'd1793;
            8'd175: qrom = 12'd1799;
            8'd176: qrom = 12'd1805;
            8'd177: qrom = 12'd1811;
            8'd178: qrom = 12'd1817;
            8'd179: qrom = 12'd1823;
            8'd180: qrom = 12'd1828;
            8'd181: qrom = 12'd1834;
            8'd182: qrom = 12'd1840;
            8'd183: qrom = 12'd1845;
            8'd184: qrom = 12'd1850;
            8'd185: qrom = 12'd1856;
            8'd186: qrom = 12'd1861;
            8'd187: qrom = 12'd1866;
            8'd188: qrom = 12'd1871;
            8'd189: qrom = 12'd1876;
            8'd190: qrom = 12'd1881;
            8'd191: qrom = 12'd1886;
            8'd192: qrom = 12'd1891;
            8'd193: qrom = 12'd1896;
            8'd194: qrom = 12'd1901;
            8'd195: qrom = 12'd1905;
            8'd196: qrom = 12'd1910;
            8'd197: qrom = 12'd1914;
            8'd198: qrom = 12'd1919;
            8'd199: qrom = 12'd1923;
            8'd200: qrom = 12'd1927;
            8'd201: qrom = 12'd1932;
            8'd202: qrom = 12'd1936;
            8'd203: qrom = 12'd1940;
            8'd204: qrom = 12'd1944;
            8'd205: qrom = 12'd1948;
            8'd206: qrom = 12'd1951;
            8'd207: qrom = 12'd1955;
            8'd208: qrom = 12'd1959;
            8'd209: qrom = 12'd1962;
            8'd210: qrom = 12'd1966;
            8'd211: qrom = 12'd1969;
            8'd212: qrom = 12'd1973;
            8'd213: qrom = 12'd1976;
            8'd214: qrom = 12'd1979;
            8'd215: qrom = 12'd1983;
            8'd216: qrom = 12'd1986;
            8'd217: qrom = 12'd1989;
            8'd218: qrom = 12'd1992;
            8'd219: qrom = 12'd1994;
            8'd220: qrom = 12'd1997;
            8'd221: qrom = 12'd2000;
            8'd222: qrom = 12'd2003;
            8'd223: qrom = 12'd2005;
            8'd224: qrom = 12'd2008;
            8'd225: qrom = 12'd2010;
            8'd226: qrom = 12'd2012;
            8'd227: qrom = 12'd2015;
            8'd228: qrom = 12'd2017;
            8'd229: qrom = 12'd2019;
            8'd230: qrom = 12'd2021;
            8'd231: qrom = 12'd2023;
            8'd232: qrom = 12'd2025;
            8'd233: qrom = 12'd2027;
            8'd234: qrom = 12'd2028;
            8'd235: qrom = 12'd2030;
            8'd236: qrom = 12'd2032;
            8'd237: qrom = 12'd2033;
            8'd238: qrom = 12'd2035;
            8'd239: qrom = 12'd2036;
            8'd240: qrom = 12'd2037;
            8'd241: qrom = 12'd2038;
            8'd242: qrom = 12'd2039;
            8'd243: qrom = 12'd2040;
            8'd244: qrom = 12'd2041;
            8'd245: qrom = 12'd2042;
            8'd246: qrom = 12'd2043;
            8'd247: qrom = 12'd2044;
            8'd248: qrom = 12'd2045;
            8'd249: qrom = 12'd2045;
            8'd250: qrom = 12'd2046;
            8'd251: qrom = 12'd2046;
            8'd252: qrom = 12'd2046;
            8'd253: qrom = 12'd2047;
            8'd254: qrom = 12'd2047;
            8'd255: qrom = 12'd2047;
            default: qrom = {OW{1'b0}};
         endcase
      end
   endfunction

   // full-period signed sample from an AW-bit phase via quadrant symmetry
   function signed [OW-1:0] sample;
      input [AW-1:0] ph;
      reg [1:0]      quad;
      reg [AW-3:0]   idx;
      reg [OW-1:0]   mag;
      begin
         quad = ph[AW-1:AW-2];
         idx  = ph[AW-3:0];
         // rising quadrants use idx directly; falling quadrants mirror (NQ-1-idx == ~idx)
         if (quad[0])
            mag = qrom(~idx);
         else
            mag = qrom(idx);
         // quadrants 2,3 are the negative half of the sine
         if (quad[1])
            sample = -$signed({1'b0, mag});
         else
            sample =  $signed({1'b0, mag});
      end
   endfunction

   // cosine leads sine by a quarter period (2^(AW-2))
   assign sine   = sample(phase);
   assign cosine = sample(phase + {2'b01, {(AW-2){1'b0}}});

endmodule
