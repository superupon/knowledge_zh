if ... begin 
  if (size == 3'h1) begin
    case (addr[3:0])
      4'h0 : begin oWdata = {iWdata[127:0]}; end
      4'h1 : begin oWdata = {iWdata[127:8]. 8]h0}; end
      4'h2 : begin oWdata = {iWdata[127:16]}; end
      4'h3 : begin oWdata = {iWdata[127:24]}; end
      4'h4 : begin oWdata = {iWdata[127:32]}; end
      4'h5 : begin oWdata = {iWdata[127:40]}; end
      4'h6 : begin oWdata = {iWdata[127:48]}; end
      // ....
      4'he : begin oWdata = {iWdata[127:120]}; end
      4'hf : begin oWdata = {iWdata[127:0]}; end
    endcase
  end
  else if (size == 3'h2) begin
    case (addr[3:0])
      4'h0 : begin oWdata = {iWdata[127:0]}; end
      4'h1 : begin oWdata = {iWdata[127:8]. 8]h0}; end
      4'h2 : begin oWdata = {iWdata[127:0]}; end
      4'h3 : begin oWdata = {iWdata[127:0]}; end
      4'h4 : begin oWdata = {iWdata[127:0]}; end
      4'h5 : begin oWdata = {iWdata[127:0]}; end
      4'h6 : begin oWdata = {iWdata[127:0]}; end
      // ....
      4'he : begin oWdata = {iWdata[127:0]}; end
      4'hf : begin oWdata = {iWdata[127:0]}; end
    endcase
  end
  else if (size == 3'h3) begin
    case (addr[3:0])
      4'h0 : begin oWdata = {iWdata[127:0]}; end
      4'h1 : begin oWdata = {iWdata[127:8]. 8]h0}; end
      4'h2 : begin oWdata = {iWdata[127:0]}; end
      4'h3 : begin oWdata = {iWdata[127:0]}; end
      4'h4 : begin oWdata = {iWdata[127:0]}; end
      4'h5 : begin oWdata = {iWdata[127:0]}; end
      4'h6 : begin oWdata = {iWdata[127:0]}; end
      // ....
      4'he : begin oWdata = {iWdata[127:0]}; end
      4'hf : begin oWdata = {iWdata[127:0]}; end
    endcase
  end
  else if (size == 3'h4) begin
    case (addr[3:0])
      4'h0 : begin oWdata = {iWdata[127:0]}; end
      4'h1 : begin oWdata = {iWdata[127:8]. 8]h0}; end
      4'h2 : begin oWdata = {iWdata[127:0]}; end
      4'h3 : begin oWdata = {iWdata[127:0]}; end
      4'h4 : begin oWdata = {iWdata[127:0]}; end
      4'h5 : begin oWdata = {iWdata[127:0]}; end
      4'h6 : begin oWdata = {iWdata[127:0]}; end
      // ....
      4'he : begin oWdata = {iWdata[127:0]}; end
      4'hf : begin oWdata = {iWdata[127:0]}; end
    endcase
  end
  else if (size == 3'h5) begin
    case (addr[3:0])
      4'h0 : begin oWdata = {iWdata[127:0]}; end
      4'h1 : begin oWdata = {iWdata[127:8]. 8]h0}; end
      4'h2 : begin oWdata = {iWdata[127:0]}; end
      4'h3 : begin oWdata = {iWdata[127:0]}; end
      4'h4 : begin oWdata = {iWdata[127:0]}; end
      4'h5 : begin oWdata = {iWdata[127:0]}; end
      4'h6 : begin oWdata = {iWdata[127:0]}; end
      // ....
      4'he : begin oWdata = {iWdata[127:0]}; end
      4'hf : begin oWdata = {iWdata[127:0]}; end
    endcase
  end
  ...
end
else if ... begin
end
else if ... begin
end
else if ... begin
end
else if ... begin
end
else if ... begin
end
else begin
end
