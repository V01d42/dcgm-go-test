package main

import (
	"fmt"
	"log"

	"github.com/NVIDIA/go-dcgm/pkg/dcgm"
)

func main() {
	cleanup, err := dcgm.Init(dcgm.Embedded)
	if err != nil {
		log.Fatalf("failed to init DCGM: %v", err)
	}
	defer cleanup()

	gpus, err := dcgm.GetSupportedDevices()
	if err != nil {
		log.Fatalf("GetSupportedDevices failed: %v", err)
	}

	if len(gpus) == 0 {
		log.Println("no GPUs found by DCGM")
		return
	}

	fmt.Printf("DCGM found %d GPUs\n", len(gpus))
	for _, id := range gpus {
		info, err := dcgm.GetDeviceInfo(id)
		if err != nil {
			log.Printf("GetDeviceInfo(%d) failed: %v", id, err)
			continue
		}
		fmt.Printf("GPU %d: %+v\n", id, info)
	}
}
