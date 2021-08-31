CC=g++
CFLAG=-g -Wall -pedantic -Wno-long-long -Werror -Wno-variadic-macros
INCLUDE=/onnc-umbrella/onncroot/include
LIB=/onnc-umbrella/onncroot/lib-linux64
CALIBRATOR=/umbrella/skymizer-master-toplevel/bin/calibrator.cortex_m
CALFLAG=-calibration-images
PRECIS=/umbrella/skymizer-master-toplevel/bin/precision_simulator.cortex_m
ONNSIM=./onnsim.cortex_m
PICTURE=/umbrella/model-vww/calibration.pb
MODEL=/umbrella/model-vww/vww.onnx
FF=-means=0,0,0 -scales=255,255,255
TESTBENCH_DIR=/testbench
all:
	$(CC) $(CFLAG) -I$(INCLUDE) -L$(LIB) -Wl,-rpath=$(LIB) main.cpp -o onnsim.cortex_m -lsystemc -lm
	$(CALIBRATOR) $(CALFLAG) $(TESTBENCH_DIR)/ad/ad01_1x640.pb $(TESTBENCH_DIR)/ad/ad01.onnx -o $(TESTBENCH_DIR)/ad/ctable.json
	$(PRECIS) $(TESTBENCH_DIR)/ad/ad01.onnx -ctable-path $(TESTBENCH_DIR)/ad/ctable.json -input-data $(TESTBENCH_DIR)/ad/ad01_1x640.pb -o ./precision_output_ad01.bin
	$(ONNSIM) $(TESTBENCH_DIR)/ad/ad01.onnx -ctable-path $(TESTBENCH_DIR)/ad/ctable.json -input-data $(TESTBENCH_DIR)/ad/ad01_1x640.pb -o ./onnsim_output_ad01.bin
	$(CALIBRATOR) $(CALFLAG) $(TESTBENCH_DIR)/ic/ic_1x3x32x32.pb $(TESTBENCH_DIR)/ic/pretrainedResnet.onnx -means=0,0,0 -scales=1,1,1 -o $(TESTBENCH_DIR)/ic/ctable.json
	$(PRECIS) $(TESTBENCH_DIR)/ic/pretrainedResnet.onnx -ctable-path $(TESTBENCH_DIR)/ic/ctable.json -input-data $(TESTBENCH_DIR)/ic/ic_1x3x32x32.pb -o ./precision_output_ic.bin
	$(ONNSIM) $(TESTBENCH_DIR)/ic/pretrainedResnet.onnx -ctable-path $(TESTBENCH_DIR)/ic/ctable.json -input-data $(TESTBENCH_DIR)/ic/ic_1x3x32x32.pb -o ./onnsim_output_ic.bin
	$(CALIBRATOR) $(CALFLAG) $(TESTBENCH_DIR)/kws/kws01_1x1x49x10.pb $(TESTBENCH_DIR)/kws/kws_ref_model.onnx -o $(TESTBENCH_DIR)/kws/ctable.json
	$(PRECIS) $(TESTBENCH_DIR)/kws/kws_ref_model.onnx -ctable-path $(TESTBENCH_DIR)/kws/ctable.json -input-data $(TESTBENCH_DIR)/kws/kws01_1x1x49x10.pb -o ./precision_output_kws.bin
	$(ONNSIM) $(TESTBENCH_DIR)/kws/kws_ref_model.onnx -ctable-path $(TESTBENCH_DIR)/kws/ctable.json -input-data $(TESTBENCH_DIR)/kws/kws01_1x1x49x10.pb -o ./onnsim_output_kws.bin
	$(CALIBRATOR) $(CALFLAG) $(TESTBENCH_DIR)/vww/vw_coco2014_batch1.pb $(TESTBENCH_DIR)/vww/vww_96.onnx -means=0,0,0 -scales=255,255,255 -o $(TESTBENCH_DIR)/vww/ctable.json
	$(PRECIS) $(TESTBENCH_DIR)/vww/vww_96.onnx -ctable-path $(TESTBENCH_DIR)/vww/ctable.json -input-data $(TESTBENCH_DIR)/vww/vw_coco2014_batch1.pb -o ./precision_output_vww.bin
	$(ONNSIM) $(TESTBENCH_DIR)/vww/vww_96.onnx -ctable-path $(TESTBENCH_DIR)/vww/ctable.json -input-data $(TESTBENCH_DIR)/vww/vw_coco2014_batch1.pb -o ./onnsim_output_vww.bin

clean:
	rm -rf test ctable.json onnsim.cortex_m *.bin *.txt
