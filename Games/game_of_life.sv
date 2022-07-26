module game_of_life(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q ); 
    
    reg [15:0][15:0]q2;
    assign q=q2;
    parameter dim=16;
    reg[3:0] sums[15:0][15:0];
    
    always@(*)begin
        for(int j=0;j<16;j++)begin
            for(int i=0;i<16;i++)begin
                sums[j][i]=
                q2[(j-1+dim)%dim][(i-1+dim)%dim] + q2[(j-1+dim)%dim][i] + q2[(j-1+dim)%dim][(i+1+dim)%dim] +
                q2[j            ][(i-1+dim)%dim] +                        q2[j            ][(i+1+dim)%dim] +
                q2[(j+1+dim)%dim][(i-1+dim)%dim] + q2[(j+1+dim)%dim][i] + q2[(j+1+dim)%dim][(i+1+dim)%dim];
            end
        end
    end
    always@(posedge clk)begin
        if(load)
            q2<=data;
        else
    		for(int j=0;j<16;j++)begin
            	for(int i=0;i<16;i++)begin
                    case(sums[j][i])
                        4'h3: q2[j][i]<=1'b1;
                        4'h2: q2[j][i]<=q2[j][i];
                        default: q2[j][i]<=1'b0;
                    endcase
                end     
            end
    end
endmodule