module ProgramCounter 
(
    input Clock, Reset, LoadEnable, OffsetEnable,
    input logic [15:0]LoadValue, 
    input logic [8:0] Offset,
    output logic [15:0]CounterValue // bit instead? removes x and z
);
    always_ff @(posedge Clock, posedge Reset) begin

        if (Reset) // Reset => PC = 0
            CounterValue <= 16'b0;
        else if (LoadEnable) // LoadEnable => PC = LoadValue
            CounterValue <= LoadValue;
        else if (OffsetEnable) // OffsetEnable => PC += Offset
            CounterValue <= CounterValue + Offset;
        else // No other pins active => PC++
            CounterValue <= CounterValue + 16'b1;
        
    end


    /*
        case ({Reset, LoadEnable, OffsetEnable})
            Reset : CounterValue <= 0;
            LoadEnable : CounterValue <= LoadValue;
            OffsetEnable : CounterValue <= CounterValue + Offset;
            default : CounterValue <= CounterValue + 1;
        endcase
    end
    assign CounterValue = CounterValue;
    */
    
endmodule