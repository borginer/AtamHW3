#include <asm/desc.h>

void my_store_idt(struct desc_ptr *idtr) {
// <STUDENT FILL> - HINT: USE INLINE ASSEMBLY

// </STUDENT FILL>
}

void my_load_idt(struct desc_ptr *idtr) {
// <STUDENT FILL> - HINT: USE INLINE ASSEMBLY

// <STUDENT FILL>f
}

void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
    gate->offset_low = (unsigned long)addr & 0xffff;
    gate->offset_middle = ((unsigned long)addr >> 16) & 0xffff;
    gate->offset_high = ((unsigned long)addr >> 32) & 0xffffffff;
}

unsigned long my_get_gate_offset(gate_desc *gate) {
    unsigned long offset = 0;

    offset += gate->offset_low;
    offset += (unsigned long)gate->offset_middle << 16;
    offset += (unsigned long)gate->offset_middle << 32;

    return offset;
}
