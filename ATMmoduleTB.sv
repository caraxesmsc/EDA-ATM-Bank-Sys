module ATMmoduleTB;
    reg clk;
    reg [3:0] pin, correctPin;
    reg [7:0] cardno;
    reg [1:0] language; 
    reg [1:0] service; 
    reg [4:0] amount;
    reg anotherServiceBit;
    reg [7:0] currentbalance;
    wire amIhere;
    wire [7:0] balance;
    wire longTime;

    //clock generation
    initial begin
        clk = 0;
        forever  
        #1 clk = ~clk;
    end

    initial begin: One

      reg [10:0] i;
      integer file;
      integer file1;
     
      file= $fopen("Accounts.txt","r");

      while(!$feof(file)) begin
        $fscanf(file,"%b", cardno);
        $fscanf(file,"%b", correctPin);
        $fscanf(file,"%b", currentbalance);
        
        pin = correctPin;

        for (i = 0; i < 500; i = i+1) begin
              // #32

              // currentbalance = $urandom_range(7'b0, 7'b0000100);
              language = $urandom_range(2'b00, 2'b10);
              service = $urandom_range(2'b00, 2'b11);
              if(service == 2'b01) begin
                amount = $urandom_range(5'b00000, 8'b11111111 - currentbalance);
                end // to prevent reset
              else begin
                amount = $urandom_range(5'b00000, currentbalance);
              end
              anotherServiceBit = $urandom_range(1'b0, 1'b1);
              @(negedge clk);

              #32

              file1= $fopen("Balances.txt","a");
              $fwrite (file1, cardno, "$", correctPin, "$", currentbalance, "$", language, "$",  service, "$",  amount, "$",  anotherServiceBit, "$", balance, "\n");
              
              $fclose(file1);

              
        end
      end

      $fclose(file);
      
      #32
      pin = 4'b0011;
      language = 2'b01;
      amount = 5'b00001;
      service = 3'b001;
      anotherServiceBit = 1'b0;

      #100 $stop();
    end


ATMmodule ATM_ver(.language(language), .service(service), .amount(amount), .cardno(cardno), .pin(pin), .anotherServiceBit(anotherServiceBit), .clk(clk), .correctPin(correctPin), .balance(balance), .currentbalance(currentbalance), .amIhere(amIhere), .longTime(longTime));

  property deposit_balance_0;
    @(posedge clk) (anotherServiceBit == 1'b0 && service == 2'b01 && language != 2'b00 && cardno != 8'b0) |-> (balance == (currentbalance + amount));
  endproperty

  property deposit_balance_1;
    @(posedge clk) (anotherServiceBit == 1'b1 && service == 2'b01 && language != 2'b00 && cardno != 8'b0  && amount + amount + currentbalance  <= currentbalance) |-> (balance == (currentbalance + amount + amount));
  endproperty

  property withdraw_balance_0;
    @(posedge clk) (anotherServiceBit == 1'b0 && service == 2'b10 && language != 2'b00 && cardno != 8'b0) |-> (balance == (currentbalance - amount));
  endproperty

  property withdraw_balance_1;
    @(posedge clk) (anotherServiceBit == 1'b1 && service == 2'b10 && language != 2'b00 && cardno != 8'b0) |-> (balance == (currentbalance - amount - amount));
  endproperty

  assert property(deposit_balance_0);
  assert property(deposit_balance_1);
  assert property(withdraw_balance_0);
  assert property(withdraw_balance_1);
  assert property (@(posedge clk) (cardno && pin));
endmodule
