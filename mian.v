module ATMmodule(
    input clk,
    input [3:0] pin, correctPin,
    input [7:0] cardno,
    input [1:0] language, // 00 is default ---- 01 is English ----- 10 is German
    input [2:0] service, // 000 is default ---- 001 deposit ---- 010 withdraw ---- 011 checkBalance ---- 100 101 111
    input [4:0] amount, // money to deposit or withdraw
    input anotherServiceBit, // 0 is default means no another service if changed to 1 then go back to serviceSate
    output reg [4:0] balance // money in your bank acc.
);
    reg [31:0] timerCounter;

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

    // Initialization block
    // initial begin
    //     // Initial values for the inputs
    //     language = 2'b00;
    //     service = 3'b000;
    //     amount = 5'b00000;
    //     cardno = 8'b00000000;
    //     pin = 4'b0000;
    //     anotherServiceBit = 0;
    // end


    always @(posedge clk) 
    begin
        // Sequential logic: State transition on positive edge of the clock
        if(state != nextState)
            timerCounter = 0;
        state = nextState;
    end

    always @(*) begin
        // Combinational logic: Determines the next state based on the current state and inputs
        nextState = state; // Default nextState is the current state
        case(state)
            // The Idle State of the System
            idleState:  
                begin
                    // Transition to languageState if card number is present
                    if(cardno != 8'b0 )
                        nextState = languageState;
                    else
                        nextState = state;
                end

            languageState: 
                begin
                    // Reset the timer counter
                    timerCounter = 0;

                    // Check selected language
                    if(language == 2'b01)
                    begin
                        // Display and transition to pinState after 2 clock cycles
                        // $display("English Language is chosen");
                        nextState = pinState;
                    end
                    else if (language == 2'b10)
                    begin
                        // Display and transition to pinState after 2 clock cycles
                        // $display("German Language is chosen");
                        nextState = pinState;
                    end
                    else
                    begin
                        // Increment timer and take action if timer exceeds 5 cycles
                        timerCounter = timerCounter + 1;
                        if(timerCounter < 5)
                            nextState = state;
                        else
                        begin
                            // Display, reset to idleState, and clear inputs
                            // $display("No Action taken");
                            nextState = idleState;
                            language = 2'b00;
                            service = 3'b000;
                            amount = 5'b00000;
                            cardno = 8'b00000000;
                            pin = 4'b0000;
                            anotherServiceBit = 0;
                        end
                    end
                end

                        pinState:
                begin
                    // Reset the timer counter
                    timerCounter = 0;

                    // Check if the entered PIN is correct
                    if(pin == correctPin)
                        nextState = serviceState;
                    else
                    begin
                        // Increment timer and take action if timer exceeds 5 cycles
                        timerCounter = timerCounter + 1;
                        if(timerCounter < 5)
                            nextState = state;
                        else
                        begin
                            // Display, reset to idleState, and clear inputs
                            // $display("No Action taken");
                            nextState = idleState;
                            language = 2'b00;
                            service = 3'b000;
                            amount = 5'b00000;
                            cardno = 8'b00000000;
                            pin = 4'b0000;
                            anotherServiceBit = 0;
                        end
                    end
                end

            serviceState:
                begin
                    // Reset the timer counter
                    timerCounter = 0;

                    // Check if a service is selected
                    if(service != 3'b000)
                    begin
                        case(service)
                            //3'b000: nextState = state;  
                            3'b001: nextState = depositState;
                            3'b010: nextState = withdrawState;
                            3'b011: nextState = balanceState;
                            // Add cases for 3'b100, 3'b101, and 3'b111 if needed
                        endcase
                    end
                    else
                    begin
                        // Increment timer and take action if timer exceeds 5 cycles
                        timerCounter = timerCounter + 1;
                        if(timerCounter < 5)
                            nextState = state;
                        else
                        begin
                            // Display, reset to idleState, and clear inputs
                            // $display("No Action taken");
                            nextState = idleState;
                            language = 2'b00;
                            service = 3'b000;
                            amount = 5'b00000;
                            cardno = 8'b00000000;
                            pin = 4'b0000;
                            anotherServiceBit = 0;
                        end
                    end
                end

            depositState:
                begin
                    // Check if the deposit amount is valid
                    if(amount != 5'b0)
                    begin
                        // if(amount < 0)
                        // begin
                        //     // Display and transition to idleState
                        //     // $display("Can't Deposit Negative Amount");
                        //     nextState = idleState;
                        // end
                        // else
                        begin
                            // Display, update balance, and transition to anotherServiceState
                            // $display("%d Amount Deposited into your Account", amount);
                            balance = balance + amount;
                            nextState = anotherServiceState;
                        end
                    end
                    else
                    begin
                        // Increment timer and take action if timer exceeds 5 cycles
                        timerCounter = timerCounter + 1;
                        if(timerCounter < 5)
                            nextState = state;
                        else
                        begin
                            // Display, reset to idleState, and clear inputs
                            // $display("No Action taken");
                            nextState = idleState;
                            language = 2'b00;
                            service = 3'b000;
                            amount = 5'b00000;
                            cardno = 8'b00000000;
                            pin = 4'b0000;
                            anotherServiceBit = 0;
                        end
                    end
                end

            withdrawState:
                begin
                    // Check if the withdraw amount is valid
                    if(amount != 5'b0)
                    begin
                        if(amount >= balance)
                            // If withdraw amount exceeds balance, transition to idleState
                            nextState = idleState;
                        else
                        begin
                            // Update balance and transition to anotherServiceState
                            balance = balance - amount;
                            nextState = anotherServiceState;
                        end
                    end
                    else
                    begin
                        // Increment timer and take action if timer exceeds 5 cycles
                        timerCounter = timerCounter + 1;
                        if(timerCounter < 5)
                            nextState = state;
                        else
                        begin
                            // Display, reset to idleState, and clear inputs
                            // $display("No Action taken");
                            nextState = idleState;
                            language = 2'b00;
                            service = 3'b000;
                            amount = 5'b00000;
                            cardno = 8'b00000000;
                            pin = 4'b0000;
                            anotherServiceBit = 0;
                        end
                    end
                end

            balanceState:
                begin
                    // Display balance and transition to anotherServiceState
                    // $display("Your Balance is : %d ", balance);
                    nextState = anotherServiceState;
                end

            anotherServiceState:
                begin
                    // Display prompt for another service
                    // $display("Do you want to make another service");

                    // Transition to serviceState if anotherServiceBit is set, else idleState
                    if(anotherServiceBit)
                        nextState = serviceState;
                    else
                        nextState = idleState;
                end
        endcase
    end
endmodule

