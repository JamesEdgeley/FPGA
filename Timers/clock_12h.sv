module clock_12h(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 

    initial
        hh=8'h12;
    wire [3:0] digit;
    assign digit={ss==8'h59&mm==8'h59&hh==8'h11,ss==8'h59&mm==8'h59,ss==8'h59,1'b1};
    counter60 seconds(clk,reset,ena,digit[0],ss);
    counter60 minutes(clk,reset,ena,digit[1],mm);
    counter12 hours(clk,reset,ena,digit[2],hh);
    counter2 meridian(clk,reset,ena,digit[3],pm);
endmodule

module counter2(
    input clk,
    input reset,
    input g_ena,
    input control,
    output q);
    always@(posedge clk) begin
        if(reset|q&g_ena&control)
            q<=1'b0;
        else if(g_ena&control)
            q<=~q;
        else
            q<=q;
    end
endmodule
            
        
module counter12(
    input clk,
    input reset,
    input g_ena,
    input control,
    output[7:0] q);
    
    always@(posedge clk) begin
        if(reset|q==8'h11&g_ena&control)
            q<=8'h12;
        else if(q==8'h12&g_ena&control)
            q<=8'h1;
        else if(g_ena&control)begin
            if (q[3:0]==4'h9)begin
                q[3:0]<=4'h0;
                q[7:4]<=q[7:4]+1'b1;
            end
            else
                q[3:0]<=q[3:0]+1'b1;
        end
        else
            q<=q;
    end
endmodule

module counter60(
    input clk,
    input reset,
    input g_ena,
    input control,
    output[7:0] q);
    always@(posedge clk) begin
        if(reset|q==8'h59&g_ena&control)
            q<=8'h0;
        else if(g_ena&control)begin
            if (q[3:0]==4'h9)begin
                q[3:0]<=4'h0;
                q[7:4]<=q[7:4]+1'b1;
            end
            else
                q[3:0]<=q[3:0]+1'b1;
        end
        else
            q<=q;
    end
endmodule