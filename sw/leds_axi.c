#include <hf-risc.h>

#define LEDS_AXI_BASE			0xe4a90000
#define LEDS_AXI_STATUS			(*(volatile uint32_t *)(LEDS_AXI_BASE + 0x010))
#define LEDS_AXI_MDATA			(*(volatile uint32_t *)(LEDS_AXI_BASE + 0x030))

#define LEDS_AXI_MTREADY		(1 << 2)
#define LEDS_AXI_MTVALID		(1 << 3)



void leds_axi(uint8_t byte)
{
	LEDS_AXI_MDATA = byte;
	while (!(LEDS_AXI_STATUS & LEDS_AXI_MTREADY));
}

int main(void){
	uint8_t data = 0x01;
	
	while (1) {
		leds_axi(data);
		printf("LEDs value: %02x\n", LEDS_AXI_MDATA);
		data <<= 1;
		if (!data) data = 0x01;
		delay_ms(1000);		
	}

	return 0;
}
