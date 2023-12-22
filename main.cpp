#include <iostream>
#include <fstream>
#include <string>
using namespace std;

int ATM_cpp(int cardno, int correctPin, int currentBalance, int language, int service, int amount, int anotherServiceBit){ // returns balance
    int timecounter,
        state = 0,
        nextstate=0,
        idlestate = 0,
        languagetsate = 1,
        pinstate = 2,
        depositstate = 6,
        withdrawstate = 4,
        servicestate = 3,
        anotherservicestate = 4,
        balancestate = 8,
        exitstate = 5;


    int balance = currentBalance;

    int pin = correctPin;

    bool clock = true;

    while (clock) {

        switch (state) {
            case 0: //idlestate
                if (cardno != 0) {
                    nextstate = languagetsate;
                    state = nextstate;
                }
                else {
                    nextstate = state;
                    clock = false;
                }
                break;

            case 1: //languagestate
                timecounter = 0;
                if (language == 1 || language == 2) {
                    nextstate = pinstate;
                    state = nextstate;
                }

                else {
                    clock = false;
                    timecounter += 1;
                    if (timecounter < 5)
                        nextstate = state;

                    else {
//                        cout << "You took so long!!!\n";
                        nextstate = idlestate;
                        state = nextstate;
                        language = 0;
                        service = 0;
                        amount = 0;
                        cardno = 0;
                        pin = 0;
                        anotherServiceBit = 0;
                    }
                }
                break;

            case 2: //pinstate

                timecounter = 0;

                if (pin == correctPin) {
                    nextstate = servicestate;
                    state = nextstate;
                }
//                else if (pin != correctPin){ cout << "incorrect pin\n"; }
                else {
                    clock = false;
                    timecounter += 1;
                    if (timecounter < 5)
                        nextstate = state;

                    else {
//                        cout << "You took so long!!\n!";
                        nextstate = idlestate;
                        state = nextstate;
                        language = 0;
                        service = 0;
                        amount = 0;
                        cardno = 0;
                        pin = 0;
                        anotherServiceBit = 0;
                    }
                }
                break;

            case 3://servicestate

                timecounter = 0;

                if (service == 1)
                {

                    if((amount + currentBalance) > 255){

                        nextstate = idlestate;
                        state = nextstate;
                        clock = false;
                    }
                    else{
                        balance = currentBalance + amount;
                        currentBalance += amount;
                        nextstate = anotherservicestate;
                        state = nextstate;
                    }
                }

                else if (service == 2)
                {
                    if (amount > currentBalance){
                        clock = false;
//                        cout << "your balance is not enough\n";
                    }
                    else {
                        balance = currentBalance - amount;
                        currentBalance -= amount;
                        nextstate = anotherservicestate;
                        state = nextstate;
                    }
                }
                else if (service == 3)
                {
//                    cout << "your balance is : \n" << balance << endl;
                    nextstate = anotherservicestate;
                    state = nextstate;
                }
                else {
                    clock = false;
                    timecounter += 1;
                    if (timecounter < 5)
                        nextstate = state;
                    else {
//                        cout << "You took so long!!!\n";
                        nextstate = idlestate;
                        state = nextstate;
                        language = 0;
                        service = 0;
                        amount = 0;
                        cardno = 0;
                        pin = 0;
                        anotherServiceBit = 0;
                    }
                }
                break;

            case 4: // anotherServiceState

                if(anotherServiceBit){
                    nextstate = servicestate;
                    state = nextstate;
                    anotherServiceBit = 0;
                }
                else{
                    clock = false;
                }
                break;
        }
    }
    return balance;
}

int main() {

    int *nums = new int(7);

    int cardno, correctPin, currentBalance, language, service, amount, anotherServiceBit, balance;

    ifstream inputFile("Balances.txt");
    ofstream outputFile("BalancesCPP.txt");

    if (!inputFile.is_open()) {
        cerr << "Unable to open the file!" << std::endl;
        return 1; // Return an error code
    }
    if(!outputFile.is_open()){
        cerr << "Unable to open the file!" << std::endl;
        return 1; // Return an error code
    }

    char character;

    int i = 0;
    string num = "";

    while (inputFile.get(character)) {
        if(character != ' ' && character != '$'){
            num += character;
        }
        if(character == '$'){
            nums[i] = std::stoi(num);
            i++;
            num = "";
        }

        if(character == '\n'){
            cardno = nums[0];
            correctPin = nums[1];
            currentBalance = nums[2];
            language = nums[3];
            service = nums[4];
            amount = nums[5];
            anotherServiceBit = nums[6];

            outputFile << cardno << "$ " << correctPin << "$ " << currentBalance << "$ " << language << "$ " << service << "$ " << amount << "$ " << anotherServiceBit << "$ " << ATM_cpp(cardno, correctPin, currentBalance, language, service, amount, anotherServiceBit) << endl;
            num = "";
            i = 0;
        }
    }

    // Close the file
    inputFile.close();
    outputFile.close();

    return 0;
}
