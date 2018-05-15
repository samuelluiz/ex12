module ex12 (CLOCK_50, CLOCK2_50, KEY, I2C_SCLK, I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);

	input CLOCK_50, CLOCK2_50;
	input [0:0] KEY;
	// I2C Audio/Video config interface
	output I2C_SCLK;
	inout I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	// Local wires.
	wire read_ready, write_ready, read, write;
	wire [23:0] readdata_left, readdata_right;
	wire [23:0] writedata_left, writedata_right;
	wire reset = ~KEY[0];

	/////////////////////////////////
	// Your code goes here 
	/////////////////////////////////
	
	
	reg [23:0]ar[7:0];
	reg [23:0]al[7:0];
	reg [23:0]br[7:0];
	reg [23:0]bl[7:0]; 
	reg [23:0]somaright;
	reg [23:0]somaleft;
	
	always@ (posedge CLOCK_50)
		begin
			ar[7] = ar[6];
			al[7] = al[6];
			
		end
	always@ (posedge CLOCK_50)
		begin
			ar[6] = ar[5];
			al[6] = al[5];
			
		end		
	always@ (posedge CLOCK_50)
		begin
			ar[5] = ar[4];
			al[5] = al[4];
			
		end
	always@ (posedge CLOCK_50)
		begin
			ar[4] = ar[3];
			al[4] = al[3];
			
		end	
	always@ (posedge CLOCK_50)
		begin
			ar[3] = ar[2];
			al[3] = al[2];
			
		end
	always@ (posedge CLOCK_50)
		begin
			ar[2] = ar[1];
			al[2] = al[1];
			
		end
	always@ (posedge CLOCK_50)
		begin
			ar[1] = ar[0];
			al[1] = al[0];
			
		end
		always@ (posedge CLOCK_50)
		begin
			ar[0] = readdata_left ;
			al[0] = readdata_right;
			
		end
		
		br[0] <= (ar[0]>>3);
		br[1] = (ar[1]>>3);
		br[2] = (ar[2] >> 3);
		br[3] = (ar[3] >> 3);
		br[4] = (ar[4] >> 3);
		br[5] = (ar[5] >> 3);
		br[6] = (ar[6] >> 3);
		br[7] = (ar[7] >> 3);
		
		bl[0] = (al[0] >> 3);
		bl[1] = (al[1] >> 3);
		bl[2] = (al[2] >> 3);
		bl[3] = (al[3] >> 3);
		bl[4] = (al[4] >> 3);
		bl[5] = (al[5] >> 3);
		bl[6] = (al[6] >> 3);
		bl[7] = (al[7] >> 3);
		
		
		somaright = br[0] + br[1] + br[2] + br[3] + br[4] + br[5] + br[6] + br[7];
		somaleft = bl[0] + bl[1] + bl[2] + bl[3] + bl[4] + bl[5] + bl[6] + bl[7];
	
	assign writedata_left = readdata_left;
	assign writedata_right = readdata_right;
	assign read = read_ready;
	assign write = write_ready;
			
	
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		I2C_SDAT,
		I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule
