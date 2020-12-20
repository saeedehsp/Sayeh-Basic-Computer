library IEEE;
use IEEE.std_logic_1164.all;
 
 entity sayeh is
   port (
     clk : in std_logic;
     ExternalReset, MemDataReady : in std_logic := '0';
     ReadMem, WriteMem, ReadIO, WriteIO : out std_logic := '0';
     Addressbus : out std_logic_vector (15 downto 0) := "0000000000000000";
     DatabusIn : in std_logic_vector (15 downto 0) := "0000000000000000";
     DatabusOut : out std_logic_vector (15 downto 0) := "0000000000000000"
   );
 end sayeh;

 architecture behavioral of sayeh is

      component datapath port (
        clk, B15downto0, AandB, AorB, NotB, AaddB, AsubB, AcmpB, shrB, shlB : in std_logic;
		ResetPC, PCplusI, PCplus1, R0plusI, R0plus0,
		Rs_on_AddressUnit, Rd_on_AddressUnit,
 		RFLwrite, RFHwrite, WPreset, WPadd, IRload,
		Address_on_Databus, ALUout_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus, RFright_on_OpndBus,
		Cset, Creset, Zset, Zreset, Zin, Cin, Shadow : in std_logic :='0';
	 	Addressbus : out std_logic_vector (15 downto 0) := "0000000000000000";
		DatabusIn : in std_logic_vector (15 downto 0) := "0000000000000000";
		DatabusOut : out std_logic_vector (15 downto 0) := "0000000000000000"
    );
   end component;

   component controller port (
        ReadMem, WriteMem, -- memory
		address_on_databus, ALUout_on_Databus, -- databus
		ResetPc, PCplus1, PCplusI, R0plusI, R0plus0, -- pc
		RFLwrite, RFHwrite, -- registerfile
		WPadd, WPreset, -- wp
		RS_on_AddresetUnitRSide, RD_on_AddresetUnitRSide, -- addressLogic
		IRload, Shadow, -- IR
		IR_on_LOpndBus, RFright_on_OpndBus, IR_on_HOpndBus, -- OPndBus
		B15downto0, AandB, AorB, NotB, AaddB, AsubB, AcmpB, shrB, shlB, -- alu
		Cset, Creset, Zset, ZReset : out std_logic := '0';  --flags
		IR : in std_logic_vector (15 downto 0);
		clk, External_Reset, MemDataReady, Zin, Cin : in std_logic
    );
    end component;

 
    signal register_load,register_shift, ResetPC, PCplusI, PCplus1, R0plusI, R0plus0,
    Rs_on_AddressUnit, Rd_on_AddressUnit, External_Reset,
    RFLwrite, RFHwrite, WPreset, WPadd, IRload, rst, RD_on_AddresetUnitRSide, RS_on_AddresetUnitRSide, IR_on_LOdBus,
    Address_on_Databus, ALUout_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus, RFright_on_OpndBus,
    B15downto0, AandB, AorB, NotB, AaddB, AsubB, AcmpB, shrB, shlB,
    Cset, Creset, Zset, Zreset, Zin, Cin, Shadow : std_logic := '0';
    signal	register_in :  std_logic_vector (3 downto 0) := "0000";
    signal	RSide :  std_logic_vector (15 downto 0) := "0000000000000000";
    signal  ISide :  std_logic_vector (7 DOWNTO 0) := "00000000";
    signal	register_out, Cout, Zout : std_logic := '0';
    signal  IR : std_logic_vector (15 downto 0) := "0000000000000000";

 begin

     DP  : datapath port map (
        clk => clk,
        B15downto0 => B15downto0,
        AandB => AandB,
        AorB => AorB,
        NotB => NotB,
        AaddB => AaddB,
        AsubB => AsubB,
        AcmpB => AcmpB,
        shrB => shrB,
        shlB => shlB,
        ResetPC => ResetPC,
        PCplusI => PCplusI,
        PCplus1 => PCplus1,
        R0plusI => R0plusI,
        R0plus0 => R0plus0,
        Rs_on_AddressUnit => Rs_on_AddressUnit,
        Rd_on_AddressUnit => Rd_on_AddressUnit,
        RFLwrite => RFLwrite,
        RFHwrite => RFHwrite,
        WPreset => WPreset,
        WPadd => WPadd,
        IRload => IRload,
        Address_on_Databus => Address_on_Databus,
        ALUout_on_Databus => ALUout_on_Databus,
        IR_on_LOpndBus => IR_on_LOpndBus,
        IR_on_HOpndBus => IR_on_HOpndBus,
        RFright_on_OpndBus => RFright_on_OpndBus,
        Cset => Cset,
        Creset => Creset,
        Zset => Zset,
        Zreset => Zreset,
        Zin => Zin,
        Cin => Cin,
        Shadow => Shadow,
        Addressbus => Addressbus,
        DatabusIn => DatabusIn,
        DatabusOut => DatabusOut
    );

    ctrl : controller port map (
        ReadMem => ReadMem,
        WriteMem => WriteMem,
        address_on_databus => Address_on_Databus,
        ALUout_on_Databus => ALUout_on_Databus,
        ResetPc => ResetPc,
        PCplus1 => PCplus1,
        PCplusI => PCplusI,
        R0plusI => R0plusI,
        R0plus0 => R0plus0,
        RFLwrite => RFLwrite,
        RFHwrite => RFHwrite,
        WPadd => WPadd,
        WPreset => WPreset,
        RS_on_AddresetUnitRSide => RS_on_AddresetUnitRSide,
        RD_on_AddresetUnitRSide => RD_on_AddresetUnitRSide,
        IRload => IRload,
        Shadow => Shadow,
        IR_on_LOpndBus => IR_on_LOpndBus,
        RFright_on_OpndBus => RFright_on_OpndBus,
        IR_on_HOpndBus => IR_on_HOpndBus,
        B15downto0 => B15downto0,
        AandB => AandB,
        AorB => AorB,
        NotB => NotB,
        AaddB => AaddB,
        AsubB => AsubB,
        AcmpB => AcmpB,
        shrB => shrB,
        shlB => shlB,
        Cset => Cset,
        Creset => Creset,
        Zset => Zset,
        ZReset => ZReset,
        IR => DatabusIn,
        clk => clk,
        External_Reset => External_Reset,
        MemDataReady => MemDataReady,
        Zin => Zin,
        Cin => Cin
    );

end behavioral ; -- behavioral