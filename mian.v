module ATMmodule(

input clk;
input [3:0] pin, correctPin;
input [7:0] cardno;
input language;
input service;
input [4:0] amount; //money to deposit or withdraw
input [4:0] balance; //money in your bank acc.


localparam [3:0]
initialState=4'b0000,
languageState=4'b0001, //input language 
pinState=4'b0010,//input password
depositState=4'b0100, //deposit
withdrawState=4'b1000, //withdraw
serviceState=4'b0011, //choose a service
anotherServiceState=4'b0101,
balanceState=4'b0110, //balance
ConfirmAmountState=4'b0111; //confirm amount of money


//********************//


reg [3:0] state, nextState;
reg [4:0] bal;

	case(state)
initialState:  
begin
	if(cardno != 8'b0 )
	nextState=pinState;
	else
	nextState=state;
end

pinState:
begin
        if(pin == correctPin)

	nextState=languageState;
	else
	nextState=state;
end

languageState: 
depositState:
withdrawState:
serviceState:
anotherServiceState:
balanceState:
ConfirmAmountState: