(module
    ;; Imports map to second argument of instantiateStreaming
    (import "env" "memory" (memory 1))
    (import "env" "printNum" (func $printNum (param $n f32)))

    ;; Exported functions
    (func (export "return5") (result f32)
        f32.const 5
    )
    (func (export "print7")
        f32.const 7
        (call $printNum) ;; call imported function, argument is the 7 pushed above
    )
    (func (export "add") (param $x f32) (param $y f32) (result f32)
        local.get $x ;; stack = [x]
        local.get $y ;; stack = [x, y]
        f32.add      ;; stack = [ (x + y) ], this is the return value
    )
    (func (export "printMem") (param $i i32)
        local.get $i
        i32.const 4    ;; load is in byte offset
        i32.mul

        f32.load
        (call $printNum)
    )
    (func (export "addSIMD") 
        (local $result v128)

        i32.const 0  
        v128.load         ;; load 4 float values 0-3

        i32.const 16
        v128.load         ;; load 4 float values 4-7 

        f32x4.add         ;; 4 pairwise adds in single instruction
        local.set $result ;; save in local var so we can store it later

        i32.const 32      
        local.get $result
        v128.store        ;; save 4 float value at indices 8-11
    )
)