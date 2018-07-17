#include <io.h>


void LED_GPIO_Init(void)
{
#if 0
 	GPIO_InitTypeDef GPIO_InitStructure;  
  // Enable Peripheral Clocks of the devices that will be used.
  RCC_APB2PeriphClockCmd (RCC_APB2Periph_GPIOA, ENABLE ); 

  // Configure GPIO pin that LED is connected:
  GPIO_StructInit (&GPIO_InitStructure);
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_5;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
  GPIO_Init(GPIOA, &GPIO_InitStructure);
#endif 
}