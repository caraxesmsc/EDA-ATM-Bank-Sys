module ATMmodule(
    input  [1:0] language,// 00 is default ---- 01 is English ----- 10 is German
    input  [1:0] service,// 000 is default ---- 001 deposit ---- 010 withdraw ---- 011 checkBalance ---- 100 101 111
    input  [4:0] amount,// money to deposit or withdraw
    input  [7:0] cardno,
    input  [3:0] pin,
    input  anotherServiceBit,// 0 is default means no another service if changed to 1 then go back to serviceSate
    input clk,
    input [3:0]  correctPin,
    input [7:0] currentbalance,
    output reg amIhere,
    output reg [7:0] balance, // money in your bank acc.
    output reg longTime
);

    reg [3:0] timerCounter;
    // States definition
    localparam [3:0]
        idleState = 4'b0000,
        languageState = 4'b0001, // input language 
        pinState = 4'b0010,      // input password
        depositState = 4'b0100,  // deposit
        withdrawState = 4'b1000, // withdraw
        serviceState = 4'b0011,  // choose a service
        anotherServiceState = 4'b0101,
        balanceState = 4'b0110;  // balance

    // State and nextState registers
    reg [3:0] state, nextState;
    reg [7:0] currentbalanceReg;
    reg [1:0] language_reg;
    reg [1:0] service_reg;
    reg [4:0] amount_reg;
    reg [7:0] cardno_reg;
    reg [3:0] pin_reg;
    reg anotherServiceBit_reg;

    always @(currentbalance or service or amount) begin
        // Assign input values to reg variables
        state = idleState;
        nextState = state;
        anotherServiceBit_reg = anotherServiceBit;
        currentbalanceReg = currentbalance;
        language_reg = language;
        service_reg = service;
        amount_reg = amount;
        cardno_reg = cardno;
        pin_reg = pin;
        balance = currentbalance;
        timerCounter = 4'b0;
        longTime = 1'b0;
    end

    always @(posedge clk) 
    begin
        // Sequential logic: State transition on positive edge of the clock

        if(nextState != state)
            timerCounter = 0;
        else
        begin
            if(timerCounter==4'b1110)
                longTime= 1'b1;
            else
                timerCounter = timerCounter+1;
        end

        if(longTime) begin
            //idle state
            nextState=idleState;
            //reset values
            language_reg = 2'b00;
            service_reg = 2'b00;
            amount_reg = 5'b00000;
            cardno_reg = 8'b00000000;
            pin_reg = 4'b0000;
            anotherServiceBit_reg = 0;
        end
        state = nextState;
    end

    always @(*) begin: alwaysBlock
        reg [7:0] temp; // for use in deposit
        amIhere = 0;
        case(state)
            idleState:  
                begin
                    // Transition to languageState if card number is present
                    if(cardno_reg != 8'b00000000) 
                        begin
                            nextState = languageState;
                                       
                        end
                    else 
                        begin
                            nextState = state;
                        end
                end
            //? The Language State of the System
            languageState: 
                begin
                    // Check selected language
                    if(language_reg == 2'b01)
                        begin
                            nextState = pinState;
                        end
                    else if (language_reg == 2'b10)
                        begin
                            nextState = pinState;
                        end
                    else
                        begin
                            nextState = state;
                        end
                end
            //? The Pin State of the System
            pinState:
                begin
                    // Check if the entered PIN is correct
                    if(pin_reg == correctPin) 
                        begin
                            nextState = serviceState;
                        end
                    else
                        begin
                            nextState = state;
                        end
                end
            //? The Service State of the System
            serviceState:
                begin
                    case(service_reg)
                        // 3'b000: nextState = state;  
                        2'b01: nextState = depositState;
                        2'b10: nextState = withdrawState;
                        2'b11: nextState = balanceState;
                        default: nextState = idleState;
                        // Add cases for 3'b100, 3'b101, and 3'b111 if needed
                    endcase

                end

            //! The Deposit State of the System
            depositState:
                begin // Check if the deposit amount is valid
                #5 amIhere = 1;
                temp = amount_reg + currentbalanceReg;
                    if(amount_reg)
                        begin
                            if(temp < currentbalanceReg) begin 
                                nextState = idleState;
                            end
                            else begin 
                                balance = currentbalanceReg + amount_reg;
                                nextState = anotherServiceState;
                                currentbalanceReg = balance;
                            end
                        end
                    else
                        begin
                            nextState = state;
                        end
                end
            //! The Withdraw State of the System
            withdrawState:
                begin // Check if the withdraw amount is valid
                    if(amount_reg)
                        begin
                            if(amount_reg > balance) // If withdraw amount exceeds balance, transition to idleState
                                nextState = idleState;
                            else
                                begin
                                    // Update balance and transition to anotherServiceState
                                    balance = currentbalanceReg - amount_reg;
                                    nextState = anotherServiceState;
                                    currentbalanceReg = balance;
                                end
                        end
                    else
                    begin
                        nextState = state;
                    end
                end

            balanceState:
                begin
                    balance = currentbalanceReg;
                    // Display balance and transition to anotherServiceState
                    nextState = anotherServiceState;
                end

            anotherServiceState:
                begin
                    // Transition to serviceState if anotherServiceBit is set, else idleState
                    if(anotherServiceBit_reg) 
                        begin
                            

                            nextState = serviceState;
                            anotherServiceBit_reg = 0;
                        end
                    else 
                        begin
                            nextState = state;
                        end
                end

            default: nextState = idleState;
        endcase
    end
    
endmodule

