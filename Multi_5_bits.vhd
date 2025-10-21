library ieee; 
use ieee.std_logic_1164.all; 
 
entity Multiplicador is 
    port ( 
        A, B: in std_logic_vector(4 downto 0); 
    Cout:out std_logic; 
        ResultadoF: out std_logic_vector(10 downto 0); 
    flag_zero: out std_logic; 
    flag_signo:out std_logic; 
    flag_acarreo:out std_logic; 
    flag_overflow:out std_logic 
    ); 
end Multiplicador; 
 
 
architecture comportamental of Multiplicador is 
  
 Component Full_adder_Vector_de_bits 
 port( 
  A, B : in std_logic_vector(9 downto 0); 
  Carry : out std_logic; 
  Res : out std_logic_vector(9 downto 0); 
  flag_zero : out std_logic; 
  flag_signo : out std_logic; 
  flag_acarreo : out std_logic;  
  flag_overflow : out std_logic 
 ); 
end component; 
 
 signal C: std_logic_vector(49 downto 0); 
 signal Carry: std_logic_vector (3 downto 0); 
 signal SumTem1,SumTem2,SumTem3,SumTem4: std_logic_vector (9 downto 0); 
  
begin 
    C(0) <= A(0) and B(0); 
  C(1) <= A(1) and B(0); 
  C(2) <= A(2) and B(0); 
  C(3) <= A(3) and B(0); 
  C(4) <= A(4) and B(0); 
  C(5) <='0'; 
  C(6) <='0'; 
  C(7) <='0'; 
  C(8) <='0'; 
  C(9) <='0'; 
   
  C(10)<='0'; 
  C(11) <= A(0) and B(1); 
  C(12) <= A(1) and B(1); 
  C(13) <= A(2) and B(1); 
  C(14) <= A(3) and B(1); 
   C(15) <= A(4) and B(1); 
  C(16) <= '0'; 
  C(17) <= '0'; 
  C(18) <= '0'; 
  C(19) <= '0'; 
   
 --Suma final 
 --Componenete suma 
 Sum0: Full_adder_Vector_de_bits port map( 
 A=> C(9 downto 0), 
 B=> C(19 downto 10), 
 Carry=> Carry(0), 
 Res=> SumTem1 
 ); 
  
  C(20) <= '0'; 
  C(21) <= '0'; 
  C(22) <= A(0) and B(2); 
  C(23) <= A(1) and B(2); 
  C(24) <= A(2) and B(2); 
  C(25) <= A(3) and B(2); 
  C(26) <= A(4) and B(2); 
  C(27) <= '0'; 
  C(28) <= '0'; 
  C(29) <= '0'; 
  
 --Suma final 
 --Componenete suma 
 Sum1: Full_adder_Vector_de_bits port map( 
 A=> SumTem1, 
 B=> C(29 downto 20), 
 Carry=> Carry(1), 
 Res=> SumTem2 
 ); 
   
  C(30) <= '0'; 
  C(31) <= '0'; 
  C(32) <= '0'; 
  C(33) <= A(0) and B(3); 
  C(34) <= A(1) and B(3); 
  C(35) <= A(2) and B(3); 
  C(36) <= A(3) and B(3); 
  C(37) <= A(4) and B(3); 
  C(38) <= '0'; 
  C(39) <= '0'; 
   
  --Suma final 
 --Componenete suma 
 Sum2: Full_adder_Vector_de_bits port map( 
 A=> SumTem2, 
 B=> C(39 downto 30), 
 Carry=> Carry(2), 
 Res=> SumTem3 
 ); 
  
  C(40) <= '0'; 
  C(41) <= '0'; 
  C(42) <= '0'; 
  C(43) <= '0'; 
  C(44) <= A(1) and B(4); 
  C(45) <= A(2) and B(4); 
    C(46) <= A(3) and B(4); 
  C(47) <= A(4) and B(4); 
  C(48) <= A(4) and B(4); 
  C(49) <= '0'; 
  
 --Suma final 
 --Componenete suma 
 Sum3: Full_adder_Vector_de_bits port map( 
 A=> SumTem3, 
 B=> C(49 downto 40), 
 Carry=> Carry(3), 
 Res=> SumTem4 
 ); 
  
  ResultadoF <= Carry(3) & SumTem4; 
    
flag_zero <= '1' when (Carry(3) & SumTem4 = "00000000000") else '0'; 
flag_signo <= '0';  -- asumiendo que todos los números son positivos 
flag_acarreo <= '0'; 
flag_overflow <= '0'; 
 
end comportamental; 